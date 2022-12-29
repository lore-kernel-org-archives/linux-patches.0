Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C288033F0
	for <patches@lists.linux.dev>; Thu, 29 Dec 2022 13:42:58 +0000 (UTC)
Received: by mail-oi1-f176.google.com with SMTP id r205so17155785oib.9
        for <patches@lists.linux.dev>; Thu, 29 Dec 2022 05:42:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iU5YR6g7EfNu0IKYILG9gNX2NqRxPGtJQ3zhvrD7d40=;
        b=Vjnbt8qCFN9vs5SeheQkjqX73L+5YrEyhgFYHuNft0EHBaacpA6LgS5zEvsxfdpjgZ
         G5oiQcGyZSjoCfrB9kHrfIDFUcHZ9fBR4QLM0HK+FFOnKwOFPjB0o1Ok0BEo8bIgGKmY
         /ZCUFD/f4xZJHelP9yi1cU4AdWCt8c5hTSoCfmT80dT9mpYbc4VQuW0xeodQPvthDLjp
         bHMnjKDXp8LhCssXKaqDFwZuzHhAUyPuEZ9RP9HSOCSITztZFGS+knJXJXQAxGSwOFHF
         yR6VK9tVleeQjRAE2UUyh40RIlwpeQ27z7F5CUpD7MpyJWjS1Rt2BXKnx0ZxYgdNRvml
         RjPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iU5YR6g7EfNu0IKYILG9gNX2NqRxPGtJQ3zhvrD7d40=;
        b=7U1bZ0Ff0+MzoFszdD3Bv/73fOgBZ6iV2KugshOIR6Kw9jrHUziQOYAz5lCE9rjJT0
         9veXc+xcCnAqC7vKoiKuv+AM33arkOKttd3a12ZrbiMfiLzYDNc94b/jwxrri010EHZF
         tePl1VKNFqpjw330ntX1CIbdnAUTbI7qY0uLYgswUH3q+6BNTsZ+O5ky24Fi3wK19Fut
         4sLtMyF/FOGPThHSpBl8EQBDR686HxloGrokuK8IxiYE0BrSEbK/cDXYEewc0tkiopHT
         oDsIDvfZMlDLmLZ+bSmjaLMGNHwuRVqdZODOidBY0LQgQMomKu/v21TLW0iyw0K83lbE
         eEhA==
X-Gm-Message-State: AFqh2kpQl/kh7N56/CX3Oiu34bk1mZzksdic30a5QirWS8YRQWAxPPm4
	kSPnqBY526fIsBtRukCHkuM=
X-Google-Smtp-Source: AMrXdXuo9eYBLfUByRgvD9NMG9Rb66AbVGrS7Ha0n8FVfIwYn+QIzbcIG8zOwR37iOFykfujMN4XdA==
X-Received: by 2002:a05:6808:1387:b0:361:25b3:b4e6 with SMTP id c7-20020a056808138700b0036125b3b4e6mr15394570oiw.22.1672321377725;
        Thu, 29 Dec 2022 05:42:57 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s8-20020aca4508000000b003549db40f38sm8037733oia.46.2022.12.29.05.42.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Dec 2022 05:42:56 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 29 Dec 2022 05:42:55 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/731] 5.15.86-rc1 review
Message-ID: <20221229134255.GA16547@roeck-us.net>
References: <20221228144256.536395940@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>

On Wed, Dec 28, 2022 at 03:31:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.86 release.
> There are 731 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Dec 2022 14:41:39 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 158 fail: 2
Failed builds:
	arm:allmodconfig
	arm64:allmodconfig
Qemu test results:
	total: 489 pass: 489 fail: 0

Build errors as reported.

Guenter
