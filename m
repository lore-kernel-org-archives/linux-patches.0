Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.211.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795161961;
	b=ntx4S25LJXo690JD6+3HWGW2NwS30Jq7IYqfSPRg0ECTG0do8OljR9QyTPdFLZeSpS2Y
	 JGRxgzfjuCiJ7pTsyeLsgGhvlQriBvkid1tG8pVcPiWT8kFxuPhyR5FS69VABKXDy26Oq
	 wOA2KUJJlpmil19NxDCD2fdJbVl2IZ/TDKqd7Gp/GPvDZCmJlXhoKXGRkWQZa8tli4Gab
	 zhMaAZQsHMjpHMWyLXufXFK0x1ec3O+YPKkbI8Cai0eZ/NtNZy4/lrRRkTk3OOi5ZLEd/
	 seGpgFjHCpfM/3eVZar/bRr5zQ2+vIJLi85gzTTEdPTNI4LG9tfn6ofwDLmvyGnzi8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795161961;
	h=DMARC-Filter:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=VSY1iDAHZ6tCyGqcPNtz1Q8eGTEUUYKlMakxCbur3ZY=;
	b=jk+0cS0886LJV5XH4zrVXG9YarvnDoDTP2CiRMlh2f59rUnnxRuWjqmGdpOrOX4z6bhD
	 PN+k8Q/4xG0Wdnq0pspA3kHuHomzA8AEGm2hdu6Wm1iUxanJYpQlYKn6d0woF8f/uoCnA
	 zxvG5XjP0TG8EKh5LpQ9EjpG4UCEXpqTzX2axIl9q9NBSvcNkbTkzGuOEEIKn6wYKeIHI
	 54FnD/6xZsMf1W2Q2Vaut2NDoz8GMTUx0gIQe1ZIzgtNsTq/EDgukMQwoADecNc8zSkkN
	 0KcmH8ADQKsMIRPCBb3PtB5rGPeCZ1gSHeBgjEGgBMbpOtOb8VVBSWFvu2vLBAUcpFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	dkim=pass header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=SXj+Tkz6;
	arc=none smtp.remote-ip=185.128.211.58
Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E44760A2611;
	Fri, 20 Nov 2026 08:06:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2E44760A2611
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=SXj+Tkz6
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=librecast.net; s=2026110900; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=VSY1iDAHZ6tCyGqcPNtz1Q8eGTEUUYKlMakxCbur3ZY=; t=1795161960; x=1796025960; 
	b=SXj+Tkz6acZZixSbPDloACsLecUXB6jHNQiCxjStUjwzl1Bm6KbxVwlGfqAi7KVeakkrtpvrcFq
	6FqtsMhskdfokSdGDklSynBloDIxjBJSaz+wMTRK+OtmjuD75IRdehmUDeZLuIoeho4DgLB3WQVNa
	QFRresny1AvGBhxjHCB6N0vF/hwUMHTCnEa90KSKOOAEeM+Vt0F2BXKhPAnbU5La+x/tkJS9YpAma
	pTthVyPEpCwc1/4IORznMLyFUbXeiu1aujNsEN4DLeACp+2eZM5640xHdrmcIZNURFcEdtbrxzAxh
	7DpgwQUsEj4JzbLZrdL7B3xxj7kubDk2YrpA==;
Date: Fri, 20 Nov 2026 08:57:13 +0100
From: Brett A C Sheffield <bacs@librecast.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 5.10 0000/1848] 5.10.275-rc1 review
Message-ID: <av_9WRciaJYhqHEK@karahi.librecast.net>
References: <20261118145911.150052362@linuxfoundation.org>
 <av3U6pDFzRL3k0m3@karahi.librecast.net>
 <2026112014-lemon-barista-c77f@gregkh>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026112014-lemon-barista-c77f@gregkh>

