Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A0A264FA0;
	Tue,  8 Apr 2025 11:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113522; cv=none; b=Y3USj26UTHlAaHyTCsS6v238lkzzXVjoKTQLrOGAthPJZAUu/lC6zyOsvwrIJ9fOlZog4lCVHl7LaTMzjVWCp5zHApGpBP8ggq3NyYA30UOxOEiSKw3kdd0nHAPcDMnFfivWaYQw6gsD25zCSKfZXTMYel67dO9KDj51QirdfKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113522; c=relaxed/simple;
	bh=QrI4z0mD59KYfGC/FCw3nqroxQ7XR3r4LsWqIwDM5gU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QI/KZxahDB3fuVyfSfoPo0btNsulLW4jBIQ8WMqRHwH+tlbGWWCumlDcSOrPRMdbgQA6k+8ywyXPc0iNveuI9P4eD0/fgUUWyOlc+AHDNspLfoWipE0RYPaOWGNeHFhmL27r0IIFbYNRpJZDzRhDoyoQwKUfZZ/V3a9nFJDZCNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AQHypo8q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AQHypo8q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51B9C4CEE7;
	Tue,  8 Apr 2025 11:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113521;
	bh=QrI4z0mD59KYfGC/FCw3nqroxQ7XR3r4LsWqIwDM5gU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AQHypo8qpo4NS0TdrZU7CaUqpeZ4I7JiKh9Jg5IcHAUFdO7xGA+442sgzO+WnBg3q
	 8vMCIwSa0HHFgEDvIbgmCaT9WjLvdDWdoIcuVfyGnypKhF88n3MULw0eD9kSp1XAYV
	 6E41v6KM6vef6ry069pKcUzY0vg/YUpiCUitAOAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=E8=B0=A2=E8=87=B4=E9=82=A6=20 ?= <Yeking@Red54.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 153/268] LoongArch: Fix help text of CMDLINE_EXTEND in Kconfig
Date: Tue,  8 Apr 2025 12:49:24 +0200
Message-ID: <20250408104832.666131526@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9fd8644a9a4c6..623cf80639dec 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -356,8 +356,8 @@ config CMDLINE_BOOTLOADER
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



