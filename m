Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DDF425C715;
	Tue, 11 Mar 2025 15:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705826; cv=none; b=rLbcx766RIpO80aF5MeuDPzmfHlqOwLqcmM6TgaN47qEUtlp0M4hEZg5DTj9qRbAqRU5YYfN7QICUF7f7kQfQfwVWD+EhxnJ0D2hr9kiwf6BgkZCLlqDhvesWe23kjqsSQv/D0AzusKwuv6PdsUToeq+U3OVA6QeDOQrRaUox6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705826; c=relaxed/simple;
	bh=Ygy9VyS/8fa2M+zo0KVpNk8PNI6jQ6aYV80C0IRPKzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YMeeP2UWki/CV47dP8qmJnvslW4te1RZoZ+E7eqyqk4N9RLc1H7YnOmJF7YB1wQMusB/MO1jYLoOZLCHIjEGnVShk/vlyMCjs3/wk9SfDx4/q1zw46NmV7nUvRptrx7PaOxMS59ramUwDjgk1ZWNvmHxIi1dmD0tjZqDH0TXlRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xbz7YPaE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xbz7YPaE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86563C4CEE9;
	Tue, 11 Mar 2025 15:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705825;
	bh=Ygy9VyS/8fa2M+zo0KVpNk8PNI6jQ6aYV80C0IRPKzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xbz7YPaEIpNSbb/uI5cCnbt+UBoQNBYcgTB6b8QeX95THIcgpW7WxxXjHQkaeVQVw
	 IMnEmJDicmr+1guK7V5ptEjeMGw1CVxndwpzIFrQEzmEcnaixNEI8Px92JOl3rdIh2
	 MTHCFIvz0WETEGHvRHx9XpSKALrdk0elfrrats7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WangYuli <wangyuli@uniontech.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.4 160/328] MIPS: ftrace: Declare ftrace_get_parent_ra_addr() as static
Date: Tue, 11 Mar 2025 15:58:50 +0100
Message-ID: <20250311145721.265383056@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: WangYuli <wangyuli@uniontech.com>

commit ddd068d81445b17ac0bed084dfeb9e58b4df3ddd upstream.

Declare ftrace_get_parent_ra_addr() as static to suppress clang
compiler warning that 'no previous prototype'. This function is
not intended to be called from other parts.

Fix follow error with clang-19:

arch/mips/kernel/ftrace.c:251:15: error: no previous prototype for function 'ftrace_get_parent_ra_addr' [-Werror,-Wmissing-prototypes]
  251 | unsigned long ftrace_get_parent_ra_addr(unsigned long self_ra, unsigned long
      |               ^
arch/mips/kernel/ftrace.c:251:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
  251 | unsigned long ftrace_get_parent_ra_addr(unsigned long self_ra, unsigned long
      | ^
      | static
1 error generated.

Signed-off-by: WangYuli <wangyuli@uniontech.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/kernel/ftrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/kernel/ftrace.c
+++ b/arch/mips/kernel/ftrace.c
@@ -264,7 +264,7 @@ int ftrace_disable_ftrace_graph_caller(v
 #define S_R_SP	(0xafb0 << 16)	/* s{d,w} R, offset(sp) */
 #define OFFSET_MASK	0xffff	/* stack offset range: 0 ~ PT_SIZE */
 
-unsigned long ftrace_get_parent_ra_addr(unsigned long self_ra, unsigned long
+static unsigned long ftrace_get_parent_ra_addr(unsigned long self_ra, unsigned long
 		old_parent_ra, unsigned long parent_ra_addr, unsigned long fp)
 {
 	unsigned long sp, ip, tmp;


