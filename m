Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975818BE5
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:49:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BBCFC433C8;
	Mon, 19 Jun 2023 10:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171784;
	bh=V1F8vLYeUEeXICI3qUJDOaqIMmr5RJhZPTfKHvk7ajI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FV8gO8Qb4CZpXpDOnEs0HMCAh+P+Z9yh3DuhzykqMvSkxsBgMClDBf7pusZY1Zps5
	 IBw0cqWv2FfFyJkFQdld7BIuQk22KyC9vH37HY9oVUWd78A5LGD3w1mPgm76NR2AdB
	 RtZ7lU+nVLwhBtejKH6Qps3ZK2OVGJOHgOda0+pI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Hutchings <benh@debian.org>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 155/166] parisc: Delete redundant register definitions in <asm/assembly.h>
Date: Mon, 19 Jun 2023 12:30:32 +0200
Message-ID: <20230619102202.209885975@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
References: <20230619102154.568541872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ben Hutchings <benh@debian.org>

commit b5b2a02bcaac7c287694aa0db4837a07bf178626 upstream.

We define sp and ipsw in <asm/asmregs.h> using ".reg", and when using
current binutils (snapshot 2.40.50.20230611) the definitions in
<asm/assembly.h> using "=" conflict with those:

arch/parisc/include/asm/assembly.h: Assembler messages:
arch/parisc/include/asm/assembly.h:93: Error: symbol `sp' is already defined
arch/parisc/include/asm/assembly.h:95: Error: symbol `ipsw' is already defined

Delete the duplicate definitions in <asm/assembly.h>.

Also delete the definition of gp, which isn't used anywhere.

Signed-off-by: Ben Hutchings <benh@debian.org>
Cc: stable@vger.kernel.org # v6.0+
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/include/asm/assembly.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/parisc/include/asm/assembly.h b/arch/parisc/include/asm/assembly.h
index 0f0d4a496fef..75677b526b2b 100644
--- a/arch/parisc/include/asm/assembly.h
+++ b/arch/parisc/include/asm/assembly.h
@@ -90,10 +90,6 @@
 #include <asm/asmregs.h>
 #include <asm/psw.h>
 
-	sp	=	30
-	gp	=	27
-	ipsw	=	22
-
 	/*
 	 * We provide two versions of each macro to convert from physical
 	 * to virtual and vice versa. The "_r1" versions take one argument
-- 
2.41.0



