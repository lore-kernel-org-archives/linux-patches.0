Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13B7C2FC
	for <patches@lists.linux.dev>; Mon, 14 Aug 2023 18:23:52 +0000 (UTC)
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-79196067c75so99054939f.1
        for <patches@lists.linux.dev>; Mon, 14 Aug 2023 11:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692037432; x=1692642232;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NWupG9DwQIYj9GGXdsQX071mDyjhufKSfGQxxSZ5484=;
        b=Svr2mtHiul4UwhULRwpJDSx/BAztyHSmfrQOurRbrFGIJI28Rr2Y61qsO9Ilsd4qza
         U2VUYuOQ3Q+yRLXLiIyxsLSnN8fS7YOfbHABM9hqvnVmnz75AEhN0zoHeP6ZYTRfCcmE
         45/5cpsYLGinQWRkxytySUYxLsfbXfnvtsCn/6EUpzJ6FynhT6cMh4D12FGIhX1C9TSu
         ifoikaSss2pW0xvcnhce7lxZEA+hH8BNfS8TJVPt8RjFTcqvEvVMMRR21Hav/fuz4J9f
         56G8Vcxg/QOpPFgjKLMSEIRLrzfwuVWX9BmFt1w/Ua+sYnZUcPZSUdKs7Hj+qAX/p1Bd
         FXDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692037432; x=1692642232;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NWupG9DwQIYj9GGXdsQX071mDyjhufKSfGQxxSZ5484=;
        b=Ri1p08o6qcMqE7Zs6aDmbB6f5/P7kv9yCYTiooxclwYMqWJjswNkU0d1zrSvf9nsCE
         cnzHCMKfbyNqsdofJ+RQ4h392Qf1FYMWYThwB9mHGs+UOH1snoW9+eFxmUVVD9Ttmyyv
         ApOEIy29xf5cqF6dBLmeX9mKlwvFGQ46HUv4i7Y0TYU+ODtRGJDtvzHPKQiAdKluE6og
         r45W0RdvkawNNDxFplEUniEWHMTDilzL/m6zmDKQHs/hpkSu775xUHxY6pZ0ITKKnGgb
         Bl2gd1sN3aKCMKUs0EKKee5VNhbgDxudXaVO3IxZFmvql6/rZPk5tuD4pZWkWMniCJzB
         Mf1g==
X-Gm-Message-State: AOJu0Yxl60ca5qm8w3AghT77iwoG2maspOIUqpLrKXcor0lprxVDmYB5
	1aGVMh9CQyNkYogJ/cWDmVEQKYy5tJo=
X-Google-Smtp-Source: AGHT+IEdL2mP0rO43JPP2eVbfSl6k8D1NAAP65CGIi9xuwSPGh9JxpetdwgDmh8FsBIJJmcqjTF1mQ==
X-Received: by 2002:a05:6e02:881:b0:348:b910:313d with SMTP id z1-20020a056e02088100b00348b910313dmr13371040ils.14.1692037432043;
        Mon, 14 Aug 2023 11:23:52 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w12-20020a92c88c000000b00348fae8a5b5sm3394747ilo.42.2023.08.14.11.23.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 11:23:51 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 14 Aug 2023 11:23:50 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.4 00/39] 5.4.254-rc1 review
Message-ID: <87e99247-e4a8-4ca0-87d1-780ad7186d99@roeck-us.net>
References: <20230813211704.796906808@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230813211704.796906808@linuxfoundation.org>

On Sun, Aug 13, 2023 at 11:19:51PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.254 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 15 Aug 2023 21:16:53 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 455 pass: 455 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
