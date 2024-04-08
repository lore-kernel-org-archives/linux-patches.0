Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2A2B1465AD
	for <patches@lists.linux.dev>; Mon,  8 Apr 2024 20:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712606818; cv=none; b=Mrh2D4f9mMYn0GLQHS/lbHN51o/Pu4x4by2MN5mR57gk6v53S8+fSj2laF2hXNSpvX1y9VCkS6dKtdVn08o6lDF3fGc8tCX/gCmbpGZxQC1BS+VYFeXjY33Xc7T4iLpKzGHbW3/dXrmpLupWEqUMzvUxnFJjqoSBGAuo8lFK0PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712606818; c=relaxed/simple;
	bh=uP8p+u907i0fX21wYEXgRHvCgXzf0/e4KsgBCY2n9Rs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TKlVr2hPcfUkmkXXxlFQo1Iw4LtEDT7ABgK9GO1ADdlekS7nvA7nnizbSkmXsXbNx+LXtzo/HPdVC7nnkGAj/hHlw9VJ24XvSPFbTaj4t62Ph2w61gb6amJjM7gPw4FzKzx/sBCLKFk3SLcNLem/C9p6OaxJ33//xTx9oueUYPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=JcfcUPfs; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="JcfcUPfs"
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id 703AC20EA447; Mon,  8 Apr 2024 13:06:55 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 703AC20EA447
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1712606815;
	bh=xBr69HjT/zSd9c72AkS35t6i4F3bTZq50jzsNrhgI3I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JcfcUPfsQaJEylqoFo5J0kA6eRR+FWcY6sL1ws2uT/M2Bna+APb0eKCfZcIN1XMdH
	 VtFQfKrBUJJeZ5NqPXnBfrBBZHMJI3W/NzcAmY0xxIJ5e04/75U+/h/JacmnSkoDCc
	 hjnnAE5GgcbUm8wRzg2QdG5kqtLPCKzXQucq/CGw=
Date: Mon, 8 Apr 2024 13:06:55 -0700
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 5.15 000/690] 5.15.154-rc1 review
Message-ID: <20240408200655.GA4018@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20240408125359.506372836@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Mon, Apr 08, 2024 at 02:47:46PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.154 release.
> There are 690 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 10 Apr 2024 12:52:23 +0000.
> Anything received after that time might be too late.

No regressions found on WSL (x86 and arm64).

Built, booted, and reviewed dmesg.

Thank you. :)

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
