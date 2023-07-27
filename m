Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DEFC1BEE4
	for <patches@lists.linux.dev>; Thu, 27 Jul 2023 00:01:15 +0000 (UTC)
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1bb7b8390e8so2332815ad.2
        for <patches@lists.linux.dev>; Wed, 26 Jul 2023 17:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690416075; x=1691020875;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=krtD8R/lLhBKeI2YQdXqv2MhTFMpAqrYyPfJ6hRaVFU=;
        b=A+kqLljwtj0zb/ddirkKdwi6D3OZloGUPKXuXA0CWzzQfVs3xi5SVjMF2fE10GygDU
         pZjJ067C79pB4DwfAhEndRQ8djouGmGN3VnPnDZK1X0297a0JRPBhd+OoWreME0RQKq0
         an36sir9uzm5yY6wWFB8MO5yYi55vZjgSKcO14jUDfSeFUqjr6PnugP87ewbUkGGIgj7
         QlZPpzzNHC3Z8IzKkHYy9PAmlFT5sCyrlnAgJGhFinLsuLAY+deYkahFb8xQ9sIp2fuI
         sCr0/DKtD1+zGujPlaTgr882U/UICmESb6L4ol7HgTu8yjK4mqNgTRh0FlCIFHkA3LdF
         wCiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690416075; x=1691020875;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=krtD8R/lLhBKeI2YQdXqv2MhTFMpAqrYyPfJ6hRaVFU=;
        b=EXeCrEFEkHc7T3wV26H4IjOXH+I8latvkFSiDM/w65aYBzEgXhcdFjX2PuUtaFf2hZ
         Gl/xN/I2MvqpnEcVDVLsxG7Ua+LLqD8GmskdOqkhjTqKfuL2JV0//+H/vIAMsF8Bh96W
         H3RSiOFrsNnAi7/GKWKwD1STwofHVQ5N9itQeSjYfY5EjecqIttKbklvwXTBVsIKMyiS
         8iBnj8AyNd1HjCdHBBt+S20+2SBCGPDTyK48Uf29yf+j/8uM4xw0S2eZNqEQef9mJFm9
         AknNBRcxIKG6mqrrcFA6kKF70xCtJ/Rmz7KVlrGMVa3ybnzAsc+iAt18nxaPVW5+EoyD
         UcEA==
X-Gm-Message-State: ABy/qLY1k+Oxhj2olcCYLcrA3dZiK8nrOalO/ZyPleJGQYVklUHJxA/e
	BEELg4w2+cCh7rwX4yrY2EFkS0c1m2s=
X-Google-Smtp-Source: APBJJlFcskRhxR4tDtKALG5JpFr5TJd6jaMbQx/EjxLetEPEFtwwgdRSQV0SceG7NRq+AFk76NPNEw==
X-Received: by 2002:a17:902:dac6:b0:1bb:d280:5e0b with SMTP id q6-20020a170902dac600b001bbd2805e0bmr2378295plx.18.1690416075182;
        Wed, 26 Jul 2023 17:01:15 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t14-20020a1709028c8e00b001b8062c1db3sm128454plo.82.2023.07.26.17.01.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jul 2023 17:01:14 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 26 Jul 2023 17:01:13 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.4 000/310] 5.4.251-rc2 review
Message-ID: <88576194-c440-4b8b-8b37-225d5c87171f@roeck-us.net>
References: <20230726045247.338066179@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230726045247.338066179@linuxfoundation.org>

On Wed, Jul 26, 2023 at 06:54:02AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.251 release.
> There are 310 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 28 Jul 2023 04:51:55 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 455 pass: 455 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
