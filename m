Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3518E27732;
	Thu, 16 Jul 2026 14:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211754; cv=none; b=EIE12SsulxxbnNYtinDRZvb52liuwo6ZDb6e2NvFmLpiGdL+Zy8zarhLBJHbvFEZ6WxmxuF8XUaklvzvqr7M4DOnf7PMaXpMFvDQyvPoW8Srst+Tiqy0Cgg7ON6ihRxOWCtkpyJUFVS7mulQREDElHb8nTfuohUXOnTlhmRJ70o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211754; c=relaxed/simple;
	bh=KOKI1cJpCzZWcpFqfBCPpLiFd9MF3Aul7l0YvzdnKgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cmX6x6KZk+ldJLRd7r0orlQjmbsl3se5w4wFWSpRVkAGBh2azAugKalT3Ktk8qrXHX1UYfn79nJrWE2l+YbOqlBBE61vEd7yZUS8DtS+YPp26olthVyyztFkwycKs8wsTnRjsnl05vW8fe3DXcTpiiNfT3hu87WvaWTrxuMxzPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hvPsrF0p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hvPsrF0p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB751F000E9;
	Thu, 16 Jul 2026 14:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211753;
	bh=2XwdhoUhG4iCGo4StKvI7fU/82F8zkjQ7H+8FFfbgmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hvPsrF0phXNqOqpl9fNWH9vWFDeU6mV0v3R2wcoSi5nMiguLoPiFTQwBh4vYFcxqY
	 tAMw3YJD3UeufnyKFfkcuRlzzixIDkqklUHRAUVfMccQEu8uBM0keOL8pIfaUFxtcD
	 1k22tvZa/oAzLi+RPV4zYlFvF3BNyB2tiliGzBNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Crt Mori <cmo@melexis.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.12 068/349] iio: temperature: Build mlx90635 with CONFIG_MLX90635
Date: Thu, 16 Jul 2026 15:30:02 +0200
Message-ID: <20260716133034.843918605@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

commit 63a76e3a587c4143e8e24e8a6b0c232fa0676034 upstream.

drivers/iio/temperature/Kconfig has a dedicated MLX90635 option, but
the Makefile currently builds mlx90635.o under CONFIG_MLX90632.

This means enabling CONFIG_MLX90635 alone does not carry its provider
object into the build, while enabling CONFIG_MLX90632 unexpectedly also
builds mlx90635.o.

Gate mlx90635.o on the matching generated Kconfig symbol.

Fixes: a1d1ba5e1c28 ("iio: temperature: mlx90635 MLX90635 IR Temperature sensor")
Cc: stable@vger.kernel.org
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Acked-by: Crt Mori <cmo@melexis.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/temperature/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/temperature/Makefile
+++ b/drivers/iio/temperature/Makefile
@@ -13,7 +13,7 @@ obj-$(CONFIG_MAX31865) += max31865.o
 obj-$(CONFIG_MCP9600) += mcp9600.o
 obj-$(CONFIG_MLX90614) += mlx90614.o
 obj-$(CONFIG_MLX90632) += mlx90632.o
-obj-$(CONFIG_MLX90632) += mlx90635.o
+obj-$(CONFIG_MLX90635) += mlx90635.o
 obj-$(CONFIG_TMP006) += tmp006.o
 obj-$(CONFIG_TMP007) += tmp007.o
 obj-$(CONFIG_TMP117) += tmp117.o


