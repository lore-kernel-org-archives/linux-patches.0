Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C859A159593
	for <patches@lists.linux.dev>; Mon, 15 Apr 2024 23:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713225210; cv=none; b=QklFhpwumiKivoVl/K0rRDu6LFXamX29eAWiEYGSK8pVUIk/pqWdhF6vRd05rt3or+2KfjUShVE2q+aWaekkH3UthPjOugE3ivN6bXhRf1y1C5SFTyYBw/IEnxKeFRwCepqUOUkcJel/dPn6S3dMN/+EpDe3FyIRODv19qQSzSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713225210; c=relaxed/simple;
	bh=IGEgV9i5prZjOOhn9NHJ88hW0jvaLTE+ORvIm3DROSw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FyjlNZtPRf/nbUfYSHbDWxWfor1ETd8KVarsdmnlX2K8owCcLSVDsfwHSNczTRChzIwUDgxL8TecB406gJ2liWIb+rEIjjaqHKhD4CqMLE+sKARCpbxOlJ1gRos91O/hgqNsjueih6JhITqT7LIl5prVqiCDfvZ9RggLRfG4yR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=XyMd7fqJ; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="XyMd7fqJ"
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id 6F71920FCF9D; Mon, 15 Apr 2024 16:53:28 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6F71920FCF9D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1713225208;
	bh=nTs39I7ll8z5rWDZRJGSaYOBXUW0TLZ4vfS/4WYtHC4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XyMd7fqJoI4Haq0x8JjWWvD9shwyLM97MjksJKmQfFjME08XNVuDpuUPJD2HH9wi/
	 8xtovzlmqsCaULjCjQdv9+vVEwGl8PcwmYmQaJfyYoHlU6C4VGKL4cUCVyvZMjLrmg
	 K38e3aA6mbZVcwSfL4G7X5WWeXxbtz1nitzzFj78=
Date: Mon, 15 Apr 2024 16:53:28 -0700
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/69] 6.1.87-rc1 review
Message-ID: <20240415235328.GB11121@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20240415141946.165870434@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240415141946.165870434@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Mon, Apr 15, 2024 at 04:20:31PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.87 release.
> There are 69 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 Apr 2024 14:19:30 +0000.
> Anything received after that time might be too late.
> 
No regressions found on WSL (x86 and arm64).

Built, booted, and reviewed dmesg.

Thank you. :)

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
