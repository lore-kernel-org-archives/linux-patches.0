Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DD621B1B9;
	Wed, 25 Jun 2025 08:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750839932; cv=none; b=Zf7E/9ggbvneTdB57MZ3NfBxBA+LjB8MLCPB432EXnOLr2fe3oIZRhk2cwuJV00BrDf5KlUUio7k99OMVl30/g8pjNuWsPXH0u9zvydlvTI50tMl3fy8TV0Q10NoHSZgf7s/E3uqQq2nWwQCmcL1Xzxhdms/RH1MBQKIrDWfoyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750839932; c=relaxed/simple;
	bh=76JayBgTFIMor183bdEqxVCpqwxcIxrDDM2N1ad5G38=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JZoHCv4VJzjFWiesuwb7tg+10MFvOGcLlBkNYNMPcVjdRtzcK/jJCk6tCyyKTmFMHML18Q1vprEbt0nTOsjejEcaOLxYMFCpBOeT4NDfZ1fAS4KlTcTFJBy3damD0ETacKJILvpLj0CGw1xvOsnkenvRa2qcfnjKbnq3FOTRbas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nv7GTPsW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nv7GTPsW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA782C4CEEA;
	Wed, 25 Jun 2025 08:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750839932;
	bh=76JayBgTFIMor183bdEqxVCpqwxcIxrDDM2N1ad5G38=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nv7GTPsWdGsg7qLtxhsPf5INIySeXcAPMqUiWVpuElGQ2f3iX+ayL+qmMdIG5Df0l
	 U8KQb3x0zG2t+LB5i6+mEXd0cdCqyVqmp+HJt/wUUN97omZg1lLwD74cKHOYLjam6h
	 UN1HoueYZlM89qk+sMbtgRm1KZuWxESm5FomFBDU=
Date: Wed, 25 Jun 2025 09:25:29 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?= <holger@applied-asynchrony.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 6.15 000/588] 6.15.4-rc2 review
Message-ID: <2025062511-tutor-judiciary-e3f9@gregkh>
References: <20250624121449.136416081@linuxfoundation.org>
 <e9249afe-f039-4180-d50d-b199c26dea26@applied-asynchrony.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e9249afe-f039-4180-d50d-b199c26dea26@applied-asynchrony.com>

On Wed, Jun 25, 2025 at 10:00:56AM +0200, Holger Hoffstätte wrote:
> (cc: Christian Brauner>
> 
> Since 6.15.4-rc1 I noticed that some KDE apps (kded6, kate (the text editor))
> started going into a tailspin with 100% per-process CPU.
> 
> The symptom is 100% reproducible: open a new file with kate, save empty file,
> make changes, save, watch CPU go 100%. perf top shows copy_to_user running wild.
> 
> First I tried to reproduce on 6.15.3 - no problem, everything works fine.
> 
> After checking the list of patches for 6.15.4 I reverted the anon_inode series
> (all 3 for the first attempt) and the problem is gone.
> 
> Will try to reduce further & can gladly try additional fixes, but for now
> I'd say these patches are not yet suitable for stable.

Does this same issue also happen for you on 6.16-rc3?

thanks,

greg k-h
