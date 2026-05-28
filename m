Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97213164B7;
	Thu, 28 May 2026 20:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998997; cv=none; b=utfHrDda7AEmF0YRtDqKD489lcEmeeaeGyQXl6jSLzU8nInLNUvpKJe+T2wXK5kFgGDiV2S2vYb/TktLzjg6suROT3ISn80tckQANXN4+v/G69NLb3rT+XmX1sIWDfHmWUX/WDgvUwPb3bL0dzKf6XqkhMmSJxzFwEoMu8RDvLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998997; c=relaxed/simple;
	bh=LaKsY1Jl8DjoZKOjBfYIBwW2QGLJ9rXEQJakCmqgnVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I2g9jgwxDf7GsZX5o6Ny5wPi12iWqfiwTBj1VSbhiSjcuw8+dk+dwvm7lYhzo8x0v8hi5Vn25VFgDL1/FfIj11U2AUcNpaDWPHp0i6dFwoVU/T0WxEnSsfaRk4bbstj+G5LPSXC6h5bV46g09tag6IFExuc/MUwCLIGiE85mi/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=meU3jdpr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="meU3jdpr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B08B1F000E9;
	Thu, 28 May 2026 20:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998995;
	bh=05B9p2AVnlMuMGMfI8Kn8tOqMRMowhA1IYgXQ67Oakc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=meU3jdpr06sux0P6J+HWspxSuYnWP5RC7VaFMCM7Pd1EFSc0avp/txsB/uwVBqJFj
	 HGxeNw4BBlokMAEgN8CPOtMwKCL+Red5lEgQKww7cpaDgP/Dpq4TAAOcACZrm2hcig
	 atvii/wvN2nnPvnloq8X7gRyGw6tYuZorICOD10A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 371/461] drm/mediatek: mtk_cec: Fix non-static global variable
Date: Thu, 28 May 2026 21:48:20 +0200
Message-ID: <20260528194658.184906587@linuxfoundation.org>
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

[ Upstream commit 571f00a5fb725984049bd532ee8193cc34ff2994 ]

The struct 'mtk_cec_driver' is not used outside of the
mtk_cec.c file, so make it static to silence sparse warning:
```
drivers/gpu/drm/mediatek/mtk_cec.c:243:24: sparse: warning: symbol
'mtk_cec_driver' was not declared. Should it be static?
```

Fixes: 1e914a89ab7e ("drm/mediatek: mtk_cec: Switch to register as module_platform_driver")
Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20260429-mediatek-drm-fix-sparse-warnings-v1-3-d95c4d118b83@collabora.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_cec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_cec.c b/drivers/gpu/drm/mediatek/mtk_cec.c
index c7be530ca041f..b8ccd6e55bedb 100644
--- a/drivers/gpu/drm/mediatek/mtk_cec.c
+++ b/drivers/gpu/drm/mediatek/mtk_cec.c
@@ -240,7 +240,7 @@ static const struct of_device_id mtk_cec_of_ids[] = {
 };
 MODULE_DEVICE_TABLE(of, mtk_cec_of_ids);
 
-struct platform_driver mtk_cec_driver = {
+static struct platform_driver mtk_cec_driver = {
 	.probe = mtk_cec_probe,
 	.remove = mtk_cec_remove,
 	.driver = {
-- 
2.53.0



