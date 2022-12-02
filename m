Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C5110EB
	for <patches@lists.linux.dev>; Fri,  2 Dec 2022 01:43:56 +0000 (UTC)
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-12c8312131fso4199593fac.4
        for <patches@lists.linux.dev>; Thu, 01 Dec 2022 17:43:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EDAw+k7/ZK1+ApeJfLb7KmbDjE8+VFTywcK2NeWnPYs=;
        b=l3VU1hWeYUqaYSxqmFL7JLE214mr/ZCBJI7yMMK1Zv98TbfYXLpMuuAMOTJzl51nvQ
         HcV+Oj1QdjfAZrei5nTpZi1bEvKDKmZ+v8zPnq1FN1pZOs2gS09NDmYgIxT78JqPVl7U
         uUPAOLP3PhGX0XLAOknASuS6JPApRYJaoKe/FAL0mR+DsnL8FaihfgJAdjRtbE9BDaE7
         sf52IFDVpcuPFKVFFv11wOWBabMsagaLjD8mPV1V2wHlTaVFyEClQoXJpUybGuXSksOB
         OPw+OpVN6NS0oPHTPN2kM55gqXEznUSZTE4tAv1ngDAXekhU7OP//yOWepftBOSOg96A
         lFEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EDAw+k7/ZK1+ApeJfLb7KmbDjE8+VFTywcK2NeWnPYs=;
        b=73zG/vph83W7pbSi/etZkQUwkhrE3qOXUPeBOZErvcvs//VpMbZZ6gDTc9rOSau6Dv
         sM85iA2ULVWrvPkSu9iC/FiHMPiRUJwy49R3Z0hcJhgxf8GnED3hjuOMYTmeh8Rw4y3/
         482joyrWpikZfcHrq7I877WPb/D+kvwxta9Uoq7Ua78RDP82EiJZ7yg7wbLZe2U/UFnW
         zIA/tVfurIymfYDQO83sO3mN8LpAIlrytBnhd2ab4d1gfMVzAsG3D2fVqbosiDCWpyjg
         xtd1zGRwQFbd0QkigyDN/vI1006x0x8PgKPzvStErZATQKV2IJfSaXqe6PBLZi3bnUNB
         K0sA==
X-Gm-Message-State: ANoB5pn3dB8wpDFjR9lzbA8PmQH937+7TPngdo8GweQXmd9T3Bau6Qru
	sUU8pCT3pNPA35ZVRxzc/8Q=
X-Google-Smtp-Source: AA0mqf6U9hus+hGon+eWJAZLXnx15a4jf8LkIA7TcNeEwiaFyxshHup8CZbdMB92acViWUaT88Lzwg==
X-Received: by 2002:a05:6870:d1cd:b0:143:75da:a5b with SMTP id b13-20020a056870d1cd00b0014375da0a5bmr19439027oac.74.1669945435247;
        Thu, 01 Dec 2022 17:43:55 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id cy23-20020a056830699700b006391adb6034sm2816308otb.72.2022.12.01.17.43.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 17:43:54 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 1 Dec 2022 17:43:53 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/280] 6.0.11-rc2 review
Message-ID: <20221202014353.GA2255418@roeck-us.net>
References: <20221201131113.897261583@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221201131113.897261583@linuxfoundation.org>

On Thu, Dec 01, 2022 at 02:11:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.11 release.
> There are 280 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 03 Dec 2022 13:10:41 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 500 pass: 500 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
