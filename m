Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9456F620
	for <patches@lists.linux.dev>; Tue, 24 Jan 2023 00:13:39 +0000 (UTC)
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id E2CFB20DFDBA; Mon, 23 Jan 2023 16:13:38 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E2CFB20DFDBA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1674519218;
	bh=oX9Ybw+RwVXw/WIRa4dVtoIkYe3NY88XEM5Ayyelj/Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C36ADgE5rkOLi9graOXqH23amdIE2i9wZJSyNy7tphnTlGYHKJB7bUBauyinBTkUP
	 fqariAux9XfJhk1NO+HSCMP/ImVfbh74krYsFx6doxPOe7NegdVB+NJpI3L7e4WmqJ
	 hg0JRn3qK6pZiAgYfviVwsWlH5R6sX9675DpuxbY=
Date: Mon, 23 Jan 2023 16:13:38 -0800
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/117] 5.15.90-rc2 review
Message-ID: <20230124001338.GA27672@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20230123094918.977276664@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230123094918.977276664@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Mon, Jan 23, 2023 at 10:52:31AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.90 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Jan 2023 09:48:53 +0000.
> Anything received after that time might be too late.
 
No regressions found on WSL x86_64 or WSL arm64

Built, booted, and reviewed dmesg.

Thank you.

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com>
