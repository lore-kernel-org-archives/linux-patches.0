Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F012D0C94;
	Sat, 12 Sep 2026 19:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241978; cv=none; b=FZZyYLbZ69AGHLMziznU/iIcSPttYm63BORXT3osRhiNymnNUCSKUuR7U/9b+MLO2ATM4wmGFVE7PSRuJPlg/EhuKWPWKrxKEKIXultm36Ks0+0SVRd6Xuki3KlFw5Jt6A4QPVoDwPBFsp2+OYKNz1tv/x2GvZbM78rwm2UC+OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241978; c=relaxed/simple;
	bh=/fLZzSaoXOCjb7RyGHxCzX1MmZY8P8ELoirSY/+wpvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d1zYc2Zqp0f5NTFjyrBSOUpgllLPxhSYufRQVtecBtSm1nq2CoUt4VwbisRfHczJ6yYsphGHCniIJKf6WT3Unh5qQesmiRz3/iIpf0iJXsmooOIrk4WrE6RrVbwMf6n58/dG/My4TWm+fHCrlt7V2rxe/Likybus8gt29q4pgTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l9jhrlqE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l9jhrlqE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 863651F000FF;
	Sat, 12 Sep 2026 19:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241977;
	bh=JG+YY7hxjJmEcIxvCF0c15n+kNiutYpTy76+uTmz9IM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l9jhrlqEvBvf4OfE+FTJ7GjC0peFkZu7i4nvfGBeIF4AzglQKMjER/vepaSiAey9f
	 lbG8Fvph/U/pGNWCUKs2dbbHTU6hqOcmi9chY+/DFiR+mBfu75ype7k1vYYDH7dxvL
	 kfWmTTpNxEyo4a/C7uMhvn3pjNt1hPXZ03uwHRwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 240/798] parisc: Fix alignment of asm statements in head.S
Date: Sat, 12 Sep 2026 08:57:48 +0200
Message-ID: <20260912065522.658758696@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 04cf68c9a76e3c6b67ad056a66a14923abf85925 upstream.

All assembler statements need to be 4-byte aligned. Prevent a possible
misalignment if someone changes the preceeding string and it's length is
then suddenly not a multiple of 4 any longer.

Cc: stable@vger.kernel.org
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/head.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/parisc/kernel/head.S
+++ b/arch/parisc/kernel/head.S
@@ -104,6 +104,7 @@ $iodc_panic:
 	or		%r10,%r10,%r10	/* qemu idle sleep */
 msg1:	.ascii "Can't boot kernel which was built for PA8x00 CPUs on this machine.\r\n"
 msg1_end:
+	.align 4
 
 $cpu_ok:
 #endif


