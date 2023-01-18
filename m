Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A35E7B
	for <patches@lists.linux.dev>; Wed, 18 Jan 2023 01:38:16 +0000 (UTC)
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-15eec491b40so13062770fac.12
        for <patches@lists.linux.dev>; Tue, 17 Jan 2023 17:38:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yj95zSMd/dFzEvBANl5CQ2nulIJOTYnoNXUK/SwkuLw=;
        b=N67wc/sdTeD/kWurZ5iOghACMZ/UDON9JEeyhQ4J5nucfOXCEUqHtM1sf1csiY8mWh
         PJ3hDWt1SHPq8VQa0hIAB9getPRUQd72NZwrl6ZtBDJcl1e5zlap2zJonahffO2A82BC
         ZWOqPmBWN3JFDkG5FiMIuVxoU5mDGOtU8MraH/rIEgHiresAt7iz1fvgn6b6/QglRJke
         z9pC3eAGa3s3Xem34y21jvL+o7Tl43111uxu1abrk/f4Yq2ogSLgOX2roOAPNz7U/R9P
         luBz7+QVfcnR5/OFk1DPDSVs6Y0Hl2WVTG3Qot2GmexrDh+nE350ZAoV7Oqlzi0g0T9O
         K7TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yj95zSMd/dFzEvBANl5CQ2nulIJOTYnoNXUK/SwkuLw=;
        b=HYBKk3CatGh8IFYdrNMxErcup8o6+khq4lLODbxeumtjO82lw2j6Xv1+1V7Ka/AtNu
         svgYaujQNQvREKIInVD+V9V9wR6iLsIPsEI0zJ4+H5OSc4oCbDxV/GMs1B91ILBj5nng
         ij58W55e4Ef4Zem9f+Js+SC2LneBl1L3zr5UmGwQ7T0bj/s7ffsLTa2R1yEWufBBAndq
         sz6kxX+ftmRl51HL0OXqLVq2lPbdLWIbS5mxfE4JAPai9hpnQIVPVNTKU6dS64LJsXDo
         V+Q7sUnw8LWuyuC1zp+JnYIskhk5dOhZhS+pvBejJXhQwQ9q1kqTYfW7l4Qq2qIxzkLC
         jUDw==
X-Gm-Message-State: AFqh2kpPfv0Q7BraIknFn18Ks2rOLl9TkzDgHGjxOUfL/TkFeeYCxXQq
	jEi4OhkI2EXGDFMVdOyqfNM=
X-Google-Smtp-Source: AMrXdXt4YJs7IBzCXlfyaG69wyzx6BqNCxCU3/qF6vaEjm3K2gzXk1se84EZBsc90DP9HT40auewDA==
X-Received: by 2002:a05:6870:d98b:b0:15f:a9c:de99 with SMTP id gn11-20020a056870d98b00b0015f0a9cde99mr3074374oab.32.1674005895241;
        Tue, 17 Jan 2023 17:38:15 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y34-20020a05687045a200b00143ae7d4ccesm3770238oao.45.2023.01.17.17.38.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 17:38:14 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 17 Jan 2023 17:38:13 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 000/477] 4.19.270-rc2 review
Message-ID: <20230118013813.GB1727121@roeck-us.net>
References: <20230117124624.496082438@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117124624.496082438@linuxfoundation.org>

On Tue, Jan 17, 2023 at 01:47:51PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.270 release.
> There are 477 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Jan 2023 12:45:11 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 425 pass: 425 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
