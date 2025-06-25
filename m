Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9900A27F178;
	Wed, 25 Jun 2025 17:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750871487; cv=none; b=bjOzBisSD755WuOHakuRZvBW3oIsCt4fDmW6z1/cMF5by7QmX3scZIxQm8mG5GiNO9Mzl32vGOQJPR3QJlA+P5C5tTSj3llx5e06ArqX+e23RCg7CB3Yopz4Z0TGPAsZ/l2VCNZ+UKDg2ocqcMeES8/5k6x+m4ll/5w56INHkak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750871487; c=relaxed/simple;
	bh=yuXva1Qx1cHz7GN4Wu1hZkhXNKPSN9nx5xNzcpqFH8I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c81HfZd70hyzsmyY2TZA3jYKGrpLZy9YWZVja4MKVYALL0rpXJz7IYnI+8qUKM1+oT3A7n0IlqDLMiZneTLJpkS2thlt9yg/O4fHaMugnWMBov44isMsADAca0+lmraJrKsZM9f+oBkZtU6OUdbN/mIAsqdwIpB0gDxvKHC6iCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K0ntKY+g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K0ntKY+g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5690C4CEEA;
	Wed, 25 Jun 2025 17:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750871487;
	bh=yuXva1Qx1cHz7GN4Wu1hZkhXNKPSN9nx5xNzcpqFH8I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K0ntKY+gftWtEEABQyJCk2YpIwO6IgM/V+h85pu1TsNwn7ZGQHjd4HG45yfqPzkOR
	 rUMmvgeobbNJJvLSkpjzj1Aa/VYV9C/P/239HTiNMWA7YMs3KDRBf5EDvpHL+1KsJZ
	 GJssBRwa4gO9I8ggGtvTalEQmbZkIAncZTLJxp1SnlPbap13hZFLS4bYu5hdq6VpP2
	 dGHSSG00VbsIrGZtiCjHK+Pqd5m5dc4zGJn+FZ2FR7/o8GUx48oqVF/GEfdNMsbVUj
	 B+cWDUY+5TnotdGmlkRKaNNfAwkdVIs+QvWM7ef5Mtliee8D8QibAC5qSwjGTtarfl
	 UYQ83Zagwm4Hw==
Date: Wed, 25 Jun 2025 10:11:18 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, kvmarm@lists.cs.columbia.edu,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Russell King <linux@armlinux.org.uk>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	Andy Gross <agross@kernel.org>
Subject: Re: [PATCH 5.4 000/222] 5.4.295-rc1 review
Message-ID: <20250625171118.GA2987959@ax162>
References: <20250623130611.896514667@linuxfoundation.org>
 <CA+G9fYvpJjhNDS1Knh0YLeZSXawx-F4LPM-0fMrPiVkyE=yjFw@mail.gmail.com>
 <2025062425-waggle-jaybird-ef83@gregkh>
 <CA+G9fYvNTO2kObFG9RcOOAkGrRa7rgTw+5P3gmbfzuodVj6owQ@mail.gmail.com>
 <2025062508-vertical-rewrite-4bce@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025062508-vertical-rewrite-4bce@gregkh>

On Wed, Jun 25, 2025 at 09:52:27AM +0100, Greg Kroah-Hartman wrote:
> On Wed, Jun 25, 2025 at 10:03:22AM +0530, Naresh Kamboju wrote:
> > The git bisection pointing to,
> > 
> >   kbuild: Update assembler calls to use proper flags and language target
> >   commit d5c8d6e0fa61401a729e9eb6a9c7077b2d3aebb0 upstream.
> 
> Thanks for that,  I'll go drop all of the kbuild patches that Nathan
> submitted here and push out a -rc2

Thanks and sorry about the breakage. This is a bug that we missed when
d5c8d6e0fa61 was merged upstream because there were no uses of as-instr
for arch/arm at that point but there are in this tree so [1] needs to be
merged and backported with that series. I will resubmit when it lands.

[1]: https://lore.kernel.org/20250618-arm-expand-include-unified-h-path-v1-1-aef6eb4c44ca@kernel.org/

Cheers,
Nathan
