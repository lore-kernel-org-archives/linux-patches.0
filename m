Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9181850A4
	for <patches@lists.linux.dev>; Wed,  4 Feb 2026 22:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770243462; cv=none; b=pCw7GLu5EWtwLX1c8N+0bCpeAFtjom7m9GnSwC6SqhwhChX3c3CYzF1V5rcmQ6LkZvrjCUqnPz3Z/cfUDynRgjnByvdJl0Webh1avRj2aJ9+1voxDMHZ4xGBY9CePkNLb1QJVR8ZnfB/n7XyPN/B+bOYuBeFwVQa/VVmIwyTWIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770243462; c=relaxed/simple;
	bh=LwRgORfTdp1rfDO5Rs44wUevT0v1b5ixr92+tbSGu7E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jOeAdOve1DNmD4uC0TYGH4GwiMK4MX3ENoKEhhnkx8dyA86oB8fjPksnXE2emeh4mZIcFmSqA0EXbOTV+ELF9lunmdoOVqKoR7JDit+LlXOvGgFJLs9MXtBG/OcfgXUMmVCS7fft19NLIIHm9MCfoxPJUfHVmC37rZt+MKNRxa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=VaxUyHmp; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="VaxUyHmp"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-42fbc305914so324259f8f.0
        for <patches@lists.linux.dev>; Wed, 04 Feb 2026 14:17:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1770243460; x=1770848260; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FdmnEHLUkOwdTeKQiBTTTy4aoO1XnQ2/LFeT+WVMkVc=;
        b=VaxUyHmpl/mFqZYlZcD/gKZAj8fstCbbu0mNiljcTYxFPdSi+VgEcHLeoE3PnrjLuG
         5aCNVi/bu704EJ9ukcn2kec5h0SyBwqFpn01j/DZguBMfloztSMmueTM0im0QXT2IBJG
         lUxdRpnaUPUmtt54pBty7vvpEWciVbv0/iVOYlY7FJ562XYLsJ8i+4KdN+QA37HDIuDU
         t9dkmp0rC28Q2zQpx/60P+j4Jnfe+Ca72iP4eZ22ZtPCU8w/np5bunTLADE2qzavOVDp
         20U0ASV3uD4uGGG5YaKHlqeEXfg2qUvIHZo7GzKOvaMAbSovc9uRXPSDlieOrNRCm6q+
         Z9ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770243460; x=1770848260;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FdmnEHLUkOwdTeKQiBTTTy4aoO1XnQ2/LFeT+WVMkVc=;
        b=eZdejhIJSBxC4g4ygIRqJTBDJe5xzyzc6gGdffLDkp4B8PGXNmXKIaYrgV/axDWMIa
         x54VNptPkQzypR+u7YoGZn1+OqxFh5hbXeL4yz61JxgwtOWzkCBW3s3cel0i0z3zNtQ2
         TzClcWtZmX8KMBJEK0AR36Hni9BXTq5iuvVScyh4fbKvr3VdrjcmLgsrtlWcpIhxCWgF
         lqS170kXuWCZrGdvueRTCvXWwRqogfTjTjIP/jQFtYSbwK/wk10MXuUiMLbE1imccP36
         hVWBwmqT7geYGLJLu7leyge5dHA+G0AyhfcXEXIatmyb98ACcztPnjUHCFXW3exkmkBe
         jbeA==
X-Gm-Message-State: AOJu0YyBjTaDEnrMky9lsZlQamujGoU7XC0kOv0+6fb+uw3G14HGP8Dn
	Ajx0ML23MruI5FRKxqWWPox9i/FfL1gD1zJFeP8xbf7eMUIXJhkgV8w=
X-Gm-Gg: AZuq6aL1TzgpTwNeiBjRpRf4oAvzdsaBXe521KanOjMQrFVRbZQJEYjKL7+Xp7V2yNo
	09IhGHZQ05mIHfOiHL5g/IuZJ1PcbUSerHteJAnK9DLzdwhysCueaUMz2B/ucG/2aeGwSYb2Xuu
	aFFz12XZRDw+MidUe5kifdZJz2Dh1ZDvsRMGJNCRXmfLPHvQ6msTzCf8sKC5iiSRaFFvp8YxeCc
	NegErhihC7X//EUF/v3xa/yj9OzSbcFpk+sVWsx7TWfVSa29nL6GVdE25SpzEOYs6cfoRVlBsXt
	SXRXOJipNHuuhhYYOsayNASNSmcTJBvKveGYNR/mVNt4khh8dMgLkRG9JvdwNSEuxaj2EL3FKeE
	dQMWOQ8DbHr0/ftV8XFujy9enBu6TN1XVNhgwR+T6Fu7h9HQgyp+zu7zYGxZxiKFTrDGCWNvjUR
	Uu08dR0gX1r/CygrIEzDovasW88EPOx2b4KpAuLgEZ9a5dwFPhdBOqA7xPTBC8KA==
X-Received: by 2002:a05:6000:26c6:b0:435:9ee1:f91a with SMTP id ffacd0b85a97d-436180588camr7043921f8f.53.1770243459796;
        Wed, 04 Feb 2026 14:17:39 -0800 (PST)
Received: from [192.168.1.3] (p5b2b4d5e.dip0.t-ipconnect.de. [91.43.77.94])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-436180588bfsm9435893f8f.26.2026.02.04.14.17.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Feb 2026 14:17:39 -0800 (PST)
Message-ID: <25910fd9-ecc8-4119-9abc-2ab6baf5ce77@googlemail.com>
Date: Wed, 4 Feb 2026 23:17:38 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/280] 6.1.162-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260204143909.614719725@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Greg,

Am 04.02.2026 um 15:36 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.162 release.
> There are 280 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Feb 2026 14:38:23 +0000.
> Anything received after that time might be too late.

It seems that this time, I cannot even build this RC. When I run "make menuconfig" I get a big serious of warning and 
error messages; something seems to be really messed up here...


root@linus:/usr/src/linux-stable-rc# vim .config
root@linus:/usr/src/linux-stable-rc# make menuconfig
scripts/kconfig/Makefile:215: Warnung: Das Musterrezept hat das Peer-Ziel „scripts/kconfig/mconf-bin“ nicht aktualisiert.
   HOSTCC  scripts/kconfig/mconf.o
   HOSTCC  scripts/kconfig/lxdialog/checklist.o
   HOSTCC  scripts/kconfig/lxdialog/inputbox.o
   HOSTCC  scripts/kconfig/lxdialog/menubox.o
   HOSTCC  scripts/kconfig/lxdialog/textbox.o
   HOSTCC  scripts/kconfig/lxdialog/util.o
   HOSTCC  scripts/kconfig/lxdialog/yesno.o
   HOSTLD  scripts/kconfig/mconf
