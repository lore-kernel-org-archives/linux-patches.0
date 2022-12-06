Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E89613D
	for <patches@lists.linux.dev>; Tue,  6 Dec 2022 12:27:59 +0000 (UTC)
Received: by mail-pl1-f169.google.com with SMTP id a9so13745828pld.7
        for <patches@lists.linux.dev>; Tue, 06 Dec 2022 04:27:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aF6V0yGGidp6q8ssR7JdUYdu4/B6DpE3k0WEFhRk5Vw=;
        b=Vs3pZqSm4aeuLOv+nInbIXkj1GeMqkF4ZHr9AiANTVbsxKxMzxZGnUfqrsYdykK1IK
         h+5iVIl0pMZWjhSUNlzeVoyuw2rWQlmmOpxNdCjjMWR1KOk1ehxWZIgaJcLjBpzJ6nn7
         B/IZCyPLy0aGLQcbbQy02mFs/br5HnztUM3og=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aF6V0yGGidp6q8ssR7JdUYdu4/B6DpE3k0WEFhRk5Vw=;
        b=gxHlU9iPoplDJ2njrClqCQbP0USeeaU63L0XeSLPaP7h48T0e9OzqeUzDH1qbY207M
         yV+Fmdx8574TJ26M/S/Om7PgFRQUBJaHRbDADJNTrQP+dDn7L1WVysIZgYusurFgX+Iu
         Mu92MWz3IJAwNFeYmm+vAhS6G8fH19+/UeJIVvaS/Rd4TizQQLQcbW4q4r9uP0fiQJ1g
         6/apngIqU5kG9zcimuyZylM5Mcs8FlRqJhu8kRBB1HHugfcMf3FQtZjrzJikFPx72cWQ
         Om4NfM7URP55ae8Ii03yn+VlXkligIHL92DuR8DmjAnHNv86eJYk+WC6wbWAcOwFX2qx
         S5Ww==
X-Gm-Message-State: ANoB5pk9WSQst4eaXXT4HuoDX39VtOykufZ0ZxO0loGyc35XR/bcAT0c
	z3orSv03BDxREEr+MeLWsxGhLQ==
X-Google-Smtp-Source: AA0mqf6v6kGYQYhfDmUwl0mIDXxX6gmJ28YDaQVO56HSzFqym6MimztwgkhnqbioxoTBmYZcrmy2/A==
X-Received: by 2002:a17:90a:9c18:b0:212:fa9a:12df with SMTP id h24-20020a17090a9c1800b00212fa9a12dfmr100930150pjp.231.1670329679069;
        Tue, 06 Dec 2022 04:27:59 -0800 (PST)
Received: from 1ea210ad73b0 ([220.253.112.46])
        by smtp.gmail.com with ESMTPSA id cp12-20020a170902e78c00b0017854cee6ebsm3202220plb.72.2022.12.06.04.27.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 04:27:58 -0800 (PST)
Date: Tue, 6 Dec 2022 12:27:50 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/92] 5.10.158-rc1 review
Message-ID: <20221206122750.GA932196@1ea210ad73b0>
References: <20221205190803.464934752@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205190803.464934752@linuxfoundation.org>

On Mon, Dec 05, 2022 at 08:09:13PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.158 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Dec 2022 19:07:46 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.10.158-rc1 tested.

Run tested on:
- Intel Skylake x86_64 (nuc6 i5-6260U)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- Allwinner H6
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
