Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0CD364BE
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mzFEeQVM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 699FEC433C9;
	Wed, 15 Nov 2023 19:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076749;
	bh=5JgNTko6sZqvoVOm+hgo11kXd6X4Ih2njO1Oku4gyaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mzFEeQVMcyCjMifKYrFsbRRLi/RLTum7RZYps33ne1ilRDCqpPwgcHcGHHsEs8tAU
	 xu2rPgg3QLpc4oB1d1Epjp5IaU11nPey3bpbTjuhv/XO/YWhJHHUynJ5VRYoRo0lRH
	 9jhjnb5E8Xk96EXzGILqd8vhMHP1B4VDyetoign8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/603] x86/srso: Print mitigation for retbleed IBPB case
Date: Wed, 15 Nov 2023 14:09:20 -0500
Message-ID: <20231115191614.218136460@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

[ Upstream commit de9f5f7b06a5b7adbfdd8016f011120a4e928add ]

When overriding the requested mitigation with IBPB due to retbleed=ibpb,
print the mitigation in the usual format instead of a custom error
message.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/ec3af919e267773d896c240faf30bfc6a1fd6304.1693889988.git.jpoimboe@kernel.org
Stable-dep-of: dc6306ad5b0d ("x86/srso: Fix vulnerability reporting for missing microcode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/bugs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 2859a54660a28..d5db0baca2f14 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -2425,9 +2425,8 @@ static void __init srso_select_mitigation(void)
 
 	if (retbleed_mitigation == RETBLEED_MITIGATION_IBPB) {
 		if (has_microcode) {
-			pr_err("Retbleed IBPB mitigation enabled, using same for SRSO\n");
 			srso_mitigation = SRSO_MITIGATION_IBPB;
-			goto pred_cmd;
+			goto out;
 		}
 	}
 
@@ -2493,7 +2492,8 @@ static void __init srso_select_mitigation(void)
 		break;
 	}
 
-	pr_info("%s%s\n", srso_strings[srso_mitigation], (has_microcode ? "" : ", no microcode"));
+out:
+	pr_info("%s%s\n", srso_strings[srso_mitigation], has_microcode ? "" : ", no microcode");
 
 pred_cmd:
 	if ((!boot_cpu_has_bug(X86_BUG_SRSO) || srso_cmd == SRSO_CMD_OFF) &&
-- 
2.42.0



