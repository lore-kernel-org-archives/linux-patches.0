Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF7B14D705;
	Thu, 16 May 2024 16:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715875940; cv=none; b=S7u4aDSfOIvX3qWmFdeGAn57EkitWOADmv1pWI7V3W3xYN6PZWdWQfjB0UD7ZeUauZXwRA69O5058Xit1MivyLbemZv6LpxCp1UtLwZ56tWaA5xU2zfwqhT3OCjdLhFBPRyZAwc+MWf4HfvnLJGzSFttyZQnN14TL4dMyrIUS3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715875940; c=relaxed/simple;
	bh=AveY1UwJeMZdQSc/FB03KHEVXdIe7soELOoMFXXzsTI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dl+7fIBb4GPcJuGPNWHwb5plGINnKpnfWH+R4rDEa6c6wiVzauSohmeymgRQKiGid1u/CeRyYFJkWU94du+dJvmerVenJb3g3b10Plrl4mAfmIdDiYCtnRSUUMTkTR039vVoROg1bxI2hHswP7/O+U3/LHSloZyI+99hxKLCCok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HFo6xGgJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HFo6xGgJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA1DBC113CC;
	Thu, 16 May 2024 16:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715875939;
	bh=AveY1UwJeMZdQSc/FB03KHEVXdIe7soELOoMFXXzsTI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HFo6xGgJ+sRV4F97CW4UnUXHxcepio7O92phn8ErG7qZ1sWWNTAD2C2kkxvs7ZV/7
	 WNKhzL4tyqVCSkKb6gyqDvhvgZY41nMPIuMc77TE82H+KNCfib+W+HeCni7VJjCONN
	 AVQGHkVgUNd4Kmgj8/q46+eJu4s+cHmDsyxmVTSI=
Date: Thu, 16 May 2024 18:12:16 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/308] 6.6.31-rc3 review
Message-ID: <2024051607-prune-fiber-9e23@gregkh>
References: <20240516121335.906510573@linuxfoundation.org>
 <533a6e6f-83fd-4f06-a7bb-78144839d34a@sirena.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533a6e6f-83fd-4f06-a7bb-78144839d34a@sirena.org.uk>

On Thu, May 16, 2024 at 04:41:49PM +0100, Mark Brown wrote:
> On Thu, May 16, 2024 at 02:15:01PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.6.31 release.
> > There are 308 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> Tested-by: Mark Brown <broonie@kernel.org>

Great, thanks for the quick turn-around!

greg k-h
