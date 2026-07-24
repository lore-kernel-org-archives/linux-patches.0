Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51932433E62;
	Fri, 24 Jul 2026 11:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784891838; cv=none; b=UmqSLImz1C/9tMPZAgPTnT5/EO+Q4via2QZBG5Sfb/5ld0aLUlLeqhIqvfcIFyD3aj9q2p1g210XuHckVIz8L4Ksjsl81HSGQsn1I/LRyQHIw8z5CnySVa/klq/ZywpdV3cewW5E3YbUVzjLp0peAdoMEmyaLxjQv9A2WJPL674=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784891838; c=relaxed/simple;
	bh=2brLpdLw/vrg9oRMOCcOInMKwyXDy265QEg9ak0cEKQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=plf13vEvkd3L75aL+dJ31wAUwMykKSX8EZg2Fs5oonhnluXWzmNoktsEWbBFqBXQzHerQQt2/Y0y3jH4DGnyMTRVBipGFunQ7eASkL/f24Qv81HsbGrZT5JoL7Ao1G72jhBjeVOOWTq8aSO2RIdh0EU4goY2HsbbiMYu+tSiFtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M81COCyd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M81COCyd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEBF71F01833;
	Fri, 24 Jul 2026 11:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784891836;
	bh=fj5lgiXGhzW3XhuEYVvbBZH8cL9ce5gzlBET9tStzDE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=M81COCyd+96yVGORFUr3pz5tqWq29diiaUPa6BuwPWSCHVPUBFv1c7LAFsmr4NaiW
	 zrYx6KR3JMHP4dpqD9s015C099miF/YJM2xSZRsLr0e/PZUdIfJ1KauesSHMD8CTZo
	 7AyWl+x7Zm0r4DnoEwsa1pzlZJqhFdoNIE1GM1cw=
Date: Fri, 24 Jul 2026 13:16:57 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Danilo Krummrich <dakr@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, achill@achill.org,
	akpm@linux-foundation.org, broonie@kernel.org, conor@kernel.org,
	f.fainelli@gmail.com, hargar@microsoft.com, jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org, linux@roeck-us.net,
	lkft-triage@lists.linaro.org, patches@kernelci.org,
	patches@lists.linux.dev, pavel@nabladev.com, rwarsow@gmx.de,
	shuah@kernel.org, sr@sladewatkins.com, stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com, torvalds@linux-foundation.org,
	Eliot Courtney <ecourtney@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Alice Ryhl <aliceryhl@google.com>, nova-gpu@lists.linux.dev
Subject: Re: [PATCH 6.18 0000/1624] 6.18.40-rc2 review
Message-ID: <2026072417-avalanche-absurd-de3f@gregkh>
References: <20260722142910.893804136@linuxfoundation.org>
 <20260723154303.11008-1-ojeda@kernel.org>
 <DK68JRVCSLFU.3MCXVFEF3EE5T@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DK68JRVCSLFU.3MCXVFEF3EE5T@kernel.org>

On Thu, Jul 23, 2026 at 10:33:16PM +0200, Danilo Krummrich wrote:
> On Thu Jul 23, 2026 at 5:43 PM CEST, Miguel Ojeda wrote:
> > I suggest dropping commit
> >
> >   d8fa174e21c8 ("gpu: nova-core: vbios: read BitToken using FromBytes")
> >
> > for now -- it was not marked for stable, and as far as I know, there are
> > no production users of Nova, especially in stable kernels.
> 
> Yes, we can just drop the commit. In general, for now we should only backport
> nova patches that could get into the way of testing stable releases in one or
> the other way.

Ok, I'll just drop all the nova patches from 6.18.y and 7.1.y now as
they were not specifically tagged for stable, but just picked up due to
their Fixes: tags.

thanks,

greg k-h
