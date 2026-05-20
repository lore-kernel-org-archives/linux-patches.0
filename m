Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4612609FD;
	Wed, 20 May 2026 17:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297073; cv=none; b=epbZfKi59Vh1dZrz9K+0JNRsl8j3R9a9pQBoC3z/oc2N/6hKsikczedqtKn1sEvdAZdJYVpaULnJF4GYYomm7UBRiF9nqy5xPtua/yp2TR0epjMXZH1vkyRT5zu5qdzLmonphNqDK6jBdEt7mP6pK4q0iZcDVk+Zg5Vt5g0kQ3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297073; c=relaxed/simple;
	bh=fGc/oaVkZsfEbxIvFWV8peW04gayqmTSx+brps+ewAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=taM+AgkhJw4dcxrAfeb9ABPU9ViCHLaj0OowyZREwnbK1JnXWteLIg5TbALFCg5swuii6b7qkePhmOMIPzNu14rPClrH2EGeEnnYbe/IAmCI8TVdG1Z/tnFAk5EnVWb/jh3ara1GZPTOsMZ6Q9JO97XKjzIj3KsBnAajk4RK0TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ecU6fDSP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ecU6fDSP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2184D1F000E9;
	Wed, 20 May 2026 17:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297072;
	bh=PzoXLjbiT7Kn3GOKo5emj5AoK3XAFMIpzZjBbJE/rMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ecU6fDSPmfe8o2PNjlwNCoVkpgCkOMsxaFRGu/N2BGeubUFoULGJCTMIZzucHrjkV
	 ToXoDGgjGKJPYQlMJfVbdcRaJZuviDsvA2fXuQYy2i4w7XUPT3aPMbu+2eBHufjuWq
	 kZ1skZEGlPvde9Yz9lA318aTCTNsaCGO/Sqj6cIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 1003/1146] drm/amd/display: Allow DCE link encoder without AUX registers
Date: Wed, 20 May 2026 18:20:53 +0200
Message-ID: <20260520162210.932207389@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit ac27e3f99035f132f23bc0409d0e57f11f054c70 ]

Allow constructing the DCE link encoder without DDC,
which means the AUX registers array will be NULL.

This is necessary to support embedded connectors without DDC.

Fixes: 4562236b3bc0 ("drm/amd/dc: Add dc display driver (v2)")
Link: https://gitlab.freedesktop.org/drm/amd/-/work_items/5192
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 87f30b101af62590faf6020d106da07efdda199b)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c b/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c
index 2ba3d3a3aac58..d2b36cfb28c3d 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c
@@ -1071,7 +1071,9 @@ void dce110_link_encoder_hw_init(
 		ASSERT(result == BP_RESULT_OK);
 
 	}
-	aux_initialize(enc110);
+
+	if (enc110->aux_regs)
+		aux_initialize(enc110);
 
 	/* reinitialize HPD.
 	 * hpd_initialize() will pass DIG_FE id to HW context.
-- 
2.53.0



