Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A17314A81
	for <patches@lists.linux.dev>; Wed, 10 May 2023 19:09:19 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1aafa03f541so74245145ad.0
        for <patches@lists.linux.dev>; Wed, 10 May 2023 12:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683745759; x=1686337759;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gNlkpGUaNqMczv5xZxW+63h+QrX9tPOqLyoTH2dL8ww=;
        b=OLJZdv6AmTISTbWYQwpUZyTXbqtTVJ1iAoDLVSKxVxHnPFITOpxlrD1BCq8k4uEtIm
         RQjkap2JnxktKZtG4g3eE/X45hhFoWMN1MhhmVNn6N9ij9eShf7FbL/rByZgeAil3kIz
         HstPNDCzD3E7YRa9GNYPM5b602h6IDo2pCPBRNjXT611b35ESKsmei9feY82yu3d2gqT
         mGYRKx3e7HhFmsjYyzTFoc+9kXkS+y/dBKCCGj6ADX/8Zf7dkFo/y0iCYnNLzsqMQpqi
         D+KlWrZNwoYhT4ADbI6D3WkRBj0PPoY4wsmQlJ+FQInP9Z1WAAGK4M9tKyw+qBLJ66iZ
         19Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683745759; x=1686337759;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gNlkpGUaNqMczv5xZxW+63h+QrX9tPOqLyoTH2dL8ww=;
        b=Fe2aHOoZt0RvprUNQCSrn+8asmWt6JQvTo9Q8OmnLLQgA0cZNy8/3MxsH17O4T16Es
         tDdIMRgBofcwJ60rElv0uny/r+wiQaqw2cQM8b4c9mrxbZq9uVKnvdYoP4Bos/964GiL
         hPvgxVnzr+VJsTY6I7SXMS8W/H8VTxOHrB/KHuAi91csmrwyTsVA/5uZc4UllFca1b8W
         BxOV+OUaViuCn8VX6Z4SWHHXD94P49Ty2QNQMIhKsZRntgEGXNbM5+9qZqSD5FEYiU5E
         pIN3q9hwFd04QEeXJqIILB0n4GRWuU5l6CGFK/IEgPOXVS+2QNxzQeJqtfGrHg8lOE4O
         zOtQ==
X-Gm-Message-State: AC+VfDw2ISvYomiDJRe2m8y3tw3N8btWW+F1di9nW+F68qJDl60TjZ07
	TFLtiUktDH65hJUWuWcapl8=
X-Google-Smtp-Source: ACHHUZ6zy911nNEAr8uwmueeH7bXhfdjScvRLeumyixtZTCvGmj873SmIL6BncZX/MFFk6be6JhYOg==
X-Received: by 2002:a17:902:c412:b0:1ab:25a6:a54b with SMTP id k18-20020a170902c41200b001ab25a6a54bmr25085985plk.4.1683745758847;
        Wed, 10 May 2023 12:09:18 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j6-20020a170902690600b001a072aedec7sm4154803plk.75.2023.05.10.12.09.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 12:09:18 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 10 May 2023 12:09:16 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/370] 5.15.111-rc2 review
Message-ID: <b92bf726-cf81-4516-95c4-5aa534662224@roeck-us.net>
References: <20230509030611.521807993@linuxfoundation.org>
 <863a112f-f4a4-d580-9687-f6214d555939@linaro.org>
 <2023051035-monitor-sandy-2a5b@gregkh>
 <CAEUSe79AViqsHimbYbFjkKAxcvROGhFKA2yKVuC3aP1Gm=jc1w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEUSe79AViqsHimbYbFjkKAxcvROGhFKA2yKVuC3aP1Gm=jc1w@mail.gmail.com>

On Wed, May 10, 2023 at 09:46:14AM -0600, Daniel Díaz wrote:
> Hello!
> 
> On Wed, 10 May 2023 at 01:43, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Tue, May 09, 2023 at 09:12:33AM -0600, Daniel Díaz wrote:
> > > Hello!
> > >
> > > On 08/05/23 21:26, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 5.15.111 release.
> > > > There are 370 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > >
> > > > Responses should be made by Thu, 11 May 2023 03:05:05 +0000.
> > > > Anything received after that time might be too late.
> > > >
> > > > The whole patch series can be found in one patch at:
> > > >     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.111-rc2.gz
> > > > or in the git tree and branch at:
> > > >     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > > > and the diffstat can be found below.
> > > >
> > > > thanks,
> > > >
> > > > greg k-h
> > >
> > > New warnings are introduced for Arm, PowerPC, RISC-V:
> > >
> > >   /builds/linux/kernel/sched/debug.c: In function 'print_cfs_group_stats':
> > >   /builds/linux/kernel/sched/debug.c:465:41: warning: unused variable 'stats' [-Wunused-variable]
> > >                   struct sched_statistics *stats =  __schedstats_from_se(se);
> > >                                            ^~~~~
> >
> > Odd, and this isn't on other kernels too?
> 
> Only on 5.15, not on the 6.x RC's. I'll share more info after my
> bisection is done.
> 

Upstream has

	struct sched_statistics *stats;
	stats = __schedstats_from_se(se);

which may trick the compiler into believing that 'stats' is used.

Guenter
