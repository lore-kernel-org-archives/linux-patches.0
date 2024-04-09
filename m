Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095037E101;
	Tue,  9 Apr 2024 08:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712653081; cv=none; b=Uf59cGaKjUqD7pUy3yBD6AgNtv4jzm1H6ObPoKHwsR+Fbqw7Kcft3IVIv81tg/PcR6Y9G0konBddPgEpkVGleL5YpSztbfGytvj0JvfSxQ16QgklGbc8fmfAEoRtLr9rKpBa7vm5V8ZHcD2RChYsfqZXkqhQYTyCCXC53ncqyic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712653081; c=relaxed/simple;
	bh=SrPS1SoFdFAOpaMBtOJKXgICKkkVwjju2OEbJERQvXM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Dd7FvVZXbmEmZEep2ZmxxY+44ffo68CKi0vHKPHjZkdpW6XuLhpRNKpHnVBTnz+nuGkNm6tH24sH/AsEo7z6zfhdH2ruE3YeBMmSGU2FsWOyrOnooV8Sgd9OFK7dL4KctZQw87XlcPUS+lQeh5HqJLlQluAmrwnNLYjLdeNGTg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b=rOGIeJ6l; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="rOGIeJ6l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1712653077;
	bh=P0pjqDL1fQu8o32YoyNBzlgTnO0AyBJXTa6E6xDr6hU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=rOGIeJ6l4xVwwk0XjnOyhmsxAhk7452CumvunomtGki62pburr68/pa/bAyB/8fmF
	 sNBzAUR42JbhUXWhVXbSl28qOaua/fy5NL1L0K2XHQGpOANWVSHklb2zO1G9Y6X7i3
	 ypyHOH/Mo06MNu0WmgAY4hPn3bch9mLTYJdfQ7cBbiUi4oxqb9o3+0ErOkr6B+gEAo
	 G8EQqAz40W3Cs4TgP1wNqZmADkG7nAk8gWgQpmrL9aPyP/i0vNCJA9P+laAuamvYHb
	 YjAsmd31TKmB1CUd7Sx33GqTIYdGiyR+Miy+KK3Mxpha836sJKXKK1UOsSLjEEHdqE
	 rex1j5CzXFJJQ==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4VDKc519mMz4wqM;
	Tue,  9 Apr 2024 18:57:57 +1000 (AEST)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Nathan Chancellor <nathan@kernel.org>
Cc: morbo@google.com, justinstitt@google.com, ajd@linux.ibm.com,
 bgray@linux.ibm.com, linuxppc-dev@lists.ozlabs.org, llvm@lists.linux.dev,
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
Subject: Re: [PATCH] powerpc: Fix fatal warnings flag for LLVM's integrated
 assembler
In-Reply-To: <20240405-ppc-fix-wa-fatal-warnings-clang-v1-1-bdcd969f2ef0@kernel.org>
References: <20240405-ppc-fix-wa-fatal-warnings-clang-v1-1-bdcd969f2ef0@kernel.org>
Date: Tue, 09 Apr 2024 18:57:56 +1000
Message-ID: <87y19map63.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Nathan Chancellor <nathan@kernel.org> writes:
> When building with LLVM_IAS=1, there is an error because
> '-fatal-warnings' is not recognized as a valid flag:
>
>   clang: error: unsupported argument '-fatal-warnings' to option '-Wa,'
>
> Use the double hyphen version of the flag, '--fatal-warnings', which
> works with both the GNU assembler and LLVM's integrated assembler.
>
> Fixes: 608d4a5ca563 ("powerpc: Error on assembly warnings")

Thanks.

I guess I need to do some of my clang builds with LLVM_IAS=1 :}

cheers
