Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123ED29ACEB;
	Mon, 12 May 2025 18:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073525; cv=none; b=hU7CFMt8BFPbLDVpbzlNgTeYW18PaOm9j0+oT6TEJlzMsYZOH0r9ZIyaselHIBeRRlDuVnKdQN05USMjEBRHuksmoBmws4CtC+FMbnESkjx+BYH3kMbw6ajNdDq3fW+UhhPZ1DlKERq5LK/8ThSxsWXs1syQt9XG7plgwg9SC2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073525; c=relaxed/simple;
	bh=340YkbON5ppfbOnXXrM66eT8bRawpzJJlCxtz2V6u+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d5uva6Zu1pjtyk30tqPtqL+wfSu8by0ubDTzy9IWwk6ZvvcaUzvsai2+SF1L17NuCu/OTYCgnpeedic/4JsvUaeIZPgscecTzyiWNSNd5bcF4QstNe5nfaNwFyzOn83SzKQIe0s2piddIIN2dSADTR+MMNJ1Jor9ymOLPWbbUqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eH8vYrpN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eH8vYrpN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F31C4CEE7;
	Mon, 12 May 2025 18:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073524;
	bh=340YkbON5ppfbOnXXrM66eT8bRawpzJJlCxtz2V6u+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eH8vYrpNzq7jlknX/u5dV93Pm/PZhjoEeub0n698b4URvmxgOvwIgtBmtVqSDn98y
	 J/kMKScaVRYSZIHfj3bWjNh5B6Ip8lmeVK96Q7R9UbsT//9XahgepSlnc2ue8sIm2k
	 zm2dINrYvOEnQ7kZE1cay7UoHcyTNmNp5xA2yV60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>
Subject: [PATCH 6.6 103/113] x86/speculation: Remove the extra #ifdef around CALL_NOSPEC
Date: Mon, 12 May 2025 19:46:32 +0200
Message-ID: <20250512172031.869710245@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -468,12 +468,8 @@ static inline void x86_set_skl_return_th
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
 


