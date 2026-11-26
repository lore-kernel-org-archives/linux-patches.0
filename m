Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.194.8.81
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795714968;
	b=IpMbm/I/svoEhHKBo1SLAw0FWUymvBrU0wg1uQogu87p//nR2/cChiB+Vm58c8RX8Tzw
	 ai3mEZjz4pj16w0JVuzIXSTNztHtUzzHVAUh/rUCNzUIngtVOgM/zZVbVjLdpNg+wK/Pd
	 WE4TGXCLFF4vc5OkXQxmvcqSWS/nSYElTExaHLNajyw2RvcwvqXKjSPckS4K9I3NwRrPb
	 pgU0WcLGAUEnf+DqbYkt9YyGslF54zzskU4Jp8mycW1MElkrQWM/2VGYvV4hUmqJbzx7c
	 kTHX8SW2p09+MG8PcKbjK79Hv2X1IXXYSN+XfTOVmXKr/Zz8YIyFsj5XYJQf+1IKdOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795714968;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=rk4WUFkSxV9JLKf6YDWqGNIH4iyjXBvocQ6QjinLjvw=;
	b=SRNeDCXorE4D/JVpcalZxQZEGGac/o0PxmyRxj5S2/TMSZGEjZWOqEQcvcPX6Y51X1PD
	 V8XW4mCFvKj6disxodMY8Qz6I5J5fGEBrTwhiai8W060/rFp5XvbFUSjoQJVtQGyJbDMg
	 Czg+90iL3txMMpJJy8LSVtnw77lVw8WOCagrcBwBE/m02heMKE/AEYjOGJzJJ2X++aDap
	 Y+e0I0tWQ5LYybNlifnAo019ORUnkU96xznD+oGlWzSgDvHscw4qVw+/x+lte84/HooBu
	 7rnUh9YXik9WebevahB+B4Bh1PAMExLYXukNNH12CYujPEIjjtUCZUvtAc3j+M7TfFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=dolcini.it;
	spf=pass smtp.mailfrom=dolcini.it;
	dkim=pass header.d=dolcini.it header.i=@dolcini.it header.a=rsa-sha256 header.s=default header.b=CMpR0e0q;
	arc=none smtp.remote-ip=217.194.8.81
Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28E8606A323
	for <patches@lists.linux.dev>; Thu, 26 Nov 2026 17:42:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F28E8606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=dolcini.it header.i=@dolcini.it header.a=rsa-sha256 header.s=default header.b=CMpR0e0q
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id 6FE811F927;
	Thu, 26 Nov 2026 18:42:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1795714966;
	bh=rk4WUFkSxV9JLKf6YDWqGNIH4iyjXBvocQ6QjinLjvw=; h=From:To:Subject;
	b=CMpR0e0q9egrTBOZVd1QNM6f8yTvtZ8BE/rgu9apMSGgh4gHLTHZaxTgxeas0eX12
	 vqEbqS+OYljpJ4jPzW4C3RpqvHRemNXbroqggAKMtLkZlo/wxiBjyoRFSMUWKoz0vy
	 P5V5xzcb9Z192ZerymnT73fx0qmwwM78wQRUStkDr05nW/XUWhePR0r97/1pDw+rU/
	 bk6P9uwn0Fj/3ZP4BmXLiJpZ+fxHmDkw53reaRgoNe4HLu6kZm05s6002F2rLp+SaV
	 ngWiSYrfAj0y18lYkffv/chMSRbmiRgtI8eiBGCo2VQvKAz3qFopu83Yr1orMEVeJq
	 Krs63QWMeehuw==
Date: Thu, 26 Nov 2026 18:42:36 +0100
From: Francesco Dolcini <francesco@dolcini.it>
To: Francesco Dolcini <francesco@dolcini.it>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	sungbyeongchan <tjdqudcks0424@naver.com>,
	"Michael S. Tsirkin" <mst@redhat.com>, Nishanth Menon <nm@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/990] 6.18.66-rc1 review
Message-ID: <20261126174236.GA183126@francesco-nb>
References: <20261125143822.072087159@linuxfoundation.org>
 <20261126173920.GA180459@francesco-nb>
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
In-Reply-To: <20261126173920.GA180459@francesco-nb>

On Thu, Nov 26, 2026 at 06:39:33PM +0100, Francesco Dolcini wrote:
> +Nishanth, Vignesh, Michael and sungbyeongchan
> 
> Hello Greg,
> 
> On Wed, Nov 25, 2026 at 03:22:47PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.18.66 release.
> > There are 990 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> Failure on various TI K3 boards (AM62, AM62P and AM69), during our CI/CD tests
> 
> [  477.440292] rtc-ds1307 0-0032: write error -110
> [  478.374406] wm8904 1-001a: ASoC error (-110): at snd_soc_component_update_bits() on wm8904.1-001a for register: [0x00000043]
> [  478.464258] rtc-ds1307 0-0032: read error -110
> [  479.520264] rtc-ds1307 0-0032: write error -110
> [  480.342404] wm8904 1-001a: ASoC error (-110): at snd_soc_component_update_bits() on wm8904.1-001a for register: [0x0000005a]
> [  480.576282] rtc-ds1307 0-0032: read error -110
> [  481.600274] rtc-ds1307 0-0032: write error -110
> [  482.310409] wm8904 1-001a: ASoC error (-110): at snd_soc_component_update_bits() on wm8904.1-001a for register: [0x0000000e]
> [  482.624288] rtc-ds1307 0-0032: read error -110
> [  483.680291] rtc-ds1307 0-0032: write error -110
> [  484.278402] wm8904 1-001a: ASoC error (-110): at soc_component_read_no_lock() on wm8904.1-001a for register: [0x0000004a]
> [  484.320383] INFO: task kworker/1:5:66 blocked for more than 362 seconds.
> [  484.330368]       Not tainted 6.18.66-rc2-8.1-devel #1
> [  484.338741] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  484.350050] INFO: task weston-simple-e:783 blocked for more than 241 seconds.
> [  484.360452]       Not tainted 6.18.66-rc2-8.1-devel #1
> 
> According to claude the issue is
> 
> commit e498eb93f961 ("virtio_ring: use shadow flags when detaching split descriptors")
> 
> and those commits should be dropped
> 
>   e498eb93f961 ("virtio_ring: use shadow flags when detaching split descriptors") [22944d517ff8]
>   9dc6b944f16c ("virtio_ring: factor out split indirect detaching logic") [44b6e54e4a0a]
>   4b7bf8d55032 ("virtio_ring: code cleanup in detach_buf_split") [032159f85f3f]
> 
> I am not able to do any test now or tomorrow, unfortunately. And the
> above analysis is just claude. Might be correct, might be wrong.

2 more cents on this, it seems that the issue is the communication with
the device manager. 

Francesco

