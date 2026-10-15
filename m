Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702F350C2A8
	for <patches@lists.linux.dev>; Thu, 15 Oct 2026 10:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792059591; cv=pass; b=Kz9hF1IhT77tA/h1Uy4GmVL8hLdnrsl30nWS7BQ4WOwGfQMye7woM07xuQEHGuOxqz5z+zE2m/v91VdfERcKbLluNAzx3nUU5wMTPw0fpQeAGHBpvSfV+e4aoBvJoSG56ZC1K2qG0R6tUqnihC5s7CFjByRj8jcdx/bCsNGyP+U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792059591; c=relaxed/simple;
	bh=aLnGdcn8SVT+l8zY1DVp9E1OXpgrWCKYi41UBV9MLZ8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OoSVYOuCwbm2KiBlZdlniIbNrpBEt6gonq2nrv1gLwSgcpUKFqrknAMoh5zBsJq32S/UShVU0lZA5ix36xTXaF9ZpuFJzPoN4zSYjUoQnkUIfAOwzhgAEaJlTYZkQuIY9zVP9LSkU1lRAqPjxLo3yhVD/L+mZB2c3KifQPTz04s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=oa2RbMmt; arc=pass smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="oa2RbMmt"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c2e8e738ae0so902848966b.1
        for <patches@lists.linux.dev>; Thu, 15 Oct 2026 03:19:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792059587; cv=none;
        d=google.com; s=arc-20260327;
        b=Ys5+0uktmomR4+mFZb7ISMyTcRx1T0XGxJRPJ0poGW2+in0E2WYDH5Pjg8+/HwdKvI
         EVtqtYhb8chRTufT2n4rCUlTjmZLzQ/HRa2Cvfk8o2ebOUBdVawvoQAhl2cTp8ymXz0s
         6olxulIvfoDLGvj8CNj95Q4R7+dlTyG64Nqc61cZWshG+PDYL5jpuIte+cYPCLPiZtac
         0/JboDfFZQwPxJOmXFayDacA4C8CZSBfRyvPP/VGUltFLX+qZHI14SwId+sZaQOeYNI0
         ryOJjtmT2ksznxu9eh/3L24e7Ep4DAui7eDKqYL5kwrk7jw/tZe7LPdq65OEaCJkF8F+
         vtkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6G9qdhvcH8NEbAp7bRobDvF91lk/yeFcW7ZExqFVdy8=;
        fh=GQSQyqNuqonVaWc7ovXEcVYIXQJtQd3BeXCyYYVioPM=;
        b=Kv0tae21lNebVc+hWse8bQ9N2t9Q5yVm0NLVnIYkK0yH8yu9r0lNdSQriNIuULI08q
         SXT1MU77nzXhPimqtrU5HXff0dcmQiYicCkvUHr2jQum9rUP8kk39/LdPbGfk0lZI3Sh
         dM5411daTu6E0iZEwXaa78yP4fAzAK2B+gRnSr7d1WfSicKsKfOynR2L8MIM4rZyH+h0
         gBjI80bGoiJQXks4iIQdseGzY+wtEpczTei59H1+fZBMwREyAPFUL/xCSd+2Stol3Qfk
         zhyvwKYc6WBrwCnPcO2kzxxY9X1TS0yEOyjddPD0NJdiCxl2p2YoFGhF/ly9aXAijzxx
         Wquw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1792059587; x=1792664387; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6G9qdhvcH8NEbAp7bRobDvF91lk/yeFcW7ZExqFVdy8=;
        b=oa2RbMmtpzXE4S6/oELVz7uPrGX/TIdaE0NDv7sqR2RM3F4B//Xdj0WF5cpCupbAY1
         Lx8TIS/FKJjPAZ+l3I12+BudUC3144jyWDUDuXDgvMRG8fyYhfOw/7GZrMgQSUIndM7A
         kQbB0uZXAodfjdUL5xvkQGr14w7KGB4yiSSs+it7+iC4OmWF18ER2e6aV9xtW6bDu5Cc
         1rbZb9fcoRj134YWi0Q6iXL3+6ARdLHKF8LA4aCMDeFEmrZdUssXlHciyMCCes+D+vF0
         I6Bd7aYgl502h20K5eCsG2lda1FZ0IMGrup0Q4kQrGT0lqSEfkCOXWqfh+XeL/LWYx2u
         0rRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792059587; x=1792664387;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6G9qdhvcH8NEbAp7bRobDvF91lk/yeFcW7ZExqFVdy8=;
        b=p9yhizmDGERDNfQmeSC5qeTXpZfRZX/lfhaSShzIbmgR6EtN6ROrbZMk+lnY6FeRoB
         wp8vEhu9X6cOXsciAFNcc6Qi66sK37ZHYSg52N52K1T8hCm3ME0lcE6Ti8TMCKSBoM7j
         WLqQT/kmYmTSd0UCd/2wqflfmRz4btBsmM5ZD1e8+5TNNuzHpUvrVHSN+1XPyFQFxDsx
         aD2PAQ0xx7g3DaM1pt9wQwftSqEArtlKEW04h5cXqh8k95fYxLmBOTCtMVTF9UrdyNta
         iz8InKlSnociQOnJuulE7NVCgxspW0L7xnfhF7Pon+axt0Fsf7prtHPOjErgKg1FGq7i
         MiaQ==
