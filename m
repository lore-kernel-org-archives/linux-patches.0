Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6C04657EA;
	Thu, 26 Feb 2026 19:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772135634; cv=none; b=QP2K5nPd2z7eMPq8b41WtQgVQj01rqH4WsM6Ns85SLEH3tvCUM/Rpy33uOBIXjm3fb3I8bJFeJZQnRMEtpCu/FytsMSPHoThxeHqhFdMX0SmoP3j9NXD7wxkhmnRDO1ZGhT1TFdVGbOHjW9rkg5fXoPf42KEjsW/5uXpRtaLYt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772135634; c=relaxed/simple;
	bh=NoE8kUotcJ93X/TE/uSjp0u560QsI3yr0iLQxBijdRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oCEQdJDgIiUBqbg1Pg3CVAUpTGLWcYGAWpnNudnAExZzXQKKZgZlMBznfQZ7SliUZhhEv/DO2Jch6qWCitb1ranPSz2Hz/+pBhNc1wNm/jHfqul6zVaeBXdzO0FFL06QbcVQhL09dlvntZx7MKFOHhUiYiICPO8dTA/faEOb3HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E//KJyvY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E//KJyvY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 267D5C116C6;
	Thu, 26 Feb 2026 19:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772135634;
	bh=NoE8kUotcJ93X/TE/uSjp0u560QsI3yr0iLQxBijdRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E//KJyvYUAA3uY7oVas9EaMaUgm+Rc+d9HCoyvYo9gPmU2iKvDV+5IR1hnDgSLWCC
	 Tm2AkklR0pA0b3PHAiyXp/V7BKLr1YwaPQo9FVdAByXgVnq/mzoZZ3xJ5M6egWZ9x6
	 14kJdtddgcvzIzo4oyN+0SpRpfKvvJEAzyM9DHirAXQUBGyVdGY6EAp/xxotPEwoSm
	 gRtm7SnaVQ98uwh1IjbG8LgWq/taSzXya66t/HTfwWzxQWnQuDrUyNM1bo7/1KAJa3
	 tIu0dqn0G46rr5E1fw/v00u9Jp4nyEHqTbYumCsrUpGqXuTIUret2P3aDOl+yFU8Yy
	 r7BUyOrENwF7w==
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
Subject: Re: [PATCH 6.18 000/641] 6.18.14-rc2 review
Date: Thu, 26 Feb 2026 20:52:52 +0100
Message-ID: <20260226195252.25667-1-ojeda@kernel.org>
In-Reply-To: <20260225151847.709818960@linuxfoundation.org>
References: <20260225151847.709818960@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 25 Feb 2026 07:51:50 -0800 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.14 release.
> There are 641 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 27 Feb 2026 15:17:08 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
