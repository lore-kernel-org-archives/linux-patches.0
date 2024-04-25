Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9C026293
	for <patches@lists.linux.dev>; Thu, 25 Apr 2024 06:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714027249; cv=none; b=WOEKn4Nw/8JRg7hP+28fTjvsZvk3lURvhq2UKZ1wbGgO2epvlh6hxegkF/fLl++KHjpvtn846Zm5ql6eYanUAsxkUuKjhHks4xM/zrnzki6xv1jwqM62QtoINRRVqJKL8noxUQ5TN/KLMf+9T5wyQ8lcq3a3yJjUDZhgQvIHNJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714027249; c=relaxed/simple;
	bh=7OKYbj4Uuksbo2Qf5HPNw17rjN6Qs+vtlgxGEBAQNdc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q4JWZnfYRedhgGx6Lp4775ihQ1ERz7tdRrs3ttLgHaiXi2Abi2Kx1dhRnD3KeqGemJ3gw2IdDAtBzQKz7CuJisGirWxdOab1M/lvn9dcyZukFX+0I9tu3VACDnoPAaVDIu4y+Tj4ORQhEXFJtopUqNL2D5uZuPu05ts0QOSwfMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=O7wamDWQ; arc=none smtp.client-ip=209.85.221.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="O7wamDWQ"
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-4daa8e14afbso223275e0c.3
        for <patches@lists.linux.dev>; Wed, 24 Apr 2024 23:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1714027246; x=1714632046; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gHsnE6PXlZIvSfAKFrgueOgWtUt0jTx+nljG77Q1N3I=;
        b=O7wamDWQ4CnpkTilTUa3ro5PSVnVATbcOIdWnfRReU6lCOhEntupdEldfY44qito/G
         gGqANSos8L5PgguTUDTEKIEYbR/RpJNcOp48sYgzm/LzLiOElkQTar9ORmNrrjikkZ9H
         NIm1rhv2w/r5IrzcjtPkZYAlGD5K8Yc1W6TOZ5EiuB4LVSpUEvNxyFDkYGosm8wsCoXF
         OI1IdtAO3LoBEQnHtg+nj7nJVXZamE7jnxsFXak9rJ7k+rGB5YZsF0vc0mTKQgzTZ5rp
         hEUA4Wa+AYZNgNBmicgLO7y33tS18CJrEpLiZ25xUAnzHoLp00b/WVxSybbyWClT0ap8
         ORAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714027246; x=1714632046;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gHsnE6PXlZIvSfAKFrgueOgWtUt0jTx+nljG77Q1N3I=;
        b=CG3AxGoN3x992AOrt0gC5ldHcQQ5+xjI9tCZi1g68jXBtQquZO/E4PBRzDorpFUc1k
         XS40fc6KvSzqaxPVdGH+g7y7lttnI+4HkwBzAdBEd6/DZjKyCtU7Xm/pcfBXcqSB3P/y
         6Y7Y/O3uqRYKcWuP7KNzRFyjyk/SzjkSpGIGvsqrjR/wyYwXXUYt9AIRJLWpueRFy6qF
         +gbwmmr7Q1AlEEu4V4FaFbjM04rq2gYhW/6DRBjW1n62JqZIwSNe2ZO0+eKaIMCGdauv
         vpvabAb2q23tOVp8uUJKaCJLlrVVGTndwT+kCFuM1lPXpQs0GKAejq8Hk8vdDPLnRRey
         tccw==
X-Forwarded-Encrypted: i=1; AJvYcCW19oveJ8ea+6zp5E2xtMbhdfvFnFliQGwfGIfAJZrzJ43VzIfagXEzMoQrbWMTuPNYig6mIOH8gDE0queKfxoaXabL4DJwsg==
X-Gm-Message-State: AOJu0YwNRYomvq2XiVOi6idfFAiugxFcrJCJT/DXDVdobdK8+Am/yorU
	/lECDs1i+9TKVxB9V5SeFfNTvHib4yTcy1rutI/SsnUguCgr5jCAW6D1DlkN1cFQyWqFUJkIdox
	V4BT+e6mAJjUcw4/TwodTsKCDrd90JYuJCS+RVA==
X-Google-Smtp-Source: AGHT+IHy4yn17l8WHIexhBFucEWjWLbwAWQAgKSltStNJ3dC7QNXsxAi/oLT0hbpvn0uD0kdCJfydjnj6Vo6WxvlaAs=
X-Received: by 2002:a05:6122:4686:b0:4da:aabe:6f6c with SMTP id
 di6-20020a056122468600b004daaabe6f6cmr5538526vkb.7.1714027246474; Wed, 24 Apr
 2024 23:40:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240423213855.824778126@linuxfoundation.org>
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 25 Apr 2024 12:10:34 +0530
Message-ID: <CA+G9fYvB61RTie=PKQau1m2WWQNUQ++ZY+W_of4kXVh5P26B0w@mail.gmail.com>
Subject: Re: [PATCH 6.8 000/158] 6.8.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, Arnd Bergmann <arnd@arndb.de>, 
	Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 24 Apr 2024 at 03:11, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.8.8 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 25 Apr 2024 21:38:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.8.8-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.8.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, x86_64, and i386.

