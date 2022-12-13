Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D39E7F
	for <patches@lists.linux.dev>; Tue, 13 Dec 2022 00:25:39 +0000 (UTC)
Received: by mail-oi1-f175.google.com with SMTP id m204so12870639oib.6
        for <patches@lists.linux.dev>; Mon, 12 Dec 2022 16:25:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HjhAEhNy4eBz0xtQln6cgYjayNXGTWsSk8Q5Ye+0zcU=;
        b=FmIEJwgvNlXRTvqKSvAGzatkGqI7kzhAcmwAz1d12dSMm78DRc1Ki9jDTTYMzL1F8r
         2lSFrevaF7b1CFDdpmAXKr2WWpx08aYT793tt0WNw5PTBe4mql/2voi+//2UDN1A50xO
         vta8z5b7TiDxh4GVsbst/w0Hw0gSWL0htbaE0zCfOyK2yBskiw5WNYfZciE0KpS1+KiE
         JJmVZxnQNd3iAQktFRajsedXm4NfPTVcW7U9T6rEC/Yvd1U1Fz9+Bgh1j7yDKcJQf3s+
         vAO2p15i3nuCEPZTd0MDWq+Ww6zel5qQNNelWBiYYqCBUlpl+M8vzUnlubntlTujpNrK
         lfrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HjhAEhNy4eBz0xtQln6cgYjayNXGTWsSk8Q5Ye+0zcU=;
        b=nnLWwVui3pXwm+qzAt1XDp4j5bBhA+aHAXSBvQ32aLLSxZKXTZ54x/J1qM3yaUzhGl
         G/5JTACX2viVFANxCPUrccIDCf4PGhjruiv0XDcGVJiDCLVgR/Be/bXT+jaqaNH4MHLh
         A927/Nz/xvADqrEMlki2g8yNewnjpajNo2CWXxau6Q2MNXBdST8l1txn+OXMnNiMiTVu
         ytl2gdTtqUgN1Pg2W1FW2gC0gLjtOu9zl4NGONi1mfsVOeJ7WG8dskx/YtULP7j95Oi0
         2ELGKky73win5D9OnkveLT5GdEXtbvzESe+wJl/FzPLm6KpXwRiWseA7NZyf1B249I4Q
         KYdw==
X-Gm-Message-State: ANoB5pmdqyGCpSf/tx4vbMylxj31YhKtVBL4uvinBbLxx1QGms6n8Pow
	Ma+9jlzlCNs1t8IdEX5iMN8=
X-Google-Smtp-Source: AA0mqf5sdy4PFIu9ZH/vUGeGoeF9W7DuK7dztuSjeyeOKkE2dXAmxUNwCArg96qatQLPjowvXaBorg==
X-Received: by 2002:a05:6808:10c8:b0:35a:2325:7b04 with SMTP id s8-20020a05680810c800b0035a23257b04mr10158574ois.54.1670891138202;
        Mon, 12 Dec 2022 16:25:38 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 5-20020aca0605000000b0035a7fc53a26sm4030367oig.42.2022.12.12.16.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 16:25:37 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 12 Dec 2022 16:25:37 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/157] 6.0.13-rc1 review
Message-ID: <20221213002537.GG2375064@roeck-us.net>
References: <20221212130934.337225088@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>

On Mon, Dec 12, 2022 at 02:15:48PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.13 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 500 pass: 500 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
