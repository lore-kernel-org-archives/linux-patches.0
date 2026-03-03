Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4733090C5
	for <patches@lists.linux.dev>; Tue,  3 Mar 2026 07:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772523411; cv=none; b=U/XZNyONBAB025OspZJe42yN6K3ln1syiFVtCf1VPG8PoYFpgMLgwzGPo60u6Rf5QACqvZ+UWN+Vgffp0Eq2LLQ9+iERT0Hcg//5dRpLkOstbWHvYl4lVU9xBgpRYXWNvQxI1go3tpcf4H4tSvMiD7wvBWQhTO9MJY4aJBjDNLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772523411; c=relaxed/simple;
	bh=qyAbQa+uIbunJoMV8ba0kY78hp8PuC2dAGne+gE0A4I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HjTnPa6duvV5ObqeGb32fIlqMDkdzc4DIvJagmEjOn9OBPkLvOVOr+iAsc7WI9UPGMD7GM1Gu/JrirB0Rliiahr1BrH/ah/nWQdMpUk5C9Zzsn717io5Ifmq+xQHvYZMB3B9lvgjscLFgMoG9d9TI58BugMAPF01QNB5u/gT/Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=j3cy5fak; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="j3cy5fak"
Received: from francesco-nb (248.201.173.83.static.wline.lns.sme.cust.swisscom.ch [83.173.201.248])
	by mail11.truemail.it (Postfix) with ESMTPA id 77C452296C;
	Tue,  3 Mar 2026 08:36:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1772523408;
	bh=YUgKyECFmsP/uThhBYXet1w2Xr455oYYOxNKGdfJokg=; h=From:To:Subject;
	b=j3cy5fak40TK5qp8Lz57uyY6IEvWfflkvuKix5W5/NJ0Wwm1DSysF4RmRcDMVwe3q
	 5DXBoBlACsr4nEdQTaAh9iPDfZK+MAOBCvaOk3hdlkBamtCBBIdznQBJv4dlGoM7+A
	 7M+atytcPYyHNfhVCSMi0o5s5uIfkZzZIm4ojv/JmOnL6pjiEBpXvXn36LNHfjAiEQ
	 iu4BSPAYmTvZSFKKYjRFFWiFRh1X3J3Av+a5yPFpfe5D7cfiAl0D5Dd3yKcATBhHyC
	 +A+Z6LygiJ57ZuyUKUqDEjfeJ5rXfkR0pYaiNYKZbhiMz3B5p5kIeKGIpTzbn3MkoU
	 mL//Gnqfzujbw==
Date: Tue, 3 Mar 2026 08:36:46 +0100
From: Francesco Dolcini <francesco@dolcini.it>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	gregkh@linuxfoundation.org, patches@lists.linux.dev,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.6 000/684] 6.6.128-rc2 review
Message-ID: <20260303073646.GB9569@francesco-nb>
References: <20260302160934.2521545-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302160934.2521545-1-sashal@kernel.org>

On Mon, Mar 02, 2026 at 11:09:34AM -0500, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 6.6.128 release.
> There are 684 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Compiled and tested on

 - Verdin iMX8MM
 - Colibri iMX6
 - Apalis iMX6
 - Colibri iMX6ULL
 - Colibri iMX7

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

