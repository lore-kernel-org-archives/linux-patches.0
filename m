Received: from 1wt.eu (ded1.1wt.eu [163.172.96.212])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B11C85270
	for <patches@lists.linux.dev>; Sat, 14 Dec 2024 07:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=163.172.96.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734160347; cv=none; b=C+dGN0o9RGNes3+pZK8pBZ3M0OStdKKT0Ye56eN1qNvPpumw8MjJ3I/TfvLkkm/r6biRpS7apT3U0LWcwrISsYqpSTWbG9bzBx7UJ1Ns/vZde3ehnEEAkCw/wmjBkMNwcPtbuJxHVPulOT5HhPxNb0rQ//wH+BFrjkOjYVtNMUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734160347; c=relaxed/simple;
	bh=DW85s3K/2RaRQoRpw/TsqtSuThFC5ie2FU5BB6r6MnY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LKlWzcCene8EEZK+eqG07Nv5Hc65jEfbXwX9F5v49TyOlReKkMod0DHYNy8F7lVGFYynvcZ2xkMpl2ZAAv1YO1/fWuCRX+Csw5D59JuhsrmPZzm7MMx6zYYx2jcuifBbrrX8K2f64wKQaepdcUqL0im93ULbE0t6rptXSTht8m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=1wt.eu; spf=pass smtp.mailfrom=1wt.eu; arc=none smtp.client-ip=163.172.96.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=1wt.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=1wt.eu
Received: (from willy@localhost)
	by pcw.home.local (8.15.2/8.15.2/Submit) id 4BE6urk6029602;
	Sat, 14 Dec 2024 07:56:53 +0100
Date: Sat, 14 Dec 2024 07:56:53 +0100
From: Willy Tarreau <w@1wt.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
        hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.12 000/467] 6.12.5-rc2 review
Message-ID: <20241214065653.GA29240@1wt.eu>
References: <20241213145925.077514874@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241213145925.077514874@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, Dec 13, 2024 at 04:03:57PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.5 release.
> There are 467 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Dec 2024 14:57:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.5-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.

Booted on Radxa E52C (arm64) using pcie, rtl8125b(r8169), eMMC(dwmmc),
usb(xhci-hcd) + cdc_acm, i2c rtc. Looks good.

Tested-by: Willy Tarreau <w@1wt.eu>

Willy
