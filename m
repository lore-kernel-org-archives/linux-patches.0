Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B03B18C038;
	Fri, 27 Sep 2024 12:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440265; cv=none; b=MG0M+YBxzP4uoXxosF/6j9HDwzOdRXGgQI/gtCtWPcLLo8zHOZQbOEZgFuDmo7kqJdwh2g2Ggh7HeCd3fnoKWBFr0DjMJ24bHSrovNnAHynZhWqkbIwvk1uOgkMPqZ9cJJWHyNa8QCYlJ1IGmsX7Zyx4GUUTMls8wCn1bt1ywfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440265; c=relaxed/simple;
	bh=gyTBFaqqGsAIoAYchWxIGyyz4eKsJtGk3kclJQV3hVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=frlUHtRIt37Cf1Fdwum01ECWdjHlqaup9eg6HdrAm9g9OgdpR05f7Lz/najkIPCK9KpMjCekp7T9rN4DRXvKFvktZumh5VfnKx+eFhJBoEmFWjiy5FJK7XHeq4gc16ZS/5Wpk06avXH5OFOP55Z97ABYBvJ/14biEXu2FksUnjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W8/zn6xD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W8/zn6xD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD40C4CEC4;
	Fri, 27 Sep 2024 12:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440265;
	bh=gyTBFaqqGsAIoAYchWxIGyyz4eKsJtGk3kclJQV3hVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W8/zn6xDKnCLqyp+M1vhrcoRZwTWa1LwXCLy04jNEcFYsrSvAyiv6QLGd67tQ/rpG
	 fFJ2DOVIz/qZqyjPNrEDACfjl1OAKBQFIRsj/gvKryXXUXLw1koW2XJJrRb2T6qmFu
	 3PdlHyCGRBrpmJxk8iFzpwmRvApkEfFdcwTQJzV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chen <liaochen4@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 20/73] ASoC: intel: fix module autoloading
Date: Fri, 27 Sep 2024 14:23:31 +0200
Message-ID: <20240927121720.707201138@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
References: <20240927121719.897851549@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b4893365d01d5..d5c48bed7a250 100644
--- a/sound/soc/intel/keembay/kmb_platform.c
+++ b/sound/soc/intel/keembay/kmb_platform.c
@@ -817,6 +817,7 @@ static const struct of_device_id kmb_plat_of_match[] = {
 	{ .compatible = "intel,keembay-tdm", .data = &intel_kmb_tdm_dai},
 	{}
 };
+MODULE_DEVICE_TABLE(of, kmb_plat_of_match);
 
 static int kmb_plat_dai_probe(struct platform_device *pdev)
 {
-- 
2.43.0



