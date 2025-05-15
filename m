Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632342253B5;
	Thu, 15 May 2025 12:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747312059; cv=none; b=Sz+bI3vWinQcKabprmuWA2SZ0YBhIovlxCIhR6d7WFbgT3mE8ldjISbUM9L82jkcY9m7ktnLNw3esNw+25cZHr4HSQYvGykZz/Qh4n9AS+rFqsIwHx5jfkpKzYThMXTxhLxFXZLAeJeD2Zk6qfhdAPHMttMKKvPq/WiIPi+V7bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747312059; c=relaxed/simple;
	bh=4DWIXHRcAJp2J4m/FFHNZtU2ownSnh3NG4wp6QerkFA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=siycYwnHnjx4YYcvI8Dmys7GR65cnkV3JYQ6DZovjoRHLlxT/b1KRa8qeApghdAXLi0grjXY599iGF5WFhR15gC3niXE3jZvtJz3yRyuGdB0V8En1bHUduk77b0Ba0RS7jgQxTRsdNAbDUpjLJIiIvR6H607ekOFkmaULwiP7Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R4BePNe/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R4BePNe/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E5FC4CEE7;
	Thu, 15 May 2025 12:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747312058;
	bh=4DWIXHRcAJp2J4m/FFHNZtU2ownSnh3NG4wp6QerkFA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R4BePNe/db93bpviLL9aQ2j7q2CT+C/BhQ63X6RCFMDtJBHjGzC08pbi312LkI/vb
	 w80RXl4Y9XM8Ble4csViBrYkiX1Vji93KRsscujGDR5zTEMST3IOlQqCQVPMvi1G82
	 UCPKC8yQ579grvk2RNLUebYxDQRUVlo7HlS+/ygQ=
Date: Thu, 15 May 2025 14:25:50 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	kees@kernel.org
Subject: Re: [PATCH 6.14 000/197] 6.14.7-rc2 review
Message-ID: <2025051529-mulled-cubicle-b1cd@gregkh>
References: <20250514125625.496402993@linuxfoundation.org>
 <vrvefaimjqkseuoyuhgg6omt2ypgp5v6xwwuxihj2t5jidizyr@ir5w67k4kl36>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <vrvefaimjqkseuoyuhgg6omt2ypgp5v6xwwuxihj2t5jidizyr@ir5w67k4kl36>

On Thu, May 15, 2025 at 08:15:32PM +0800, Shung-Hsi Yu wrote:
> On Wed, May 14, 2025 at 03:04:16PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.14.7 release.
> > There are 197 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> ...
> > Kees Cook <kees@kernel.org>
> >     mm: vmalloc: support more granular vrealloc() sizing
> 
> The above is causing a slow down in BPF verifier[1]. Assuming BPF
> selftests are somewhat representing of real world BPF programs, the slow
> down would be around 2x on average, but for an unrealistic worth-case it
> could go as high as 40x[2].
> 
> 1: https://lore.kernel.org/stable/20250515041659.smhllyarxdwp7cav@desk/
> 2: https://lore.kernel.org/stable/g4fpslyse2s6hnprgkbp23ykxn67q5wabbkpivuc3rro5bivo4@sj2o3nd5vwwm/

Is this slowdown also in 6.15-rc right now?  If so, let's work on fixing
it there first.

thanks,

greg k-h
