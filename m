Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F28C23A6
	for <patches@lists.linux.dev>; Fri, 25 Nov 2022 08:05:21 +0000 (UTC)
Received: by mail-yb1-f178.google.com with SMTP id d128so4197674ybf.10
        for <patches@lists.linux.dev>; Fri, 25 Nov 2022 00:05:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pnfIVSOrUJ3z+ilEDdymU1GO/STI0zxzNjpepGL0pvY=;
        b=G9i0Y5NM3kY1yH6UILP1oYSOnKsIaZHoPRSN+B+o+PeOJWJv9HW74WfuUmfYFlaWX2
         xb4e2tijSPZAn9AVQM3oEXa3TxO1DmGbTZa/Wu/Fq7MNy0R4vnfMKe1cve+r39I20f2R
         BHmD1RbmEmcjRjWfAesitbIMwc+688tJMaHSaD37b8/dVQjQ3CPednoutLFpO60KiGGW
         R/G7dPdqtKzyEkweEmE5c0J2Wepl43/Rfm2OdCAlLFBsd87DlPXeEN+MCSt2ugSKqcBR
         aFUhn7WXyVcR8DOZ4Jo4fQie+TMU/nrBwNGafmFCdxu2tz/FmhUsAtw3lGmyjPL2s6E1
         Hj6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pnfIVSOrUJ3z+ilEDdymU1GO/STI0zxzNjpepGL0pvY=;
        b=KmH5I0Hs17mi8Kf50KcytSHK+TSxWr0D68HvPARxazP+QDGcV7UxPa/VWKtLAcD0OA
         01q3koak+wXiAiCrubNnuO2KNzt+aEgDHRdcWLCdA6Y+vaCm3QE4QikT89PWQOwjl9Ae
         O4eHiAmxk01m9OTFJfHwja/1Msei6/+gjKFb8YEV4vcKWUGxwiO3NFpKTfCs1EU1F8yM
         fBkk7WLPMkIDtubiTpsEoskOkTfBzcxiyQqXXQ8mrGjVpueZd+KMElQYfDICmHQv7wPf
         cBH9VBEyCJiIL33qJQo/w/zhlar0Oio2FX/ZObmiBiTJp8dTPXpbl0SVmmQS/uB0Hr7A
         zfog==
X-Gm-Message-State: ANoB5pncyLhdmATvHDPkuAg2BlY8/PFdMtmBFt96YYfZAzlEtPhtmGTV
	X910WjvXqHkT3drsabo5QCdoz3Plk6+M6OTI/VMNeA==
X-Google-Smtp-Source: AA0mqf7OgJkiz3KAGFtHjIaNXzXenKiC0lfUTs2VaZpT60Y42LyT6mHG+ZY7pBZ6ToQai8QeKtDh5776ncDGQd5pifM=
X-Received: by 2002:a25:9d8f:0:b0:6d0:155f:aa9e with SMTP id
 v15-20020a259d8f000000b006d0155faa9emr15327691ybp.448.1669363519825; Fri, 25
 Nov 2022 00:05:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221123084557.945845710@linuxfoundation.org> <CA+G9fYvKfbJHcMZtybf_0Ru3+6fKPg9HwWTOhdCLrOBXMaeG1A@mail.gmail.com>
 <CA+G9fYvgaNKbr_EhWsh9hjnzCeVXGJoXX4to72ytdvZi8W0svA@mail.gmail.com> <Y4BuUU5yMI6PqCbb@kroah.com>
