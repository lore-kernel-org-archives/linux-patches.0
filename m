Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D501AF0BB;
	Tue, 15 Oct 2024 12:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728996919; cv=none; b=Yh97AzG18ixFhgfqkbYaRSC7rLKzl/3Iyp+QQDSuaqIzKcivWefCAcAoBDS6Qcug1ZvE+8sn3qGSw9e9fmestj+UNrf4BTV++a4jiznqtRzTLqYnXRN8wo0OpUM1p+4QIh+tS54c8ipM1BFW/gn/ZGYqShMs53FigcG5SODtKZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728996919; c=relaxed/simple;
	bh=K7srZxwPCRJBRF7W9eajl7ExhJT8ZHvDVxQZr6RU2xY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MR9Fxkbe0HQcOsRvBvZiF/2nD+gFVpk6Qqwtap1z4pkH7980UfXp5uf1grw5+giVL6mPeAudb/GpRuhS9utvjNklUbv0fM/8IWxsYaRu3jw7kMwMuQdoNPZdLQ439xdDYTlwlanasMWRTMAxj2pp2UqnlVBOgaSdAj2t4NP8zXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ps0DGaqw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ps0DGaqw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 194C1C4CED0;
	Tue, 15 Oct 2024 12:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728996919;
	bh=K7srZxwPCRJBRF7W9eajl7ExhJT8ZHvDVxQZr6RU2xY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ps0DGaqw3wuRyYOcmo2eDRGMguW65QRZm7uROWbt4stUx7Z+aZY4bBJkYCFl2oJAY
	 mOo5Dc286xtzPrQToYekhsX6da4Qgs+Bs78Cyi1nuvcB5ky+/4yy7C4Lx/AAOu3N/1
	 oL4O7llPvPbMgFNO+ErjW/SCjdavOeIlEoEtkWoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chen <liaochen4@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 038/518] ASoC: tda7419: fix module autoloading
Date: Tue, 15 Oct 2024 14:39:02 +0200
Message-ID: <20241015123918.474378203@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 83d220054c96f..9183db51547d3 100644
--- a/sound/soc/codecs/tda7419.c
+++ b/sound/soc/codecs/tda7419.c
@@ -624,6 +624,7 @@ static const struct of_device_id tda7419_of_match[] = {
 	{ .compatible = "st,tda7419" },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, tda7419_of_match);
 
 static struct i2c_driver tda7419_driver = {
 	.driver = {
-- 
2.43.0



