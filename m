Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA9E18C033;
	Fri, 27 Sep 2024 12:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440267; cv=none; b=Sq0mBwaR7P39XOHt7rY783EXLQnhm0ME43uqfibehh5Ql37LZKe88Xkbbe+6RKiLK3ExE1PWKfWIR58ZlNP21fr2s/7PD5gRIuG8D05XLWaMZhnaaGOLHxf7VzgaiuTwLttLhn8Tb6akEVY8WopMptkqQgyuuIAr5nyAcGFxc/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440267; c=relaxed/simple;
	bh=2O/08dNFA0Thmqv7wcXrqnKQW0roJT179fW63MEiymE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CY+3wmHmaJsU7zuTSYZYlsJsynkBHOPrDxNs1hJ0RN0KLs5Bgquk6G8l8wgGFIjUolrwHaN5Jzagg7A6dkho1ywUjC0ztIAPJU7R1gQotTvUo1MlQbwmyrfEmTycIh141yF02J0Eog30RTdvCFdfHd7M3bEcm5LJwNCASw3D5JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rs9NRb8L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rs9NRb8L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC08C4CEC4;
	Fri, 27 Sep 2024 12:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440267;
	bh=2O/08dNFA0Thmqv7wcXrqnKQW0roJT179fW63MEiymE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rs9NRb8LLxSE/maPTsAtQT/+JFKHGAMxUuteLfKW6pDNyPbSy3JeAbdWpPLdL5D8S
	 VNtyWrY1IUuKwDFDz26v+OPpgVPATKdZUVvMd2/S/+MZhRch3+KLwSQEI/8JhwtXKu
	 s7yfklsvLTnCJ+wsBhpfYhrjzChL2WxVLJysqzVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chen <liaochen4@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 21/73] ASoC: tda7419: fix module autoloading
Date: Fri, 27 Sep 2024 14:23:32 +0200
Message-ID: <20240927121720.740882751@linuxfoundation.org>
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
index d964e5207569c..6010df2994c7b 100644
--- a/sound/soc/codecs/tda7419.c
+++ b/sound/soc/codecs/tda7419.c
@@ -623,6 +623,7 @@ static const struct of_device_id tda7419_of_match[] = {
 	{ .compatible = "st,tda7419" },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, tda7419_of_match);
 
 static struct i2c_driver tda7419_driver = {
 	.driver = {
-- 
2.43.0



