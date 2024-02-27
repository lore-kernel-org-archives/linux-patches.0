Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6309413B2B4;
	Tue, 27 Feb 2024 14:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043846; cv=none; b=jz0ZzmHbqAl6xyT2aNXrPubqd/Z6C7e6PzXTKxfbVO/OMhUfIBtjlwCTEj7FpODdi9qaREXijKn9fcqCvcUJOY0r8J9j1znMOItk22x1VyZ3EksqGoKP6PxR1/BGg7QwdxbRVkX149frlxhgIL6gJbV3+G4jVYA6jmHX4jeLvqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043846; c=relaxed/simple;
	bh=Gbxa2yJmpQc241Wck8c/OdIGNq6rl5WUasbbwE4Xb8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pe46SNgJNko8opZoI+su5K32RpbB+r/z11QdMdu6L712gqHH+Rrt8Q6ODp4pqAaCAdiNjAZ0jyjLIXrhlY1RGMVdQz33UZRMKpNjR6MPgOKewdhPNCPo06AwViGaKYMMb9eDkg74dpMk9OCRQvQwNUnQxzNT1PSZf6/NxVIx/3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nwm6vdw7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nwm6vdw7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F0FC433F1;
	Tue, 27 Feb 2024 14:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043846;
	bh=Gbxa2yJmpQc241Wck8c/OdIGNq6rl5WUasbbwE4Xb8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nwm6vdw7X+unWAJVI6N+svjDCs1476sWCCIORw0lsYVXC3lNqCks9hq2AYyr/yzjm
	 lc8629h1lyU1THnasjaI1iXmLiR1wb2rwfHxnjfbfqYfI6foX0R2G6f0PxMHiuk7Vb
	 QCwELruukEl8l2AQhMOUpBM883VBgWAxYaCaGPtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Nikita Shubin <nikita.shubin@maquefel.me>,
	Linus Walleij <linus.walleij@linaro.org>,
	Alexander Sverdlin <alexander.sverdlin@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.4 58/84] ARM: ep93xx: Add terminator to gpiod_lookup_table
Date: Tue, 27 Feb 2024 14:27:25 +0100
Message-ID: <20240227131554.759821590@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131552.864701583@linuxfoundation.org>
References: <20240227131552.864701583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -337,6 +337,7 @@ static struct gpiod_lookup_table ep93xx_
 				GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN),
 		GPIO_LOOKUP_IDX("G", 0, NULL, 1,
 				GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN),
+		{ }
 	},
 };
 


