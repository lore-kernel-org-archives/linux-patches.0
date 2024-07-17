Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85F4F180A9E
	for <patches@lists.linux.dev>; Wed, 17 Jul 2024 18:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721239471; cv=none; b=d4AFY5PZ50Ux38aO9X0FugRJ3OujSU+oBkwloL7274kvHyDr2yjQecV98wd0AIOg/d/xx8aeFkwJjO88w6E/YWdlYtcRB1RE2WZv1zpsRHFtgFTS2U1QDy+xjisY0XhmsWvjafxEr4J4PgTzOX3JR9rGZBoVqtXo+VWiQLud0+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721239471; c=relaxed/simple;
	bh=J2mL7q0vY0f5WxwXSABB+/fLMrHwMl8UxpjoiNNq94Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lfMy4GaP3FTGKMVde/E+B+6NALn/EOvIeauRWBVLyFGzfJ1WjG7lzNF2qS4i3lrNtAuMQ7dEgXmVYkjHVU/5B8Dq3WaIOD0jTKM08MEoiHJB4e9n82BDxjkcWQFRxe4CZ2JADFARwph8xJRuXJKh2S+1cg0/LZYbbJh0B1tIl8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=LMd1dFpB; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="LMd1dFpB"
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id 31F1920B7165; Wed, 17 Jul 2024 11:04:30 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 31F1920B7165
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1721239470;
	bh=ig07ZMBGtAV2pZZn3LNiXBGVvQe7jS1nZy2AaBq/lnQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LMd1dFpBkr3vrURiM6nuKBteE/j4fBjKRR/Lv4dDqrOCFz7cA99zEhj7QeIpldSq5
	 oRi4eh8LbI3V1wNa8hWBrg4ha4vEcWLtuUjMtGQzRXhH7bIUmXsS3PJb0NKV3l/TZJ
	 HyB2m8UhFb5gPSBHezEXfUNgZKdhhwbPgFfyczKU=
Date: Wed, 17 Jul 2024 11:04:30 -0700
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.6 000/122] 6.6.41-rc2 review
Message-ID: <20240717180430.GB7194@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20240717063802.663310305@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240717063802.663310305@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Wed, Jul 17, 2024 at 08:39:51AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.41 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 19 Jul 2024 06:37:32 +0000.
> Anything received after that time might be too late.
> 
No regressions found on WSL (x86 and arm64).

Built, booted, and reviewed dmesg.

Thank you. :)

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
