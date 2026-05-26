Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AAF4421F17;
	Tue, 26 May 2026 18:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779820430; cv=none; b=L+dSmmnt9QgzWEVQs7kydqMynNPkC2gf4HVjvZo4qM4Vwzzdzf08SMl/hFXap8yMZV7pcCxM9WD1+c/t9u+6QC6KJWZrXxMi9j6ZpvoLacKb9D+BsIE7m2RWv2CJSEcEtCzAsknOBPNTVT0aRskDKKAkq7Kzo536FjzdN3O1qNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779820430; c=relaxed/simple;
	bh=LA/AM1XVU1zZHWIGcZtmjHyfCOja1Yd2PIb79QCaIYI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SAdBU7Q0ruAYqIE5AUePlqPXK26mKXNAUtJvsRsLgnv8914D4QiZxs8WgQscTZsOl3FKbqDTZNCcg3HHI0DbrXjyngOgf7DN5nXsLdGOUC7Ivo7em8C+jjESuJnycM6CBZpGFfNQntiEujXcNXLs9FyH9Ht73UNtT/fqv/jHZEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mXx3ydIL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mXx3ydIL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AB9B1F000E9;
	Tue, 26 May 2026 18:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779820427;
	bh=YRqyNA83gZxe0q1w7lVPcn4myC9qzt6H1egBiwSE624=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mXx3ydIL1qb31vY5nGb9Md20EL5FCKPj/RIeJ0RM8ZmF5CIIPX5i2yFpBdm9mQzXP
	 9w6O/rp3/Pe3MTMshZTVsL/L8kpPYrnU+yCtVgGnDDG6nrsFQY7rTbFjwBoGlPVZpW
	 wYawH20gOgS3dSIgIUaVzKWV8XD1utfFMME35QlT+C60H4P87GMcYKFHlrPULyBdac
	 UMQSds3tqUY4DX9PUJAk57Z8fEbfJXmAjDCCMej+iwMZVpVQi9ZzNgjzgibQI4c5Pb
	 LgzBQRT0VYk8O0zRC0fT+2np2KyOn1SvzoMHrwVhryggAOfaH09AZrEthV2p+vCQLM
	 iwwmf0mndB0BQ==
Date: Wed, 27 May 2026 03:33:46 +0900
From: Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>
To: Leonardo Costa <leoreis.costa@gmail.com>
Cc: ryanmatthews@fastmail.com, hongxing.zhu@nxp.com, bhelgaas@google.com, 
	linux-pci@vger.kernel.org, linux-imx@nxp.com, francesco@dolcini.it, achill@achill.org, 
	akpm@linux-foundation.org, broonie@kernel.org, conor@kernel.org, f.fainelli@gmail.com, 
	gregkh@linuxfoundation.org, hargar@microsoft.com, jonathanh@nvidia.com, 
	linux-kernel@vger.kernel.org, linux@roeck-us.net, lkft-triage@lists.linaro.org, 
	patches@kernelci.org, patches@lists.linux.dev, pavel@nabladev.com, rwarsow@gmx.de, 
	shuah@kernel.org, sr@sladewatkins.com, stable@vger.kernel.org, 
	sudipm.mukherjee@gmail.com, torvalds@linux-foundation.org
Subject: Re: [PATCH 6.6 000/508] 6.6.141-rc1 review
Message-ID: <20260526183025.GA1285841@rocinante>
References: <20260521052241.GA8766@francesco-nb>
 <20260526180537.21223-1-leoreis.costa@gmail.com>
 <20260526181726.GA1093069@rocinante>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526181726.GA1093069@rocinante>

Hello,

> When you have a moment, consider changes from the following series:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/pci/pci.git/log/?h=sysfs
> 
> Test, and let us know if this fixes the problem for you.
> 
> I would appreciate if you could test this for us.

I realise that 6.6 is a bit of a far cry from changes against the upcoming
7.2 release, so you might have to massage the series/patches into sensible
state, so to speak.

Let me know if testing is too involved, given the need to potentially
backport a lot.  I will think of something.

Thank you!

	Krzysztof
