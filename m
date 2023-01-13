Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F8A436C
	for <patches@lists.linux.dev>; Fri, 13 Jan 2023 01:36:00 +0000 (UTC)
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id 5E9F820DFE06; Thu, 12 Jan 2023 17:36:00 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5E9F820DFE06
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1673573760;
	bh=FkafJS8VsvJLT1ALvP9aAGd7nzhETQrBv0jT7rET+K0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JmqoviMH3EmMYkxuVUdAux/ZO1GkkEcWISx1nwhOAXwA5tl3eXQeLAww3G6jWusnZ
	 cD2jwvczSIr8Ur9NT66kIWsPV5g/8bO/ghSaKP8CohnIJayb5mjyJS/vM6nqe/53xI
	 X/UgljCl9NLF4VDitYQdX+tWQu82U9Yx66O9rueE=
Date: Thu, 12 Jan 2023 17:36:00 -0800
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/10] 5.15.88-rc1 review
Message-ID: <20230113013600.GA27117@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20230112135326.689857506@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112135326.689857506@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Thu, Jan 12, 2023 at 02:56:37PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.88 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 14 Jan 2023 13:53:18 +0000.
> Anything received after that time might be too late.

No regressions found on WSL x86_64 or WSL arm64

Built, booted, and reviewed dmesg.

Thank you.

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
