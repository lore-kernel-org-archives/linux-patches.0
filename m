Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4171A1F75B6;
	Tue,  3 Dec 2024 15:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240901; cv=none; b=b4hEC8WltyGbPBsom0OB/101I9xlB6usibMKBRFh1+tlJx31y9RFLCNeO5K3x//a2/qtJpUOPLoAJnJO0/fUcMkn2NEsqg4On10nOQAXLbT6hJTZjUowlOer7nB0IpLxOmyGJDGo2Z03EFrzB+HtElAMIAKPdnsFssGr+m5Z+KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240901; c=relaxed/simple;
	bh=uRCCnifIJFYXHFqDS0f1YkM6s9q5/Jp1mEaXXskG0mQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M44gqUM9ofb56Gpibx75Xcdqwr+Y6A738gkfVQyqytmzPFBzk0OSxQHPDK9vChh1C4WBikYBkLwa6vKUgmT/Ht5jQ1IRvXbXnNAQBZVS3YNQsNDSfK5ooavlI3gi9ke8RC2h3up1SWim43mp5w18h7ZAUHqrrP5hrcaQgFOAd7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ifWxlS6Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ifWxlS6Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73222C4CECF;
	Tue,  3 Dec 2024 15:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240901;
	bh=uRCCnifIJFYXHFqDS0f1YkM6s9q5/Jp1mEaXXskG0mQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ifWxlS6Z6gvlaeEe9CEXFuM7URWZApcKFVgWv9Caz4ULtKCVaiuC3nGEOM80Nge04
	 eGLUz6LNXiEE48azDuAncUawrh9KY4SvfOcuQF2Du0F1WyoeU6hIw4L3DvMN0QLAay
	 bVQl00m+i6/sAhVSYP7FzElA0MeBZpCfVXb1eYbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 241/826] drm/vc4: Correct generation check in vc4_hvs_lut_load
Date: Tue,  3 Dec 2024 15:39:28 +0100
Message-ID: <20241203144753.167018433@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit 42aa18d1c3e7762bcebd89a5857ed7774e669d92 ]

Commit 24c5ed3ddf27 ("drm/vc4: Introduce generation number enum")
incorrectly swapped a check of hvs->vc4->is_vc5 to
hvs->vc4->gen == VC4_GEN_4 in vc4_hvs_lut_load, hence breaking
loading the gamma look up table on Pi0-3.

Correct that conditional.

Fixes: 24c5ed3ddf27 ("drm/vc4: Introduce generation number enum")
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Closes: https://lore.kernel.org/dri-devel/37051126-3921-4afe-a936-5f828bff5752@samsung.com/
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241008-drm-vc4-fixes-v1-3-9d0396ca9f42@raspberrypi.com
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hvs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hvs.c b/drivers/gpu/drm/vc4/vc4_hvs.c
index f30022a360a8a..863539e1f7e04 100644
--- a/drivers/gpu/drm/vc4/vc4_hvs.c
+++ b/drivers/gpu/drm/vc4/vc4_hvs.c
@@ -224,7 +224,7 @@ static void vc4_hvs_lut_load(struct vc4_hvs *hvs,
 	if (!drm_dev_enter(drm, &idx))
 		return;
 
-	if (hvs->vc4->gen == VC4_GEN_4)
+	if (hvs->vc4->gen != VC4_GEN_4)
 		goto exit;
 
 	/* The LUT memory is laid out with each HVS channel in order,
-- 
2.43.0



