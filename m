Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7236B7B
	for <patches@lists.linux.dev>; Sat, 11 Mar 2023 14:16:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9734DC433D2;
	Sat, 11 Mar 2023 14:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678544160;
	bh=Byk8OJy7FAffNevRuOq1SrYcViAV1cY6st/7GhgpR/c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bYHl0ogBs1PmWBud8dlJgzDkHockoQW+Zf9OY2mkEfUkxdW2D6DNOjQJ6yeqcSG8p
	 N3g9Qgq5krodxEfY/Y3ep2pOhFvHEzbOAlifRBqaWboMeHHkPp2uITfGgeEtmfSnxo
	 /0B7UcJxGpWTb9RpSvme/rs9RBluw+547eSIgi1I=
Date: Sat, 11 Mar 2023 15:15:57 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.14 000/192] 4.14.308-rc2 review
Message-ID: <ZAyNHcm9ZqUj4Hon@kroah.com>
References: <20230311092102.206109890@linuxfoundation.org>
 <8c29b19c-e0b2-410d-b501-b6d8ddb77470@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c29b19c-e0b2-410d-b501-b6d8ddb77470@roeck-us.net>

On Sat, Mar 11, 2023 at 05:43:51AM -0800, Guenter Roeck wrote:
> On Sat, Mar 11, 2023 at 10:40:14AM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.14.308 release.
> > There are 192 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Mon, 13 Mar 2023 09:20:28 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 168 pass: 168 fail: 0
> Qemu test results:
> 	total: 430 pass: 430 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

Wonderful, thanks for the quick turn-around!


greg k-h
