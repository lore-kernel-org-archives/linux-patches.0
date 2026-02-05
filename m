Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0C226E719
	for <patches@lists.linux.dev>; Thu,  5 Feb 2026 08:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770280100; cv=none; b=iIgVQqHdBaongnM2h1AJtwtCF9qrIsZF2U0eOOHVBC6K4MIsLag3c2XxOkHUM1rj3KqzEYXrG/ClSICvxo4E29LzLbTrA096qvfAUeQGwB39I56lrz9dtYqxdCLDfB+EeYRFuVYBRMf0i+mqHxqkWOe/3u+R4wyMK4+bi2YaDbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770280100; c=relaxed/simple;
	bh=A3awokezcYpQ/7ZWlgrcbLyfe5jVoyACpijvArVvveg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l3F3crbxhke8SjqYqKIPl24rGUmtDptJV8VUbAH/8o4DDXXYKfolrR3eDe+8RK7eVophHYTpdCXMsPOCW9jaYBgM8JykxmDhhZeviEEbqv4gkfRlNiDnfA/x4GtGfzqwgA5RhiPWbSOswbY3DRzw0XFlYwWAl4zsmu5/RQK96gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=Gp+MXe+O; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="Gp+MXe+O"
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id 208861FA94;
	Thu,  5 Feb 2026 09:28:18 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1770280098;
	bh=6xeO6HF+8wKyfdj5hCH5AaPvV0doI5eKSqCsZeyclX8=; h=From:To:Subject;
	b=Gp+MXe+OeXr/iTBnZRm69fTJnmvdmgQ/LD1tNEfsML00HQEKfXEQnfspIl7usP0DL
	 DWt5NH6jR+IajAxN6ShVIU+RP2wcIBL1kX48Pc4reTht1vYQEBJ4ksSVowa8dcLIGY
	 XXd+94hSTgezNuZK016E/qc08KQGegdSG1cTNhaiJGwxJe3/6e1rYAgu67qWVeVqdd
	 nQQl2mY91cNVYAdzeZLATFww0S7TOEVWDiZ11Z/nTU1Xjskvp1PeRgbipJMuy6QOmX
	 PfbAIlZtrTKd/zvXXUW5l+4m8TL20vqGhT/Ss7IcEc9Uvp9zhosqJFqsO3RyLGwDLI
	 qKJbwOZCoOcNA==
Date: Thu, 5 Feb 2026 09:28:14 +0100
From: Francesco Dolcini <francesco@dolcini.it>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.6 00/72] 6.6.123-rc1 review
Message-ID: <20260205082814.GA16405@francesco-nb>
References: <20260204143845.603454952@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260204143845.603454952@linuxfoundation.org>

On Wed, Feb 04, 2026 at 03:40:03PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.123 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Compiled and tested on

 - Verdin iMX8MM
 - Colibri iMX6
 - Apalis iMX6
 - Colibri iMX6ULL
 - Colibri iMX7

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

