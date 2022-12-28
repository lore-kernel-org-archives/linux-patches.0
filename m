Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E502F43
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 20:47:07 +0000 (UTC)
Received: by mail-pj1-f53.google.com with SMTP id u4-20020a17090a518400b00223f7eba2c4so17064600pjh.5
        for <patches@lists.linux.dev>; Wed, 28 Dec 2022 12:47:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sOlbV4pVuTrR4K7vYl051PtLayKzACg/bpHOG7JoG+c=;
        b=ZVlkF0vh9TYZ3NdiMd0rSXUwj4lTQlldN+ERK7nWJPIm3v3TK2RIerCh0pf/4EWMJ8
         sQfWz4IZhFdNRqsRMY4oK4vRQBj6CIPltvdgu8gGrpU+g9SyK72A3D2uLXIAqHYgfYiN
         kVM1J36/5P/0+QNsTxIVaR5LO80jIURLICkC/nBr/p6P2/Z5q1H91FlgBVp4ILHWthp2
         YbBo8kKECHrNtBoF9QAiAo2V8POKN+610lUEOBxXR6Yhp+Mciwy4HZ2AFFrN3m1QktzZ
         67HEJUa75K5WqMPrlQ4pqQ5SDhBOFBPmxM9YEjT6f72v9ePH01lqs272GtWL218FaUza
         RVYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sOlbV4pVuTrR4K7vYl051PtLayKzACg/bpHOG7JoG+c=;
        b=NuLkC3QyyC1qHB/xRKEEttAmSPtoiryan/z7IGIA/lv68VOjfXabedMRQ19KX2STS7
         ZVGwrhAWmAkrlHYwCrBHvs16YrJcw1G/aCZvNGsDmvfIJgrdTdyclZQiY+lgDzZtI9aA
         xEaiMtsczIHZERRt9S2k4lyXJO20dlUCWNg/dQxP6HGMXI+t1I/iAOrZXePcGEipPVc6
         jxqJgTeQ0SguxCcKzDp7wKghGndEOrHkyE8d5kpLa/wlzYeabUXOFvn4n0++2tBM/kGG
         WDt8bn5T5kqTGkG7LYkxORG60iHjWElMYPnOp/9chKFaOQmo5zGVNjJhqBgown/LsaoK
         tonA==
X-Gm-Message-State: AFqh2kpz7eySHQqBbBPYLGtoqM+jxhduhLEd6nemaKNTG9dem8vTFp1A
	8SKRKqqc97H2tJBIsYo0h9oA7X26I/Hp3UGeIdfe1N5fVK9wxmXEEYQ=
X-Google-Smtp-Source: AMrXdXsCg0XdSXOAPFAc83qqX3enR1D/euK7Qz+bUp7sA0KghDQA/lFRvR6WzxlB7gZ4M6EPfFRVyA8D39SHlW0wbkE=
X-Received: by 2002:a17:902:e845:b0:191:ef6:a73e with SMTP id
 t5-20020a170902e84500b001910ef6a73emr1612447plg.90.1672260427368; Wed, 28 Dec
 2022 12:47:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221228144330.180012208@linuxfoundation.org>
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
From: Slade Watkins <srw@sladewatkins.net>
Date: Wed, 28 Dec 2022 15:46:56 -0500
Message-ID: <CA+pv=HNoOeKaqANvE3d70j39qb0cqnAfgvHzht7-QsNLNuU4fQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 0000/1146] 6.1.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

On Wed, Dec 28, 2022 at 9:45 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.2 release.
> There are 1146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 30 Dec 2022 14:41:29 +0000.
> Anything received after that time might be too late.

Compiled and tested on my x86_64 test systems, no errors or
regressions to report.

Tested-by: Slade Watkins <srw@sladewatkins.net>

-- Slade
