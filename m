Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6104E2F25F6;
	Fri, 10 Oct 2025 13:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102299; cv=none; b=bBv/9Nlbmydy7FzmD1/jXV7gOpujLzdozjOBne/gR3U1/FONV1hGu0N5PGDuQ/YKlpBthlJKmWefB7ddS5ORRjzrwouX224Y2aEkr1o1pOrE6iIhJXPTTP6iaDdjhF5JP1fg4a247pD6WKENjWFy2L7M03VTwefZPH42WThsFE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102299; c=relaxed/simple;
	bh=gZbNCzFfNH12lpYMHc4seFl7xBQbRZw/A5b5YQeuw64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MBbleOhcUH+Lfq6RGTJ8zN1Ipc935W63byKvBho2nO3Tlor9z1P+8T0jHf7RuOckqd5uUvue/jmWGt71lBIlAYyG/LdyAibNTAE3TUZM3PZ/T8I1vSCJ4r7PH0KYxiU3q+nR5ZVwp7DhkcEbS+GEQ2AWDxgcuZ9pLau16bulbtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CngeIvyJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CngeIvyJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E01B7C4CEFE;
	Fri, 10 Oct 2025 13:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102299;
	bh=gZbNCzFfNH12lpYMHc4seFl7xBQbRZw/A5b5YQeuw64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CngeIvyJ91CSzM/DKof/VXKQrqP6N8pwL58C/hv0LrbCOj0nIXtxChA86sHuZq1ik
	 oZb/ardclXZGEmzq6L+RxkCac8OeyYtsui4CP/H0lOl83fchs0zHaGxV25neLp7u4q
	 CFpsRyhB8f5QCLiCE/CogFwuLS4KgfxATh2BafjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
Subject: [PATCH 6.17 14/26] serial: stm32: allow selecting console when the driver is module
Date: Fri, 10 Oct 2025 15:16:09 +0200
Message-ID: <20251010131331.728779369@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131331.204964167@linuxfoundation.org>
References: <20251010131331.204964167@linuxfoundation.org>
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
@@ -1412,7 +1412,7 @@ config SERIAL_STM32
 
 config SERIAL_STM32_CONSOLE
 	bool "Support for console on STM32"
-	depends on SERIAL_STM32=y
+	depends on SERIAL_STM32
 	select SERIAL_CORE_CONSOLE
 	select SERIAL_EARLYCON
 


