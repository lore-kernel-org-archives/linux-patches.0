Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020138;
	b=hNtOx+OsuRCJoxHNfoPId/mIFNbs8d4uYypwv8+qbfXgKR7hHptmNjZtY1Le0KgWVBlE
	 jsN/5YkoYgM5xt4mSnmMsiiJTadSCwLLCpbmTVJ3KhXoWWQJo9sEwYBB262L/BwR+PnHI
	 CbHSugWlUuOYMo8Oolmm7i7kcM79nKZHjgL6nrXUnZcrS2mz87GBfPnfMVqW3aKimevV1
	 shwXChXWVMv5T49UOVxhDstIWDMSqEUAbV7eEZTbuc31Klc8DNyblhlTheX8sA8f13GrR
	 oHAem3Hp7EnHOu0zWben3RDKDRCF6vwtpC3q9MCmPhC5eeKKYGu5wN1TGBPPmYhsAnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020138;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AeAmylU/XzyMIzWG703+SBjZGTzVAxhN3CQrGpcFrTA=;
	b=RkSZ1ewUZpNQrMQMmIyySSmti/3gYgGx/jdGd5+0APNeOHguxYq8YcTpJdTOR2R7id9k
	 ZFYDc3U1CAB7yxEifLmefhSm/P08QZnsEBs0WX9SZQ6/QX9FqASJmTvvNbgXE3UOHmDb2
	 KE9OxcFoVtOvz2pZoonBt8jy3awsNSQzyzO7j+0mctQaLedeannbqetsbG1GMBAWPlGAs
	 axr6LHi4f8x/gubAvk/C10+tqcBiBN3aS9Wwx4LAisX7HzeZz0xkxFw5SvncP5BNeDHQw
	 6rABfCczETjHr/QHrZWgBCDA5spUK3iJZzgF0Wz6eiHwlb8ljvyqSh9bPHNMZqFTmbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ChrRkamy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65768606A336;
	Wed, 18 Nov 2026 16:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ChrRkamy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 688461F000C5;
	Wed, 18 Nov 2026 16:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020137;
	bh=AeAmylU/XzyMIzWG703+SBjZGTzVAxhN3CQrGpcFrTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ChrRkamyAMijttFa3qhpAF1cCPvy32V/8aVi5b60R882ZiGz3nVV1MW7IQUorH++M
	 c9ezW9UQ9DP851b+SYMe2FNXdGmsssCEqowlaJVEUozE4tFLCdvpAXjy1g5ZHX4rVi
	 YpHjZyA1R1lMfhG3tL1KzumjMJq/4kwPQV7+hpRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Douglas <me@timdoug.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1846/2651] serial: pmac_zilog: report received breaks
Date: Wed, 18 Nov 2026 15:51:26 +0100
Message-ID: <20261118150353.512795884@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Tim Douglas <me@timdoug.com>

[ Upstream commit 8db79ea07a67b126c773da6efdc00066000daeb8 ]

pmz_status_handle() sets PMACZILOG_FLAG_BREAK from RR0, and
pmz_receive_chars() clears it on the null character that ends the
break without marking that character, then tests BRK_ABRT in RR1,
where the SCC does not set it in asynchronous mode. Breaks therefore
arrive as plain NULs: brk is never counted and BRKINT, PARMRK and SysRq
never see them.

Set BRK_ABRT in r1 for that character, as sunzilog does.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Assisted-by: LLM
Signed-off-by: Tim Douglas <me@timdoug.com>
Link: https://patch.msgid.link/20261013013541.4535-3-me@timdoug.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/pmac_zilog.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/pmac_zilog.c b/drivers/tty/serial/pmac_zilog.c
index f49d6052d11be..a612f1db9f189 100644
--- a/drivers/tty/serial/pmac_zilog.c
+++ b/drivers/tty/serial/pmac_zilog.c
@@ -233,6 +233,7 @@ static bool pmz_receive_chars(struct uart_pmac_port *uap)
 		ch &= uap->parity_mask;
 		if (ch == 0 && uap->flags & PMACZILOG_FLAG_BREAK) {
 			uap->flags &= ~PMACZILOG_FLAG_BREAK;
+			r1 |= BRK_ABRT;
 		}
 
 #if defined(CONFIG_MAGIC_SYSRQ) && defined(CONFIG_SERIAL_CORE_CONSOLE)
-- 
2.53.0



