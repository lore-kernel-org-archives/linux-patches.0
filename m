Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E9F3161A1;
	Sat, 12 Sep 2026 13:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221427; cv=none; b=OGCnrBvzdra3v4bTfYOSyZF7TlFklWfymmeUr66TpavLyJWRJk5FItDOdIZru6fGpxUInnzGQmFNYBn8R4cE7g0vOJe/t6c9ZGOqRj+Mfhh/A2Q8H0g3/VDHcad09TcKe4JDk6aju14q1CgxVp8EAYxpJlo5o51CH17+oJ81KZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221427; c=relaxed/simple;
	bh=Lil95C4M6rk3wtRH8VPcA/Bxs0klgOYkjzJUm/06SrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a6oPaUp5SnVw6qV7729/d5kkUvdSedH2BDB2Gs6oLhfgr8QvZ2lNPO41z1wywhACGmTjjAq6ouTB//pAx/YGL14H53yxTmZSgsWG4xnj8CuEvZZQaNLmkCYzqUe3Db1BQhLHrF4uyvyqCBckxyeKsqPdHTwXLajWR4Agv/Ehvc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X0Vt+t+w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X0Vt+t+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B67981F000FF;
	Sat, 12 Sep 2026 13:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221425;
	bh=MOh06Uv78sD1A6gzJUcsWiyovdTkLaxC5huLAZAvtAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X0Vt+t+wD0OtBPYB2JQbU6mscrdWpElt/ztUQshUJfmlZN0lQZx2VLHsA1KAf3MZP
	 hTb0ehsmoW9bCINBLHIkaM1f4W/3eWHvgATluV0HrXFCNaLLWg7cNTp5Y+ClrGE8gK
	 yRD0v8/jkq5gqbnx1AUnKZsW/W3foMqFjDMfFLNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 0379/1424] parisc: Fix alignment of asm statements in head.S
Date: Sat, 12 Sep 2026 08:46:51 +0200
Message-ID: <20260912065615.780376793@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


