Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F8313B7A0;
	Tue, 27 Feb 2024 13:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041588; cv=none; b=fUB4XoDVot4n+rcGr8YtS2byikVKaWozf7e46RhOawIsfLhQcKHvEYU3LwoYRN8sFyAoomak36hO6OobVUWVaq5Ev1nJrNDFDerEam0g4MbSKxXShAinsEQL+3gSpKtc7YPPKiL3nLPuVau3WSpJCQRF4y/YYzVYyz83Jv99/VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041588; c=relaxed/simple;
	bh=PCFLJr9hlKzaxCl9comiBXMlkLC1AGkqat01wtgxMJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CMrg7LTXKurQKwEpM1SfF8HdXI8ouIjcG3ovfFwKlfv8aRDYykZ4X9iVMl7PG2prDVbXsO212FYTey8h9Q2xybhckzmUEwWp7VDJ22dXFNlqkyMC0YkEBWT2e2AvnqRRPmq4EqMsRLGXGy8ixhVvkMBzfGwnYpzAeQdbOBH85As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eDhHfXzV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eDhHfXzV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44665C43394;
	Tue, 27 Feb 2024 13:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041588;
	bh=PCFLJr9hlKzaxCl9comiBXMlkLC1AGkqat01wtgxMJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eDhHfXzV1f1GOIJ0Sy7BgLNoaopsyke2sXh8bI6+Ez8oxakKxucZjlVDVTEcxYau8
	 neC+FH2E9epeU4ARJWcUOYNPFp7/Xo/qRLZvqGiC360MZX64z+5QBxO8p8chX8Z9kN
	 STPFi/epJnnkxsttF9N/mOD+4l+doVZRLcAxGtLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Nikita Shubin <nikita.shubin@maquefel.me>,
	Linus Walleij <linus.walleij@linaro.org>,
	Alexander Sverdlin <alexander.sverdlin@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4.19 32/52] ARM: ep93xx: Add terminator to gpiod_lookup_table
Date: Tue, 27 Feb 2024 14:26:19 +0100
Message-ID: <20240227131549.588085742@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131548.514622258@linuxfoundation.org>
References: <20240227131548.514622258@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Shubin <nikita.shubin@maquefel.me>

commit fdf87a0dc26d0550c60edc911cda42f9afec3557 upstream.

Without the terminator, if a con_id is passed to gpio_find() that
does not exist in the lookup table the function will not stop looping
correctly, and eventually cause an oops.

Cc: stable@vger.kernel.org
Fixes: b2e63555592f ("i2c: gpio: Convert to use descriptors")
Reported-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Nikita Shubin <nikita.shubin@maquefel.me>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Alexander Sverdlin <alexander.sverdlin@gmail.com>
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@gmail.com>
Link: https://lore.kernel.org/r/20240205102337.439002-1-alexander.sverdlin@gmail.com
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mach-ep93xx/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/mach-ep93xx/core.c
+++ b/arch/arm/mach-ep93xx/core.c
@@ -330,6 +330,7 @@ static struct gpiod_lookup_table ep93xx_
 				GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN),
 		GPIO_LOOKUP_IDX("G", 0, NULL, 1,
 				GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN),
+		{ }
 	},
 };
 


