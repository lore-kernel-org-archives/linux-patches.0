Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C3958211
	for <patches@lists.linux.dev>; Tue,  5 Mar 2024 11:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709638054; cv=none; b=e7SrQn3AbLAEoFn1kUDIrNNOAVypIQzAYOb49brXgJdFwpFq4l2VDdNDe6uLqkoEUXqlvnmLfLTKgPOGu//xwOdXigjdcfzkRbR591bWniqU9SRFfFFQLCkpThUfDCvFE9l0/l8uTGXcDVFsdWmGkZPuhUA5E8vDUUAJfoTmaIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709638054; c=relaxed/simple;
	bh=NmIyi+uer4ft3Si2/NDiltp3CB467/NxrS3sOEcx25w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kOYQDTBST+B96XFglOAQORsGb1c5g0k4dEN3bYMiwH73jG677UxpgBsURn94cftdL1Z07z6OrBPfv0y+DJsN1rqggJ28V01VJL6XbkRaoLst+hzMOGuFnYEcs/6aC7yoY32BSYqL7ZD9xTa/bjjOA7AlseakMQqBUP7IsKdANys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=f0eE68xN; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="f0eE68xN"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 57ECE40E0196;
	Tue,  5 Mar 2024 11:27:27 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id gTeyGp7SjuM7; Tue,  5 Mar 2024 11:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1709638044; bh=PQkshWLVBReZdIPM5CKUSDjZ1k2jJH0v/Ls3eG6lGys=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f0eE68xNXxS+qQ16PXt7ki7acFuPzYxFs63MgRA2jwufV3OerXaprikyJ6pFORKu9
	 J67QOvB76UKqRhyy5k25Z/H7kft+KMiENHpH2XKrrPMiWCU+OkVkaL471YffLPaAdw
	 p+NSxaHNmmeHqWqyxVnOwSmaaKXYqtkjWTWL5OiKwfWgRSCOHXTAMX+i1GI0VphK+d
	 564L61Kk+/9lbNHQzn5NXUhm7NDcoYx3/CPTSO9IqqpnnuGIzRjEzlTytCKiOebaxF
	 /hij4d1i89KkcbIN+s/N5RgnyxpGjgC9U8V6Uk50cFEMWfuyZjlzVCNAoWwlV1vhXw
	 tyVNXiI+OklqrZfAYy49bmWqaH/yoM8jUJEPPui409HD7wStYAMUtrwEqFJ9pKBAkd
	 nZmLuARRAWGQq0yLwq96qkHdhI0EWv+ygAJAGCl3drFnFBoTIadUq/wFGsQp/ktkYs
	 f1OJ/Ei+JAyNT3WhgQIVkB/c0G6dpQ47cJk9KxhyM8j6o4cZNFfRN/vAgAt5SMrWmO
	 R5DTAlXgYUqWCkyZ+cRN5efZ82dukMRKYQiUTZ5f8DpHTBz8bro1IkDamo1BH6ArAw
	 SgbCB0SKZzEtZ8Z1KPlV7wrgW0T7a4edyn+wP1xyG0ddZ+Dx90nPhGOZFpMeNAY9nP
	 m2zx+QWDuNuG2XL5RqkOFxx8=
Received: from zn.tnic (pd953021b.dip0.t-ipconnect.de [217.83.2.27])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 4754A40E0185;
	Tue,  5 Mar 2024 11:27:18 +0000 (UTC)
Date: Tue, 5 Mar 2024 12:27:11 +0100
From: Borislav Petkov <bp@alien8.de>
To: Omar Sandoval <osandov@osandov.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>, stable@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH for 5.10-stable] x86/paravirt: Fix build due to
 __text_gen_insn() backport
Message-ID: <20240305112711.GAZecBj5TMaQDSz6Ym@fat_crate.local>
References: <20240227131558.694096204@linuxfoundation.org>
 <20240227131601.488092151@linuxfoundation.org>
 <ZeYXvd1-rVkPGvvW@telecaster>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZeYXvd1-rVkPGvvW@telecaster>

On Mon, Mar 04, 2024 at 10:49:33AM -0800, Omar Sandoval wrote:
> v5.10.211 is failing to build with the attached .config with the
> following error:

Ok, let's try this:

---
From: "Borislav Petkov (AMD)" <bp@alien8.de>

The Link tag has all the details but basically due to missing upstream
commits, the header which contains __text_gen_insn() is not in the
includes in paravirt.c, leading to:

  arch/x86/kernel/paravirt.c: In function 'paravirt_patch_call':
  arch/x86/kernel/paravirt.c:65:9: error: implicit declaration of function '__text_gen_insn' \
  [-Werror=implicit-function-declaration]
   65 |         __text_gen_insn(insn_buff, CALL_INSN_OPCODE,
      |         ^~~~~~~~~~~~~~~

Add the missing include.

Reported-by: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/ZeYXvd1-rVkPGvvW@telecaster
---
 arch/x86/kernel/paravirt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 5bea8d93883a..f0e4ad8595ca 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -31,6 +31,7 @@
 #include <asm/special_insns.h>
 #include <asm/tlb.h>
 #include <asm/io_bitmap.h>
+#include <asm/text-patching.h>
 
 /*
  * nop stub, which must not clobber anything *including the stack* to
-- 
2.43.0

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
