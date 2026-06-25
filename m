Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C041C29B77C;
	Thu, 25 Jun 2026 13:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782393025; cv=none; b=nHA8n9oEgQvR2JLF3uTGBjb5/hg1m0pcR0ZzgfYlWbCn9JBYDKc4C6JrbfeIaPRUvXw9RG75iDINk0pZKpUdhTnk0jk0gYPKksj2NxSj7cH8CumFrseuR5MIW8aa0cht/7RcosQZoihQJz/03gC8JWjmPqf/VVL/8m31pIdCIEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782393025; c=relaxed/simple;
	bh=5TAtTU2Ev4uBCj2XbNoG64Ogb3SxyCs9PqIC/wwgUGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IITC4HdnJxwC74b60x8WRvK5WOe2naC0aeaZ6IBE0Y+bwZJJWeGKh52x1mjdHFLE1MkxXe/VrcqTOwPQOMWH7CzMK1sj7ENCi5ZtBnbBXjJViz/AFqz/8XaoAVSiN4BHO6eow8ks1qCEUOf1ofWTcrGEHtgsNugmNkWGWJej+gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S7OzZ/p3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S7OzZ/p3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11AB41F000E9;
	Thu, 25 Jun 2026 13:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782393024;
	bh=JhBai0q7pthUo7ka1itYdt5n6IBoSRoX+zXucFINRMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S7OzZ/p3oHBfH5Wpr/Ipp3dij0f28hLh8KJ0BEe2RzRX4T3DpQXIRKIZy6WhT6uTE
	 Xkhzz63nJ3jPJG3psx4MTD4NyWJAEVQrWJaB/oYcxyIs+qvMY+mdxzeogs5DfmBlvU
	 ZoLC1Zhex+lPrqwcsBiqCoUQEs0EKdRBKAgpvsY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jonathan Cameron <jic23@kernel.org>,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Andy Shevchenko <andy@kernel.org>,
	Sam Daly <sam@samdaly.ie>
Subject: [PATCH 7.0 34/49] iio: adc: ti-ads1298: add bounds check to pga_settings index
Date: Thu, 25 Jun 2026 14:03:46 +0100
Message-ID: <20260625125642.322076574@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125637.527552689@linuxfoundation.org>
References: <20260625125637.527552689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sam Daly <sam@samdaly.ie>

commit 95e8a48d7a85d4226934020e57815a3316d3a14b upstream.

ads1298_pga_settings has 7 elements but ADS1298_MASK_CH_PGA can yield
values 0-7. If it yields a value >= 7, this causes an out-of-bounds
array access. Add a bounds check and return -EINVAL if the index
is out of range.

Note that the remaining value b111 is reserved so should not be seen
in a correctly functioning system.

Assisted-by: gkh_clanker_2000
Cc: stable <stable@kernel.org>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: David Lechner <dlechner@baylibre.com>
Cc: "Nuno Sá" <nuno.sa@analog.com>
Cc: Andy Shevchenko <andy@kernel.org>
Signed-off-by: Sam Daly <sam@samdaly.ie>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ti-ads1298.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/iio/adc/ti-ads1298.c
+++ b/drivers/iio/adc/ti-ads1298.c
@@ -279,6 +279,7 @@ static const u8 ads1298_pga_settings[] =
 static int ads1298_get_scale(struct ads1298_private *priv,
 			     int channel, int *val, int *val2)
 {
+	unsigned int pga_idx;
 	int ret;
 	unsigned int regval;
 	u8 gain;
@@ -302,7 +303,11 @@ static int ads1298_get_scale(struct ads1
 	if (ret)
 		return ret;
 
-	gain = ads1298_pga_settings[FIELD_GET(ADS1298_MASK_CH_PGA, regval)];
+	pga_idx = FIELD_GET(ADS1298_MASK_CH_PGA, regval);
+	if (pga_idx >= ARRAY_SIZE(ads1298_pga_settings))
+		return -EINVAL;
+
+	gain = ads1298_pga_settings[pga_idx];
 	*val /= gain; /* Full scale is VREF / gain */
 
 	*val2 = ADS1298_BITS_PER_SAMPLE - 1; /* Signed, hence the -1 */


