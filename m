Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5961442F2;
	Tue, 23 Apr 2024 21:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908594; cv=none; b=I+MeB7Y2pkUjc8oyMacvomPRtTop1dHaAeqpqUZHsbV31BZe2LI8I579IY7KyJNX9y9Y6UZ34Sf0mjV8pe6P5NcAERXXrZTXx3dCHwC4XbXC0d8sgFvnCBxTv2c2S0lwx8bv0pZcewJQk26bvLDP/95d5uG9gkmuEv+VaW1hfIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908594; c=relaxed/simple;
	bh=sURxCRx5aT5MMQk9M/GO9jfOCUf7QZt+SlO4cm2EWEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ITw0bu11efyWbye9fLGXGin9mNNw1RWxqc62KxuOrHgaOQHFiWlqx+ChruHRzryxGLbI8ILzVbsuUEgIeuPJGsrPyby2Kc5pLLrj2jCjbXO8cs9gk1hT+ldpV02J4NQgX+YyXsa4qT4+XMCZXQpK2rF8U1GWkQLhm5ZiIPK23Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y4RN/H3k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y4RN/H3k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA48C116B1;
	Tue, 23 Apr 2024 21:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908594;
	bh=sURxCRx5aT5MMQk9M/GO9jfOCUf7QZt+SlO4cm2EWEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y4RN/H3kWCP8scyrCPqpSWBSg1NIFM/um/Y7aY3iEOkGAPFwb3p9YuykbNMw7uWjg
	 4dtqbNpszhYTjpByERDz8iTE2KpAhyljSM818wR+U79Rc/Qw89Yb/Cl35roTtOmOV0
	 71wzeEflO6bXnCe7P4Q6ytoYBdGPc8Kq6/J1un08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 056/158] gpiolib: swnode: Remove wrong header inclusion
Date: Tue, 23 Apr 2024 14:38:13 -0700
Message-ID: <20240423213857.602105871@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



