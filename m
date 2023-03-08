Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F082C9A
	for <patches@lists.linux.dev>; Wed,  8 Mar 2023 18:34:02 +0000 (UTC)
Received: by mail-oi1-f181.google.com with SMTP id bm20so12868203oib.7
        for <patches@lists.linux.dev>; Wed, 08 Mar 2023 10:34:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1678300442;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B9LrpmC171HQRUblc06CI2KjW6cWk6Sb8yDZK03fraU=;
        b=URn+G7KlJct4bRPej5fPlH2PT+eexQb021kzQ5CEj1Oxxt3p4p3+wWKqE7gkvYiWqj
         nXaVW8EoaoSW05ln6+myN53qZkw5FvQtSd/NbYoDEJDL9GLJwY/yKKymQSQfdsgRdCBY
         02NsHLGaUeDkyvmK+iUlES4b4axfGMASeWv4k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678300442;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B9LrpmC171HQRUblc06CI2KjW6cWk6Sb8yDZK03fraU=;
        b=J8U+2aFN4f62/CZIbIQ9ERD59u6s7TSBwux/EMeBZRnExCRy9eFs+lV0Nt4iDBR6QC
         cmQd0+A90CEOCj9mC5faJyBEdh9RLZ1W/TREergr+/xAzdBsgpsK7hq/VuzrAzcFKGTC
         PeOko39n43fxyxZEC9QNoPZRi4zstAsqJ/lDxZ6HYBEp8uvv/lpTdNBUyiP8/JD64QV7
         Zm440WFPIG8B0JoVmxb6w+IqCioJW98TXbQqLK4MljiT3CtWFAaRYLOa+HwpRQvVEvlv
         +PCzYgwTrXOpSfRcSMm7sHuQfEbXbvEb2pWKDauvWWFkjlhtIUB8reumYTFSTDkuRBDG
         yA0w==
X-Gm-Message-State: AO0yUKUdxc2PnlXpbkaWLU3FOgZQTQZVXkoE2ErLdzsdakb12ZpEw2z/
	pkWBTAFmKQyppoRE+7giXookxQ==
X-Google-Smtp-Source: AK7set9s66ey7Pd2U7u3rc5QdVYbw054DPbXubGkP/DV1CegmaMVAFssVKw4/jQin94cL7bNtE7n9Q==
X-Received: by 2002:a05:6808:274e:b0:384:23da:6e73 with SMTP id eh14-20020a056808274e00b0038423da6e73mr7567803oib.47.1678300441866;
        Wed, 08 Mar 2023 10:34:01 -0800 (PST)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id l7-20020a544507000000b0037d8c938d62sm6574214oil.50.2023.03.08.10.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 10:34:01 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 8 Mar 2023 12:33:59 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/887] 6.1.16-rc2 review
Message-ID: <ZAjVF4i4rS5BTsaX@fedora64.linuxtx.org>
References: <20230308091853.132772149@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230308091853.132772149@linuxfoundation.org>

On Wed, Mar 08, 2023 at 10:29:31AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.16 release.
> There are 887 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 10 Mar 2023 09:16:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.16-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc2 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
