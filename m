Received: from mx-out.tlen.pl (mx-out.tlen.pl [193.222.135.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D3919149F
	for <patches@lists.linux.dev>; Wed, 26 Jun 2024 19:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.222.135.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719429604; cv=none; b=uQAwjFTWfAf8jvE9Q4zg8SEDZVSCVodsTUti5Nth2sM+9PZkvt0P91oDauS6DgYVgP/Ve567s7tP+NI+pBOMa0gaa5KGsML9Wx3C38BT0w8ah9ntM5bAVSy9TwXVQ/Fn7VyrjbeX8GZ+ALYPiiFXSRy+VNA5wwEURISVmvkJuBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719429604; c=relaxed/simple;
	bh=EaM1Dz9Wa5nQavU2xkJGT0mePNQMVEaSABMv7owQFqI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fGsKY1AaxVIAksPUkVuF7MmQZ4iriTm5CZbgY7snNh3qPWt40wEyDAMcvy4s0UJCaopkNc64Ki4Q0Uk97Is3vD663Y7yd3sQNDrgeS8e6WIWk1q8iJJkNzvj0DZJaifCEiqvJXBvsqn6G1ZG/YOQ18h0/JFSlMYMBv/QyBETsns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=o2.pl; spf=pass smtp.mailfrom=o2.pl; dkim=pass (1024-bit key) header.d=o2.pl header.i=@o2.pl header.b=Ba4CHt5Z; arc=none smtp.client-ip=193.222.135.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=o2.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=o2.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=o2.pl header.i=@o2.pl header.b="Ba4CHt5Z"
Received: (wp-smtpd smtp.tlen.pl 23978 invoked from network); 26 Jun 2024 21:13:20 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=o2.pl; s=1024a;
          t=1719429200; bh=VBlrCgswGgdojCmX7rLsHFjXXUfvRoXuCvlbvbwzY98=;
          h=Subject:To:Cc:From;
          b=Ba4CHt5Z+uNeLEuVlCMV1s9KXuWciRoavqKRRv8l6nPL+d0sqMQVDg3pGmxDb5nxj
           rjdMcl/tJ6jCcpnI6Z7BOB9rx7Vb9aI1sP3Z8ESC7iC3TMo3NVonFp66+nfkkR9Mnl
           ENq9GEx8i6l5eMkodRGKkr5L5qk0zdMNKII5kuoM=
Received: from aaer237.neoplus.adsl.tpnet.pl (HELO [192.168.1.22]) (mat.jonczyk@o2.pl@[83.4.121.237])
          (envelope-sender <mat.jonczyk@o2.pl>)
          by smtp.tlen.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <gregkh@linuxfoundation.org>; 26 Jun 2024 21:13:20 +0200
Message-ID: <ba2d19ca-a39c-4ed7-979e-7b33f4ffdb5a@o2.pl>
Date: Wed, 26 Jun 2024 21:13:18 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/131] 6.1.96-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240625085525.931079317@linuxfoundation.org>
Content-Language: en-GB
From: =?UTF-8?Q?Mateusz_Jo=C5=84czyk?= <mat.jonczyk@o2.pl>
Autocrypt: addr=mat.jonczyk@o2.pl; keydata=
 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
 TANkZ3QqXNX2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-WP-MailID: 3371b8397a28434c5dbed359df685d1a
X-WP-AV: skaner antywirusowy Poczty o2
X-WP-SPAM: NO 0000000 [MXOk]                               

W dniu 25.06.2024 o 11:32, Greg Kroah-Hartman pisze:
> This is the start of the stable review cycle for the 6.1.96 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 27 Jun 2024 08:54:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.96-rc1.gz
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

Issues found:
- NVMe drive failed shortly after resume from suspend:
    pcieport 0000:00:1d.0: AER: Corrected error message received from 0000:00:1d.0
    pcieport 0000:00:1d.0: PCIe Bus Error: severity=Corrected, type=Physical Layer, (Receiver ID)
    pcieport 0000:00:1d.0:   device [8086:9d18] error status/mask=00000001/00002000
    pcieport 0000:00:1d.0:    [ 0] RxErr                

    [... repeats around 20 times ]

    nvme nvme0: controller is down; will reset: CSTS=0xffffffff, PCI_STATUS=0x10
    nvme nvme0: Does your device have a faulty power saving mode enabled?
    nvme nvme0: Try "nvme_core.default_ps_max_latency_us=0 pcie_aspm=off" and report a bug
    nvme 0000:03:00.0: enabling device (0000 -> 0002)
    nvme nvme0: Removing after probe failure status: -19
    nvme0n1: detected capacity change from 1000215216 to 0
    [...]
    md/raid1:md1: Disk failure on nvme0n1p3, disabling device.
    md/raid1:md1: Operation continuing on 1 devices.

  After a cold reboot, the drive is visible again and functioning apparently
  normally. SMART data claims it is healthy. Previously this happened 3 weeks
  ago, on Linux 5.15.0-107-generic from Ubuntu, also shortly after a resume
  from suspend. As no recent patches in Linux stable appear to touch NVMe / PCIe,
  I'm giving a Tested-by: nonetheless.

Stack:
- amd64,
- ext4 on top of LVM on top of LUKS on top of mdraid on top of
  NVMe and SATA drives (the SATA drive in a write-mostly mode).

Tested (lightly):
- suspend to RAM,
- suspend to disk,
- virtual machines in QEMU (both i386 and amd64 guests),

- Bluetooth (Realtek RTL8822BE),
- GPU (Intel HD Graphics 620, tested with two Unigine benchmarks)
- WiFi (Realtek RTL8822BE),
- webcam.


Filesystems tested with fsstress:
    - ext4,
    - NFS client,
    - exFAT,
    - NTFS via FUSE (ntfs3g).

Greetings,

Mateusz

