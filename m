Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C1C3FE660;
	Thu, 16 Jul 2026 14:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210548; cv=none; b=Jgqr9RHY/a6RaTWtJGz1CE4S6XXdLI2CIxWcV6i0XWOWWWTC0VkDg7wOQRnLYtW7f4GpgO1kI6IvaOu6OTskidP0z0pYx5vPqoYBhQnTqsL7lsEnhkgnm0yGtRm9IY3eCcM/MorSL8Qivr2RqbrS4pE05s0FXDmR8MZFYrPujog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210548; c=relaxed/simple;
	bh=3RAM/b9NJh3ZlYAoIEUnwO3iCtppxiItAD6jHR9WHFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EFKn4hqoT3VG/6ECisHhTUcQUNrKaUUPVh0VjoYrqO4iMfx7j64Q42TbiTCV9FSxeT3fLoW1rb75gsSAaUgJAWcDojL5w3q6FvpU30rWUiyqNcDvacmH0HhuVy9SV6WR1KY8wCaHYNbQH7b5kMS2eQ9ckSm9SwstIZlcZBEkkJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RYXfLxgZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RYXfLxgZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D041F000E9;
	Thu, 16 Jul 2026 14:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210547;
	bh=4AmmeisWKpwpYuz94eojbNA2r/dc2jn1rScGGVPpX2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RYXfLxgZe7bqF94Xvv0R+onjY7T+LP4089NGQblZk07RFmZpd3VlRt88lCAClAxoN
	 BynJ7FnHc5l0BIBVS1cCFSOqhqX2DHCDuPJAqk+nogz+maF00+PYEMQRkJrS/pWROS
	 nOy4xtw0QazMddNnKd6f48UpGsI1hVlC4fO1qDSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Crt Mori <cmo@melexis.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.18 087/480] iio: temperature: Build mlx90635 with CONFIG_MLX90635
Date: Thu, 16 Jul 2026 15:27:14 +0200
Message-ID: <20260716133046.592779627@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


