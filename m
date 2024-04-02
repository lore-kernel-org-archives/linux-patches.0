Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F375B14A90
	for <patches@lists.linux.dev>; Tue,  2 Apr 2024 00:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712016913; cv=none; b=j1j7OAIGjHckWeY1lJJ9JR04UIaagI9rtmu3JOFCqGFVo5f+WlM4t412E34Ix7V/4DbxzbafvVHPMVs8kCGABDJ1OXXzP87p8oSSYyIB5rTX12jP8+xa4jgug1olE64gPv2UbDE3oE76PZ2TOBNQQFwFyaF7MsOrAtwg3ktV3mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712016913; c=relaxed/simple;
	bh=L/cepksWsJAulAIq7KxYXzP5InKjCyjd8aWigQpsGvI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LSeACxbRJEWLLgnwr/ql4ehT1GSa5VHPaFlySUO7AJJ054ROoWSYwlJuKFFZQRyr4uUMxN5F5kUq5ZKF4LTjKpDj9UnYo7H1r4uLemnDCALt+voVOPOK4Jwi0RE5A6n6T1JCvqAMaEO6QeTVeOwIVppLSDIgxBaRbxaUTsTBM6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=tNmpcLN7; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="tNmpcLN7"
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id 98C7B20E6F67; Mon,  1 Apr 2024 17:15:10 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 98C7B20E6F67
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1712016910;
	bh=IC8o4VTPdCWxCV8lfNPO6z2ktngkRkqdOkjU6TGlf/4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tNmpcLN7fU4YNiIJUEYi3EZjJDqn1jWNNmLyC5CJNxfV7xQh9vG7R4ESawpGPA/b0
	 qfKL/VRnEIFOO0vza65R7L9vnMY2OhCp0Es8uwTyElAIRsavf2VXFD3sCdpfaSydMC
	 /itSNS08PL7SPU16QdJDSCeQg4SgzUMiPW1KzYxw=
Date: Mon, 1 Apr 2024 17:15:10 -0700
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.6 000/396] 6.6.24-rc1 review
Message-ID: <20240402001510.GB5026@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20240401152547.867452742@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Mon, Apr 01, 2024 at 05:40:49PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.24 release.
> There are 396 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Apr 2024 15:24:46 +0000.
> Anything received after that time might be too late.
> 
No regressions found on WSL (x86 and arm64).

Built, booted, and reviewed dmesg.

Thank you. :)

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
