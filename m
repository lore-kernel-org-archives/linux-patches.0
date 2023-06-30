Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325AD3FD4
	for <patches@lists.linux.dev>; Fri, 30 Jun 2023 06:21:05 +0000 (UTC)
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2b5c231f842so22940841fa.2
        for <patches@lists.linux.dev>; Thu, 29 Jun 2023 23:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1688106064; x=1690698064;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rRbIAUxLipf503mIOlM3ZYKM925BvMPEOuWIEIxYBNQ=;
        b=J3lkofH26gqKDY5t4dxPDICKkFC+dkZWUPX5Sk92DZ9UQgDmBrG+zpRDtG41e3ZIb2
         klUhkV9VsSRWZNVQA4bNIgh/rYW/ebyZllvv0mVN54YQQI4g9W9h0z08Rj36OOQAPuQP
         x6d447QBc+WrUsQQ5UjE9Xekc+sfrVYiQs6J0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688106064; x=1690698064;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rRbIAUxLipf503mIOlM3ZYKM925BvMPEOuWIEIxYBNQ=;
        b=iqIpJdggdtHkVgk2V2A98tuPo+24repyXn4a1AxJuuR56QEjHkbbminYmkxm/SILxL
         mDbLLpdOQXEzzYNsCscP7DeIWLGBqNorrj/POP8CW38xKquCbMh5IIe4qEcl57y+OX7A
         vvcxcDo0vdYgnUymjc4HXsIe3bjcQo6SPd+4dA7rJu4ors/yn/lW7Hqms3q8jLhIR3Hw
         H3UrjZitMqiUugUCm4f5VsPCz+EJ6WcaB+Vm7zMJ5gpS25GA3gGyagBM9/JwpEVzdl0f
         31b2bSXjaitdF4l94n+nHwM0sjpauMkjTM+3tpzWTVVNqH5JoAfg6/tF0+hB77Il8ucG
         r26A==
X-Gm-Message-State: ABy/qLZtQFiHq4DgDZ1k81Ov8D5ubOON+49Cw21E87Fh8/XKdgehVZ0e
	ela3KLuZLdvdDQeTU0/SI2rF0d33H3FwgYkB8rNf2AFp
X-Google-Smtp-Source: APBJJlGO4BNXSm7EGLC2o+fc1K2dAI3MFiKRhgsKevW6qLR27o7YulCCdiFYtxBOdz3FD+Qxl4Grug==
X-Received: by 2002:a2e:7d13:0:b0:2b6:982f:df6 with SMTP id y19-20020a2e7d13000000b002b6982f0df6mr1239147ljc.11.1688106063696;
        Thu, 29 Jun 2023 23:21:03 -0700 (PDT)
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com. [209.85.208.176])
        by smtp.gmail.com with ESMTPSA id x12-20020a2e880c000000b002b69c2fed0dsm2645426ljh.54.2023.06.29.23.21.02
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jun 2023 23:21:02 -0700 (PDT)
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2b5c231f842so22940401fa.2
        for <patches@lists.linux.dev>; Thu, 29 Jun 2023 23:21:02 -0700 (PDT)
X-Received: by 2002:a05:651c:206:b0:2b6:9f64:c375 with SMTP id
 y6-20020a05651c020600b002b69f64c375mr1282639ljn.47.1688106061998; Thu, 29 Jun
 2023 23:21:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230630055626.202608973@linuxfoundation.org>
In-Reply-To: <20230630055626.202608973@linuxfoundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 29 Jun 2023 23:20:45 -0700
X-Gmail-Original-Message-ID: <CAHk-=when9OgPprG57O+DtVFM7X9_wb6x2h4Veq4Gu6TUvxyiQ@mail.gmail.com>
Message-ID: <CAHk-=when9OgPprG57O+DtVFM7X9_wb6x2h4Veq4Gu6TUvxyiQ@mail.gmail.com>
Subject: Re: [PATCH 6.4 00/29] 6.4.1-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 29 Jun 2023 at 22:59, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> Linus Torvalds <torvalds@linux-foundation.org>
>     gup: add warning if some caller would seem to want stack expansion

Did you decide to take that one after all?

It's not exactly wrong, and it might help find any odd cases, but I do
suspect you can get syzbot etc to trigger the warning. It's designed
to find crazy users, and syzbot is - pretty much by definition and by
design - one of the craziest out there.

            Linus
