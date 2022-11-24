Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE677E
	for <patches@lists.linux.dev>; Thu, 24 Nov 2022 02:36:22 +0000 (UTC)
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-14263779059so613942fac.1
        for <patches@lists.linux.dev>; Wed, 23 Nov 2022 18:36:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lKu6dFZkege7gh2XFt/Jc2wITLyP+TssjbYd/0rYDtA=;
        b=IugpXe4bF5HBztBSSTS9Bdc9NxzYLyWj1yftjniondPennQgrpCb3uHUwTUh602yEN
         4ngb/F7oVyfDPVTLsJ0WoH5Kl7AqcYpevOveGts9KHQlsTWieg/jjZC6PlBIJQVSh56A
         XgFe020xmpqkQF2/J0IG5cuvwZTRyIaCmsMWolUr1ngDGYPqJj5sUI/TW95Y4idDu+iX
         RgxiC6RwEHm3mWhV1CSasFoDKI/xnnOnQbJwOnTBY++QQ1wY2jjvkYdaA1vVHXGQOWOp
         BGkKVssQd5gO0SPq0qpiBjZGnZaYiCvoMhBqkZEzLRBTqNg89GjBtY9VPPagt5x9m0Bg
         lF9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lKu6dFZkege7gh2XFt/Jc2wITLyP+TssjbYd/0rYDtA=;
        b=f0sNmwf+rxT42NBgIgtxG5lm0nYXfPUKReGfnTlf8QY/n+gsR2q8DKDtvCt38jlZ6/
         ZU+DBXbVTBsr6ErbVmk8tcopLGwykWBSmBN4g3eXSRH42QrI3ZtjzyfKLhQfZgMfErAe
         9PwV2Uia7giwljDHOWM+tkds/lFTiPw9CBnEfm/Nu9pA1IgHv1BshZRNKkvHpMPca+dJ
         5Kwj6y386iUojr8Vidjt9KikucraXy3L0b3ZF90gqbhZuLFnGjQQkCIFaJRK360kx3bU
         UmM4DPbC7k0MURJkvBqYJircKp3t6rn4n8WvLl3V3NbathdTOpjwE/p6TN12NP+DpoH5
         rBjw==
X-Gm-Message-State: ANoB5pkYOxFGb6vAaPwVPhNin7+IWJoQBMkhkS0z6RaT2XJCux+IJdm0
	1w7F+jXjxIzOuSop1NtCARY=
X-Google-Smtp-Source: AA0mqf5B6Zjb/dYephIVdV9c5Iu6/OprCrRtwGjwTifMcC3Hp9MroBuNRg+lVMsfU37yezcroHkhlA==
X-Received: by 2002:a05:6870:c895:b0:13a:dd7e:7bda with SMTP id er21-20020a056870c89500b0013add7e7bdamr20135013oab.222.1669257381679;
        Wed, 23 Nov 2022 18:36:21 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h16-20020a056870171000b0012c21a64a76sm5950oae.24.2022.11.23.18.36.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 18:36:21 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 23 Nov 2022 18:36:20 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 000/114] 4.19.267-rc1 review
Message-ID: <20221124023620.GC2576375@roeck-us.net>
References: <20221123084551.864610302@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123084551.864610302@linuxfoundation.org>

On Wed, Nov 23, 2022 at 09:49:47AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.267 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 423 pass: 423 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
