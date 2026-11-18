Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049755;
	b=XmCxUi3ny0T4MKDYFtoaS/RCFq9Gajlvzft7NBuRDtyDO2pIcy586FKOW//ueAhFpNYi
	 34VfytzhqqpE4JHk0jsQyVAvvB2V8RjMyeE8Khq5cNZjM56od6hfslrH4xuzDg+jqFVSp
	 /o/GA6KqBhiLnwu+/IQNE7sehiLUeC0zUYRcKQlT7WhwRrHqwgp7ApiehtR17QJtQ4vQj
	 RAhbbY1f6XSoMQJ04Hj0X9UWDSBM5ao26BgsfRDZL71PZvetKmedGGIdvWQDhrW4virbk
	 xK76fOh0uhYEOtpbt5Ac0+h4NaUXBSgKcv8Hyhhlx0tnSHhfuGift5uERx4GyJ59QvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049755;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jC3tvjGHZpVzlisBNJgyrYZam7M/+Ykgjk8ySQF0ONA=;
	b=Sz6w9HFvbkP6PsJV1hmdtU2rWBLxi7qLkMG3dSRAR0e8GrrJCxdFfB/vEerkC3gOzoSp
	 +1D0BQ1LXZS8QgCst9bPHUknHSXS6VkqIuGOtBuxXXWU9ZBtzNgpiS9F+ildfL42dJgbv
	 W0AQ7CUFIuC7Z1E3VHEzzumr7oo6TrF4vM8VTxwOiG++UO+ZHQYU9Tkc6pcmrXj1+enrn
	 h4VvFqxIGOOZ2NydpQttWio4n2wr6dhi3RrKZfDvAWreihPyehPU5ei0xhvYM9nVyXOGf
	 bOgmIMHJQfYl9xp9rUQLYg5q1JG+/70UvyPDUWvr2t933uQDAC2xqnntuKUtuwCoOXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aymnmxF0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8278606A336;
	Thu, 19 Nov 2026 00:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aymnmxF0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7D51F000C4;
	Thu, 19 Nov 2026 00:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049755;
	bh=jC3tvjGHZpVzlisBNJgyrYZam7M/+Ykgjk8ySQF0ONA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aymnmxF0V2l3jDguMjLwnVANe6dqPZEA08gOoCN+R4zlUVe4N/dgboOw/UU+dirOV
	 QMtPRG9bClldkDaXIDCbS+J+q/+teTPRQTL2pb0sy4/xMf8v48BwOAjGFQ9BlAMFmL
	 BCwTMu1BOWISg5IjrCVwoZA6YfPW+iONktEd6qiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Douglas <me@timdoug.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2466/2857] serial: pmac_zilog: report received breaks
Date: Wed, 18 Nov 2026 15:58:20 +0100
Message-ID: <20261118150330.359955387@linuxfoundation.org>
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
index 67cb3905fed87..08d029dfc9ad1 100644
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



