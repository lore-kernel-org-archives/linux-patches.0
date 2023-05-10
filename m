Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F97F9D9
	for <patches@lists.linux.dev>; Wed, 10 May 2023 11:58:18 +0000 (UTC)
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1ab032d9266so66807285ad.0
        for <patches@lists.linux.dev>; Wed, 10 May 2023 04:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google; t=1683719898; x=1686311898;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YEjvu86VPeGIfcd6OBm9HJ4PKZg1A/Y6LH8NJqVZG8c=;
        b=ZbAGM2fObdjVBK1J10RtHSe/ix/n1zTYxNYJgd/RAtr2N7aH+2zKW02g7tmRFBiOgc
         5tTsQd0TqpkEmPErxPlk16+4EH5aRi0HOIOJow+Fd28D7ehk0eUVT7f/KKMUzP86dWK/
         SOot1yuKRrBUktim6LY9fQ8hzGr6qAB04dsMw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683719898; x=1686311898;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YEjvu86VPeGIfcd6OBm9HJ4PKZg1A/Y6LH8NJqVZG8c=;
        b=c/kIXPeVw1X76gGrUlrehzoFNhaOTaBISSoNHmVgMgIAVy+8IDHcu1J2TYn+06y7UD
         MjAVk3UwLpXTu+LgJL95nYswSRIRRCiEUaoj+tJ5fBwhGGUiyPfML7BDCR0RYGIpJxN0
         XllnFvMsAoe1Ji87x4AA56DWCIbM/IfXIhSx1GwcCtsVknwmqACPu0VNhWG5s75lZu2L
         TINggxL82aCFpWgLj649FgSmaN2WNsPi4R4ZXOxb4tmxP0N5BoMAn0Ajk5jw1I/rmE4r
         Oz2rEVBRnR+8CfOTKwFOgkePV9aHTpaDyMMeVvPvhxUfS5W4VHhkH6ixsn6dkjz/+6c6
         NDUQ==
X-Gm-Message-State: AC+VfDxnqR0J74F/rzRKDMScCR9m9BsDr5kWyB1PmmvHW0DlW4v08iSK
	b2AVjo7u1cdBIl6SMFHb0kpzblyH8455spzmCQuX3A==
X-Google-Smtp-Source: ACHHUZ4EzpDvqdANutq6jWg36ktzU9BJBGxSvmCy60I6ujWewzPWfKsIh2WnBGcBv4iDfADN/VCRmrS5OeH5QSllRVQ=
X-Received: by 2002:a17:902:7b87:b0:1aa:da53:dd9b with SMTP id
 w7-20020a1709027b8700b001aada53dd9bmr17018316pll.28.1683719897795; Wed, 10
 May 2023 04:58:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230509030705.399628514@linuxfoundation.org> <20230509080658.GA152864@d6921c044a31>
 <20230509131032.GA8@9ed91d9f7b3c> <2023050913-spearhead-angrily-fc58@gregkh>
 <20230509145806.GA8@df3c0d7ae0b0> <2023051025-plug-willow-e278@gregkh>
 <CAG9oJsnr55Atybm4nOQAFjXQ_TeqVG+Nz_8zqMT3ansdnEpGBQ@mail.gmail.com> <2023051048-plus-mountable-6280@gregkh>
In-Reply-To: <2023051048-plus-mountable-6280@gregkh>
From: Rudi Heitbaum <rudi@heitbaum.com>
Date: Wed, 10 May 2023 21:58:06 +1000
Message-ID: <CAG9oJskrJotpyqwi6AHVMmhnFmL+Ym=xAFmL51RiZFaU78wv-A@mail.gmail.com>
Subject: Re: [PATCH 6.3 000/694] 6.3.2-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, ntfs3@lists.linux.dev, 
	almaz.alexandrovich@paragon-software.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 10 May 2023 at 19:09, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, May 10, 2023 at 06:29:23PM +1000, Rudi Heitbaum wrote:
