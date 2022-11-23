Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD9C256C
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 14:01:04 +0000 (UTC)
Received: by mail-yb1-f175.google.com with SMTP id y83so4370366yby.12
        for <patches@lists.linux.dev>; Wed, 23 Nov 2022 06:01:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WTYTRYk6f/wEnl7mJzNrGBfYtp6molz9on9Z5eyVh7Y=;
        b=dOyMTxXjwVGwKVthIhRYDaAtrpahmmifx8Qf979kDzdG0O/ly0ey6ZDqNlFtRNv0AZ
         MyT2vWpH1YkG0bi8xh2pfB3jFxZW4ZdpH9ABAlvtdqPgGq91GkzUqq5Xy7e/WrsONF3h
         2Yx9mKtvq/I4tZS5dehNlBDNTUbfEpbokf7NdBWRPbQ2uhQRb1OFOzKJQYRNkJ+1gMK6
         527rH3q6Rxu2s6TlwOGnCyv8f4dVbAPTZBahB8OLE1x0YHAR07AIV/nOTD1BviYEXQev
         sn59XdvndRwckymR2UIH3GH0jWU9TzCkcTwfhWWEQQS9RvMWn1L3FCljBfQ8Vp9UfsRw
         YpAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WTYTRYk6f/wEnl7mJzNrGBfYtp6molz9on9Z5eyVh7Y=;
        b=1OmfTWscv53T1XqbRVDb1Hn6SIvZcxZAXms4In5pDBC/WbT/gvUXjnWqprj2zyUx1Y
         K2ItdYnOzsObfwg0/7Azp55oXxWr9853nWxA5KSEBd2XG7spYtPtcnvCLb71WrXmj7sI
         +x0hNtGidJBQkWmgTD2V9Db8oiU5m5nwJeKcx1FuR1oQ3Sm++vRdk32eyGzab1e/KlNS
         SSn662vpd66EvSvubdy6o1X8VOWqXCHncCzjL2ZXF1JAkH6K9OxNhJEmlFvomDwlSV88
         5Z7YsQsz+LKhffoqUe5juk8PEGgcFtZ9zAtmC5lEjtQIDZoU7XpW/xzKGQIDK9HQxyFp
         3faA==
X-Gm-Message-State: ANoB5pmLDP+pnD3PwNsweKAnyo0ti6pwzUsiv/5JP0VWn20X4nY4lKOH
	jMg1iSGK1b+9dLbUHopf259omiFo3A/PqGoqY3ccjg150MVmdA==
X-Google-Smtp-Source: AA0mqf5sFmUBzHQ+l6kKNO0dh5atgZv8TBPL9cQGGpRXs3zWuwYppj+h7nEHVfjqs/k/q5ZejLgXlnCiIXc05201a7E=
X-Received: by 2002:a5b:f0f:0:b0:6d2:5835:301f with SMTP id
 x15-20020a5b0f0f000000b006d25835301fmr16235642ybr.336.1669212026059; Wed, 23
 Nov 2022 06:00:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221123084557.945845710@linuxfoundation.org>
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 23 Nov 2022 19:30:14 +0530
Message-ID: <CA+G9fYvKfbJHcMZtybf_0Ru3+6fKPg9HwWTOhdCLrOBXMaeG1A@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/149] 5.10.156-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, Netdev <netdev@vger.kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 23 Nov 2022 at 14:50, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.156 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.156-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


With stable rc 5.10.156-rc1 Raspberry Pi 4 Model B failed to boot due to
following warnings / errors [1]. The NFS mount failed and failed to boot.

I have to bisect this problem.


Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>


[    0.000000] Linux version 5.10.156-rc1 (tuxmake@tuxmake)
(aarch64-linux-gnu-gcc (Debian 11.3.0-6) 11.3.0, GNU ld (GNU Binutils
for Debian) 2.39) #1 SMP PREEMPT @1669194931
[    0.000000] Machine model: Raspberry Pi 4 Model B
---
[    3.253965] mmc0: new high speed SDIO card at address 0001
[    7.229502] bcmgenet fd580000.ethernet eth0: Link is Up -
1Gbps/Full - flow control off
[    7.237710] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[    7.253259] Sending DHCP requests ......
[   81.086546] DHCP/BOOTP: Reply not for us on eth0, op[2] xid[42e6766b]
[   89.106504] DHCP/BOOTP: Reply not for us on eth0, op[2] xid[42e6766b]
[   98.657252]  timed out!
[   98.683997] bcmgenet fd580000.ethernet eth0: Link is Down
[   98.691276] IP-Config: Retrying forever (NFS root)...
[   98.698404] bcmgenet fd580000.ethernet: configuring instance for
external RGMII (RX delay)
[   98.707190] bcmgenet fd580000.ethernet eth0: Link is Down
[  102.813504] bcmgenet fd580000.ethernet eth0: Link is Up -
1Gbps/Full - flow control off
[  102.821680] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[  102.841257] Sending DHCP requests ....
[  119.840915] DHCP/BOOTP: Reply not for us on eth0, op[2] xid[34e6766b]
[  127.860148] DHCP/BOOTP: Reply not for us on eth0, op[2] xid[34e6766b]
[  132.513252] .. timed out!

[1] https://lkft.validation.linaro.org/scheduler/job/5880584#L392

--
Linaro LKFT
https://lkft.linaro.org
