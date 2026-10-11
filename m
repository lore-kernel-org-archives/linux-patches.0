Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09EF1B87C9
	for <patches@lists.linux.dev>; Sun, 11 Oct 2026 01:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791681967; cv=pass; b=IOgcAz2WAWXjbPf2jgkcF6D5I7hKmE0xkBeiknprtuzsCiz3hw//zqmYqFki00FZVUHfVd1D323+MGLoigJ8NgMttXI+jAulZvQ9mLyoYvp7jbsqSB3x/47SQpwurMBjnOK41GOxT8v9ZV3aoPD8IdxpqFL7N7+QQhgmOybS0DI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791681967; c=relaxed/simple;
	bh=4AOaTpaQq8Voh+cFkgg8oIDZlCp2f1Lf+Q3dWmXSF0g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Wo3NSQoChLSz/ANzIVGpxNlhl6BlsaaVK7N8eu+u8/T4uWmXm832OkkV+1dwhq6eDjx3l6rX+jkv8AbmW6x2jVzGeIxTMS7lgLpEA5XgujGwLbi70WOjNkvFgO3sKCPTkU3Syy9PVYKwdGgsR4k6eMz7sxa36+kUKC6VEtYXNSk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com; spf=pass smtp.mailfrom=sladewatkins.com; dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b=GPFCp3an; arc=pass smtp.client-ip=74.125.224.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b="GPFCp3an"
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-66fca0709caso606161d50.1
        for <patches@lists.linux.dev>; Sat, 10 Oct 2026 18:26:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791681965; cv=none;
        d=google.com; s=arc-20260327;
        b=RLqopJ3PX80PYECS6S12rgakh78kBiC/QCrxSxXXW7iwBXPH6AQdEcFSLWJkxgIYd5
         fbaCT82N/1CtBGBMty/RkKlOmEisa3pccB6BdSbKH/0KKGU510nVeSrVic/m2zNmsMGU
         zzvsiz+mmUMYCnLsM7R+IfYXrLMo4AbUkdYE0PxFUgyHpclAf+U5EzwR4s8CPoqm0K+9
         tbFGwqKqzU+oulCI9nr12ZqmDkEkguX1N3inLMk5HhxRdfClmJtkKqO2Y2uEn9SqjFzk
         CgwZtLfLA6uxMPNtwKqzgHp45X3K+po6PYXjzsGR0F5TjbeISNKbEEGzzmiSurdTLRI6
         HBcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Z9yH2y3goTIlD1nGF+P4iDsFdwyaI9RVJU1CXJC3Tro=;
        fh=kAj6X1i15QK8elBHnXTOzGgrXSyN2KyibI3un6OZ3nw=;
        b=iVBm9opHBvaTyRm1qxTlEJ41WSpiq79ybcCvUVt9CZqcGZVwYpnMaW1JdkMNIIE6bW
         nty/zHl1cmfrW4Id/sP7kp2ZZ7GofwEVnxf95aHYpbqNlNeJXxaqndmyPFQht63nxTza
         9omlKpZYbHYlaU+L4/4mpdxeEIBGA6y0YJM+a7ojgfUjgQmkwDDrpNLJ7G7U4rShfamx
         q4nUV/QiiqonKklBB68xmFu4TcWNILm9imPEyUlyAYgFNXOgRNSMO/hY5yhrOF63Mr1m
         3lK5NQC9KbKmuznAI/0n5CKnjb+4iWzpK6CYFrO2QZozK1aoLW3PbzKp+O/gFuXuwQmp
         XW/Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.com; s=google; t=1791681965; x=1792286765; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Z9yH2y3goTIlD1nGF+P4iDsFdwyaI9RVJU1CXJC3Tro=;
        b=GPFCp3anTEsFvwGFiXRvTgcvWdYJgfZizkwVsQb12DHOYv1gxWBb919FsKL89qXiFA
         1OLl6z2U8OVlZrw5U1TImPXbSoz9Ww0C1gO88ZKGtQnVAEpJQmuh0/uN2i6GEsASLhpH
         hI+sEKPeFYpELup5p2iyOA9gWtKim8enOS9SCW1ri1taeIAxEoxvsTSrWKSEje2KA4uD
         Qxq91X0mwocH45r+tLRpb3srAMWj9GKJdgdkyf1yvjpjzw1se3dbthGXrJsxQbqbfI7H
         7aaEZsgYjKK2+HE4w3s9V8UgR02C0G25IJbdfcaf2LkY4YjW+1gDl54FXm0xbDZ5d4Vk
         fSqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791681965; x=1792286765;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Z9yH2y3goTIlD1nGF+P4iDsFdwyaI9RVJU1CXJC3Tro=;
        b=JwnSKzb55evxqRFoMlB01rPWyFqkferwDotuWXN4cyrjBq8mMqMF0eM762tpYCrUjO
         E9J7Qee6//0+VFMiUxTfE1jZfJSpMtPEPNdUk/BfqyJpGYkuUhQ+lr15YLIz/qKebCL+
         do4dx0pNz/4+gFc4EP5MyQRJEHDILMeotb5P+g8QuXSXpEDiUP5SaH0L8BAgjmw3gfnb
         +uTatzHFlak6k948+TllLzUsZ3GgM2cBI++SiSJpio7JrRG6lXESoKJWO20bQezFK8Ai
         I27nuDF6BtdQx48Y+NL0HJdBMZgzaVdARmdYIeYJaaciNcr38wvJCISCj+wZDziW1Az8
         GUpw==
