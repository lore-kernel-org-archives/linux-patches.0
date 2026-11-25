Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620724;
	b=i1vsOtj/oYkY14FPuDQxOeokpvFAZcRuXG/A+zhCvLcqWHg3ihOQpzyEINVf1EcqzzMM
	 cJOLRdyQ/ZMIAvoeKHbNcAQDbW7NJSC/+MOTkMh15JIF4EToHVC8UIrRtt/l1ARkpuIGS
	 E2656BbwhT4Ye3Amqw3MvrUUHa+2Xx9WSFiluJbXIiV1EsXwj35/2Yr+EoseKIsl+6E2k
	 ajN93k+lr3BFSve4leG8nj23Q8MSKpqOE4TbHrz48i3RvTsyLT99aMs5SbV5LmPOOFweh
	 XbDnIHwBDmTawWjU3KtBVf1BtdeA5/QljtBgZFMO91FftZVa+dduBipXLwOky8+8FjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620724;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e0hc4ZQKnDUJ60n6zChXE2A9rrhKbkywk7b9C3XQeLk=;
	b=k4zxFR4TzgSqzVMsYTp7n/2XC8TZckOGgiolfVYqKOyoDwb9DR1ulKxCuRlq40L1tSzy
	 z7eFGfpRX/sW+UTHKowT7e8LNIx+3X9N4B9HQ4JxHQnsLNdEz0xrmx2aWGzDLcM+zc/1d
	 RPwx3wM6Vnwv0Yk8n0eEin/AtWjKfcgxOkWTyV862BjU7efSF7WzA26DNF+Ko3Wnv23wC
	 vQYNQHXU46OjNfMy6pZNsMwWIPFXTmFO9wdF8+aRvAFOW+TCHmiJ2xrCKiHC0rt/v5erv
	 uI+buqgZMH4Bqz2WlxRbemf54BegHWZfvVFXQb+0xJy76IUMUiN9ccR+0BxfrWWbISQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Eex0/DIW";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00EF1606A323;
	Wed, 25 Nov 2026 15:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Eex0/DIW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 513211F000D0;
	Wed, 25 Nov 2026 15:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620723;
	bh=e0hc4ZQKnDUJ60n6zChXE2A9rrhKbkywk7b9C3XQeLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eex0/DIWKWOnP8goyG9u7J8kzbSA9GUH7QMGeW14le+XAGdOGYgBvldB9AoPcBdIV
	 HyrLsn7TDVedNAx0qAUoTejiPEU+eIZiIo2cYIdDcyS3n2DWnMnezF9HdQyBD0vVYH
	 EHzec2osNgWnXGpArR3IYds/FYBqN7o+T1Eiu14I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnav Kapoor <kapoorarnav43@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.3 0989/1005] iio: proximity: sx9324: fix out-of-bounds read of scan period table
Date: Wed, 25 Nov 2026 15:38:47 +0100
Message-ID: <20261125143844.823833989@linuxfoundation.org>
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

From: Arnav Kapoor <kapoorarnav43@gmail.com>

commit 7b5f54280f8e6ef07664f6705dd005feefbe87d1 upstream.

The scan period of the SX9324 is selected by the 5 bit wide
SX9324_REG_GNRL_CTRL0_SCANPERIOD field, so it has 32 possible values.
sx9324_scan_period_table[] however only has 16 entries, it was copied
over from the SX9310 driver where the field is only 4 bits wide.

sx9324_wait_for_sample() indexes the table with the raw field value, so
all the codes from 16 to 31 read past the end of the array. The default
value of the register is SX9324_REG_GNRL_CTRL0_SCANPERIOD_100MS (0x16,
i.e. 22), so the out-of-bounds read happens with the default
configuration of the device. It is only avoided when the device has an
interrupt line, as the wait is only done in the polling case.

The value read is then used as the duration of an msleep() call, so the
sensor is polled with a completely random delay.

Fill the table with the scan periods of all 32 codes, which are the
periods documented for the corresponding sx9324_samp_freq_table[]
entries, and add a static assertion to keep both tables in sync.

Fixes: 4c18a890dff8 ("iio:proximity:sx9324: Add SX9324 support")
Cc: stable@vger.kernel.org
Signed-off-by: Arnav Kapoor <kapoorarnav43@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/proximity/sx9324.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/iio/proximity/sx9324.c
+++ b/drivers/iio/proximity/sx9324.c
@@ -279,11 +279,20 @@ static const struct {
 	{ 0, 250000 },  /* 11111: 4 s */
 };
 
+/*
+ * The scan period of the SX9324 is selected by the 5-bit wide
+ * SX9324_REG_GNRL_CTRL0_SCANPERIOD field. The values below are the scan
+ * periods in ms of the corresponding sx9324_samp_freq_table[] entries.
+ */
 static const unsigned int sx9324_scan_period_table[] = {
-	2,   15,  30,  45,   60,   90,	 120,  200,
-	400, 600, 800, 1000, 2000, 3000, 4000, 5000,
+	1, 2, 4, 6, 8, 10, 14, 18,			/* 0x00 - 0x07 */
+	22, 26, 30, 34, 38, 42, 46, 50,			/* 0x08 - 0x0f */
+	56, 62, 68, 74, 80, 90, 100, 200,		/* 0x10 - 0x17 */
+	300, 400, 600, 800, 1000, 2000, 3000, 4000,	/* 0x18 - 0x1f */
 };
 
+static_assert(ARRAY_SIZE(sx9324_scan_period_table) == ARRAY_SIZE(sx9324_samp_freq_table));
+
 static const struct regmap_range sx9324_writable_reg_ranges[] = {
 	/*
 	 * To set COMPSTAT for compensation, even if datasheet says register is


