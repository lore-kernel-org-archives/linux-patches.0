Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD735572694;
	Wed,  9 Sep 2026 14:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963665; cv=none; b=uh4Gf5de9nAFLUlKZuF24TDYpvyjfVnfnDEyWuXWxEnib3mail/j93dajCqLzJD4KyZvIQq2JohD2rbS2QNc+D1AmauYoDgtAMT1c8h1cJfpp+dRQKk96XfaViPCYSjQ2R9N+rMxc71NUYswKFTjkGxhUJVFwkN6wIRd8YDSVEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963665; c=relaxed/simple;
	bh=klEdLSr6vedEfihRpe36ZvBweFaqsoj4TrlbjacEzjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ad1JU0Pxs9YYwnTM2CcfNd62RdZKSGbOpBB9cKN2MJpr0Nlwmk0RgfW/TM7O8PY8XiMjNtTH42U8DwZX2H8iakb6FHfPyz/Fb05xsuMcgp7XXmnulACyBd7HQC6Z2YYL/i59pAkaGLnhgV9ncU01vbTZOzi0N+uG9RjzZxsg7sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SagfCLJ+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SagfCLJ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31DAC1F00A3A;
	Wed,  9 Sep 2026 14:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963664;
	bh=bUMu6bCy/7l4QHXJBESL0QQrDXQ1fd1grj91VsTPyZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SagfCLJ+GRMQ63c0K2gOmBod+RMoByX8y4sdhVbjSvDJqB3sUMvDwIHtgT96UyuRr
	 gYS1QGGTwPaSJLIlOeag9tnGF/Y8SlQJ1zrFPQIJUe1wK4PCnIAC9FbnIYxHwMGVRK
	 QP/kUOqQIxiLdAYVbCn7WdanvkocjiebcLAMj1lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.18 120/583] parisc: Fix alignment of asm statements in head.S
Date: Wed,  9 Sep 2026 15:36:45 +0200
Message-ID: <20260909134242.290392602@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


