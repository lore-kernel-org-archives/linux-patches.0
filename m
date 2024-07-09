Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3F4F1B86ED
	for <patches@lists.linux.dev>; Tue,  9 Jul 2024 19:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720555118; cv=none; b=bTYxa5tx5sZIHlSwz7hHmM37SfjHSBo/CCN9tcLNIAwzCW6dKGS3d+c9n+xNggbWQPtMWhLPFIQk6fjCqXRtx+qiFssK1EscQFsB5LEHgJHPqPzgnil/M2KIiXbWpWLdA+UwD5o3SCwHPdluQpTZwq7IHBSs/ca9zO4LIg0Zb+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720555118; c=relaxed/simple;
	bh=rHyXzjyH5K5pfelYo3/Kz9dGWJTOKDmJqpvDGNtn5a8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SrbnEoH5SL356COHS3iVqvUTm0TMszbv0eWPWTQY2j7CNu6A4VELY060vi/j4caE5z0XJAxv0iPixkDpatTYs1sw4dDW+clVRo8A3ZL5WBRaGH4StfQVZQyzWoiPm+00PdYMgy6VTv2aIkoX3PbzlyRTJJIQPt7U1YWmD8Kf2eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=UFOyz84B; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="UFOyz84B"
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id 4C2AD20B7165; Tue,  9 Jul 2024 12:58:36 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4C2AD20B7165
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1720555116;
	bh=YaYzdEHDjrY+tAYOL+KMOdyXShBdqlDZ0+gicROvX/s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UFOyz84BspjncxL8xf2N2qxPFdIJF9Rv/KnFPO7s6nA1Xcl3VtS+TMPdAa8OYXjLp
	 P9nO5ok+J1E2mwi5q7A6IMOzUPUvKC1fMLExX6lx/H3SPOLiM4QpZBcRgL3cKE+Z8e
	 w2ltpK0FYZOZ0rRankSmRw6CiIMW3YRlcbf+2kvs=
Date: Tue, 9 Jul 2024 12:58:36 -0700
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.6 000/139] 6.6.39-rc1 review
Message-ID: <20240709195836.GB28302@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20240709110658.146853929@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Tue, Jul 09, 2024 at 01:08:20PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.39 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Jul 2024 11:06:25 +0000.
> Anything received after that time might be too late.
> 
No regressions found on WSL (x86 and arm64).

Built, booted, and reviewed dmesg.

Thank you. :)

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
