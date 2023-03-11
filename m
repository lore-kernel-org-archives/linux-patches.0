Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73F77B
	for <patches@lists.linux.dev>; Sat, 11 Mar 2023 13:54:06 +0000 (UTC)
Received: by mail-oo1-f47.google.com with SMTP id c184-20020a4a4fc1000000b005250b2dc0easo1216785oob.2
        for <patches@lists.linux.dev>; Sat, 11 Mar 2023 05:54:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678542846;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JezEZK+AICOI0aCjZw5wcLy2MWny1R1bm5pTOcZP52Q=;
        b=IWAV33oZ0R5ipeJENHaR0hu1TGcacho1kb7emu57od+tpeEKaDo61d820eI0a/8oyl
         wepF0Xf0e8or6G8wJ8CsgD+5B48L+1QpiFgqAvoTeAqS0BN6QQRftwNUzopboFuHTpy7
         Ik6PRxu+/WK4xV3GE0plW3F+zQ7gSLq65jHT0/eOSzdGRiPIsj+DBLRhBqHxLpL+wW9/
         H7iaOddJ2V0AScorw1EsPaHRubnAD6leTmHyZzihfZzhBp7gcLBi17LvA39Ksb7SWxtL
         3t7bdwr+DTuqYxcuu3DQXMZVk6JWk9m9BC6R62UEWmCfjD2AzH7pxNTqnmpcaEvetIdt
         qBXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678542846;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JezEZK+AICOI0aCjZw5wcLy2MWny1R1bm5pTOcZP52Q=;
        b=6Yt7yXk3CSJY00gyV0aqXsWQI9bc50BBGgKsUK8Xrfq84CrEnimhKaE02rZEnq1xe8
         fW1S4xw1aJIOzrNszl+siRcnw0eO9r/nIYzkiRhe53kDxt01HoShTuBOJo3cuzAU4G/P
         QLiV7u5Dm2olmTQ9/D9MnL0GyajcJ25sQ0/C0AWV2/xVCO4CLtNR5CkGuAdYKPBek4ie
         i1szn7C/0mCf38m6LTjpPaZMo2HpHXd2yD0pTt3VZJ3SnYszTSt4rm9FixlD7bShu78c
         PhYhqqcYxS4JP9AFpI8AdRrSpgzf/zEFuxQvjqJ2cR1hP49+WJZ/gNNB/ZgzTe5dLKDk
         B7bQ==
X-Gm-Message-State: AO0yUKVku0beTcN9PnAgVUUrsbvhLBEeyiAbJ21hO/vnPXd5CzpecE9N
	b4yLAP8cgW+TeX/Gn1bdGlQ=
X-Google-Smtp-Source: AK7set/WcLHiSCysTRUjU/YKJhjf7PBNSIjZybwnHqg+QYQ1QJM00HSm+hdT/yVTcZoCLL+49bNHmg==
X-Received: by 2002:a4a:d74f:0:b0:525:34e:1f02 with SMTP id h15-20020a4ad74f000000b00525034e1f02mr11262226oot.3.1678542846086;
        Sat, 11 Mar 2023 05:54:06 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x16-20020a4aca90000000b00524f546997esm1104510ooq.0.2023.03.11.05.54.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 05:54:05 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Sat, 11 Mar 2023 05:54:04 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/528] 5.10.173-rc2 review
Message-ID: <b755d647-a363-46fd-9bf1-c97e68d8700a@roeck-us.net>
References: <20230311091908.975813595@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230311091908.975813595@linuxfoundation.org>

On Sat, Mar 11, 2023 at 10:20:47AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.173 release.
> There are 528 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 13 Mar 2023 09:17:40 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 485 pass: 485 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
