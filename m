Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E07515CA
	for <patches@lists.linux.dev>; Fri, 27 Jan 2023 16:54:38 +0000 (UTC)
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-15eec491b40so7180434fac.12
        for <patches@lists.linux.dev>; Fri, 27 Jan 2023 08:54:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AKfy4Zb92p4ujrI1Uo6sjErmbYq3MKPY1OiO3UmQ6Ek=;
        b=FB1DAwfu6rLlMeTEKpjv2E3dXr71osBms5COqFglrcTbeJScC0WUWpdCwAKBmoVoi9
         dVPli64tgWV2Vxnrm1fGDjPE4aitqZuMpHk+3SS/XrncbQEqbCfDDfSV8CObNNmidE5u
         37f3SXEMpA3eT4mRkP8HBjZmvcdLsFTKSSb6Y504p9HeKxfUJZm2VuDKNH1n+D3bY03/
         HkSdbee+0EasDd0sFPUZ9reHn9H7nz893lj4a20odx+v8uy4Q+QvlAksgke/hky+v6Fj
         SASGNzNBD66/fX/Q0LquVtyVDskxW190JJZgoqJxXKhg37Cr/S0tPsOBLIFVc3V00WYa
         cA4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AKfy4Zb92p4ujrI1Uo6sjErmbYq3MKPY1OiO3UmQ6Ek=;
        b=qwmsN/GmjKCvSY/equz5dS7xqVyWMWOnDJawrJ8tZG9dDBgr+4EVgOY5gyWxW8HHQo
         aGjaD5y9SuBMMeF7H+KtylqLLg5d/YVkosVaTD2zdag6X31ZOFr/Kdpzf5SJB6gka/UK
         caYJye8xFKypvC+g2SAQy6o80n4/Aa0fKXacgmEHaLg75suMHk7gwqoSZpis9mRY8UZV
         3SwBAPO1zAIhYrb4/5RMIAUKDlpP7W3kKG66RWW7trC7u6NUl+tx841Dy+8xSdUgBp69
         V3UZuJnm8bbi5D+a0yBj70QI6/ncuHUS8DT/SePDsj6Z+kriyevNdk0vluNwgZeJdc5V
         rqqw==
X-Gm-Message-State: AFqh2krDcFa6v5SeFB2gXgNRmzfL6urSjp1EahMu22sAEy6BSB9njhhf
	AUNBX45kIvPDz88RVnUmF4E=
X-Google-Smtp-Source: AMrXdXuopfL1mgXnujtk5CYG2EnTl+QLAfpTQB4oPXBtlqTlN/VaST/HHopMmyj57+HZNrKhTrrsSg==
X-Received: by 2002:a05:6870:4151:b0:15e:cd63:b7b6 with SMTP id r17-20020a056870415100b0015ecd63b7b6mr23335086oad.24.1674838477504;
        Fri, 27 Jan 2023 08:54:37 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e10-20020a056870c34a00b0013b9ee734dcsm2034931oak.35.2023.01.27.08.54.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 08:54:36 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 27 Jan 2023 08:54:34 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/37] 4.19.271-rc1 review
Message-ID: <20230127165434.GA3962737@roeck-us.net>
References: <20230122150219.557984692@linuxfoundation.org>
 <20230124024734.GB1495310@roeck-us.net>
 <Y9JBAPjj1+aj++Ro@kroah.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y9JBAPjj1+aj++Ro@kroah.com>

On Thu, Jan 26, 2023 at 09:59:44AM +0100, Greg Kroah-Hartman wrote:
> On Mon, Jan 23, 2023 at 06:47:34PM -0800, Guenter Roeck wrote:
> > On Sun, Jan 22, 2023 at 04:03:57PM +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 4.19.271 release.
> > > There are 37 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Tue, 24 Jan 2023 15:02:08 +0000.
> > > Anything received after that time might be too late.
> > > 
> > 
> > Build results:
> > 	total: 155 pass: 154 fail: 1
> > Failed builds:
> > 	i386:tools/perf
> > Qemu test results:
> > 	total: 426 pass: 426 fail: 0
> > 
> > perf build failure:
> > 
> > util/env.c: In function ‘perf_env__arch’:
> > cc1: error: function may return address of local variable [-Werror=return-local-addr]
> > util/env.c:166:17: note: declared here
> >   166 |  struct utsname uts;
> >       |                 ^~~
> > 
> > No one to blame but me, for switching the gcc version used to build perf
> > to gcc 10.3.0 (from 9.4.0). The problem is fixed in the upstream kernel
> > with commit ebcb9464a2ae3 ("perf env: Do not return pointers to local
> > variables"). This patch applies to v5.4.y and earlier kernels.
> 
> It's already in the 5.4.y tree (in release 5.4.56), and it applies to
> 4.19.y so I'll add it there, but it does not apply to 4.14.y so I would
> need a working backport for that tree if you want it there.

Turns out it won't help. It just uncovers other build failures with gcc-10
on v4.19.y, and it looks like the problem was actually introduced between
v4.14 and v4.19.

I reverted to building perf with gcc-9.

Guenter