In-Reply-To: <Y4BuUU5yMI6PqCbb@kroah.com>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 25 Nov 2022 13:35:08 +0530
Message-ID: <CA+G9fYsXomPXcecPDzDydO3=i2qHDM2RTtGxr0p2YOS6=YcWng@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/149] 5.10.156-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, YueHaibing <yuehaibing@huawei.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, Netdev <netdev@vger.kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	=?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 25 Nov 2022 at 12:57, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Nov 24, 2022 at 09:17:36PM +0530, Naresh Kamboju wrote:
> > On Wed, 23 Nov 2022 at 19:30, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> > >
> > > On Wed, 23 Nov 2022 at 14:50, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > This is the start of the stable review cycle for the 5.10.156 release.
> > > > There are 149 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > >
> > > > Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> > > > Anything received after that time might be too late.
> > > >
> > > > The whole patch series can be found in one patch at:
> > > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.156-rc1.gz
> > > > or in the git tree and branch at:
> > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > > > and the diffstat can be found below.
> > > >
> > > > thanks,
> > > >
> > > > greg k-h
> > >
> > >
> > > With stable rc 5.10.156-rc1 Raspberry Pi 4 Model B failed to boot due to
> > > following warnings / errors [1]. The NFS mount failed and failed to boot.
> > >
> > > I have to bisect this problem.
> >
> > Daniel bisected this reported problem and found the first bad commit,
> >
> > YueHaibing <yuehaibing@huawei.com>
> >     net: broadcom: Fix BCMGENET Kconfig
>
> But that is in 5.10.155, 5.15.79, 6.0.9, and 6.1-rc5.  It is not new to
> this -rc release.

It started from 5.10.155 and this is only seen on 5.10 and other
branches 5.15, 6.0 and mainline are looking good.

>
> What config options are being set because of this that cause the
> problem?

LKFT is built with arm64 defconfig + distro configs as described below.

>   Should it just be reverted for 5.10.y, and not the other
> branches?  Or for everywhere including Linus's tree?

Reverting for 5.10 works for Rpi-4 to boot.

Due to the problematic commit
      # CONFIG_BROADCOM_PHY is not set
and Raspberry Pi 4 boot failed only on 5.10.155 and later.

--

diff -Narub good-config bad-config
--- good-config 2022-11-09 14:19:58.000000000 +0530
+++ bad-config 2022-11-16 15:50:36.000000000 +0530
@@ -1,6 +1,6 @@
 #
 # Automatically generated file; DO NOT EDIT.
-# Linux/arm64 5.10.154-rc2 Kernel Configuration
+# Linux/arm64 5.10.155 Kernel Configuration
 #
 CONFIG_CC_VERSION_TEXT="aarch64-linux-gnu-gcc (Debian 11.3.0-6) 11.3.0"
 CONFIG_CC_IS_GCC=y
@@ -2611,7 +2611,7 @@
 # CONFIG_ADIN_PHY is not set
 CONFIG_AQUANTIA_PHY=y
 # CONFIG_AX88796B_PHY is not set
-CONFIG_BROADCOM_PHY=y
+# CONFIG_BROADCOM_PHY is not set
 # CONFIG_BCM54140_PHY is not set
 CONFIG_BCM7XXX_PHY=y
 # CONFIG_BCM84881_PHY is not set

---

# To install tuxmake on your system globally:
# sudo pip3 install -U tuxmake
#
# See https://docs.tuxmake.org/ for complete documentation.
# Original tuxmake command with fragments listed below.
# tuxmake --runtime podman --target-arch arm64 --toolchain gcc-11
--kconfig defconfig --kconfig-add
https://raw.githubusercontent.com/Linaro/meta-lkft/kirkstone/meta/recipes-kernel/linux/files/lkft.config
--kconfig-add https://raw.githubusercontent.com/Linaro/meta-lkft/kirkstone/meta/recipes-kernel/linux/files/lkft-crypto.config
--kconfig-add https://raw.githubusercontent.com/Linaro/meta-lkft/kirkstone/meta/recipes-kernel/linux/files/distro-overrides.config
--kconfig-add https://raw.githubusercontent.com/Linaro/meta-lkft/kirkstone/meta/recipes-kernel/linux/files/systemd.config
--kconfig-add https://raw.githubusercontent.com/Linaro/meta-lkft/kirkstone/meta/recipes-kernel/linux/files/virtio.config
--kconfig-add CONFIG_ARM64_MODULE_PLTS=y --kconfig-add
CONFIG_SYN_COOKIES=y --kconfig-add CONFIG_SCHEDSTATS=y
CROSS_COMPILE_COMPAT=arm-linux-gnueabihf-

Bad config link,
https://builds.tuxbuild.com/2HcnnvEDD3gSr1zmS5DHzqPG2cJ/config

>
> thanks,
>
> greg k-h

- Naresh
