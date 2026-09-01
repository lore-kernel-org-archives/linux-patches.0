Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCAA29BDBB;
	Tue,  1 Sep 2026 22:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788301545; cv=none; b=QuiVZnQsavdcYmBv6Vg6aZsZym4Yv7QaC7XcbzfgIhEXV8s+4rOB4jIEOYnHwi6Q0tPyDbjYJ89tkiU2QQDTpB4vENhClEqRYKsTO/pv9Aa3fxSoN4RTZvC80WXDRVxkImeNLTj6YfKtQqLZb2XF2jvUw9Fu0I/9w7saJf7b29s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788301545; c=relaxed/simple;
	bh=QHCRNAyo7a8K9X8qlls8Q0c2PE2ItLuzXA792FjXAoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g5Ez/62cLiqRBogzamTIcTM/j8eIs6pUlniipaN5CJ94rmDuZxdtZ4rY+sBWQcxN7XBv/dTeVWkW/s5LxLEc2fpqdIxFsij5cFW2BBfHtur6tAn65pHbJWIfWSv0Zo/lMWIbTGFrDonJe9jA/wTLTsh5tM9AtiLgFSeMx5Le6vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=miWbgalr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="miWbgalr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01721F000E9;
	Tue,  1 Sep 2026 22:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788301544;
	bh=4J/Yyag0zgvHsNXieZdeu73iKqrBqQw35aySa29vSzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=miWbgalrUwvaNzmY8s9QbbgfAtS/P/NinHP02J3nc41SA5Zv7GREEEsYmr/xCYvbt
	 DsWQD1GKw2KBJ4JIvI9rt2a0Ei+WuMER4G4hW3CdcUrj5Z+igWgZxhc68qykKhhZLq
	 Y7Yrn70aJW3O6N/+0GUJzKvnD7tFYkurkdcVeRsovGbmfH2l29zF7ruFVNp5Gm4dx+
	 U9Oh1cgJ1Rx6VlXcP4Yzmzuw5kwcUAu+Koaqbdx5hNZaoiSJwmAKf6oYo5XYkI5WUF
	 wnMWe6VFflnuEzQv8AiOzkkFG5u6yAjsOD5/8y7bVRHDG/YMWw63aB04Lm1r8ljoVs
	 BfxVzCGgqt0wQ==
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
Subject: Re: [PATCH 6.1 00/92] 6.1.187-rc1 review
Date: Wed,  2 Sep 2026 00:25:30 +0200
Message-ID: <20260901222530.60656-1-ojeda@kernel.org>
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 31 Aug 2026 15:33:58 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.187 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Sep 2026 13:32:19 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
