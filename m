Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AF13D0924
	for <patches@lists.linux.dev>; Wed, 18 Mar 2026 11:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773834452; cv=pass; b=FATNR+5n4aOwrDi77dSCcJ17I0mKNMW0d4A51shGL/0SToFDxl1QEcTFnkUALE2Z9I4Bflti724qNo9FONq/gVTGI3v9VI3Opwa1sJjMfmrhZ9JCY5gaBrzLfXeUo5ULwSNXi8dzmxbmbz614JkV2bhywq67hGQ3wtNKoXCaYuk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773834452; c=relaxed/simple;
	bh=E3qBqwU/8UNmYPfmpxGyTaDCcrX1OikSY3bBJrMOiHo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O2ujbJEijxVHrvFfZDsAUWog46Gzu4a1VcmMFqKtbUtkRN9zU1fVNcKNVOZnSpmyEbj15c9Y3RgdvWxY+MiYG5CsG1OTmU7n9le97++zXqJx68hCo+jgppsLlK5B74vKD/IjzlrX6o7O16Euma6ShugetH/Qjc9NnLFIqBVcbco=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=ZEUOrEq8; arc=pass smtp.client-ip=74.125.82.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="ZEUOrEq8"
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-126ea4e9694so1866332c88.1
        for <patches@lists.linux.dev>; Wed, 18 Mar 2026 04:47:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773834450; cv=none;
        d=google.com; s=arc-20240605;
        b=dO8MfqCtpTdaBitkxJsj/SemAi8L/dryJVrkLhalXvL4BZBO6WH7qUwQitWBpQrrd0
         UJjsGk4Uw1XGg+TIrgYRQoCV2KqiheLYlMIUVNpw71VL9CNkyqGovtydHNu+KtIzus1g
         nbAFpI8n9UYiHye+bu7PB81LQUr5sSIm104gdsQG7gOEGWNLnmP/iHetj62/+nIpklrS
         VO0Nz/CTIjiNA1ZRZEoz5FeTIuX8mXb7s8Z3owVbeOmyTkDDyLxoyoXiKxgBZba3OrIs
         dmbzj1WnSZE0NbGgSu7UkF1Z/NkjHERG7sYwBHQuNGh0u3aUQB5+DXGsKD6HWT5lxJQF
         rVJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6EYF2SOiO0US3pkVoquFF4wX9nbAh0s9J5OFZoHyp6Y=;
        fh=KHHWNEhFj/VfPUwIjCYBIlbWsZtG8AU3o7riGl7NCWE=;
        b=TTVT/PnwfECNNDrD5QvMuXdakhlh2h1drBBFGP+KVUWnrGGckQQpBOQP/sejSoJWr4
         VFQ/6bWALH5En2DiqawcDEkoIUXRhcZhHaGE4w2Lxv9uVsi4s29kQa8SjSUzWCJv0ztU
         evRd0lxeVKsgr5krrjGbtMvQ/XzaLTr2cQBP9iyBWZCKphUzKxzpnZrWaQ1iO4YkbUtB
         8F9N35dlr0FcrCc3C0RRzHkCb2b3Hy94qx/ubh6cAwDfp9I1T3Sj1x4B0yVzt6YDNlrD
         P+qJxEiOAx2X7bozEzt8Rhzj8ERl5w6TBAufD7G5pyovB1QzWxcvBazZbiZvqsEMGVsL
         +BFw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1773834450; x=1774439250; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6EYF2SOiO0US3pkVoquFF4wX9nbAh0s9J5OFZoHyp6Y=;
        b=ZEUOrEq8iZhLzLo0g6Kd0bQvKzEDh9dQSoM2ntoaU1qTP8+LdUJN6MzFy7TWS7HU1e
         RS1/2JqRqg5TbDu9cVSymXvY7Sg1iaQRfXN1Lwtx6ju0+mETNSweMRJuBhkENVdM71K/
         TFrGvQqDjyJHADEBg0c+VJ4lJ5VNcampyq0Nbf7cB7TM3gt7o8IomsvLqefM1EBxDsFA
         NtrV/KD8vomOZrmKz56h42OpVaSfnL+9mwB9ZNVlYg7lrETf68IPH4bSoNG2hNIDlo5x
         xNcngq92o05d2sxd5VXZjolwfmAR4iMP5FigU/MdHWTX8kC20Qk82hJS/EdqlZ0TFwN5
         lmDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773834450; x=1774439250;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6EYF2SOiO0US3pkVoquFF4wX9nbAh0s9J5OFZoHyp6Y=;
        b=IOsa/tD054yItQZqBFMkb3iyYfJ3B6yOqgxQy+ru2fKMJcXUu/WVPl16vMQabeIBd+
         gl5v15ffR/DinAMHr3TrDBRayMEf6t3LL4HAJUrZcPHo0OIFVlFhOfyher/q/LNO7GAz
         cBDUsIxkskaZn01gZ8FG1WBOGOcKrYwV+ykmTdTvwfbHnC4dh0IzokIfenSLeephr6Ch
         4vyYr18TGY4DREwn5i4w3lFrg6POPiEqocOfpJ9m6zZPGzKz6+AsTM5HO7qJJdY4m/YR
         8/cvhDmM61/L8JZ1kc+riF19NXAU5YpVSMuqS6pzEZj7pDilCWQ0iy2uRlVXLnIEYnoH
         3fAA==
