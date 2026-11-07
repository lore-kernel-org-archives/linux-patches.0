Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065598;
	b=mpwka7kHKiXQzu779Z0lTjWkxoMk6Y9pCNwJO1V044+5Ixst8TM4lBJCfLdQh7v8w//D
	 Hqrqks9J2y0tgSr4+ZoU+0JUdmJzdz8RwkAgW1mx09TuUV0vamq+iDA2HWNvkmkK+gfM4
	 CrP7yyTiw9b1H/T+ipvWE+owhhyZXD4FgL4pBNwifzkzVGkaBvt60DbM+Yg+EnGc7snAN
	 H1DsjwWzT4NtMwVip0WBzXdhs6qYNATFwQs5c/6N/6CwdEyCfD4UxXe2+uMGxznShp+/p
	 PHUCbC/+MYddl006fRu4SYTnBk10KJcuD0Ty3nK2XhZMZk7sPPzgGjHTPro2LY5msCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065598;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VPmapjKtzsp97Bq2rzAf5ui/ZHYZTExzKZguUp9F/jI=;
	b=qRNlDSBWwmjuiYAvuLoiern8kN2y2fAdkatBDjakVPfP/UcCTLPh9X/REcGZwcBUXZ+x
	 lK2/O9cU+ekzAqakEW5bUFVEoPczuWzQE8QKvS7g8rlIqxg47wwXHm6Tul1S2/2M7nxlf
	 UnmKwFqHEHV9yEAz5mMgokVg1O1YcoXu4OjVPKU7wtQi0KSndMLOWjXrrZ0dcn5PlqrwO
	 Gt+bh9QwsY0dfgJeqTvfSl7UYP+tZoJymAFzM7+JYl6bdyspND4f75MZS55lHjxbwFH3G
	 yl9OLwoerzChuKQzW4pqx62/bqSz/xGAtKronktp6bGG7U5Q82ZTSBq8XUQq+z4DbHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ttEZaRfM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62828606A32C;
	Sat,  7 Nov 2026 15:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ttEZaRfM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F20121F0089F;
	Sat,  7 Nov 2026 15:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065598;
	bh=VPmapjKtzsp97Bq2rzAf5ui/ZHYZTExzKZguUp9F/jI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ttEZaRfMPpqO8UDO0e0TjDa1S9BGhI/5ZhHzrkmsFVlle9/GIYDoJYzTvoByz74z2
	 c/BULyemZeI8MmwFz8uuoQVn8ThqMQIZwzwIUuoFdzICqiOByWnqnMPnORCqmI3eKx
	 4FR4XhaZ4JAgA4iNd0NWypxBa5zEsSDwFViTP/3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1254/1257] init/bootconfig: pass init arguments in documented order
Date: Sat,  7 Nov 2026 08:59:10 -0500
Message-ID: <20261107135013.947122324@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 31f2bf54976ab..4efcb9956c39c 100644
--- a/init/main.c
+++ b/init/main.c
@@ -1028,12 +1028,12 @@ void start_kernel(void)
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



