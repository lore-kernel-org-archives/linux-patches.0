Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 114A139FC2;
	Fri, 24 Nov 2023 18:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YFFPw2A4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BBA7C433C8;
	Fri, 24 Nov 2023 18:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850261;
	bh=b63i8nZfnqJAvhmu1gWUGU9vs6KsEPbfQHF8afHCNXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YFFPw2A4MEAAkfIW+qSF6Fj6xiBpNqhoB3xSiePWj3oEi5zCrr/jUBdyfKf0huyX8
	 /0IF+Q6Ga/aoR8LIyNuoaWGiIKOxn+AGu/yFBZqGYan5ec1KzOZ9u/KrvtAmqTy8o9
	 qnc8H1yuez6J8E2LMBkk+rf2VBwaW5GADAZpMJVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Caleb Jorden <cjorden@gmail.com>
Subject: [PATCH 6.6 509/530] x86/srso: Move retbleed IBPB check into existing has_microcode code block
Date: Fri, 24 Nov 2023 17:51:15 +0000
Message-ID: <20231124172043.657170362@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

commit 351236947a45a512c517153bbe109fe868d05e6d upstream.

Simplify the code flow a bit by moving the retbleed IBPB check into the
existing 'has_microcode' block.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/0a22b86b1f6b07f9046a9ab763fc0e0d1b7a91d4.1693889988.git.jpoimboe@kernel.org
Cc: Caleb Jorden <cjorden@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -2422,10 +2422,8 @@ static void __init srso_select_mitigatio
 			setup_force_cpu_cap(X86_FEATURE_SRSO_NO);
 			return;
 		}
-	}
 
-	if (retbleed_mitigation == RETBLEED_MITIGATION_IBPB) {
-		if (has_microcode) {
+		if (retbleed_mitigation == RETBLEED_MITIGATION_IBPB) {
 			srso_mitigation = SRSO_MITIGATION_IBPB;
 			goto out;
 		}


