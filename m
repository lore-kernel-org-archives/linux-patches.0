Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBD11E260A;
	Wed, 12 Mar 2025 08:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741766742; cv=none; b=c+elSZ1/wswdey2QqpnE5M8GGUvm9q5rTpDom1HvknWMGIcTPHQ9uMAG5gAN8byDX5B+ihpzQHFsB2LQ8hs3WOgsoaoL6+LI6+Vh2nSEgpeDf2wsqkKz0YTsrMACicGD0AA2wYQUnQw7Nr7Inpr44yYV66NeynXhaplBw9MdGss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741766742; c=relaxed/simple;
	bh=8joOwn5zgiw6PMnPjafoawE85VlA/Bqip/RwXux5d00=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zf6cj/RW2HYn7XCFynDcw+/d2cauoM+5m1gmwlxYsmHV5XiC9rfLvpq03OGd3utP3hRRm/wLfHKMZDiFIm5sWLSnWwaUwUmVtb4iXhQHY9il78ksUERZKZpH5MerDnMdFg0rq589pbNOX1BRo4uLBdNcKagWW69umqBsR6Pcet4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NQVDBwg5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NQVDBwg5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 837D4C4CEE3;
	Wed, 12 Mar 2025 08:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741766742;
	bh=8joOwn5zgiw6PMnPjafoawE85VlA/Bqip/RwXux5d00=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NQVDBwg5iEVDhtkWC50lnaozSMDr9NaEmowQ42RDRSdW7i7BwcygKZXzGPCZYC1wB
	 vBCNKsKQThv5tdJTT42HxwAXUMyFCCMdPdwj1PV6bqjMIqJiXEMAmCgeXARrAhFk74
	 E0UOxBZsX9QPMOoB4OTvT4pZOaql/JBJEEjOF8qg=
Date: Wed, 12 Mar 2025 09:05:39 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.4 000/328] 5.4.291-rc1 review
Message-ID: <2025031226-translate-resisting-f989@gregkh>
References: <20250311145714.865727435@linuxfoundation.org>
 <0f5c904f-e9e3-405f-a54d-d81d56dc797e@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f5c904f-e9e3-405f-a54d-d81d56dc797e@gmail.com>

On Tue, Mar 11, 2025 at 11:38:29AM -0700, Florian Fainelli wrote:
> On 3/11/25 07:56, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.291 release.
> > There are 328 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 13 Mar 2025 14:56:14 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.291-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on
> BMIPS_GENERIC:
> 
> Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
> 
> Please note that "udp: gso: do not drop small packets when PMTU reduces"
> does cause the following build warning:
> 
> In file included from ./include/linux/uio.h:8,
>                  from ./include/linux/socket.h:8,
>                  from net/ipv6/udp.c:22:
> net/ipv6/udp.c: In function 'udp_v6_send_skb':
> ./include/linux/kernel.h:843:43: warning: comparison of distinct pointer
> types lacks a cast
>   843 |                 (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
>       |                                           ^~
> ./include/linux/kernel.h:857:18: note: in expansion of macro '__typecheck'
>   857 |                 (__typecheck(x, y) && __no_side_effects(x, y))
>       |                  ^~~~~~~~~~~
> ./include/linux/kernel.h:867:31: note: in expansion of macro '__safe_cmp'
>   867 |         __builtin_choose_expr(__safe_cmp(x, y), \
>       |                               ^~~~~~~~~~
> ./include/linux/kernel.h:876:25: note: in expansion of macro '__careful_cmp'
>   876 | #define min(x, y)       __careful_cmp(x, y, <)
>       |                         ^~~~~~~~~~~~~
> net/ipv6/udp.c:1144:28: note: in expansion of macro 'min'
>  1144 |                 if (hlen + min(datalen, cork->gso_size) >
> cork->fragsize) {
>       |
> 
> we need a more targeting fix for 5.4 which replaces the use of min, with
> min_t:
> 
> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> index 58793dd7ac2c..db948e3a9bdc 100644
> --- a/net/ipv6/udp.c
> +++ b/net/ipv6/udp.c
> @@ -1141,7 +1141,7 @@ static int udp_v6_send_skb(struct sk_buff *skb, struct
> flowi6 *fl6,
>                 const int hlen = skb_network_header_len(skb) +
>                                  sizeof(struct udphdr);
> 
> -               if (hlen + min(datalen, cork->gso_size) > cork->fragsize) {
> +               if (hlen + min_t(int, datalen, cork->gso_size) >
> cork->fragsize) {
>                         kfree_skb(skb);
>                         return -EMSGSIZE;
>                 }
> 
> Thanks!

Thanks, that worked!  I'll go make this change to both 5.10.y and 5.4.y.

greg k-h
