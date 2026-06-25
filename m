Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0A92E7374;
	Thu, 25 Jun 2026 13:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782393134; cv=none; b=kx2J9UTfDlNinOADDUyjEdQRbLf5N29CmOJOuW23oZ+nVsa8biIbfZm+H1dFlA8b8ZBp9VaToMKoz+vS2u7LtR4FLL1/NZNFRviAUn0QZQLfUw+gVXB1KBHf/15bpQ0NgiZhla4N+oZU3xiaZ0SAbsKiErgPBe8d0jc3X0BinzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782393134; c=relaxed/simple;
	bh=5iddZ0CxSutvJLVaB3uq9jnn6NtUnk2qKzOrasc2dW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VympITUOej7Ibi4dbx6+8fo4hFW4CDR5WLPLt6QNKvK6eIK0cOIX6pgcTP7YikG+20yiJQwb7+6htR3eE9JbEBGHFLBRUPbYE/QvJ6GqGCjmAkH2VR4j9nxvQqqY3toc8mh/wBH0Pf408DU4MI+BRcKiJ8JBodUPKZRcLukOglA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ze6p1icP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ze6p1icP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED28A1F000E9;
	Thu, 25 Jun 2026 13:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782393133;
	bh=pofFyXXR7MljxuiFWNhUWZvXjrAeahp5lcfeE0XioTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ze6p1icPkt7Of2u1fBuI//bxb/4bxn4zChW1/sRztG5EX4bWfe4XtLCUXUlppshrG
	 9CEQF3Nrk+bNLR4l2kbv4oiEOaTiXslS3pey9h6SK12uNNeo0oVyICXQzgDL3nkQBH
	 MGelA6B27gawcw7Rknar31GwbSyp5m+nM0Ed2qgA=
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
Subject: [PATCH 7.1 06/21] iio: adc: ti-ads1298: add bounds check to pga_settings index
Date: Thu, 25 Jun 2026 14:03:58 +0100
Message-ID: <20260625125614.113828252@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125613.243729608@linuxfoundation.org>
References: <20260625125613.243729608@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


