Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467512EBBB0
	for <patches@lists.linux.dev>; Thu, 22 Jan 2026 12:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769086700; cv=none; b=Dp6j1TAonOVfTNsYwpNk0cLEshI2R96yhe33UenoS5cZ2cpBNIl/YX61VCeMSmqbmoKqf7TXtr62l8nWv4lHNMqat24jwjPZ/W+rLOXjqMa896H74HxqapqSAb1BD6Zt8W70FORWqhvbfFq8voO7rnjSm9BtE35WV364IMKHXQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769086700; c=relaxed/simple;
	bh=aU+YlFTJpfAjbIPFXxwvw3vej51pgQtic97OXHxiW3Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZpQPdvH5SLDD1RtAphrMYBk7HC1JOCev4GMIleDTZ5SWmkcVi1IzAbdNWmNid5ihhn9VSnvdWVuJ7bjO8PomjMtC7MJ+vcN/NPcyWmdn4SbhskGjVehdsFlBE+SGtnmva2LlGXdq1VOPn0+dAqzowkwn67+Orn9+bn+A4dDskH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=zYis99hx; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="zYis99hx"
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id 2F3F01FAFC;
	Thu, 22 Jan 2026 13:58:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1769086688;
	bh=cLtm+fknhPP1OrspAUg5Zc31jIa7VV4SGAIlugNaLJw=; h=From:To:Subject;
	b=zYis99hxYZiHLp8U4ytMu3WgB7UA/bsMWtsI1hfrne7EwDqGSlTnSspiMXOzRtOe1
	 K1YTyM/WMp4UPgeXfqA5K7gCOrckmWDvf5dtkoGcdRt2XZ1FCkVGcHfAI7J+wDJJhY
	 FzbR/HxycQI7Aj8k5jU2f8FwsBN7IvQURAKjj63RzLKYo3WMxhwjCgTAfqZhlu+724
	 oucoaBbBJYxEKN/aly/E2P1sqtn5EPm0hRNWcQK0fBOFQvWK+9rm8FNTz5ft/VOC1o
	 WXTV3SHF7EIZ01h+4977gDbCcVnmHNtJhPxBldZtG5zSEg2DOsCkJKYl8VnsEOMVXl
	 f3VY0aiLAtEiQ==
Date: Thu, 22 Jan 2026 13:58:02 +0100
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
Subject: Re: [PATCH 6.12 000/139] 6.12.67-rc1 review
Message-ID: <20260122125802.GA54064@francesco-nb>
References: <20260121181411.452263583@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>

On Wed, Jan 21, 2026 at 07:14:08PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.67 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Compiled and tested on

 - Verdin AM62
 - Verdin iMX8MP

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

Francesco

