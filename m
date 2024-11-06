Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6191FCF52;
	Wed,  6 Nov 2024 12:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897794; cv=none; b=E3nIOpep72L/SUdLKijYdlDcLc1a6hjQ1ga5vNhXDUFaxt/lVIyLUCECFO+kC/C92UmP3SArWGIpJSpeUkY2TGu54BhMTRncV8RydFzwQC38A7VDf6ubm3a9Ab4dBBitn7KomSL1sEgpFiKg/U1ruD/vEot8/IIjKJsrAslssX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897794; c=relaxed/simple;
	bh=3ZwMqtFCyNEIxbwA4UmJyDiDoVYYNG8dskjGVMC5Ego=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cGMDlGzgF2u53nDV6f5I0GoLiarJKcVhbjqlSIkBFC4eeMGPjh/Hw2Akm8tegqzHtXAQ6crRkzPOkgzbvx37GS/brUtJZ2eFFDQO27/4XesMkv+kdybGFTq7+uWHbrcmX3ZHp40c0WqUTHuFhh2Qa8DDbCqxRZR9Pvl94b6pGpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HhdJy4t8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HhdJy4t8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1086CC4CECD;
	Wed,  6 Nov 2024 12:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897794;
	bh=3ZwMqtFCyNEIxbwA4UmJyDiDoVYYNG8dskjGVMC5Ego=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HhdJy4t8tPBMw9ORfwviIPe+b863KpTPsG7J4oFE9hT+KuXZN57fnLuACrLvzPgFe
	 x+4OFAVGWax3J6mT/Uem3zKn9AoiY6rBQ4uDHc1kP55coHl7DFGlWxxyh/biSKAf7e
	 mJnW2aAxN1FlZrBDEnbcHM26L6W6W4EMUM4u/sBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chen <liaochen4@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 021/462] ASoC: tda7419: fix module autoloading
Date: Wed,  6 Nov 2024 12:58:34 +0100
Message-ID: <20241106120332.033859492@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liao Chen <liaochen4@huawei.com>

[ Upstream commit 934b44589da9aa300201a00fe139c5c54f421563 ]

Add MODULE_DEVICE_TABLE(), so modules could be properly autoloaded
based on the alias from of_device_id table.

Signed-off-by: Liao Chen <liaochen4@huawei.com>
Link: https://patch.msgid.link/20240826084924.368387-4-liaochen4@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tda7419.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/tda7419.c b/sound/soc/codecs/tda7419.c
index 2bf4f5e8af275..9d8753b28e36e 100644
--- a/sound/soc/codecs/tda7419.c
+++ b/sound/soc/codecs/tda7419.c
@@ -629,6 +629,7 @@ static const struct of_device_id tda7419_of_match[] = {
 	{ .compatible = "st,tda7419" },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, tda7419_of_match);
 
 static struct i2c_driver tda7419_driver = {
 	.driver = {
-- 
2.43.0



