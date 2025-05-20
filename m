Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A872441B4;
	Tue, 20 May 2025 13:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749165; cv=none; b=bPrW2x/CIilEKftIHB7XuWMiSmDeHhr6omNavTxpGDloulTiiQXEbTySDoHMW7rxjMLMp4FSVRHQa/uapeZ0G0MauRZyxFDU8N1q14/M8oEtiKGsgKXUR8CJhHbdNHW82q7/FrhUAUwaXN928Sd5i6ZA+WNwJ8mUd2Md7+XKXzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749165; c=relaxed/simple;
	bh=dh5sNjP7kNb/TKRde381sunN2Kf7rlL8bq21OfAvK4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m0ItrUd+RZFg6EnT+3nxESh9tIZX2OtMBVxXx1oV0qLx018cf+lohieJ9yxuZYrjgPz88DGTGDq9mnZd8yClfqSKiSA7+o9eC9CS5WjPCU5sxBN7RMBgfmwIcFZD7zCCZH+JCV/T8c2jvA2z4KLsPlmDgwdqnSgbuKOr4px/1QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ns3Q2DRF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ns3Q2DRF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E9E8C4CEE9;
	Tue, 20 May 2025 13:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749163;
	bh=dh5sNjP7kNb/TKRde381sunN2Kf7rlL8bq21OfAvK4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ns3Q2DRFKrileK9v3+XjHId7TS7oBhSMo1LM6/HuMx/guN43QVJGm6LKvPRXowkR6
	 kGHIVM6++iaa3ZSRoCM4TU4Ia5nPsk9XniWz/wBcFc/D72XsINcHPdoJORBL670Wgg
	 O6+H6INAPwenPl+bR+QzgKCgoTTqr0kM2GrFYl70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>
Subject: [PATCH 5.15 17/59] x86/speculation: Remove the extra #ifdef around CALL_NOSPEC
Date: Tue, 20 May 2025 15:50:08 +0200
Message-ID: <20250520125754.533970365@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125753.836407405@linuxfoundation.org>
References: <20250520125753.836407405@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit c8c81458863ab686cda4fe1e603fccaae0f12460 upstream.

Commit:

  010c4a461c1d ("x86/speculation: Simplify and make CALL_NOSPEC consistent")

added an #ifdef CONFIG_RETPOLINE around the CALL_NOSPEC definition. This is
not required as this code is already under a larger #ifdef.

Remove the extra #ifdef, no functional change.

vmlinux size remains same before and after this change:

 CONFIG_RETPOLINE=y:
      text       data        bss         dec        hex    filename
  25434752    7342290    2301212    35078254    217406e    vmlinux.before
  25434752    7342290    2301212    35078254    217406e    vmlinux.after

 # CONFIG_RETPOLINE is not set:
      text       data        bss         dec        hex    filename
  22943094    6214994    1550152    30708240    1d49210    vmlinux.before
  22943094    6214994    1550152    30708240    1d49210    vmlinux.after

  [ pawan: s/CONFIG_MITIGATION_RETPOLINE/CONFIG_RETPOLINE/ ]

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Link: https://lore.kernel.org/r/20250320-call-nospec-extra-ifdef-v1-1-d9b084d24820@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/nospec-branch.h |    4 ----
 1 file changed, 4 deletions(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -295,12 +295,8 @@ extern retpoline_thunk_t __x86_indirect_
  * Inline asm uses the %V modifier which is only in newer GCC
  * which is ensured when CONFIG_RETPOLINE is defined.
  */
-#ifdef CONFIG_RETPOLINE
 #define CALL_NOSPEC	__CS_PREFIX("%V[thunk_target]")	\
 			"call __x86_indirect_thunk_%V[thunk_target]\n"
-#else
-#define CALL_NOSPEC	"call *%[thunk_target]\n"
-#endif
 
 # define THUNK_TARGET(addr) [thunk_target] "r" (addr)
 


