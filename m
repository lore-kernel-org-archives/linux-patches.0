Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026631;
	b=H7+jGrQQoZl1oSvmNiY7T6HRpSv30nu+uL/7CQlDxo7T06vw4kUrngSakWF8bbgmW1Y2
	 W/lwse1UBSGuX9QQJyk1B51Ca4q4m99Vx3+By28MoXfywjFpM/gKC6FDb0oiW4Fh6iyvV
	 /+3NXXZc9WpY2INJPxiQiauLURtxGdS8EOXMWR+pdse6mTa8rfeuFe2zp5YbXzfjXWNAp
	 /VTXWNZ+U/5+NOZLWmsO1jxIsxFL1pdwPyuwBEZIEtRfqD2NmnpUUF5w+T6IlgNwXFxo/
	 7R6xh6CFOXpLrkqMv0rz8kdcOlLtnFlY1TnjuqoORfzJFdWqbxffDLwh8EIRzlqoUIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026631;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HENtZeqbKDNhGuEtmOi6/5Seej9sZGCec/Ko2b9qCWg=;
	b=RJStj7uF/yICi/OdPpdH/S04eMPPdtYZ5S0xni6W9+HAuhMd61RdyQYtHqDkDBEI1l+X
	 +RJiEi279cRQ3quLS4w8VQg0Lk6G6j3dKkoRlz7mmu0NRpNCoPVQ+8JIQIAqIg1BvW9xi
	 WZCYLtIPVuBWkFr9O6tz+6C700ntjZyiw5hstj27F9TVBbeE9XTCak53VY6Ge86jvxiiT
	 di2TrcDMOmTpZxIfRwrOiXUJTcHNh9fD5DlmJ+FbAheXiZo3ZvPvM4EL7JdRwGlwgQrii
	 /Q0J888g5nUjxq8RijCIMjCkgsmKQZCLyNu+HkyRFQ2qyZO8Dvpykq5oAuG3qT1/ueA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sLlrF+oX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385AB606A320;
	Wed, 18 Nov 2026 18:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sLlrF+oX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8F91F000C4;
	Wed, 18 Nov 2026 18:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026631;
	bh=HENtZeqbKDNhGuEtmOi6/5Seej9sZGCec/Ko2b9qCWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sLlrF+oX2AFtnyWUgM3/pPJf7W3yzjnKZjNulc4edyflW7fQwFpkTXoCXgtjJgu7t
	 PdJk7lBzBpzErepmgLTicWNlRpwsnK1f6oIWiMWhSAyDtBWwtdRQnNMiiVXSjXMQaZ
	 j9z4h1idnhzxTouYwJmoFub98qEJ7IghObKNbR/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Douglas <me@timdoug.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1502/2151] serial: pmac_zilog: report received breaks
Date: Wed, 18 Nov 2026 15:53:57 +0100
Message-ID: <20261118150216.582005636@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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



