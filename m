Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064783;
	b=pm5+V7tSAu2R67fhNEu8dbPmsbPkhQTc5ZSbmTxXQVOdDyMxAqDYCMf5e3QSnZE1Dyws
	 aBpRbkES5YZGYJRleGDsSL3WI8LqhVHwJODJogRfb4geeUYHnd5GwHWESO67EKl2E5APo
	 6Pkapi5qYo8BmQMOpug3mvDSJy+IKRQ5qVXbdI09GVDkxQuuin8tlWLnYK1rgAELTGAfP
	 zGTy7ZH10EULvDhLINt3FzsNtF0LMBhcLCWKbdIwfAyastU/p94yOFsv12HOi0skZwJgJ
	 NU9zKznjY+ZqJo4X3ZPTJj0P1XpVDe+uPmXs0FIF9qSF2Uv6/FA9/ma6r4tgsTDQHsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064783;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rK9qY9+BM6gBOBbg89Nxej38DfmGD0SsOUNEb1ZxCCU=;
	b=r24mkPOgTmIr9zeGq3ICGT3Qxf6l7nFhHtrkFNR6SXMBjX1NDwa71YkVbPru5T/8twSk
	 oLP6wT0iw7qOKJawQVBsOF4LWp4R5C5hWI1WlxIf9wjaqtf5qCQwzCliGQXQwgGgC5I94
	 jJbJlLdvfGQw/jNzNZq0pwOJkaYaBpiZWnIBT6EPOiJqkeD1QyOwa7Gac7G4tA4DXKBV4
	 dyrA7+7Z9T3pEcvMtF6W8yM9CBJfYeiDwCWC2Gn3C5rZ7Hr8yBlP3+bu93WKwVlMRr80v
	 RmcZzfYlbKBkIY8c0/rhQRn+xYHCJgncexqBUzVoFnyCRxdjhnciIijDi0wMuzgboXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="lDJb2l/P";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B4F606A9FA;
	Sat,  7 Nov 2026 15:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lDJb2l/P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877631F0089F;
	Sat,  7 Nov 2026 15:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064782;
	bh=rK9qY9+BM6gBOBbg89Nxej38DfmGD0SsOUNEb1ZxCCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lDJb2l/Pks08fu6cnmcxRThbaSy6VTr85bhVgdUxiEiYHPmCU3CSsLLWkaPUR+nh1
	 Lv/OndxoolNSH3KrG4nC981UoDxH2TqlJ5BworPfMSiCMNfnp7qwL0mAmJlISXOUrS
	 snDFIxukGaL2uHTDId/5uKM3tbQ4onvD+XKOEZ7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bradley Morgan <brads@mainlining.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Petr Mladek <pmladek@suse.com>,
	Guenetr Roeck <linux@roeck-us.net>,
	Sashiko <sashiko-bot@kernel.org>,
	Wang Jinchao <wangjinchao600@gmail.com>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0732/1257] panic: flatten nmi_panic control flow
Date: Sat,  7 Nov 2026 08:50:28 -0500
Message-ID: <20261107134959.491062942@linuxfoundation.org>
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

From: Bradley Morgan <brads@mainlining.org>

[ Upstream commit 75eb687ff2bcec9fba31bbe266e5f91e5c283efe ]

panic() is __noreturn, so the else after panic_try_start() is dead.  Drop
it so the force_cpu path can be added cleanly on top.

Link: https://lore.kernel.org/20260916182957.7788-3-brads@mainlining.org
Signed-off-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Guenetr Roeck <linux@roeck-us.net>
Cc: Sashiko <sashiko-bot@kernel.org>
Cc: Wang Jinchao <wangjinchao600@gmail.com>
Cc: Wim Van Sebroeck <wim@linux-watchdog.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/panic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index 010b331658b6b..e1b443150ba0b 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -517,7 +517,8 @@ void nmi_panic(struct pt_regs *regs, const char *msg)
 {
 	if (panic_try_start())
 		panic("%s", msg);
-	else if (panic_on_other_cpu())
+
+	if (panic_on_other_cpu())
 		nmi_panic_self_stop(regs);
 }
 EXPORT_SYMBOL(nmi_panic);
-- 
2.53.0



