Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB853D306
	for <patches@lists.linux.dev>; Tue, 21 Mar 2023 17:49:53 +0000 (UTC)
Received: by mail-pl1-f179.google.com with SMTP id z19so6437578plo.2
        for <patches@lists.linux.dev>; Tue, 21 Mar 2023 10:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled; t=1679420993;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z4P54MBQ4cIozOzjCsNEj1iyhhcCLnHlDld+BAq0u/c=;
        b=TiFqbZsrplC5EapCAa+IPqjsan9R90HRFywv7MGGfpaO6c9gkLAdbwZC1RgDsjv/LK
         USI5j/M0yKBfMGQlDncNnoXa5XkP7ujR4krU3LjoUmXXIs+em4ALhohZ8jYguqFgCark
         9CtN10vas8fbD3Hmi9w+9tvghR6eS0XkrqmI/huhwBfUmQFwotwtH8I7KJr/2BBehSjE
         EnAy4j7AaLTwUKMba6+EE9Qx3Q4U9R3BGmr3h+Q3zD0G6oEfe/UpqE3+5H8M7p072W4C
         MOqKnd5f+msRt0YoDROei91jUqal9mQmSUfDOpX+frrMFAOGux4kOu9q9N9RFUSKeYTw
         mT3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679420993;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z4P54MBQ4cIozOzjCsNEj1iyhhcCLnHlDld+BAq0u/c=;
        b=QnDXaaY3cvAuUC4hXK/UD5XMPn+WOQGNg5D4sT+RRmK5iKn4xaxDJVoc4AoFjkcLQ0
         qUhsyfOVl/qb3FMHNew2oRuFmCLjKUqCEQ0y9D+Qs/XISI2nF7ZE56KM+NlI8eiSTq2N
         w/Gg9qX57WD/KjCYg2Lf7skymDPSTOy7yx27KBYq7LkYYFJ00HoP7fNz2KOSH8bRQTR6
         662i0OkHRQqYIPiBkd9OriAUBFS3TXzyMbl4CPpkvIIGr7hYtkUrUCfBZNykdrQQ/Vhk
         N98q2eyEykotDzlPVUYTE2UU/Cpy2ZWuZ0p6Ammt6rbrJpWsqeN3q0L/+r3QSysIWBmb
         XApg==
X-Gm-Message-State: AO0yUKUrsL3owuH7GBgI7TsVIdOC+Dh4Voxq9b2+2j9UmBr8mpI6mCPz
	aw1PnTwp7qXkAcgt8pNrTAA5n1ukwcar63DwAV0fFu7y4Q5N7sCQeOommRhxlt0TsVXOwF/DwIB
	OYc+a+fGnGTD3HrBqmBVza0JOj5va
X-Google-Smtp-Source: AK7set/0lIxr18ls8fqOL+XZgVodfkTEHhpZvmra/rLvuYzI/FkpyFin7e61WmLsdhHXtBlsi9VsktTTiBQ4XUastSU=
X-Received: by 2002:a17:90a:4703:b0:23f:1105:4295 with SMTP id
 h3-20020a17090a470300b0023f11054295mr231123pjg.7.1679420992946; Tue, 21 Mar
 2023 10:49:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230321080604.493429263@linuxfoundation.org>
In-Reply-To: <20230321080604.493429263@linuxfoundation.org>
From: Slade Watkins <srw@sladewatkins.net>
Date: Tue, 21 Mar 2023 13:49:41 -0400
Message-ID: <CA+pv=HO+OXXY9CMgCfRVHgeN0-EcxqQ7MxUpqug+41aWom2+xg@mail.gmail.com>
Subject: Re: [PATCH 6.2 000/213] 6.2.8-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-SWM-Antispam: Scanned by pmxgwmtau.interior-mail.sladewatkinsmedia.com
X-SWM-TLS-Policy-Status: enforced
X-Gm-Spam: 0
X-Gm-Phishy: 0

On Tue, Mar 21, 2023 at 4:39=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.2.8 release.
> There are 213 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 23 Mar 2023 08:05:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.2.8-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.2.y
> and the diffstat can be found below.

Compiles and boots on my x86_64 test systems. No errors or regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

-- Slade
