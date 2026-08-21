Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0291F4631;
	Fri, 21 Aug 2026 13:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787320789; cv=none; b=AbXSFb5wOhCocrFGrT8q7UQJpQpw7VnWut/ONHYCBCqljEXi1GcUJxB2qiqCtp6HGcCaVdGCENu/R613PVaZI5obJNEb5mTY5j+/Ax5t+dyxRBHZERNxTIlCqHxlgVD7l8HfwZPnQXn3VLDRl89h0cn18RcYRMd+cDUF4aM0hcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787320789; c=relaxed/simple;
	bh=6zeF/NFx9MH/jej+0q2rlmGWgZY4JxcofHngSm8HA+A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p7594En317mrPvoNRamh8bMPwUFeVcBfCox4YrQi5EfxTB6m0iKnXJ1Pe6AGWRZ+i3GxwwpGhhtP0j2htcWZqvQehvN0JqW91kbyL1LGv2g2nYECsRNajgBLxnUvUNGKH6RhRybqwQsNZf++2hoPiAj7ObFVwmvP2F6fTspUfhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KG6/wMur; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KG6/wMur"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFDF41F000E9;
	Fri, 21 Aug 2026 13:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787320787;
	bh=7IDKNTDNrSdBA3gVW8BAwvxUqc2iEpRAf2MwruvGPhg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KG6/wMurQ5h9sz8GZaRzi17W9tQL8P1whLRE9XWtOIGnvNxjcbtj1YiOBqRHIZdUo
	 U8V2tJjnlyVvOv3g0KnVqbd9RNOaAL0DCTxAkrhQlHp5/4b1tqWIoVK6C0DiOAtLKA
	 pgxemK2IsPXnIXQADQ2CZ0ZnDrtXtS0hhkxoeE2U=
Date: Fri, 21 Aug 2026 15:59:44 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ron Economos <re@w6rz.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.6 000/166] 6.6.153-rc1 review
Message-ID: <2026082132-cape-customary-fc07@gregkh>
References: <20260820145211.194104353@linuxfoundation.org>
 <ef63dced-7dc3-4436-823d-8a912f2d3b7a@w6rz.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ef63dced-7dc3-4436-823d-8a912f2d3b7a@w6rz.net>

On Thu, Aug 20, 2026 at 10:34:59PM -0700, Ron Economos wrote:
> On 8/20/26 07:54, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.6.153 release.
> > There are 166 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 22 Aug 2026 14:51:11 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.153-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > 
> The build fails with:
> 
> drivers/net/ethernet/intel/ice/ice_switch.c: In function 'ice_aq_alloc_free_vsi_list':
> drivers/net/ethernet/intel/ice/ice_switch.c:1816:23: error: implicit
> declaration of function '__struct_size'; did you mean 'struct_size'?
> [-Wimplicit-function-declaration]
>  1816 |         u16 buf_len = __struct_size(sw_buf);
>       |                       ^~~~~~~~~~~~~
>       |                       struct_size
> 
> This can be fixed by reverting commits:
> 
> "overflow: Change DEFINE_FLEX to take __counted_by member" a5c50a3af39c74eef1a15c39924b0e1f4c6a43a6
> 
> "ice: make use of DEFINE_FLEX() in ice_switch.c" 858a287aeaf8a690fd3c769e0ee2247f40e44b62
> 
> Unfortunately, the Bluetooth commits have to be reverted also (because they
> depend on "overflow: Change DEFINE_FLEX to take __counted_by member").
> 
> "Bluetooth: hci_sync: Fix advertising data UAFs" 50d4431fab38c15c9ef405b6c7e13c0491f29928
> 
> "Bluetooth: eir: Fix possible crashes on eir_create_adv_data" c4fedbbb5b925228321a359b8a3949b207cc0a62
> 
> "Bluetooth: hci_core: Fix not handling hdev->le_num_of_adv_sets=1" cf931b0c0a6a5b8b70da339101c0df17cc068488
> 
> "Bluetooth: hci_conn, hci_sync: Use __counted_by() to avoid -Wfamnae warnings" 88dd9093e398c68467d8e9c8b7fb630aab05be05
> 
> 

This is odd, because this builds here for me just fine.  Let me dig...
