Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620591;
	b=etV/3U6kUia4Iz3+mOPiS/kLZ7gFpM/xaExYGwKVTZIfKVGsIWzYvOZxIrVv2k4/VcpF
	 Pbvmel+cqlMtqE2PX6TJDc01rmEqQwUp1xCWp4X7x/t1s5CNwK1nDxipqeb9y2dD3l7al
	 tB0JYmYZAnHLst7xl63S59PkUweg2Q6DbKn1DD0UegVIu6bsXMjTQuHERnfw6hUQH8JFe
	 gAdysJnE0NUYZkThuiZKDVf+YzUT/Di8d7Zg1aKq1SMlAJi1bOTSygYqg9/05/sFC2j73
	 2uczxoIH9zUTofQCa8KMQxC7COHTZ+u6Z/5+fzBfkw6P1lcKbFFX6K8rZKP4P57/AHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620591;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DMxHdR1F6wA0870EBoXQQGbTozUUgxqN/FSjKge9rAc=;
	b=mvfRqDUqu/XwovqC5y7e4sp/N+LhWVDCYCnMqkCKTrq7PKexkIkLXETkEFU+8YBfovfA
	 iBLhBRGhRL4dFWmTR+5dydQwQWJ6ZQYekvHAa8QreA5Uv0ZMVds5A4Io/CaMOVNXJ+v88
	 p9Ny9lbriJNfW7KMsvITLNRma/PkjsIsffdI2LP3/vcPsDO/C+q0ZmD6HtogoB+vxCeJL
	 Wrl39YcQfj4GJke0PWDuEJQx0GWwAw2kpRW+iUEm/0GbqifViMluZl4Zg4MPSAJ3v48Rs
	 MdWJdnky/Hkvs2sf7b0g4IQ/3L8Bo6SZYKaBglRusa3VYQfKkzzEkEkr92IwUkY0Y3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=06SD4YMN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63C5606A31E;
	Wed, 25 Nov 2026 15:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=06SD4YMN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A59E61F000CA;
	Wed, 25 Nov 2026 15:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620590;
	bh=DMxHdR1F6wA0870EBoXQQGbTozUUgxqN/FSjKge9rAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=06SD4YMN0Ds3nSWGWKkfLI15oefDogrpZYu3AhdRPR2nNmcQ5N7PN9mFSZz9g/i+R
	 VDbZ/bt33FRKFlV3wM4GdNo8EQzQhcJqlAmOmAnUK0nCJjdFfRj0abMmtjEsvHS0hr
	 b9s1MyJVDGgbfWvl1dIW2atUcm5zk+rCSU8cH8is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Billy Tsai <billy_tsai@aspeedtech.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.3 0967/1005] iio: adc: aspeed: Use syscon phandle for trimming data when available
Date: Wed, 25 Nov 2026 15:38:25 +0100
Message-ID: <20261125143844.319332850@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Billy Tsai <billy_tsai@aspeedtech.com>

commit 4e7007317fdf83b5201f39afff5adfa0292fc707 upstream.

aspeed_adc_set_trim_data() locates the SCU holding the ADC's
reference-voltage trimming data with of_find_node_by_name(NULL,
"syscon"), a global search that matches the first device-tree node
named "syscon" regardless of which SCU instance it actually is.

On AST2700, which splits its SCU into "syscon0" (soc0) and "syscon1"
(soc1), both nodes share the same node name "syscon" and only differ
by label and unit address, so the lookup always resolves to syscon0
even though the ADC's trimming data lives in syscon1.

Use the new "aspeed,trim-syscon" phandle property when present to look
up the correct regmap directly, falling back to the old global by-name
search when the property is absent so existing device trees keep
working.

Fixes: 9d8b88ffb773 ("iio: adc: aspeed: Add AST2700 ADC support")
Signed-off-by: Billy Tsai <billy_tsai@aspeedtech.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/aspeed_adc.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

--- a/drivers/iio/adc/aspeed_adc.c
+++ b/drivers/iio/adc/aspeed_adc.c
@@ -201,18 +201,29 @@ static const struct iio_chan_spec aspeed
 
 static int aspeed_adc_set_trim_data(struct iio_dev *indio_dev)
 {
-	struct device_node *syscon;
+	struct device_node *np, *syscon;
 	struct regmap *scu;
 	u32 scu_otp, trimming_val;
 	struct aspeed_adc_data *data = iio_priv(indio_dev);
+	const char *propname = "aspeed,trim-syscon";
 
-	syscon = of_find_node_by_name(NULL, "syscon");
-	if (syscon == NULL) {
-		dev_warn(data->dev, "Couldn't find syscon node\n");
-		return -EOPNOTSUPP;
+	np = dev_of_node(data->dev);
+	if (of_property_present(np, propname)) {
+		scu = syscon_regmap_lookup_by_phandle(np, propname);
+	} else {
+		/*
+		 * No "aspeed,trim-syscon" phandle: either a single-SCU SoC,
+		 * or a DTB predating the property. Fall back to the old
+		 * global by-name lookup for backward compatibility.
+		 */
+		syscon = of_find_node_by_name(NULL, "syscon");
+		if (!syscon) {
+			dev_warn(data->dev, "Couldn't find syscon node\n");
+			return -EOPNOTSUPP;
+		}
+		scu = syscon_node_to_regmap(syscon);
+		of_node_put(syscon);
 	}
-	scu = syscon_node_to_regmap(syscon);
-	of_node_put(syscon);
 	if (IS_ERR(scu)) {
 		dev_warn(data->dev, "Failed to get syscon regmap\n");
 		return -EOPNOTSUPP;


