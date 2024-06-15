Received: from mx-out.tlen.pl (mx-out.tlen.pl [193.222.135.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A664594D
	for <patches@lists.linux.dev>; Sat, 15 Jun 2024 13:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.222.135.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718457576; cv=none; b=CnmI9MYWLMSjBbnzYQ7DRl96gVAVKicQLY+ZOYPYsedI8deVj+wfipkukJpIhqQAQ6jocBGssRwUK+se/RXKVzN6Rq/JEuRyyxKJ/62sCz+GitXRDDdXjOco+OVwYlOigVddOq+sAVUkT18h6c5ls6yMv/uD4zLk9/z/THOHeqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718457576; c=relaxed/simple;
	bh=GNy+ogj7RswXyM7tInlMBCMymmApHC3g1pXAWLfUs1g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jLXhvElUzw1fDY+3MdvJbPf7sxZ1eKDobWt35IYehPT5XUH/A9TmeUObPRapC6zY6uKx7iKJ3C/6oswYm50h/KQcgSkcw9470qARjIYkIyHV91AS4+6VVL++iofR/ORT6CIhIVKhrmdmoilNpNir6nkWC6s03jksJUiA5DloM/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=o2.pl; spf=pass smtp.mailfrom=o2.pl; dkim=pass (1024-bit key) header.d=o2.pl header.i=@o2.pl header.b=OsquMRsg; arc=none smtp.client-ip=193.222.135.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=o2.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=o2.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=o2.pl header.i=@o2.pl header.b="OsquMRsg"
Received: (wp-smtpd smtp.tlen.pl 30838 invoked from network); 15 Jun 2024 15:19:23 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=o2.pl; s=1024a;
          t=1718457563; bh=IMdUjdX+AEOslkyKAAahjrStX15n+hN+3dhxuasNPdE=;
          h=Subject:To:Cc:From;
          b=OsquMRsgWZLStE0hhoSYQ6kWz8wUPe0UFRbX+5tDkAa4Fr3wj6rPvhgCX1+o4xHBH
           5vxhyvEnO8NhPV2sAvxYkpIdv0PPWisc7smpJbC5cjpkbX5g32Z6EgDHfyf9aSxm8a
           VFu5XWAGBdLoHLI8wxGtmaaRu9u40IQiUTKS19mM=
Received: from aaen80.neoplus.adsl.tpnet.pl (HELO [192.168.1.22]) (mat.jonczyk@o2.pl@[83.4.117.80])
          (envelope-sender <mat.jonczyk@o2.pl>)
          by smtp.tlen.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <gregkh@linuxfoundation.org>; 15 Jun 2024 15:19:23 +0200
Message-ID: <b4f871ef-0f4b-4a7b-beed-05420f96b234@o2.pl>
Date: Sat, 15 Jun 2024 15:19:18 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/85] 6.1.94-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240613113214.134806994@linuxfoundation.org>
Content-Language: en-GB
From: =?UTF-8?Q?Mateusz_Jo=C5=84czyk?= <mat.jonczyk@o2.pl>
Autocrypt: addr=mat.jonczyk@o2.pl; keydata=
 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
 TANkZ3QqXNX2
In-Reply-To: <20240613113214.134806994@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-WP-MailID: 6f2b6be8b0528aa4d5b9b2640e08873a
X-WP-AV: skaner antywirusowy Poczty o2
X-WP-SPAM: NO 0000000 [4dNE]                               

W dniu 13.06.2024 o 13:34, Greg Kroah-Hartman pisze:
> This is the start of the stable review cycle for the 6.1.94 release.
> There are 85 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.94-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
Hello,

Tested-by: Mateusz Jończyk <mat.jonczyk@o2.pl>

Issues found:
- the WiFi signal sometimes is displayed as ~100%, even though the AP is far
  away and the signal is weak. According to my notes, something like this I
  have seen on some older stable kernels (6.1.68-rc1) and on Linus' kernels
  since 6.7-rc3. I have never gotten around to reporting this seriously, just noticed
  this again now that I use a more distant AP.

    For example:

    $ iw wlp2s0 station dump
    Station 50:c7:bf:2c:a9:31 (on wlp2s0)
        [...]
        beacon loss:    0
        beacon rx:    4418
        rx drop misc:    7
        signal:      0 [0, 0] dBm
        signal avg:    -2 [-3, -2] dBm
        beacon signal avg:    -68 dBm
        [...]

    On my laptop I use a Realtek RTL8822BE, but it happened also on
    a desktop computer with a PCI-Express Intel WiFi card:
        Intel Corporation Wireless 7265 [8086:095a] (rev 61)

    Logs from this one-liner:

        while true; do date; iw wlp2s0 station dump; sleep 5; done

    can be found at the bottom of this mail.

Tested on a HP 17-by0001nw laptop with an Intel Kaby Lake CPU and Ubuntu 20.04.

Stack:
- amd64,
- ext4 on top of LVM on top of LUKS on top of mdraid on top of
  NVMe and SATA drives (the SATA drive in a write-mostly mode).

Tested (lightly):
- suspend to RAM,
- suspend to disk,
- virtual machines in QEMU (both i386 and amd64 guests),

- GPU (Intel HD Graphics 620, tested with an Unigine benchmark)
- WiFi (Realtek RTL8822BE),
- PCI soundcard (Intel HD Audio),
- webcam.

Greetings,

Mateusz


sob, 15 cze 2024, 14:56:46 CEST
Station 50:c7:bf:2c:a9:31 (on wlp2s0)
    inactive time:    593 ms
    rx bytes:    1691981
    rx packets:    10069
    tx bytes:    131929
    tx packets:    2000
    tx retries:    0
    tx failed:    0
    beacon loss:    0
    beacon rx:    4338
    rx drop misc:    7
    signal:      -68 [-73, -68] dBm
    signal avg:    -67 [-73, -67] dBm
    beacon signal avg:    -68 dBm
    tx bitrate:    175.5 MBit/s VHT-MCS 4 80MHz VHT-NSS 1
    tx duration:    0 us
    rx bitrate:    263.3 MBit/s VHT-MCS 6 80MHz VHT-NSS 1
    rx duration:    0 us
    authorized:    yes
    authenticated:    yes
    associated:    yes
    preamble:    long
    WMM/WME:    yes
    MFP:        no
    TDLS peer:    no
    DTIM period:    2
    beacon interval:100
    short slot time:yes
    connected time:    769 seconds
    associated at [boottime]:    3327.468s
    associated at:    1718455437511 ms
    current time:    1718456206519 ms
sob, 15 cze 2024, 14:56:51 CEST
Station 50:c7:bf:2c:a9:31 (on wlp2s0)
    inactive time:    5601 ms
    rx bytes:    1699466
    rx packets:    10126
    tx bytes:    131929
    tx packets:    2000
    tx retries:    0
    tx failed:    0
    beacon loss:    0
    beacon rx:    4364
    rx drop misc:    7
    signal:      -69 [-74, -69] dBm
    signal avg:    -68 [-73, -68] dBm
    beacon signal avg:    -68 dBm
    tx bitrate:    175.5 MBit/s VHT-MCS 4 80MHz VHT-NSS 1
    tx duration:    0 us
    rx bitrate:    263.3 MBit/s VHT-MCS 6 80MHz VHT-NSS 1
    rx duration:    0 us
    authorized:    yes
    authenticated:    yes
    associated:    yes
    preamble:    long
    WMM/WME:    yes
    MFP:        no
    TDLS peer:    no
    DTIM period:    2
    beacon interval:100
    short slot time:yes
    connected time:    774 seconds
    associated at [boottime]:    3327.468s
    associated at:    1718455437511 ms
    current time:    1718456211526 ms
sob, 15 cze 2024, 14:56:56 CEST
Station 50:c7:bf:2c:a9:31 (on wlp2s0)
    inactive time:    1392 ms
    rx bytes:    1707004
    rx packets:    10184
    tx bytes:    132047
    tx packets:    2001
    tx retries:    0
    tx failed:    0
    beacon loss:    0
    beacon rx:    4391
    rx drop misc:    7
    signal:      -69 [-73, -69] dBm
    signal avg:    -68 [-73, -68] dBm
    beacon signal avg:    -68 dBm
    tx bitrate:    175.5 MBit/s VHT-MCS 4 80MHz VHT-NSS 1
    tx duration:    0 us
    rx bitrate:    263.3 MBit/s VHT-MCS 6 80MHz VHT-NSS 1
    rx duration:    0 us
    authorized:    yes
    authenticated:    yes
    associated:    yes
    preamble:    long
    WMM/WME:    yes
    MFP:        no
    TDLS peer:    no
    DTIM period:    2
    beacon interval:100
    short slot time:yes
    connected time:    779 seconds
    associated at [boottime]:    3327.468s
    associated at:    1718455437511 ms
    current time:    1718456216538 ms
sob, 15 cze 2024, 14:57:01 CEST
Station 50:c7:bf:2c:a9:31 (on wlp2s0)
    inactive time:    48 ms
    rx bytes:    1827402
    rx packets:    10287
    tx bytes:    137924
    tx packets:    2047
    tx retries:    0
    tx failed:    0
    beacon loss:    0
    beacon rx:    4418
    rx drop misc:    7
    signal:      0 [0, 0] dBm
    signal avg:    -2 [-3, -2] dBm
    beacon signal avg:    -68 dBm
    tx bitrate:    175.5 MBit/s VHT-MCS 4 80MHz VHT-NSS 1
    tx duration:    0 us
    rx bitrate:    52.0 MBit/s VHT-MCS 5 VHT-NSS 1
    rx duration:    0 us
    authorized:    yes
    authenticated:    yes
    associated:    yes
    preamble:    long
    WMM/WME:    yes
    MFP:        no
    TDLS peer:    no
    DTIM period:    2
    beacon interval:100
    short slot time:yes
    connected time:    784 seconds
    associated at [boottime]:    3327.468s
    associated at:    1718455437511 ms
    current time:    1718456221547 ms
sob, 15 cze 2024, 14:57:06 CEST
Station 50:c7:bf:2c:a9:31 (on wlp2s0)
    inactive time:    4857 ms
    rx bytes:    1848410
    rx packets:    10343
    tx bytes:    138300
    tx packets:    2051
    tx retries:    0
    tx failed:    0
    beacon loss:    0
    beacon rx:    4443
    rx drop misc:    7
    signal:      -69 [-72, -69] dBm
    signal avg:    -66 [-70, -66] dBm
    beacon signal avg:    -68 dBm
    tx bitrate:    175.5 MBit/s VHT-MCS 4 80MHz VHT-NSS 1
    tx duration:    0 us
    rx bitrate:    52.0 MBit/s VHT-MCS 5 VHT-NSS 1
    rx duration:    0 us
    authorized:    yes
    authenticated:    yes
    associated:    yes
    preamble:    long
    WMM/WME:    yes
    MFP:        no
    TDLS peer:    no
    DTIM period:    2
    beacon interval:100
    short slot time:yes
    connected time:    789 seconds
    associated at [boottime]:    3327.468s
    associated at:    1718455437511 ms
    current time:    1718456226559 ms
sob, 15 cze 2024, 14:57:11 CEST
Station 50:c7:bf:2c:a9:31 (on wlp2s0)
    inactive time:    1467 ms
    rx bytes:    1869290
    rx packets:    10413
    tx bytes:    140713
    tx packets:    2061
    tx retries:    0
    tx failed:    0
    beacon loss:    0
    beacon rx:    4470
    rx drop misc:    7
    signal:      -69 [-74, -69] dBm
    signal avg:    -63 [-68, -63] dBm
    beacon signal avg:    -69 dBm
    tx bitrate:    175.5 MBit/s VHT-MCS 4 80MHz VHT-NSS 1
    tx duration:    0 us
    rx bitrate:    52.0 MBit/s VHT-MCS 5 VHT-NSS 1
    rx duration:    0 us
    authorized:    yes
    authenticated:    yes
    associated:    yes
    preamble:    long
    WMM/WME:    yes
    MFP:        no
    TDLS peer:    no
    DTIM period:    2
    beacon interval:100
    short slot time:yes
    connected time:    794 seconds
    associated at [boottime]:    3327.468s
    associated at:    1718455437511 ms
    current time:    1718456231570 ms
sob, 15 cze 2024, 14:57:16 CEST
Station 50:c7:bf:2c:a9:31 (on wlp2s0)
    inactive time:    6481 ms
    rx bytes:    1876386
    rx packets:    10468
    tx bytes:    140713
    tx packets:    2061
    tx retries:    0
    tx failed:    0
    beacon loss:    0
    beacon rx:    4495
    rx drop misc:    7
    signal:      -68 [-74, -68] dBm
    signal avg:    -69 [-73, -69] dBm
    beacon signal avg:    -68 dBm
    tx bitrate:    175.5 MBit/s VHT-MCS 4 80MHz VHT-NSS 1
    tx duration:    0 us
    rx bitrate:    52.0 MBit/s VHT-MCS 5 VHT-NSS 1
    rx duration:    0 us
    authorized:    yes
    authenticated:    yes
    associated:    yes
    preamble:    long
    WMM/WME:    yes
    MFP:        no
    TDLS peer:    no
    DTIM period:    2
    beacon interval:100
    short slot time:yes
    connected time:    799 seconds
    associated at [boottime]:    3327.468s
    associated at:    1718455437511 ms
    current time:    1718456236584 ms

