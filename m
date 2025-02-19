Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7991F1538;
	Wed, 19 Feb 2025 09:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957244; cv=none; b=gQZnH+V8Fuy+jVbW9mikEqiSsUhVcZTbI14+nZtTg6vtyJ7dFK66xydUD8erMexapov5GeIDo9vidRtVqH89BFb+FRMFSPfWShIVDxhSt2tqRzrMutbPsuQ4fbLzuRSAbv6dKm7zDYxScpHIszpQJh5QIqC929AmdrX5fR74rjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957244; c=relaxed/simple;
	bh=ljtprST/1otnMIiHk/ykZlLY5g/BzauPJ6A52KrreM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g7Y0dwS4wGAtSzGCxl881buC5Z/m/chUngk4PV26GR4lJzLq791VlacbjdtFn6BFuD5nF+KvS/Ww4m0Y506gwftSJRsMGCoJJT8ZEDSQ9/Ciskl4+AkxQhOnMycgEaXQ9XHRFCn92Zc4eNl845wQirXqihbJOi28pcLM29B3d5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=opy4Speg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="opy4Speg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7FBEC4CED1;
	Wed, 19 Feb 2025 09:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957244;
	bh=ljtprST/1otnMIiHk/ykZlLY5g/BzauPJ6A52KrreM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=opy4Spegbj/RX7Anq8eH3T+8oCTDx2aFNzzZh6a6u5VaYKHZAsOo/oc21qoPDveUN
	 PKwoJTX+JFAXiRgKpoWaAObhGj6A6DxcTkPkOMpXqqa88XcEU3DsHsm8CA97SlchwS
	 UHnpoXQZ5Q5lqZALVzj4AuA4vMoQMLPHV9Jr3+iw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Michal Simek <michal.simek@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH 6.1 451/578] gpio: xilinx: remove excess kernel doc
Date: Wed, 19 Feb 2025 09:27:35 +0100
Message-ID: <20250219082710.734111263@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

commit 4c7fcbf5077532b80bc233c83d56e09a6bfa16b0 upstream.

The irqchip field has been removed from struct xgpio_instance so remove
the doc as well.

Fixes: b4510f8fd5d0 ("gpio: xilinx: Convert to immutable irq_chip")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202312150239.IyuTVvrL-lkp@intel.com/
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Michal Simek <michal.simek@amd.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-xilinx.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpio/gpio-xilinx.c
+++ b/drivers/gpio/gpio-xilinx.c
@@ -52,7 +52,6 @@
  * @dir: GPIO direction shadow register
  * @gpio_lock: Lock used for synchronization
  * @irq: IRQ used by GPIO device
- * @irqchip: IRQ chip
  * @enable: GPIO IRQ enable/disable bitfield
  * @rising_edge: GPIO IRQ rising edge enable/disable bitfield
  * @falling_edge: GPIO IRQ falling edge enable/disable bitfield


