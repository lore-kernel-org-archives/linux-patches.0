Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052968;
	b=oP4mT5H6Cy58E0tHcUrg2BgxfPoj2ho3na4DR+gOfPSpOwNEjn4JJ4i/K5Q5fBqhXN/H
	 1zxtT7tgCPUZmV4HTwi6v7b1IDMy9l6TSyvX2PTPwBUb8wAww/cAHx2JqiC8R8qW+c8PT
	 x8HD/hJM/CxGBGLEQQZReBNrjcFFN4gXiixgIPbagTjzEUO/7jNssIZ3dOLRVFpf0P4Nb
	 z8fVO1qZk1GvD3VglWLjhPYaIVVpgruzoiqs4QJLwKCv4vPkR6vbD2zIFgH6TB4Nsw++B
	 BL0UzmE9SrFIuUDG+Wv57yjrkxY3n+o+KjW7H+125GWOvHL88C6WFT3Rjkeg5nLzNsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052968;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T2u1N+hZr4uKwrNhFMzSO90zqlg8dzZiD5aB/8q7RQM=;
	b=C/n02TGaErsj7Ff4sfH4UPM64ecBLQOkcTVMkqhG8pSkMVBruyFbS1QQSxpK6iBFM8AI
	 eW2Bo9efat3nda1CA3ZaTj3XinS08bMR4OaePlT1eTPifSVPpSVel+0ObfdNEk+z6dkEb
	 R/DiqQNbdnSz65ZQ4y8bo9hZOCpRWMFrl0vtmoZdZaVcEjOvzGc+wpjRW+n7DV6Tgym9B
	 Ffpaf5wTMiWo5wgJIYvUuyG6aSTTaxszAFFLqCACdS0UMytBtqMazNpRAihe6RE7D/171
	 hG4L6xmh9S3MMZU47/SJTwebawFULPfrovpdF2BSvj81guhx5hO2Cr9yK4P5HTeQrpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mBKAuc1j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D793606A325;
	Thu, 19 Nov 2026 01:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mBKAuc1j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE1FC1F000C4;
	Thu, 19 Nov 2026 01:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052968;
	bh=T2u1N+hZr4uKwrNhFMzSO90zqlg8dzZiD5aB/8q7RQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mBKAuc1j88ETjHKxlvh7IMA1/FI1eDoBiJqCLPN42blwQ6ABINoxMVdVQOoE/TRjk
	 qVKNTsKJTS7x4ouhNp8vcyoB0u1QxURBIjP7ADRdG5dLhNtxkkwD+ilPCAxn5qIVV6
	 SLIctf2exOPza0rsD3ZrBdQJvmuv5GOvVma16Sl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0752/2214] init/bootconfig: pass init arguments in documented order
Date: Wed, 18 Nov 2026 15:40:28 +0100
Message-ID: <20261118150041.846847909@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit 278b2abf660a3e0991eb9f16f11bd9e9514a286d ]

start_kernel() appends command-line init arguments before
bootconfig init arguments, while setup_command_line()
places them in the opposite order. As a result, the
arguments passed to init do not match the saved command
line, reversing the intended precedence of options.

Parse extra_init_args before after_dashes so command-line
init arguments are passed last.

Link: https://lore.kernel.org/all/20261027073719.4010659-2-thnkslprpt@gmail.com/

Fixes: b66fbbe8d482 ("init/bootconfig: Reorder init parameter from bootconfig and cmdline")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/init/main.c b/init/main.c
index c86df2005204a..fe0edf6d9aa7e 100644
--- a/init/main.c
+++ b/init/main.c
@@ -953,12 +953,12 @@ asmlinkage __visible void __init __no_sanitize_address start_kernel(void)
 				  __stop___param - __start___param,
 				  -1, -1, NULL, &unknown_bootoption);
 	print_unknown_bootoptions();
-	if (!IS_ERR_OR_NULL(after_dashes))
-		parse_args("Setting init args", after_dashes, NULL, 0, -1, -1,
-			   NULL, set_init_arg);
 	if (extra_init_args)
 		parse_args("Setting extra init args", extra_init_args,
 			   NULL, 0, -1, -1, NULL, set_init_arg);
+	if (!IS_ERR_OR_NULL(after_dashes))
+		parse_args("Setting init args", after_dashes, NULL, 0, -1, -1,
+			   NULL, set_init_arg);
 
 	/*
 	 * These use large bootmem allocations and must precede
-- 
2.53.0



