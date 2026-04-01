Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5543F54BE
	for <patches@lists.linux.dev>; Wed,  1 Apr 2026 11:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775043624; cv=none; b=rIpI8arXwLQPmtAEa07vWF4ezNjFWj+cP/gmcouWeTa4SMb8lqj//2+Ezrkq3bBTlVidnpnlx9E1diQJFVufGLizqCgdPWqgtDK9S4AizLIYDePN4zs/xIjoZDsKqkZAdAhyJ9BopSVn7kkM2P0piHZNWppdBfakld2frJMIYjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775043624; c=relaxed/simple;
	bh=YY+GYp3xDDuatiO0Yc5J/Taw8NeIdUoRrTBZi5JuV1s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GIKQw2jkkphMMD6GvuufOlPET95lUF12XPkWGPw+BKexbe0s9VI2q13pJY+16YqTb1e3JxmKpC+tnyjoY3od2RbrWd3ajGKCCJ305gTe3zkpOzMxQP2WE3fWo2O9WFFx3UjSBUe1WkXIhHFZ7ud6R/dAo6dcqnfW7dUYHI190sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=ZjMuavT9; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="ZjMuavT9"
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id B924B1FF76;
	Wed,  1 Apr 2026 13:40:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1775043619;
	bh=U9GkX0W4sVizLKII2LRCQhzhrwJAGKA3ymcNInF43Ow=; h=From:To:Subject;
	b=ZjMuavT9A1Akx0tih7KprUWHnoCITFGFNUQOOIYztsrbiEGb4Penkg8eehsJTV/q7
	 Sc4RyiNHbur086l+6+tlq1wGaljNZSEYEOxrsfJoEodXjAA54W3t60GLao5LlAFqot
	 XHQsRSPg1CfdgwCipZDOCsBG5yeP5R+rY1nd2O9OtJmEFAFpu1DJk6CU2Z7FR7sl+P
	 GzbmiiBVzHI01yqb9ANsJctrc5hKLXIpxcx4tInmkFNrbeupWUVtwZ7uoR8Oe/xekC
	 kcir3+I/opXI51rrg3wnh1IGZMYfAWgPdGu6epNQUtX8OLOGCZQ5bGHbzhJEIJTOtO
	 hgUTBSQNwFshw==
Date: Wed, 1 Apr 2026 13:40:17 +0200
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
Subject: Re: [PATCH 6.12 000/244] 6.12.80-rc1 review
Message-ID: <20260401114017.GB23291@francesco-nb>
References: <20260331161741.651718120@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>

On Tue, Mar 31, 2026 at 06:19:10PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.80 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Compiled and tested on

 - Verdin AM62
 - Verdin iMX8MP
 - Toradex SMARC iMX8MP

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

