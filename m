Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED652EFDAD;
	Mon,  8 Sep 2025 09:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757322550; cv=none; b=dVEM+RfExPKJ6tAC69qqRqqrw8rAK2gG6BiYlqz54T9IiPFe7XN63x6DajxzbXTRqzjffZu0N2nwF9ria9f/FwBSieBVULelHIP+4gE2kcv5gEdWScRWh5SiRZIBayxKE+3w6mEhPKvMxb4KDRQyL3DN3WugN0LY/2wlVQKN4Ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757322550; c=relaxed/simple;
	bh=d4EWkqTmWTK+QVtfkDOawxf1iVy4btAiduZLlzXIOxE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=En2bmV7wVasqn+3Y6g9/pKDoKZt3Cp9yVWwnKiVoMQasrUEy9LZbAwfhmZyKMQrKuyaN6j6+3bbffWQhyKudBz3TTwgaKvv2oVm7qWLpT752U7s1+hcFgQTs6ZTZS1nWDaDjf1g4fZm5Gu2hZUU0XCX++qDTxSESfbUdhNotAg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DIAuUmi+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DIAuUmi+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66050C4CEF9;
	Mon,  8 Sep 2025 09:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757322550;
	bh=d4EWkqTmWTK+QVtfkDOawxf1iVy4btAiduZLlzXIOxE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DIAuUmi+iBCXjvtZXZZDoaSq9EEbQBZmjbGMoPrvATgdhaHft0PFjZc+plS2pOiUk
	 XJx/Q51AwHDUe1kU4XxIp1nwa38AmLaGNqOGkwsPlY8lkokPY7GfjiXiamHOhTDFs+
	 O0e2gjx1aKyMUMNfKUOpg0oTOtf5wW0b6mJvFuvo=
Date: Mon, 8 Sep 2025 11:09:06 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org
Subject: Re: [PATCH 6.1 000/104] 6.1.151-rc1 review
Message-ID: <2025090811-pendant-calm-09c5@gregkh>
References: <20250907195607.664912704@linuxfoundation.org>
 <6a53318e-13f1-4c38-a9cb-88955247b666@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a53318e-13f1-4c38-a9cb-88955247b666@gmail.com>

On Sun, Sep 07, 2025 at 08:00:39PM -0700, Florian Fainelli wrote:
> 
> 
> On 9/7/2025 12:57 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.151 release.
> > There are 104 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.151-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> perf fails to build with:
> 
> util/bpf-utils.c: In function 'get_bpf_prog_info_linear':
> util/bpf-utils.c:129:26: error: '__MAX_BPF_PROG_TYPE' undeclared (first use
> in this function); did you mean 'MAX_BPF_LINK_TYPE'?
>   129 |         if (info.type >= __MAX_BPF_PROG_TYPE)
>       |                          ^~~~~~~~~~~~~~~~~~~
>       |                          MAX_BPF_LINK_TYPE
> util/bpf-utils.c:129:26: note: each undeclared identifier is reported only
> once for each function it appears in
> 
> which is due to  05c6ce9491f1851d63c40e918ed5cf7902fd43d3 ("perf bpf-utils:
> Harden get_bpf_prog_info_linear")
> 
> Looks like we need caf8f28e036c4ba1e823355da6c0c01c39e70ab9 ("bpf: Add BPF
> token support to BPF_PROG_LOAD command") which adds the definition for
> __MAX_BPF_PROG_TYPE, unfortunately there is a lot going on there that this
> won't apply cleanly.

Ick.  I'll just drop the perf patch, thanks for noticing this.  And I'll
drop the patch after this one for both 6.1.y and 6.6.y.

thanks,

greg k-h
