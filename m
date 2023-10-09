Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD5928DD9
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zm20X4/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE68C433C8;
	Mon,  9 Oct 2023 13:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858826;
	bh=lVCTU1sNEAD1R8kU+oqFH0zdItrl2bE4xmQ8Ts6Wy2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zm20X4/jKc1ueaXdX5BmH/CctmBbW69HwK1tmnuGib2CoZlo8KcQYQ9QL4HJfX5qK
	 W1Gj3BhdkK6wUa95egVvQupndQfDO4Hfs8YndIWNOiuPn8ZOrQ4pRp4kaNfxrFXMS+
	 QUZjwnfjFjJ0gA/kpPuoCP5VPltWnHxYIeZNyIRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 112/226] parisc: irq: Make irq_stack_union static to avoid sparse warning
Date: Mon,  9 Oct 2023 15:01:13 +0200
Message-ID: <20231009130129.708077086@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

[ Upstream commit b1bef1388c427cdad7331a9c8eb4ebbbe5b954b0 ]

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/kernel/irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/parisc/kernel/irq.c b/arch/parisc/kernel/irq.c
index 60f5829d476f5..2762e8540672e 100644
--- a/arch/parisc/kernel/irq.c
+++ b/arch/parisc/kernel/irq.c
@@ -388,7 +388,7 @@ union irq_stack_union {
 	volatile unsigned int lock[1];
 };
 
-DEFINE_PER_CPU(union irq_stack_union, irq_stack_union) = {
+static DEFINE_PER_CPU(union irq_stack_union, irq_stack_union) = {
 		.slock = { 1,1,1,1 },
 	};
 #endif
-- 
2.40.1



