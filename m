Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8623B83E1;
	Sat, 17 Oct 2026 17:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257095; cv=none; b=KXihcbhwklrVOh10TR0z9sUM1F9CSeP/Kvi/RtilRm27xCL2v0wqSDieTpnUoCbkAr/JvnhBQTdt9vFBmGj8v/oDVZdzc2o0Fh7kISmgJx2hxITpffyMTTNCeVx1gIhhkQFdvH0W19PCzI72grHL+O5xRWnSZSz5brZ6rrfCL+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257095; c=relaxed/simple;
	bh=rv3aJ7UZnV0axfkhsVGc3oqSABkKP1CnuUUUcTTi+l0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V/nrYNZ3W5zMNV8DdUN7Jzve6V12eKaaorlu2As/TvYMltrKqu6bIQYufl1jGXQV5KGxj+9qxbUEuhfV+NADknmfADxt8TNJf10g5dzFyKwxdgc85WpXee3HJfHqa+aQ/qAFj3iRXKEbr0I5xkg1k7NeKtWKEMPA7B4LKLr9qG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oA2Un0Wt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oA2Un0Wt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 387661F000C4;
	Sat, 17 Oct 2026 17:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257094;
	bh=pZE6BFs5OT9nSKTbPBAelabXXXWc0nK+j2cMDKAKXrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oA2Un0WtOWFKDxj0oLrJpcOKkUFpeLkde9XjlW/hX7QRpc0pDfSE/s5QY5Q2M8Cvl
	 oOJ8KZuhxQrATNIAFHxGCIUuagXgJ3n0AloxUMN+zEpirI7rW/eHsHkTe3VkhrCUDM
	 YGxLImNkeASMvU6WlpOZeEYYQbXX/3UH4OX8hUc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0451/1674] iio: cdc: ad7150: fix OF matching and publish module aliases
Date: Sat, 17 Oct 2026 17:45:23 +0200
Message-ID: <20261017160442.693733504@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <hppiscas@163.com>

[ Upstream commit 52da294027f53e7084c18dd4b4f73354a40382f3 ]

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
[ sashal: Adjusted context to match the existing {} sentinel formatting. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/cdc/ad7150.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/cdc/ad7150.c b/drivers/iio/cdc/ad7150.c
index 4c03b9e834b88..0417dffd350a2 100644
--- a/drivers/iio/cdc/ad7150.c
+++ b/drivers/iio/cdc/ad7150.c
@@ -637,11 +637,13 @@ static const struct i2c_device_id ad7150_id[] = {
 MODULE_DEVICE_TABLE(i2c, ad7150_id);
 
 static const struct of_device_id ad7150_of_match[] = {
-	{ "adi,ad7150" },
-	{ "adi,ad7151" },
-	{ "adi,ad7156" },
+	{ .compatible = "adi,ad7150" },
+	{ .compatible = "adi,ad7151" },
+	{ .compatible = "adi,ad7156" },
 	{}
 };
+MODULE_DEVICE_TABLE(of, ad7150_of_match);
+
 static struct i2c_driver ad7150_driver = {
 	.driver = {
 		.name = "ad7150",
-- 
2.53.0



