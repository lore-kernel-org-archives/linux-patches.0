Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7658D233737;
	Mon, 10 Mar 2025 17:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629539; cv=none; b=hUmNbidkV8R87RR0ftW+U2Y27QshoRTu8x4tKnLNaQJh6/hc8SF+art0eL4bc3BF5H438qFmDkpUOoq8LJMoh8ymHcj9BJPaYDNq7hdeKJQao/vUJdcp0GRYqlWAWbYj8F5+NM5kN5ly6AZFLg71t3oX1IZiPDKdJ9zI7eaQgvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629539; c=relaxed/simple;
	bh=wsh+U3oBNRUiPBecAOLjz8IHxx7308Nxi0ME1YlJ7is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PSAX3YQt/1fLwJXPFfYSSc4fbNrKxvhppxzbhWRxJD0T8YJWCFbGGJD+wl5+hcA+bz5Wx0lP/49L/KJEQzXxqjWW9Xx6IiJD+fSDOhy9aXNU8UXmeU30XCvGudiJSkyntkAqkxQb5iRUGfmQybLtM36Xg0B6VGsgSmShqkfy6Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TWxHuKv4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TWxHuKv4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020D8C4CEEC;
	Mon, 10 Mar 2025 17:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629539;
	bh=wsh+U3oBNRUiPBecAOLjz8IHxx7308Nxi0ME1YlJ7is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TWxHuKv4y7nnToHa1XF0yI/aL1oEgOj8FYKLIlWzzEDb34F11GGD6Mp7UDcGuF9cs
	 ci2fQWIugKMjlq7wTlxV3q75/IuK6RxAWmzrnS4n+gg+RWCdKXH2pu1xKL3fn84m9F
	 mpEWtPrmXYZFC8mkmgpktVIFGtMzb1+c6NzWK8RA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Michal Simek <michal.simek@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH 5.15 330/620] gpio: xilinx: remove excess kernel doc
Date: Mon, 10 Mar 2025 18:02:56 +0100
Message-ID: <20250310170558.629962494@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


