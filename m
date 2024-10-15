Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4921D90DB;
	Tue, 15 Oct 2024 11:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992286; cv=none; b=drYzVBizF2FRg2OSTKDaoI1oSjrLnil39/MPXU8K+9w5h6S23dtD7K8m8Q2kpr+ikHvkJxInxLC3FIlQ0W+0Dd3dE5Fphy0NgUStITxZmL4SwK3AL8UmqIlPUxvet6vl6s0rhzCJO9JH86b/sqoyf8S+gXgTF35PTWf1VPKmCPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992286; c=relaxed/simple;
	bh=rIodb4yfC+3vgh9Fp84USS1eXYpeUY7In/gvdwNekr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G3O4KbZxaL1mVit1YL41KOklJJWix6sWnv58jZkUxk94LuvQiXXElrOOUkZLeaXD+z0rkPWvrX96d+SrP7TinI4zMrrD37z0ht0Nnp6DHKHV+Itgcy8Fr3h5NZbc4hnoJ1u+M+2nJZZApYC9wgYuXHaAXwa3wDRRdSGYGZPpm7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vKF4SHfH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vKF4SHfH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E0C2C4CEC6;
	Tue, 15 Oct 2024 11:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992286;
	bh=rIodb4yfC+3vgh9Fp84USS1eXYpeUY7In/gvdwNekr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vKF4SHfHCYiTVa8IeH3/X4O4L1gOaFMHwyYPlZ6Ekk+hlkXinNAGRUrmQEqmrADV7
	 vWN956t/ZEx1pG+w+f6Qhvin2oBrTMZvVypQ7eJ9bZIgDGB5sPeENCAUah4vQ8Up4g
	 /aqNAimjq/yTUHYdQ/Cokrp7F8KGVn4FyHrAPuJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chen <liaochen4@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 071/691] ASoC: intel: fix module autoloading
Date: Tue, 15 Oct 2024 13:20:19 +0200
Message-ID: <20241015112443.171824122@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a6fb74ba1c424..86a4c32686e73 100644
--- a/sound/soc/intel/keembay/kmb_platform.c
+++ b/sound/soc/intel/keembay/kmb_platform.c
@@ -815,6 +815,7 @@ static const struct of_device_id kmb_plat_of_match[] = {
 	{ .compatible = "intel,keembay-tdm", .data = &intel_kmb_tdm_dai},
 	{}
 };
+MODULE_DEVICE_TABLE(of, kmb_plat_of_match);
 
 static int kmb_plat_dai_probe(struct platform_device *pdev)
 {
-- 
2.43.0



