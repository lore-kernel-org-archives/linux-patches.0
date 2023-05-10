Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B9F814
	for <patches@lists.linux.dev>; Wed, 10 May 2023 06:53:49 +0000 (UTC)
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-643990c5319so4832798b3a.2
        for <patches@lists.linux.dev>; Tue, 09 May 2023 23:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google; t=1683701629; x=1686293629;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9ARlpM+pAsr8BGSZNletFEdMQRPC07jRQRvs7jrtEQg=;
        b=Ba6Qxb6tPiVzsdverLvJeaA6NMNs1ESe2582fx4Ch2x9nGbxGoede5BMdVMhrMkMXG
         aQp2cdPrwDF+HEclzi3fHCh2YX612MHaOqfL2bgAKvp0V3reXphaf7Ar9w8jPv6aeEQB
         Pf30hlSXS0yL7rqaXpmkiJ5OkARMDSPDV/p+0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683701629; x=1686293629;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9ARlpM+pAsr8BGSZNletFEdMQRPC07jRQRvs7jrtEQg=;
        b=kbA4BcxJ9jnP3TDVn6fgpvzVX1O3aIxq52gF5dRlko0IN1sfkwAEn0Smt2uX9uKl16
         6quGeeELZWFMKhmtgl91Upy+9WcroqwK0BvsrwIT/XRRr5YotX2S7aQWvZY9KM0l1Exn
         toYCXU6x6yUs0X0lHa4VOhxTRCOg7AboAiq+PeWTNqgHooDAo1rLe2Hx9GUbV76I1ym3
         3Fq3DdJk9A3cGBorgaTNPuxjSS1x5L0dSdbCdJ/vlAycfYWSUvBoLofrSgwj9N0nR2lx
         3uBPbz5GDUq23l1inEqZQb4iB0lXbqObAbFYsQF2yXViX4IP7ourYytpA18rtZTHTAkj
         fDNw==
X-Gm-Message-State: AC+VfDzVxSpzrfiTNcBQynxbCpufAq49WQ1GwJk4K9l3eS0JhCRtPent
	ORQ+0RAbfrXnXDL9oMf+lECruGx03XR/nUsU25RwuQ==
X-Google-Smtp-Source: ACHHUZ5cDWPb1mJZ0ZYYOzrCTrAw5KODsZQvrHxo2j5ECdRSUuDCYP5w1GI6SDTCL5wXkAlKoem2FIwX4BIuiyjMU8U=
X-Received: by 2002:a05:6a21:3391:b0:101:5f33:94ad with SMTP id
 yy17-20020a056a21339100b001015f3394admr5767688pzb.52.1683701628619; Tue, 09
 May 2023 23:53:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230509030705.399628514@linuxfoundation.org> <20230509080658.GA152864@d6921c044a31>
 <20230509131032.GA8@9ed91d9f7b3c> <2023050913-spearhead-angrily-fc58@gregkh>
 <20230509145806.GA8@df3c0d7ae0b0> <CA+G9fYuCLSuPchYoSfqnu6y+CUV+Km3TVFr1NhGj0dik-ScEdQ@mail.gmail.com>
