Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360551107
	for <patches@lists.linux.dev>; Fri,  3 Mar 2023 01:31:04 +0000 (UTC)
Received: by mail-io1-f52.google.com with SMTP id e11so410602ioe.3
        for <patches@lists.linux.dev>; Thu, 02 Mar 2023 17:31:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677807063;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MzspCeKzatS2dHlJS5xRfrp0ZIPDqDnXUo+766wH1rE=;
        b=XT9w7CcZfVj9rg7ZLOcQvEjGva+TrPPYpJpX/2m8Zl8Y92EVMumVKXW7RC00gX5hFl
         WYaH+ttWrcDq5gwRho6aNBYLJhUmS/cNYipiOj1kAtu64ygpf/bCleAH37o+fvBVZUc3
         06E7IrK/zOcWJ2qU/t2PnGxuZsBJGO/N9N5t1Jg6qyVqfpm0PFErecdMezoYcnDC0G1o
         wsrAMaS0RH4qYFfmWu723yW+ubGp+kNL6XUv01s23xqGMUfhgjrTPtfBCZ6Xc0ujwwnK
         0DBFlyYCo6yQDwaEdfcf/y9ZuNHDZPD+OPap7Bzxxxh1UUjJ8V/vRxXHmIqPRjkFFUEd
         MBGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677807063;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MzspCeKzatS2dHlJS5xRfrp0ZIPDqDnXUo+766wH1rE=;
        b=wKFYf650ARWnMtIK0K4vkJyDjcLeJvnUl2cQ4BlDC1dgeoFQ2x5ewyL1BaWWg05NkZ
         FMS8fk9L63khKlyie28DGV5i0iHLZcrynsIU/0KkSVyV2m3Jokoiof5cS+e5bPTXAy7T
         VD1+z35SyYrcoApJpeGFJzEWIJ9Se2velF6y1E+0H6h0x68tzRwijONoop0991i1d2mR
         c2m0UPM4OGd8huDsM0YoAHYtFlrsIKUdNYOTEhZH3d6RRxUWwk+fCZ4l98+CVGnTT3Sr
         GKT40P0x8i6/hBiozh/iKjozQe4xAbG6vR/KvZJ7g9C0xkGWff/68KE7SbVtmd9ZtM6o
         b1DQ==
X-Gm-Message-State: AO0yUKUoP+5gyNQlx66xr9MVpv8iaDT2uC484b/4gN26L8XmrGIOC5SJ
	hFt5mFf+x8cTzwgjm6Y15pA=
X-Google-Smtp-Source: AK7set+9h3VwScmqEgiAbGgNbIv534jlg8DPGcX8occWqWb75za9S8xYv/exhE9KTWugE3Z1RXcsDA==
X-Received: by 2002:a6b:ee14:0:b0:74c:91c2:cb05 with SMTP id i20-20020a6bee14000000b0074c91c2cb05mr7573825ioh.9.1677807063309;
        Thu, 02 Mar 2023 17:31:03 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s4-20020a5d9a04000000b0074578972b86sm296978iol.30.2023.03.02.17.31.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 17:31:02 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 2 Mar 2023 17:31:01 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/42] 6.1.15-rc1 review
Message-ID: <ae047122-bc72-491c-bbef-089e0d70ab10@roeck-us.net>
References: <20230301180657.003689969@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>

On Wed, Mar 01, 2023 at 07:08:21PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.15 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 503 pass: 503 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
