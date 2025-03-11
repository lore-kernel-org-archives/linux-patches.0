Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB2A725E813;
	Tue, 11 Mar 2025 15:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706780; cv=none; b=qC53oHzfdp/djOAJCJXpWZkODcoHQqSJmkx0CvqrV7s5f20twpWgI8DP1zIRVTq8llXj76vCesXpPFh6nTX7mU6M1VFHChn+tE4QpeRSOGFErUgOnsrGyZBX+UeXezflSkKyqHd61VCimUbVPKvA8PYKcvwzJxXTyuZJ3x/AQyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706780; c=relaxed/simple;
	bh=ji5iaIhy0bwjtz3gWufLx9UVU1L6ByZvwccEpHVMxKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U+Xi16z3kjNsr1eHI1MuhfscChAEJazhWeHtTifqtknH/POJYDjFPByUX2r8rxSQGZ156ULON2/EzxXIFZZV+vTlw66GTuCj1mVqJRQXwFT7LEUUoG5K8mT8A2LKej+0ZwrsjZ2gkbzWxuSIOWthkGIddhGvEc0Q5bZF+6e74DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WoMkdwaU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WoMkdwaU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730BCC4CEE9;
	Tue, 11 Mar 2025 15:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706779;
	bh=ji5iaIhy0bwjtz3gWufLx9UVU1L6ByZvwccEpHVMxKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WoMkdwaUwf4Dr/EV3MO8RAB/wzHEU3SajKdPaF90STtHt7mv0EqIAXGzFAVAgYEfN
	 +8JTRvCNK+vBzaDtb6hsRgJDyOpE/cvzIrT4zXrHOPwXC46KwxtN7yLavvzd9SKV7q
	 LBMshiCuzuCV3KWegGDKCXZfSOTZ4AFTJMw4J3fQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 5.10 164/462] leds: lp8860: Write full EEPROM, not only half of it
Date: Tue, 11 Mar 2025 15:57:10 +0100
Message-ID: <20250311145804.824665932@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Sverdlin <alexander.sverdlin@siemens.com>

commit 0d2e820a86793595e2a776855d04701109e46663 upstream.

I struggle to explain dividing an ARRAY_SIZE() by the size of an element
once again. As the latter equals to 2, only the half of EEPROM was ever
written. Drop the unexplainable division and write full ARRAY_SIZE().

Cc: stable@vger.kernel.org
Fixes: 7a8685accb95 ("leds: lp8860: Introduce TI lp8860 4 channel LED driver")
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Link: https://lore.kernel.org/r/20241114101402.2562878-1-alexander.sverdlin@siemens.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/leds/leds-lp8860.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/leds/leds-lp8860.c
+++ b/drivers/leds/leds-lp8860.c
@@ -267,7 +267,7 @@ static int lp8860_init(struct lp8860_led
 		goto out;
 	}
 
-	reg_count = ARRAY_SIZE(lp8860_eeprom_disp_regs) / sizeof(lp8860_eeprom_disp_regs[0]);
+	reg_count = ARRAY_SIZE(lp8860_eeprom_disp_regs);
 	for (i = 0; i < reg_count; i++) {
 		ret = regmap_write(led->eeprom_regmap,
 				lp8860_eeprom_disp_regs[i].reg,