X-Forwarded-Encrypted: i=1; AKwUvBypADFz55vSmf+yS1loklcyysh9gnWYZiNKF17cjcU4GlYwuoV5naFt9Dhsx5phME/mBYYqaMRA@lists.linux.dev
X-Gm-Message-State: AFq9FYLDdS+vgS6EHgovUqEDS7xEfwgrZLluFox+Qr8zNZd4A9orbUw9
	AIGgIYZHIpetZNwKCZCElT+2v0jDUQjt77lmPuS8e5n5QdEGfrsTNvXOulLh/IiDY4WRqcLxQdI
	08KEfrnaRxRgtpnRu3PQoRy1PkQFVLFq9MBxCVadmC4H5cBovvcbXfBY5BqmU/YadIr9EQn/CK0
	ESdOWcR389sGQmABw/9340h8PG52ct
X-Gm-Gg: AYBFou1i0tLBuPQG6U6RUYmimvL//vS+u5T1ahZ0XZRTGVyQkhdlOcRv98uq1J7VAc8
	fc0+hhvQJcHVXkOWeJ9Y5+qRJ1lG22OtEaW+VHwsE7Psxr+/iyegbblZlF+QUWJkySyGLtu9AjZ
	JwOnN3uvNfB2AuHmBf11yboJbcngBoK4TrSJTMADTlPzWfeqnzecYTsffkXzd5ypcfkqKv6oHIi
	DD7Vfy43b5eiOsvNLXHW98AOKKrL3ncpaNVywnwi90OEF6NxtcLoHPxIDD36x6WgpB0YUiWzilJ
	lYU9vxmWnmO0JDUtRykYhLwK4dWKA4fzkwxKiT7R+TYzk+gWi/Utyay1Bb1njViRm88fKJGJIri
	gg8rs6UFnH6c=
X-Received: by 2002:a05:690e:150d:b0:674:a7b:a07e with SMTP id
 956f58d0204a3-679362715a8mr1849655d50.29.1791681964629; Sat, 10 Oct 2026
 18:26:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261009140946.008206689@linuxfoundation.org>
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
From: Slade Watkins <sr@sladewatkins.com>
Date: Sat, 10 Oct 2026 21:25:53 -0400
X-Gm-Features: AclHuK-mPjRKtEOxbIaB0PCNQlzkgcurHHS9ajfoSxGLwQ46ONA1zvOrJKTSiuM
Message-ID: <CAMC4fzKGfW=zuJYCYjh-i5Z7_1568SSB4k=HGWP2ObLfzsJyug@mail.gmail.com>
Subject: Re: [PATCH 7.2 000/428] 7.2.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rogueport-AntispamServ: glowwhale.rogueportmedia.com
X-Rogueport-AntispamVer: Reporting (SpamAssassin 4.0.2-sladew)

On Fri, Oct 9, 2026 at 10:14=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.2.10 release.
> There are 428 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 11 Oct 2026 14:08:23 +0000.
> Anything received after that time might be too late.

Hi Greg,

7.2.10-rc1 built and run on my aarch64 test system. No errors or regression=
s.

Tested-by: Slade Watkins <sr@sladewatkins.com>

Cheers,
Slade
