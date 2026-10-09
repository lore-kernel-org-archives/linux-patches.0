Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F75D3BB112;
	Fri,  9 Oct 2026 14:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557145; cv=none; b=C6yfkAWS5L1j8nzMJYBDRtxPsl5WItYpDQ3RKqv3IsbHSQmpfi9UwOADeSieuGRLsSz+dHcyNjIaNO6HWVroRC+PyTpbKdUOMkSNnvyitX3rC1WSs6sSzWCUqPmLxh84BcO2Ln0yY0zv5Su/9z7yTNxyo4lkRtXUBJlEcuCtVrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557145; c=relaxed/simple;
	bh=F+sbbXs7swxLXwY32U2VR21lf8PAcTyfNpwJ59jZBQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Erj+sC7yti5+m345SOTsScQaM5ktoWbqsTZBgxL/L7M+0gxZZPpmO079tF3j6zqb+Bwv1Ppa5rDCLVz/dTNuO/0Y41ePHss3Czb1XLoXMNUGCHX2T18BRtOorv8M6sbGjIJ4zjK6pCxuJm86nasLdpVPVAidgIqMqUpgwgub16k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Jtx7DNa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Jtx7DNa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 075061F000FF;
	Fri,  9 Oct 2026 14:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557144;
	bh=JtLtHqfZNjQDeYDFF8fWwZdRTBnrZATpAxxajcC6X20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Jtx7DNajn+v2ESDxc0h8fqdU2jBzdsz15wfPhmb8Newx0aup5vvxYdK15VU5rcze
	 ocb29fM9bR7cT07uk6KQBmYle8s9PG2ODFpogmbiE+xKoR43zJrYBGTyqIsaXlUE56
	 5OzmSE0s5RlBqIhH3qnYv1XjGeuil5dLo4Ab5Qso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 322/403] iio: cdc: ad7150: fix OF matching and publish module aliases
Date: Fri,  9 Oct 2026 16:11:23 +0200
Message-ID: <20261009140959.757692806@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <hppiscas@163.com>

commit 52da294027f53e7084c18dd4b4f73354a40382f3 upstream.

The OF match entries use positional initializers, which initialize the
name field rather than compatible. Consequently the advertised AD7150,
AD7151 and AD7156 compatible strings do not describe OF compatible
matches. The table is also not exported for module alias generation.

Use designated compatible initializers and publish the OF table. Keep
the existing I2C ID table and its device-variant selection unchanged.

The issue was found by our static-analysis tool.

Fixes: 89f2d5b080bc ("staging:iio:cdc:ad7150: Add of_match_table")
Assisted-by: LLM
Cc: stable@vger.kernel.org
Signed-off-by: Pengpeng Hou <hppiscas@163.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/cdc/ad7150.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/iio/cdc/ad7150.c
+++ b/drivers/iio/cdc/ad7150.c
@@ -637,11 +637,13 @@ static const struct i2c_device_id ad7150
 MODULE_DEVICE_TABLE(i2c, ad7150_id);
 
 static const struct of_device_id ad7150_of_match[] = {
-	{ "adi,ad7150" },
-	{ "adi,ad7151" },
-	{ "adi,ad7156" },
+	{ .compatible = "adi,ad7150" },
+	{ .compatible = "adi,ad7151" },
+	{ .compatible = "adi,ad7156" },
 	{ }
 };
+MODULE_DEVICE_TABLE(of, ad7150_of_match);
+
 static struct i2c_driver ad7150_driver = {
 	.driver = {
 		.name = "ad7150",


