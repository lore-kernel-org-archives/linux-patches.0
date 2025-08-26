Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48E01F4C90;
	Tue, 26 Aug 2025 14:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218422; cv=none; b=bql04SMgIKjEDN0MEJL7FYy6d6AEB2c1pv5WnY/GWsXU6GYUStnvRwkthDt/CKgHaUJSpPmWwkFDUDVVE4V/0TBv74z1tMtAfY+WbdQHcEEJ5FqGNlYsn1rn0Y+FgWugs7mVbveqieqmIbH++28nYP/27mgWWETAsW41lTEMK5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218422; c=relaxed/simple;
	bh=2257YKTf0hZvEhw7QERhgoMA7jBQDNI1+ysTVeZGj28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XnjfmG/VZPUO5IxRMBJ3CPtkk00qKsxQ2SGHXnAhavCpBm6y3a9o+Ks7ype2NOa/fa1j7BkEpRdt/5tV7Ics9F3OIKzWG0M87IS63WjD5Q3pg1OczhFBKxAHhJxvv9BxQWny/YotLTMxgxLls/CsmqFm7lpNP/9ZOAAKP94Wdwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WxsltBcK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WxsltBcK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AF1BC113CF;
	Tue, 26 Aug 2025 14:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756218422;
	bh=2257YKTf0hZvEhw7QERhgoMA7jBQDNI1+ysTVeZGj28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WxsltBcK+j3ManeQX/b5w0YjB1wnGJo1pxCeKtl8MfhBQVYOBjAohBdswxN/cAB5k
	 xmCwzMIFd388jxAYnHJdDfkHU34Dw3/JE/LATSVknhKspcVackSL1XXRS9wGvKXX9H
	 myvPgnLh3VrkW1A6JHTaOCAiqwlbr3xgJKMb5ZHwppxvuzsrvSBuAx+AT8mpWVbsXK
	 NvthND3Q99lp6W0Du7iEUYUwe642+dCclmhXJEP9PAdVgaO7w9Zs1ZI13TqQZpub2D
	 9R4GE7ml7JZEWAIm4Az4o5qRQ7uTpwKrt+GRo2M70lPYv9a6vOecrWRVEBsyvisYCI
	 DK71kf1m1hh4Q==
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
	pavel@denx.de,
	rwarsow@gmx.de,
	shuah@kernel.org,
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.1 000/482] 6.1.149-rc1 review
Date: Tue, 26 Aug 2025 16:26:49 +0200
Message-ID: <20250826142649.711126-1-ojeda@kernel.org>
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 26 Aug 2025 13:04:13 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.149 release.
> There are 482 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 28 Aug 2025 11:08:22 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
