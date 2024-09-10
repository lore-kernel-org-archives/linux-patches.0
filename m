Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3644C18E77F;
	Tue, 10 Sep 2024 10:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965080; cv=none; b=lY9hG7XkBcD/kolEJi+TNsiRo2UjvkJ3t4d+nQYBdoBtzTOfi14NsP+eYNJDa0bn+RtfPoEP4YwbpLqxZf32gpIrIOo/hNEzIcxJMUgLzd2l5k7z6bbGXmsx3Aa12MWpAatJCUiL3fB2IOu4D2oaha6LCDy4/hfrak81m/YuCnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965080; c=relaxed/simple;
	bh=z7FP6MI3CdOXNgKEvzJJRPXvE9yxDWTTbJBaq0V/bL4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WHJqzZhD8+Kwrr5QvR5zvxep3wTkyH/9t74FLOiPyRccPZP9ShtotpWH57F/Xe77uo+gIZX/7UrwwHSb9Z7D+dmzxYnoZQKdY7q5WnwjT019CHCoQS6IgR+nxTdDxWkNZ0xB+wvV5jDss4Rc/PZWSqppsLwsy22ze5U/KGPKG+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e62jTtEj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e62jTtEj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62653C4CECE;
	Tue, 10 Sep 2024 10:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965080;
	bh=z7FP6MI3CdOXNgKEvzJJRPXvE9yxDWTTbJBaq0V/bL4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e62jTtEjIApyF3AfB/A0pYMX1Id2BUUuAMKEsQD6GEUCz+pQs/QusUhW1Tg09Uq6P
	 oUMMiuSdt6Qx9iQowWsJkuf4xLfFVCf59YBdKgacjVtp20QRhdtVESBehyHQ34Vneq
	 S2FwItAxwDpYvnG/fXnUEkCrMlRs3TPT3Tf2Q5Vs=
Date: Tue, 10 Sep 2024 12:44:36 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pavel Machek <pavel@denx.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/192] 6.1.110-rc1 review
Message-ID: <2024091051-blooper-comply-47d3@gregkh>
References: <20240910092557.876094467@linuxfoundation.org>
 <ZuAhCgJ3LUBROwBR@duo.ucw.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZuAhCgJ3LUBROwBR@duo.ucw.cz>

On Tue, Sep 10, 2024 at 12:35:54PM +0200, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 6.1.110 release.
> > There are 192 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> Can you quote git hash of the 6.1.110-rc1?

Nope!  We create the git trees for those that want throw-away trees,
once I create them I automatically delete them so I don't even know the
hash anymore.

> We do have
> 
> Linux 6.1.110-rc1 (244a97bb85be)
> Greg Kroah-Hartman authored 1 day ago
> 
> passing tests
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.1.y
> 
> . But that's 1 day old.

Lots have changed since then, please use the latest.

thanks,

greg k-h
