Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B3E3594A;
	Wed, 10 Dec 2025 12:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765370878; cv=none; b=JjK4WWpsrzyo5z1Km9Iydrb240jGiAvsrKqwldZLcypEAY7yCEw1YogCR2UQ5yB6vSB2TxoQ1udE8zdx+VevC6pCuKDEBvAxmZpbYszliRpTxAJDBTXmemXTaXZkn7iddjxKQC8QPDEagkeskkW8XnA3sjh7jaHVwdgaZvL94UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765370878; c=relaxed/simple;
	bh=7W4zBoxyRYepE0lW9X0YLsHsRRlW4WsOr+d3EcIku+8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D+JJ12g9s2tD1gbDYn9/Lu88Zf/C80Ddl2wRFCWOFnqc7CpaQTvzxrvtyesr0B59OnWg7PZNpR/kpQrjBC7duOkMdTBwsY6+sOsDvriSTGkzR9nryu9duW2r4VSnXnXGtr7v3/zXFCERj9QXVDXnG2Ssi5RAshih89LnbKDWxhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q96j/QYI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q96j/QYI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C99DBC19423;
	Wed, 10 Dec 2025 12:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765370878;
	bh=7W4zBoxyRYepE0lW9X0YLsHsRRlW4WsOr+d3EcIku+8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q96j/QYI6bk39iMck8YfBKms6dMCFJoKq62BAmec0PmU1xj3BCQZlf9mLBiGCmhM/
	 45EuTknZqb8QpWhr981HwrdOxEa7dOs6kyxeHE3Isa59VIIXTCoIxwlUtJYcHNhtrF
	 JhWcjE4OIJeoYgMQGBfJmK0pOsUWd2Iliw3CvdnE=
Date: Wed, 10 Dec 2025 21:47:55 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.17 00/60] 6.17.12-rc1 review
Message-ID: <2025121046-satchel-concise-1077@gregkh>
References: <20251210072947.850479903@linuxfoundation.org>
 <CAG=yYwm==BjqjJWtgc0+WzbiGTsKsHV3e4Lvk60fcartrrABDw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG=yYwm==BjqjJWtgc0+WzbiGTsKsHV3e4Lvk60fcartrrABDw@mail.gmail.com>

On Wed, Dec 10, 2025 at 04:22:21PM +0530, Jeffrin Thalakkottoor wrote:
>  compiled and booted 6.17.12-rc1+
> Version: AMD A4-4000 APU with Radeon(tm) HD Graphics
> 
> sudo dmesg -l errr  shows  error
> 
> j$sudo dmesg -l err
> [   39.915487] Error: Driver 'pcspkr' is already registered, aborting...
> $

Is ths new?  if so, can you bisect?
