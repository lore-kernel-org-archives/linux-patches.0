Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D966A01E
	for <patches@lists.linux.dev>; Tue, 10 Sep 2024 14:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725978214; cv=none; b=jW0jmUUwls1ldc8SFDcUg/6YBbN4ybIldi5eUNZXlRDSGfimx/mZzWRTV1oFhbhTwbVvHye51DM8M+xo1VbZimgIbGszjlS6KujvzDMqRb4NL0DEslEGAcixIoeIjLqtg3XCEGh0aHxo3Ha6UfMYYCKLIpiihjakZBb56iYjL4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725978214; c=relaxed/simple;
	bh=oVRbXLj532BXhiOT5C4+qRrYGXt4OjydJknjPFbePeM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oSk4OJo1egjFJCB2muLMYHVRldquj+ikrTSJrJq2gAMkCKsrY/ZPBrEkLzN2JYt06AlboKs1uhhqrP8aTtTSooR6l6aCzXh3doxH9yhKOgLxFX9xzRciQQw+ngzVv0gBb/68aZxIj0T0N6IM3weM2p1g2s5XIKh8+YS3sdPFU1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=F6JKt/wZ; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="F6JKt/wZ"
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-2611dcc3941so218126fac.3
        for <patches@lists.linux.dev>; Tue, 10 Sep 2024 07:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1725978212; x=1726583012; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=81lETcO+41yZt1CbWmF21krOLTzEKBsg3XQNJ7wzck4=;
        b=F6JKt/wZvqVDz/Prn3rBMnDvKQOehMi70K9Hbeb1Tma6Ztiu2WjkL2gLDxySp8mpnL
         L8uQb+bzNdtF1jotX/k8EbID+nWc8QXN7oFvYTVpb04dk12yXdFGkDNZIXR4bIjXQpOB
         GASTWWOvOqh+s16nMkI/41BoPqi2VuQvOG2+0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725978212; x=1726583012;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=81lETcO+41yZt1CbWmF21krOLTzEKBsg3XQNJ7wzck4=;
        b=YeuG1MmpxoOsSaCs4MqCQiC1ATKaAaaQ2WsLBDkNnCQ6FLwMrt1ha+VuFCeAPsDRsD
         G9+JCi/04SfKKxATfaukz9/DsBndbQbqOyOmuLnHwoSHIspEtf0xOkbtNUxVmP67oLaq
         Ql/WBSdLRYjj5GU0MSFA0AIpnUbe8RzNbO4CFTMg3Q1Uce4rixagdhYIhSdt0ADG5vng
         EE/sv/eQLbjm8ZjxIRobLeH5arFawmtYTDAgh06jFrHq+RlAbe5+R2xVX76hXeL1PKDD
         F9osfdZc9RXkNi+2EeKdF07sMIohDX2/507ZZ5tImT2D+6CanCg1yS7sijrB4lUh6G7V
         yMNQ==
X-Forwarded-Encrypted: i=1; AJvYcCVm6QU9fTNXBeeaSsPAu8nWFI/pKgBq1wSDkJZH/odMCHBel+Pi9QuHCDVDsg5ICY3XmprvL4XV@lists.linux.dev
X-Gm-Message-State: AOJu0Yw8f6Drf7MKBK9VnhYKVV9mV6so6xlZ2e4MCcyu9tBVQ+Ro3Ouy
	bV3fI+BuUY5e9yWAFQDqHS0GcdzRYqb8tDhqJcaTjjNwn/lmHZ9B5J0rp5+524bmkukDdlgRXgN
	8wC4fflVKCYYFExjlIXYS82I7kZOULOCc2MNRTdgFUm5Ybq8=
X-Google-Smtp-Source: AGHT+IE0einZMCpCTFUXN657fJfRl8aXLCLD+vZ7naZGZqVajrcI5CNad900VWdQ/m9RhQIueD/NTav9o0Yk9+TxZpk=
X-Received: by 2002:a05:6870:7184:b0:260:ccfd:1efe with SMTP id
 586e51a60fabf-27b82f9cff1mr5859066fac.6.1725978211598; Tue, 10 Sep 2024
 07:23:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240910092622.245959861@linuxfoundation.org> <20240910092623.314101083@linuxfoundation.org>
In-Reply-To: <20240910092623.314101083@linuxfoundation.org>
From: Jeff Xu <jeffxu@chromium.org>
Date: Tue, 10 Sep 2024 07:23:19 -0700
Message-ID: <CABi2SkV-FdDQy2bjDkpgpqz7hX7ybeTjCrUgUf6WcYqGkuxWMQ@mail.gmail.com>
Subject: Re: [PATCH 6.10 032/375] selftests: mm: fix build errors on armhf
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>, Kees Cook <kees@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Shuah Khan <shuah@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi

