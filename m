Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A660A24F2B
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 20:47:00 +0000 (UTC)
Received: by mail-oi1-f180.google.com with SMTP id r76so13924164oie.13
        for <patches@lists.linux.dev>; Wed, 02 Nov 2022 13:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WKmJ5JoLpFYgfLKKODG9Gk/9YmXzCQzISYWongoE+Tg=;
        b=GR9qGaj/MLz0QuQRws0IUsP3GFTSmuKM7NEQtpDjwanNTgaaW/zgS8MET60K+q6w8y
         BgMh7YnLqG1ZQy7DT27g2itFX2dvZ1nnCis44LgM7RQtav041lPEFV7QtLWAlh0BnxGr
         hws1NA6q6WKvqWOIpnvCCESlED18WgTURnPLouERAVcV6suu1USw140amxq/OroauquZ
         Ff5GXL71bmCQoHjcGMEumJjcAyYzdlT36kDCEQhdgAMb85m9dBiDmFmanLn6/3WswUlH
         gGI+0TxwtbXXdDuWyBWeBUD3VsCOPnBo680Dlp5QqFAXar+ay/BgJMDk9qqJDFmbIgf9
         Ji4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WKmJ5JoLpFYgfLKKODG9Gk/9YmXzCQzISYWongoE+Tg=;
        b=mwJH2O1AHCUHJm/VbMwS3T/l0BT8yTC+6DWwgf/rS0esFTZD8YzhdljJy14Rnz8I0X
         rfoHElQL6w+InThtZggwxJzKlUILiJjSFoVDlpzVM++UF/zonvMoYy6gQbimjuxPzQJp
         xnWdGWJuEY2b6jWarGcc/NxFnquGoMfg7pfAC+lRzFiIyjINUDb3YPTmr5GcbP317lD2
         oLh5uVg3MSSJI4IaxI5s7Wu5BxC628k91kYr+IIA3rSpq9gXyp63lnNTxkbkMr0V8aaH
         bMfHISGiXnAMUCrBois4oApvrtY7uv9zuvLURrxm6b9ocp0L64BmBALmR9MD03rP3iXO
         i0Sw==
X-Gm-Message-State: ACrzQf1BsmM6kRbKoVQ5zGDpZgN+svEusjjhnyyVZeJB6MZS7l6mo0mi
	O20B+dQ7qOuymzBkkFuGG2o7iOFdkxY=
X-Google-Smtp-Source: AMsMyM6aabmxrj8ZX75MzJo1eGe0aehlB8J6xM9nm1A/XSvH8losngnBLyELYGUL2ixfYHMvcivWLQ==
X-Received: by 2002:a05:6808:16ac:b0:353:b7d7:5fef with SMTP id bb44-20020a05680816ac00b00353b7d75fefmr14901190oib.293.1667422019788;
        Wed, 02 Nov 2022 13:46:59 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b11-20020a056870390b00b0013cd709659dsm5576705oap.52.2022.11.02.13.46.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 13:46:59 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 2 Nov 2022 13:46:58 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net
Subject: Re: [PATCH 5.10 00/91] 5.10.153-rc1 review
Message-ID: <20221102204658.GF2089083@roeck-us.net>
References: <20221102022055.039689234@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>

On Wed, Nov 02, 2022 at 03:32:43AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.153 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 475 pass: 475 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
