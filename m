Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E56A1D172C;
	Wed,  2 Oct 2024 14:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878708; cv=none; b=gHRy6B765ZTKtH8UW+0hcjl7B1c2tBZxYQQKpCedWtQEH9bMNDcvCW7YPhInG1x9Ej1BxgPaZpZ9YMQrriNeZehpGMY+S84quOkbBoUKTrUfGGp9gRZ9LE7OpVZxqYpnmQS/YgtqBsyCZQFYvz8mp4D3146lGnozi63X/tC+oeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878708; c=relaxed/simple;
	bh=QwSeQgzx5PvZzDIVasN1mjz/pxI+AJLzRysl4/xEL5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cRTSvkF4zi42q2stEZquHvVojEvdSmtSOsxgE+3aTm1qkAfzaUNlo5+gQllJSs7lML7O9pXC9s6epniR4H3Su5dlD8A9/Vi7nL3I8XYCbY4ysk/rQsyuiyrFY8jBJV86KJZc1u7I5G5RdLm/7oUrgxtFT6q8aA9TqW78q6a4RoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sjJWWxG3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sjJWWxG3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B5CEC4CEC2;
	Wed,  2 Oct 2024 14:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878708;
	bh=QwSeQgzx5PvZzDIVasN1mjz/pxI+AJLzRysl4/xEL5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sjJWWxG3RPRNd5dSl/5AwlRrmcwVJESDuMXchTM2huSA3yz3gdVHXpfIwMdM1YNMY
	 49YRYXRuUGt7YmNzUTh6unT9ecGzxWkdMH2uxYTb4v/v/hQ6Hf1x7XYQziI58RqhSF
	 5YEKwq1bacHJSJivHCh/snIAdyghjA6CS32l0QRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH 6.10 475/634] soc: fsl: cpm1: qmc: Update TRNSYNC only in transparent mode
Date: Wed,  2 Oct 2024 14:59:35 +0200
Message-ID: <20241002125829.856020771@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

From: Herve Codina <herve.codina@bootlin.com>

commit c3cc3e69b33fee3d276895e0e2d1a8fb37ea5d0e upstream.

The TRNSYNC feature is available (and enabled) only in transparent mode.

Since commit 7cc9bda9c163 ("soc: fsl: cpm1: qmc: Handle timeslot entries
at channel start() and stop()") TRNSYNC register is updated in
transparent and hdlc mode. In hdlc mode, the address of the TRNSYNC
register is used by the QMC for other internal purpose. Even if no weird
results were observed in hdlc mode, touching this register in this mode
is wrong.

Update TRNSYNC only in transparent mode.

Fixes: 7cc9bda9c163 ("soc: fsl: cpm1: qmc: Handle timeslot entries at channel start() and stop()")
Cc: stable@vger.kernel.org
Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Link: https://lore.kernel.org/r/20240808071132.149251-2-herve.codina@bootlin.com
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/fsl/qe/qmc.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/soc/fsl/qe/qmc.c b/drivers/soc/fsl/qe/qmc.c
index 76bb496305a0..bacabf731dcb 100644
--- a/drivers/soc/fsl/qe/qmc.c
+++ b/drivers/soc/fsl/qe/qmc.c
@@ -940,11 +940,13 @@ static int qmc_chan_start_rx(struct qmc_chan *chan)
 		goto end;
 	}
 
-	ret = qmc_setup_chan_trnsync(chan->qmc, chan);
-	if (ret) {
-		dev_err(chan->qmc->dev, "chan %u: setup TRNSYNC failed (%d)\n",
-			chan->id, ret);
-		goto end;
+	if (chan->mode == QMC_TRANSPARENT) {
+		ret = qmc_setup_chan_trnsync(chan->qmc, chan);
+		if (ret) {
+			dev_err(chan->qmc->dev, "chan %u: setup TRNSYNC failed (%d)\n",
+				chan->id, ret);
+			goto end;
+		}
 	}
 
 	/* Restart the receiver */
@@ -982,11 +984,13 @@ static int qmc_chan_start_tx(struct qmc_chan *chan)
 		goto end;
 	}
 
-	ret = qmc_setup_chan_trnsync(chan->qmc, chan);
-	if (ret) {
-		dev_err(chan->qmc->dev, "chan %u: setup TRNSYNC failed (%d)\n",
-			chan->id, ret);
-		goto end;
+	if (chan->mode == QMC_TRANSPARENT) {
+		ret = qmc_setup_chan_trnsync(chan->qmc, chan);
+		if (ret) {
+			dev_err(chan->qmc->dev, "chan %u: setup TRNSYNC failed (%d)\n",
+				chan->id, ret);
+			goto end;
+		}
 	}
 
 	/*
-- 
2.46.2