One regression on arm,
the TI BeagleBoard-X15 device kunit test boot failed and
it is always reproducible.

Not a problem on qemu-armv7.

However, I am bisecting this problem and let you know shortly.

Links:
---
 - https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/tests/2fWFwcz=
HZDFUGnjqyT1mZ6wIeS9
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.8.y/build/v6.=
8.7-159-g9919cd9ab988/testrun/23660959/suite/boot/test/gcc-13-lkftconfig-ku=
nit/details/

log:
--=20
[   45.931457] BUG: KASAN: slab-out-of-bounds in
krealloc_more_oob_helper+0x464/0x4c0
[   45.950073] Write of size 1 at addr cacc68eb by task kunit_try_catch/176
[   45.956817]
[   45.958312] CPU: 0 PID: 176 Comm: kunit_try_catch Tainted: G    B
W        N 6.8.8-rc1 #1
[   45.966735] Hardware name: Generic DRA74X (Flattened Device Tree)
[   45.972869]  unwind_backtrace from show_stack+0x18/0x1c
[   45.978149]  show_stack from dump_stack_lvl+0x6c/0x8c
[   45.983245]  dump_stack_lvl from print_report+0x158/0x510
[   45.988677]  print_report from kasan_report+0xc8/0x104
[   45.993865]  kasan_report from krealloc_more_oob_helper+0x464/0x4c0
[   46.000183]  krealloc_more_oob_helper from kunit_try_run_case+0x224/0x59=
8
[   46.007019]  kunit_try_run_case from
kunit_generic_run_threadfn_adapter+0x84/0xe4
[   46.014556]  kunit_generic_run_threadfn_adapter from kthread+0x378/0x410
[   46.021331]  kthread from ret_from_fork+0x14/0x28
[   46.026062] Exception stack(0xf219bfb0 to 0xf219bff8)
[   46.031158] bfa0:                                     00000000
00000000 00000000 00000000
[   46.039367] bfc0: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[   46.047607] bfe0: 00000000 00000000 00000000 00000000 00000013 00000000
[   46.054260]
[   46.055755] Allocated by task 176:
[   46.059173]  kasan_save_track+0x30/0x5c
[   46.063049]  __kasan_krealloc+0xf0/0x13c
[   46.067016]  krealloc+0xb8/0xfc
[   46.070190]  krealloc_more_oob_helper+0xd4/0x4c0
[   46.074829]  kunit_try_run_case+0x224/0x598
[   46.079040]  kunit_generic_run_threadfn_adapter+0x84/0xe4
[   46.084472]  kthread+0x378/0x410
[   46.087738]  ret_from_fork+0x14/0x28
[   46.091339]
[   46.092834] The buggy address belongs to the object at cacc6800
[   46.092834]  which belongs to the cache kmalloc-256 of size 256
[   46.104736] The buggy address is located 0 bytes to the right of
[   46.104736]  allocated 235-byte region [cacc6800, cacc68eb)
[   46.116363]
[   46.117858] The buggy address belongs to the physical page:
[   46.123474] page:af853d8a refcount:1 mapcount:0 mapping:00000000
index:0x0 pfn:0x8acc6
[   46.131439] head:af853d8a order:1 entire_mapcount:0
nr_pages_mapped:0 pincount:0
[   46.138885] flags: 0x840(slab|head|zone=3D0)
[   46.143005] page_type: 0xffffffff()
[   46.146514] raw: 00000840 c6801500 00000122 00000000 00000000
80100010 ffffffff 00000001
[   46.154663] raw: 00000000
[   46.157287] page dumped because: kasan: bad access detected
[   46.162902]
[   46.164398] Memory state around the buggy address:
[   46.169219]  cacc6780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   46.175781]  cacc6800: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   46.182373] >cacc6880: 00 00 00 00 00 00 00 00 00 00 00 00 00 03 fc fc
[   46.188934]                                                   ^
[   46.194885]  cacc6900: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   46.201446]  cacc6980: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   46.208038] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   46.215454] hub 1-1:1.0: 4 ports detected
[   46.215637] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   46.226745] BUG: KASAN: slab-out-of-bounds in
krealloc_more_oob_helper+0x458/0x4c0
[   46.234374] Write of size 1 at addr cacc68f0 by task kunit_try_catch/176
<common> [   46.570037]  krealloc_less_oob_helper from
kunit_try_run_case+0x224/0x598
<common> [   46.576873]  kunit_try_run_case from
kunit_generic_run_threadfn_adapter+0x84/0xe4
<common> [   46.584411]  kunit_generic_run_threadfn_adapter from
kthread+0x378/0x410

## Build
* kernel: 6.8.8-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.8.y
* git commit: ea4e35f1afd7d7d003c345bf14862183910ecc6b
* git describe: v6.8.7-159-gea4e35f1afd7
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.8.y/build/v6.8.7=
-159-gea4e35f1afd7

--
Linaro LKFT
https://lkft.linaro.org
