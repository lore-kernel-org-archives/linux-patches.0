Received: from mx-out.tlen.pl (mx-out.tlen.pl [193.222.135.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D4A14D70E
	for <patches@lists.linux.dev>; Mon, 10 Jun 2024 19:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.222.135.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718047352; cv=none; b=ucH/TeVar674Zbj5F0+o33duyc/cWrxmCYSwTdUTZGe90LFgxXtnc8SftGqeOXlAJN4EMP8ZB4O9QxmOe9+whS5kJeuzzCGOM9NunOnZC8WIVTitenwjpuPzg6EjrXzQQJcevhES7dkSBJ+2o/rbpSTOhV0zsjdcJFX5hQCgLt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718047352; c=relaxed/simple;
	bh=Iawzg28T3aFCFKqGptTGfReENBNWkMpmGd777B2b2hA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z3CGMibttmmuv5tzz5CnZ9aKXSb0qou01hiDqfGdqAsTf7skM9E7SxEq7hIeI1h7xUx8C58YDkvf2YyR5uX4+4TTp6qkbAg7K6FiVICuqZWTIxIEJCvg/SWs2Il8G/+JWd48zzx7KKPporpN+pYi+fgP0gaHnwNgGI1JaECTJd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=o2.pl; spf=pass smtp.mailfrom=o2.pl; dkim=pass (1024-bit key) header.d=o2.pl header.i=@o2.pl header.b=fkCgvDyR; arc=none smtp.client-ip=193.222.135.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=o2.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=o2.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=o2.pl header.i=@o2.pl header.b="fkCgvDyR"
Received: (wp-smtpd smtp.tlen.pl 8804 invoked from network); 10 Jun 2024 21:15:47 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=o2.pl; s=1024a;
          t=1718046947; bh=MeySumbwzlBo0kldPkNbI3BFVqV8D1zfPKw7TgMj87k=;
          h=Subject:To:Cc:From;
          b=fkCgvDyRKT6m1QfYwnbUKp2Lnb7Yy70nj/8tC3be6vBJNJ3+hWZHdJ+wz3Nv5DBov
           ERgZvTzlg7ifkUsGdFbpPOwaIHkEOX6HPWLC783Hnf9ZaDd99Y7z2xCgJRLSIrr7PO
           MSOXeJlI//si/3aCRi0S9e0glYkH5zLxI/y3wXBQ=
Received: from aafb246.neoplus.adsl.tpnet.pl (HELO [192.168.1.22]) (mat.jonczyk@o2.pl@[83.4.131.246])
          (envelope-sender <mat.jonczyk@o2.pl>)
          by smtp.tlen.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <gregkh@linuxfoundation.org>; 10 Jun 2024 21:15:47 +0200
Message-ID: <3e0b8e07-2481-4c79-9ba8-9c6165b456c1@o2.pl>
Date: Mon, 10 Jun 2024 21:15:42 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/470] 6.1.93-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240609113816.092461948@linuxfoundation.org>
Content-Language: en-GB
From: =?UTF-8?Q?Mateusz_Jo=C5=84czyk?= <mat.jonczyk@o2.pl>
Autocrypt: addr=mat.jonczyk@o2.pl; keydata=
 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
 TANkZ3QqXNX2
In-Reply-To: <20240609113816.092461948@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-WP-MailID: ac896e9918a2a86bcaaed34bb2b44892
X-WP-AV: skaner antywirusowy Poczty o2
X-WP-SPAM: NO 0000000 [gXM0]                               

W dniu 9.06.2024 o 13:41, Greg Kroah-Hartman pisze:
> This is the start of the stable review cycle for the 6.1.93 release.
> There are 470 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 11 Jun 2024 11:36:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.93-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Hello,

Tested-by: Mateusz Jończyk <mat.jonczyk@o2.pl>

Tested on a HP 17-by0001nw laptop with an Intel Kaby Lake CPU and Ubuntu 20.04.

Stack:
- amd64,
- ext4 on top of LVM on top of LUKS on top of mdraid on top of
  NVMe and SATA drives (the SATA drive in a write-mostly mode).

Tested (lightly):
- suspend to RAM,
- suspend to disk,
- virtual machine in QEMU
- WiFi (Realtek RTL8822BE),

No dmesg regressions (on warning+ levels). I have previously tested 6.1.93-rc1
more thoroughly.

Greetings,

Mateusz

