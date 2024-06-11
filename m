Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EDDF16F90F
	for <patches@lists.linux.dev>; Tue, 11 Jun 2024 04:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718078506; cv=none; b=pfrn58LDo27Wxa2ZDCWQP67zNx4OhHp7dIzWrlbXEk0/OzIH/d62GZvNCv5XS++2IxCjSeNOAyMjoTniHnulVLnfmyMkltatq+I/BOKEzt19DfGMIivEI46v/AB8xCSzj20aeQCLqI+zovQ5gOHbkufTYgKREspxdPnOrxyltnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718078506; c=relaxed/simple;
	bh=oNNFw3Z2tEKo3yZRF6NWL1OTtd4Q0tAVSBkR5AlGnzw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wt32txFguK5VYiM3Mg56GuWYu3kJmx7BlkdxBXz6jLoPXb/ygTpdmwip6WZk6t3fhC/Tm4GdCuyyRttbOKQwpRIys0HMMmt2D0v2esWzTZ4sJARVUovxlh/0D8BvHVUigsyP7tFgiVGZqUfupnf460EQGM7XxrtnrQf51PTPcfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=HSQvIM3F; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="HSQvIM3F"
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id ABE1D20B9260; Mon, 10 Jun 2024 21:01:44 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com ABE1D20B9260
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1718078504;
	bh=fXizyP5Ok2ZdrVGQsJ+QH7s2Btg5mzEalvHU+sbwAHM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HSQvIM3FNnZV4fjWTmMrhZlGgN3RTlj1jdm4BQ14+oJpKivJPbA+GyQi8U4UYmxv4
	 +5B8eIXq38l/00EF4jzAycwMxvmB2Zgi7UkiYDDVLLTj/svXgqWshm19P4aQUi5p8E
	 AjJFSiOiBS6fe941zJAyAJm+nuWybKZB3kbZA3PA=
Date: Mon, 10 Jun 2024 21:01:44 -0700
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/470] 6.1.93-rc2 review
Message-ID: <20240611040144.GC27792@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20240609113816.092461948@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240609113816.092461948@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Sun, Jun 09, 2024 at 01:41:02PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.93 release.
> There are 470 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 11 Jun 2024 11:36:08 +0000.
> Anything received after that time might be too late.
> 
No regressions found on WSL (x86 and arm64).

Built, booted, and reviewed dmesg.

Thank you. :)

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
