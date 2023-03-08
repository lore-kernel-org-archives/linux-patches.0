Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D7B7B
	for <patches@lists.linux.dev>; Wed,  8 Mar 2023 07:20:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0051BC433EF;
	Wed,  8 Mar 2023 07:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678260000;
	bh=aR6bB2GGlBtO9BARFVyUtoh6bM7DG1ldubDV47rx5cg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t8Y+LsjLtiqDxF4P7mv2mNOJTMJI18lFa4TEDU7fUtTfKMyz52MUx1UKkzr93JeKe
	 310D5G0rC5S2G7tuFjqgaCln5fpy+VrE/eSNkKsBTHBDWwYVO+rN9imBxa8SA95q8/
	 LKz1rvSNLSaRLvtabVBCi0MNnCwZzI13+LmmLdPw=
Date: Wed, 8 Mar 2023 08:19:57 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/567] 5.15.99-rc1 review
Message-ID: <ZAg3HXzHaE1SQQAg@kroah.com>
References: <20230307165905.838066027@linuxfoundation.org>
 <c1bc24d9-0977-4d7e-bee8-aa897b1cb435@linaro.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c1bc24d9-0977-4d7e-bee8-aa897b1cb435@linaro.org>

On Tue, Mar 07, 2023 at 05:06:23PM -0600, Daniel Díaz wrote:
> Hello!
> 
> On 07/03/23 10:55, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.99 release.
> > There are 567 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 09 Mar 2023 16:57:34 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.99-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> We see Perf failing to compile on: arm, arm64, i386, x86_64, under OpenEmbedded (GCC 11.3) when building for the following machines:
> * Dragonboard 410c (arm64)
> * Dragonboard 845c (arm64)
> * Juno (arm64)
> * X15 (arm)
> * intel-core2-32 (i386)
> * intel-corei7-64 (x86_64)
> 
> Error:
> -----8<-----
> util/intel-pt-decoder/intel-pt-decoder.c: In function 'intel_pt_eptw_lookahead_cb':
> util/intel-pt-decoder/intel-pt-decoder.c:1445:7: error: 'INTEL_PT_CFE' undeclared (first use in this function); did you mean 'INTEL_PT_CBR'?
>  1445 |  case INTEL_PT_CFE:
>       |       ^~~~~~~~~~~~
>       |       INTEL_PT_CBR
> util/intel-pt-decoder/intel-pt-decoder.c:1445:7: note: each undeclared identifier is reported only once for each function it appears in
> util/intel-pt-decoder/intel-pt-decoder.c:1446:7: error: 'INTEL_PT_CFE_IP' undeclared (first use in this function); did you mean 'INTEL_PT_BEP_IP'?
>  1446 |  case INTEL_PT_CFE_IP:
>       |       ^~~~~~~~~~~~~~~
>       |       INTEL_PT_BEP_IP
> util/intel-pt-decoder/intel-pt-decoder.c:1447:7: error: 'INTEL_PT_EVD' undeclared (first use in this function); did you mean 'INTEL_PT_OVF'?
>  1447 |  case INTEL_PT_EVD:
>       |       ^~~~~~~~~~~~
>       |       INTEL_PT_OVF
> ----->8-----

Should now be fixed.

thanks,

greg k-h
