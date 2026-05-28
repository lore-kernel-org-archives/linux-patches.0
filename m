Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D8A3164B7;
	Thu, 28 May 2026 20:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998988; cv=none; b=ThbNKOOwOE2pFJnF1Rn5mKPxsuZi6n4fNa9eEqtkxymf2wAxhJ1xVqGxIy22P549GFQX6IkDy+Locb80QmrgkphwiFj8yMB1Bx46syjQ7d73CNsLiZLXyD3m2Ow6AaO+AbuyxCDE4xqLLrXxK0tTkCcvAUsHmrtJocVDuNsksD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998988; c=relaxed/simple;
	bh=TMbdCusWUsKppDqOQsry35dtvvXhWBNNBfcsyvqAJ50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p9O3rlvx6zSSOBnv8Q+LW4E3Gjh3ePEwCfgOE2DhPsebWXAu1E5wO0Xm924bvjGBev69pyqLYN2IbWWwfMYPRCUHp/4HRV4rHEEX847D9D4KGnMzaaDX21zi5QePXSoPw/HLNfOhAfwoiKx3gDsvz7vLCdbkHy0cFbRzP59+2AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0nzFk0gB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0nzFk0gB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFE9A1F000E9;
	Thu, 28 May 2026 20:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998987;
	bh=NVAPszidtrQ3lwR7g8+9gmPobEyc3tNbcdhEnUJY6Y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0nzFk0gByg0B/7FFgiapMC+D2sqn3XkD3/GxtYCRx1jWh6v4jKvR1PCVBE1KuOdj8
	 4Lx4t5zzVhWceoLBTuAlC0BgmU67L7PE7rNcOkypR43c3Qn9P2Ds1EhWgHi9X+4yUs
	 lFGQJQLVjz3UznPfDr5PIuSpmB7TiKEC152Wf2+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 369/461] drm/mediatek: mtk_hdmi_ddc_v2: Fix non-static global variable
Date: Thu, 28 May 2026 21:48:18 +0200
Message-ID: <20260528194658.124499043@linuxfoundation.org>
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

[ Upstream commit e9f5e8da29762df1111a58ae0b4a83091595d834 ]

The struct 'mtk_hdmi_ddc_v2_driver' is not used outside of the
mtk_hdmi_ddc_v2.c file, so make it static to silence sparse warning:
```
drivers/gpu/drm/mediatek/mtk_hdmi_ddc_v2.c:392:24: sparse: warning:
  symbol 'mtk_hdmi_ddc_v2_driver' was not declared. Should it be
  static?
```

Fixes: 8d0f79886273 ("drm/mediatek: Introduce HDMI/DDC v2 for MT8195/MT8188")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202604132044.fcYjEcU8-lkp@intel.com/
Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20260429-mediatek-drm-fix-sparse-warnings-v1-1-d95c4d118b83@collabora.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_hdmi_ddc_v2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_hdmi_ddc_v2.c b/drivers/gpu/drm/mediatek/mtk_hdmi_ddc_v2.c
index d937219fdb7ee..31e81a6de6d85 100644
--- a/drivers/gpu/drm/mediatek/mtk_hdmi_ddc_v2.c
+++ b/drivers/gpu/drm/mediatek/mtk_hdmi_ddc_v2.c
@@ -389,7 +389,7 @@ static const struct of_device_id mtk_hdmi_ddc_v2_match[] = {
 };
 MODULE_DEVICE_TABLE(of, mtk_hdmi_ddc_v2_match);
 
-struct platform_driver mtk_hdmi_ddc_v2_driver = {
+static struct platform_driver mtk_hdmi_ddc_v2_driver = {
 	.probe = mtk_hdmi_ddc_v2_probe,
 	.driver = {
 		.name = "mediatek-hdmi-ddc-v2",
-- 
2.53.0



