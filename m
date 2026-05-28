Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4AEE335566;
	Thu, 28 May 2026 20:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998999; cv=none; b=LwfHcvq6q5qGqQdhc3q+0VkkSAIbOGNCsQOT8CEVdxHUZ0xqsGf1zMb1OWsDEwMg4L8M+pFldCTC2ieOFpbAfUcKNkAhU0cFAMFOyyGSm5kyUOLOY3X8v9RNZow+wI0brPO9TFv5FxkALeDCJRAOOITQN13SZ6I+kp47TjDnL9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998999; c=relaxed/simple;
	bh=4Vsf4UphiufCRLxMPW0hyYGpecQlKWZg2BF/EIp6wlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RdxPLOAK86spX9SwYGavh473oPWqxHc0yQdydKEcFWcYFkwak6SBE4ePP9fzMyccjOWwp1BipHGyiq5dp7dCMCywLACg8CRcgxoYBjqGkVXqX74VMx0FU7Aaeq2aQyEc5S860bm6UkeV2E3dTpRDv0UVsLM51StBun8B3GtEvSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fJ0qsaMf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fJ0qsaMf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EDAF1F000E9;
	Thu, 28 May 2026 20:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998998;
	bh=N8LuV9eLHFkgv8vJaVzwFNToqf/sdZrItzG/NST2mpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fJ0qsaMffan0kZ5wzkf8ykW8cJIXcJ35bKYiEwGnZUX0pIBjoO2Bx1yrFwRVRkkj6
	 R2CKMz+RX+0Qi8fhoFtnG73bMljej5uR05BYYXnpupgoyzlfeRDhcrQ33Et3+ApGiG
	 19CF5NgM0qBjrqqVYYJy4mWu17pLng99JcRWUoQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 372/461] drm/mediatek: mtk_hdmi_ddc: Fix non-static global variable
Date: Thu, 28 May 2026 21:48:21 +0200
Message-ID: <20260528194658.214210384@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>

[ Upstream commit 87ed4e845d5a90bba1a56c0a5c580a13982e8648 ]

The struct 'mtk_hdmi_ddc_driver' is not used outside of the
mtk_hdmi_ddc.c file, so make it static to silence sparse warning:
```
drivers/gpu/drm/mediatek/mtk_hdmi_ddc.c:331:24: sparse: warning: symbol
  'mtk_hdmi_ddc_driver' was not declared. Should it be static?
```

Fixes: c241118b6216 ("drm/mediatek: mtk_hdmi_ddc: Switch to register as module_platform_driver")
Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20260429-mediatek-drm-fix-sparse-warnings-v1-4-d95c4d118b83@collabora.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_hdmi_ddc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_hdmi_ddc.c b/drivers/gpu/drm/mediatek/mtk_hdmi_ddc.c
index 6358e1af69b49..2acbdb025d893 100644
--- a/drivers/gpu/drm/mediatek/mtk_hdmi_ddc.c
+++ b/drivers/gpu/drm/mediatek/mtk_hdmi_ddc.c
@@ -328,7 +328,7 @@ static const struct of_device_id mtk_hdmi_ddc_match[] = {
 };
 MODULE_DEVICE_TABLE(of, mtk_hdmi_ddc_match);
 
-struct platform_driver mtk_hdmi_ddc_driver = {
+static struct platform_driver mtk_hdmi_ddc_driver = {
 	.probe = mtk_hdmi_ddc_probe,
 	.remove = mtk_hdmi_ddc_remove,
 	.driver = {
-- 
2.53.0



