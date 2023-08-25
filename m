Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066892CA9
	for <patches@lists.linux.dev>; Fri, 25 Aug 2023 15:38:06 +0000 (UTC)
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-34cacab5e33so3574135ab.2
        for <patches@lists.linux.dev>; Fri, 25 Aug 2023 08:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692977886; x=1693582686;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Dz5ahBOHl2bbH2qK+Exj0zAbZ4Se97M3FlA5URgWaWQ=;
        b=PFeIrxX6lC1CZNlZRPYzPA8H8WikGo6NOR92KOyC8ISsgCx1gLa8P3JtOzzXj/7HQK
         VPAoQU1oDb/2h37vOP/pfK7dgA0v7hyyLUgSouksbgodARIlEpVH2/eEzUgN+k22ZZD8
         NMt2VM03otD+iUTzL0WYlyaf3bbcB5D0nYPKlgZTnAZV5cES8SXPluh8eryEDywkgxgN
         f7lLhyIyQxUCKDbkEOQ7vz4wRWqvX9BmDYIWEZMaKjs6/NpiSM6tbud4XeU7BFN9psz8
         K15IeH2DHDrenBPztdECLbE6RyHVb42DZEmpfJKbuq2Mt4FIkosuq++MU1unCOK6y7UO
         myow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692977886; x=1693582686;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dz5ahBOHl2bbH2qK+Exj0zAbZ4Se97M3FlA5URgWaWQ=;
        b=iTOHyThQAPGbrYGerK+1RsYlPPQo8Hl+jUXjndc0cf8ORgVb3cqkEY4e9bb8F+nQW6
         J3+/+OcG02Cdl5cXaqWyPbL3eEJ/MeRzvQVWeSMNPZ7KuIeXjW70tJMttBoUrsnQbrEA
         mqzAGtF45VF5WhGZPrCjLXGTlr6N4wGLeT1DdU06+7IWSVFHIYbGyjozwXCx8vGvPLc9
         kmnGUvNHbwmA1ARwoJ3esn3Iclfk9AcBFF0Fuw3TkYCA0liU1m3BqLY6XfxrClWlcXqi
         NJSvzqLuFB8j60oDOJvVt4VI1j499xZ0EuGDfwLHQsBK/Rqx8kj7WKS7HDdqLNBklyJV
         ErcQ==
X-Gm-Message-State: AOJu0YywUIbXekBe5NRF9sGKhu50l0nQYv7wMEffQgmfZT6VsjqhEPDS
	ZWpGFt86VfqbwI7lKcSJTPI=
X-Google-Smtp-Source: AGHT+IGXcm8HRPfPMUqpBveB7Dyn+UNV4oOmGWBgciWYubpLSZkygzhaFoSxMtXN2p+Smqoe4+UTfg==
X-Received: by 2002:a92:c201:0:b0:348:ffdb:78 with SMTP id j1-20020a92c201000000b00348ffdb0078mr8283901ilo.9.1692977885897;
        Fri, 25 Aug 2023 08:38:05 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t7-20020a63b707000000b00553d42a7cb5sm1573917pgf.68.2023.08.25.08.38.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Aug 2023 08:38:05 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 25 Aug 2023 08:38:04 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.15 000/139] 5.15.128-rc1 review
Message-ID: <e2dc2283-65d3-4160-967a-b758a14fdde3@roeck-us.net>
References: <20230824145023.559380953@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230824145023.559380953@linuxfoundation.org>

On Thu, Aug 24, 2023 at 04:48:43PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.128 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 26 Aug 2023 14:49:55 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 501 pass: 501 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
