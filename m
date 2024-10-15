Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969E61D0492;
	Tue, 15 Oct 2024 11:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993304; cv=none; b=jsatqwaE2xjgUGabNp1d+m0cbYqoe8VoEtxjKj67QRzBTfxz16p0l9sqQx6/6v4AZFm5ew2/rjg6PnjU2zG0mIpni25QecdjQF4XhsXWBPwSQvF2r99//1FwewapmRttZZo3V3o8Cf/PW9aAg2NBluMMk3O1+qG7j8WdOVUTaLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993304; c=relaxed/simple;
	bh=fq1H02N/7ZUtV2derhn0KZDo3VpuDVJ1i1NZaiIcE/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ITUsdid/JCSMVMDlJvanHs9gYnL7dB/Jy+JwtqYXNYTp/aJwAp6WA/bYaPdGS7O+Bdo1pHSFP7R19nVzbp7nmC9eQ51HOU6nmPAZ3Dq6DrWxjr7jYZMFHEJIuN8ivD58/yO7Ws6i0Bm6i1L/0evLV9d8SH46L5BBg13zY6II+yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tUuD3l0E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tUuD3l0E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0717AC4CEC6;
	Tue, 15 Oct 2024 11:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993304;
	bh=fq1H02N/7ZUtV2derhn0KZDo3VpuDVJ1i1NZaiIcE/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tUuD3l0EzMOHxcuTPfG0BXXaNaH/CcWCij+YRFpVtoT9CxtWLNToMLG8ssWeiwOtj
	 K6BgN0eaIT2TsCCrZ02e/6xNrhq1b6EOHdbB9tmdsBZNnBMU8r5LsOAu/yYPwUS/ZP
	 j9VZVvAYZ+qdboJDlb7wKymqplDaRkKvQdvzhSRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 371/691] spi: lpspi: Simplify some error message
Date: Tue, 15 Oct 2024 13:25:19 +0200
Message-ID: <20241015112455.073121693@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 0df874c6712d9aa8f43c50ec887a21f7b86fc917 upstream.

dev_err_probe() already prints the error code in a human readable way, so
there is no need to duplicate it as a numerical value at the end of the
message.

Fixes: 12f62a857c83 ("spi: lpspi: Silence error message upon deferred probe")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-By: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://lore.kernel.org/r/253543c462b765eca40ba54c66f4e3fdf4acdeb7.1659735546.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-fsl-lpspi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -919,7 +919,7 @@ static int fsl_lpspi_probe(struct platfo
 
 	ret = devm_spi_register_controller(&pdev->dev, controller);
 	if (ret < 0) {
-		dev_err_probe(&pdev->dev, ret, "spi_register_controller error: %i\n", ret);
+		dev_err_probe(&pdev->dev, ret, "spi_register_controller error\n");
 		goto free_dma;
 	}
 


