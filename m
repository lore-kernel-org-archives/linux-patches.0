Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666F51C3318;
	Thu, 28 May 2026 20:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000149; cv=none; b=ATxJqiVN4a9GtCq/92hOhrCXSQShUJpIUNBhXcMMHsxCLVnvE2wnCymIcS0M/ZIwhOSpIWHTAWfLF8/pGL4Bk899SBhhCCgkoCBHUjIHqKM4uOlF8Ta3IGbcAVEx8CijvFw2iQUsN+as42UHdCnmBnkBABrATVjo1frLjBcDuLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000149; c=relaxed/simple;
	bh=GOve0eUp6m9ZEXADk67ExpDUF66FgzAyAJCdbSKYaR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Npl98gOuVwYKJCwW4ZnRABQS0Nwpgi2VbyfYm2YrQFjg2OY9KFv+czbvDIolPnm8kWFcfSceec0VhHmWAOBfmKq0+u2eQY3u8iw2iiGKy4UWQRvE9erRcI7T/NCLHkNQgyBRom+l/cfBUxXe+1at3tz0bjeH5xtESx77/yl8jww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jtO1Dmij; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jtO1Dmij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C28AC1F000E9;
	Thu, 28 May 2026 20:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000148;
	bh=ynhdHy4USQJma5ZWyK1mTZZxI2JIRZtiR7xfUNu4qMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jtO1Dmij+insy5v4WIH0OusmwgEy065XCDSDY/7qGgs08eclzb/AH7mWlz4bQZNwg
	 4GqRqvYDGwG9oCH5xYU5xmgUVwWoRxeRDJKIx/zyGamGqUkZnh0rsM9Xc2Rm7PoqWi
	 mgRdzwJIffiHPznZc8dgZiKQ5yB7f5jvS6zyOCpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 320/377] drm/mediatek: mtk_hdmi_ddc: Fix non-static global variable
Date: Thu, 28 May 2026 21:49:18 +0200
Message-ID: <20260528194647.664812549@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



