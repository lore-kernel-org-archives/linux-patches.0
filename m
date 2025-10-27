Received: from smtp-out3.simply.com (smtp-out3.simply.com [94.231.106.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AADD7221271;
	Mon, 27 Oct 2025 08:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.231.106.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761552920; cv=none; b=aYA7DdlCdcONb9AxFAlybU609yo8v8+RE/AiyuN1gqnC3N1nxfyyq20dXEXU9MWC2b5L5mjQmLMMKemr3z4RkVwIGNd3pm8WNVVeHOE1kjE37Ar4vedFiJH51oVhEOmJaBDkHWePXMAW42LJ1biX3lA13hR/Hm7FgOGO/K7g/UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761552920; c=relaxed/simple;
	bh=CzMWNYBpkVxjntctMxpyDnNqn3kObLOGDmZpfh4lBHc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MIrzKTYhPqpN3POCJg/wff4fqp/vYKOC5LLlzmne/+BH4OkGwZ4WiQoNjaB2eTGoWt74V010BaKe3oFlV1YVsSQyzXqrH3+cDa60TJWFr7u8nQlFVfqvyZ8E3+AVcY2pn6IIPg9XByCRs1754Eji09gFjadlHfdHhdNT/g3lhrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gaisler.com; spf=pass smtp.mailfrom=gaisler.com; dkim=fail (0-bit key) header.d=gaisler.com header.i=@gaisler.com header.b=U7oPHaKg reason="key not found in DNS"; arc=none smtp.client-ip=94.231.106.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gaisler.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gaisler.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=gaisler.com header.i=@gaisler.com header.b="U7oPHaKg"
Received: from localhost (localhost [127.0.0.1])
	by smtp.simply.com (Simply.com) with ESMTP id 4cw5kk1q7vz1DDSX;
	Mon, 27 Oct 2025 09:09:18 +0100 (CET)
Received: from [10.10.15.20] (h-98-128-223-123.NA.cust.bahnhof.se [98.128.223.123])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by smtp.simply.com (Simply.com) with ESMTPSA id 4cw5kj4mWhz1DDSD;
	Mon, 27 Oct 2025 09:09:17 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gaisler.com;
	s=simplycom2; t=1761552558;
	bh=ZLV2TZQ8o0UIo4kQoy81VsD/d+q0Y3BumdWGaXuUWFs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=U7oPHaKgL8ya1ryi1sQnGMtxdWqzLdImAv2+viSOEJzM9A6NZo5rYPOs3wkx8MITz
	 VdI2cbRdHtPmbp8gd3Sp5i0ncY5AiNcCFhpq5hC6WoaGCPK+niW2y//67xXSzIobOB
	 38t2HiXUfA4px479zvBd5RxN5gdPIqRc5rZ/bnKedw4p+y1ok8c7eA/ZFpE0AjnSVO
	 75CWmLYcHCsJzCOY7RvpvQlAFRNuZl0X7SBpWRPTt4mhIt4uqstrwDLt+pRZYE70fS
	 MVxuQZ3F9CaSnvhpYDbxUvnXYYJZviZ8PL7bo9M0p3Dc5PLgLDArCbqYW8RIs7eSoJ
	 H9HnEuMPxDzxw==
Message-ID: <62e049c9-cb92-4eaa-b069-e96ddafaad03@gaisler.com>
Date: Mon, 27 Oct 2025 09:09:17 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH AUTOSEL 6.17-5.4] sparc: Replace __ASSEMBLY__ with
 __ASSEMBLER__ in uapi headers
To: Sasha Levin <sashal@kernel.org>, patches@lists.linux.dev,
 stable@vger.kernel.org
Cc: Thomas Huth <thuth@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 sparclinux@vger.kernel.org, nathan@kernel.org, alexandre.f.demers@gmail.com,
 alexander.deucher@amd.com, llvm@lists.linux.dev
References: <20251025160905.3857885-1-sashal@kernel.org>
 <20251025160905.3857885-242-sashal@kernel.org>
Content-Language: en-US
From: Andreas Larsson <andreas@gaisler.com>
In-Reply-To: <20251025160905.3857885-242-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-10-25 17:57, Sasha Levin wrote:
> From: Thomas Huth <thuth@redhat.com>
> 
> [ Upstream commit d6fb6511de74bd0d4cb4cabddae9b31d533af1c1 ]
> 
> __ASSEMBLY__ is only defined by the Makefile of the kernel, so
> this is not really useful for uapi headers (unless the userspace
> Makefile defines it, too). Let's switch to __ASSEMBLER__ which
> gets set automatically by the compiler when compiling assembly
> code.
> 
> This is a completely mechanical patch (done with a simple "sed -i"
> statement).
> 
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Andreas Larsson <andreas@gaisler.com>
> Cc: sparclinux@vger.kernel.org
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> Reviewed-by: Andreas Larsson <andreas@gaisler.com>
> Signed-off-by: Andreas Larsson <andreas@gaisler.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---

The upstream commit dc356bf3c173 ("sparc: Drop the "-ansi" from the asflags") is
a prerequisite to d6fb6511de74 ("sparc: Replace __ASSEMBLY__ with __ASSEMBLER__
in uapi headers") that here is planned to be picked up to stable branches. If
this prerequisite is not picked up first the kernel will not compile [1].

[1] https://lore.kernel.org/all/810a8ec4-e416-42b6-97bf-8a56f41deea1@redhat.com/

Cheers,
Andreas

