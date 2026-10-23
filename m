Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774521;
	b=JBz7cP+VegcOelpbexPeH0T0JIM8Ef/cQK83BbyeOXa4j49LhayP7bseCIttNLXWnvbf
	 nZDVfRApaVXGeAZFnoiK0BXwXaY3I3C27l2IpBPxTZOLu06JaWyCacTF/MDICiL/k1ifI
	 AY7ku0munFjJadZQYlOZiUZFWTtvXJy8CLZdISeRZhmzrohQHQz+1i7bPFRTQc8rKi/KA
	 1CbO+zZkpZl0WHNmsOerRsR0Xy50Rzq+5h0EAKlYfzYd4d/0mDkvDd4xxwVvc/PFZJQGb
	 iyJjVSIGhyUCN9I0GW0O2YPkznuOiDo7b9vpMZib6MNmxEbPP5bia8oXQhH7/iHh92w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774521;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6F2vg4ha5E/CxzWViGdOY4/FrUliHSkUA2yWhAil55Y=;
	b=mOJDESNeVXvqMD/VUWKq4DTjmDNzYA4yJpQzJOo/ex6BW3MV5elwsRR1b5SoZ2vkZH6N
	 8sYjBbooxaz0j96eabknJCH2wynAmDsTCCM75/0O6pED7Lwfa8e+X9Xzg4PQREnFHXCFX
	 MsGMmjEiFvCaIQhocjKCJK6LBzSUSnNfCwgTEneCoo7hkvDV+fwpkYWi/99hZVYyJC9D6
	 2UhuI2bIETJIPw2sSNrJGUGQPWWuRwu+Inq96GufWNPdHMj2ggNQut1ek90lzfng/cyjM
	 VWiA/eY3P+T/FPTVxrWlIWrkiugy82MrXL989zlyHO3Pleln0qm1WoOxn8P76ix8GkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0y+Sq9Sh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B19606A31B;
	Fri, 23 Oct 2026 16:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0y+Sq9Sh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C1DF1F01825;
	Fri, 23 Oct 2026 16:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774520;
	bh=6F2vg4ha5E/CxzWViGdOY4/FrUliHSkUA2yWhAil55Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0y+Sq9ShAsT0xvgEhqvQ3SKz1vDhup0NEBDORquxDHAdRtzOyHyH2brJJ2WNfw5gq
	 XbC7ivfeFF7bYx5Yb7diGYqIJoWcFguuWm9lyQCIa83X76aWaCHTK8kORDi14NwKrC
	 7s1UtSwO/HN6u3KMPqvUpD9WtW3Rrcs8YXZHYEHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 068/242] tracing: Fix empty symbol names in simple_ring_buffer undef check
Date: Fri, 23 Oct 2026 18:38:30 +0200
Message-ID: <20261023163715.390115271@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Donnefort <vdonnefort@google.com>

[ Upstream commit c902b6d709845def1d1d3ab818e0b9d9b962ab16 ]

Sparc64 emits empty symmbol names. Skips them when establishing the
allowlist and when extracing undefined symbols.

Link: https://patch.msgid.link/20260923074213.3077182-2-vdonnefort@google.com
Fixes: 1211907ac0b5 ("tracing: Generate undef symbols allowlist for simple_ring_buffer")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Closes: https://lore.kernel.org/all/5574c9e6-9ed2-4ee6-a2b2-fb6ee81e83a1@roeck-us.net/
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index f934ff586bd43..0e1846f7dda32 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -146,11 +146,11 @@ KASAN_SANITIZE_undefsyms_base.o := y
 
 UNDEFINED_ALLOWLIST = __asan __gcov __kasan __kcsan __hwasan __sancov __sanitizer __tsan __ubsan __msan \
 		      __aeabi_unwind_cpp __s390_indirect_jump __x86_indirect_thunk simple_ring_buffer \
-		      $(shell $(NM) -u $(obj)/undefsyms_base.o 2>/dev/null | awk '{print $$2}')
+		      $(shell $(NM) -u $(obj)/undefsyms_base.o 2>/dev/null | awk '$$2 {print $$2}')
 
 quiet_cmd_check_undefined = NM      $<
       cmd_check_undefined = \
-          undefsyms=$$($(NM) -u $< | grep -v $(addprefix -e , $(UNDEFINED_ALLOWLIST)) || true); \
+          undefsyms=$$($(NM) -u $< | awk '$$2 {print $$2}' | grep -v $(addprefix -e , $(UNDEFINED_ALLOWLIST)) || true); \
           if [ -n "$$undefsyms" ]; then \
               echo "Unexpected symbols in $<:" >&2; \
               echo "$$undefsyms" >&2; \
-- 
2.53.0