X-Forwarded-Encrypted: i=1; AJvYcCWOCvHxXCGVNvopD6TGaNFdrcp2gb9W2aqvly8GeGyicMx+ce5QsNLtxX3MWwNaZYCehklmpvcT@lists.linux.dev
X-Gm-Message-State: AOJu0YzpAGXVXEgv0N43i77A3tKhvv2ATHq69AyLBa75Nz9bQQJs7gqq
	SsQFkv6WvFBUoui+Nfwed1/vvOfcvFtdeROjmzElG8jiqlUPZqQe8YDHiSl/YUqm921dxifJHdT
	2+6XdiCyVyZp/fQL/OFYuTN0ppEXs/6nU3SqZzlATZQ==
X-Gm-Gg: ATEYQzwFRbOP0ZNkrjboICwoVwzooOa1D8QZp0Cd5udED5Uc2X8kD8pRT5gAOec4h2W
	3PJs6DsEjJWmNtfQMwU/KFKjDZqEJiEq6+s3whDUinrmlzPxUC0tNhE1j0Mtxqt/w1iKhpy5jyw
	z4GoB7w9Md+y9Dpav5AniLLlWbijP+GACpOO72GqN+FnL1oGVyss4NIKMSflKTRsct0aSmkNNEF
	KSHkpED8Ttm2nv8Hr8nTD2QCAla7ieBYrtL/bKeP8iE1gtbA+aBnlWGgy+za3cKMYcIF7emiCQa
	Uf1T0oRW
X-Received: by 2002:a05:7022:6a1:b0:128:d752:e076 with SMTP id
 a92af1059eb24-129a70d21fdmr1617987c88.3.1773834449597; Wed, 18 Mar 2026
 04:47:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260317163006.959177102@linuxfoundation.org>
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 18 Mar 2026 20:47:12 +0900
X-Gm-Features: AaiRm50NjHuUz3mp4Te1JOKZG2_t_c9Y_gOPCaKImhLf1IGNd0hvRcwLZ5jowZ0
Message-ID: <CAKL4bV6scXrnea-QFxNm-2p5UcpBAg=VOy4UJZhmh8guyydGRw@mail.gmail.com>
Subject: Re: [PATCH 6.19 000/378] 6.19.9-rc1 review
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

On Wed, Mar 18, 2026 at 1:43=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.19.9 release.
> There are 378 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Mar 2026 16:28:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.19.9-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.19.9-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.19.9-rc1rv-g4f987e117969
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20260209, GNU ld (GNU
Binutils) 2.46) #1 SMP PREEMPT_DYNAMIC Wed Mar 18 18:51:42 JST 2026

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
