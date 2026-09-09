Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7524F55A5;
	Wed,  9 Sep 2026 13:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962105; cv=none; b=dnNirAoWQ7g/IR1xbUCntPKJJ9Ec5E9pLaW78d+PPJm48cpNH7dw/0KgXHsXtV/n4qd0fNRBR61oXt0eevAMxW67v7WyCaw9HjEh/k+IQ0QvOqLAgal0zmu4rTfe9Et3vQD/QJBp4Loa7Rcd3NaNZKb4ooKYfWsgfCNQzUQ2Hjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962105; c=relaxed/simple;
	bh=sLEH4xsr2aUEawwvp2CnilLOMyFySEeebHaG8jZkGFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XpARmqMczwaEhXvuS1WecrxQ3yHVNkPSX3jvkkO7iDbvBRa4u3F5CTdC2EdE3WQYHm35VHLNg2AwoN2UgKxG8dSjxHDTapUCjiH3cjgNdma/MmUL9XkZ4QSDmLW8MXMAKVNbW9+bysXEX2DdTJiVa3cKRWg44rVX6ThWkmob9Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IkSwZbQA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IkSwZbQA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA2C1F00A3A;
	Wed,  9 Sep 2026 13:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962104;
	bh=LLHKR5qBeR/D+TuNLO33A9yMuDwDV5GrXEdrBQj42ZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IkSwZbQAnxV2qMJmuo+Js+WmUg6FO3O0AO4RLx1BOX4egL5YjvtTmuug9lLaf5/FU
	 EthuTSs11eSrpMXKEQc8SmAOGlkd5zTT1AAMK4KQp8K+JJu/z/7PleVIrAhBemAeUN
	 Jt525Rgn32SFXlJfWpgFynv9GVoIsDKObPUpbfLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 7.2 176/556] parisc: Fix alignment of asm statements in head.S
Date: Wed,  9 Sep 2026 15:37:36 +0200
Message-ID: <20260909134236.608547694@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -105,6 +105,7 @@ $iodc_panic:
 	or		%r10,%r10,%r10	/* qemu idle sleep */
 msg1:	.ascii "Can't boot kernel which was built for PA8x00 CPUs on this machine.\r\n"
 msg1_end:
+	.align 4
 
 $cpu_ok:
 #endif


