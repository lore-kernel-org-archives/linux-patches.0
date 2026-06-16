Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F073D34AD;
	Tue, 16 Jun 2026 17:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632369; cv=none; b=btxL+Fm89y1WerpKnVdaG4aEwYr6bIvGgo6x9YJynriC/wfwRUPCE+rvUu2M4qQqhUwnI3l0ioM9+6HkcNm4Ei5SmgC9YmyFKQZW3ePOmrwsjoA7f6rshzydCnpgN0QxsaIsnjG4unEnA2kPmBbPMPxUS8D33mo2SwrzeYaBINM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632369; c=relaxed/simple;
	bh=pd/VrXF17jtZJxntOiv7JtWdbP/zh0BROScawxpyEdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LulQ/di4Ck3SXRy1iZeZYIMOv89eiIjalexaga826Q+R11Rcf6M+mwumLVg/3h+fK0DTqaMaN3y8fKEp6hz2x3FIYJjY0JSFth9H6KkAd5aP0g36f2nQ6nhjj0GogMI4QDI/Vgc9+KHhCmjxZZnNQJDaLD2XBdAHd9naqR0DZWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a8gxT6ou; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a8gxT6ou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEBF31F000E9;
	Tue, 16 Jun 2026 17:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632366;
	bh=riPhiLl3zeaX1/RJbTGD7ZFY+tT9NvlVmxgY8JkNecQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a8gxT6ouzNouZzrZXFbQZbuqxb0e+BBtb3kEePk+MWNnPdWshaIFOzrGYBMK3NFs5
	 naeiha7fnSvshY3H7I8q2OSUccB+eQ9462CutTUDgOul484EK21p1dKNAEesqO3hMc
	 UF7sbXNa7woC58mjjIMFv9Wvi14K1FPD4YFWx3aQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zeng Heng <zengheng4@huawei.com>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 397/522] mtd: spi-nor: core: fix implicit declaration warning
Date: Tue, 16 Jun 2026 20:29:04 +0530
Message-ID: <20260616145144.648987912@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

From: Zeng Heng <zengheng4@huawei.com>

[ Upstream commit 25e3f30601a368642678744fc8a9b1dce183c7bc ]

spi-nor/core.c needs to include linux/delay.h,
or it would raise below compile warning:

drivers/mtd/spi-nor/core.c: In function ‘spi_nor_soft_reset’:
drivers/mtd/spi-nor/core.c:2779:2: error: implicit declaration of function ‘usleep_range’ [-Werror=implicit-function-declaration]
 2779 |  usleep_range(SPI_NOR_SRST_SLEEP_MIN, SPI_NOR_SRST_SLEEP_MAX);
      |  ^~~~~~~~~~~~

Fixes: d73ee7534cc5 ("mtd: spi-nor: core: perform a Soft Reset on shutdown")
Signed-off-by: Zeng Heng <zengheng4@huawei.com>
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Link: https://lore.kernel.org/r/20220923031457.56103-1-zengheng4@huawei.com
Stable-dep-of: e47029b977e7 ("mtd: spi-nor: debugfs: fix out-of-bounds read in spi_nor_params_show()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -16,6 +16,7 @@
 #include <linux/math64.h>
 #include <linux/sizes.h>
 #include <linux/slab.h>
+#include <linux/delay.h>
 
 #include <linux/mtd/mtd.h>
 #include <linux/of_platform.h>


