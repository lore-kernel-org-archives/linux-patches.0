Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052013D4123
	for <patches@lists.linux.dev>; Fri,  3 Jul 2026 13:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783084324; cv=pass; b=iQ7gQPJvvzisJHHmbAPvTJVgMWU3b4zBVZIxJGI72XdMohP60IgoEwPU5/IZCsGiPlxh3v9cznp0Q2QRUw7vTmt1UegxnENEx0Ypo6eJy5j+7t+tBvmyTNN6AEBgBNDwt8gQXaywtk2qYgwjCosfA2VLervoemd7NW2+WtkfRJ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783084324; c=relaxed/simple;
	bh=BZ2c/iqj6Fnv5DHCt4xFCrkQIdu6CJdZKHyHErvXts4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FeoOonvbwczBOBcMEEaYEm02QLIdPDfzhedv9juEraWO15CwtIvkl4SBcZcP7ifxc9B8ao/onSm2sBJNQGD7zWPlptRC58B14kKXJCu8HwBDHe8yR8pLM0oNSNKFTIDpMpoAP3WEWlMMcHUeRRiYvNozv42sD5h5C0ocyX6T59M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=qQl9hN96; arc=pass smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="qQl9hN96"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2caea3f742bso2891385ad.0
        for <patches@lists.linux.dev>; Fri, 03 Jul 2026 06:12:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783084322; cv=none;
        d=google.com; s=arc-20260327;
        b=rK5uzGLoiZSOfScfW3x0oKFDCpZj4gCMwY5jdedmDP7ydIxrjNMMRCOGm9wZTdqrG8
         Ew0SHt+Ie16vzEU9zzrld2ARkWJOzTOzpEHKN7JgXHU1ZPJlT5xlQvkeogQSCJk88YLA
         OtuTW1dpmPYYh624lgx5mqXqHpRotJbL2AbBX9DKE6kJQazX1zowbDPlwNwXdc4Ca/Go
         ztA9cvzg1g9sZlgIbkMWRmFdDyoYxKVokE/FcQ1OAwPd6iSroelShOHlVhKah4FvGCp3
         bJMXBPvlaEiV9gNlh/XL1z6CDJD4kkNLJAyLsRXIFU1w771aTV4cynFNyWeC67HCOB3K
         OtRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=X8lFHiTICcGdDsPowE7kwVw6KbJBWR6drjVQi7KGbu4=;
        fh=vDSkn9SCqEub7Lv/J2YBZG+LuNUJCa9jRZ3GvobAr+k=;
        b=gzXsy7xyY/m5yRW4tYckJjGIfZtjHEEj7WFhlzAm1DEiRFIq+S7x1J5A3zqb3b9dfv
         25lZzhK1fyu07vYja486jqi00ygU3KGIFVh6MWskpPPuZc597XnCDkiCbdmMCVaAr/Hb
         sJA+mT+T/KwBWLAvkS/wF+WtAgq5rsFUaLx5GjEje7bnVVes34PN+YxGcBgn/EgGNpwW
         Bv32cqzyQ2DR1uLjvSs+NFNqQMjaX+RWPiDubV6vlsS5wKrT48YzSbpFkuE9iW8FC8V3
         qIBry/cqv2ccWp57VhC28Gc6aDjrTZgKy/98KfBdJLcrOhPayJY/LFS/CfJt9rjCMv9B
         o3eQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1783084322; x=1783689122; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X8lFHiTICcGdDsPowE7kwVw6KbJBWR6drjVQi7KGbu4=;
        b=qQl9hN96eQzWucRBYLlOJhDQlpL/9xCkFGbn613UXAFY6N3GlA7AbFiO+L+jHwKPL7
         ac1j4jGWiATec/2vS7NKhGn+ZtpGM+GNUTd++IeYCw9kMRyyoBhypWceA4iAWvG08Dn2
         zH4e6v27jLhEcoD8PJVCkR/f5wg9Eh2pXOKUyEeC+UULy6+WvhKvBrO9tMlqbbcJFhkp
         TBUbdlwCdntTdDOSK0oGBGmA2Xp/QUrQjp09vuDfKPWyTcbWPFv/5H5kpDecBxnvzLXT
         z0Kj/cP49UQWLzA6JKMOd9+/WreMVdUyfUcbbJ3DtUUkGu0NqwMBLMNM7018YAJcMFcU
         cMaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783084322; x=1783689122;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=X8lFHiTICcGdDsPowE7kwVw6KbJBWR6drjVQi7KGbu4=;
        b=FH18pe6Nm207LZpZcbz5Abp7ySBD9MyUDg8uiN3pT/lT/1c6uhL53MNRq3tyoKv29Y
         C3Tks9V0HvENmK+od5kaeXhOFMYR+0IuJeJ10FbwqdqlbZinpp2kU3U+OvM3onxlyJUh
         7m68j8+lBwyhYzXuiDKia4917ypB4CCDtFZtRIIaEAVzjt7bhOT7iBzSA6lG+mOAVEqo
         TR7gdoRs0OBeJxBpN5VrtVRi9Eyc1i/CmEEPQvKAOn6fsOB6qpQ8EqS5F8Ga5HloqSnm
         2r8Pvhwp+/IWcvsqRY/3YgNSo5IJTQrNmQ9TAOAxgvdeykshLwpqTVh5/Vfsd7ryKZD3
         +a1g==
