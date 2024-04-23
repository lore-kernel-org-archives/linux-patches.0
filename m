Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3796414388A;
	Tue, 23 Apr 2024 21:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908478; cv=none; b=K29/lklUyhHD2R/PxMLwYRkBApdPU5nTNiHJWzOegSgWrifk4s3Y98O0B029fkc8VVw7EGo+tmsKR/HoZ7XO+pvtrCNKVpSzN+y6gJIEEDhHDMMOybYZG15Jfoom70QjS3caV5EcuM2jJetSz6jau6l078tvjPzP7r606fNw3bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908478; c=relaxed/simple;
	bh=muykViqdHxRq4mEuLU21icDJX1nhi5XMc7xGUguUvgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pkIZv9eqTQEgnSOi1tKbizPhVdIBGLKIgLHfAqIJ3T1PXueY2Fdkv66DEfScjwAC5W3XEyNbwRODb2IdlEr1eDvpP+ZMCwcD++dAW2CUiZlgBivJyIbvRgE+wZmobjpAKKy1UTJEC+fnZVffPb+GYxzo3x3FVUEn/9q+88yqA4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pVZBkMct; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pVZBkMct"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AEFCC4AF07;
	Tue, 23 Apr 2024 21:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908478;
	bh=muykViqdHxRq4mEuLU21icDJX1nhi5XMc7xGUguUvgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pVZBkMctVduONLDZksyTIZPqFB3FZUqOm0DZ6iozqL/WrZxQkDqLzIsX5xOEAlrsc
	 p2jJfrEZBYPxJXGuCxgSisW+Q8n85FCI9GW3D6p4EDXKHYtLNU/DFLIM53MIPCSmCo
	 Glqp1fDswNs7folBoj4VLjMJC9NFYnH3/O+n+LP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 046/158] gpiolib: swnode: Remove wrong header inclusion
Date: Tue, 23 Apr 2024 14:37:48 -0700
Message-ID: <20240423213857.407527367@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 69ffed4b62523bbc85511f150500329d28aba356 ]

The flags in the software node properties are supposed to be
the GPIO lookup flags, which are provided by gpio/machine.h,
as the software nodes are the kernel internal thing and doesn't
need to rely to any of ABIs.

Fixes: e7f9ff5dc90c ("gpiolib: add support for software nodes")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/gpio/property.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/gpio/property.h b/include/linux/gpio/property.h
index 6c75c8bd44a0b..1a14e239221f7 100644
--- a/include/linux/gpio/property.h
+++ b/include/linux/gpio/property.h
@@ -2,7 +2,6 @@
 #ifndef __LINUX_GPIO_PROPERTY_H
 #define __LINUX_GPIO_PROPERTY_H
 
-#include <dt-bindings/gpio/gpio.h> /* for GPIO_* flags */
 #include <linux/property.h>
 
 #define PROPERTY_ENTRY_GPIO(_name_, _chip_node_, _idx_, _flags_) \
-- 
2.43.0



