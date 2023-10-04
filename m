Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07AF31D523
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:03:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4CDC433C9;
	Wed,  4 Oct 2023 18:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696442629;
	bh=wK68qaoHptm/gPicNRDPFROolkXvKKTcQHzt8XQxR6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=roRIPVzw3OqUiYMtF5Hlo8gjixsqyEsaHw2AOb96UWKxnr211nouT5kBrTFjx5kEd
	 RSxkrZ2ry3SYc4Ol0mzml73GTHWKW8eeVYpD94AVGRI8NBPn78dtXBfS2v6ZvvxJrc
	 ltmjJWNt3tOyN0fqYL0PzBGNH/bRZ2eSKm2sHuBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 053/183] x86/srso: Fix SBPB enablement for spec_rstack_overflow=off
Date: Wed,  4 Oct 2023 19:54:44 +0200
Message-ID: <20231004175206.178761722@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175203.943277832@linuxfoundation.org>
References: <20231004175203.943277832@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 01b057b2f4cc2d905a0bd92195657dbd9a7005ab ]

If the user has requested no SRSO mitigation, other mitigations can use
the lighter-weight SBPB instead of IBPB.

Fixes: fb3bd914b3ec ("x86/srso: Add a Speculative RAS Overflow mitigation")
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/b20820c3cfd1003171135ec8d762a0b957348497.1693889988.git.jpoimboe@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/bugs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 78a57737f1ba1..6322a08edbba5 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -2414,7 +2414,7 @@ static void __init srso_select_mitigation(void)
 
 	switch (srso_cmd) {
 	case SRSO_CMD_OFF:
-		return;
+		goto pred_cmd;
 
 	case SRSO_CMD_MICROCODE:
 		if (has_microcode) {
-- 
2.40.1



