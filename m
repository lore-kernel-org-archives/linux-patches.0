Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937F913B58D
	for <patches@lists.linux.dev>; Wed, 14 Aug 2024 07:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723621412; cv=none; b=IllKKpwWhP6R5Twh7tYgiONQ7LLy/ExO5sDbUzYpzLSAMvXl2E7FuADMOIjYRY+6uldUqvZLMolWA4IoaTSqIEFR6uZdOxhEIpSVIDG5F3Lk27uO7Z1MMC9kui2XdF4+kGyZ8kfCgJYNW5/SQDaW4DuPWp62HXhXCT+uCTD009I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723621412; c=relaxed/simple;
	bh=RE60C9dIjR3xdU+DSCU4Zt5xPZP/MHIQfAfKZ+VgP6w=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=LdkeH31bTsRV8y1laMA+tQcoorZHFE/caVam95vUi01qED3bI59RwXaPkzoNUWinQvduDeKM7yIe2Bd8LrO1P865AnQ29OaYsAspYoDiyFLkg0YZtl7kNTIh57muCth0YUgJwJmUW/JoLq7K3gk+ly0SuTN4yUuLF1hA0IKzujU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=holm.dev; spf=pass smtp.mailfrom=holm.dev; dkim=pass (2048-bit key) header.d=holm.dev header.i=@holm.dev header.b=FEi6p6jC; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=holm.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=holm.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=holm.dev header.i=@holm.dev header.b="FEi6p6jC"
Message-ID: <2d48c3c0-286d-4ed7-a3b6-5b4742b0e9d1@holm.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=holm.dev; s=key1;
	t=1723621407;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XrfB0GMhb8lHryl92k7ibI5+T1BmYcNtqYFF71b3Av4=;
	b=FEi6p6jCigsTaA6OwHtHCeFysI5w0c2Trf0PRgEJEGRRYqYixoKsIpUB9eOSRLNi3cN7I5
	jjCc7FN34oUgYagDu0KejypD97g8+hBpPCeTtFNoGdV1GjHNQbSYtv9ng0XTbgHpN5P8NG
	dWMPXlguhsclffCAJ4Vul2HoK751Wyml4jdx3xfg57AVXTFRt35ZtIQq/DSIpyZQR11vST
	q/lJ2cKHighVBGgSo/9lpVdb2FN91sbgZ51Ntn7RLZlZXJdiq2ng5tS1QmXidaoUVYy5s3
	hyU3rtYWWy1pVL/YhR6FbBdDfAEfOuo/mqpoN8ZaK0oBWcCQ2rcAJFDyUDFsYA==
Date: Wed, 14 Aug 2024 09:43:23 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 6.10 257/263] drm/amd/display: Defer handling mst up
 request in resume
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kevin Holm <kevin@holm.dev>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Lin, Wayne" <Wayne.Lin@amd.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
 "patches@lists.linux.dev" <patches@lists.linux.dev>,
 "Limonciello, Mario" <Mario.Limonciello@amd.com>,
 "Deucher, Alexander" <Alexander.Deucher@amd.com>,
 "Wu, Hersen" <hersenxs.wu@amd.com>, "Wheeler, Daniel"
 <Daniel.Wheeler@amd.com>
References: <20240812160146.517184156@linuxfoundation.org>
 <20240812160156.489958533@linuxfoundation.org>
 <235aa62e-271e-4e2b-b308-e29b561d6419@holm.dev>
 <2024081345-eggnog-unease-7b3c@gregkh>
 <CO6PR12MB5489A767C7E0B1CFAEB069A0FC862@CO6PR12MB5489.namprd12.prod.outlook.com>
 <2024081317-penniless-gondola-2c07@gregkh>
 <12516acf-bee6-4371-a745-8f9e221bc657@holm.dev>
Content-Language: en-US
In-Reply-To: <12516acf-bee6-4371-a745-8f9e221bc657@holm.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 8/13/24 21:54, Kevin Holm wrote:
> On 13.08.24 17:26, Greg Kroah-Hartman wrote:
>  > On Tue, Aug 13, 2024 at 02:41:34PM +0000, Lin, Wayne wrote:
>  >> [AMD Official Use Only - AMD Internal Distribution Only]
>  >>
>  >> Hi Greg and Kevin,
>  >>
>  >> Sorry for inconvenience, but this one should be reverted by another backport 
> patch:
>  >> "drm/amd/display: Solve mst monitors blank out problem after resume"
>  >
>  > What commit id in Linus's tree is that?
> 
>  From what I can tell it's:
> e33697141bac18 ("drm/amd/display: Solve mst monitors blank out problem after 
> resume")
> 
> You've send out a message that it failed to apply to a few of the stable trees:
> - 6.10: https://lore.kernel.org/stable/2024081212-vitally-baked-7f93@gregkh/
> - 6.6 : https://lore.kernel.org/stable/2024081213-roast-humorless-fd20@gregkh/
> - 6.1 : https://lore.kernel.org/stable/2024081213-sweep-hungry-2d10@gregkh/
> 
> To apply it on top of 6.10.5-rc1 these two patches need to be applied first:
> f63f86b5affcc2 ("drm/amd/display: Separate setting and programming of cursor")
> 1ff6631baeb1f5 ("drm/amd/display: Prevent IPX From Link Detect and Set Mode")
> 
> I don't know if that solves the problem I initially described as I'm currently
> on a different setup. What I can say is that it applying those three patches on

Applying the three patches I listed above, fixes the problem for my setup. My
external 4k monitors now get a signal both on boot and when resuming from sleep.

~kevin
> top of 6.10.5-rc1 works without conflicts and compiles without errors.
> 
> ~kevin
> 
>  > thanks,
>  >
>  > greg k-h
> 

