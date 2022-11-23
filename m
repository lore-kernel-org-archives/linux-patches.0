Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF58E1C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E88C433D6;
	Wed, 23 Nov 2022 09:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194706;
	bh=WBsEQ12Gj7rGSWbM3sB6+Z5vB/94Z3+pKFM2Vlxb8wE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UTxQWyDDb2XCot3WsrzlqAWaOcEcCMC2KgQt5vfWn1jyMRbXKWyc/kPcRvj8a9Zxa
	 gf9Td6NgapXq/TsQZ3mKWyTYNJ4Mf82LXHkDfHa3EHbNza/DQGMvS9oSdnUZkK7owa
	 IIOnS7X90Tu+VoZcZsVFw9QBy8juyMhzhI1/+kxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.4 039/156] MIPS: jump_label: Fix compat branch range check
Date: Wed, 23 Nov 2022 09:49:56 +0100
Message-Id: <20221123084559.337502133@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

commit 64ac0befe75bdfaffc396c2b4a0ed5ae6920eeee upstream.

Cast upper bound of branch range to long to do signed compare,
avoid negative offset trigger this warning.

Fixes: 9b6584e35f40 ("MIPS: jump_label: Use compact branches for >= r6")
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: stable@vger.kernel.org
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/kernel/jump_label.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/kernel/jump_label.c b/arch/mips/kernel/jump_label.c
index 71a882c8c6eb..f7978d50a2ba 100644
--- a/arch/mips/kernel/jump_label.c
+++ b/arch/mips/kernel/jump_label.c
@@ -56,7 +56,7 @@ void arch_jump_label_transform(struct jump_entry *e,
 			 * The branch offset must fit in the instruction's 26
 			 * bit field.
 			 */
-			WARN_ON((offset >= BIT(25)) ||
+			WARN_ON((offset >= (long)BIT(25)) ||
 				(offset < -(long)BIT(25)));
 
 			insn.j_format.opcode = bc6_op;
-- 
2.38.1



