Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E98361
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 00:39:55 +0000 (UTC)
Received: by mail-oi1-f173.google.com with SMTP id i127so14135346oif.8
        for <patches@lists.linux.dev>; Wed, 11 Jan 2023 16:39:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vD6FPw0Foz3KscaH9BJ4SjGehgedvV7XcgtNlp6oYpw=;
        b=jx8uVM+jed9cCTxSuxF3g+qXgo6J7/eQkRCMImwaOjC7zMI7FPJmRKPJdu+ZR7oAxi
         u5nId+iwxA/huPvvDQ6rc2MR+2GaH9a1wjhLuYwTjX3wN6WeIibJBSbim4mhA4pgbnMS
         uDWkkqLdmodToimywp7Xcx2o51prwf9j9eaGgM00CkKltITH0qT4GwjAnoeDvbC9VzrO
         QQdU9MtJ+REO4B1LZQEvYoteF9Fkh8EPNUdEA/hr3/gu3K1vRsMrodwETk/ddsGpoF8E
         Zw9jirI7lwYw7l2gg2ZLipsixtRpaUhtn7OTQpRruE2lWuDShNtGkRPBQ7E9BnlGe/VZ
         d8nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vD6FPw0Foz3KscaH9BJ4SjGehgedvV7XcgtNlp6oYpw=;
        b=iv194eioqAG0x3185FDDNmT9JaFLba8wC0rkZFQKRfaPxudLjtU2cNG7ybS+FoGHx+
         hRTtBIIfsbzWh+9rKn98n400DBLw50ewFAEepPHVxW1XHSCMUxTGOh+/3/lNmOwMKLlv
         Et759doGke14BulaWvvcHhGv3rV80mopDy8o4DAS8PmjVE0u33MUu2fSStDMzyRwdSPL
         ZoSPW7fwpthqSiWsI87uxynmwgVIExe1lqjKT7KCrqdUcNgx+89g02/bt8Ueqh8eohaP
         29hhuNZEAqs86fegHfb7Ov3N9ontfsS4FaKW+kdGI6Y6P8XFUY2guFEpUY5b3r8sO/Yd
         KHSw==
X-Gm-Message-State: AFqh2kot2J6et13rs2u6ZaikOxbdpKPG9iJkPw3GyVLPhkh9HV0yMK5Q
	mKM9tENYfU3CtpTDQNuqSeQ=
X-Google-Smtp-Source: AMrXdXvb3xCEM9deV/155H7juHqnMssSD6E5wampKJojkM34Ez1nWEDc/kCsPahdW37dVIJbjXg5vg==
X-Received: by 2002:a05:6808:1387:b0:35e:bd7e:c89a with SMTP id c7-20020a056808138700b0035ebd7ec89amr40084928oiw.16.1673483994985;
        Wed, 11 Jan 2023 16:39:54 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bh31-20020a056808181f00b003436fa2c23bsm7296800oib.7.2023.01.11.16.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 16:39:54 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 11 Jan 2023 16:39:53 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/148] 6.0.19-rc1 review
Message-ID: <20230112003953.GB1991532@roeck-us.net>
References: <20230110180017.145591678@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>

On Tue, Jan 10, 2023 at 07:01:44PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.19 release.
> There are 148 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> NOTE, this will probably be the LAST 6.0.y release.  If there is
> anything preventing you from moving to 6.1.y right now, please let me
> know.
> 
> Responses should be made by Thu, 12 Jan 2023 17:59:42 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 500 pass: 500 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
