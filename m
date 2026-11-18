Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042847;
	b=ZhXhM0jmKBJRYeOSO7ISU58t/goE44T4QyxoMOlxfduLb4VgFtXfZgZAFNY3GUruHZhn
	 A8hyZlpUJ1hD3VF59Ty+7kZ6Lakg2CFRd7maWni+ZOptMsY9rFnqSMhNBKOIkc67XRZl8
	 TlNSRKmxQ7AksYoxuF9NeLRVVPhxERZqMvsYIViwUwpJ4mloD5Gz4n/HqenzpedAkmine
	 xuff4KPMlaiIFgGhyqz0B9a5k7rayTzsjYBSCLHk7LLFR65o03kEoIOhJYmb/oY9l3JQJ
	 wf9XLKJzeJQVmOoZSgbgOW5UkNwRWvJVKc3vZXD4Nm5Xa8hVPTQmiyFkHECF8BtMABg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042847;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NvBj/80cUmmIMpD6CgDdN+u/FVEJJ3BB1rNp4BOAOUw=;
	b=DhQk9vpzmqMNLNXWug3cnsPUgbaL3uM3WcaeylLgrAbg7rrWe1167Jnf0hXy0T6WaaSk
	 rgfJI11z7eQKiz7mSCkdx/YV21kc4e0wENGDpoGaXiYZj6+srQaFVie2GJxS1zRcz+Njv
	 VFW+HQHV/Ti7MrBq/fo4Lzj/hVX1zvNkWv+JR0rPcOvY68BPU4WGutiEOhLm3DD8sEpfU
	 CBkaa1BL2ra7igF38ZkJziBTsxAJsc+1u8qrNai7dXX15arAB8A5HRE6XrVJ+LO5tPfP7
	 DnrLsTOKC7RP3vEiqIx3jZC+TKpvV+LXuPaGTWEP3CA5t4MTeg6bWlpUO+tlks7edQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jbpnKH1g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF68B606A31C;
	Wed, 18 Nov 2026 23:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jbpnKH1g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 529CF1F000C4;
	Wed, 18 Nov 2026 23:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042846;
	bh=NvBj/80cUmmIMpD6CgDdN+u/FVEJJ3BB1rNp4BOAOUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jbpnKH1g3QP9H8ZUQv7hbeKqtkft5kAHMUyvRnpyE8MT2G38o48uhORMSQwMyaFN2
	 +1ATvAL1C6NLFooKri0Ek2uAxCdHeVbbRaQWbMOpJYMeXkaDRgf/gk4svaG4sOcZcp
	 z5nu3taqefTl+h7uYVagn3zi/WcSN5OK+70d2dvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 6.6 3315/3318] kconfig: initialize sym->curr.tri to no for all symbol types again
Date: Wed, 18 Nov 2026 16:05:37 +0100
Message-ID: <20261118150459.023044374@linuxfoundation.org>
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

From: Masahiro Yamada <masahiroy@kernel.org>

commit bfef491df67022c56aab3b831044f8d259f9441f upstream.

Geert Uytterhoeven reported that commit 4e244c10eab3 ("kconfig: remove
unneeded symbol_empty variable") changed the default value of
CONFIG_LOG_CPU_MAX_BUF_SHIFT from 12 to 0.

As it turned out, this is an undefined behavior because sym_calc_value()
stopped setting the sym->curr.tri field for 'int', 'hex', and 'string'
symbols.

This commit restores the original behavior, where 'int', 'hex', 'string'
symbols are interpreted as false if used in boolean contexts.

CONFIG_LOG_CPU_MAX_BUF_SHIFT will default to 12 again, irrespective
of CONFIG_BASE_SMALL. Presumably, this is not the intended behavior,
as already reported [1], but this is another issue that should be
addressed by a separate patch.

[1]: https://lore.kernel.org/all/f6856be8-54b7-0fa0-1d17-39632bf29ada@oracle.com/

Fixes: 4e244c10eab3 ("kconfig: remove unneeded symbol_empty variable")
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Closes: https://lore.kernel.org/all/CAMuHMdWm6u1wX7efZQf=2XUAHascps76YQac6rdnQGhc8nop_Q@mail.gmail.com/
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/kconfig/symbol.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -364,6 +364,8 @@ void sym_calc_value(struct symbol *sym)
 
 	oldval = sym->curr;
 
+	newval.tri = no;
+
 	switch (sym->type) {
 	case S_INT:
 		newval.val = "0";
@@ -376,7 +378,7 @@ void sym_calc_value(struct symbol *sym)
 		break;
 	case S_BOOLEAN:
 	case S_TRISTATE:
-		newval = symbol_no.curr;
+		newval.val = "n";
 		break;
 	default:
 		sym->curr.val = sym->name;


