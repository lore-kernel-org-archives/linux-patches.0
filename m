Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0309719E64
	for <patches@lists.linux.dev>; Thu, 11 May 2023 14:19:30 +0000 (UTC)
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-50bd2d7ba74so79823675a12.1
        for <patches@lists.linux.dev>; Thu, 11 May 2023 07:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1683814769; x=1686406769;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C/W5GB4E38fHdQpL0SzJkoknJdNzqLnuSIkNSr13Ymk=;
        b=RNTRx2N4n4mZOMNUrqOjHgWFBEwiLvgRC0YdIsPVWxQnc5d8hFo21yAqZU3AcgeEDE
         GKcOouTjSiujQzxxWAknGb2ZAk0+481qHx5QVfUc3py60SBuPidsFRPjvipD4Ey+RM9+
         odlLD6CngBkAdxtx2FmFRbye/wCf6EhuJqs+0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683814769; x=1686406769;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C/W5GB4E38fHdQpL0SzJkoknJdNzqLnuSIkNSr13Ymk=;
        b=V1n/Mme21sYxEXXjJMf883x4H3XLLx5Pp9OGjhUgPwJlxEgNLYpK3N37QF+3DjA58L
         UCMsAQC/LcUOGTD5xmrsfUfcRMq4TEH7toIUo/ljs40wectMCk6xpUCDisc2vM6qBUIr
         62plpdoAmqJMvNK1C+T2bnevga94vivY0KCbPvUlTz8yipOqpFR8kZAHZHoIzy0Jz9b1
         6pdRq2dbH0Qb5qkF9j4WwKGvfu+RfB+EoI2Uj2tXBXFx+WIZYMft4JVdH2nX4Pocq9+f
         M33S4CC//IQjx67AwjDV8sz08QrdZAd8B/wab/QGZKM5pntjVScfeN/5/itYdit25g6r
         NcSw==
X-Gm-Message-State: AC+VfDxpd96KkcfomtmwUcew8zlDKiBe6mRlAeZVk9P2fOGHAQWoK3Z4
	rHoKbL1Ls5AqljnpRrBqAD7GORcGw+qab5AdH+k5QQ==
X-Google-Smtp-Source: ACHHUZ4RiaQLhpqajiCI7tzZeVxYhMJ5LbiTK0klZdX3KIeFJIGSuLhoBig06vrn5eZnw1rCjN4KEQ==
X-Received: by 2002:a17:907:3ea8:b0:953:37d9:282f with SMTP id hs40-20020a1709073ea800b0095337d9282fmr18146907ejc.38.1683814769045;
        Thu, 11 May 2023 07:19:29 -0700 (PDT)
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com. [209.85.208.47])
        by smtp.gmail.com with ESMTPSA id bz1-20020a1709070aa100b00969e316d8dbsm3778066ejc.225.2023.05.11.07.19.26
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 May 2023 07:19:27 -0700 (PDT)
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-50bd37ca954so79959146a12.0
        for <patches@lists.linux.dev>; Thu, 11 May 2023 07:19:26 -0700 (PDT)
X-Received: by 2002:a17:907:3ea8:b0:953:37d9:282f with SMTP id
 hs40-20020a1709073ea800b0095337d9282fmr18146763ejc.38.1683814766379; Thu, 11
 May 2023 07:19:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230509030705.399628514@linuxfoundation.org> <20230509080658.GA152864@d6921c044a31>
 <20230509131032.GA8@9ed91d9f7b3c> <2023050913-spearhead-angrily-fc58@gregkh>
 <20230509145806.GA8@df3c0d7ae0b0> <2023051025-plug-willow-e278@gregkh>
 <CAG9oJsnr55Atybm4nOQAFjXQ_TeqVG+Nz_8zqMT3ansdnEpGBQ@mail.gmail.com>
 <2023051048-plus-mountable-6280@gregkh> <CAG9oJskrJotpyqwi6AHVMmhnFmL+Ym=xAFmL51RiZFaU78wv-A@mail.gmail.com>
 <2023051132-dweller-upturned-b446@gregkh> <CAG9oJskf0fE7LiumdzD4QW8dTmGpmVyXBSyiKu_xP+s72Rw44A@mail.gmail.com>
In-Reply-To: <CAG9oJskf0fE7LiumdzD4QW8dTmGpmVyXBSyiKu_xP+s72Rw44A@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 11 May 2023 09:19:08 -0500
X-Gmail-Original-Message-ID: <CAHk-=wjJNHjwfrT0X5DvSP3fZzUF0SAbErkc30qAWDW=U9uKtQ@mail.gmail.com>
Message-ID: <CAHk-=wjJNHjwfrT0X5DvSP3fZzUF0SAbErkc30qAWDW=U9uKtQ@mail.gmail.com>
Subject: Re: [PATCH 6.3 000/694] 6.3.2-rc2 review
To: Rudi Heitbaum <rudi@heitbaum.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, ntfs3@lists.linux.dev, 
	almaz.alexandrovich@paragon-software.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 11, 2023 at 3:30=E2=80=AFAM Rudi Heitbaum <rudi@heitbaum.com> w=
rote:
>
> I have run 6.1.28-rc2 today, and was able to trigger the error. So
> definitely bad in both 6.3 and 6.1.
>
> [13812.020209] BUG: kernel NULL pointer dereference, address: 00000000000=
00020
> [13812.021322] #PF: supervisor read access in kernel mode
> [13812.022346] #PF: error_code(0x0000) - not-present page
> [13812.023591] PGD 0 P4D 0
> [13812.024876] Oops: 0000 [#1] SMP NOPTI
> [13812.026088] CPU: 5 PID: 20386 Comm: .NET ThreadPool Not tainted 6.1.28=
-rc2 #1
> [13812.027336] Hardware name: Intel(R) Client Systems
> NUC12WSKi7/NUC12WSBi7, BIOS WSADL357.0085.2022.0718.1739 07/18/2022
> [13812.028593] RIP: 0010:ntfs_lookup+0x76/0xe0 [ntfs3]

I suspect this is fixed in mainline by commit 6827d50b2c43 ("fs/ntfs3:
Refactoring of various minor issues") which changed the IS_ERR() check
into a IS_ERR_OR_NULL().

But dropping the original fix from stable might be the right thing to do.

                 Linus
