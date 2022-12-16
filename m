Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C408BFA
	for <patches@lists.linux.dev>; Fri, 16 Dec 2022 22:24:48 +0000 (UTC)
Received: by mail-ot1-f46.google.com with SMTP id y18-20020a0568301d9200b0067082cd4679so2210795oti.4
        for <patches@lists.linux.dev>; Fri, 16 Dec 2022 14:24:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YYit2c2jkPTrVbVdrstlPkLC+5NweBeML4Ph4fLR/gM=;
        b=bpXekg32yy+5yfgTWmHPlH7BIoMCxlTwyDV9EX8GwGlAkfN2nHsUy8FW8dsU4bRr02
         vOqOny21fNUns7idHCoVAFlq0ZSOclRxe9hM8P9CJkalsAqC4u2hkg+Jkhg5WAQfaEgM
         juUO7DYhzZZk911NrZrUate4wCCbejstmeYtX4biljNBcQFc9FFfgXqBNy/Bsp7T54GZ
         Qbl9LFB1f3x7JriCsOO+MmRNvsVo69B5B+tJkx9Ajt7pps1ZXFANDYydwlYKvo8WDSK+
         y3rft9+VBUzSlCDFCCEBXRIzDaCT+c/9awf23H4oj/D9DScs7hntDmtsas3i1FsiUP5Q
         Hkhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YYit2c2jkPTrVbVdrstlPkLC+5NweBeML4Ph4fLR/gM=;
        b=bYeScrfXrPWvWMWn6GzG+ovFV1DwWqbr2cwaqLdb54R3Co31Yh36Y8LRJBD8Vez7T7
         Zads5RMi/fIahdt5RABmGnx/fl02Hjgk87OxnlX3VckeC5Skd+xR4kSo232qRGH+I8GS
         b5ZiYLCvOc27IMk7illJbCINprikRSTmLXqB3Lt6YtlFys2nEnFzEQmZ41COxHTXKznW
         qICYiFh7Ol23piUGfkC1nG/0p5zPZBtLaxFsrNolBx8JM9aeRxKmm+Enzq4eNb/Of7xE
         IQx5T/D/ofvxYkE/pZQhY2omF95SAA/ZyyfJXabMX3nVwB80JiQLQYg0d4HXuN+hiLQf
         IxJg==
X-Gm-Message-State: ANoB5pkTej+HKvZzhVMPh1HVqk9B23Cjy5+T6fit+SYsLSTa4e3e3J2n
	Z1N15wmR+cACnvbTRrzR12s=
X-Google-Smtp-Source: AA0mqf5oYROIxEhb5ZDap0hW5Paj3ULGJFVZ92lTc0ewMnYuzYiZVz9U4HZ9kmzbDYBjT2wNgNMLQQ==
X-Received: by 2002:a9d:7cc7:0:b0:670:5d89:b1d4 with SMTP id r7-20020a9d7cc7000000b006705d89b1d4mr17179706otn.35.1671229488024;
        Fri, 16 Dec 2022 14:24:48 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id cr27-20020a056830671b00b006393ea22c1csm1400225otb.16.2022.12.16.14.24.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 14:24:47 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 16 Dec 2022 14:24:46 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 00/16] 6.0.14-rc1 review
Message-ID: <20221216222446.GA4070447@roeck-us.net>
References: <20221215172908.162858817@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221215172908.162858817@linuxfoundation.org>

On Thu, Dec 15, 2022 at 07:10:44PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.14 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Dec 2022 17:28:57 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 500 pass: 500 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
