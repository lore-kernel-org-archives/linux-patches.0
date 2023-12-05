Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162B455761
	for <patches@lists.linux.dev>; Tue,  5 Dec 2023 16:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IIyk6wip"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-6d855efb920so3395269a34.1
        for <patches@lists.linux.dev>; Tue, 05 Dec 2023 08:48:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701794898; x=1702399698; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4F+cl8bqviYCfWVifl1IWgKB6oJF4gmJXAutfvfQxKQ=;
        b=IIyk6wipiOvCOwWnxPq1EWIvJW9cTR00+mPJVcRuWZ75y2P4Kkhkj+xADelig7ZETT
         AaTIq1akYisADW5M4AAIfCHD2guWo4Tfj3eKRGEFbFbnBeJwNi2PgLjauoIsD3GEwlhd
         By9wu42gvilU+J1bWOHC0LfsSbSVYJmltkIWJBTUxO7TwEz+5KZt3+oyEJiV+ByzfjBf
         KPUdYqiOU+UGtUTiM5MIS+YmzwhgkZipFqntin+s20viYqdbGVbqKhmTvzJeU2xKzWxj
         Bv0cUvnGMjd0ItQPs3Sk15p/KR08bafd8/QB0eAxpNrtAoignCQ4IQiApFAsTBqabZEp
         XB5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701794898; x=1702399698;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4F+cl8bqviYCfWVifl1IWgKB6oJF4gmJXAutfvfQxKQ=;
        b=QGO/nIeAzJ31wzrClJfqe5vmnVqkRWqDCeAnbdN4hZwAQTYHWNJm7ayDo91+4kv60k
         lXBR8r0eynVFwpGTjbyqC5AyjjBfVJJjF1+avxPGA0xXe/Kvv6w8PvbyWPP4FdFiniVy
         Vb5ivBXcF0J6aBx2PIuZdsOIZeHzLkmYRchknQPYW/YgdSNiCFn9rNHcHGfwxKH/zOeC
         SVMjUFnUh2VWUXy6oTOYviMLJsJMkbP2MoaQZGRmoG/3EeVbzWehHJYT4nFeZ8LUuTIU
         52sKqo68+vVTxSdSlcwZKVBiqVR4j+9Diad4cRDlmh5Wl5H0cGQbc39b/Dt+uTmnaD0R
         niAA==
X-Gm-Message-State: AOJu0YyRTvADSL4K49WHjYW57a/Iw+7E/XM+6Y+S1o5BuQ4y064P3rRx
	73nTo0lrugH3d1UfsUxQUD0=
X-Google-Smtp-Source: AGHT+IFNL+2khA0N/44s+bMmXXd2EwayAYlVrA3MCsA66rjsp9s7dopeeGCPN5NT2LI09aTlvlRh5Q==
X-Received: by 2002:a05:6870:e242:b0:1fb:17ff:2a71 with SMTP id d2-20020a056870e24200b001fb17ff2a71mr6434826oac.50.1701794898014;
        Tue, 05 Dec 2023 08:48:18 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id nl18-20020a056871459200b001fb31d5c733sm1674470oab.52.2023.12.05.08.48.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 08:48:17 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 5 Dec 2023 08:48:16 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 5.10 000/134] 5.10.203-rc2 review
Message-ID: <d128c8cb-52a5-461b-aee0-6e8159ab91d2@roeck-us.net>
References: <20231205043610.004070706@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231205043610.004070706@linuxfoundation.org>

On Tue, Dec 05, 2023 at 01:36:53PM +0900, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.203 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Dec 2023 04:35:38 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 493 pass: 493 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
