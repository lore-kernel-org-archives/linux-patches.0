Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC93629
	for <patches@lists.linux.dev>; Tue, 31 Jan 2023 03:12:03 +0000 (UTC)
Received: by mail-ot1-f49.google.com with SMTP id e21-20020a9d5615000000b006884e5dce99so5113528oti.5
        for <patches@lists.linux.dev>; Mon, 30 Jan 2023 19:12:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WfBbkbDd95gVhRjbU6KPFTWVPnygLYHxiav1fmang+k=;
        b=D84fgyEGkhZmHGOZPs0/Oq4c7kpBmjjF7qMmDgno9kCjwzBaynZXeTrzwfQybWqMBV
         Z/bNbtb5Tt44eL8R2No+nuXTjjlDqkv7UyR82v9pbH7QC5cvlS+/eM3FuwgkDNwUsSj2
         WJZHz67MiEIqWhIqbxTLrZtK7syM2ASYlOf0997PivecCajm6aZ51ejedY3JSgOKF5A6
         KdY+UEMK/S5lbO6ywojFM0IzbOTJ50jSeApKlF0zmznHs009PXPRf+SR5oOnVwTlkZVs
         VKF18kcDndpf5rYZFED88d0UPYcUK3iq7vUb/5KloM/o6cx2AF7Opagr2WOpdKNDucEc
         8iZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WfBbkbDd95gVhRjbU6KPFTWVPnygLYHxiav1fmang+k=;
        b=aMsHYmxtoFKE+G0pcd9U7Yap0uezP3EAYJJQpdWMVFt/Sm1Y362x63YCfiSY+YO2rO
         2O84lJvbi+cHlRbMs0EjiHLXaUjnKg7zjSYZTTSXyA9F6UTlZssye15zd7KXmsabkcSc
         VEkjRJmRaDBVn2EpJzg/fvD+sbzF0Hp5/QWp2+hzL3upSUAxAx1H1V5dhw8XLoaDXrPJ
         WHSdvB/FLQfZABBA0iTMeucqEJIGvkllLfGIfYPrZWGUASOaXjgNr26EeKCFQGRYU7Dh
         L23tJ1ls/SM8gdb5y/o2tiNRLIP4SgiQBas8RdMoyJDhEMP89DQeg76leZJXzVDkF9Lo
         9weg==
X-Gm-Message-State: AO0yUKUNQX1aGQNfxJDwbW56sybiIZJCPpSKOl3Wd99Xbkm7ZJ+6ToXp
	Zvc05JhtwPaoTg+c6wgvMzs=
X-Google-Smtp-Source: AK7set8tfstPQPTJxw5ir484oQAonXMmk2eEazJQlEthqCUhQqnUirTFBxAXG5UnN5NCU86pXh/KVA==
X-Received: by 2002:a05:6830:b93:b0:68b:b06a:5b8b with SMTP id a19-20020a0568300b9300b0068bb06a5b8bmr7625975otv.0.1675134722240;
        Mon, 30 Jan 2023 19:12:02 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h27-20020a9d3e5b000000b0068bce6239a3sm2315333otg.38.2023.01.30.19.12.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 19:12:01 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 30 Jan 2023 19:12:00 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/204] 5.15.91-rc1 review
Message-ID: <20230131031200.GB835036@roeck-us.net>
References: <20230130134316.327556078@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>

On Mon, Jan 30, 2023 at 02:49:25PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.91 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Feb 2023 13:42:39 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 492 pass: 492 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
