Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E432318FDBD;
	Sat, 30 May 2026 18:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166864; cv=none; b=rQ1le+e0v3jsnTaRFlzq3YazqqznglF+K1Gm4caDJr6HA/YizWquuA1NLNvO3eLATUsCDBVa1Z8gFIpojzaqFHqCF81vf+ZHVBvp3pcKU4AN5OUUbRWXpGo9nfqMquGK2pxcoJvv0zElXu1uh8ivBNCLsv2+DdcZ7B8AGhgKkTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166864; c=relaxed/simple;
	bh=RNNRmwe6ucmmLt3hz+fhT0wBc24gOi0xtAa6P2MoXu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rVEHfO2DXSrpo3xDc11P5+BcCR/zHlLfKnxX8bivzQabWe/kxm1wG/1KyiVYNh4vUcw9FG2+rYxR8KJDv7iasWQQ9nF/oD59YOtEVi/F6sqODttHQVy6DL+7+1M6LhcmVFNBqKaaSk9deywm+vJGBI8zIn/nYmC0M5cSNOXKL14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tjZXhN03; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tjZXhN03"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3506B1F00893;
	Sat, 30 May 2026 18:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166863;
	bh=v4VY3YUDadFKcO47Rt9wgDmW6rz/xKUIZfcHYrk3AVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tjZXhN03i+zI9sr50nN5kVlnRS2LVEzPWkCH11Lfo0VBqpCerp/CiHN5jra5c2pUU
	 gU5ZHIMmODr2844EJBB5mOGs2HCwChvWGgaUHjvs9S9dc1nqH/WTmYqYbJfvrLQDri
	 BSIAilHdukL+JNG0O8T6atuUQY1IxH/le1Z87thw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 494/589] drm/amd/display: Allow DCE link encoder without AUX registers
Date: Sat, 30 May 2026 18:06:15 +0200
Message-ID: <20260530160237.609486251@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 48bc459009547..f9d30fcfd052c 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c
@@ -994,7 +994,9 @@ void dce110_link_encoder_hw_init(
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



