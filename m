Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033519;
	b=nZmNhI3l9F2V9yjizscqVRdfLjFfO7XgMuL6VpW/V/2fZ9UuSsLCczJ8n+oVSKY5UzcA
	 pbQZ/vzf1maKEdsKdj7UIQgDZduWnvBIZTsWvzAZBDXPY6aYuZw/XAxCTEeIoXqG5Hf/v
	 DvUUg+xXVwSDcWINDQNN3o6D6+P5tB7Qe9KQ0Okov4cES0ssSyZYEQeSGvqPL3Rvd8FYA
	 t/VHINqShGN5p49qmNuHfMTfIfcQdueigg3hWwqrLrzY53fOrRDONVqULh4SJix5tux8R
	 NJdF39a8uHDIc4CqLEeph0gP/dHRbawqyjKVqPK7b0Rda5Xyde4WKUM04QE/HUW5MZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033519;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=k6b/ToP9LJBRPRuo6SPJnOTGgFCyfqNQTFGbaG1U7uw=;
	b=ZJhGPO4+YWcQHPMPXy6n02rnoONZPDO4AcEaEizwwxuamBNwBlkl059Ksr6rnbmMfOwH
	 tVzgMVP4lr3aoe3NmcNeMG8/DdEum92UPVbejSmhUzckBEnGajisJyWuvOOa7VSJmevSR
	 Z2W1Y8hfa4nJR6kh2DZhYMKvpFB5ODNe2BcjqAxcviMKZmhYi7HLeBbKl9G/s4m9GAzMj
	 87S2gdXS7OAU/jqTDcGDrGhH3WRK5jgTw70Fr1IvjYyI7BnRK9oee6DnLvgbdrNMvEFQe
	 JMnn9w27oVwDajW4HRE9XFh49BTi7dijztZXZPTxf5rjy3MiF9osgKTkgZYaeUVDL+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="LsST/gf/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BCE4606A31C;
	Wed, 18 Nov 2026 20:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LsST/gf/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6187D1F000C4;
	Wed, 18 Nov 2026 20:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033518;
	bh=k6b/ToP9LJBRPRuo6SPJnOTGgFCyfqNQTFGbaG1U7uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LsST/gf/csPvaNnexi6FYdW+Wqa4Y5xWwonnsbUR9JUAf/ZkpMHmHszpVxP63sP09
	 RBdt2/VWgsl+Q6iWZIgluMIkr6aioRnWPbmmR/8gvDT8mXbCl8JO5pFSDeQ62DcUUu
	 Ivm1+DScn3QNCd5XvT+Mhr/UjhK87PIAXgS+OhyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Kry=C5=A1tof=20=C4=8Cern=C3=BD?= <cleverline1mc@gmail.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0026/3318] w1: ds2482: add OF device match table
Date: Wed, 18 Nov 2026 15:10:48 +0100
Message-ID: <20261118150314.544978452@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index da801859c7ec0..d4d81766fe486 100644
--- a/drivers/w1/masters/ds2482.c
+++ b/drivers/w1/masters/ds2482.c
@@ -551,9 +551,17 @@ static const struct i2c_device_id ds2482_id[] = {
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



