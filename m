Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939D628A1CC;
	Fri, 10 Oct 2025 13:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102553; cv=none; b=Pr6o5UlGvtPpOLbfwD8CDsjh1j0aXLtAZ2LZ2cQmK0s/YKGA2m3DS6AEWGJUBWfg6gOHGAIDFR1ikMqYDY7TB5zLTxLcV4Aztph/CqGxQXgPcR7q5cMzL7rhjb2/agy9dtsFLSl0mSGVKm7lvu7kbaKiqW8lK/NPuIZKOJTaDpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102553; c=relaxed/simple;
	bh=DbOffwnFqxyKgI0gpKLMHpcWyz4sSR251QpSejwP+yA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f9a0WTDU+LzbCA5OUQUuq9RnRKSnTElVze26V2byHO0pmzymtgBTL1QyKcp4X2L0phDcBA8jcxiyTN56juMcDwTjPHc2X+SrUGjrSCPZVissjH3t1YEfHvjTRQtySfVOfN3hALifnuD4BxQjNH14zyEUrfS1YXATRUbxizGR8zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jXtLwpjh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jXtLwpjh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1002C4CEF1;
	Fri, 10 Oct 2025 13:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102553;
	bh=DbOffwnFqxyKgI0gpKLMHpcWyz4sSR251QpSejwP+yA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jXtLwpjh4eCLn02mUEb61YhGfpfIF2uAFkJ8gB6omtI+aVYTBHHaxxSV8WF+TVmsV
	 xH/G5qe2HkzhTBcAPZx2ilu1n0wHuWZouzFUOgwoyX9DaoxBzvjGdU1Urv2gEf7dYS
	 RTMpgq00J3a8KHZf7fniUWOAUwgCHrIBemHSjZpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
Subject: [PATCH 6.6 19/28] serial: stm32: allow selecting console when the driver is module
Date: Fri, 10 Oct 2025 15:16:37 +0200
Message-ID: <20251010131331.063769311@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131330.355311487@linuxfoundation.org>
References: <20251010131330.355311487@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1405,7 +1405,7 @@ config SERIAL_STM32
 
 config SERIAL_STM32_CONSOLE
 	bool "Support for console on STM32"
-	depends on SERIAL_STM32=y
+	depends on SERIAL_STM32
 	select SERIAL_CORE_CONSOLE
 	select SERIAL_EARLYCON
 


