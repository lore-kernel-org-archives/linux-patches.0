Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203CF3AB26B;
	Sat, 30 May 2026 18:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164722; cv=none; b=PeM0yuY6Us07w9F9gUl83vBCD9pKIrhFamI+SHnChNdO703WZPX/6Ght/iNAT4zuHJnwf6P8Pxll7KILlReCoM5aRqfCPoTqAuLtFX1tNYZELx7SLX9upskgJNl0WtLl0qEQMpUafcmznmaHrPPK8gt6j8kjKMVPUwS/R1eZlWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164722; c=relaxed/simple;
	bh=Jtc1Cu7FchgVnEFFDRtzM1XVO2YMysjLJOJPHGh/Sz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GHDlEtBehm4E/18ZK3LezQXgf2R5FhOlq3edCOoT94Fok/5PDvh0cxr+36TdCz1yYUh9sAqHoLYiSEEE36Kl/6G8I/6bKJTsvM905B6IU2TjSQTFfBxd9ZUUd7Jd4ynAqhB2NJzswwHjFuaCx+ofzwj9u2jQq7LqSq7GQO0T8IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pMyhNRi5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pMyhNRi5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C74A1F00893;
	Sat, 30 May 2026 18:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164721;
	bh=QLVMT4IuOB5reX73u3odzLG+dqkFE65nAzpVLlQkuQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pMyhNRi5qxdz4MMqHcASTCeUj7ZPfBQYw4TlPXz2nILqhEZugwwWiAV4WoJIZxaEx
	 Nvn4YpuppTWXVm4YQC3OaVSsjtJ531oSfy92iyTAImvCVc3sjsTG6mFb7WQ2eR+Qs/
	 +elJqNT8XBuwcW3NF4VEBl22OZ7voJqtA2b1vit4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 639/776] drm/amd/display: Allow DCE link encoder without AUX registers
Date: Sat, 30 May 2026 18:05:53 +0200
Message-ID: <20260530160256.468638809@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index fce0c5d72c1a0..55c367cf72ffd 100644
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



