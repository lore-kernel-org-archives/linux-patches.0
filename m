Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C997610C;
	Sun, 22 Jun 2025 07:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750577160; cv=none; b=uPUGJVK4oyhWRjjrHxLHi42fnJPHgLmZFUxD8i0WfSx3NJfbESrQ67PfuZnh5VgwMVvVfj8fEXdKWSUVEWHWq1B8/3osB87c5idXQx5VlWAIBTiabjtF2GPjsRvZNp+VrO9Zx/fu4vsOxcorIbDucDCMBz6TvnCblfQjrtfCT60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750577160; c=relaxed/simple;
	bh=zcbbA1/2SXkp1qglZxsnSRGCPPObpRRtEYyL6aHsCbw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ql92NzzaKS6/a8SO1gb3JiozWzIWHIAy90wMyx1cPUBhm/fvnok+EW1T6D0e8lAbofcgcmqn5DWlSHaRX/WvNW6rBYRybKzKGSeWufRENwger3W4AjXXakJo3sgQ5b2/pXrmtSA/XXuiyAi/UjcuFcmucr7Ur7lz1SGHbLmlS6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fKQyJgfl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fKQyJgfl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6A4C4CEE3;
	Sun, 22 Jun 2025 07:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750577160;
	bh=zcbbA1/2SXkp1qglZxsnSRGCPPObpRRtEYyL6aHsCbw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fKQyJgflm0H4KcVcdtusHpxYIN4HrHOfjR2NTNCSo5kBU7pxZ7bHs9WgURI4PqmAD
	 eRcuJmdXuCJ+dAEvAhfUSc9pKv2RPYTPTNTlzTZDlimJ0itnp0k9JWpPZ6AC3Abh1z
	 vC+E8vQzVQLw28i/T90TiOkldyFSBYObHB1/A8cs=
Date: Sun, 22 Jun 2025 09:24:32 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pascal Ernster <git@hardfalcon.net>
Cc: Ronald Warsow <rwarsow@gmx.de>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, conor@kernel.org, hargar@microsoft.com,
	broonie@kernel.org, "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.15 000/780] 6.15.3-rc1 review
Message-ID: <2025062220-appeasing-underling-664c@gregkh>
References: <20250617152451.485330293@linuxfoundation.org>
 <f2b87714-0ef6-4210-9b30-86b4c79d1ed8@gmx.de>
 <2025061848-clinic-revered-e216@gregkh>
 <c8e4e868-aafb-4df1-8d07-62126bfe2982@hardfalcon.net>
 <097ef8cc-5304-4a7d-abc0-fd011d1235d5@hardfalcon.net>
 <2025061930-jumbo-bobsled-521a@gregkh>
 <79673bf1-1ee7-4c42-8134-ca6ead0a36ac@hardfalcon.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <79673bf1-1ee7-4c42-8134-ca6ead0a36ac@hardfalcon.net>

On Sun, Jun 22, 2025 at 12:09:42AM +0200, Pascal Ernster wrote:
> [2025-06-19 06:17] Greg Kroah-Hartman:
> > On Wed, Jun 18, 2025 at 10:31:43PM +0200, Pascal Ernster wrote:
> > > Hello again,
> > > 
> > > 
> > > I've sent this email a few minutes ago but mixed up one of the In-Reply-To
> > > message IDs, so I'm resending it now with (hopefully) the correct
> > > In-Reply-To message IDs.
> > > 
> > > 
> > > I've bisected this and found that the issue is caused by commit
> > > f46262bbc05af38565c560fd960b86a0e195fd4b:
> > > 
> > > 'Revert "mm/execmem: Unify early execmem_cache behaviour"'
> > > 
> > > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?id=f46262bbc05af38565c560fd960b86a0e195fd4b
> > > 
> > > https://lore.kernel.org/stable/20250617152521.879529420@linuxfoundation.org/
> > > 
> > > https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-6.15/revert-mm-execmem-unify-early-execmem_cache-behaviour.patch?id=344d39fc8d8b7515b45a3bf568c115da12517b22
> > 
> > Thank you for digging into this.  Looks like I took the last patch in a
> > patch series and not the previous ones, which caused this problem.  I've
> > dropped this one now and will add it back next week after I also add all
> > the other ones in the series.
> 
> 
> You're welcome! :)
> 
> Btw, the same patch has turned up again in the stable queue für 6.15.4:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/log/queue-6.15/revert-mm-execmem-unify-early-execmem_cache-behaviour.patch
> 
> Is this intentional or a mistake?

Intentional, I took the whole series this time, right?

thanks,

greg k-h
