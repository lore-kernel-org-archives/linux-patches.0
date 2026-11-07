Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064357;
	b=Yu/NAz7XWa1m0dp4fn4S8+Dp4PhD9UPr7s3rg+X3Z4Yv0bFQVjdOEG6AUa3e8w+Lpi3A
	 HyFhFBR2fCfT5khVtnoeKjVPmR9bRSjTgQLMeIiEwCAxEdKFjYE0BFWgcciCUXDAn68O2
	 6dOAhbCH32YPc5jhGHZG7jZt4kb1A78ChGWN6Ut+ewIwST2Sp2omMppb9s4rz2r6E8Wgv
	 Ce0brd3u0IC+o9YJGeP602qFRfS8+w7+aV1S1SrpGDG+dSEtmp3K1eyMV25U+Ev7ZjHQU
	 sLP686LRvShkAkGtVbEfvtTbafbXK+CBgCVl47fMBeaNJ7LYkYhmoWvANkyU4NKmKfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064357;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YMtq9Aac2AcKb/FY0Z77O2+q5Ei5Ttci3+yBjP6HEB4=;
	b=XfpPXKdUTlWApFutremeZtJ8fVJ3ocns8vNlyKKrva4qP08DXuZ4Ul6G4m0gOZBt6+Fn
	 oO/8Lu1+bA7/u9xHBt4kvYjreCDVrpH+6rGqJZgFuOiTW7QThg1KUkj5Tbz8vmtS8ofLl
	 tmKXOCraScgRjSAK6c6GFT+XAfduv0+KN03CMZAYPiWAIBkH/Zvr/wyVq5GSdt+e9k4Ag
	 Plbd0Dw7rA2WOniyC2F/+BTZs4rqliA/gx+bA3xplt/DY2x5wJiLayzSby5j4F1W+8PTb
	 VD0gpIYtZAqiGtNsserkS3GDvo325zLPLJZXZ56whxbmelq40Q90oQBENQffZ0Ouhpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gZv4vd9d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E111606B88E;
	Sat,  7 Nov 2026 15:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gZv4vd9d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF88C1F0089F;
	Sat,  7 Nov 2026 15:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064356;
	bh=YMtq9Aac2AcKb/FY0Z77O2+q5Ei5Ttci3+yBjP6HEB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gZv4vd9dszfshl5bUjMN/zGHwGNXH76QsI31XqH+7+wEKMlU98sShsu/DdboSAXDb
	 UBQsGP9RQ4nCIVMUzXvJSfi5BEbBa8XSk/Cy8LWjs9OZBaAXaOgVKs6hMO79uO73MN
	 2+d0gTjPtlFrUtrXaUMjKkCUMJBzlu4KVaEFZISs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Kim Phillips <kim.phillips@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0439/1257] x86/bugs: Fix CONFIG_MITIGATION_RETPOLINE=n mitigation reporting
Date: Sat,  7 Nov 2026 08:45:35 -0500
Message-ID: <20261107134951.611765720@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 1b2381da4d831..000ebee2d247b 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1958,7 +1958,7 @@ early_param("spectre_v2", spectre_v2_parse_cmdline);
 static enum spectre_v2_mitigation __init spectre_v2_select_retpoline(void)
 {
 	if (!IS_ENABLED(CONFIG_MITIGATION_RETPOLINE)) {
-		pr_err("Kernel not compiled with retpoline; no mitigation available!");
+		pr_err("Kernel not compiled with retpoline");
 		return SPECTRE_V2_NONE;
 	}
 
-- 
2.53.0



