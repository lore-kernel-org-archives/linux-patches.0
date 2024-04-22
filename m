Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2750502BD;
	Mon, 22 Apr 2024 08:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713773931; cv=none; b=NuJM9J05bKB5B5Zgp8Wom7nWErGrOjaKD64iMq1ROOcewpko5w2h0PRzx9YQOmbFaCLi5TN9oRdFIAYRygoommG4iKBfMTWG4XFluIeHoT1prMO+Q+KE2jtun7HOKeWF/dhATNVEZhgBBBAFBpjvZBEY4XhEdMVd8Vv8vdJ43xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713773931; c=relaxed/simple;
	bh=sSY3u+8ZHO4gD1DSn/pzbn7w0OPgLJUBZ8cqjGbolh8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=qpnheTGiu4QfBqeNVbivY4Hzk2pQc3jzUhEzA30Y7hqRIjiarI0Btk1i6wiXFcQ6uVdgaLsxJwP9KVL0mHg4GuRFoOutMj6g6FmSN0EgPvM3m7nfHO9fNJqKmWbVgnwR0Et+6QJ0zbOskpHO+MkEEbvssCLTe6r+11mvbSsiZQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4VNJ6w2xtQz4x23;
	Mon, 22 Apr 2024 18:18:48 +1000 (AEST)
From: Michael Ellerman <patch-notifications@ellerman.id.au>
To: mpe@ellerman.id.au, Nathan Chancellor <nathan@kernel.org>
Cc: morbo@google.com, justinstitt@google.com, ajd@linux.ibm.com, bgray@linux.ibm.com, linuxppc-dev@lists.ozlabs.org, llvm@lists.linux.dev, patches@lists.linux.dev
In-Reply-To: <20240405-ppc-fix-wa-fatal-warnings-clang-v1-1-bdcd969f2ef0@kernel.org>
References: <20240405-ppc-fix-wa-fatal-warnings-clang-v1-1-bdcd969f2ef0@kernel.org>
Subject: Re: [PATCH] powerpc: Fix fatal warnings flag for LLVM's integrated assembler
Message-Id: <171377378380.1025456.16747240278509808133.b4-ty@ellerman.id.au>
Date: Mon, 22 Apr 2024 18:16:23 +1000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

On Fri, 05 Apr 2024 12:31:22 -0700, Nathan Chancellor wrote:
> When building with LLVM_IAS=1, there is an error because
> '-fatal-warnings' is not recognized as a valid flag:
> 
>   clang: error: unsupported argument '-fatal-warnings' to option '-Wa,'
> 
> Use the double hyphen version of the flag, '--fatal-warnings', which
> works with both the GNU assembler and LLVM's integrated assembler.
> 
> [...]

Applied to powerpc/next.

[1/1] powerpc: Fix fatal warnings flag for LLVM's integrated assembler
      https://git.kernel.org/powerpc/c/8884fc918f6aee220f9b41806974508bd0213aca

cheers
