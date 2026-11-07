Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063099;
	b=awq3si5ttvJvdiDVSxMPvc92oAOox2mYHkvk1Jb/MhZSw8dIiPs56P09FclxmZYHUGIQ
	 TUeXMlG1UWbO5J5e/LZ7UQe5INpamKQJccbZPCJYne3Zjr6g1mx9WpCzrXte0P+5hh3Nz
	 WxccWKlQ/1TscO5cj1WcNQrH6Jaamjp8zdmLgd96PAlKuOnd+PdsuS+q8JKlmut+bYEhG
	 WV3pdv/2URXH+dhqWNFUzRCPBtEy7TVkCkjiTKGuuxtp5ii0WNBLqrwd5nBrTcVvZPJK1
	 p3ZigAJ8ofrTI6gQMJrRDNE6mWn08+8mR1ge2vVtsxvzIdQk9Zjh2adiOGN3Dlg3fOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063099;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ETM9slyRMLxHghctt76uWdBTzKImZGyjlM2/+6djxFQ=;
	b=OUeUbHVqjOyvZsCnI1nt/yIfq9/Zz0Kwp0Tf91kSDoprNWyxFi678RJS9F1Fz7feBZ6y
	 w71STJ29luyPf0FnWsDihkcOvppSIohLU6MwAAazlRmc4bLbAnBulhQjnP/oB+vcaDCkX
	 /lfwu14bNaBDjqbk7KTM8Smsr4TvXUlJ0ImYuXldD8WkBX/6lzFMA4zk5pof7K26LnAaX
	 j7ggu2PrIFrmxCmymbXCwvzgDNwyaSN3hkQ8owVpS+Nd3cplfUkL16/jxy5ilRxIfcs3t
	 bN4n6wqNihJV45Ray6SVBej7bG25t+aHICy/IlvGSHYerE7Oc/BhynRgJBWXtMAIbwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gYCHHBOg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79700606D804;
	Sat,  7 Nov 2026 14:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gYCHHBOg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E1D1F0089F;
	Sat,  7 Nov 2026 14:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063099;
	bh=ETM9slyRMLxHghctt76uWdBTzKImZGyjlM2/+6djxFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gYCHHBOgkI7KooYLGkM9Ow24UDKew79wKQ47TmXWxCO804MhYCJ+1r1JFzRT6RMh5
	 ljX5Xsm4aJE5KlPAvZqBJhsjp0PgDRcM0lktpETIbN1NPXontlbCr7qNC0gzgR85zn
	 owD7qISC1fJsCaYQ5zcVYaR2zUKMF/Xrm2alHMOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Kim Phillips <kim.phillips@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 334/869] x86/bugs: Fix CONFIG_MITIGATION_RETPOLINE=n mitigation reporting
Date: Sat,  7 Nov 2026 08:50:16 -0500
Message-ID: <20261107134903.741095273@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kim Phillips <kim.phillips@amd.com>

[ Upstream commit 1847c80537891baead3975f3ca969233ff7b2a11 ]

When the kernel lacks retpoline support, spectre_v2_select_retpoline()
emits

  "Kernel not compiled with retpoline; no mitigation available!"

before returning SPECTRE_V2_NONE to its callers.  SPECTRE_V2_NONE is not
the final answer, though: spectre_v2_update_mitigation() runs afterwards
and can still upgrade the mitigation.

On an Intel CPU affected by RETBleed, built with

  CONFIG_MITIGATION_IBRS_ENTRY=y and
  CONFIG_MITIGATION_RETPOLINE=n,

and booted with spectre_v2=auto, retbleed_select_mitigation() picks
RETBLEED_MITIGATION_IBRS, and spectre_v2_update_mitigation() then promotes
SPECTRE_V2_NONE to SPECTRE_V2_IBRS.  The boot log claims no mitigation is
available immediately before reporting

  "Spectre V2 : Mitigation: IBRS",

and sysfs reports the machine as mitigated.  The message is alarming and
simply wrong.

Drop "no mitigation available!" because the final mitigation state is printed
afterwards in spectre_v2_update_mitigation() anyway.

  [ bp: Drop CC:stable, massage commit message. ]

Fixes: 480e803dacf8 ("x86/bugs: Restructure spectre_v2 mitigation")
Suggested-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Assisted-by: LLM
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Link: https://patch.msgid.link/20260831210916.987152-1-kim.phillips@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/bugs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index a39d97eee8bdb..90d0488d54c5c 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -2103,7 +2103,7 @@ early_param("spectre_v2", spectre_v2_parse_cmdline);
 static enum spectre_v2_mitigation __init spectre_v2_select_retpoline(void)
 {
 	if (!IS_ENABLED(CONFIG_MITIGATION_RETPOLINE)) {
-		pr_err("Kernel not compiled with retpoline; no mitigation available!");
+		pr_err("Kernel not compiled with retpoline");
 		return SPECTRE_V2_NONE;
 	}
 
-- 
2.53.0



