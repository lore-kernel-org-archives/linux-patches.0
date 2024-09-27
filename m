Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4064A17B515;
	Fri, 27 Sep 2024 12:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440156; cv=none; b=V9REZ1Wx6Kdek8naf+pIo9JWFCg71jyaos98T1cE82WBiMerqyIngRYJMuYTFOxneWeeeqO0K+mrA7qabnlgO5/9PNNBUQxtR7+BZxYQlOJ6LpAhC3lhBh9L3yR9wAvdpoFfFJBobZAZOgMYKDAY3pmOe2Zs8R2w/i2yMBmMw9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440156; c=relaxed/simple;
	bh=qsTlhjyJ9s1xmZPrlBMTzjd21JAVnsU1tR0ygn1pogo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dM8yuqG8cahvfoejF4YLog/jCUYaTpHHhD9HN2T8llcoLpRq88/sn8gptsZlrw+XAQiA/HLhC5q0LH5gKnfTrcvIK6T0pSa/Wwf0Uvof07XGlfBW4NOpxLlE+91hlLWOONRW9lFYCjyUYC+dHBlU/evgbmpwxsZ27eim93u+0TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ccj2GsEg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ccj2GsEg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1511C4CEC4;
	Fri, 27 Sep 2024 12:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440156;
	bh=qsTlhjyJ9s1xmZPrlBMTzjd21JAVnsU1tR0ygn1pogo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ccj2GsEgT/VNwrHfO5SG/jidzkk5/WqpQkNclG5MWQKI8R8FFPF6HcX+GaVo0Jonc
	 uecUZqh8jBbEziApqjrb256/VM8lNDW2Jc2JFLU8scYHfDtAjPMruSWqkeLZYj8/A2
	 /C57y0Owk1GFm+WfwoZqCli7XZlKjGEPHXOGsaRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chen <liaochen4@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 26/58] ASoC: intel: fix module autoloading
Date: Fri, 27 Sep 2024 14:23:28 +0200
Message-ID: <20240927121719.864725242@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121718.789211866@linuxfoundation.org>
References: <20240927121718.789211866@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liao Chen <liaochen4@huawei.com>

[ Upstream commit ae61a3391088d29aa8605c9f2db84295ab993a49 ]

Add MODULE_DEVICE_TABLE(), so modules could be properly autoloaded
based on the alias from of_device_id table.

Signed-off-by: Liao Chen <liaochen4@huawei.com>
Link: https://patch.msgid.link/20240826084924.368387-2-liaochen4@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/keembay/kmb_platform.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/intel/keembay/kmb_platform.c b/sound/soc/intel/keembay/kmb_platform.c
index 37ea2e1d2e922..aa5de167e7909 100644
--- a/sound/soc/intel/keembay/kmb_platform.c
+++ b/sound/soc/intel/keembay/kmb_platform.c
@@ -814,6 +814,7 @@ static const struct of_device_id kmb_plat_of_match[] = {
 	{ .compatible = "intel,keembay-tdm", .data = &intel_kmb_tdm_dai},
 	{}
 };
+MODULE_DEVICE_TABLE(of, kmb_plat_of_match);
 
 static int kmb_plat_dai_probe(struct platform_device *pdev)
 {
-- 
2.43.0



