Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A6D3CF42;
	Wed, 21 Feb 2024 14:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525421; cv=none; b=DP9tYVIuJI0haV0ogRd591oYMcEWRz57W01AUNPAzHoH2jXgXriu5gn2+oaCmm8Ef7vuzOGg7JZAeCns7mxE04PqmbAYGf/0YO0ubd2x6sDKI4BcDEppDogCieeGIUei8BIqXOBB8StuQWoxz6xHcVNMTx8UQwnCoXY1VFLrws4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525421; c=relaxed/simple;
	bh=JOmUEpC76kRk8feLwMx2ExZraHxvQ4C/zaDDdGYAIqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GOAPbg/u7CTovEWZqhVQypLoHUM5cU1XJL0+dOSGoMcV3+UtxExZxvKGbwWUVsF82oJ3QDQbsiBeQlcMW0PnOifpjCbw1XMBfjQn7raWVOPkYWKQ8KH2J2c1tP5ITg2/WO7d5XskJXsxUS8SXbG5Usazne1PSgODmekFqW5BkSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K06Qvha5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K06Qvha5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B42AC433F1;
	Wed, 21 Feb 2024 14:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525421;
	bh=JOmUEpC76kRk8feLwMx2ExZraHxvQ4C/zaDDdGYAIqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K06Qvha5ktqmiy/XZ+By6dwOkJCfj+FELxYF+HAtshbk6PrYejp1SzVv9ptsTfpS4
	 NWsSqqQam23/+F1JOpaMPj2h6S2bU3QaSmGAzxZuMmhrO0M5MpugeUhhmUvRxriS++
	 YEA0iQy9g63r7Khr37xzwB0mGA7h1wVWcaycVbBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 133/267] media: ddbridge: fix an error code problem in ddb_probe
Date: Wed, 21 Feb 2024 14:07:54 +0100
Message-ID: <20240221125944.223285721@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

From: Su Hui <suhui@nfschina.com>

[ Upstream commit 09b4195021be69af1e1936cca995712a6d0f2562 ]

Error code is assigned to 'stat', return 'stat' rather than '-1'.

Signed-off-by: Su Hui <suhui@nfschina.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/ddbridge/ddbridge-main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-main.c b/drivers/media/pci/ddbridge/ddbridge-main.c
index 03dc9924fa2c..bb7fb6402d6e 100644
--- a/drivers/media/pci/ddbridge/ddbridge-main.c
+++ b/drivers/media/pci/ddbridge/ddbridge-main.c
@@ -247,7 +247,7 @@ static int ddb_probe(struct pci_dev *pdev,
 	ddb_unmap(dev);
 	pci_set_drvdata(pdev, NULL);
 	pci_disable_device(pdev);
-	return -1;
+	return stat;
 }
 
 /****************************************************************************/
-- 
2.43.0



