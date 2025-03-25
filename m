Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2E3E55B;
	Tue, 25 Mar 2025 12:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905914; cv=none; b=U7LVL/f8O5FTl/1NtexeL1qodQ/N05MLSBLXYWN7mZZ8Y4bnF4KcmnLyT6uXUjCEsEdSRtdvxtFe0ydiJCV2YzWgDy0lDtV+VU8YUYcaOAH3FvpfFV9xMLPOQPIbxBbJrCEUIs9l6iyy0oRziKCmsY/q+CeRjm4GTkjF9UPAg8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905914; c=relaxed/simple;
	bh=X58PrYtU0Dlb5vD9JWHF93POU6T4a7Jfjw4XdwJDKd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GWYszPM2hFUi4uMHEOcuHx6ccqIkGKeCV027K+YLZoM73qmcHj60rOM7PEGRrJmKhPE+3AtxBOJ3lCuXfsTaUyw2XWZoC1JBD2lc5SCdiU7CXGauZmX53Lo+w4EINMXIZKd1fvr6eW7TGIiHIxwlISTYqgAIec5jQ833FyQXVxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wuENIh7C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wuENIh7C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 406D4C4CEE4;
	Tue, 25 Mar 2025 12:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905914;
	bh=X58PrYtU0Dlb5vD9JWHF93POU6T4a7Jfjw4XdwJDKd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wuENIh7CmjuhAjBI8chueoqWVjsfZD4s9V9lcOuioEm7+pyq4wqKHEyG6BUOYZpG3
	 MwYphnhlOcKlCqjaTuyKyLr62GK7WOzbfAiYv8kg6rnjZc9jn0C8TYkYXepmIe/EMf
	 KIcZ1m3EsKaMLHVV9+ZQmxnBJledgZgX5nsrQ73o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 034/119] ARM: davinci: da850: fix selecting ARCH_DAVINCI_DA8XX
Date: Tue, 25 Mar 2025 08:21:32 -0400
Message-ID: <20250325122149.933611938@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit 45d5fe1c53baaed1fb3043f45d1e15ebb4bbe86a ]

Chips in the DA850 family need to have ARCH_DAVINCI_DA8XX to be selected
in order to enable some peripheral drivers.

This was accidentally removed in a previous commit.

Fixes: dec85a95167a ("ARM: davinci: clean up platform support")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Acked-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-davinci/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-davinci/Kconfig b/arch/arm/mach-davinci/Kconfig
index 2a8a9fe46586d..3fa15f3422409 100644
--- a/arch/arm/mach-davinci/Kconfig
+++ b/arch/arm/mach-davinci/Kconfig
@@ -27,6 +27,7 @@ config ARCH_DAVINCI_DA830
 
 config ARCH_DAVINCI_DA850
 	bool "DA850/OMAP-L138/AM18x based system"
+	select ARCH_DAVINCI_DA8XX
 	select DAVINCI_CP_INTC
 
 config ARCH_DAVINCI_DA8XX
-- 
2.39.5



