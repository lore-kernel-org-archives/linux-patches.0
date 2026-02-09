Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CD03815FC
	for <patches@lists.linux.dev>; Mon,  9 Feb 2026 16:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770654716; cv=none; b=VJnLKzBH6JlZw0tQTqVD9ddA6l+gW6iOAA1BOHtcxrMEcl7CJ7t8caCES/0XG4iRqETO2G8U///cEU4mMxvO+6LDuCSCLqNzMguwgfTJx4PqvKXiRDpColv1eoPrIcxeOLDyK0nJ90T59YIgsIctYuv+6Oba1xpdwn0Rtpk8a4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770654716; c=relaxed/simple;
	bh=xUw1eEx1+xzBRsGU2TmLI4OHykRj52hCOz0JWTaOYdo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ungqQGX1kM5Ugdmfsw5ZrgnRI/IX9fjZn40LXsq6G5hwV/Ytm07uayd0ZTlzKUKNcQUUzCle1GyCsCmAB0TBEeamICsf3dEi3rpVn0w+gghe+DREspOSAnXfyAGA9DlRlLkDBK8vqxJW2iwiOqHnJpdGp5jhICDWt/26PBOuwHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=x/9WHEk3; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="x/9WHEk3"
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id 07D081F96C;
	Mon,  9 Feb 2026 17:31:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1770654706;
	bh=25RzqTKTDZ4mPHZiEv92TbZFYjSW9N1HIPBfVTdHQkI=; h=From:To:Subject;
	b=x/9WHEk3aQ/Au0VEvyMmA+KkHB57I1eBVtSio9w4g1j1IEEpop7IF82GqADbn0o1v
	 5ntnZwHQdICB5Q9mL8AAJtOf5NP3Nsn5J3XJptyOSB+egHxSbQV7wt0Tqi7f08S1R0
	 H9NbQnbISVECEGrcp5B9KcvccMcowgrR6YH8Nkw2nv91SiNT1SjdApIFpRPW2t3E68
	 9BMaUPjR10ksILfyFuo3mUmaFFe0bBY7aBziQSt59j/at1crCer0504b/6Qb5lxaN/
	 fr7dOl8K0lQrliESU6xrlKeYVbFGicl4IbrVPAQLU8ytO2K2/58mUDKXJNWBCrwf4F
	 /LVfNzoWDEQgw==
Date: Mon, 9 Feb 2026 17:31:42 +0100
From: Francesco Dolcini <francesco@dolcini.it>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/113] 6.12.70-rc1 review
Message-ID: <20260209163142.GA203709@francesco-nb>
References: <20260209142310.204833231@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>

On Mon, Feb 09, 2026 at 03:22:29PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.70 release.
> There are 113 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Compiled and tested on

 - Verdin AM62
 - Verdin iMX8MP
 - Toradex SMARC iMX8MP

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

