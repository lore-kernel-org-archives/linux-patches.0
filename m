Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2779D337117;
	Fri, 17 Oct 2025 14:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713014; cv=none; b=plNXzhmIvYQUfjCio94HpgNLODOk6cEBCNuhLpgp0R02tlDXlXLvHw/Q3nBBMnFbF0M5q0kqrwyNwsKQPxWlaMcbwwJ9o5ngzssYI5a+QRibLBDfdBu7YkhUNGXayaXafIqldydYSc578VMG0dEPbjPZANcc3W9I6h4DHbSPiAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713014; c=relaxed/simple;
	bh=ocWlcLtozkVbtlBz6OGc0ciDuLQC02nG+r/yAGl0aVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BGwSzubj+3qaHAWLnywF9TrtlKoX4JQv2e8T8oCHHLY+bXg39gqXWHpG8egqZROx7nioUgjcY2HCuZNyGRYIjWJlDgLbJLxeUex8xkthzzTSxKADJP66Ol7QLSsHlPZAEiFCf+fITqhB1RmbF+L4p1IYtxOboirA6bVQFYLkb9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rO2Amc33; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rO2Amc33"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4670C4CEE7;
	Fri, 17 Oct 2025 14:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713014;
	bh=ocWlcLtozkVbtlBz6OGc0ciDuLQC02nG+r/yAGl0aVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rO2Amc33avYZkz3aAMlYQHMMjpwTX+YrRVagD9UFWwRV/tHeOyGS/B5taTzYGo2Mn
	 rEKSi/IaZ2S5X1KoNUyhbOvAxIXoGXDaiNjNTD9rL7OhD8Kk0Y7vOuZEJyKxESeeYY
	 Kv4Zhw88ysTjnQN0XRHxHFAf2bFU7HLh65K9Vgs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Hennerich <michael.hennerich@analog.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 004/168] iio: frequency: adf4350: Fix ADF4350_REG3_12BIT_CLKDIV_MODE
Date: Fri, 17 Oct 2025 16:51:23 +0200
Message-ID: <20251017145129.167763765@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


