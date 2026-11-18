Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045929;
	b=4vqazFC2MnTtwZJ34V2YOmcroJ0GJuh0GrIWGxmQzFfS/b31QCZEfZRSTvJ7uZIs2NsD
	 dnRwlryuANfMpxOX83CXrDLYdRCzSIe8/XBqTwmebp+TkqZM3UfyGj5kV8bDZ4XTx80L0
	 wAdatOx246qd9Z6z9YAts3/LXuLtSvOVDUCTuZcAdY9OaUqx9ZtJ9wWmo+GjJNaYqMOrA
	 0dQarmikfocL1oiDHLUsoDcB1f9kcQdC6uVkjevx+NFLkkM5oL1QmuwiT2boVrXG5TrBD
	 lHCH23qEb2AoX8JptM+igdwzssLnVLNIcbslUt/sIJ4v3Y8nXqZ4oUC1FgwCp3O/Evw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045929;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qRYKsMMvZH4uhEv09qMbJCnQf2mdaSX8fqkLr4TeQjM=;
	b=Ff9akpm1iwQI/4K5T+0BxlbLsfxhiw6O7p/wUafzPCuaKVWhunuOlSvi4PnoEmIIqrLf
	 HamMIg2oKplvoOSceKKZo5dSLKmMFngM8BdDVg908LtX6zWPyOqm1/iqG2/DuwtsRb3W9
	 Vh07d8NC8DV4unv9KZyhzPQVjQAawXsrL5PvY784Sbw8YESNAnhxjBHy6XLgGG5sjRDaF
	 gj9DOumBg+9klMsnOH/7GffbG6Tgh+nP0SS1zfywU1YHplbnWUoQdmRdNibniYEg+uwDR
	 ovW2g/E3WFdVHGyp3kuXWiDK77O42OBpCiMXsAK4cRwD65jM2he9R/3fZ93qAC0MPUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ycmZxDmb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDC0606A32A;
	Wed, 18 Nov 2026 23:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ycmZxDmb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67AD71F000C4;
	Wed, 18 Nov 2026 23:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045928;
	bh=qRYKsMMvZH4uhEv09qMbJCnQf2mdaSX8fqkLr4TeQjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ycmZxDmbs0+Nm+ItESzxTMX9Ytvy+2f5ddHJ9OUjV43WJGuKKQRuQArFoPBXaRjXk
	 V7PksHLP1fkXT1B99OnOJtlflLaDpky7j1o8D6FzR/qs9WW+ttMAcMm0rQDJ6C+dTe
	 GNXPanfzMHpVu6wL3b9APZAUYqQKDWTI7O2cONSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1099/2857] init/bootconfig: pass init arguments in documented order
Date: Wed, 18 Nov 2026 15:35:33 +0100
Message-ID: <20261118150241.205725672@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index cd1b46b008ca0..2a91e32b00765 100644
--- a/init/main.c
+++ b/init/main.c
@@ -957,12 +957,12 @@ void start_kernel(void)
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



