Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92955136C
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jMywL2XF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13BB7C433C8;
	Wed,  4 Oct 2023 18:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444216;
	bh=7WEa9AfKJ7B4W0hPt1Fg1/zOSziUqukDkW/UJUD++Yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jMywL2XFbdOig7P7pBBPzOSSdgSGt68Be3vOSFjekmrrOM9qgPFXmtk4IixFGJpnI
	 hvGkRGl6peWqsvzmLyDHGvAEY+VbRxt0j6XPTtaEnhvguo+Y3f/HsKCrBvaxZeXQ/j
	 Hpg85cQjA0VbbQzMl/ypUB0D15gpG94wzLda2WYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 171/321] parisc: irq: Make irq_stack_union static to avoid sparse warning
Date: Wed,  4 Oct 2023 19:55:16 +0200
Message-ID: <20231004175237.179543518@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

[ Upstream commit b1bef1388c427cdad7331a9c8eb4ebbbe5b954b0 ]

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/kernel/irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/parisc/kernel/irq.c b/arch/parisc/kernel/irq.c
index 12c4d4104ade4..2f81bfd4f15e1 100644
--- a/arch/parisc/kernel/irq.c
+++ b/arch/parisc/kernel/irq.c
@@ -365,7 +365,7 @@ union irq_stack_union {
 	volatile unsigned int lock[1];
 };
 
-DEFINE_PER_CPU(union irq_stack_union, irq_stack_union) = {
+static DEFINE_PER_CPU(union irq_stack_union, irq_stack_union) = {
 		.slock = { 1,1,1,1 },
 	};
 #endif
-- 
2.40.1