> > On Wed, 10 May 2023 at 17:25, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Tue, May 09, 2023 at 02:58:06PM +0000, Rudi Heitbaum wrote:
> > > > On Tue, May 09, 2023 at 03:56:42PM +0200, Greg Kroah-Hartman wrote:
> > > > > On Tue, May 09, 2023 at 01:10:32PM +0000, Rudi Heitbaum wrote:
> > > > > > On Tue, May 09, 2023 at 08:06:58AM +0000, Rudi Heitbaum wrote:
> > > > > > > On Tue, May 09, 2023 at 05:26:44AM +0200, Greg Kroah-Hartman wrote:
> > > > > > > > This is the start of the stable review cycle for the 6.3.2 release.
> > > > > > > > There are 694 patches in this series, all will be posted as a response
> > > > > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > > > > let me know.
> > > > > > > >
> > > > > > > > Responses should be made by Thu, 11 May 2023 03:05:05 +0000.
> > > > > > > > Anything received after that time might be too late.
> > > > > > >
> > > > > > > Hi Greg,
> > > > > > >
> > > > > > > 6.3.2-rc2 tested.
> > > > > >
> > > > > > Hi Greg,
> > > > > >
> > > > > > Further testing and have seen ntfs3: NULL pointer dereference with ntfs_lookup errors
> > > > > > with 6.3.2-rc2 (I have not seen this error before.) No other errors in the logs.
> > > > >
> > > > > Can you reproduce this without the extern, gpl-violation module loaded?
> > > > >
> > > > > thanks,
> > > > >
> > > > > greg k-h
> > > >
> > > > Hi Greg,
> > > >
> > > > I dropped the bcm_sta and recompiled and commented out the i915.guc=3
> > > > and was able to reproduce.
> > > >
> > > > [   84.745080] BUG: kernel NULL pointer dereference, address: 0000000000000020
> > > > [   84.746239] #PF: supervisor read access in kernel mode
> > > > [   84.747599] #PF: error_code(0x0000) - not-present page
> > > > [   84.748929] PGD 0 P4D 0
> > > > [   84.750240] Oops: 0000 [#1] SMP NOPTI
> > > > [   84.751575] CPU: 2 PID: 3176 Comm: .NET ThreadPool Not tainted 6.3.2-rc2 #1
> > > > [   84.752998] Hardware name: Intel(R) Client Systems NUC12WSKi7/NUC12WSBi7, BIOS WSADL357.0085.2022.0718.1739 07/18/2022
> > > > [   84.754474] RIP: 0010:ntfs_lookup+0x76/0xe0 [ntfs3]
> > >
> > > And do you get this same crash on ntfs3 on 6.4-rc1?  Is this a new
> > > regression, or does it also show up on 6.3.1?
> >
> > Tested with 6.3.1 during the day today. No errors, and had been
> > running 6.3.1 with no issue. Retested with 6.3.2-rc2 and problem
> > immediately evident. So yes - I believe a regression.
> >
> > I have built and am now testing 6.4.0-rc1 this evening - no errors so far.
> >
> > [    0.000000] Linux version 6.4.0-rc1 (docker@1ccd349e2545)
> > (x86_64-libreelec-linux-gnu-gcc-13.1.0 (GCC) 13.1.0, GNU ld (GNU
> > Binutils) 2.40) #1 SMP Wed May 10 07:51:37 UTC 2023
> >
> > > And ntfs, ick, why?  And .NET?  What a combination...
> >
> > Joys of media players. Test device gets to test exfat, ntfs3, .NET,
> > and throw in a compile host/GHA runner to put it through paces.
>
> Yeah, this should work.  Thanks for verifying this works on other
> releases.  Any chance you can do 'git bisect' to track down the
> offending commit?  In looking things over, I don't see anything
> obvious...

Hi Greg,

I can confirm the offending commit in 6.3.2-rc2 is

bf11fd528a97 fs/ntfs3: Fix null-ptr-deref on inode->i_op in ntfs_lookup()

Regards
Rudi

> thanks,
>
> greg k-h
