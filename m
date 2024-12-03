Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1431E3DF9;
	Tue,  3 Dec 2024 15:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238416; cv=none; b=SmKoXpYxXZmGJAxjUe1l4LDPiOlw/sQUNcHw1/gt5wrHLPmtvJGwMG2PgPuifbxlzYVy/ZyqBCoqHe6jn5uCkd7H/iGsTT46QltCQ8izbxE4QbLZ92fQIGoLN+d1nT4VsS4wrO/57SWAczyw4LHd1bSQ1feU9M/1kVmzZEExxaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238416; c=relaxed/simple;
	bh=qy84lbqVdGFSc8dZ4N6yvF99HwNGfUVn9Qqd7ScXduk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G+G3jX5CcHYS9KiGBzjfPruNZVVIli4f6gnxqsV3FqTLwe5G19WRy7K3Jxc9VmMsvyWWYThHhQYYmKdcgKsjG3gNCbOgD9y7TUPP9R9CWV8YzujKDNAI9I4LrrctVxGwesqepM0ex5xebQipgZXhPF2d22PwgdIQ84wm83xXChY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wEGHYeRH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wEGHYeRH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A9C9C4CECF;
	Tue,  3 Dec 2024 15:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238415;
	bh=qy84lbqVdGFSc8dZ4N6yvF99HwNGfUVn9Qqd7ScXduk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wEGHYeRHryp+I+X164xYGmyuuTTFxVCF5NmlTT2h6vFpUpVJjT609hVybbSyVDufo
	 FW7W+Ew/oAWCknnLdLsmGyTOgMhYqUqKseyvdq/KR5R2CZ9FOCVnFlh1Oys22jq0z9
	 r/1ToutxHQOXuIbVao7Fef0TwU/oAzrMtkq2pJFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 268/817] drm/vc4: Match drm_dev_enter and exit calls in vc4_hvs_lut_load
Date: Tue,  3 Dec 2024 15:37:20 +0100
Message-ID: <20241203144006.254895935@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit cf1c87d978d47339a39bfa7a6133ecd3f8f87525 ]

Commit 52efe364d196 ("drm/vc4: hvs: Don't write gamma luts on 2711")
added a return path to vc4_hvs_lut_load that had called
drm_dev_enter, but not drm_dev_exit.

Ensure we call drm_dev_exit.

Fixes: 52efe364d196 ("drm/vc4: hvs: Don't write gamma luts on 2711")
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Closes: https://lore.kernel.org/dri-devel/37051126-3921-4afe-a936-5f828bff5752@samsung.com/
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241008-drm-vc4-fixes-v1-1-9d0396ca9f42@raspberrypi.com
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hvs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hvs.c b/drivers/gpu/drm/vc4/vc4_hvs.c
index 64d2410b4b860..ad2d8f6f1e9ef 100644
--- a/drivers/gpu/drm/vc4/vc4_hvs.c
+++ b/drivers/gpu/drm/vc4/vc4_hvs.c
@@ -225,7 +225,7 @@ static void vc4_hvs_lut_load(struct vc4_hvs *hvs,
 		return;
 
 	if (hvs->vc4->gen == VC4_GEN_4)
-		return;
+		goto exit;
 
 	/* The LUT memory is laid out with each HVS channel in order,
 	 * each of which takes 256 writes for R, 256 for G, then 256
@@ -242,6 +242,7 @@ static void vc4_hvs_lut_load(struct vc4_hvs *hvs,
 	for (i = 0; i < crtc->gamma_size; i++)
 		HVS_WRITE(SCALER_GAMDATA, vc4_crtc->lut_b[i]);
 
+exit:
 	drm_dev_exit(idx);
 }
 
-- 
2.43.0



