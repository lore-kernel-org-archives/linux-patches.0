Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063776;
	b=4+eciwMTa3El5rQJdwech+lvsR7PjFW/GJzONNhswtKKnfOak9jPd0cbFqs3IaVBTiQS
	 HiINqbdmeMSSoinCLGzl//3PI4LZhWe5NrNV7xnF2uZu0fCOw06AGDI4my2ZjDfTiN/In
	 l36ygVxFW1Eio+3HGOMvAJp61mKuay8RJwSSHlJmQlVkcGbeZFdCGFCKfWqVCv4lsm8QX
	 ERmGTeU+EbwhE0FEik5+n9aNXsDbW+6eP/U8Me3uZ841lQnxS1Y9WsTOvp+j0oaNmHzP5
	 OiHE9ybI8E5uymHIijK22gWKT7ztPP3eBvpGR9G/XxxvwNP/W7201BR26CsWsx76x4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063776;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2ev5KYuYpH/dHD0pcCpSSTy/zuz1lMeUt7J+yj4br0w=;
	b=NAZlfWBpQ/lWnVkg/XITJ98Fh0/18iSZ6jjbsMfiIhZ7viqZHKdEuVPg8vbv7FxI0cz/
	 pwtLD8JRZJRtiAXHFxifEyJ4KP+okolbI32kgREeOYnzTosI1QUpfy6AjRO3sbOYpj3ly
	 KSjG/M/cZKF9MrrXzHpGao3s5Lbt/xYcmwcc9ivQFVJSdXnRcwP5Hy7PZcUiksWFriyuu
	 W+9KePVPbIb6xd2gvCz95Oc8pr6v8uNz7nZBwF5bcB2OAQO/p+2UU/OV7s7zQLclg6acG
	 1xapMFGowqjw1nbIHEAyXXFAsBtog/yrwMnzlSmAd8w7rWRPoaUnkfa0rw/yRF5CPbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N+zTOwna;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7031460A2615;
	Sat,  7 Nov 2026 15:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N+zTOwna
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E0901F008A2;
	Sat,  7 Nov 2026 15:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063776;
	bh=2ev5KYuYpH/dHD0pcCpSSTy/zuz1lMeUt7J+yj4br0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N+zTOwnaFipLeQ2OWWld933my3JgPV3pIBrUw8Q3v3AMflQal06/bEhfe8AepRGnP
	 w2UMWDkBWREoUp9fwmJSMzj41w4J1hSE3w1yLkEfvN4Bui+jwx5+LJKK+1fqMYVelR
	 I0upo1VTlIXnOkXlW30AlZYmdRHpwYWZy08vU7pM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 866/869] init/bootconfig: pass init arguments in documented order
Date: Sat,  7 Nov 2026 08:59:08 -0500
Message-ID: <20261107134922.176023128@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 269b30038b9fa..2097f4bbc0d87 100644
--- a/init/main.c
+++ b/init/main.c
@@ -910,12 +910,12 @@ void start_kernel(void)
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



