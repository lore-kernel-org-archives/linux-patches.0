Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5581E145FE0;
	Sat, 25 Apr 2026 12:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777119885; cv=none; b=qGGgXX+BtTiWUwCXVCT248ZGmYOQLkxqZPZR/VAtPuqhh6bfVUr4E3+Dy6ZHYThyf2TTNYRvoANFVz47+8Sh2dfojSAfPuf6eo6PQQqi4x/+J3ZEW5HXXdqJKltkg9iDYzjdZ5PET+QBZSZ4eiLw595NZ3dMePKTzbZwO+ByOUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777119885; c=relaxed/simple;
	bh=0g41Cx4V2oyPygIAzf303PsoKAop4msEOE21Apppx+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lqaFTyALX5NbYUTdhtxDCqtrXJ+RHdTLfObi/pTFBcLgLIGa3XIcQmiZ9zDd9nC1xv/1Pvu2M+cGQvjwAoHdNe92eS6mVFiLn0KXo35g2rw+WYIrCLYtlelEcPqWPx467fVjYPyFJL0O5/ijEOOQg7mb61MkLWBwcdvVUSFVyek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EcdOs4MI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EcdOs4MI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C2DC2BCB0;
	Sat, 25 Apr 2026 12:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777119885;
	bh=0g41Cx4V2oyPygIAzf303PsoKAop4msEOE21Apppx+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EcdOs4MIO3fsYnwEPefUjKUrRz7nAId/E5hd7LRvxOsOk6bMdz1eod1DbR8UJX43v
	 QZZExERl6EPo5clj+qbKqEiBlqA/qujiAnNYdcv7PpFg/d1L6ICsABC5a0MMlxjmqw
	 Zc1Ko1vsie1/VQEbsTp1CxjAze+krgLEUREtKno4GFdlajKm9S3VymaOSQD8bRasjm
	 +TX1Add6nYTe9r2hF1hKf99xjnfZ0Z41dk/P8j4Hk7k/MYyI6TqxhHL0Cp+EtfblCh
	 H8f/0F8LHclko7vV7tjDKgrUsivlW2pOms8wgKvm4sDIsDCVMMlYJEPDq1bsxu+PxW
	 0fKN18dB8+YWg==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: achill@achill.org,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	hargar@microsoft.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@nabladev.com,
	rwarsow@gmx.de,
	shuah@kernel.org,
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.12 00/35] 6.12.84-rc1 review
Date: Sat, 25 Apr 2026 14:24:25 +0200
Message-ID: <20260425122425.162711-1-ojeda@kernel.org>
In-Reply-To: <20260424132411.427029259@linuxfoundation.org>
References: <20260424132411.427029259@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 24 Apr 2026 15:31:07 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.84 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 26 Apr 2026 13:23:21 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

The UML issue is now gone.

I also talked to Benno and Gary about the Clippy warnings and they are
OK with an `#![allow]`, so we will do that.

Thanks!

Cheers,
Miguel
