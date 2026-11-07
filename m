Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062683;
	b=yeYKcm82RF3lgbq5ksBeBLzSx5h4o6RMcMfNNBOZkykvgKuem7pc20GEeocfS57laPxj
	 PnGbGVNUXXKW2YgT0vhaU1Ojc2B/ZwReCQ1tItdP2R97izWfxG+LGnNqei9dc5AYf4RJU
	 WFqzMqqsH4NqM1VBhqx5mXdL3hawainAC+vD7RDRD/oSou09zJzhxlIbbuoRxKj7/9D2X
	 NQn0s8VmJziUqO7kQcuyphH3Tc/Yt/81ZxLwnZDqesLpZLaGqG9xUYwsIXyjy85mO5R1O
	 LwAeEUeF7SD4f1eGbkehy0TJs/AgOMLRKSqH4i4VWluKoRmEmncxTkvqcHo4SNGJXIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062683;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5XW+CaRaXZO9XkN/ZXZIfu5bDBXK9oVQlVriUyqwno0=;
	b=lPq9vuVqAnB0aMyBQQoQXRsCWfo5y1ECqTRjGZaiFYOhE/df8C+7nGypluVQvffla3Ly
	 ZxzcgZEvULlDbz2qXpBKn30i/u10f/INP82zXJgStQTNlm5mOzVcBm0kTdZVEqPo6qVv/
	 eqxJLYutVWw4KqONC7ZRqIMREtP3R+4zcrhBm2MzKpfKqwpcoiWYLAXMdKhWqBtwN90Tk
	 NtKEQFFeHP8gs92CxVGquWTzrgC9ICMLlMVlMVhdJyySdy0W6CwvRwGb2P4LIGYIMP4nc
	 sqK+eHQUq5Sm8yGepsCAEtj1htlW7Y9dtk/G8gO6Fho79MRgWW80tbTXDAnfjXZ9FJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hoDvcuAz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB96606A326;
	Sat,  7 Nov 2026 14:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hoDvcuAz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7981B1F0089F;
	Sat,  7 Nov 2026 14:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062682;
	bh=5XW+CaRaXZO9XkN/ZXZIfu5bDBXK9oVQlVriUyqwno0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hoDvcuAzHbbgvqOahhMfgKQ/OMuoomE7Bea0yPdPTXaQUIluhk6mU6kFqrbiM+7d2
	 TpH7ZOULObKrRLyDFyr3NqhVpsBhrrMVSpNMdAIFBaHPjvxjUNe0rw4DDr85t1H+ZO
	 q4xmG219N3tLJLyCPeuRqwD+KtwjnvbCL632jQi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1532/1536] init/bootconfig: pass init arguments in documented order
Date: Sat,  7 Nov 2026 08:59:08 -0500
Message-ID: <20261107135040.913179496@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 34bb284f64191..bad880340de43 100644
--- a/init/main.c
+++ b/init/main.c
@@ -914,12 +914,12 @@ void start_kernel(void)
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