/usr/bin/ld: scripts/kconfig/lxdialog/yesno.o: warning: relocation against `acs_map' in read-only section `.text'
/usr/bin/ld: scripts/kconfig/mconf.o: in function `show_help':
mconf.c:(.text+0xa1b): undefined reference to `stdscr'
/usr/bin/ld: mconf.c:(.text+0xa20): undefined reference to `getmaxx'
/usr/bin/ld: scripts/kconfig/lxdialog/checklist.o: in function `print_arrows':
checklist.c:(.text+0x2c): undefined reference to `wmove'
/usr/bin/ld: checklist.c:(.text+0x43): undefined reference to `wattrset'
/usr/bin/ld: checklist.c:(.text+0x49): undefined reference to `acs_map'
/usr/bin/ld: checklist.c:(.text+0x51): undefined reference to `waddch'
/usr/bin/ld: checklist.c:(.text+0x65): undefined reference to `waddnstr'
/usr/bin/ld: checklist.c:(.text+0x75): undefined reference to `wmove'
/usr/bin/ld: checklist.c:(.text+0x97): undefined reference to `wattrset'
/usr/bin/ld: checklist.c:(.text+0x9d): undefined reference to `acs_map'
/usr/bin/ld: checklist.c:(.text+0xa5): undefined reference to `waddch'
/usr/bin/ld: checklist.c:(.text+0xab): undefined reference to `acs_map'
/usr/bin/ld: checklist.c:(.text+0xb3): undefined reference to `waddch'
/usr/bin/ld: checklist.c:(.text+0xb9): undefined reference to `acs_map'
/usr/bin/ld: checklist.c:(.text+0xc1): undefined reference to `waddch'
/usr/bin/ld: checklist.c:(.text+0xc7): undefined reference to `acs_map'
/usr/bin/ld: checklist.c:(.text+0xf2): undefined reference to `wattrset'
/usr/bin/ld: checklist.c:(.text+0xf8): undefined reference to `acs_map'
/usr/bin/ld: checklist.c:(.text+0x100): undefined reference to `waddch'
/usr/bin/ld: checklist.c:(.text+0x13a): undefined reference to `wattrset'
/usr/bin/ld: checklist.c:(.text+0x140): undefined reference to `acs_map'
/usr/bin/ld: checklist.c:(.text+0x148): undefined reference to `waddch'
/usr/bin/ld: checklist.c:(.text+0x14e): undefined reference to `acs_map'
/usr/bin/ld: checklist.c:(.text+0x156): undefined reference to `waddch'
/usr/bin/ld: checklist.c:(.text+0x15c): undefined reference to `acs_map'
/usr/bin/ld: checklist.c:(.text+0x164): undefined reference to `waddch'
/usr/bin/ld: checklist.c:(.text+0x16a): undefined reference to `acs_map'
/usr/bin/ld: checklist.c:(.text+0x172): undefined reference to `waddch'
/usr/bin/ld: scripts/kconfig/lxdialog/checklist.o: in function `print_item':
checklist.c:(.text+0x1de): undefined reference to `wattrset'
/usr/bin/ld: checklist.c:(.text+0x1eb): undefined reference to `wmove'
/usr/bin/ld: checklist.c:(.text+0x20c): undefined reference to `waddch'
/usr/bin/ld: checklist.c:(.text+0x225): undefined reference to `wmove'
/usr/bin/ld: checklist.c:(.text+0x23c): undefined reference to `wattrset'
/usr/bin/ld: checklist.c:(.text+0x25c): undefined reference to `wattrset'
/usr/bin/ld: checklist.c:(.text+0x26d): undefined reference to `wmove'
/usr/bin/ld: checklist.c:(.text+0x284): undefined reference to `wattrset'
/usr/bin/ld: checklist.c:(.text+0x296): undefined reference to `waddnstr'
/usr/bin/ld: checklist.c:(.text+0x2aa): undefined reference to `wmove'
/usr/bin/ld: checklist.c:(.text+0x2b2): undefined reference to `wrefresh'
/usr/bin/ld: checklist.c:(.text+0x2da): undefined reference to `wattrset'
/usr/bin/ld: checklist.c:(.text+0x2f6): undefined reference to `wattrset'
/usr/bin/ld: checklist.c:(.text+0x307): undefined reference to `wmove'
/usr/bin/ld: checklist.c:(.text+0x31a): undefined reference to `wattrset'
/usr/bin/ld: checklist.c:(.text+0x32c): undefined reference to `waddnstr'
/usr/bin/ld: checklist.c:(.text+0x349): undefined reference to `waddch'
/usr/bin/ld: checklist.c:(.text+0x359): undefined reference to `waddch'
/usr/bin/ld: checklist.c:(.text+0x388): undefined reference to `wprintw'
/usr/bin/ld: checklist.c:(.text+0x3b8): undefined reference to `wprintw'
/usr/bin/ld: checklist.c:(.text+0x3d3): undefined reference to `wprintw'
/usr/bin/ld: checklist.c:(.text+0x3ee): undefined reference to `wprintw'
/usr/bin/ld: scripts/kconfig/lxdialog/checklist.o: in function `print_buttons':
checklist.c:(.text+0x46a): undefined reference to `wmove'
/usr/bin/ld: scripts/kconfig/lxdialog/checklist.o: in function `dialog_checklist':
checklist.c:(.text+0x565): undefined reference to `stdscr'
/usr/bin/ld: checklist.c:(.text+0x56a): undefined reference to `getmaxy'
/usr/bin/ld: checklist.c:(.text+0x57d): undefined reference to `stdscr'
/usr/bin/ld: checklist.c:(.text+0x582): undefined reference to `getmaxx'
/usr/bin/ld: checklist.c:(.text+0x5a7): undefined reference to `stdscr'
/usr/bin/ld: checklist.c:(.text+0x5ac): undefined reference to `getmaxx'
/usr/bin/ld: checklist.c:(.text+0x5b8): undefined reference to `stdscr'
/usr/bin/ld: checklist.c:(.text+0x5d0): undefined reference to `getmaxy'
/usr/bin/ld: checklist.c:(.text+0x5e1): undefined reference to `stdscr'
/usr/bin/ld: checklist.c:(.text+0x60a): undefined reference to `newwin'
/usr/bin/ld: checklist.c:(.text+0x61a): undefined reference to `keypad'
/usr/bin/ld: checklist.c:(.text+0x64b): undefined reference to `wattrset'
/usr/bin/ld: checklist.c:(.text+0x658): undefined reference to `wmove'
/usr/bin/ld: checklist.c:(.text+0x666): undefined reference to `acs_map'
/usr/bin/ld: checklist.c:(.text+0x66e): undefined reference to `waddch'
/usr/bin/ld: checklist.c:(.text+0x682): undefined reference to `acs_map'
/usr/bin/ld: checklist.c:(.text+0x68e): undefined reference to `waddch'
/usr/bin/ld: checklist.c:(.text+0x6a1): undefined reference to `wattrset'
/usr/bin/ld: checklist.c:(.text+0x6a7): undefined reference to `acs_map'
/usr/bin/ld: checklist.c:(.text+0x6af): undefined reference to `waddch'
/usr/bin/ld: checklist.c:(.text+0x6d2): undefined reference to `wattrset'
/usr/bin/ld: checklist.c:(.text+0x717): undefined reference to `subwin'
/usr/bin/ld: checklist.c:(.text+0x729): undefined reference to `keypad'
/usr/bin/ld: checklist.c:(.text+0x8b5): undefined reference to `wnoutrefresh'
/usr/bin/ld: checklist.c:(.text+0x8bf): undefined reference to `wnoutrefresh'
/usr/bin/ld: checklist.c:(.text+0x8c4): undefined reference to `doupdate'
/usr/bin/ld: checklist.c:(.text+0x8e4): undefined reference to `wgetch'
/usr/bin/ld: checklist.c:(.text+0x9f7): undefined reference to `wrefresh'
/usr/bin/ld: checklist.c:(.text+0xa40): undefined reference to `delwin'
/usr/bin/ld: checklist.c:(.text+0xa48): undefined reference to `delwin'
/usr/bin/ld: checklist.c:(.text+0xaa8): undefined reference to `scrollok'
/usr/bin/ld: checklist.c:(.text+0xab5): undefined reference to `wscrl'
/usr/bin/ld: checklist.c:(.text+0xabf): undefined reference to `scrollok'
/usr/bin/ld: checklist.c:(.text+0xb12): undefined reference to `wnoutrefresh'
/usr/bin/ld: checklist.c:(.text+0xb1a): undefined reference to `wrefresh'
/usr/bin/ld: checklist.c:(.text+0xb79): undefined reference to `wnoutrefresh'
/usr/bin/ld: checklist.c:(.text+0xb81): undefined reference to `wrefresh'
/usr/bin/ld: checklist.c:(.text+0xbe2): undefined reference to `scrollok'
/usr/bin/ld: checklist.c:(.text+0xbef): undefined reference to `wscrl'
/usr/bin/ld: checklist.c:(.text+0xbf9): undefined reference to `scrollok'
/usr/bin/ld: checklist.c:(.text+0xc56): undefined reference to `wnoutrefresh'
/usr/bin/ld: checklist.c:(.text+0xc5e): undefined reference to `wrefresh'
/usr/bin/ld: checklist.c:(.text+0xc68): undefined reference to `wgetch'
/usr/bin/ld: checklist.c:(.text+0xcdc): undefined reference to `doupdate'
/usr/bin/ld: checklist.c:(.text+0xcf1): undefined reference to `doupdate'
/usr/bin/ld: checklist.c:(.text+0xd16): undefined reference to `delwin'
/usr/bin/ld: checklist.c:(.text+0xd1e): undefined reference to `delwin'
/usr/bin/ld: checklist.c:(.text+0xdb8): undefined reference to `delwin'
/usr/bin/ld: checklist.c:(.text+0xdc0): undefined reference to `delwin'
/usr/bin/ld: checklist.c:(.text+0xe08): undefined reference to `doupdate'
/usr/bin/ld: scripts/kconfig/lxdialog/checklist.o: in function `print_arrows':
checklist.c:(.text+0xdd): undefined reference to `waddch'
/usr/bin/ld: checklist.c:(.text+0x122): undefined reference to `waddnstr'
/usr/bin/ld: scripts/kconfig/lxdialog/checklist.o: in function `print_buttons':
checklist.c:(.text+0x47c): undefined reference to `wrefresh'
/usr/bin/ld: scripts/kconfig/lxdialog/inputbox.o: in function `print_buttons':
inputbox.c:(.text+0x63): undefined reference to `wmove'
/usr/bin/ld: scripts/kconfig/lxdialog/inputbox.o: in function `dialog_inputbox':
inputbox.c:(.text+0xd6): undefined reference to `stdscr'
/usr/bin/ld: inputbox.c:(.text+0xdb): undefined reference to `getmaxy'
/usr/bin/ld: inputbox.c:(.text+0xee): undefined reference to `stdscr'
/usr/bin/ld: inputbox.c:(.text+0xf3): undefined reference to `getmaxx'
/usr/bin/ld: inputbox.c:(.text+0x106): undefined reference to `stdscr'
/usr/bin/ld: inputbox.c:(.text+0x10b): undefined reference to `getmaxx'
/usr/bin/ld: inputbox.c:(.text+0x112): undefined reference to `stdscr'
/usr/bin/ld: inputbox.c:(.text+0x124): undefined reference to `getmaxy'
/usr/bin/ld: inputbox.c:(.text+0x137): undefined reference to `stdscr'
/usr/bin/ld: inputbox.c:(.text+0x15a): undefined reference to `newwin'
/usr/bin/ld: inputbox.c:(.text+0x16a): undefined reference to `keypad'
/usr/bin/ld: inputbox.c:(.text+0x19c): undefined reference to `wattrset'
/usr/bin/ld: inputbox.c:(.text+0x1ab): undefined reference to `wmove'
/usr/bin/ld: inputbox.c:(.text+0x1ba): undefined reference to `acs_map'
/usr/bin/ld: inputbox.c:(.text+0x1c2): undefined reference to `waddch'
/usr/bin/ld: inputbox.c:(.text+0x1d2): undefined reference to `acs_map'
/usr/bin/ld: inputbox.c:(.text+0x1dd): undefined reference to `waddch'
/usr/bin/ld: inputbox.c:(.text+0x1f3): undefined reference to `wattrset'
/usr/bin/ld: inputbox.c:(.text+0x1f9): undefined reference to `acs_map'
/usr/bin/ld: inputbox.c:(.text+0x201): undefined reference to `waddch'
/usr/bin/ld: inputbox.c:(.text+0x21f): undefined reference to `wattrset'
/usr/bin/ld: inputbox.c:(.text+0x246): undefined reference to `getcury'
/usr/bin/ld: inputbox.c:(.text+0x250): undefined reference to `getcurx'
/usr/bin/ld: inputbox.c:(.text+0x2a6): undefined reference to `wmove'
/usr/bin/ld: inputbox.c:(.text+0x2b4): undefined reference to `wattrset'
/usr/bin/ld: inputbox.c:(.text+0x2e8): undefined reference to `waddnstr'
/usr/bin/ld: inputbox.c:(.text+0x307): undefined reference to `wmove'
/usr/bin/ld: inputbox.c:(.text+0x30f): undefined reference to `wrefresh'
/usr/bin/ld: inputbox.c:(.text+0x31c): undefined reference to `wgetch'
/usr/bin/ld: inputbox.c:(.text+0x382): undefined reference to `wgetch'
/usr/bin/ld: inputbox.c:(.text+0x3ea): undefined reference to `wgetch'
/usr/bin/ld: inputbox.c:(.text+0x41f): undefined reference to `flash'
/usr/bin/ld: inputbox.c:(.text+0x434): undefined reference to `wgetch'
/usr/bin/ld: inputbox.c:(.text+0x487): undefined reference to `wgetch'
/usr/bin/ld: inputbox.c:(.text+0x4da): undefined reference to `delwin'
/usr/bin/ld: inputbox.c:(.text+0x55c): undefined reference to `waddch'
/usr/bin/ld: inputbox.c:(.text+0x5ab): undefined reference to `wgetch'
/usr/bin/ld: inputbox.c:(.text+0x5d5): undefined reference to `delwin'
/usr/bin/ld: inputbox.c:(.text+0x5f4): undefined reference to `delwin'
/usr/bin/ld: inputbox.c:(.text+0x635): undefined reference to `delwin'
/usr/bin/ld: inputbox.c:(.text+0x6c2): undefined reference to `delwin'
/usr/bin/ld: inputbox.c:(.text+0x75a): undefined reference to `wgetch'
/usr/bin/ld: inputbox.c:(.text+0x79f): undefined reference to `wmove'
/usr/bin/ld: inputbox.c:(.text+0x7a7): undefined reference to `wrefresh'
/usr/bin/ld: inputbox.c:(.text+0x7af): undefined reference to `wgetch'
/usr/bin/ld: inputbox.c:(.text+0x7de): undefined reference to `wgetch'
/usr/bin/ld: inputbox.c:(.text+0x7fc): undefined reference to `wgetch'
/usr/bin/ld: inputbox.c:(.text+0x85e): undefined reference to `wmove'
/usr/bin/ld: inputbox.c:(.text+0x879): undefined reference to `wmove'
/usr/bin/ld: inputbox.c:(.text+0x890): undefined reference to `wattrset'
/usr/bin/ld: inputbox.c:(.text+0x8dd): undefined reference to `wmove'
/usr/bin/ld: inputbox.c:(.text+0x918): undefined reference to `waddch'
/usr/bin/ld: inputbox.c:(.text+0x933): undefined reference to `waddch'
/usr/bin/ld: inputbox.c:(.text+0x946): undefined reference to `wmove'
/usr/bin/ld: inputbox.c:(.text+0x94e): undefined reference to `wrefresh'
/usr/bin/ld: inputbox.c:(.text+0x956): undefined reference to `wgetch'
/usr/bin/ld: inputbox.c:(.text+0x9b7): undefined reference to `wmove'
/usr/bin/ld: inputbox.c:(.text+0x9ed): undefined reference to `waddch'
/usr/bin/ld: inputbox.c:(.text+0xa07): undefined reference to `waddch'
/usr/bin/ld: inputbox.c:(.text+0xa18): undefined reference to `wmove'
/usr/bin/ld: inputbox.c:(.text+0xa33): undefined reference to `wattrset'
/usr/bin/ld: inputbox.c:(.text+0xa8b): undefined reference to `wmove'
/usr/bin/ld: inputbox.c:(.text+0xac5): undefined reference to `waddch'
/usr/bin/ld: inputbox.c:(.text+0xae6): undefined reference to `waddch'
/usr/bin/ld: inputbox.c:(.text+0xaf9): undefined reference to `wmove'
/usr/bin/ld: inputbox.c:(.text+0xb01): undefined reference to `wrefresh'
/usr/bin/ld: inputbox.c:(.text+0xb59): undefined reference to `wmove'
/usr/bin/ld: inputbox.c:(.text+0xb93): undefined reference to `waddch'
/usr/bin/ld: inputbox.c:(.text+0xbad): undefined reference to `waddch'
/usr/bin/ld: inputbox.c:(.text+0xbc0): undefined reference to `wmove'
/usr/bin/ld: scripts/kconfig/lxdialog/inputbox.o: in function `print_buttons':
inputbox.c:(.text+0x75): undefined reference to `wrefresh'
/usr/bin/ld: scripts/kconfig/lxdialog/menubox.o: in function `do_print_item':
menubox.c:(.text+0x6d): undefined reference to `wattrset'
/usr/bin/ld: menubox.c:(.text+0x7a): undefined reference to `wmove'
/usr/bin/ld: menubox.c:(.text+0x82): undefined reference to `wclrtoeol'
/usr/bin/ld: menubox.c:(.text+0x9a): undefined reference to `wattrset'
/usr/bin/ld: menubox.c:(.text+0xab): undefined reference to `wmove'
/usr/bin/ld: menubox.c:(.text+0xc0): undefined reference to `waddnstr'
/usr/bin/ld: menubox.c:(.text+0xd8): undefined reference to `wattrset'
/usr/bin/ld: menubox.c:(.text+0xeb): undefined reference to `wmove'
/usr/bin/ld: menubox.c:(.text+0x108): undefined reference to `wmove'
/usr/bin/ld: menubox.c:(.text+0x14a): undefined reference to `wattrset'
/usr/bin/ld: menubox.c:(.text+0x15d): undefined reference to `wmove'
/usr/bin/ld: menubox.c:(.text+0x16f): undefined reference to `waddch'
/usr/bin/ld: menubox.c:(.text+0x181): undefined reference to `waddch'
/usr/bin/ld: scripts/kconfig/lxdialog/menubox.o: in function `print_buttons':
menubox.c:(.text+0x253): undefined reference to `wmove'
/usr/bin/ld: scripts/kconfig/lxdialog/menubox.o: in function `print_arrows.constprop.0':
menubox.c:(.text+0x28d): undefined reference to `getcury'
/usr/bin/ld: menubox.c:(.text+0x299): undefined reference to `getcurx'
/usr/bin/ld: menubox.c:(.text+0x2ac): undefined reference to `wmove'
/usr/bin/ld: menubox.c:(.text+0x2c2): undefined reference to `wattrset'
/usr/bin/ld: menubox.c:(.text+0x2c8): undefined reference to `acs_map'
/usr/bin/ld: menubox.c:(.text+0x2d0): undefined reference to `waddch'
/usr/bin/ld: menubox.c:(.text+0x2e4): undefined reference to `waddnstr'
/usr/bin/ld: menubox.c:(.text+0x2f4): undefined reference to `wmove'
/usr/bin/ld: menubox.c:(.text+0x2fc): undefined reference to `wrefresh'
/usr/bin/ld: menubox.c:(.text+0x317): undefined reference to `wattrset'
/usr/bin/ld: menubox.c:(.text+0x31d): undefined reference to `acs_map'
/usr/bin/ld: menubox.c:(.text+0x325): undefined reference to `waddch'
/usr/bin/ld: menubox.c:(.text+0x32b): undefined reference to `acs_map'
/usr/bin/ld: menubox.c:(.text+0x333): undefined reference to `waddch'
/usr/bin/ld: menubox.c:(.text+0x339): undefined reference to `acs_map'
/usr/bin/ld: menubox.c:(.text+0x341): undefined reference to `waddch'
/usr/bin/ld: menubox.c:(.text+0x347): undefined reference to `acs_map'
/usr/bin/ld: menubox.c:(.text+0x34f): undefined reference to `waddch'
/usr/bin/ld: menubox.c:(.text+0x35e): undefined reference to `wmove'
/usr/bin/ld: menubox.c:(.text+0x38a): undefined reference to `wattrset'
/usr/bin/ld: menubox.c:(.text+0x390): undefined reference to `acs_map'
/usr/bin/ld: menubox.c:(.text+0x398): undefined reference to `waddch'
/usr/bin/ld: menubox.c:(.text+0x3ac): undefined reference to `waddnstr'
/usr/bin/ld: menubox.c:(.text+0x3c2): undefined reference to `wattrset'
/usr/bin/ld: menubox.c:(.text+0x3c8): undefined reference to `acs_map'
/usr/bin/ld: menubox.c:(.text+0x3d0): undefined reference to `waddch'
/usr/bin/ld: menubox.c:(.text+0x3d6): undefined reference to `acs_map'
/usr/bin/ld: menubox.c:(.text+0x3de): undefined reference to `waddch'
/usr/bin/ld: menubox.c:(.text+0x3e4): undefined reference to `acs_map'
/usr/bin/ld: menubox.c:(.text+0x3ec): undefined reference to `waddch'
/usr/bin/ld: menubox.c:(.text+0x3f2): undefined reference to `acs_map'
/usr/bin/ld: menubox.c:(.text+0x3fa): undefined reference to `waddch'
/usr/bin/ld: scripts/kconfig/lxdialog/menubox.o: in function `dialog_menu':
menubox.c:(.text+0x446): undefined reference to `stdscr'
/usr/bin/ld: menubox.c:(.text+0x44b): undefined reference to `getmaxy'
/usr/bin/ld: menubox.c:(.text+0x452): undefined reference to `stdscr'
/usr/bin/ld: menubox.c:(.text+0x459): undefined reference to `getmaxx'
/usr/bin/ld: menubox.c:(.text+0x49f): undefined reference to `stdscr'
/usr/bin/ld: menubox.c:(.text+0x4a4): undefined reference to `getmaxx'
/usr/bin/ld: menubox.c:(.text+0x4b0): undefined reference to `stdscr'
/usr/bin/ld: menubox.c:(.text+0x4ca): undefined reference to `getmaxy'
/usr/bin/ld: menubox.c:(.text+0x4d6): undefined reference to `stdscr'
/usr/bin/ld: menubox.c:(.text+0x50b): undefined reference to `newwin'
/usr/bin/ld: menubox.c:(.text+0x51b): undefined reference to `keypad'
/usr/bin/ld: menubox.c:(.text+0x54d): undefined reference to `wattrset'
/usr/bin/ld: menubox.c:(.text+0x55a): undefined reference to `wmove'
/usr/bin/ld: menubox.c:(.text+0x568): undefined reference to `acs_map'
/usr/bin/ld: menubox.c:(.text+0x570): undefined reference to `waddch'
/usr/bin/ld: menubox.c:(.text+0x582): undefined reference to `acs_map'
/usr/bin/ld: menubox.c:(.text+0x58e): undefined reference to `waddch'
/usr/bin/ld: menubox.c:(.text+0x5a1): undefined reference to `wattrset'
/usr/bin/ld: menubox.c:(.text+0x5b5): undefined reference to `wbkgdset'
/usr/bin/ld: menubox.c:(.text+0x5bb): undefined reference to `acs_map'
/usr/bin/ld: menubox.c:(.text+0x5c3): undefined reference to `waddch'
/usr/bin/ld: menubox.c:(.text+0x5e2): undefined reference to `wattrset'
/usr/bin/ld: menubox.c:(.text+0x621): undefined reference to `subwin'
/usr/bin/ld: menubox.c:(.text+0x631): undefined reference to `keypad'
/usr/bin/ld: menubox.c:(.text+0x7ac): undefined reference to `wnoutrefresh'
/usr/bin/ld: menubox.c:(.text+0x7f5): undefined reference to `wmove'
/usr/bin/ld: menubox.c:(.text+0x7fd): undefined reference to `wrefresh'
/usr/bin/ld: menubox.c:(.text+0x805): undefined reference to `wgetch'
/usr/bin/ld: menubox.c:(.text+0x933): undefined reference to `delwin'
/usr/bin/ld: menubox.c:(.text+0x93b): undefined reference to `delwin'
/usr/bin/ld: menubox.c:(.text+0x97e): undefined reference to `delwin'
/usr/bin/ld: menubox.c:(.text+0x986): undefined reference to `delwin'
/usr/bin/ld: menubox.c:(.text+0xab9): undefined reference to `scrollok'
/usr/bin/ld: menubox.c:(.text+0xac6): undefined reference to `wscrl'
/usr/bin/ld: menubox.c:(.text+0xad0): undefined reference to `scrollok'
/usr/bin/ld: menubox.c:(.text+0xadd): undefined reference to `wrefresh'
/usr/bin/ld: menubox.c:(.text+0xb81): undefined reference to `wnoutrefresh'
/usr/bin/ld: menubox.c:(.text+0xb89): undefined reference to `wrefresh'
/usr/bin/ld: menubox.c:(.text+0xbe6): undefined reference to `wrefresh'
/usr/bin/ld: menubox.c:(.text+0xcc3): undefined reference to `delwin'
/usr/bin/ld: menubox.c:(.text+0xccb): undefined reference to `delwin'
/usr/bin/ld: menubox.c:(.text+0xf96): undefined reference to `wrefresh'
/usr/bin/ld: menubox.c:(.text+0xfca): undefined reference to `scrollok'
/usr/bin/ld: menubox.c:(.text+0xfd7): undefined reference to `wscrl'
/usr/bin/ld: menubox.c:(.text+0xfe1): undefined reference to `scrollok'
/usr/bin/ld: menubox.c:(.text+0xff3): undefined reference to `wrefresh'
/usr/bin/ld: menubox.c:(.text+0x1066): undefined reference to `delwin'
/usr/bin/ld: menubox.c:(.text+0x106e): undefined reference to `delwin'
/usr/bin/ld: menubox.c:(.text+0x111a): undefined reference to `scrollok'
/usr/bin/ld: menubox.c:(.text+0x112c): undefined reference to `wscrl'
/usr/bin/ld: menubox.c:(.text+0x1136): undefined reference to `scrollok'
/usr/bin/ld: menubox.c:(.text+0x113e): undefined reference to `wrefresh'
/usr/bin/ld: menubox.c:(.text+0x11f4): undefined reference to `scrollok'
/usr/bin/ld: menubox.c:(.text+0x1231): undefined reference to `scrollok'
/usr/bin/ld: menubox.c:(.text+0x123e): undefined reference to `wscrl'
/usr/bin/ld: menubox.c:(.text+0x1248): undefined reference to `scrollok'
/usr/bin/ld: menubox.c:(.text+0x1250): undefined reference to `wrefresh'
/usr/bin/ld: scripts/kconfig/lxdialog/menubox.o: in function `do_print_item':
menubox.c:(.text+0x126): undefined reference to `wrefresh'
/usr/bin/ld: scripts/kconfig/lxdialog/menubox.o: in function `print_buttons':
menubox.c:(.text+0x265): undefined reference to `wrefresh'
/usr/bin/ld: scripts/kconfig/lxdialog/menubox.o: in function `print_arrows.constprop.0':
menubox.c:(.text+0x374): undefined reference to `wrefresh'
/usr/bin/ld: scripts/kconfig/lxdialog/textbox.o: in function `refresh_text_box':
textbox.c:(.text+0x2da): undefined reference to `wmove'
/usr/bin/ld: textbox.c:(.text+0x2e7): undefined reference to `waddch'
/usr/bin/ld: textbox.c:(.text+0x304): undefined reference to `waddnstr'
/usr/bin/ld: textbox.c:(.text+0x30c): undefined reference to `wclrtoeol'
/usr/bin/ld: textbox.c:(.text+0x33d): undefined reference to `wnoutrefresh'
/usr/bin/ld: textbox.c:(.text+0x350): undefined reference to `wattrset'
/usr/bin/ld: textbox.c:(.text+0x364): undefined reference to `wbkgdset'
/usr/bin/ld: textbox.c:(.text+0x39c): undefined reference to `getmaxx'
/usr/bin/ld: textbox.c:(.text+0x3a6): undefined reference to `getmaxy'
/usr/bin/ld: textbox.c:(.text+0x3b4): undefined reference to `wmove'
/usr/bin/ld: textbox.c:(.text+0x3c7): undefined reference to `wprintw'
/usr/bin/ld: textbox.c:(.text+0x3d7): undefined reference to `wmove'
/usr/bin/ld: scripts/kconfig/lxdialog/textbox.o: in function `dialog_textbox':
textbox.c:(.text+0x48a): undefined reference to `stdscr'
/usr/bin/ld: textbox.c:(.text+0x48f): undefined reference to `getmaxy'
/usr/bin/ld: textbox.c:(.text+0x496): undefined reference to `stdscr'
/usr/bin/ld: textbox.c:(.text+0x49e): undefined reference to `getmaxx'
/usr/bin/ld: textbox.c:(.text+0x4c4): undefined reference to `stdscr'
/usr/bin/ld: textbox.c:(.text+0x4d9): undefined reference to `getmaxx'
/usr/bin/ld: textbox.c:(.text+0x4e0): undefined reference to `stdscr'
/usr/bin/ld: textbox.c:(.text+0x4f5): undefined reference to `getmaxy'
/usr/bin/ld: textbox.c:(.text+0x508): undefined reference to `stdscr'
/usr/bin/ld: textbox.c:(.text+0x530): undefined reference to `newwin'
/usr/bin/ld: textbox.c:(.text+0x540): undefined reference to `keypad'
/usr/bin/ld: textbox.c:(.text+0x55c): undefined reference to `subwin'
/usr/bin/ld: textbox.c:(.text+0x56d): undefined reference to `wattrset'
/usr/bin/ld: textbox.c:(.text+0x581): undefined reference to `wbkgdset'
/usr/bin/ld: textbox.c:(.text+0x58e): undefined reference to `keypad'
/usr/bin/ld: textbox.c:(.text+0x5c0): undefined reference to `wattrset'
/usr/bin/ld: textbox.c:(.text+0x5cf): undefined reference to `wmove'
/usr/bin/ld: textbox.c:(.text+0x5dc): undefined reference to `acs_map'
/usr/bin/ld: textbox.c:(.text+0x5e4): undefined reference to `waddch'
/usr/bin/ld: textbox.c:(.text+0x5f2): undefined reference to `acs_map'
/usr/bin/ld: textbox.c:(.text+0x5fe): undefined reference to `waddch'
/usr/bin/ld: textbox.c:(.text+0x611): undefined reference to `wattrset'
/usr/bin/ld: textbox.c:(.text+0x625): undefined reference to `wbkgdset'
/usr/bin/ld: textbox.c:(.text+0x62b): undefined reference to `acs_map'
/usr/bin/ld: textbox.c:(.text+0x633): undefined reference to `waddch'
/usr/bin/ld: textbox.c:(.text+0x670): undefined reference to `wnoutrefresh'
/usr/bin/ld: textbox.c:(.text+0x678): undefined reference to `getcury'
/usr/bin/ld: textbox.c:(.text+0x683): undefined reference to `getcurx'
/usr/bin/ld: textbox.c:(.text+0x6ca): undefined reference to `wgetch'
/usr/bin/ld: textbox.c:(.text+0x763): undefined reference to `delwin'
/usr/bin/ld: textbox.c:(.text+0x76b): undefined reference to `delwin'
/usr/bin/ld: textbox.c:(.text+0x82c): undefined reference to `wgetch'
/usr/bin/ld: textbox.c:(.text+0x9d4): undefined reference to `delwin'
/usr/bin/ld: textbox.c:(.text+0x9dc): undefined reference to `delwin'
/usr/bin/ld: scripts/kconfig/lxdialog/textbox.o: in function `refresh_text_box':
textbox.c:(.text+0x3ed): undefined reference to `wrefresh'
/usr/bin/ld: scripts/kconfig/lxdialog/util.o: in function `init_one_color':
util.c:(.text+0x2ef): undefined reference to `init_pair'
/usr/bin/ld: scripts/kconfig/lxdialog/util.o: in function `attr_clear':
util.c:(.text+0x324): undefined reference to `wattrset'
/usr/bin/ld: util.c:(.text+0x335): undefined reference to `wmove'
/usr/bin/ld: util.c:(.text+0x36c): undefined reference to `waddch'
/usr/bin/ld: util.c:(.text+0x387): undefined reference to `wmove'
/usr/bin/ld: util.c:(.text+0x3a0): undefined reference to `wmove'
/usr/bin/ld: util.c:(.text+0x3b0): undefined reference to `getmaxy'
/usr/bin/ld: scripts/kconfig/lxdialog/util.o: in function `dialog_clear':
util.c:(.text+0x3e1): undefined reference to `stdscr'
/usr/bin/ld: util.c:(.text+0x3e6): undefined reference to `getmaxy'
/usr/bin/ld: util.c:(.text+0x3ed): undefined reference to `stdscr'
/usr/bin/ld: util.c:(.text+0x3f4): undefined reference to `getmaxx'
/usr/bin/ld: util.c:(.text+0x401): undefined reference to `stdscr'
/usr/bin/ld: util.c:(.text+0x428): undefined reference to `stdscr'
/usr/bin/ld: util.c:(.text+0x42d): undefined reference to `wattrset'
/usr/bin/ld: util.c:(.text+0x434): undefined reference to `stdscr'
/usr/bin/ld: util.c:(.text+0x440): undefined reference to `wmove'
/usr/bin/ld: util.c:(.text+0x47c): undefined reference to `stdscr'
/usr/bin/ld: util.c:(.text+0x48f): undefined reference to `wmove'
/usr/bin/ld: util.c:(.text+0x4a6): undefined reference to `stdscr'
/usr/bin/ld: util.c:(.text+0x4c2): undefined reference to `acs_map'
/usr/bin/ld: util.c:(.text+0x4c9): undefined reference to `stdscr'
/usr/bin/ld: util.c:(.text+0x4d2): undefined reference to `waddch'
/usr/bin/ld: util.c:(.text+0x4de): undefined reference to `stdscr'
/usr/bin/ld: util.c:(.text+0x502): undefined reference to `stdscr'
/usr/bin/ld: util.c:(.text+0x50c): undefined reference to `waddnstr'
/usr/bin/ld: util.c:(.text+0x52b): undefined reference to `stdscr'
/usr/bin/ld: util.c:(.text+0x542): undefined reference to `waddnstr'
/usr/bin/ld: util.c:(.text+0x59a): undefined reference to `stdscr'
/usr/bin/ld: util.c:(.text+0x5a7): undefined reference to `waddnstr'
/usr/bin/ld: util.c:(.text+0x5ae): undefined reference to `stdscr'
/usr/bin/ld: util.c:(.text+0x5b8): undefined reference to `waddch'
/usr/bin/ld: util.c:(.text+0x5cc): undefined reference to `stdscr'
/usr/bin/ld: util.c:(.text+0x5d2): undefined reference to `acs_map'
/usr/bin/ld: util.c:(.text+0x5d7): undefined reference to `waddch'
/usr/bin/ld: util.c:(.text+0x5de): undefined reference to `stdscr'
/usr/bin/ld: util.c:(.text+0x5e8): undefined reference to `waddch'
/usr/bin/ld: scripts/kconfig/lxdialog/util.o: in function `init_dialog':
util.c:(.text+0x61a): undefined reference to `initscr'
/usr/bin/ld: util.c:(.text+0x621): undefined reference to `stdscr'
/usr/bin/ld: util.c:(.text+0x626): undefined reference to `getcury'
/usr/bin/ld: util.c:(.text+0x62d): undefined reference to `stdscr'
/usr/bin/ld: util.c:(.text+0x638): undefined reference to `getcurx'
/usr/bin/ld: util.c:(.text+0x63f): undefined reference to `stdscr'
/usr/bin/ld: util.c:(.text+0x64a): undefined reference to `getmaxy'
/usr/bin/ld: util.c:(.text+0x651): undefined reference to `stdscr'
/usr/bin/ld: util.c:(.text+0x658): undefined reference to `getmaxx'
/usr/bin/ld: util.c:(.text+0x6ea): undefined reference to `has_colors'
/usr/bin/ld: util.c:(.text+0x6f7): undefined reference to `start_color'
/usr/bin/ld: util.c:(.text+0x866): undefined reference to `has_colors'
/usr/bin/ld: util.c:(.text+0x997): undefined reference to `stdscr'
/usr/bin/ld: util.c:(.text+0x9a1): undefined reference to `keypad'
/usr/bin/ld: util.c:(.text+0x9a6): undefined reference to `cbreak'
/usr/bin/ld: util.c:(.text+0x9ab): undefined reference to `noecho'
/usr/bin/ld: util.c:(.text+0xc01): undefined reference to `endwin'
/usr/bin/ld: scripts/kconfig/lxdialog/util.o: in function `end_dialog':
util.c:(.text+0xc39): undefined reference to `stdscr'
/usr/bin/ld: util.c:(.text+0xc3e): undefined reference to `wmove'
/usr/bin/ld: util.c:(.text+0xc45): undefined reference to `stdscr'
/usr/bin/ld: util.c:(.text+0xc4a): undefined reference to `wrefresh'
/usr/bin/ld: scripts/kconfig/lxdialog/util.o: in function `print_title':
util.c:(.text+0xca9): undefined reference to `wattrset'
/usr/bin/ld: util.c:(.text+0xcb6): undefined reference to `wmove'
/usr/bin/ld: util.c:(.text+0xcc8): undefined reference to `waddch'
/usr/bin/ld: util.c:(.text+0xcd4): undefined reference to `wmove'
/usr/bin/ld: util.c:(.text+0xce7): undefined reference to `waddnstr'
/usr/bin/ld: scripts/kconfig/lxdialog/util.o: in function `print_autowrap':
util.c:(.text+0xe18): undefined reference to `wmove'
/usr/bin/ld: util.c:(.text+0xe28): undefined reference to `waddnstr'
/usr/bin/ld: util.c:(.text+0xe30): undefined reference to `getcury'
/usr/bin/ld: util.c:(.text+0xe3a): undefined reference to `getcurx'
/usr/bin/ld: util.c:(.text+0xe9d): undefined reference to `wmove'
/usr/bin/ld: util.c:(.text+0xead): undefined reference to `waddnstr'
/usr/bin/ld: util.c:(.text+0xeb5): undefined reference to `getcury'
/usr/bin/ld: util.c:(.text+0xebd): undefined reference to `getcurx'
/usr/bin/ld: util.c:(.text+0xf65): undefined reference to `wmove'
/usr/bin/ld: util.c:(.text+0xf75): undefined reference to `waddnstr'
/usr/bin/ld: scripts/kconfig/lxdialog/util.o: in function `print_button':
util.c:(.text+0xfa3): undefined reference to `wmove'
/usr/bin/ld: util.c:(.text+0xfba): undefined reference to `wattrset'
/usr/bin/ld: util.c:(.text+0xfce): undefined reference to `waddnstr'
/usr/bin/ld: util.c:(.text+0xff5): undefined reference to `wattrset'
/usr/bin/ld: util.c:(.text+0x101d): undefined reference to `waddch'
/usr/bin/ld: util.c:(.text+0x1039): undefined reference to `wattrset'
/usr/bin/ld: util.c:(.text+0x1046): undefined reference to `waddch'
/usr/bin/ld: util.c:(.text+0x1054): undefined reference to `wattrset'
/usr/bin/ld: util.c:(.text+0x1066): undefined reference to `waddnstr'
/usr/bin/ld: util.c:(.text+0x1074): undefined reference to `wattrset'
/usr/bin/ld: util.c:(.text+0x1088): undefined reference to `waddnstr'
/usr/bin/ld: util.c:(.text+0x10ba): undefined reference to `wattrset'
/usr/bin/ld: util.c:(.text+0x10c7): undefined reference to `waddch'
/usr/bin/ld: util.c:(.text+0x10d5): undefined reference to `wattrset'
/usr/bin/ld: util.c:(.text+0x10e7): undefined reference to `waddnstr'
/usr/bin/ld: util.c:(.text+0x110a): undefined reference to `wattrset'
/usr/bin/ld: util.c:(.text+0x111e): undefined reference to `waddnstr'
/usr/bin/ld: util.c:(.text+0x1145): undefined reference to `wattrset'
/usr/bin/ld: scripts/kconfig/lxdialog/util.o: in function `draw_box':
util.c:(.text+0x118d): undefined reference to `wattrset'
/usr/bin/ld: util.c:(.text+0x11a4): undefined reference to `wmove'
/usr/bin/ld: util.c:(.text+0x11b9): undefined reference to `acs_map'
/usr/bin/ld: util.c:(.text+0x11c1): undefined reference to `waddch'
/usr/bin/ld: util.c:(.text+0x11ff): undefined reference to `waddch'
/usr/bin/ld: util.c:(.text+0x122d): undefined reference to `wmove'
/usr/bin/ld: util.c:(.text+0x1248): undefined reference to `acs_map'
/usr/bin/ld: util.c:(.text+0x124d): undefined reference to `waddch'
/usr/bin/ld: util.c:(.text+0x126e): undefined reference to `acs_map'
/usr/bin/ld: util.c:(.text+0x1273): undefined reference to `waddch'
/usr/bin/ld: util.c:(.text+0x1293): undefined reference to `acs_map'
/usr/bin/ld: util.c:(.text+0x129b): undefined reference to `waddch'
/usr/bin/ld: util.c:(.text+0x12aa): undefined reference to `acs_map'
/usr/bin/ld: util.c:(.text+0x12b2): undefined reference to `waddch'
/usr/bin/ld: util.c:(.text+0x12c4): undefined reference to `acs_map'
/usr/bin/ld: util.c:(.text+0x12c9): undefined reference to `waddch'
/usr/bin/ld: util.c:(.text+0x12e1): undefined reference to `acs_map'
/usr/bin/ld: util.c:(.text+0x12e6): undefined reference to `waddch'
/usr/bin/ld: util.c:(.text+0x12f2): undefined reference to `acs_map'
/usr/bin/ld: util.c:(.text+0x12fa): undefined reference to `waddch'
/usr/bin/ld: scripts/kconfig/lxdialog/util.o: in function `draw_shadow':
util.c:(.text+0x133e): undefined reference to `has_colors'
/usr/bin/ld: util.c:(.text+0x136a): undefined reference to `wattrset'
/usr/bin/ld: util.c:(.text+0x137c): undefined reference to `wmove'
/usr/bin/ld: util.c:(.text+0x1398): undefined reference to `winch'
/usr/bin/ld: util.c:(.text+0x13a3): undefined reference to `waddch'
/usr/bin/ld: util.c:(.text+0x13cc): undefined reference to `wmove'
/usr/bin/ld: util.c:(.text+0x13d4): undefined reference to `winch'
/usr/bin/ld: util.c:(.text+0x13df): undefined reference to `waddch'
/usr/bin/ld: util.c:(.text+0x13e7): undefined reference to `winch'
/usr/bin/ld: util.c:(.text+0x13f2): undefined reference to `waddch'
/usr/bin/ld: scripts/kconfig/lxdialog/util.o: in function `on_key_esc':
util.c:(.text+0x1513): undefined reference to `nodelay'
/usr/bin/ld: util.c:(.text+0x151d): undefined reference to `keypad'
/usr/bin/ld: util.c:(.text+0x1525): undefined reference to `wgetch'
/usr/bin/ld: util.c:(.text+0x1530): undefined reference to `wgetch'
/usr/bin/ld: util.c:(.text+0x1544): undefined reference to `wgetch'
/usr/bin/ld: util.c:(.text+0x1555): undefined reference to `nodelay'
/usr/bin/ld: util.c:(.text+0x1562): undefined reference to `keypad'
/usr/bin/ld: util.c:(.text+0x159e): undefined reference to `ungetch'
/usr/bin/ld: scripts/kconfig/lxdialog/util.o: in function `attr_clear':
util.c:(.text+0x3c9): undefined reference to `wtouchln'
/usr/bin/ld: scripts/kconfig/lxdialog/util.o: in function `dialog_clear':
util.c:(.text+0x4f1): undefined reference to `wnoutrefresh'
/usr/bin/ld: scripts/kconfig/lxdialog/util.o: in function `end_dialog':
util.c:(.text+0xc53): undefined reference to `endwin'
/usr/bin/ld: scripts/kconfig/lxdialog/util.o: in function `print_title':
util.c:(.text+0xcfc): undefined reference to `waddch'
/usr/bin/ld: scripts/kconfig/lxdialog/util.o: in function `print_button':
util.c:(.text+0x10a7): undefined reference to `wmove'
/usr/bin/ld: scripts/kconfig/lxdialog/util.o: in function `draw_shadow':
util.c:(.text+0x140d): undefined reference to `wnoutrefresh'
/usr/bin/ld: scripts/kconfig/lxdialog/yesno.o: in function `print_buttons':
yesno.c:(.text+0x6d): undefined reference to `wmove'
/usr/bin/ld: scripts/kconfig/lxdialog/yesno.o: in function `dialog_yesno':
yesno.c:(.text+0xc2): undefined reference to `stdscr'
/usr/bin/ld: yesno.c:(.text+0xc7): undefined reference to `getmaxy'
/usr/bin/ld: yesno.c:(.text+0xda): undefined reference to `stdscr'
/usr/bin/ld: yesno.c:(.text+0xdf): undefined reference to `getmaxx'
/usr/bin/ld: yesno.c:(.text+0xf0): undefined reference to `stdscr'
/usr/bin/ld: yesno.c:(.text+0xf5): undefined reference to `getmaxx'
/usr/bin/ld: yesno.c:(.text+0xfc): undefined reference to `stdscr'
/usr/bin/ld: yesno.c:(.text+0x10b): undefined reference to `getmaxy'
/usr/bin/ld: yesno.c:(.text+0x11d): undefined reference to `stdscr'
/usr/bin/ld: yesno.c:(.text+0x13e): undefined reference to `newwin'
/usr/bin/ld: yesno.c:(.text+0x14e): undefined reference to `keypad'
/usr/bin/ld: yesno.c:(.text+0x180): undefined reference to `wattrset'
/usr/bin/ld: yesno.c:(.text+0x18e): undefined reference to `wmove'
/usr/bin/ld: yesno.c:(.text+0x19b): undefined reference to `acs_map'
/usr/bin/ld: yesno.c:(.text+0x1a3): undefined reference to `waddch'
/usr/bin/ld: yesno.c:(.text+0x1c2): undefined reference to `acs_map'
/usr/bin/ld: yesno.c:(.text+0x1ce): undefined reference to `waddch'
/usr/bin/ld: yesno.c:(.text+0x1e1): undefined reference to `wattrset'
/usr/bin/ld: yesno.c:(.text+0x1e7): undefined reference to `acs_map'
/usr/bin/ld: yesno.c:(.text+0x1ef): undefined reference to `waddch'
/usr/bin/ld: yesno.c:(.text+0x20d): undefined reference to `wattrset'
/usr/bin/ld: yesno.c:(.text+0x23f): undefined reference to `wgetch'
/usr/bin/ld: yesno.c:(.text+0x26b): undefined reference to `delwin'
/usr/bin/ld: yesno.c:(.text+0x29b): undefined reference to `delwin'
/usr/bin/ld: yesno.c:(.text+0x2ba): undefined reference to `delwin'
/usr/bin/ld: yesno.c:(.text+0x2df): undefined reference to `delwin'
/usr/bin/ld: yesno.c:(.text+0x30d): undefined reference to `delwin'
/usr/bin/ld: yesno.c:(.text+0x344): undefined reference to `wrefresh'
/usr/bin/ld: yesno.c:(.text+0x373): undefined reference to `wrefresh'
/usr/bin/ld: scripts/kconfig/lxdialog/yesno.o: in function `print_buttons':
yesno.c:(.text+0x7f): undefined reference to `wrefresh'
/usr/bin/ld: warning: creating DT_TEXTREL in a PIE
collect2: error: ld returned 1 exit status
make[1]: *** [scripts/Makefile.host:123: scripts/kconfig/mconf] Fehler 1
make: *** [Makefile:703: menuconfig] Fehler 2
root@linus:/usr/src/linux-stable-rc#




Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
