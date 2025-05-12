Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89254297B94;
	Mon, 12 May 2025 18:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073157; cv=none; b=I4UQ7Mq442dvDeiE2k5czQFfjotnGni3Ina1y1TW/KCVa7NEZjj0oBgkAV7Zn+JsxKTUQX3r0gTpCokDS+JGrm5rbsltBLTxOPTHC0S6M/Hx4HEUiA8iH3nj3Vbs7tiQOQv1GzVOi5kO4+qnvDcRJF78cXDXKGvfRk4UxiVHYG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073157; c=relaxed/simple;
	bh=wqrONNua3sCVKRYxHJYG4aFCLLCg9ANXHZWHMP13QoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rA/1/VwXeje6kqjH5Qci3bwXav8eWaFgoduU38SmGT/OIRwGuvRn6mOjG05Bz+6iyf0NOc9F8d7PX9Yqtig1lfhhV8ygb373Gfv8pi7LwNVGXybGweLifqoGXd6M9IGBaFMT4Lk8oms4pztt4dj9ZZIKgLYPGNAs+Mm47+DZEQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ElfMWb6z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ElfMWb6z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A709C4CEE7;
	Mon, 12 May 2025 18:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073157;
	bh=wqrONNua3sCVKRYxHJYG4aFCLLCg9ANXHZWHMP13QoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ElfMWb6zTBG8SQ8R7RoyuyQHFcdomMRdGWh0iikNDDrshqm8UE3+NXVN6ABr0JpJP
	 /bmgRnhy9JE5FkncGf/GwZwsf5lFHj3VdWe2chTue0r8LOMdUeLgz9zSKLR/r3aH2T
	 Vk8i3shaAGj8FudcHYv7fakOqY1/oSfilubn2YbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>
Subject: [PATCH 6.12 173/184] x86/speculation: Remove the extra #ifdef around CALL_NOSPEC
Date: Mon, 12 May 2025 19:46:14 +0200
Message-ID: <20250512172048.854456314@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit c8c81458863ab686cda4fe1e603fccaae0f12460 upstream.

Commit:

  010c4a461c1d ("x86/speculation: Simplify and make CALL_NOSPEC consistent")

added an #ifdef CONFIG_MITIGATION_RETPOLINE around the CALL_NOSPEC definition.
This is not required as this code is already under a larger #ifdef.

Remove the extra #ifdef, no functional change.

vmlinux size remains same before and after this change:

 CONFIG_MITIGATION_RETPOLINE=y:
      text       data        bss         dec        hex    filename
  25434752    7342290    2301212    35078254    217406e    vmlinux.before
  25434752    7342290    2301212    35078254    217406e    vmlinux.after

 # CONFIG_MITIGATION_RETPOLINE is not set:
      text       data        bss         dec        hex    filename
  22943094    6214994    1550152    30708240    1d49210    vmlinux.before
  22943094    6214994    1550152    30708240    1d49210    vmlinux.after

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
@@ -452,12 +452,8 @@ static inline void call_depth_return_thu
  * Inline asm uses the %V modifier which is only in newer GCC
  * which is ensured when CONFIG_MITIGATION_RETPOLINE is defined.
  */
-#ifdef CONFIG_MITIGATION_RETPOLINE
 #define CALL_NOSPEC	__CS_PREFIX("%V[thunk_target]")	\
 			"call __x86_indirect_thunk_%V[thunk_target]\n"
-#else
-#define CALL_NOSPEC	"call *%[thunk_target]\n"
-#endif
 
 # define THUNK_TARGET(addr) [thunk_target] "r" (addr)
 


