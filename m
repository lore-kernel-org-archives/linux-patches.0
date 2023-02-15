Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD20B7C
	for <patches@lists.linux.dev>; Wed, 15 Feb 2023 04:17:20 +0000 (UTC)
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-16debd2786aso11740111fac.7
        for <patches@lists.linux.dev>; Tue, 14 Feb 2023 20:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xmVeJ55I3Amn4MeSLLrEqjAfEnFaFqqmJFVHznJhXDg=;
        b=f0JQ8yzg+FPR5y3CaNNne8QhAd3lAC+Iilmkc/1qKFQTVBnRvohkiTN/g+NPgq0Xz1
         9D/AruKAIVYyH6eQMAt3KOsjYJDlzJKisFMpwfFA3ZkKBrySd1D6r50TnpU+1DYDQMhU
         HTY/kh7NQ2N99B2VXolM/BaAF5uCePH0rJi5DR4vF3ANxwwnMU0MsrkyeLbZJ9shFQkD
         p+a3x4w9MUXBQdKGtJ+fBOhybW5arybnxQL5cC6MZL4StEjiLu2s4bkg8jB9OteGxdPg
         ANdpvz12ub8F7pCYPMzncSWFQUQe/2u6J+lT534u39ulfGTjd3B5CPSi2rXD1mEzF7IG
         ICFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xmVeJ55I3Amn4MeSLLrEqjAfEnFaFqqmJFVHznJhXDg=;
        b=03SAiZpvL+7717m9CuByI5ysKkzi5anrDH5q7gu4whf5nt5snQ0lwivSF/o+QLXVAz
         i8qgK00PemIgLj7H+X1MZ3oVCIHATP7nYdJdVTy2z0RqVxpdnp4RTdE0bNooyOTgyfwo
         TmYix2mFrqY663bxLD7gqrZ9vNW9DF2kwnxR9cJ9xUki9IXaR2qA3996vFi6AA5rc2vh
         lGpI9Tj39tltetI38rQJD+FlZb4KqKKKBEgifZxULBKuWclWsbbCKwyvo6ZV8T5S1c+n
         83j/3GwbzVD0qhlwS0Ec7rKEm2JP3/IIXBYxBdHDzZTR6KY8+qgu+1Za/ZBcY/6fqbPs
         VZIQ==
X-Gm-Message-State: AO0yUKVlcQezQHjiCSh5xNQUAWL7D2MlZcZKlbtSdjaG8OiBgcUILcS0
	5KoVK4tnMCQ2WE1M1qvi4a4=
X-Google-Smtp-Source: AK7set9YxmE76VEtlEwSGDhLhrdacS37IAlGfOJedC4/nE6qBvViit+FXiWz6r49rMj3U8quEpIkWw==
X-Received: by 2002:a05:6870:20c:b0:16d:d985:3363 with SMTP id j12-20020a056870020c00b0016dd9853363mr401941oad.36.1676434639838;
        Tue, 14 Feb 2023 20:17:19 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id ds41-20020a0568705b2900b0016db8833b2dsm5181674oab.52.2023.02.14.20.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 20:17:19 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 14 Feb 2023 20:17:17 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/134] 5.10.168-rc2 review
Message-ID: <20230215041717.GA1237270@roeck-us.net>
References: <20230214172549.450713187@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230214172549.450713187@linuxfoundation.org>

On Tue, Feb 14, 2023 at 06:41:06PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.168 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Feb 2023 17:25:19 +0000.
> Anything received after that time might be too late.
> 

For v5.10.167-133-gf90240a:

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 478 pass: 478 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
