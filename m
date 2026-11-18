Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.210.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020548;
	b=3xqYcyJFhNU2xMqkGPOsvVz11rhr4iEsRibkfU7sJZe6athwU5bxHHe1BK8S401orOqi
	 nZ3LWwj6ro1Q48Y6RvlLWxdbd3EcQ9shslk5DJy69PTXIN6bVv0sDyxspq1GJ+vwZzcIy
	 O3xwzm1Z4e+7P31MB6H7y86Nl/OfMWJfx5WHQc/VH5Co65u9i5+ANBAzj/8XgI9UITDiB
	 MDtwn3tRRCc4sAcfLJjDf9vCf/40GkUSxtjELaprO2Enqyz2VjMql9PvLvCisE193hW5Z
	 0ugpU+h4YERfBVlzzmhSX8nXKbDOkEcN4fbKpck/j7EZjhPFnD/aVEonRHPDX3kHnJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020548;
	h=DMARC-Filter:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=17jJjjEF1+rWZilPIQDSUtuio2TWtu8870uYmj+/Khg=;
	b=MoGVXSoD3LkdzW/vRpwCdLqmjVwG7nAEOA7F8KPYwUL+RJWfYLzBLd642Riu/O27QaIp
	 cZNHX0DrvCfpZ0QSsV2f8mg79mPGT2LHTLUSMuyzOn92kY5Nc1ti14F7Wskl7Vgl5zrzX
	 IuGdA09iu2jUuxpi5LjeL0nQHEH9H0tv+051vCLy0d5lXnr/KG1ZP1OyR6pOySurdj+Ok
	 A4ZWt+lNrfNE505BIu7pyaDxPNsRJOgFsYwLxRZN21GIJe30oRH5Xrf0l0UoBKiEf+lcu
	 Jm9iUm+PcgLIN3aCFmr8EPEx1xUZGC+hXPb3U4EzhpEBVolVi1ejjd+rwzBtyFZE5+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	dkim=pass header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=V7o4RqFC;
	arc=none smtp.remote-ip=185.128.210.58
Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DAF2606A336;
	Wed, 18 Nov 2026 16:49:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2DAF2606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=V7o4RqFC
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=librecast.net; s=2026110900; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=17jJjjEF1+rWZilPIQDSUtuio2TWtu8870uYmj+/Khg=; t=1795020546; x=1795884546; 
	b=V7o4RqFC50BJwOz/mx8iF4nmb475am1QJD8xyDmZHPilr6BQXnYgCe+z/QkAyKyrt3RsR73SPwK
	KpZJqTUK9llU7IU4NqL7UANeF31K4bU7xwHW42FslKTlbxxv/pQCEprAHh2TeUxEimeTv3AuPh6Z7
	9RkBy18ytK2PuQBP/+h9L4PUCO3lDjGWTBHkwqFu0zg2G3dP3fZ0yCqBzMA7ogFc9VrB1Mx3k/Sji
	KXxao+paU9Q3vI2hKyUnRsH+e54RjUudLIs5zrmnY7RaaTDV/AC7etQc1oHPMUgVe0ceM1NePKv34
	n9WkHtuLS8ft1mvPRL6eBh2gfL/equZUEEsw==;
Date: Wed, 18 Nov 2026 17:40:10 +0100
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
Message-ID: <av3U6pDFzRL3k0m3@karahi.librecast.net>
References: <20261118145911.150052362@linuxfoundation.org>
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
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>

On 2026-11-18 15:33, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.275 release.
> There are 1848 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 20 Nov 2026 14:55:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.275-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.

Build failure on amd64 with amdgpu.

git bisect start
# status: waiting for both 'good' and 'bad' commits
# bad: [12d2575b30ab6dd7d0f61ef33860d08836347cbb] Linux 5.10.275-rc1
git bisect bad 12d2575b30ab6dd7d0f61ef33860d08836347cbb
# status: waiting for 'good' commit(s), 'bad' commit known
# good: [3a323bc22b881a5bdc1646080f93f5ecb22850bf] Linux 5.10.274
git bisect good 3a323bc22b881a5bdc1646080f93f5ecb22850bf
# good: [48be8a7d04b11bd8a2d641bfb8965ee037cab57b] xen/gntdev: Fix gntdev_dmabuf ref leak in dmabuf_exp_wait_released()
git bisect good 48be8a7d04b11bd8a2d641bfb8965ee037cab57b
# good: [7edc53e830e18e313c808faa4bc5d2e14d90aa34] iio: dac: ad5758: Fix the offset calculation
git bisect good 7edc53e830e18e313c808faa4bc5d2e14d90aa34
# good: [533ee956be520b32f60844a83d6b030ae2586849] sh: sh7785lcr: Register the PCA9564 controller as I2C bus 0
git bisect good 533ee956be520b32f60844a83d6b030ae2586849
# bad: [6c4061694ecb407f5d67421f35e7f550f98805df] ASoC: cs42l56: Remove the ADC Mute Switch control
git bisect bad 6c4061694ecb407f5d67421f35e7f550f98805df
# good: [5ed2a3e2073ef449d3f0c6d052dbfa8a55c2ff73] ASoC: soc-component: Fix return type of snd_soc_pcm_component_pointer()
git bisect good 5ed2a3e2073ef449d3f0c6d052dbfa8a55c2ff73
# bad: [a356793651fdb50e5b5bc0558357d578b8d405d3] selftests: netfilter: fix return value in zone subtest
git bisect bad a356793651fdb50e5b5bc0558357d578b8d405d3
# good: [e9e79589baa60f79c75823422974ef46fd619613] ARC: Strip libgcc debug information when generating BTF
git bisect good e9e79589baa60f79c75823422974ef46fd619613
# bad: [4428e62a30507763e58fb1bb017f273ec98457d5] bpf: Validate the SRH which End.DT6 uncovers in End.BPF
git bisect bad 4428e62a30507763e58fb1bb017f273ec98457d5
# good: [d0c3b85950d12e1808644f31f10a95461f254df0] ASoC: codecs: sta350: Fix definition of Ch2 and Ch3 Volume Bypass controls
git bisect good d0c3b85950d12e1808644f31f10a95461f254df0
# good: [1de066662fa2ef918a350698c90f873e803e61eb] gre: keep the UDP tunnel GSO type when completing GRO
git bisect good 1de066662fa2ef918a350698c90f873e803e61eb
# good: [51a5555c99ede3eed53b2999a4ab3245cf4a2e49] bpf: Fix verifier WARN on narrow read of bpf_tcp_sock u64 fields
git bisect good 51a5555c99ede3eed53b2999a4ab3245cf4a2e49
# first 'bad' commit: [4428e62a30507763e58fb1bb017f273ec98457d5] bpf: Validate the SRH which End.DT6 uncovers in End.BPF

Reverting 4428e62a30507763e58fb1bb017f273ec98457d5 fixes the build.

-- 
Brett Sheffield (he/him)
