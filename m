Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4402DF137;
	Thu, 16 Jul 2026 13:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209220; cv=none; b=se3s/WgHIWsudObvKOGQrCrrlv0XC/g+Qr4t3TUbGXPdLS4JDdJpgFwBhO/QxtxQ5/lW0eUxdwrAcjzrbzyregqe/Jn9BLH6eREj1c4tqAR/VWH49bXCsRrq8dQIdVAjS0PH/WdTiDoTgwmXwuFEjJ2aReAsXfhyPCbmvLt4GPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209220; c=relaxed/simple;
	bh=uUxQZpYHj5OpcHYEzi5TmvnqdboDUv0nnB+i1zaD17Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ixJqwvnhYZCYPOPXLPoqVmUxpwgqss7uuvM8HhgdRVSIryQrDyfSLPC+7VOEulmzjtN+R20x7aXVn2pvdF4eA+V/w3TD/3Ew8gB5CS4efygynB7ppMVv2DYpqSA3oh3Qc63oa5L487v4CI9xtce0OYgZYBL1h9dD0CdWE6Mh0E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FAGLLkJ0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FAGLLkJ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5955B1F000E9;
	Thu, 16 Jul 2026 13:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209218;
	bh=dnaXz85+Xjq8mNZNccG/ObxtdZEPqX1+iqMujME4QC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FAGLLkJ0/X0vKD67qob3psymO9/apPW9hzXHkCQPhZJp7b+E4CNxOnLfjomLS3Rl2
	 94nfYmzW0HD5nuAC64+cWG71W0qGTYJ9tWqI5dJBJ4dsNSm9omtN48Yro2DNcDn6n0
	 pzQvQi8mnU1TUkb9wQK1colwKvgMruN4hnX/5QTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Crt Mori <cmo@melexis.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.1 075/518] iio: temperature: Build mlx90635 with CONFIG_MLX90635
Date: Thu, 16 Jul 2026 15:25:43 +0200
Message-ID: <20260716133049.426900386@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


