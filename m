Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623757;
	b=FDKUIx8bzcvJsAUASQtIVertr8bIEmvO+0x2MY0PXC+CsZw7OahoDtoqpBzdgHa589hp
	 1ipzvya7xPvm5LvzTyqVhupOqHL6fHlsMVTrFRHDFN76vQ/no8a4J/Binn5o6CY3i2/yz
	 Yn1iJZ+UHagNEJd2XPWCsAkPjw1i4+rAUUyNuMEFBuKTGIqVdYK0Oo8BP4dTM76XqELQl
	 T9FDUP8Ss+7HDxFPmapuZBdSGAE9JEMAnbaVJO7MG+YRVBr7YVtxSPPfIS9l6N/oijzDR
	 R091gQS1gIRPoy2arSwlnyjHblIZSt8WnZovMrTdSFl3u7jykIt0pZv2knz9JGtllJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623757;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=XQq3JvZTXAhxSJ/4nCrQ9moQCzRATUiklcVf83kMteg=;
	b=WkluKMNtfcy2dCKHXWlcsVxuhTshjzOeRhVaE7FyfrWhjRNgNtWjKqGyveZg5eW59lGZ
	 WKHhvFFfk2Xx9Yo4JwItf4j3pOgDZN0n+FMK5jb26magQA4ZPmsTaXnTSYnOWMgT4KAuC
	 E0nwOux+6xkLOaiMmlM7YDqK5t0m7dw1/d3ecXafvtUJHkBT+jeSI/hhQGdrYzmj7S0uX
	 2pRuqcVIxx3WZbW72u6SqSmcQVYUT0X6i5zVTfJZmnfehE08FEQ57YKXA1Rv3wlwhs8zM
	 SzxuHAeH4yZQzPu5bVeqaHmZ3RyOOVli4LGVrVqzqpeFVVEo9s0mKhLqG+nSsOqWygw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XD+9oT46;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2CB8606A321;
	Wed, 25 Nov 2026 16:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XD+9oT46
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56751F000D1;
	Wed, 25 Nov 2026 16:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623757;
	bh=XQq3JvZTXAhxSJ/4nCrQ9moQCzRATUiklcVf83kMteg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XD+9oT46yrhT/F4R/Xe+mWmSoq8cHdfiHA8Wa6gPzuw8L0Dgg7hSK+l1SAjKw9mk7
	 9BD9cqRZCYrrfCxrk02U9x0M36YRv1JDJAfTSbTl/7YUfz4BhQZVf+R37cJgI6zw6z
	 z5aZx6mcGmYyfYGXDXHaw0rJ98TAPHq1MeZYbQaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sarmanow <as@discnull.de>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 960/990] iio: light: vcnl4035: Fix reversed ALS mode bit
Date: Wed, 25 Nov 2026 15:38:47 +0100
Message-ID: <20261125143844.474593827@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Sarmanow <as@discnull.de>

commit 6bcabc30b89f31e2925647d1ffa5a0e4b7919829 upstream.

According to the datasheet (table 2) the ALS_SD bit behaves the opposite
way the current ALS mode defines are set, writing 0 powers the sensor
and writing 1 shuts it down.

The current driver thinks the ALS is up while it's actually shut down
and it's down when the systems powers it up.

Fixes: 55707294c4eb ("iio: light: Add support for vishay vcnl4035")
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Sarmanow <as@discnull.de>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/vcnl4035.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/light/vcnl4035.c
+++ b/drivers/iio/light/vcnl4035.c
@@ -44,8 +44,8 @@
 #define VCNL4035_DEV_ID_MASK		GENMASK(7, 0)
 
 /* Default values */
-#define VCNL4035_MODE_ALS_ENABLE	BIT(0)
-#define VCNL4035_MODE_ALS_DISABLE	0x00
+#define VCNL4035_MODE_ALS_ENABLE	0x00
+#define VCNL4035_MODE_ALS_DISABLE	BIT(0)
 #define VCNL4035_MODE_ALS_INT_ENABLE	BIT(1)
 #define VCNL4035_MODE_ALS_INT_DISABLE	0
 #define VCNL4035_DEV_ID_VAL		0x80


