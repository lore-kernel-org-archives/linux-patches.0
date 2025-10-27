Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390002C11DF;
	Mon, 27 Oct 2025 19:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593364; cv=none; b=XXJgpfpoDQ3SRV3KVtmc62+9N8wfUfUeuZTdbhfa/i5SPenKFAmkDKWtFWnYHn8HoeKZeaj2F92kUXu3inDB1AhkXr976qCemOkYUPc//biU3VF4k/6ToiPOWk5uUbR1f0CZdp+4nIED1biSYFQc3qDR++P0ydpd3sqrbneNGzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593364; c=relaxed/simple;
	bh=4a4xrmfYhShRPY9YZ3JOYMDcPCNzZ33ef24hx1SX5rU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tz82guoxszRrCmGHhWjVSxro6NUQO4eQRIVvRe1HazV/JIcLB0GOHv/bGY5msM+JAfmW5JFMjPGb0i3IBhp8mQNzh9vzrGAcoH2zEDyxD4f1zpOF7eOoXd1vph2Tc6cWZx6Tqm6nIaO1knptHxuAKQ4ove9WOPV2tOZbNhEQ+bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o6xBYI3U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o6xBYI3U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0544C4CEF1;
	Mon, 27 Oct 2025 19:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593364;
	bh=4a4xrmfYhShRPY9YZ3JOYMDcPCNzZ33ef24hx1SX5rU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o6xBYI3U7fWwZvnBKha7wawcxENHCgTizGKeDQpJu4qwUUNSSRwxkwuBGOcpaphMB
	 o76Tix6QKQSxJcYk+wiuB9mECBLgxqV4NIS7I6bGJEhY9hXRd43aK9v70SoyWWSyJg
	 ecuZV3Xm1Uc7rTWwG4gJssKWCq8dFBm/yplVFi6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Cave-Ayland <mark.caveayland@nutanix.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	William Breathitt Gray <wbg@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.17 074/184] gpio: pci-idio-16: Define maximum valid register address offset
Date: Mon, 27 Oct 2025 19:35:56 +0100
Message-ID: <20251027183516.890827221@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: William Breathitt Gray <wbg@kernel.org>

commit d37623132a6347b4ab9e2179eb3f2fa77863c364 upstream.

Attempting to load the pci-idio-16 module fails during regmap
initialization with a return error -EINVAL. This is a result of the
regmap cache failing initialization. Set the idio_16_regmap_config
max_register member to fix this failure.

Fixes: 73d8f3efc5c2 ("gpio: pci-idio-16: Migrate to the regmap API")
Reported-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
Closes: https://lore.kernel.org/r/9b0375fd-235f-4ee1-a7fa-daca296ef6bf@nutanix.com
Suggested-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
Cc: stable@vger.kernel.org
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: William Breathitt Gray <wbg@kernel.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20251020-fix-gpio-idio-16-regmap-v2-2-ebeb50e93c33@kernel.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-pci-idio-16.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpio/gpio-pci-idio-16.c
+++ b/drivers/gpio/gpio-pci-idio-16.c
@@ -41,6 +41,7 @@ static const struct regmap_config idio_1
 	.reg_stride = 1,
 	.val_bits = 8,
 	.io_port = true,
+	.max_register = 0x7,
 	.wr_table = &idio_16_wr_table,
 	.rd_table = &idio_16_rd_table,
 	.volatile_table = &idio_16_rd_table,


