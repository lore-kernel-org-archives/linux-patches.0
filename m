Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056227;
	b=TMqX58qx9YFvtkruM2VtQMrvi2EWuigjWeGi9wAuDF9wZfcSYFttDh0a8udP3t0g53Z9
	 gxQHIEuBvqHhxR+nVWmpmX73pzhxUbPbRGrRKUAQ/biEvAuAPnAJ3/Lmwy8d9Pk9GwSHw
	 oPGQNXE+SzWcq++UEYicdbU0/dbcTNTfVlZP3UtnbGT3Ux7Z/1oNm9JhFzzAFZrLldu0A
	 wTRPZPBq6fL9neNkIKS9jL50Ynt/1TEZ1weTS/IUIPAUNXyq0MnfiCKHt19U7jehciM+m
	 LDVD6s+CUOLObngy0Wd+LPZbeXEmsXZt0xvAGlfzO/LtCX/tTkXEylZuglovu4Y5jVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056227;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qqk1QCP78F7jszi3fV0Bg/uKLvUr5VOKKpgHog3dpKU=;
	b=BNdXzkRb0k9vQGo59U0HuRdmzVQHDpx60zdDo6GrE25eS4TLNiXC3sKWzBjLP0094WHY
	 vyBvimg/xAoDxByutcfUZgA6516/kEe6xCwRW+FocEdPWN4N0qDAP4FTjnfJViXa9RkWQ
	 9HOmfRwcbkcu7qqw9iTBUMd9V9i0gXrzdf/6AUb5sSOwq/sAQQRz/G0JiMJWOH4dy3zhG
	 P1f8xqAUr3sD1X0tE/slsLWVhx2sZNsP9KKPOkXgY4ejQjw87qrnkwCZ7vp3CIYwKVdsn
	 WdlkFPSbnvHtk5VlS+NJmd7YOklZeGuNeKqh32F2UhPGGfiQXOhpo5GKDyHqmLNxHJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tM7CYjvi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA68606A320;
	Thu, 19 Nov 2026 02:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tM7CYjvi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AE741F000C4;
	Thu, 19 Nov 2026 02:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056226;
	bh=Qqk1QCP78F7jszi3fV0Bg/uKLvUr5VOKKpgHog3dpKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tM7CYjvitOoEnf4d98ElulVjm5ayRILy6XElWsOwQY5ybWihWJ0clg7//K21NK3ks
	 wFIY5sKa/XziWie9cEigeX1Q82JKauOdFJkm+GF3X3V1apLrBiIGq3QpSijrIMDKcS
	 MbP52GW5B7DrB84GoLBdT9DK8kkhN8zeIYMHz+AY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Douglas <me@timdoug.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1913/2214] serial: pmac_zilog: report received breaks
Date: Wed, 18 Nov 2026 15:59:49 +0100
Message-ID: <20261118150127.607425172@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ad67608b23901..d4eb45c356c85 100644
--- a/drivers/tty/serial/pmac_zilog.c
+++ b/drivers/tty/serial/pmac_zilog.c
@@ -240,6 +240,7 @@ static bool pmz_receive_chars(struct uart_pmac_port *uap)
 		ch &= uap->parity_mask;
 		if (ch == 0 && uap->flags & PMACZILOG_FLAG_BREAK) {
 			uap->flags &= ~PMACZILOG_FLAG_BREAK;
+			r1 |= BRK_ABRT;
 		}
 
 #if defined(CONFIG_MAGIC_SYSRQ) && defined(CONFIG_SERIAL_CORE_CONSOLE)
-- 
2.53.0



