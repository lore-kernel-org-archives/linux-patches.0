Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E021D2B17;
	Fri,  4 Oct 2024 12:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728045459; cv=none; b=VvrVPFdYe2eEpAMXuErfIHqeR/jC+o8gK08FEnaa23u+UgakA4pjUP093eLoVf1kBGKhhS3anseDB3B1/J919YU+iOIvHsteXgxv71mxCQBRxCcpwBLbudh4hZeXGLjrZTfUccTr9iXYZys5LZt1GNHOpaS9qvznDaVzUSdM0Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728045459; c=relaxed/simple;
	bh=3zfonY9sf1wjm4sdPiwJ9/S9NQD+PWGHtrpv2Fq7FZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O4kux4u3g+M1sullVrPzOiRwqaGjLhoq0ACHdU0Uq+/Ce6AvNFHb87hDmSJybFI29Shxkpdfn/gMKYOetP68iie+q0bZzrp/FBId8fAVU5UZOXIuV0zkU+v99x72X/Mr808k2blTjgr6kfVRw+2KS2s8hKciEhSaUbq9xQ/nOWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I4Dt1rU6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I4Dt1rU6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB6A5C4CEC6;
	Fri,  4 Oct 2024 12:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728045458;
	bh=3zfonY9sf1wjm4sdPiwJ9/S9NQD+PWGHtrpv2Fq7FZY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I4Dt1rU67ncIOvQTd00T9nbmvL1N1CWXqKShkpk/I6vzIvZEEkr6aL5fXTGRW+iA0
	 TAfcEt7001/F7F6pe3hcvKTQrfNc10WSBZ+yn9L4duF6daW0vLEQwrWxkP/JsJmv5U
	 9SHv72vIT6pYMDumVYE+06gkiAfE/FUZC/+swP6U=
Date: Fri, 4 Oct 2024 14:37:35 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Wang Yugui <wangyugui@e16-tech.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.6 000/533] 6.6.54-rc2 review
Message-ID: <2024100410-daughter-pruning-e2a6@gregkh>
References: <20241004071723.69AD.409509F4@e16-tech.com>
 <2024100426-wheat-heavily-68d1@gregkh>
 <20241004185705.7AA1.409509F4@e16-tech.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241004185705.7AA1.409509F4@e16-tech.com>

On Fri, Oct 04, 2024 at 06:57:07PM +0800, Wang Yugui wrote:
> Hi,
> 
> > On Fri, Oct 04, 2024 at 07:17:24AM +0800, Wang Yugui wrote:
> > > Hi,
> > > 
> > > > This is the start of the stable review cycle for the 6.6.54 release.
> > > > There are 533 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Sat, 05 Oct 2024 10:30:30 +0000.
> > > > Anything received after that time might be too late.
> > > > 
> > > > The whole patch series can be found in one patch at:
> > > > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.54-rc2.gz
> > > > or in the git tree and branch at:
> > > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> > > > and the diffstat can be found below.
> > > 
> > > A new waring is report by 'make bzImage' in 6.6.54-rc2, 
> > > but that is not reported in 6.6.53 and 6.12-rc1.
> > > 
> > > arch/x86/tools/insn_decoder_test: warning: Found an x86 instruction decoder bug, please report this.
> > > arch/x86/tools/insn_decoder_test: warning: ffffffff8103c4d5:    c4 03 81 48 cf e9       vpermil2ps $0x9,%xmm15,%xmm14,%xmm15,%xmm9
> > > arch/x86/tools/insn_decoder_test: warning: objdump says 6 bytes, but insn_get_length() says 0
> > > arch/x86/tools/insn_decoder_test: warning: Decoded and checked 6968668 instructions with 1 failures
> > > 
> > > the root cause is yet not clear.
> > 
> > I've been seeing this locally for all 6.6.y releases, so for me it isn't
> > new, and I can't seem to track down the root cause.  As it's just now
> > showing up for you, can you do a 'git bisect' to find out the issue?
> 
> 'git bisect'  show that the root cause is
> 	x86/entry: Remove unwanted instrumentation in common_interrupt()
> 
> after reverting this patch to 6.6.54-rc2, this warning does not happen.
> 
> gcc --version:
> gcc (GCC) 8.3.1 20190311 (Red Hat 8.3.1-3)

Wow that's an old version of gcc.  can't you use anything more modern?

Anyway, that patch looks sane, it's just moving stuff around, it's not
making any new code anywhere from what I can see so perhaps the decoder
test just needs to be updated with a patch we have missed from newer
releases?  I'll dig into that after this release is out unless someone
beats me to it...

thanks,

greg k-h
