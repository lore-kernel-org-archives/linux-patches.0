Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A37536B067;
	Wed, 26 Aug 2026 18:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787767440; cv=none; b=pYR6ZUthTY3byIRowdviOH+r34NMQ9o+zlkVLp0YsnpFbRpXAVeYDEfzNFZapBuGiMtwxUJ72JZtblj+eq8xCIMn1p538CTUzPRXIctfFzX8XxligHDhyHOqAmgbxXtX+bFEOt1Ladot3XuBp2uo2qVkULUn2ZTCzpS5pZT9yQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787767440; c=relaxed/simple;
	bh=cC5gnYKtKChjZjGK1f58P/EcMaK1ymn5oR8DTMK08Bg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PYNz73Edt5FbPrEfJ7IvM9oKe/bMtpWMuzZqBl5NayeHCb+NoNh4Dl0RmGs4E2uNWnznOpfAZKQL9NFzyfJr8OWHHm5lYy6IWpl+0ZqePh0S5Gy3iwgycv9X0RBKESndntR8gyJryvkhaPmbjyRD3cGuGt0rYAqUOllLck5Ungg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KyQp/rbG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KyQp/rbG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B03DE1F00A3E;
	Wed, 26 Aug 2026 18:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787767428;
	bh=v/rmQCkw+8/y3EOBoiQX/SoNR9BJ2BW+H56CgAbq6Ds=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KyQp/rbGfoscGd9gZ+TZfLHNZJiRYDwQjBDFtWvua749FFXn5GIUcdfdKF5CXiuhU
	 c8o3Tvup+yIFWeYohSovOiPfDahU4lIVXY4fSnC6VBHrfEJrSZ/2TfjmfP8/woSzkZ
	 9XxJTBJxQA0fY06vh8W1aWTRViwnkTu+LPoJgN716MwgNZX6bjuA9bQHPU7WYkv0Hr
	 kkQ1bvXl/BJCZZfUWMYLA1dy6cXLvIybwcuO9jpeTT6eMqP4kNkY1Cgk/RoeHlGmN6
	 w6ZbPf7MMkAQc51bzNbxJXsgd8C0RmJKpwDGIBx973eRgNS119yCCkgmZH5fiq4J4/
	 c9UmZsaWAG+Yg==
Date: Thu, 27 Aug 2026 03:03:46 +0900
From: Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.2 00/82] 7.2.1-rc1 review
Message-ID: <20260826175904.GA3047625@rocinante>
References: <20260825132541.560541185@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260825132541.560541185@linuxfoundation.org>

Hello,

> This is the start of the stable review cycle for the 7.2.1 release.
> There are 82 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Aug 2026 13:25:02 +0000.
> Anything received after that time might be too late.

No issues running for over a day now.  Additionally, a number of Arch and
Omarchy Linux users also reported no issues - so the kernel has been tested
on a variety of hardware now, and has been working fine.

As such:

  Tested-by: Krzysztof Wilczyński <kwilczynski@kernel.org>

Thank you!

	Krzysztof
