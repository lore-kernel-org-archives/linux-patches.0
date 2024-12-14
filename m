Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C6B101DE;
	Sat, 14 Dec 2024 15:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734191288; cv=none; b=rGjNqf3f3YUpFND3aGa8X8fjUB2J+bTD6PHkdELW2uID6whLz21+frx/nzNz0dxa1uGHtOmwZ/ny4A9Q8eYfrl6dSbwA4PyCBGZvO9KuretHY+7gXFOryRToz7I64M/BhVF8Cg9zbO5fyCxM1YK9iuawQQ20HJefx0zWbf9TPnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734191288; c=relaxed/simple;
	bh=NsAijW7He8ZNqvND3ODoC7GqFTdM+ETcI4SDNwsPBEw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=MrW66QxCTFX0jHIaaCEAvSyN5Fj5Ynl9VPJfJqhcp/x4pu79WJco/e8rHWYLLI1RsKjLOjn2M1sF0fTe9cE/USJfEajr4bYqREZ4Wl1a2kVzEf73/PP2Y8VZzVfUxoo1M3ztqqy84edUu1vfr3Tlj4F5G3pU1u2r8naRRNV7Cto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=svenjoac@gmx.de header.b=IxTKL7F+; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=svenjoac@gmx.de header.b="IxTKL7F+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1734191249; x=1734796049; i=svenjoac@gmx.de;
	bh=jKTnUzFv43iUiomb93gDcq2GrOVrgbNReFvK6+xebZM=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:In-Reply-To:References:Date:
	 Message-ID:MIME-Version:Content-Type:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=IxTKL7F+M0zCLRHPBlu6gF0denQPhGz8XFnXw5kqdd9QRMglUxgoMJFj6Y0i+Rl8
	 5XMtnUP0f7K6mLNzrs9Zg4d271rUiKBnp9KIlRHBhVfCMDX4GRGgriu313Y0OPMXd
	 ncAeZNLxR+2dOfZSxPav2nMuzgHryNRjcS0aDgo2CcZUSQUFfSFNyhrd/JKCYuwSi
	 dRhaVUr947M3XuCHqjarBX+uubDvxmWMhc0w/90KnRXdmRV6I9v+GTeyERXmg34om
	 7o4+EEsrJDgsj6zZ+gDwvvvHmkVQQwjiiSkst5FyKVRGONHi6t5W4Fy5kCl+BNqBU
	 iwKOEUzPQKTxzhCcpw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from localhost.localdomain ([87.168.51.82]) by mail.gmx.net
 (mrgmx105 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1MtOKc-1tbGb11Y5O-00u5nI; Sat, 14 Dec 2024 16:47:29 +0100
Received: by localhost.localdomain (Postfix, from userid 1000)
	id EB3668011C; Sat, 14 Dec 2024 16:47:27 +0100 (CET)
From: Sven Joachim <svenjoac@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org,  patches@lists.linux.dev,
  linux-kernel@vger.kernel.org,  torvalds@linux-foundation.org,
  akpm@linux-foundation.org,  linux@roeck-us.net,  shuah@kernel.org,
  patches@kernelci.org,  lkft-triage@lists.linaro.org,  pavel@denx.de,
  jonathanh@nvidia.com,  f.fainelli@gmail.com,  sudipm.mukherjee@gmail.com,
  srw@sladewatkins.net,  rwarsow@gmx.de,  conor@kernel.org,
  hargar@microsoft.com,  broonie@kernel.org
Subject: Re: [PATCH 6.1 000/772] 6.1.120-rc2 review
In-Reply-To: <20241213150009.122200534@linuxfoundation.org> (Greg
	Kroah-Hartman's message of "Fri, 13 Dec 2024 16:04:17 +0100")
References: <20241213150009.122200534@linuxfoundation.org>
Date: Sat, 14 Dec 2024 16:47:27 +0100
Message-ID: <87ttb66zcg.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Provags-ID: V03:K1:+1vAiYYmZmxKWRmt2iiM7EH3Ss70jh3yBCsEf7JM1BT2DIKP1nF
 2DC8A7P73H3dOrMpT0GbLDBWT6hR4CpS0gwH7c9ziqMI6czpwvAg/oIaMPZ/tm5RwP71XMv
 mibHIcSSMg1ZX7pr3nZHK0zLwcE4Mh45xo88hBCBdy9Dpi2SSyiv6PakN5L/ITbkjRuWBNH
 CIznKc4mIpShLt0f9TRSg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:NnimcqHXfTs=;FnJIgdsCaOOfPoYHiH3BWSswJKh
 Ec7j6WB8ldB+cMq4jKYDi+nnxC8su6Lsu+fVb5x/UV7+V6tKRClYgslTg7IxJ2CRQNdZoS3Lt
 v5kyo/Ybdtxx35enhFegGzA68Iyz4Y8stfza+agwpqZ2m4puntQmLXM9pdYqH0QV8yksIwvgO
 Nx45EX8kCwXzT+X4XhKfn7/j8PxqyMrbvIU0ynqSdSNkaw0QyItyVvGWEQgenbXpReDLa6hZU
 mncmh/YcQS0lj1jqOc/fGqRIptTQQDUSjCnd5x3m1FwdoQMOHn9+DU0iv85GsOjvxhE9rkitW
 J3O5IlfAXPR81m5HU9/WwPWJcvZdpUtgjP6NiJYzzcVrLyD4nCmFa3v2nAFeaFWqoxFWBt7WI
 Hht78fj4+hKGUaFsLJ96B8MZirGMKRYpahlcDSSyJ/wBNTURQaNISHYV4awfHiEASHS4Xmdbl
 F+UADm2cVdgbWEndfAjkng+mOpIqn6dVr6YYLuiIIWomIuDy6STV91+ATod3h7/KeKPvQx+xG
 Al6jPYlm0+S65EPPWmCHPd6nCJKl2QhGK1/tyf+Vy5yGcqfThkWOVEx8vEQWZZwZFf9nP3bCs
 0TCnAciDTTey7bf2csgAyMQ8yPROhLd3mdhqPxShg6gQB/v40clr9pQEWTUSao7Y8TrUpRh8b
 ZABWVAz5adv75Nu5TYm16vdPjo/zdQy6rAB8WFqDgOLKpXX9UOUxh/rY7RF/+99+ZpKGNVIW/
 tWUmZxCVUWy6xAD8+THkDVjOzn2ynPWpwTF8CRgqytmH8mc5EW/otr+MHtGamIj3Ed9TFu+vc
 AKI81AV3HOLmUTKJGMCRaeY4fFOf5sNH7u6phr6OSPvTorK6yQclCuWtyjGNBt35I5jISm9Bj
 HPvv1qqTM0SfWKbPUjX91Vb+cBsvOzqxkASI3i9eErACpWqJNMgdwTvICT72rHrEleRMIj67e
 1/pirDTOUOGn0qaVOCoC+hiLIvnX7L+6YDMmMvVi9nQStO+NjTmi/HALkJtZyuTa4uPKESXVl
 7mduoh7dN9n/EWx/EzBWsMGhoXaR3IO2wYrkCrYRIGit55o22NzBYO3PMxS5y+aWnvUtMv3dB
 olYmuOw16H4VXQ8fGnbshjhSXsLkQa

On 2024-12-13 16:04 +0100, Greg Kroah-Hartman wrote:

> This is the start of the stable review cycle for the 6.1.120 release.
> There are 772 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 15 Dec 2024 14:57:53 +0000.
> Anything received after that time might be too late.

Works fine for me on x86_64.

Tested-by: Sven Joachim <svenjoac@gmx.de>

Cheers,
       Sven
