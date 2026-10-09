Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A24334D3BE;
	Fri,  9 Oct 2026 14:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557244; cv=none; b=OZ1tQwWtRcaN8HiN2vPzNgSk8KYfqneh2v4Sg9VVtMqxZs6MYTUIiLQ/3u1GMWbqDKhJbT9jJcx7NCf5FksAXjcCI6lEQpm37GZgETD3vewGLN8Fa1UQ4Qx0ReCSq9s5MOMJvw+5oUMLxaAWuEwVWFipCeD0PGaHWGSvoxmXf5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557244; c=relaxed/simple;
	bh=AQgK0Oa0R55BE1zKlWX9QFbR+V3yj48KYbLNYAdT8Ec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AsJvgIUkzjOWGzk/131cbNtUTI5rHXaSOaafRwA4Cba0SI3rtDNueB5FjYaFW7GmhuAe49fXeMJyNT72T8DtykldyFCnnDvez6M5jSG50xY02tSlmj6ypseDwbv6tYE5ewRseVTsZVuoQzrOUWEbY7ADblxAknPDI5pY0Malssg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gTJ60OdQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gTJ60OdQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA3591F00893;
	Fri,  9 Oct 2026 14:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557243;
	bh=lfJaJCdAHFc1MWg8VsEupDPHcz+um9PGL5bbu3cW4+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gTJ60OdQjqZrbh8ka5MrD/qfACZoRWF+GOc+gZcRGcpi/9KEfzk4p2S13/+Jt3dDB
	 RdyT/yidyO6jJ5KJnctxRM5+gGsY892/fJiQh8Mz4DmzYX0GYrBWlXX6Ao+chtViH2
	 peF8HQ9zyfUitce1Fg2zEi9aEM468CMPwEnQ7b9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Marcelo Schmitt <marcelo.schmitt@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 370/403] iio: adc: ad4030: Use BIT macro to improve code readability
Date: Fri,  9 Oct 2026 16:12:11 +0200
Message-ID: <20261009141000.957164399@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcelo Schmitt <marcelo.schmitt@analog.com>

[ Upstream commit a10f6dd4eef2e64fe1f366613bed45aa308494de ]

Use BIT macro to make the list of average modes more readable.

Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Acked-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Marcelo Schmitt <marcelo.schmitt@analog.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: d61521056420 ("iio: adc: ad4030: fix invalid oversampling_ratio validation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad4030.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/iio/adc/ad4030.c
+++ b/drivers/iio/adc/ad4030.c
@@ -232,10 +232,16 @@ struct ad4030_state {
 	.num_ext_scan_type = ARRAY_SIZE(_scan_type),			\
 }
 
+/*
+ * AD4030 can average over 2^N samples, where N = 1, 2, 3, ..., 16.
+ * We use N = 0 to mean no sample averaging.
+ */
 static const int ad4030_average_modes[] = {
-	1, 2, 4, 8, 16, 32, 64, 128,
-	256, 512, 1024, 2048, 4096, 8192, 16384, 32768,
-	65536,
+	BIT(0),					/* No sampling average */
+	BIT(1), BIT(2), BIT(3), BIT(4),
+	BIT(5), BIT(6), BIT(7), BIT(8),
+	BIT(9), BIT(10), BIT(11), BIT(12),
+	BIT(13), BIT(14), BIT(15), BIT(16),
 };
 
 static int ad4030_enter_config_mode(struct ad4030_state *st)


