Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031927;
	b=s6u6ITcM9/K349sf6lzrn1JxZfGoJsbdzT5SGmrW6mzUwAS3FOO6NxEo2z32kkkZQEBU
	 v/mYY7iqS4QgXaub4AUWXJlWHie9idV0swzZOrXCl+R0HjpC7a1F9NMmShqWF+2ojL3J6
	 ju34/9jV8BGC258/osdfdEeofsG6W1BH1TMe4ZRLscQxJLEoLntftXW8vEvEBMZPOKTv/
	 RcXPvPs5+oW9NAbQsRrn3OE/Qv8JkPinFrSj2FbkQuzJ9US2U7z9JuYC6pXBMetrdRW7v
	 G/5lExmXaQ4J1LAB/X4PPkhDjR1nXEW94LgHiiRCNka5kmeC44jUl8FEkbaLKwHFqgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031927;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vqOxvwN56tciwSLWYdGsdkBcAGwVHJU9ZLJVnd6C7DQ=;
	b=hkqQ5D3SqOORbcPa+HhieAU2ccMQ86MkOe8+mtcm/wETIbyU/RgHOP7ffdoEnm8LYAHF
	 i5u0x3xa7w327NtI0y/We9YVvY3fqDDXpSOtQSU1p/QsRmODGBr+MqoBfeYY9RbH7dTER
	 0cS75SDjiJYDecAzJar+x3Q4Rym6zEXJEzPaMlfxUzPlnyUt3u8vYP4FtzW02eM/Y2PjZ
	 12TvCcvZjVNDnhjCmDaGSSSTIbzsnLN1nc6wLTTzywYLIBue99Ol3AfehcNBgDomIOtMr
	 /eO/4sXIirqlcLDRXc9NtX9hG5cwAAeCgTV3U2mc1stZs7ACBPO4wRVwRNet/9ZXUQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G8h01oNP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40FF606A31C;
	Wed, 18 Nov 2026 19:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G8h01oNP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3659C1F000C5;
	Wed, 18 Nov 2026 19:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031927;
	bh=vqOxvwN56tciwSLWYdGsdkBcAGwVHJU9ZLJVnd6C7DQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G8h01oNPnQ4Am1KdhJCIkPzwOl+h9LSlsSA+p+i30Fv1m5MyvYrNXwafHfxHUtcU2
	 W5SfFoz+gjbs1m6CTuGKgRR1Ez3yz/RU+qVAPRtEUuRKNKN4g/D5OQB+CeDTkMdows
	 FEU4GfmVtxb2VKzGvFxp7+/SLUPUY5KA3bDyru60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Douglas <me@timdoug.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1194/1756] serial: pmac_zilog: report received breaks
Date: Wed, 18 Nov 2026 15:55:21 +0100
Message-ID: <20261118150057.398203018@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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



