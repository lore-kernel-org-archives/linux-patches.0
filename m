Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6FD3B14C4;
	Fri,  3 Jul 2026 09:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783071582; cv=none; b=s98WIQg3zFI1/A5veXjolZZLbvCIkcF1q4AJULkAIa19oCKY8aN+GjMb1vtSV+TxOfZpNRBkqkTAHtndEhNsI5LUv0LrydIEav/OYtFE0unqlGaMgIxgEfBvbqgRZ0xMsUZGZVIoloIQg2WbKoM0GTpHBupZN7rHk2QsBz/h5hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783071582; c=relaxed/simple;
	bh=9G+Tw6c7rXrGZSMgB2I8p5VfbXfFXdGkw9pw9/E69o8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XX4F8ynw6oeJOIjaNzsNrtpdRKAWp9vFE9KndpeThn5GEFhV5YEhDa1EqtZAXxP0N7T+yJBcELwmG1eh8pt5OKQWHH7ykj4ObegSkaUtu890vTuqwrD0Uq7fpaEZ9D18hGWlz6RjvLMigTPBaTWL3WZLNmivt7Fi/m3C/YIzt3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NHnGnK36; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NHnGnK36"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D391F000E9;
	Fri,  3 Jul 2026 09:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783071581;
	bh=x6qdjgggnd6Pzq8RvJKOSa1BUsVjBeG/Tf5BuXME5fw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NHnGnK36rFRs8aBcl9roq7yDwblvMsvBDzZH2zZHmpO+KP6MrXgi+EiWSK9upSAAp
	 xXre9dA7x97xkhcNcJTu2YxV1pMlIR4RatCPSFfzUvxHgxM+6AcDs6J7uvkJ9Hc9Xq
	 XTUhXpIVaxMZd8h91duCM8IT9x+sx8nEY40ZGWBo=
Date: Fri, 3 Jul 2026 11:39:51 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Wentao Guan <guanwentao@uniontech.com>
Cc: achill@achill.org, akpm@linux-foundation.org, broonie@kernel.org,
	conor@kernel.org, f.fainelli@gmail.com, hargar@microsoft.com,
	jonathanh@nvidia.com, linux-kernel@vger.kernel.org,
	linux@roeck-us.net, lkft-triage@lists.linaro.org,
	patches@kernelci.org, patches@lists.linux.dev, pavel@nabladev.com,
	rwarsow@gmx.de, shuah@kernel.org, sr@sladewatkins.com,
	stable@vger.kernel.org, sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH 6.6 000/175] 6.6.144-rc1 review
Message-ID: <2026070341-asleep-hazing-15a6@gregkh>
References: <20260702155115.766838875@linuxfoundation.org>
 <20260703080126.567705-1-guanwentao@uniontech.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260703080126.567705-1-guanwentao@uniontech.com>

On Fri, Jul 03, 2026 at 04:01:27PM +0800, Wentao Guan wrote:
> Hi,
> 
> Build failed in loongarch arch, which resolve in link:
> https://lore.kernel.org/stable/20260703032401.857553-1-chenhuacai@loongson.cn/
> https://lore.kernel.org/stable/2026070318-monotone-mug-74d6@gregkh/
> 
> arch/loongarch/kernel/smp.c: In function ‘stop_this_cpu’:
> arch/loongarch/kernel/smp.c:616:9: error: implicit declaration of function ‘rcutree_report_cpu_dead’; did you mean ‘rcutree_prepare_cpu’? [-Werror=implicit-function-declaration]
>   616 |         rcutree_report_cpu_dead();
>       |         ^~~~~~~~~~~~~~~~~~~~~~~
>       |         rcutree_prepare_cpu
> 
> Build tested in our x86,arm64,riscv config successfully without error.

Offending commit already dropped.

thans,

greg k-h
