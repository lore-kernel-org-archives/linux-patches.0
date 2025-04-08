Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF2E1A2860;
	Tue,  8 Apr 2025 12:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116710; cv=none; b=AY3MOEi/1eBNsWsRn4GLtm9Z+91RW9OGzQvrCZ1w5fLY33DkYCpcuCOhr61P8BOHr/Nu44EUWUAnLY2aqDOdOsSVHdh07/AHmCCjzXUB2FYVWblf3/10Inw4txZYbklSp6xcMUG+qzdFikZEJOl3aP/zDq+4zOZEF//QPiz0VOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116710; c=relaxed/simple;
	bh=hq6uLfz0ovdwU4oead3+YI7+Zcn93FPSwXsW1uPAiUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZT8pqKNqmbEVp5KDYLZyetRYFSLNI2RUQWXyq/vNC0vUHmX1c2nQ0BzfmuGlNsdpsmsJF54ZlWZMvxlUQTCaAkfmfoimkLRlx2nLk0UGg7YW/uaZxKhHdHtNVXc/xudqX+nVojjgwxnF12ZPKh/6pxLuejr7z06zRVO3Y//MypM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OR05np+y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OR05np+y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806D7C4CEE5;
	Tue,  8 Apr 2025 12:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116709;
	bh=hq6uLfz0ovdwU4oead3+YI7+Zcn93FPSwXsW1uPAiUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OR05np+ygrzcT2e/HVR27O+Zedm7Oqnm/Mys4GhQj3IH58JtTr1FqC4DyVh0ngpWn
	 AEQPzlEyuaCMe+4IOnf8cjVYY/xyic2ipkn6zrLfBaI6Z1p2pYx3zp5TFJ+GiOPxLx
	 fHaRlVfCPN5paRQiB6NLcy+VY8BCCUczySmk363Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=E8=B0=A2=E8=87=B4=E9=82=A6=20 ?= <Yeking@Red54.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 240/423] LoongArch: Fix help text of CMDLINE_EXTEND in Kconfig
Date: Tue,  8 Apr 2025 12:49:26 +0200
Message-ID: <20250408104851.319589215@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d9fce0fd475a0..fe9f895138dba 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -375,8 +375,8 @@ config CMDLINE_BOOTLOADER
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