On 2026-11-20 06:45, Greg Kroah-Hartman wrote:
> On Wed, Nov 18, 2026 at 05:40:10PM +0100, Brett A C Sheffield wrote:
> > On 2026-11-18 15:33, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.10.275 release.
> > > There are 1848 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Fri, 20 Nov 2026 14:55:32 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.275-rc1.gz
> > > or in the git tree and branch at:
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > > and the diffstat can be found below.
> > 
> > Build failure on amd64 with amdgpu.
> > 
> > git bisect start
> > # status: waiting for both 'good' and 'bad' commits
> > # bad: [12d2575b30ab6dd7d0f61ef33860d08836347cbb] Linux 5.10.275-rc1
> > git bisect bad 12d2575b30ab6dd7d0f61ef33860d08836347cbb
> > # status: waiting for 'good' commit(s), 'bad' commit known
> > # good: [3a323bc22b881a5bdc1646080f93f5ecb22850bf] Linux 5.10.274
> > git bisect good 3a323bc22b881a5bdc1646080f93f5ecb22850bf
> > # good: [48be8a7d04b11bd8a2d641bfb8965ee037cab57b] xen/gntdev: Fix gntdev_dmabuf ref leak in dmabuf_exp_wait_released()
> > git bisect good 48be8a7d04b11bd8a2d641bfb8965ee037cab57b
> > # good: [7edc53e830e18e313c808faa4bc5d2e14d90aa34] iio: dac: ad5758: Fix the offset calculation
> > git bisect good 7edc53e830e18e313c808faa4bc5d2e14d90aa34
> > # good: [533ee956be520b32f60844a83d6b030ae2586849] sh: sh7785lcr: Register the PCA9564 controller as I2C bus 0
> > git bisect good 533ee956be520b32f60844a83d6b030ae2586849
> > # bad: [6c4061694ecb407f5d67421f35e7f550f98805df] ASoC: cs42l56: Remove the ADC Mute Switch control
> > git bisect bad 6c4061694ecb407f5d67421f35e7f550f98805df
> > # good: [5ed2a3e2073ef449d3f0c6d052dbfa8a55c2ff73] ASoC: soc-component: Fix return type of snd_soc_pcm_component_pointer()
> > git bisect good 5ed2a3e2073ef449d3f0c6d052dbfa8a55c2ff73
> > # bad: [a356793651fdb50e5b5bc0558357d578b8d405d3] selftests: netfilter: fix return value in zone subtest
> > git bisect bad a356793651fdb50e5b5bc0558357d578b8d405d3
> > # good: [e9e79589baa60f79c75823422974ef46fd619613] ARC: Strip libgcc debug information when generating BTF
> > git bisect good e9e79589baa60f79c75823422974ef46fd619613
> > # bad: [4428e62a30507763e58fb1bb017f273ec98457d5] bpf: Validate the SRH which End.DT6 uncovers in End.BPF
> > git bisect bad 4428e62a30507763e58fb1bb017f273ec98457d5
> > # good: [d0c3b85950d12e1808644f31f10a95461f254df0] ASoC: codecs: sta350: Fix definition of Ch2 and Ch3 Volume Bypass controls
> > git bisect good d0c3b85950d12e1808644f31f10a95461f254df0
> > # good: [1de066662fa2ef918a350698c90f873e803e61eb] gre: keep the UDP tunnel GSO type when completing GRO
> > git bisect good 1de066662fa2ef918a350698c90f873e803e61eb
> > # good: [51a5555c99ede3eed53b2999a4ab3245cf4a2e49] bpf: Fix verifier WARN on narrow read of bpf_tcp_sock u64 fields
> > git bisect good 51a5555c99ede3eed53b2999a4ab3245cf4a2e49
> > # first 'bad' commit: [4428e62a30507763e58fb1bb017f273ec98457d5] bpf: Validate the SRH which End.DT6 uncovers in End.BPF
> > 
> > Reverting 4428e62a30507763e58fb1bb017f273ec98457d5 fixes the build.
> 
> What is the build error you are getting exactly?

I'm sorry, all I can tell you at this point is the build was exiting non-zero
and that reverting 4428e62a3050 fixed it.  The only artifact I kept from the
build environment was the bisection log.  I have rc2 checked out now or I'd
re-run it. RC2 builds and tests OK.

-- 
Brett Sheffield (he/him)
