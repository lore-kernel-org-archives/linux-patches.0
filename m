Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030803;
	b=JeSFM5B8U2+K/NIfh9xoj4dJlJjftTQsAp3LVkF4Rrhga/eQHVVMglda9PuDLW4IY4fY
	 0mQC9n7qaSrxoR1NREWlAi+cYxX8GLyj7AH5YWGjBYG7sQds+w1gWdJpogEmqx9r/Rqo1
	 x23uuz3F66XfULdyiSOZLu6mSqeDIw+TFw5IkKJlCoMMQvVVzdhlKU8iwj8cm+6pgwY1r
	 M1n5FZOod8FwXkzpnHvwxGQ4vakRtsyXIOp+By6UG+FK1Ncm63TuR3U8NsH+EKMTiP0Dp
	 zmq3Y5D1UKqKmYFWpZFqAGoOqdkN2lJVVcw+nO7fGCcnolcfOd6BIxRiIRHS3EX8c8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030803;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=14BZiZ4rPCuuB1jz1jxdK/G7J6ugIsJBkm7APDjgMok=;
	b=ekVTJS5hA1fayK2iRaIoB5MAPvmbHTkX9zgnBW9/dMatR2Cq2GnPQYU+qU7NvgUV/tcZ
	 Qm5A/d6BWxqbr8dEcKUMcCBnrpqYv97GlcYODz6UAaQJ6dpedOk/KjwcspgBHl9tvtGpG
	 jCYM0BKTpM0QKUxps2td+AZEUao+nk9ZSQv0YZPVahVDH03HMB6IVG/v1hYZfaqRhBp3p
	 mRQcNXVwPWKu1/scYkHvsJWSaIvlNZ/maRS8ufrKaJJx4DcbFARP29wqyv8pg93Gv36Bf
	 l7P2yXliNCPPhXVzwcIBU3D/KYW7yQMeUAhfrGou7Fif23FinKrfkhqNHbzI6lNmdMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZwYwyxI0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A35606C713;
	Wed, 18 Nov 2026 19:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZwYwyxI0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6521F000C4;
	Wed, 18 Nov 2026 19:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030803;
	bh=14BZiZ4rPCuuB1jz1jxdK/G7J6ugIsJBkm7APDjgMok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZwYwyxI0b3EeD3+RnVeAxGbPs5lB/cC/7Ay03wtOCUG1MPyDHNo0qkhIKt6Sf8Nol
	 VqaArft7fmQaUmr83bYiAbRVkgup4HglDy+kMkrpgIULqjKqf1pSWGCJ/JxkTryEZa
	 evymXH+MEsNq0gugJDhUUz8oa/u5q2bl4NdZRUKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0793/1756] scsi: scsi_debug: Refuse a negative physblk_exp
Date: Wed, 18 Nov 2026 15:48:40 +0100
Message-ID: <20261118150041.281669711@linuxfoundation.org>
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
index de54596bbae9b..ee129f23a7c58 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -7809,8 +7809,8 @@ static int __init scsi_debug_init(void)
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



