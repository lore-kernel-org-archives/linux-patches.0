Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795153528;
	b=3W58CKCCZ1r9SVQ+E0drGryVsRpX019DRL1XX9APpFWbjiOo4cmUP+MFQ1TK+WB6YNLn
	 9kPZv9oedLJib8NQUEQvEwg4p2SedvGtxQqebbdB3n8m4npogsHJGZO/69//P+tEgl/R0
	 wvGnAJ+JxmHMPsbPlOMYLA7KlT4BPJvVsHldcnOY4eEVTeIBq8za9dJtF8ZV0qC6vzAqs
	 yWLHZ1p8E6Bnct1WGY73LVNt+RF1LFb/iZU29qQGGqSkljrCmzCVLx9w8yrhkP0q9piZa
	 SNirH0XHUM/6tdGJ/JcIsIf6nU582o4pCuu0SdBJK3Ftm4w7iAGgFGg+m1+1o7xLhpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795153528;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=maiaVMoIWBRL7doRnPvtDpRD2qsjq2RDLEItOs2OO+E=;
	b=wKOvzjnDEXbxArYMPKBkivYSdyiaPDT1KzExFHr304aPOQn5rwHJNxPMON78ixnuhtDi
	 MUqF4wReW029VDSJFAbjmNvxKr2EgdnuCO+1JXQ3ljvPGiXFEmjZjRryTL+dvV5uPQI30
	 iu1dxWniVH7j/RfmdikPAQgXtmkmhAHKT5nTaFDm2i4lGZowABaDNlsihDSZ1raISe/Bm
	 2u5sismOr1BVYwOYauS+wg0NLghsUFhx2Va8kL2tUYmTC6b6RBNeQrRsVyf5toUCOq3c7
	 ak2/a961PsUC5i6nVeTKpN9yh8qFH3X0PQRT0JUJpzCTKraNHEEY+gfSnTANY9ppllw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qoPDMNR3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A90F606A325;
	Fri, 20 Nov 2026 05:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qoPDMNR3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 403AE1F000C4;
	Fri, 20 Nov 2026 05:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795153527;
	bh=maiaVMoIWBRL7doRnPvtDpRD2qsjq2RDLEItOs2OO+E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=qoPDMNR3N3hp0q6uuftoKMvP7CMQvP2ljUpY2WxSmX1QSEchuPJT2K0A7OTDa1qgu
	 mo+RU1mUAleA+2huUqxOSgaqluBy+jmtryBftNX90ssUTWAu8lUEJ9ttc4JIQbe4Kq
	 nZZ1tSbBQUQOmOF/7dFegLcVHrzlK8H6iVnAFmSw=
Date: Fri, 20 Nov 2026 06:45:25 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Brett A C Sheffield <bacs@librecast.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 5.10 0000/1848] 5.10.275-rc1 review
Message-ID: <2026112014-lemon-barista-c77f@gregkh>
References: <20261118145911.150052362@linuxfoundation.org>
 <av3U6pDFzRL3k0m3@karahi.librecast.net>
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
In-Reply-To: <av3U6pDFzRL3k0m3@karahi.librecast.net>

On Wed, Nov 18, 2026 at 05:40:10PM +0100, Brett A C Sheffield wrote:
> On 2026-11-18 15:33, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.275 release.
> > There are 1848 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 20 Nov 2026 14:55:32 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.275-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> 
> Build failure on amd64 with amdgpu.
> 
> git bisect start
> # status: waiting for both 'good' and 'bad' commits
> # bad: [12d2575b30ab6dd7d0f61ef33860d08836347cbb] Linux 5.10.275-rc1
> git bisect bad 12d2575b30ab6dd7d0f61ef33860d08836347cbb
> # status: waiting for 'good' commit(s), 'bad' commit known
> # good: [3a323bc22b881a5bdc1646080f93f5ecb22850bf] Linux 5.10.274
> git bisect good 3a323bc22b881a5bdc1646080f93f5ecb22850bf
> # good: [48be8a7d04b11bd8a2d641bfb8965ee037cab57b] xen/gntdev: Fix gntdev_dmabuf ref leak in dmabuf_exp_wait_released()
> git bisect good 48be8a7d04b11bd8a2d641bfb8965ee037cab57b
> # good: [7edc53e830e18e313c808faa4bc5d2e14d90aa34] iio: dac: ad5758: Fix the offset calculation
> git bisect good 7edc53e830e18e313c808faa4bc5d2e14d90aa34
> # good: [533ee956be520b32f60844a83d6b030ae2586849] sh: sh7785lcr: Register the PCA9564 controller as I2C bus 0
> git bisect good 533ee956be520b32f60844a83d6b030ae2586849
> # bad: [6c4061694ecb407f5d67421f35e7f550f98805df] ASoC: cs42l56: Remove the ADC Mute Switch control
> git bisect bad 6c4061694ecb407f5d67421f35e7f550f98805df
> # good: [5ed2a3e2073ef449d3f0c6d052dbfa8a55c2ff73] ASoC: soc-component: Fix return type of snd_soc_pcm_component_pointer()
> git bisect good 5ed2a3e2073ef449d3f0c6d052dbfa8a55c2ff73
> # bad: [a356793651fdb50e5b5bc0558357d578b8d405d3] selftests: netfilter: fix return value in zone subtest
> git bisect bad a356793651fdb50e5b5bc0558357d578b8d405d3
> # good: [e9e79589baa60f79c75823422974ef46fd619613] ARC: Strip libgcc debug information when generating BTF
> git bisect good e9e79589baa60f79c75823422974ef46fd619613
> # bad: [4428e62a30507763e58fb1bb017f273ec98457d5] bpf: Validate the SRH which End.DT6 uncovers in End.BPF
> git bisect bad 4428e62a30507763e58fb1bb017f273ec98457d5
> # good: [d0c3b85950d12e1808644f31f10a95461f254df0] ASoC: codecs: sta350: Fix definition of Ch2 and Ch3 Volume Bypass controls
> git bisect good d0c3b85950d12e1808644f31f10a95461f254df0
> # good: [1de066662fa2ef918a350698c90f873e803e61eb] gre: keep the UDP tunnel GSO type when completing GRO
> git bisect good 1de066662fa2ef918a350698c90f873e803e61eb
> # good: [51a5555c99ede3eed53b2999a4ab3245cf4a2e49] bpf: Fix verifier WARN on narrow read of bpf_tcp_sock u64 fields
> git bisect good 51a5555c99ede3eed53b2999a4ab3245cf4a2e49
> # first 'bad' commit: [4428e62a30507763e58fb1bb017f273ec98457d5] bpf: Validate the SRH which End.DT6 uncovers in End.BPF
> 
> Reverting 4428e62a30507763e58fb1bb017f273ec98457d5 fixes the build.

What is the build error you are getting exactly?

thanks,

greg k-h