X-Forwarded-Encrypted: i=1; AKwUvBx+0XIaGMAWwV1lWl9hu6oZVSkdpLL5qPHFn6MBaGsNgiW0aU48kwaxzAXYS2xQOBGBGUY6CkHX@lists.linux.dev
X-Gm-Message-State: AFq9FYLma2LRYrgOCdO3a0Ta6Czi8ddi+U+zPmZan205PByzSgFb5AXT
	fXygr8yIntw+0DO58NyPvX221AbnXTdaYz51rW032W5WibLKy0o4uMtDQuP+cnzriLll2ICq/Di
	tmzuLzgVRd5ZchpBumI+vPx5HQ58/gGr7GRePBTx9oQ==
X-Gm-Gg: AYBFou1taNRoEQGZF4dHnNKlGLy2LdKtV7hu8IUhmO/kLaQt4YjKENvs/el39k6HyFb
	Rk7/QlRs9ctN6hWLhM7WpJvQ1wbjwLhkP1EXfT2QoUS2E/cxrSTlOrnz3B+PQEZz+2fDFiYJFHP
	YTlICj1U6cQ22HAF1ph6Hzi74ZoFzeI6GWhwH6NGcPmMoRG+Dsjhb4iM02q9D2Wr7QKwV81Q1fc
	MW1iVWF3OUzaNZ7CNqZw00l5EXkrr7feeSFWVtQLzYBT2dVngs7iq+eipgO45sfP8wjKmF+JczS
	dH0AisoPEpyT1/4XOnSxn2c3hgoNprskQjFn/4QAbSMIo+RP6y4/8TY6eJodrtVHmA==
X-Received: by 2002:a17:907:7fa0:b0:c29:4490:50d6 with SMTP id
 a640c23a62f3a-c31aa022de1mr1644018966b.47.1792059587420; Thu, 15 Oct 2026
 03:19:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261014123758.782265692@linuxfoundation.org>
In-Reply-To: <20261014123758.782265692@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Thu, 15 Oct 2026 19:19:29 +0900
X-Gm-Features: AclHuK_fNn4KLGlruklVpvCw979MIpATa3NA0dr2zzs2gEVM47exlU8CVc0L7T4
Message-ID: <CAKL4bV4yy39e_UswA068F9favpRSmVbEUMqe0cQrFNPJ8EB2=A@mail.gmail.com>
Subject: Re: [PATCH 7.2 000/284] 7.2.11-rc2 review
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

On Wed, Oct 14, 2026 at 9:58=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.2.11 release.
> There are 284 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 16 Oct 2026 12:37:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.2.11-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Linux version 7.2.11-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 7.2.11-rc2rv-g62eb344d00f7
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 16.2.1 20260810, GNU ld (GNU
Binutils) 2.47) #1 SMP PREEMPT_DYNAMIC Thu Oct 15 18:54:27 JST 2026

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
