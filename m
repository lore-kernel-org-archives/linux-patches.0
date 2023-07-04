Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D22566B
	for <patches@lists.linux.dev>; Tue,  4 Jul 2023 11:27:57 +0000 (UTC)
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-51d7e8dd118so6921924a12.1
        for <patches@lists.linux.dev>; Tue, 04 Jul 2023 04:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20221208.gappssmtp.com; s=20221208; t=1688470075; x=1691062075;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tEHN8kv/zUiWgy4LCdHK93+q2EPHQUuAQ4UHUBp2+7o=;
        b=TMKyon/RMqj8v3axB/OMKH7FLtiDFJ9dKfeRHovlqyfJE5uDkbvTNEg8qdIT3Blp/y
         rcKityLrQhpDrrLqRsd30fWApdFILzX+KuXWhzvQID3oN84HJfrmkt7os7WgoLxii2Xm
         eaUJ5HCnwOODeVMWFTxV6H62t3UwAAProjDxgam7RL7jccDLRU+1vwoNq80xLiSgkhL/
         /K/IpxfgLWm8SaXpx1JmhV2EfmKj95/0Kxe3doqE7iE8F0JPiCJAzEtcSLStQE7uWxDM
         a8KK7/R5rsfN+cIHTmEvRgU/OyVuMUcY9akXi8EOJw6oCTWPJwhc2GQecvqLA/sVPQ+/
         ItiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688470075; x=1691062075;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tEHN8kv/zUiWgy4LCdHK93+q2EPHQUuAQ4UHUBp2+7o=;
        b=EmMK4FkScPmNXs6R1B0iMSSr+Fc4eItwY4ArCwxw9ic6KaWZ/oc4cBw2N9up91Rp6c
         2hwoRXww/SX/njDVpHg7XibDjdAQibX/qA5GRd2yc3x26Yb6u4AVh6BerQ3/i+ma3xF6
         5SN0yvHL4Pl6Yih6Y9rTwuQA1SOaIGu+bTjtl6+nirseObjfFZXQNeT+y5V0LmVCwEVl
         82z8u85WGAnCNVQozb4R0Xv9i0PCA8DBGi6V4FJWsHkJwCcWQiZWmBz8xgSFrthuOwLu
         IxUqxCNuKllHpyPsy04aQqoIZ3/uamfe6paXgmmoeSFyt22zFRQmvB6BDCWCowsL4/LL
         MMQw==
X-Gm-Message-State: ABy/qLaikI65F/zesYdbqc6dEBvp+3e0oZNaBFJICd2r8mQAFgFJJcmn
	1I63q2UTqLplKzzjlZ3T6N44niOmLc2BZEwIJ/CskQ==
X-Google-Smtp-Source: APBJJlHGu4FFmWCFmb+vUNh9gFQsSwpK9KXjYVAgV/FEhd+i6bDEYar8yytbjOvvBmWmwyyYiDsyRN8kw99pc17rxrs=
X-Received: by 2002:a05:6402:2ca:b0:51d:955f:9e17 with SMTP id
 b10-20020a05640202ca00b0051d955f9e17mr9928219edx.16.1688470075098; Tue, 04
 Jul 2023 04:27:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230704084611.071971014@linuxfoundation.org>
In-Reply-To: <20230704084611.071971014@linuxfoundation.org>
From: ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 4 Jul 2023 20:27:44 +0900
Message-ID: <CAKL4bV4H62QdBJ7G6=QpPRqaG+OkYJ=F9HReS+oyGzKpUCDTNw@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/13] 6.1.38-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Tue, Jul 4, 2023 at 5:49=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.38 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 06 Jul 2023 08:46:01 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.38-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.1.38-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64), arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
