Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795770155;
	b=4w1fNaKW9Msz9laYBMjC1vbPuhpftsqpgb0MjWTbQKVnW+twJjOW1ii65eFmmpxToyUb
	 NHtlw1iMDtnh5Z/f2nvpTBwflJyYfYF/VuJ/jtc3SRQnPq50pUcGJRC7rW3/aW+hRmYFk
	 4suWkc16NEILgeWAJyL4RHoGp9M9y1nuSiS+muXR+/qDzie9Nrp4TFPRhDgl9wKukrxE5
	 PvaBDvqA+U3hqlWz7T9nLP1A8DWuLtTfeJkR/v0MHndtp1xqGiZEIr4KrkBzAhnZh6pdA
	 R5obr3BEWVBcTK1DofHwilz56eXoasUz+//G8E905+t48TXcsC+bnOmSUbDqJIMzH7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795770155;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=12rBhZxLBZO1KzBgdN9MP8LgMGvvEaRD2RODE4fY23g=;
	b=hIk3y9fp6iqa08VTdR1Lj9FsE63vUvRhWvwMAiH7VoN4urUZ8u7VGtiOwHCuc5CNOAkc
	 fo7ABTqLNxjXtu2jZvWlf/J2mNQ4a1TnTDVGcp6UsoXnXOWqpZTVK4Ay/jt8M6JKKLEBe
	 YckSB51bx9VqQOwlDqA5+m+Pd8DYZu3L+vs29hxJIszoUeTsx13/3x55UQSGi25t8dgl1
	 xzytNggggK6uLsOD0IvQ4HOqHpGWViSJ58nWe56JLNRlUpBauabV3hsdrpCvzDIYfyGV9
	 nQynGyCyUYN+94aTfrJOfYzlSURE10FN24xTGiINhl3/Nc91z/40wh3ofChfe4Y2f+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tfZQoa8g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF46606A31E;
	Fri, 27 Nov 2026 09:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tfZQoa8g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FCC41F00929;
	Fri, 27 Nov 2026 09:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795770154;
	bh=12rBhZxLBZO1KzBgdN9MP8LgMGvvEaRD2RODE4fY23g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=tfZQoa8gUqBK3DXvc1ofF4GRvPOH3/0sd7edB/vdMfwYAvkPJ7PrvA0Vs+8+II/37
	 gc2LweREtB1EkxBNJCzoeQc6N2Wg1bF9b25b3Zw7Pfm8v7CW/jLRQbUMEvXGaWm45f
	 wTgWB2bPha+SlHlsWOepdzRZsSlgH7eXS3CvYMGI=
Date: Fri, 27 Nov 2026 10:02:29 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Francesco Dolcini <francesco@dolcini.it>
Cc: sungbyeongchan <tjdqudcks0424@naver.com>,
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
Message-ID: <2026112702-donator-rebuff-16b2@gregkh>
References: <20261125143822.072087159@linuxfoundation.org>
 <20261126173920.GA180459@francesco-nb>
 <20261126174236.GA183126@francesco-nb>
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
In-Reply-To: <20261126174236.GA183126@francesco-nb>

On Thu, Nov 26, 2026 at 06:42:36PM +0100, Francesco Dolcini wrote:
> On Thu, Nov 26, 2026 at 06:39:33PM +0100, Francesco Dolcini wrote:
> > +Nishanth, Vignesh, Michael and sungbyeongchan
> > 
> > Hello Greg,
> > 
> > On Wed, Nov 25, 2026 at 03:22:47PM +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.18.66 release.
> > > There are 990 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > 
> > Failure on various TI K3 boards (AM62, AM62P and AM69), during our CI/CD tests
> > 
> > [  477.440292] rtc-ds1307 0-0032: write error -110
> > [  478.374406] wm8904 1-001a: ASoC error (-110): at snd_soc_component_update_bits() on wm8904.1-001a for register: [0x00000043]
> > [  478.464258] rtc-ds1307 0-0032: read error -110
> > [  479.520264] rtc-ds1307 0-0032: write error -110
> > [  480.342404] wm8904 1-001a: ASoC error (-110): at snd_soc_component_update_bits() on wm8904.1-001a for register: [0x0000005a]
> > [  480.576282] rtc-ds1307 0-0032: read error -110
> > [  481.600274] rtc-ds1307 0-0032: write error -110
> > [  482.310409] wm8904 1-001a: ASoC error (-110): at snd_soc_component_update_bits() on wm8904.1-001a for register: [0x0000000e]
> > [  482.624288] rtc-ds1307 0-0032: read error -110
> > [  483.680291] rtc-ds1307 0-0032: write error -110
> > [  484.278402] wm8904 1-001a: ASoC error (-110): at soc_component_read_no_lock() on wm8904.1-001a for register: [0x0000004a]
> > [  484.320383] INFO: task kworker/1:5:66 blocked for more than 362 seconds.
> > [  484.330368]       Not tainted 6.18.66-rc2-8.1-devel #1
> > [  484.338741] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [  484.350050] INFO: task weston-simple-e:783 blocked for more than 241 seconds.
> > [  484.360452]       Not tainted 6.18.66-rc2-8.1-devel #1
> > 
> > According to claude the issue is
> > 
> > commit e498eb93f961 ("virtio_ring: use shadow flags when detaching split descriptors")
> > 
> > and those commits should be dropped
> > 
> >   e498eb93f961 ("virtio_ring: use shadow flags when detaching split descriptors") [22944d517ff8]
> >   9dc6b944f16c ("virtio_ring: factor out split indirect detaching logic") [44b6e54e4a0a]
> >   4b7bf8d55032 ("virtio_ring: code cleanup in detach_buf_split") [032159f85f3f]
> > 
> > I am not able to do any test now or tomorrow, unfortunately. And the
> > above analysis is just claude. Might be correct, might be wrong.
> 
> 2 more cents on this, it seems that the issue is the communication with
> the device manager. 

What do you mean by this?  What "device manager" and why does virtio
have anything to do with that?

confused,

greg k-h
