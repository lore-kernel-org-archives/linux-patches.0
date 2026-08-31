Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05F651572E;
	Mon, 31 Aug 2026 13:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183798; cv=none; b=NBXGPSRtk3IL6A42bChhenPk3GTUzf5ikFq9Re7DVWykMdJH1paa4YuEdMoeOICm0i9toR7k+E02IXmXTJjoHL9FwJHC1NZ+fozPqsO+TujDqtnEVoxzdYLSR/8vAXz9kgjiWnUH77U+ehJh0bc+4HVjpzqjWeOXwBayM4jCCt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183798; c=relaxed/simple;
	bh=1OMp5cTvkCJeZUpJs+GuxBoQyuK50nqkv/9CebJyptY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mEP1bBsZOLzfJDDICgbNwOXkj+p1DqjzOzq+TG57fHiH+ial0SS2ia2n35B06ZYVXJwY+VPm+fomzij7mck1nJInpICY3b1wiCXPffwcAircZ+ttqUFVA053hnYDbbl9/gJjbipDdyFqNtq3Fu6JBI243xo+E1sLGODPSRfuBwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BZR5J+bF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BZR5J+bF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD7861F000E9;
	Mon, 31 Aug 2026 13:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183796;
	bh=9X7WudapGkMVb60vmAyAyo/nIwsGUa8iXuABRAdEkck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BZR5J+bFKIsuVvMkcgP2XNJ3ehijMy2MsrgxQTLlacbMQelBkaYFb8XWsQEqKgy2o
	 c/c37HC7XMrBtayj6K/cA/a8yVFSH741jYg5EAhhl7MMRjnVsoddrLVYglLeULp/5b
	 yYA4c9MNn+nQg+rZA7g69G6y9+C5I82XX41kerUJo3+77qL9SDlTZYxBW+tbzmeoK1
	 DXJyOAlEwWruQ4t4Sizf92VE7pdfeC694MjywiihXEP5MT9tegrOwlRpCXqCkt3FvU
	 7TLBu5IydnolTscbjU8OwBWiTkBUa0//RDyGJ4D6EOFX9yDiyMIylgZinz5hf58SHl
	 n6avzJeu8Gahg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kevin Tung <kevin.tung.openbmc@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-iio@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] iio: adc: rtq6056: add i2c_device_id support
Date: Mon, 31 Aug 2026 09:25:37 -0400
Message-ID: <20260831133314.4125787-309-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kevin Tung <kevin.tung.openbmc@gmail.com>

[ Upstream commit ce80292ead5bb42b50a6b63e44fd95c0edf9d334 ]

Add i2c_device_id table to support legacy I2C instantiation.
Update probe to use i2c_get_match_data() so device data can be
retrieved consistently for both OF and legacy I2C instantiation.

Signed-off-by: Kevin Tung <kevin.tung.openbmc@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background branch search finished (~79s). It didn’t turn up anything
useful for this commit: `git log -S "rtq6056_probe" --remotes` returned
unrelated picks from large `linux-next` merges, and the `master` search
only hit an unrelated merge touching that file.

That doesn’t change the earlier conclusion for **6.18.43**: the
regression is present in the current tree, the fix is small and well-
reviewed, and the backport recommendation remains **YES**.

 drivers/iio/adc/rtq6056.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/rtq6056.c b/drivers/iio/adc/rtq6056.c
index 2bf3a09ac6b04..e2b1da13c0d31 100644
--- a/drivers/iio/adc/rtq6056.c
+++ b/drivers/iio/adc/rtq6056.c
@@ -728,7 +728,7 @@ static int rtq6056_probe(struct i2c_client *i2c)
 	if (!i2c_check_functionality(i2c->adapter, I2C_FUNC_SMBUS_WORD_DATA))
 		return -EOPNOTSUPP;
 
-	devdata = device_get_match_data(dev);
+	devdata = i2c_get_match_data(i2c);
 	if (!devdata)
 		return dev_err_probe(dev, -EINVAL, "Invalid dev data\n");
 
@@ -871,6 +871,13 @@ static const struct richtek_dev_data rtq6059_devdata = {
 	.set_average = rtq6059_adc_set_average,
 };
 
+static const struct i2c_device_id rtq6056_id[] = {
+	{ "rtq6056", (kernel_ulong_t)&rtq6056_devdata },
+	{ "rtq6059", (kernel_ulong_t)&rtq6059_devdata },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, rtq6056_id);
+
 static const struct of_device_id rtq6056_device_match[] = {
 	{ .compatible = "richtek,rtq6056", .data = &rtq6056_devdata },
 	{ .compatible = "richtek,rtq6059", .data = &rtq6059_devdata },
@@ -885,6 +892,7 @@ static struct i2c_driver rtq6056_driver = {
 		.pm = pm_ptr(&rtq6056_pm_ops),
 	},
 	.probe = rtq6056_probe,
+	.id_table = rtq6056_id,
 };
 module_i2c_driver(rtq6056_driver);
 
-- 
2.53.0

