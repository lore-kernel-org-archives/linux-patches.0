Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C256F6FC6
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 20:22:04 +0000 (UTC)
Received: by mail-pj1-f42.google.com with SMTP id u15-20020a17090a3fcf00b002191825cf02so1183497pjm.2
        for <patches@lists.linux.dev>; Mon, 12 Dec 2022 12:22:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uvYrIVeVNpM030K546j+nbRNvrv3/oDjBsrNjhndems=;
        b=F3gbA2hsFQB768KZc2z1w0vQpRjsUaRMhxS7wEJab6ha6UTzWL3dsTL9Q2tFyOiKwe
         xBJVe1KzfJuTn6AfQhD/gFqjPFusopeUv+Dddeh3N9z3BNEGUskIs+Y8C1s3FqSoXyIA
         DTPtRA6htZohXuhTMW+vQM9VcL5CtXZCeaauyDfxwL0C2jNGZxuAFkbbmcp7gn+keGHd
         Mkm2a1hzJhAvPc0XtwMERO3mW1RK14ZRjmVX9XDeFlCf+JbNAxspUZh+c5bZKILMSOn9
         9m66RqnakYRWwD6lIrAXWCrockQjBNvCHmoONJlcJT/7xIBNY+qQgwiXeiyUlexs9MkC
         TBfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uvYrIVeVNpM030K546j+nbRNvrv3/oDjBsrNjhndems=;
        b=6G0OWvsjCJo0UGXpeBCXybNlrHeHL3y/c2vSGx7W1mSRChW0kurNQ2+w4c9WA1sSZe
         wciqA3xOeIdnxEowxwCgn9eVtDxJ7nG4sAPMO1Z44/UM8Q2xddppJrKPDdcYxTOLsW0f
         iA4SYQftQeARpG+wha3Xg102r8hxc/7XDH/G6quvkKklKQqljX7pbs/pisjxssV/C1kC
         sbhY7VXHhrDlVc8JBaYU/8mujdytOUEor39pEI1/s1WfUYPB5kuTeL0sCwpxST3K8esw
         /8KUJ4K1NTvEGIxQExruEqfmYqAAmQL0ocF1aTu3ly4R6ss+7HmPeU1hwWpy6H55kCE+
         NAEQ==
X-Gm-Message-State: ANoB5pmlg9XM8rLTptJNfTeieG/GjEEYDnL9PQjcCZu4tYrtd/1SXqbI
	ZylbVNW0Bl99FhgsAQLgrNs32Cm0vZ5EkaWrAyeI+w==
X-Google-Smtp-Source: AA0mqf5mkuYpxcDVcjWkwYHSIH5Ctk6uaDTb6OpUNz5t+yVD+2RSn4iSvbSZQaBkwJymSCNUknN5zCTTnPT91RbXg08=
X-Received: by 2002:a17:90a:740f:b0:218:fb5c:a762 with SMTP id
 a15-20020a17090a740f00b00218fb5ca762mr32141pjg.241.1670876524292; Mon, 12 Dec
 2022 12:22:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221212130912.069170932@linuxfoundation.org>
In-Reply-To: <20221212130912.069170932@linuxfoundation.org>
From: Slade Watkins <srw@sladewatkins.net>
Date: Mon, 12 Dec 2022 15:21:53 -0500
Message-ID: <CA+pv=HPEcrt9Ju7xYyQtJ_2AX7-aeZ46+4voN9_Xs4iTJgk17g@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/38] 4.14.302-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

On Mon, Dec 12, 2022 at 8:53 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.302 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.

4.14.302-rc1 compiled and booted on x86_64 test systems, no errors or
regressions.

Yours,
-- Slade
