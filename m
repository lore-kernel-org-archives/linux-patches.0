Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77771C3730;
	Thu,  6 Jun 2024 14:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683663; cv=none; b=cbCwfr3ztieOm7ERCPT9sY45X12N55ojTVtQ5w65A3ORZsx62uKlvmfslZhf4TLDz16E+Lhp4vB5VJ2TkmL5/ud377msbSDom3/nqc9ZklQciFZcHKuhR3Pkt1kVP/2dp4UdHR7ZgQIr7ohyVKoT5iw//JhdP6C0U5dkvWBWLa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683663; c=relaxed/simple;
	bh=ttMfCjVPfVQ7rOjaExdEcpTKVNAUdmoIw0CSeNcQaWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PPr80zDFTeWqpvRF5dU91sX7U4PUQqnynLm349FIlpYXDoPEmK7MGNtWtwYUfY9x6UeJ+MmZpcUoTbxJfqbzonJPQCvuKGxQ6RyI6wd6Cq0Ufy9to5x5/Il10sYgUjZIzjzuVqxoWojb0U8m9lRb5rItuV02ByT+qioFEonkOQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xds8PIF+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xds8PIF+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 958EAC2BD10;
	Thu,  6 Jun 2024 14:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683663;
	bh=ttMfCjVPfVQ7rOjaExdEcpTKVNAUdmoIw0CSeNcQaWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xds8PIF+3PelI27eH9XquxXROv6+4poOr3S9l0tkgUish8QWDqhSc21ZZcvkiIM9Y
	 oBUXAOxktdyYnGHmQOSo971Pa2eBNvYHzZ5s3iDoj0k/7i0X/5Smfl/KKpKrjfodXl
	 /nsTXjjWsA+QJDLESJWDhgNU+kaxrvUgcGUqAMk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 547/744] iio: accel: mxc4005: allow module autoloading via OF compatible
Date: Thu,  6 Jun 2024 16:03:39 +0200
Message-ID: <20240606131749.993268936@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Ceresoli <luca.ceresoli@bootlin.com>

[ Upstream commit 4d7c16d08d248952c116f2eb9b7b5abc43a19688 ]

Add OF device table with compatible strings to allow automatic module
loading.

Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20231004-mxc4005-device-tree-support-v1-2-e7c0faea72e4@bootlin.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 6b8cffdc4a31 ("iio: accel: mxc4005: Reset chip on probe() and resume()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/mxc4005.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/iio/accel/mxc4005.c b/drivers/iio/accel/mxc4005.c
index b608aa5467175..88f0bf2cc1d3f 100644
--- a/drivers/iio/accel/mxc4005.c
+++ b/drivers/iio/accel/mxc4005.c
@@ -486,6 +486,13 @@ static const struct acpi_device_id mxc4005_acpi_match[] = {
 };
 MODULE_DEVICE_TABLE(acpi, mxc4005_acpi_match);
 
+static const struct of_device_id mxc4005_of_match[] = {
+	{ .compatible = "memsic,mxc4005", },
+	{ .compatible = "memsic,mxc6655", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, mxc4005_of_match);
+
 static const struct i2c_device_id mxc4005_id[] = {
 	{"mxc4005",	0},
 	{"mxc6655",	0},
@@ -497,6 +504,7 @@ static struct i2c_driver mxc4005_driver = {
 	.driver = {
 		.name = MXC4005_DRV_NAME,
 		.acpi_match_table = ACPI_PTR(mxc4005_acpi_match),
+		.of_match_table = mxc4005_of_match,
 	},
 	.probe		= mxc4005_probe,
 	.id_table	= mxc4005_id,
-- 
2.43.0