I'm not sure this is a correct fix.

Since mseal is a security feature, an attacker can access syscall
directly, so the test should utilize syscall directly instead of
adding glibc as an extra layer.

The correct fix is probably one of below:
1> switch to __NR_mmap2 for this test on all architecture,
or
2> switch to __NR_mmap2 for ARMHF

Though I'm not sure which one is more appropriate, because I don't
have a test environment for ARMHF .

Although, I don't think we need to block this  getting into 6.10, we
can backport  again when a future fix is available.

Thanks
-Jeff


On Tue, Sep 10, 2024 at 2:42=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 6.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>
> ------------------
>
> From: Muhammad Usama Anjum <usama.anjum@collabora.com>
>
> commit b808f629215685c1941b1cd567c7b7ccb3c90278 upstream.
>
> The __NR_mmap isn't found on armhf.  The mmap() is commonly available
> system call and its wrapper is present on all architectures.  So it shoul=
d
> be used directly.  It solves problem for armhf and doesn't create problem
> for other architectures.
>
> Remove sys_mmap() functions as they aren't doing anything else other than
> calling mmap().  There is no need to set errno =3D 0 manually as glibc
> always resets it.
>
> For reference errors are as following:
>
>   CC       seal_elf
> seal_elf.c: In function 'sys_mmap':
> seal_elf.c:39:33: error: '__NR_mmap' undeclared (first use in this functi=
on)
>    39 |         sret =3D (void *) syscall(__NR_mmap, addr, len, prot,
>       |                                 ^~~~~~~~~
>
> mseal_test.c: In function 'sys_mmap':
> mseal_test.c:90:33: error: '__NR_mmap' undeclared (first use in this func=
tion)
>    90 |         sret =3D (void *) syscall(__NR_mmap, addr, len, prot,
>       |                                 ^~~~~~~~~
>
> Link: https://lkml.kernel.org/r/20240809082511.497266-1-usama.anjum@colla=
bora.com
> Fixes: 4926c7a52de7 ("selftest mm/mseal memory sealing")
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> Cc: Jeff Xu <jeffxu@chromium.org>
> Cc: Kees Cook <kees@kernel.org>
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  tools/testing/selftests/mm/mseal_test.c |   37 +++++++++++--------------=
-------
>  tools/testing/selftests/mm/seal_elf.c   |   13 -----------
>  2 files changed, 14 insertions(+), 36 deletions(-)
>
> --- a/tools/testing/selftests/mm/mseal_test.c
> +++ b/tools/testing/selftests/mm/mseal_test.c
> @@ -128,17 +128,6 @@ static int sys_mprotect_pkey(void *ptr,
>         return sret;
>  }
>
> -static void *sys_mmap(void *addr, unsigned long len, unsigned long prot,
> -       unsigned long flags, unsigned long fd, unsigned long offset)
> -{
> -       void *sret;
> -
> -       errno =3D 0;
> -       sret =3D (void *) syscall(__NR_mmap, addr, len, prot,
> -               flags, fd, offset);
> -       return sret;
> -}
> -
>  static int sys_munmap(void *ptr, size_t size)
>  {
>         int sret;
> @@ -219,7 +208,7 @@ static void setup_single_address(int siz
>  {
>         void *ptr;
>
> -       ptr =3D sys_mmap(NULL, size, PROT_READ, MAP_ANONYMOUS | MAP_PRIVA=
TE, -1, 0);
> +       ptr =3D mmap(NULL, size, PROT_READ, MAP_ANONYMOUS | MAP_PRIVATE, =
-1, 0);
>         *ptrOut =3D ptr;
>  }
>
> @@ -228,7 +217,7 @@ static void setup_single_address_rw(int
>         void *ptr;
>         unsigned long mapflags =3D MAP_ANONYMOUS | MAP_PRIVATE;
>
> -       ptr =3D sys_mmap(NULL, size, PROT_READ | PROT_WRITE, mapflags, -1=
, 0);
> +       ptr =3D mmap(NULL, size, PROT_READ | PROT_WRITE, mapflags, -1, 0)=
;
>         *ptrOut =3D ptr;
>  }
>
> @@ -252,7 +241,7 @@ bool seal_support(void)
>         void *ptr;
>         unsigned long page_size =3D getpagesize();
>
> -       ptr =3D sys_mmap(NULL, page_size, PROT_READ, MAP_ANONYMOUS | MAP_=
PRIVATE, -1, 0);
> +       ptr =3D mmap(NULL, page_size, PROT_READ, MAP_ANONYMOUS | MAP_PRIV=
ATE, -1, 0);
>         if (ptr =3D=3D (void *) -1)
>                 return false;
>
> @@ -528,8 +517,8 @@ static void test_seal_zero_address(void)
>         int prot;
>
>         /* use mmap to change protection. */
> -       ptr =3D sys_mmap(0, size, PROT_NONE,
> -                       MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0);
> +       ptr =3D mmap(0, size, PROT_NONE,
> +                  MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0);
>         FAIL_TEST_IF_FALSE(ptr =3D=3D 0);
>
>         size =3D get_vma_size(ptr, &prot);
> @@ -1256,8 +1245,8 @@ static void test_seal_mmap_overwrite_pro
>         }
>
>         /* use mmap to change protection. */
> -       ret2 =3D sys_mmap(ptr, size, PROT_NONE,
> -                       MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0);
> +       ret2 =3D mmap(ptr, size, PROT_NONE,
> +                   MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0);
>         if (seal) {
>                 FAIL_TEST_IF_FALSE(ret2 =3D=3D MAP_FAILED);
>                 FAIL_TEST_IF_FALSE(errno =3D=3D EPERM);
> @@ -1287,8 +1276,8 @@ static void test_seal_mmap_expand(bool s
>         }
>
>         /* use mmap to expand. */
> -       ret2 =3D sys_mmap(ptr, size, PROT_READ,
> -                       MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0);
> +       ret2 =3D mmap(ptr, size, PROT_READ,
> +                   MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0);
>         if (seal) {
>                 FAIL_TEST_IF_FALSE(ret2 =3D=3D MAP_FAILED);
>                 FAIL_TEST_IF_FALSE(errno =3D=3D EPERM);
> @@ -1315,8 +1304,8 @@ static void test_seal_mmap_shrink(bool s
>         }
>
>         /* use mmap to shrink. */
> -       ret2 =3D sys_mmap(ptr, 8 * page_size, PROT_READ,
> -                       MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0);
> +       ret2 =3D mmap(ptr, 8 * page_size, PROT_READ,
> +                   MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0);
>         if (seal) {
>                 FAIL_TEST_IF_FALSE(ret2 =3D=3D MAP_FAILED);
>                 FAIL_TEST_IF_FALSE(errno =3D=3D EPERM);
> @@ -1697,7 +1686,7 @@ static void test_seal_discard_ro_anon_on
>         ret =3D fallocate(fd, 0, 0, size);
>         FAIL_TEST_IF_FALSE(!ret);
>
> -       ptr =3D sys_mmap(NULL, size, PROT_READ, mapflags, fd, 0);
> +       ptr =3D mmap(NULL, size, PROT_READ, mapflags, fd, 0);
>         FAIL_TEST_IF_FALSE(ptr !=3D MAP_FAILED);
>
>         if (seal) {
> @@ -1727,7 +1716,7 @@ static void test_seal_discard_ro_anon_on
>         int ret;
>         unsigned long mapflags =3D MAP_ANONYMOUS | MAP_SHARED;
>
> -       ptr =3D sys_mmap(NULL, size, PROT_READ, mapflags, -1, 0);
> +       ptr =3D mmap(NULL, size, PROT_READ, mapflags, -1, 0);
>         FAIL_TEST_IF_FALSE(ptr !=3D (void *)-1);
>
>         if (seal) {
> --- a/tools/testing/selftests/mm/seal_elf.c
> +++ b/tools/testing/selftests/mm/seal_elf.c
> @@ -61,17 +61,6 @@ static int sys_mseal(void *start, size_t
>         return sret;
>  }
>
> -static void *sys_mmap(void *addr, unsigned long len, unsigned long prot,
> -       unsigned long flags, unsigned long fd, unsigned long offset)
> -{
> -       void *sret;
> -
> -       errno =3D 0;
> -       sret =3D (void *) syscall(__NR_mmap, addr, len, prot,
> -               flags, fd, offset);
> -       return sret;
> -}
> -
>  static inline int sys_mprotect(void *ptr, size_t size, unsigned long pro=
t)
>  {
>         int sret;
> @@ -87,7 +76,7 @@ static bool seal_support(void)
>         void *ptr;
>         unsigned long page_size =3D getpagesize();
>
> -       ptr =3D sys_mmap(NULL, page_size, PROT_READ, MAP_ANONYMOUS | MAP_=
PRIVATE, -1, 0);
> +       ptr =3D mmap(NULL, page_size, PROT_READ, MAP_ANONYMOUS | MAP_PRIV=
ATE, -1, 0);
>         if (ptr =3D=3D (void *) -1)
>                 return false;
>
>
>
