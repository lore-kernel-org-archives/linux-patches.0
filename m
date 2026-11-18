Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037228;
	b=VhFDORF+jozXxMttDGB5jH7PsiVfq8heuVqYB+yO7YBkljHNhVA+pNnhPkLqM68l0d3l
	 3TDH+LKrM+BUsh5rShh896l/jSGhpz1SpxZ67x7egpNkXolKIczbwkcRsXJN4HxukpCcA
	 VFY4Uq94gFGsdm1Ph2Np4eojh/HCwFixy3Qy9su9+5O7MKKXtv7ZQH2S1hO0ylmGpbx8a
	 7BUOftd0HYOJ9r3Hq696mb52mBUnuJ+JMgzrvkWFeoC8VTdeEGSyH+SEM6/DYTkyFnuPL
	 D2t9fUm+C6rNF9j1OzHsvHKuWciYmp+yPsoiAofdox8FlFJXF++WzO2vOvrAe/FeyeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037228;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V+gjFMTGFRbYTK436bpxAvjhQIiPnjAGUNCEMhWCoGg=;
	b=E9BpHYJEA8hbsuKZuLc/b0pksuL6690dUwZlGF4vhRcL0GwGRyaxN308u4SN9mhKGOJI
	 D15gUr3hq0Q0Cg/nwyWHwxRgJJr4OKO+1p0I1PH0pXvzU5YVxEccb8/wIxy052oOpiWMz
	 ydqQJD93/6cGbnaPGEXntmCwiOsgKHQB2tAcAPLyHpWCFu+yOdZ8opKoTp1KsHD55bKr/
	 4oGD2GFtVccA02jzGLPbG6uvYBRszJ18ub2uV9OH2WZtPeIOIuqtz9nS5sXEZgKjNG2p8
	 EfYU6W6sXjpueHqPy+PzhdbxwwYJl4MHfc2/gVvr1QNEp2O1FxZiyF4ueiEDnQ2qBRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MSpGWaxC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC94606A339;
	Wed, 18 Nov 2026 21:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MSpGWaxC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6719B1F000C4;
	Wed, 18 Nov 2026 21:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037228;
	bh=V+gjFMTGFRbYTK436bpxAvjhQIiPnjAGUNCEMhWCoGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MSpGWaxCrjUJBbcfde9jD6ysEz1uxMDSjBGjckAyg032Hwgr1noDq90FYEE2EJ2qG
	 e9jo/j95EvXiMn/mJm+NpdoFtNokzAfww3QmSnvd3kIR0tBtH1UgnnZeHq6VvWKNFW
	 fR3iFxbGHXzlJp0ATsOossZFLjgVmFDIvEMRkD74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1293/3318] init/bootconfig: pass init arguments in documented order
Date: Wed, 18 Nov 2026 15:31:55 +0100
Message-ID: <20261118150359.057544832@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0598d6aa8be82..e7b171527a1c8 100644
--- a/init/main.c
+++ b/init/main.c
@@ -890,12 +890,12 @@ void start_kernel(void)
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
 
 	/* Architectural and non-timekeeping rng init, before allocator init */
 	random_init_early(command_line);
-- 
2.53.0