X-Forwarded-Encrypted: i=1; AHgh+Rprp8ix/GGAadj3QvDIRG7D/rT9FSxwa2P4PaljaNCICvapypIRA0NjtWqSdMGkBlzKN7I+ce6r@lists.linux.dev
X-Gm-Message-State: AOJu0YxuHjH1mwvPa+oNJvE+G4i90/sIQ2qbrO9k0jzjVOV3PMMm/FQH
	TwLsOpYfbRu8y5kTqJSg4aFyDxSj7oyNRJXZMTXwDDsFz9/leg5UFLRQ6A+QKWdA2kSg8WUvUk/
	M4U/oHYXOUNjmCKHX/4aoJJ8eMA0eGenbguoiFloazA==
X-Gm-Gg: AfdE7cmQm7XRbuL8fsS23mGUUpNhCdfEpAvY0Kp3/ejdghVgfbzyTDwiW5Dmd7K33Gl
	+mzf/893ZI4yhecOmLcuJnUPRP3fftsRIQ3BE6kIKKUSRLOIAgzIu4oJ4XVWT4vfPEHdS8AyllY
	T0r9KxSSHL09PYb4VBxh/9XdY12TT4D0B+s+P5GpkLisZAAFsmWcZSqAhCL/hKSvgtMuM5wAM+b
	G6Wyk3ubSdtDbPEnc6H+sTWW7LDgOriF/yO5cjeSbSm8RPzgjikvHyfskmNNHdP2UthWkGSUhjo
	gsn9+TVcXF0/7GV58YUigyE1DwiPqw==
X-Received: by 2002:a17:903:28f:b0:2ca:4b7a:4a02 with SMTP id
 d9443c01a7336-2ca7e8c7cf2mr112714405ad.43.1783084322026; Fri, 03 Jul 2026
 06:12:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260703072822.817328079@linuxfoundation.org>
In-Reply-To: <20260703072822.817328079@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Fri, 3 Jul 2026 22:11:44 +0900
X-Gm-Features: AVVi8Ce2RGM5T3Pwi8q1vaGDUDYf0lIKTSVCyW91KIzXyuDigHkXVvd2rgHcDD4
Message-ID: <CAKL4bV6CGp9+uzndeOmJtpOsda_iAp6Cpavdv6fXC1Ek3GWsYg@mail.gmail.com>
Subject: Re: [PATCH 7.1 000/121] 7.1.3-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Fri, Jul 3, 2026 at 4:38=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.1.3 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 05 Jul 2026 07:28:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.1.3-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Linux version 7.1.3-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 7.1.3-rc2rv-g19dde9778fd8
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 16.1.1 20260625, GNU ld (GNU
Binutils) 2.46.1) #1 SMP PREEMPT_DYNAMIC Fri Jul  3 21:35:42 JST 2026

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
