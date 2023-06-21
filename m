Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6749EC3
	for <patches@lists.linux.dev>; Wed, 21 Jun 2023 00:39:12 +0000 (UTC)
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-6b2a875b1bfso4571730a34.0
        for <patches@lists.linux.dev>; Tue, 20 Jun 2023 17:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687307952; x=1689899952;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jfFk33JPiu5SUkSbaXOEsTyCLjYQF4FOsYyjMoeQTcM=;
        b=NgpXZFxlsiWlQ1BD1WSCYVxBiO7p2B+3PlF60QExYxY7/EomTiYaiGct3OrkWlRgRy
         zZpehOMJjLiTqhbvmVz2Yw4I55Q5CBkkZSpYH27JWHSOBbrY418zNM3IqskiKnTz8FMg
         YMHlsuALlleadrdVmUYQrMj//fwyQWc/jeuMUiXh9wUK8XBr14jVnxOTOW/WeOYyKh1l
         U27cdAbl/4PeeK5iXFTn5JZ5e2HGwbLRWUilKltsvGQxqDmrZpiedq3XgTO56+eJCAHP
         CTGMrvCgundBy6AQHHN/OfJlXceK/kc7dr4stEweOKizYBGRIQyqwf072exokhFTJjdp
         5wfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687307952; x=1689899952;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jfFk33JPiu5SUkSbaXOEsTyCLjYQF4FOsYyjMoeQTcM=;
        b=DACcdDrKcmroltf/iToaDzcS6G90e1hHgG3sbfyNHt8SpHjxAC6V7Af1AQvozPcadd
         woiG3RU650r2gpml8QXpyRWUh++j67/7q4I4Z9dgC+HAMtnbd40Q7pVRl0yjJAbF4UoD
         UGnxNac7Auf06TIikdwlqMZ54YAXa+Z3bf9G6u1Y4tvzYs531qa4o+XSpB/FASk4LkwJ
         3SQCr5cB+6dwlfzQsMtzF9giPsEoZl+zD8eZbipXiAw2WwBq9HW9zhPFQIINMP5PNjop
         KYmlZUndASMTdDAsZ/FuQ+lpsso/JoV+1NyVouhtQ+Jljg7uHmd4sRPZ61owXSwVIR2z
         /PFg==
X-Gm-Message-State: AC+VfDyI3Xf1w48OCaTqV4OJFh/zv30tsjLoUmvmBsbPHw8Y5qrPmHos
	LbTMQX+p+vFomve22cpAbb8=
X-Google-Smtp-Source: ACHHUZ7v+UFkOUJX3kItkD9CDJcXcN2MvfTbWPS9AL78RMeXyU5m/wHdQibEmVQWqHG4HVHd7W79/g==
X-Received: by 2002:a9d:6acc:0:b0:6b3:477c:c725 with SMTP id m12-20020a9d6acc000000b006b3477cc725mr10693386otq.12.1687307951713;
        Tue, 20 Jun 2023 17:39:11 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y13-20020a1709027c8d00b001ac937171e4sm2112422pll.254.2023.06.20.17.39.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 17:39:10 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 20 Jun 2023 17:39:09 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/107] 5.15.118-rc1 review
Message-ID: <00866956-184f-44ce-a690-674d8482605e@roeck-us.net>
References: <20230619102141.541044823@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230619102141.541044823@linuxfoundation.org>

On Mon, Jun 19, 2023 at 12:29:44PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.118 release.
> There are 107 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jun 2023 10:21:12 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 499 pass: 499 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
