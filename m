Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A09021514E9
	for <patches@lists.linux.dev>; Fri, 12 Apr 2024 22:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712960699; cv=none; b=UHOfEufCVDwgUFIZ6nQtO1OhfEsUEEdN28osYRx87YOhqZTBAp5xbVFCOfMu0a/4JwCign+4TP+5bdv3BYpSZb49bRz/2uxbzjS6T11HdINU2TZ7UmLHbYdIob8BxS8YfS6Y0bKhwOxSAqw5COOFSKDBq63xnwyxueeLbDnZpF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712960699; c=relaxed/simple;
	bh=RaRz866MO9HPY25ORTgvE4TEfCCCiVDQGwdOhD0ml1Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JbrX/KgxMDUnyJLNNtEfr1Cmx3BmZ+U3p7QT+FgT5mfC1vxomTYoGXePbIiUPsYQVEWSp16c7EkfnBLHO/8B6hZNqBiNwaPrNb+RlzQrf7gXqJP0D4m/4dlGGTo82oL9Ym3lNjDslXWHSlK0jb7fr0v7D98noJBtxM60i/uUmHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=NLwAXFHb; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="NLwAXFHb"
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id 4B31120EBE36; Fri, 12 Apr 2024 15:24:58 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4B31120EBE36
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1712960698;
	bh=Huhqiw7FZZIzfdg63pwDZLV2MjsNvDYkBo/xdY4WTBU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NLwAXFHbT9GhtwBjXY37YDqsDIslg3NW+5uFho3qf8bJkew7U60zfRggl8t1yXZx+
	 h/86ik9mYW1BkV47YJ43oc7T8hnddZStV4MNcLAKAj6FL3K8MUfRdCyn24libvaht/
	 l0VB2ZOnTsvtUMakuYYrVh8BUQA7KFYOTETbTr+I=
Date: Fri, 12 Apr 2024 15:24:58 -0700
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.6 000/114] 6.6.27-rc1 review
Message-ID: <20240412222458.GC6610@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20240411095416.853744210@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Thu, Apr 11, 2024 at 11:55:27AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.27 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 13 Apr 2024 09:53:55 +0000.
> Anything received after that time might be too late.

No regressions found on WSL (x86 and arm64).

Built, booted, and reviewed dmesg.

Thank you. :)

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
