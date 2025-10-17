Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A31330B1E;
	Fri, 17 Oct 2025 15:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716238; cv=none; b=uAn8zdYf8ewyJkhWtp6h+jzk36oI730ElRXjPL/nFkSdkXrRblqYqjn/ov14LdSsmp2tHsblLo5HG2MJ/l9cHkixcP8AUmo1gmvi6kcR2PUZFWeWgWWR5TmaZXY3oI+IUD8GpSy1gzcNRV51j9oOEiLh5yMQ8MwDkEzhEW/XcbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716238; c=relaxed/simple;
	bh=Iu0usOAScNv8DssVWEu4ti4rc/UtdHtdz+21fteVC0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q+m6yZp1a0BWbswe+hl+GuUb8deOLbE5Qy+eI+9ziVcQi2kL9Rgmzjzau5eiToQ8aztRV55oymYZ9SB4HocUUXB6kzFAmbI6hYyCc6p+leWMjwtAjxGCatk0pFE6uS6akzLb9X47a0amIUmV2TwDM73WMOAPnEssxj75i6VAO2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I8Jk8hvx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I8Jk8hvx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 401B8C4CEE7;
	Fri, 17 Oct 2025 15:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716238;
	bh=Iu0usOAScNv8DssVWEu4ti4rc/UtdHtdz+21fteVC0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I8Jk8hvxXhdqQ3K1eC+8i72lXmDfOEyOqxIjVSQ2A89QZVhnN/xZ4Z7sY/O7LRhfU
	 W20fZc/n37tSAAd8sOw4EyzCqqLKbZh5TbueySYnZ+DJwOnz4G99LPCEORnC/Cm3l1
	 /B92T8IBick84zx5eQtXD2xfZbnWmcuxXf07rVmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Hennerich <michael.hennerich@analog.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 122/276] iio: frequency: adf4350: Fix ADF4350_REG3_12BIT_CLKDIV_MODE
Date: Fri, 17 Oct 2025 16:53:35 +0200
Message-ID: <20251017145146.931220970@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Hennerich <michael.hennerich@analog.com>

commit 1d8fdabe19267338f29b58f968499e5b55e6a3b6 upstream.

The clk div bits (2 bits wide) do not start in bit 16 but in bit 15. Fix it
accordingly.

Fixes: e31166f0fd48 ("iio: frequency: New driver for Analog Devices ADF4350/ADF4351 Wideband Synthesizers")
Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Link: https://patch.msgid.link/20250829-adf4350-fix-v2-2-0bf543ba797d@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/iio/frequency/adf4350.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/iio/frequency/adf4350.h
+++ b/include/linux/iio/frequency/adf4350.h
@@ -51,7 +51,7 @@
 
 /* REG3 Bit Definitions */
 #define ADF4350_REG3_12BIT_CLKDIV(x)		((x) << 3)
-#define ADF4350_REG3_12BIT_CLKDIV_MODE(x)	((x) << 16)
+#define ADF4350_REG3_12BIT_CLKDIV_MODE(x)	((x) << 15)
 #define ADF4350_REG3_12BIT_CSR_EN		(1 << 18)
 #define ADF4351_REG3_CHARGE_CANCELLATION_EN	(1 << 21)
 #define ADF4351_REG3_ANTI_BACKLASH_3ns_EN	(1 << 22)


