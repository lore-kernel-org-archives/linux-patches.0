Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4766A31
	for <patches@lists.linux.dev>; Tue, 24 Jan 2023 02:48:58 +0000 (UTC)
Received: by mail-ot1-f51.google.com with SMTP id d6-20020a056830138600b0068585c52f86so8484186otq.4
        for <patches@lists.linux.dev>; Mon, 23 Jan 2023 18:48:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eRQo6lUgqggMAmuBjwphVAeDFQgoop+xnd6gX5YgB0g=;
        b=KsMHOxWFmIXg19fJUaR0Wpaf4MPv4gCrKseGsMaercTpuYYWSVQ7QN8cKEjsqstShB
         DvIRiDriD/M1GfRkoepJLRg3Zl05daG3Mu06cR2yosa7q1x93svy0rLrjk+vq/E8H+j5
         dpkPU8R+S/1Pc//TiJtEs5iVFOtlahS//xdfhZYJuMds6ODd2yKBla3RaW/3lr404CBT
         sqs+/IgIB9pSl0k3m6iL4afdPJcZDSEn7KR/NHZHawsFRSdTyhULstJKHmPz2Bn0nNIQ
         4q8poFyO91ZaS10bGHovs7NtkORdFVvw9XvR5CrJjgE2/NdR/SDzNSGJvUMC3mgvH7hL
         XnyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eRQo6lUgqggMAmuBjwphVAeDFQgoop+xnd6gX5YgB0g=;
        b=EBfTnP2CHcD/d7BGLsPcGAdP+tIr6s9WM9hGh08em+VYv83kqlXZ9UjNQy9XYSnJs3
         nHGA4UxXA/DqQa+gxz4Dtne0AarwVHWyntzTJhUFDjHkqAWc/KftvmE+956zD0y7M7GV
         4ORr4ZL46KMyzSuuWvorAuqjbhWHJJIDtwVyxJIj/y8U1Ly1lvQmtI96yxt0/zkL99w5
         VCjCYWOinu5AYWVX8lXF6QkX4Uv8cuoi90CjO+U35oDVxazMJFK6S+nfcJzHYvNOR6Xw
         rJe1+JTuN/+FPaJg4W3YHpNqFR+VqKIKK4IltA74oOIkPWnIYWu+Qlkxfmc+hJYCjQFU
         d1zw==
X-Gm-Message-State: AFqh2kqA1rl/Ye8tphM1POGQVscRkDJZou8YbgAjp+E/IGVMG0grdVDc
	Nj795aT5jC0n8YlLLsyxRAs=
X-Google-Smtp-Source: AMrXdXuquNpVCNlEsf9HCeKHPrxp1wH0mLBCrLb5zhVQPP5H/dzmr8NPCXaYKSS1BAefXeyAVyQpDQ==
X-Received: by 2002:a05:6830:142:b0:686:41a0:479 with SMTP id j2-20020a056830014200b0068641a00479mr13511000otp.3.1674528537641;
        Mon, 23 Jan 2023 18:48:57 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a2-20020a056830100200b0066ca61230casm436139otp.8.2023.01.23.18.48.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 18:48:57 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 23 Jan 2023 18:48:56 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/98] 5.10.165-rc2 review
Message-ID: <20230124024856.GD1495310@roeck-us.net>
References: <20230123094914.748265495@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230123094914.748265495@linuxfoundation.org>

On Mon, Jan 23, 2023 at 10:52:37AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.165 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Jan 2023 09:48:53 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 477 pass: 477 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
