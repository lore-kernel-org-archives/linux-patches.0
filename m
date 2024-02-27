Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30112145FF5;
	Tue, 27 Feb 2024 14:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044153; cv=none; b=YZu9wkEw9VjHJouh56o7E54sJfmMQNZGq2CKyZKjb35RyhHu654PG5XeYqPfbHSIEwStpD7s8nUy47xIRlcLyswvG26ywMu4ohLF0Ne8Uh/jCXsZZfCWXFFwSNMMftBS3iJ6DkNmBMKZiqNQKbzTHdzFAMJQA5RVo6KJ0nknJAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044153; c=relaxed/simple;
	bh=GZFzKAtUCEuLJIQ9O4/s+lmye2Zqbq510S37oXKsEYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ocKcwQnJlAi+G+LDaZ0IM8kCh0b7mgz47sIx5JNu7ErQHpcfefYpK3NvMlJ9I9tQKus7E6ADEEqyfL6cLaCdonayecNnk8r6+KL+FXxcwnUSyx0Ofx5be76w/EM4U+hkjNHzb3Y5QWGHegmBQ/pZhqwfzej+tRW8aFkIygTSyR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vJX2/rx2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vJX2/rx2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6CB3C433F1;
	Tue, 27 Feb 2024 14:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044153;
	bh=GZFzKAtUCEuLJIQ9O4/s+lmye2Zqbq510S37oXKsEYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vJX2/rx2x2TFZECZFR7mysK/Jqv+6LHtKwPaftC3UFZX9GCa9BK9gapPUFvBldjuZ
	 yPlfr+zlrAxUNc1iy11+lR6z9vBGjurqPzIQ48SP/X47AxxbuFX22nlPCObpAiY/NG
	 ZwNsi/R/u2/lMsomUJBzLdUZtVKPu+pdngTQYPUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Nikita Shubin <nikita.shubin@maquefel.me>,
	Linus Walleij <linus.walleij@linaro.org>,
	Alexander Sverdlin <alexander.sverdlin@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.10 082/122] ARM: ep93xx: Add terminator to gpiod_lookup_table
Date: Tue, 27 Feb 2024 14:27:23 +0100
Message-ID: <20240227131601.391052191@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 


