Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F89A3081DE;
	Mon, 13 Oct 2025 14:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760366950; cv=none; b=SZbgRDSgC7miq4cUgk2wotIxzq7uDi2PCaaA+Mz+poSHwd1uUpGlzlI+lBZKi7OcLCjBNvJgL0ubejkE7FJrwXjBqF6A7KHU45jtDMIg5J11LhkjYjI6HRq0bk1LtpEw6As8hOsafLOH7p/XQ/zwWma1bs/oc0VR/57jLJ5UBjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760366950; c=relaxed/simple;
	bh=HO/PkBfnVrkA3t+1ZDXiUMcgnCHovUGkFRXjrjeJas8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OLxwRl1he2j6EVs7sA0z7qIdwb/Hk5B73WwU4B0Xho+lcvy1DonMEcJBlmqKVcvygwMZh804XMGGxGY0gT11mhsifc/jEyxx+iY9RVMuz9Jzd2l8x6E29WSAE4CLpSqtuV9ps0mEzmsFnkdFttKO/EEop+8DkkQJ+i4Q9w1+pXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IVbIr2N+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IVbIr2N+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B94C4CEFE;
	Mon, 13 Oct 2025 14:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760366949;
	bh=HO/PkBfnVrkA3t+1ZDXiUMcgnCHovUGkFRXjrjeJas8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IVbIr2N+aE4txFzueLgc+CfIcUk3nQY2WU9xqHBLNWn34e9FkJk7m1hOp+1R5FMN0
	 iKdhzxOYPwJjHPv4kiCWczetHYbRwBVAIv9Ls6TAscejrn0+MGn+8PPOMphjz/i0GV
	 dv8ZV5lPD4gYEfpkdoGO8J1iNhLUbn5KUzNs+YEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
Subject: [PATCH 6.1 039/196] serial: stm32: allow selecting console when the driver is module
Date: Mon, 13 Oct 2025 16:43:32 +0200
Message-ID: <20251013144316.000521225@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>

commit cc4d900d0d6d8dd5c41832a93ff3cfa629a78f9a upstream.

Console can be enabled on the UART compile as module.
Change dependency to allow console mode when the driver is built as module.

Fixes: 48a6092fb41fa ("serial: stm32-usart: Add STM32 USART Driver")
Cc: stable@vger.kernel.org
Signed-off-by: Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
Link: https://lore.kernel.org/r/20250822141923.61133-1-raphael.gallais-pou@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -1410,7 +1410,7 @@ config SERIAL_STM32
 
 config SERIAL_STM32_CONSOLE
 	bool "Support for console on STM32"
-	depends on SERIAL_STM32=y
+	depends on SERIAL_STM32
 	select SERIAL_CORE_CONSOLE
 	select SERIAL_EARLYCON
 


