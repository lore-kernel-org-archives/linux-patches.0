Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC783217F40;
	Tue, 17 Jun 2025 16:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177977; cv=none; b=chRsiPKl0D7eCZeKjz9jTfS69DJX5GSep6wTTOwLQqrSCVsIGfY/+kGnZfaet+Xqlgc1L8Xn3K72foVyD5QaDf+6rmKerO9uJjr3wdz6JcjyZRJGHzUbdmfTYV7YGGFv6aEYA9s6PfeAiqKPxoSMXhaQAr5ms6cbVpyy/gYfBHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177977; c=relaxed/simple;
	bh=C+oBOtgzENwIw+whEpnfKoBI5yAGSU3SJyHkVSjHeow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NGXL8LKlBm41jDqbLNiyRoWT08ICvT+L2eO1IXktQ8kVuF8PTPNePDAeOh6/6SRfo9wB/lejTehhqAleir0Cj2w5fidMoZyakyXPd7c1+EULdlROTYYfb2np1te89u0KICYs8fMt6pACt4HKILC48XtXuuORzqpDUMkXKlYljqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z28Twuma; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z28Twuma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0F1C4CEE3;
	Tue, 17 Jun 2025 16:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177977;
	bh=C+oBOtgzENwIw+whEpnfKoBI5yAGSU3SJyHkVSjHeow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z28TwumaRBrZSADSiPZzxE/nrsqYKg1zXmsJLHUmVrESipSx0eL5MUiKPcYKUUg3i
	 eZ/Ld3/xz+9ktf9dMEQG7T/Nd/G4STTO0XPCW101VAaSc6GaiylolXkQ3gA31cQdMD
	 Gqs/Sqs5BO27L+naLx6Wo4QBTDNIKp0US9m/eSlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 391/780] soc: qcom: smp2p: Fix fallback to qcom,ipc parse
Date: Tue, 17 Jun 2025 17:21:39 +0200
Message-ID: <20250617152507.378970312@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index a3e88ced328a9..c9199d6fbe26e 100644
--- a/drivers/soc/qcom/smp2p.c
+++ b/drivers/soc/qcom/smp2p.c
@@ -575,7 +575,7 @@ static int qcom_smp2p_probe(struct platform_device *pdev)
 	smp2p->mbox_client.knows_txdone = true;
 	smp2p->mbox_chan = mbox_request_channel(&smp2p->mbox_client, 0);
 	if (IS_ERR(smp2p->mbox_chan)) {
-		if (PTR_ERR(smp2p->mbox_chan) != -ENODEV)
+		if (PTR_ERR(smp2p->mbox_chan) != -ENOENT)
 			return PTR_ERR(smp2p->mbox_chan);
 
 		smp2p->mbox_chan = NULL;
-- 
2.39.5