In-Reply-To: <CA+G9fYuCLSuPchYoSfqnu6y+CUV+Km3TVFr1NhGj0dik-ScEdQ@mail.gmail.com>
From: Rudi Heitbaum <rudi@heitbaum.com>
Date: Wed, 10 May 2023 16:53:36 +1000
Message-ID: <CAG9oJsnsSdkj=rEVSmuSa2U4GfLqPhtgWm=a_71d7orZ=r4CJg@mail.gmail.com>
Subject: Re: [PATCH 6.3 000/694] 6.3.2-rc2 review
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	ntfs3@lists.linux.dev, almaz.alexandrovich@paragon-software.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 10 May 2023 at 05:30, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> On Tue, 9 May 2023 at 20:28, Rudi Heitbaum <rudi@heitbaum.com> wrote:
> >
> > On Tue, May 09, 2023 at 03:56:42PM +0200, Greg Kroah-Hartman wrote:
> > > On Tue, May 09, 2023 at 01:10:32PM +0000, Rudi Heitbaum wrote:
> > > > On Tue, May 09, 2023 at 08:06:58AM +0000, Rudi Heitbaum wrote:
> > > > > On Tue, May 09, 2023 at 05:26:44AM +0200, Greg Kroah-Hartman wrote:
> > > > > > This is the start of the stable review cycle for the 6.3.2 release.
> > > > > > There are 694 patches in this series, all will be posted as a response
> > > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > > let me know.
> > > > > >
> > > > > > Responses should be made by Thu, 11 May 2023 03:05:05 +0000.
> > > > > > Anything received after that time might be too late.
> > > > >
> > > > > Hi Greg,
> > > > >
> > > > > 6.3.2-rc2 tested.
> > > >
> > > > Hi Greg,
> > > >
> > > > Further testing and have seen ntfs3: NULL pointer dereference with ntfs_lookup errors
> > > > with 6.3.2-rc2 (I have not seen this error before.) No other errors in the logs.
> > >
> > > Can you reproduce this without the extern, gpl-violation module loaded?
>
> Please share the steps to reproduce
>  test case / Kconfigs / device under test environment / firmware / boot loaders.

Hi Naresh,

Test case:
- general use - no specific case

Test device:
LibreELEC with docker used as media player with docker for development
/ package testing for LibreELEC
[    0.000000] microcode: updated early: 0x421 -> 0x429, date = 2023-01-11
[    0.000000] DMI: Intel(R) Client Systems NUC12WSKi7/NUC12WSBi7,
BIOS WSADL357.0085.2022.0718.1739 07/18/2022

ntfs3 volume is:
/dev/sdb2 on /var/media/L-Z type ntfs3
(rw,relatime,uid=0,gid=0,fmask=0133,iocharset=utf8)

                 *-usb:1
                      description: Mass storage device
                      product: USB to ATA/ATAPI Bridge
                      vendor: JMicron
                      physical id: 2
                      bus info: usb@4:2.2
                      logical name: scsi1
                      version: 5.08
                      serial:
                      capabilities: usb-3.00 scsi
                      configuration: driver=uas maxpower=896mA speed=5000Mbit/s
                    *-disk
                         description: SCSI Disk
                         product: Generic
                         vendor: JMicron
                         physical id: 0.0.0
                         bus info: scsi@1:0.0.0
                         logical name: /dev/sdb
                         version: 0508
                         serial:
                         size: 10TiB (12TB)
                         capabilities: gpt-1.00 partitioned partitioned:gpt
                         configuration: ansiversion=6
guid=7fe84503-eeb0-4ee6-806d-9cbe22dc50f2 logicalsectorsize=512
sectorsize=4096
                       *-volume:0
                            description: reserved partition
                            vendor: Windows
                            physical id: 1
                            bus info: scsi@1:0.0.0,1
                            logical name: /dev/sdb1
                            serial:
                            capacity: 15MiB
                            capabilities: nofs
                            configuration: name=Microsoft reserved partition
                       *-volume:1
                            description: Windows NTFS volume
                            vendor: Windows
                            physical id: 2
                            bus info: scsi@1:0.0.0,2
                            logical name: /dev/sdb2
                            logical name: /var/media/L-Z
                            version: 3.1
                            serial:
                            size: 935GiB
                            capacity: 10TiB
                            capabilities: ntfs initialized
                            configuration: clustersize=4096
created=2022-10-01 10:18:29 filesystem=ntfs label=L-Z
mount.fstype=ntfs3
mount.options=rw,relatime,uid=0,gid=0,fmask=0133,iocharset=utf8
name=Basic data partition state=mounted

Operating system:
- LibreELEC - https://libreelec.tv/ (master+ branch)

Boot loader:
- syslinux

Kconfig:
- https://github.com/LibreELEC/LibreELEC.tv/blob/master/projects/Generic/linux/linux.x86_64.conf

> - Naresh
