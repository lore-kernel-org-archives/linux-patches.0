Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38C32676E1;
	Tue,  8 Apr 2025 12:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114931; cv=none; b=TIQqjVVwk6zs2b89ocmNnDjQ55W9hEa2q7M/WJcTyt++7i97A0bW7rNArQUwFY/8xNTlJfylao9Y8DSy79iecAsQ8c+SEGIPD4g7P3OEgZzj10KOATBMX00WhUB/7egcY+4I5IareNdMKMTJzYLoMf+5YbSSdLwUraIktcuOkGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114931; c=relaxed/simple;
	bh=FA6HJlGMTAy0qzPu+nCoXuPenDE66fsLQ1E8j3FGHXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lFlVxdImkbnZfLPrsQ2/u8QmmQCQ72icqkT/C80LF7k2+779Inm8JK3SM+XTMNA2i2AP8hJJEeCYbr5eXcUSgWsgp+RQnqoh8Z42oCb4/aVdUWgYDeair3zi07wLHAF4AxNushGecg0XEoMjYJb4Q2ZYm2sWxuQamptUcMSBP7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DpwXyICj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DpwXyICj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52FC3C4CEE5;
	Tue,  8 Apr 2025 12:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114931;
	bh=FA6HJlGMTAy0qzPu+nCoXuPenDE66fsLQ1E8j3FGHXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DpwXyICjzgr0d7MmlVSWYHmM/FQSUSUV7BMHQZLvC41PqJZgw8peUHmh8dHUUV+Za
	 YAhSSAZb5f+TJUkeB5A4HMcSTv+Qx0wTsAty7R8MJLQ2KlrGd0N0jfNhMngJUuT5Rd
	 oHXlLjV7FhqFAu+j6suTpJkpbdgUkZoWZQZkf7Og=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=E8=B0=A2=E8=87=B4=E9=82=A6=20 ?= <Yeking@Red54.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 287/499] LoongArch: Fix help text of CMDLINE_EXTEND in Kconfig
Date: Tue,  8 Apr 2025 12:48:19 +0200
Message-ID: <20250408104858.373161671@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: 谢致邦 (XIE Zhibang) <Yeking@Red54.com>

[ Upstream commit be216cbc1ddf99a51915414ce147311c0dfd50a2 ]

It is the built-in command line appended to the bootloader command line,
not the bootloader command line appended to the built-in command line.

Fixes: fa96b57c1490 ("LoongArch: Add build infrastructure")
Signed-off-by: 谢致邦 (XIE Zhibang) <Yeking@Red54.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index dae3a9104ca65..bcd22ce00af2b 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -378,8 +378,8 @@ config CMDLINE_BOOTLOADER
 config CMDLINE_EXTEND
 	bool "Use built-in to extend bootloader kernel arguments"
 	help
-	  The command-line arguments provided during boot will be
-	  appended to the built-in command line. This is useful in
+	  The built-in command line will be appended to the command-
+	  line arguments provided during boot. This is useful in
 	  cases where the provided arguments are insufficient and
 	  you don't want to or cannot modify them.
 
-- 
2.39.5



