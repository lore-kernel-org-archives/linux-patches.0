Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11AF5A41;
	Sat, 10 Jan 2026 21:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768079748; cv=none; b=tTLqbeCaCHA4+tli/XnfRX369VFpHLO9JgL8XsEdJzzHxSnzNd73Ur+QCCt+fNQm7ft+R1WSVU2tWlKa16C/Lqk/I4x/zGMF5z+dzyP4q4KaH+aWK05ntdad0lMS2kWho/LYjRcXGU7YK8eRK8O0gtc79LlSn9jDl/BpMHko7Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768079748; c=relaxed/simple;
	bh=QwD8KnUtERO8VDxLiNrP7YwmQ0Bci1i+VhB9TVOwKnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kc1OduAkJ4cUGnY8L7rTaoqSbVlmTCGy2w00P2LXL3gmeFtchpYCj8wFB3QiOrbwIjOzMBjRStZ7VdUNPMUGrovgru2Gqnk9d9dh4c2K/8fdpJkdq06lNJnTceaDkLjU6EjEgXMNkOColUhoq5iUdjT+br1zboaj1zYlfbkaHKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lkcAwxRM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lkcAwxRM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFE91C4CEF1;
	Sat, 10 Jan 2026 21:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768079747;
	bh=QwD8KnUtERO8VDxLiNrP7YwmQ0Bci1i+VhB9TVOwKnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lkcAwxRMp+y7n0fwwsKCgy8I+jmKxzTHUXWGZP3keJyxKmmYzuScabitlQOJOV3sf
	 Am3g749XmcFWgWriH2v05DlbGvKOIQzWwFX86OzMzir2nXbWK1b+p4nxJswvjrNRNS
	 FEEOybIQtUADu+w0dkBR3XwWmV1Qv8fQA0t1yIAUZR+xPzovC3a75T5zSTnZUQ14Sq
	 nY16TteYXjVfxge8gBkhoMQvSSniXd19xXsmm6Gvvh1y8gAscZmbQQltuChGwgFE77
	 1K+sXIAk69l8zjIb1Bgto7ipv25NVsefXapWrJyg1W50LWgtPR4SIbWBtvPZ5nCNNj
	 2cznyNUdrwT0Q==
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
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.6 000/737] 6.6.120-rc1 review
Date: Sat, 10 Jan 2026 22:15:30 +0100
Message-ID: <20260110211530.119650-1-ojeda@kernel.org>
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 09 Jan 2026 12:32:19 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.120 release.
> There are 737 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Jan 2026 11:19:41 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
