Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160A1188006;
	Tue, 17 Jun 2025 16:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176648; cv=none; b=HVwPefAMjMApM2ZSZPWeb/KY5BM09843xguxJIz9K4gzT2wn9h2vrK2erWtCwEX6ZVZxexhMfu1hfPMGOVZDi/cw071FL63QmKAYmabxIUwjsKcRqmK7jqQ4YDgS0IruQjmBoonL3gxoPjp0W8biEpoDlR7eMH9AO6iQ+G9TRbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176648; c=relaxed/simple;
	bh=Am/OxTCchHVBo9OX/ggCIhDeO5TqtQsSrvOK2tgOfh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RXQ0+iBei1/Cd9f61RtLXejOmTW2tqJi0vz4ARPISfBfbE8RTS/ya0BOzSQiRDZkESFWWYpEIfleNn0SopJS8Zh9uW9La9A2iFnHXbCbt/KuukI8SyHJ5wb1v/62ZRJRjvVDGxLtI2RIGeMXmntnx7LNHoz7ogTLn/KltDlHpBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aS+BnueX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aS+BnueX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E92C4CEE3;
	Tue, 17 Jun 2025 16:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176648;
	bh=Am/OxTCchHVBo9OX/ggCIhDeO5TqtQsSrvOK2tgOfh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aS+BnueX1AIKpitLeH/B0QRceIHbqDi+c3spaOEZZXKgNHxFGaio0/mtINBaq8Fs1
	 w+5rm1319I5FBJfbo6C0eX2hJxLVTR5xd3WUecQeyhecrb3QxYwwln3O8urDkFdBgg
	 AaKAzGGF6Q+rfodQuNsBo5izKNPrEs/V4YLeZQFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 250/512] soc: qcom: smp2p: Fix fallback to qcom,ipc parse
Date: Tue, 17 Jun 2025 17:23:36 +0200
Message-ID: <20250617152429.732797588@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Barnabás Czémán <barnabas.czeman@mainlining.org>

[ Upstream commit 421777a02bbd9cdabe0ae05a69ee06253150589d ]

mbox_request_channel() returning value was changed in case of error.
It uses returning value of of_parse_phandle_with_args().
It is returning with -ENOENT instead of -ENODEV when no mboxes property
exists.

Fixes: 24fdd5074b20 ("mailbox: use error ret code of of_parse_phandle_with_args()")
Signed-off-by: Barnabás Czémán <barnabas.czeman@mainlining.org>
Reviewed-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Tested-by: Stephan Gerhold <stephan.gerhold@linaro.org> # msm8939
Link: https://lore.kernel.org/r/20250421-fix-qcom-smd-v1-2-574d071d3f27@mainlining.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/smp2p.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/smp2p.c b/drivers/soc/qcom/smp2p.c
index cefcbd61c6281..95d8a8f728db5 100644
--- a/drivers/soc/qcom/smp2p.c
+++ b/drivers/soc/qcom/smp2p.c
@@ -578,7 +578,7 @@ static int qcom_smp2p_probe(struct platform_device *pdev)
 	smp2p->mbox_client.knows_txdone = true;
 	smp2p->mbox_chan = mbox_request_channel(&smp2p->mbox_client, 0);
 	if (IS_ERR(smp2p->mbox_chan)) {
-		if (PTR_ERR(smp2p->mbox_chan) != -ENODEV)
+		if (PTR_ERR(smp2p->mbox_chan) != -ENOENT)
 			return PTR_ERR(smp2p->mbox_chan);
 
 		smp2p->mbox_chan = NULL;
-- 
2.39.5



