Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52F991FAA
	for <patches@lists.linux.dev>; Tue, 19 Dec 2023 01:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="st0ab0jV"
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id D92A4208A7FD; Mon, 18 Dec 2023 17:06:04 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D92A4208A7FD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1702947964;
	bh=GMHHzGcS/Ytec/qxgR+iiBTSKYqEcKrlbhU2V2sgIO4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=st0ab0jVzCDXgShbY5NuVFsFglDcZr+ruGgPmnpYgBT+LA4s1+RFV/KQZFXmKfUx6
	 juLyazaygoZFe0EHtsettszjw+sbhxaKZCbbpWGZWxY33E9SoREQEHg8dk6KDwvhUp
	 JOwCMi+1URg0fr0SkV4HDNchWl4Nz4NDL7pF5AwA=
Date: Mon, 18 Dec 2023 17:06:04 -0800
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.1 000/106] 6.1.69-rc1 review
Message-ID: <20231219010604.GB15952@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20231218135055.005497074@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231218135055.005497074@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Mon, Dec 18, 2023 at 02:50:14PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.69 release.
> There are 106 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Dec 2023 13:50:31 +0000.
> Anything received after that time might be too late.

No regressions found on WSL (x86 and arm64).

Built, booted, and reviewed dmesg.

Thank you.

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
