Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E6F87C
	for <patches@lists.linux.dev>; Tue, 15 Nov 2022 02:02:54 +0000 (UTC)
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id 22EB420B717A; Mon, 14 Nov 2022 18:02:52 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 22EB420B717A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1668477772;
	bh=c7itml/ZwE8JspAMF/MspyYjk8h+imf3zJlwRQvsj9A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZPqbeq9JbLdjiw9d+BJs7SEF0puPVCGcy138eGZf9lMWNWT1nZ5gb4pofkVD8zM3c
	 H4Fih0KDp/Avth89zpVfbrarNNDY/WMX9zorwmF1MmWOxHhRMFm/A/3RnEMZ4QUZox
	 J48EvLhaOxfnMV8VllwVKSWZOaerl/uT0bLidWjo=
Date: Mon, 14 Nov 2022 18:02:52 -0800
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/131] 5.15.79-rc1 review
Message-ID: <20221115020252.GA3913@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20221114124448.729235104@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Mon, Nov 14, 2022 at 01:44:29PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.79 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Nov 2022 12:44:21 +0000.
> Anything received after that time might be too late.

No regressions found on WSL x86_64 or WSL arm64

Built, booted, and compared dmesg against 5.15.78.

Thank you.

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
