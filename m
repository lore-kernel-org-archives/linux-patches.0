Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211084;
	b=xoOO/37F+dYziZep0mmsNF4+LqFJWE2iVvlDQysafbOukScR8TNxeRt3EfnSgLTeOzuW
	 WHOLgGwFw9rHidZMSyd7FKnG5GAveViblam3a14xBxtmeIByyfC4iVUDqsVLDhyPVSx2x
	 KUpojVBJg4ztfTJuEKiCSKuDQWc9hf2Ke7zSxaOB3mu4dRNNwbwDFebbZJUqD6jMbx/NA
	 bS7iYnQ2UFIWX2hlUN7pwE23GxOlryoY5GCWLzNFFzPqfy3y0IZNmj0CksCNFrB7O8t9a
	 dPVJoXdlcsYi/TWazfjI2JBlLfJc6SEUsw3oV2cE9u6lrf37AUR0V5G5VXcbgg7uAvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211084;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nBAHpGzYOEbOF+FdLa8pTH/f/cjRSfKLQ7AHRBTrDLM=;
	b=nm32lc8ZIsh/0mhG2jVmekcWjo2YaGVtoMpowcEZe565NkSDBTXCwKLv+TgEMj+u3Rud
	 P3Lilwebv2VnI17a9FHqauddvjeHaN3HXD4fozvrGN5XqtUuxSRVOCKnYxjIx5TTRcT5M
	 Yqn3JTBQUGcifeVhEZYK0Nw5ZoHskhfOEyUDHnIkZ2+9n/ip2PujdHUKQdxt/DgnGnyus
	 V/+fd/K2XqFJ+rDxs0I49ujCCiliIwLW9xnvOs6EcPK9DkadJRamvsrhP4MEO+ICeVlyj
	 +O4kgn2K6O8+b42tHbeAAJIGRg//FXSzImDLQsMhjAob90akOnreKmPcfKaAtw9sn5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tt2CmabC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC50260A3810;
	Wed, 28 Oct 2026 18:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tt2CmabC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ACDD1F01825;
	Wed, 28 Oct 2026 18:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211083;
	bh=nBAHpGzYOEbOF+FdLa8pTH/f/cjRSfKLQ7AHRBTrDLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tt2CmabCmf6LUjnV2ZveyWPKENnqIpXTfZM+NaplR5lg9CN5LOnc0j6ZhdU+OUoja
	 zmwigzhXFci5wLcpBNR1uG/GxF83KCatBj7YtBO/hD15zEJrGFPCVLqQLE3m5l2oeP
	 u/PfJ+mF5CvcQpAAkJiUyNXiVP7z5gbWpIIG18rc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.15 252/571] iio: accel: sca3000: fix frequency divider condition check
Date: Wed, 28 Oct 2026 17:56:39 +0100
Message-ID: <20261028170013.983573753@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Salah Triki <salah.triki@gmail.com>

commit d380bf5f94a892e546d9a94e8557ad866b043a2a upstream.

When setting the sampling frequency, the check for `base_freq / 2` is
followed by an independent `if` statement for `base_freq / 4`. If `val`
equals `base_freq / 2`, the second check fails and falls through to the
`else if (val != base_freq)` branch, returning `-EINVAL` erroneously.

Fix this by chaining the checks with `else if`.

Fixes: e0f3fc9b47e6 ("iio: accel: sca3000_core: implemented IIO_CHAN_INFO_SAMP_FREQ")
Signed-off-by: Salah Triki <salah.triki@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/sca3000.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/accel/sca3000.c
+++ b/drivers/iio/accel/sca3000.c
@@ -645,7 +645,7 @@ static int sca3000_write_raw_samp_freq(s
 
 	if (val == base_freq / 2)
 		ctrlval |= SCA3000_REG_OUT_CTRL_BUF_DIV_2;
-	if (val == base_freq / 4)
+	else if (val == base_freq / 4)
 		ctrlval |= SCA3000_REG_OUT_CTRL_BUF_DIV_4;
 	else if (val != base_freq)
 		return -EINVAL;


