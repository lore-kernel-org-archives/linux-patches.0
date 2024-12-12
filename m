Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E858A213E6F;
	Thu, 12 Dec 2024 17:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024925; cv=none; b=f2nr6+6fSk0E9VosILrAnKvIiAcACmbCfUYbLf8zqRXXxPPdFxFy1vbIsl+w2NxdmssRQwS4EarjHMujeN3zZjtQ28w7uPs5A77rPORuaeBC7lPnEDuJxwmfF4TxNOH/hnt1K3YRtZEbRZJ4G9WJAJ9zt3Bw6fS3mnQF127YpK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024925; c=relaxed/simple;
	bh=o2InuvvTPBUdEVOIhWF3OZXHuP2/s8Q/hVw9V1Z0L4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q6WhpQ37LjSAlsfyFsOBtRzFkWXvr+zUEYXW6V2W23XZuJiljpSPz6qSzXnfZZRcic9jF2kMa6xV5qxMVrRFVvCUStCpXvNG4qC7G2Z96rNjnnFzyFPaNFgcvtMhnfhms1ZKtac5iEn+d5WXPPJTNu6BYjbw7ylICtKRQYZKOEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wOBaEjIM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wOBaEjIM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B2E6C4CECE;
	Thu, 12 Dec 2024 17:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024924;
	bh=o2InuvvTPBUdEVOIhWF3OZXHuP2/s8Q/hVw9V1Z0L4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wOBaEjIMxA5/CbrXXpOHT7FO8nyBXV18aBs0yIiJTrQUyk0vC6lqDDdOP7DxTWyKR
	 oeNzC9UjKUU4mkiB+vZweljJxJp0CtQBFm6WNrGOxwsURPiMxWpxAL6InGNP4Al6wS
	 tNjqf0isFjkPIOX9v65D54NQC9sDXVSkNP115tY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 458/459] octeontx2: Fix condition.
Date: Thu, 12 Dec 2024 16:03:16 +0100
Message-ID: <20241212144311.860716788@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

From: David S. Miller <davem@davemloft.net>

commit b0aae0bde26f276401640e05e81a8a0ce3d8f70e upstream.

Fixes: 93efb0c656837 ("octeontx2-pf: Fix out-of-bounds read in otx2_get_fecparam()")
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -801,7 +801,7 @@ static int otx2_get_fecparam(struct net_
 	if (IS_ERR(rsp))
 		return PTR_ERR(rsp);
 
-	if (rsp->fwdata.supported_fec <= FEC_MAX_INDEX) {
+	if (rsp->fwdata.supported_fec < FEC_MAX_INDEX) {
 		if (!rsp->fwdata.supported_fec)
 			fecparam->fec = ETHTOOL_FEC_NONE;
 		else


