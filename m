Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049000;
	b=M6atGsfkTgVJCzjiPjw7mhUhpovhIpiHonvZQVhIPdrIC2B/Zly9HfQ5eQ/td8Nd+8Pn
	 qpGjs2nTyDwducMR/B5A7XPqlGdcHe79i8MjJNzf+nr36ex/mGwmVs+6sLuY5TCho2FkK
	 Td6MUmbZxi1sq9nmX5QuCt2AymrHyDspu55MCsvQry5mEINkWyE4CyPdjyB/Y9JPcJ+At
	 L7lEAbi35EV+/KoHcur6EdH6kLnOV3DSqPqBh+kvynV5VTofEUxF0/fdhjH3VQhHMx6Jw
	 rV6v94zJySINDsxF9IP67m5lcu6pY3cMl7mojLkSA0ThnOU1OcDKd9QoeHm51Bt5y9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049000;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W+Oi+45gpKjs/4Phjisv+ytZMCwMTy3iQF8fe3T8Ju4=;
	b=Bq7TzxjPxzU91IjvypSqKtD2Kx9rHPpbsgT0wvzSizyGBwamUG1TMYzQktZPv6wO38aa
	 GYLwmByuh1AuVALeWZBxCcYfk0wJqKYMl4CNclM5ERpx+125QY9ICa18TjfUS5qK4/BgI
	 wEhDM7/UIVBweOtQIxe6zRk5tVrwpItggfIx5fj4WQxgMka6JSrBhq24gzaU2gwuSgEKp
	 JUVsYgCGWWVQyJ5dVSxIf9hD0NAZ7DJeklRGD+k7wPa6Ets4ZX6peelBPwfg4kZEoA7Ah
	 iS9GgJFwH5lT5cU8j6yMa5cEkqfUfDxIq41DdVNR3XfY+DTl7gOYgtdvW70NUFZcdzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fWCWlzP2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD23606A31C;
	Thu, 19 Nov 2026 00:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fWCWlzP2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E3401F000C4;
	Thu, 19 Nov 2026 00:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049000;
	bh=W+Oi+45gpKjs/4Phjisv+ytZMCwMTy3iQF8fe3T8Ju4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fWCWlzP2T8fAPT3EWWaM3MR09eoXdcKmPPLGSXBr/IzSZYFkJf4AyT7VY3kzOwMrU
	 cLYkMtHFMgjdp40b0m09JDeYuUbvm75poxbsWWzSF45da3+ZgSIu/UCuXAd13yHB9q
	 e1pyiDnwpnmLpOzkfEJhtDKZ38eRWcjVuiS4+SFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2196/2857] scsi: scsi_debug: Refuse a negative physblk_exp
Date: Wed, 18 Nov 2026 15:53:50 +0100
Message-ID: <20261118150320.490385315@linuxfoundation.org>
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

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit a349876633f7a583429367daf16f9a4282118255 ]

sdebug_init() refuses a physblk_exp above 15, but the parameter is a signed
int, so a negative value is accepted. The driver then shifts by it when it
builds the Block Limits VPD page, which is undefined behaviour, and READ
CAPACITY (16) reports an exponent of 15 for -1.

Refuse a negative value as well, and print it as a signed value.

Assisted-by: LLM
Fixes: ea61fca58c13 ("scsi_debug: Add support for physical block exponent and alignment")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://patch.msgid.link/20260929082456.857423-18-cassel@kernel.org
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 08dfdc00d9ea3..620911ccd134f 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6955,8 +6955,8 @@ static int __init scsi_debug_init(void)
 		return -EINVAL;
 	}
 
-	if (sdebug_physblk_exp > 15) {
-		pr_err("invalid physblk_exp %u\n", sdebug_physblk_exp);
+	if (sdebug_physblk_exp < 0 || sdebug_physblk_exp > 15) {
+		pr_err("invalid physblk_exp %d\n", sdebug_physblk_exp);
 		return -EINVAL;
 	}
 
-- 
2.53.0



