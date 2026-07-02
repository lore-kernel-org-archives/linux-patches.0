Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D1335F19A;
	Thu,  2 Jul 2026 16:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010380; cv=none; b=Y99f0uswHiTAE7zEqB+umMBSYRAasLYOqgrrfOkIBi2sm0pYtxgeJKfdigaCNiN2qBnwyNMTz0AGOwBvIBYlR9KrOVf2Q1RdMjzeeUSWsnI7I+C7DcZZ01RtFMfbZJiPBS3v9L02yp6qKlcGCgPQCtoQWpVvriPnVQ4+sS0IRjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010380; c=relaxed/simple;
	bh=Bkg3CTNCQ53SflcFZhAT/qAZbmFa2DlcWPyi+1zhLpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d4BkPss5Nsf9AfpcP3s/XkwPcpeYwtknVRoelWic7IdMGK3b2KS4v61GALLPCru0X0xD4SHhkuRbZeWMDK9JfpVG/InxGLiTIMNHbm9DBlZ6GGiEgUmAaj4bqA3Le/pubgqQ+3pWrjFy8fNW27buge8KOR2KsYMZ8fLaWiUzzXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ah53z44l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ah53z44l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDAA01F000E9;
	Thu,  2 Jul 2026 16:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010379;
	bh=WIHqj+5VYWd6gCmYmxT1aDHx1AFSpn+obx28Zx3NxDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ah53z44l2LZGguzzz5nEgv1bD0AkeHEM0Uatam9DXTPP2KgcorvoXnhAgkC6//Umd
	 sRldyK2WwVPTAK35Dk5XrTBcF8KhNBQul/r642uP3S6Ownc1yCha6LhQeO2qtifidO
	 oJke0MDtz66yUUBA2o9CXGTQs7AzyNPJi+mrcaNc=
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
Subject: [PATCH 6.12 087/204] iio: adc: ti-ads1298: add bounds check to pga_settings index
Date: Thu,  2 Jul 2026 18:19:04 +0200
Message-ID: <20260702155120.490586150@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


