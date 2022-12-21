Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486F7185D
	for <patches@lists.linux.dev>; Wed, 21 Dec 2022 01:13:24 +0000 (UTC)
Received: by mail-pg1-f170.google.com with SMTP id w37so9456846pga.5
        for <patches@lists.linux.dev>; Tue, 20 Dec 2022 17:13:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=I8j9TRWymc2LoH0eKyaoIs9UEkksGnz4z4IEp1BW3rc=;
        b=hjDV0Ac4ho85L/SATVrnhwahrjMc+yi+EKel2PCOPLb84/eYkQkvYkigo2zCbuCBQr
         Qr3V0E1rdjOesLtEzyZ9O9UtmFbS4Z1MAy7zFVaVlsF78dkA7VkiHfhLUpDbxEY8icw3
         fitJKcWFIEyv9KTvAQwacpFOw0IchY3fZxpgYpCEt7+pvTkX34waMaj1TwlU6JO6F9rU
         hGU81NqMke+yzZomf7phHpH11VobXjQOQwYIWLzA95FlnJg/aqz+r4Imr9sD3RJAGrkZ
         pe2qWc4XiEbz7HTG1n5ylkkCrnOu0S5G+9nOwk9ViYzzi39kCfb0LLXErc9rL/MG0Xqh
         3Tlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I8j9TRWymc2LoH0eKyaoIs9UEkksGnz4z4IEp1BW3rc=;
        b=utmyLFc/5gselKDtgwt5+tHPKUq8IGX4Or/WYJzi4iE2ibQW9d2lgiQSK57v9+zXG6
         /Ifvf1BBvbpN/hj4boxcym/PgpLNijlMxwV08XK/nLTn0lZrTASe54em5z1+86smgfKc
         AT+VcBxbxcJVasvFI5VrXfdcIjvtKhSTIxUj/lobdn/u6r6ZUxRiSNHoOAON4oKIK7Qd
         1wJntm1ty5YhptCMWkPTAusHk1/CL2EaQKKskW0ORUwRhd6/lzNcxX/EE1vQ3W+KAsFd
         YSiIb1s51h0KiFgrShwxLTefPKVlS9wJoo022Gszo8ElSnh9G+dEtGIwp91Rs1QRgHF9
         m3Og==
X-Gm-Message-State: ANoB5pmAdv0494JT8j0/fC8pVoLUYgN+CjAYgp2hBHsoRWWzHNo4MwQ0
	UMMNq83TVqbmFcJA8MembLwMyvlPZO4SxNxOvvSLug==
X-Google-Smtp-Source: AA0mqf5Dq4rrq3kxKwTPoA0dfgN01W9r5o0Qnonh1YEBT9OKXCCJjiIlbU87kRlWm2kl8ZHTpnXYHINwH88Hx+j92K4=
X-Received: by 2002:a63:110d:0:b0:46f:6225:c2f9 with SMTP id
 g13-20020a63110d000000b0046f6225c2f9mr87648713pgl.225.1671585203356; Tue, 20
 Dec 2022 17:13:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221219182943.395169070@linuxfoundation.org>
In-Reply-To: <20221219182943.395169070@linuxfoundation.org>
From: Slade Watkins <srw@sladewatkins.net>
Date: Tue, 20 Dec 2022 20:13:12 -0500
Message-ID: <CA+pv=HOHmXyiiLPJkcHChGMRnxsCiQV3rY6B0uzRsAe0bwb0Fw@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/25] 6.1.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

On Mon, Dec 19, 2022 at 2:23 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.1 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.

Hi,
Compiled and tested on my x86_64 test systems, no errors or
regressions to report.

Tested-by: Slade Watkins <srw@sladewatkins.net>

Yours,
-- Slade
