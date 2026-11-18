Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050932;
	b=bVzAsb687ZfXtvcg29ssmVtcLfsbgtv4V6iliWsP2NARoK9aQYg/s89SCWE4rl7vwdfA
	 9eMj/uxm+Hw0TyDv2/pHVzdE3+nFZmdNWQKm3YF7rxY4lKHiS3cz5hMz/sVwSL5mtfuZG
	 pATa6HR08p/5e4FMEtf04tHxKrW3B2y0BmzFzcFsqFs7PmkQukucVcrqPFYqs1V/c2dYx
	 aL44je1OO/vr/XyDDuS+rXMbs6Wkvq78DX+HgYpk/cpdAcvTnzCsTHnvrfbuVJNQGkzPu
	 hyCOdYtx1uTrLoHP3qb7B984Ebwy7qMzogo5CV53HBf2jH9Dm8rx10wZANjoOdzDSAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050932;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=4Rgqw2Np/SotrnAw89qwJmaN+GXmPgn1PYeseVfVmhE=;
	b=38os+aMSp8cQdVPYrjODmTLGELK0srL068X9oqZ/PbfYo81YW254d6qpvLhC5HaoX02g
	 MGGfQmeBccO2MoqGp7NDhL7NrChqJVQ5G2e/0CufivrAzz47+fQELH4qlHs2VevYTlhmE
	 2KMXlzHWXTqt111inezC/imLgRqsVVufqj3T9iJMhHh2dQ7ZyhqeCvdtNkkoprdfcotqZ
	 +mdd5WQSLSe1Bcz/wvoLlvxxt++VCO7B5dIhZLTwBoxnAcUEeeqDNGlUO/nz9hljHUJdp
	 EIHNoVgDdEuRxxm0aw8itRun5avHm72/OHm7TZ8sGChVFr4WsmCW6l8o2IuCBQiD1yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O1lW0AdS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232D1606A31C;
	Thu, 19 Nov 2026 01:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O1lW0AdS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73AF71F000C4;
	Thu, 19 Nov 2026 01:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050932;
	bh=4Rgqw2Np/SotrnAw89qwJmaN+GXmPgn1PYeseVfVmhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O1lW0AdS5hQMIRAU72hTyIU5meHWiaDKbtquuQ2u1EO4xycT3r+KqapCRS+zb/7G2
	 Zv3l06YeGPgZy4Lr3yknmImWILcgOhbRLGyKwMpLoVMv5II+ikQwc89NNuYLjXXcRH
	 pvW5sUQan+ctOUYEgaEthMIM+ddDm+KVDyLKYJzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Kry=C5=A1tof=20=C4=8Cern=C3=BD?= <cleverline1mc@gmail.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0029/2214] w1: ds2482: add OF device match table
Date: Wed, 18 Nov 2026 15:28:25 +0100
Message-ID: <20261118150011.269510787@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kryštof Černý <cleverline1mc@gmail.com>

[ Upstream commit 53f33fd74d3993af0fbb5494b5be709f6ca6b712 ]

Add an of_device_id table and hook it into the i2c driver so the
ds2482/ds2484 can be matched and auto-probed from Device Tree.

This allows automatic module loading when instantiated via DT.

Signed-off-by: Kryštof Černý <cleverline1mc@gmail.com>
Link: https://patch.msgid.link/20260612-w1-of-autoload-v1-1-74e8a17626e6@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/w1/masters/ds2482.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/w1/masters/ds2482.c b/drivers/w1/masters/ds2482.c
index 50451ba345efb..e4cd059a67f12 100644
--- a/drivers/w1/masters/ds2482.c
+++ b/drivers/w1/masters/ds2482.c
@@ -554,9 +554,17 @@ static const struct i2c_device_id ds2482_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, ds2482_id);
 
+static const struct of_device_id ds2482_of_match[] = {
+	{ .compatible = "maxim,ds2482", },
+	{ .compatible = "maxim,ds2484", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, ds2482_of_match);
+
 static struct i2c_driver ds2482_driver = {
 	.driver = {
 		.name	= "ds2482",
+		.of_match_table  = ds2482_of_match,
 	},
 	.probe		= ds2482_probe,
 	.remove		= ds2482_remove,
-- 
2.53.0



