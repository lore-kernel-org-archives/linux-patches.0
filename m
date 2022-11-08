Received: from 003.lax.mailroute.net (003.lax.mailroute.net [199.89.1.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8ABA480
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 21:37:07 +0000 (UTC)
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by 003.lax.mailroute.net (Postfix) with ESMTPS id 4N6LtX3RxQz1prXg
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 21:33:08 +0000 (UTC)
Received: from localhost (013.lax.mailroute.net [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4N6LtP2RCgz2lJCT
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 21:33:01 +0000 (UTC)
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([199.89.1.16])
	by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10026)
	with LMTP id Oe6eiAnTOWlV for <patches@lists.linux.dev>;
	Tue,  8 Nov 2022 21:33:00 +0000 (UTC)
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by 013.lax.mailroute.net (Postfix) with ESMTPS id 4N6LtN4Pv6z2lJCY
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 21:33:00 +0000 (UTC)
Received: by mail-pl1-f199.google.com with SMTP id q3-20020a17090311c300b0017898180dddso11954644plh.0
        for <patches@lists.linux.dev>; Tue, 08 Nov 2022 13:33:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XvzS6IZtUmkiQUDObZubbiGEND3E6ynZXlDGWsaowMs=;
        b=l7c4lds6IThIy6cpCrJ8JMAWwePfEggJx2upPpc3rjIqN8y6Z7TTt3Do7NRhw8L5bt
         A5VacmPLn8vYrVg2Wm1+czEn3xk2Yh1DWhTJRfG5sk98G/xwwKhV4/v0dywSgk0Phfua
         GrHug2zpEuIkf4ghy1X197/cseDQCwSsfXIJEoP9p+ZZHZEwIVzgz+OO1qhCLJbNkf0f
         Y0t7LpoND24vEM6snXgeh5SK+NwJ0lrrLMDrhWQs6JuiKhTyvW38PklAgc1RBKMRSY9k
         DNTcxUeVwKpmIlUHRdBRuOizfXY40Czy99sshCHdA4s9gdwD8GxptqkHvUBRB6PI3q4l
         t1qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XvzS6IZtUmkiQUDObZubbiGEND3E6ynZXlDGWsaowMs=;
        b=8KV5tDzIawKQY/R4tAuoDu+4zSLC+3ggPjbxxBM2yeI22Lm3cg50JK7g2HKia0TV9T
         gepKlkNHeL0rnoNRhOpUGQ0iIRsC0gmhrIof04lHPDBWOhFRzhSUddhBQWHBii6/95zF
         3Pd8+9tgAOTVHgF5uySedlZzYWWJqIDM3cXDOsI04fiIWMgIiOdYAQis8EXHM/f3J655
         CgkrfCEmOdD255loI+kWpiJ+zh9zD9XHgGY3tVCPQGAr9e7H/YoNs6LbiZuAdTi5Xzza
         dICK4LxRup/9FNUVE6khAAcBXLE3nruO6AgPPETLzfKuoMpS4yEpdqUZghG7YNZejK13
         7hJw==
X-Gm-Message-State: ACrzQf0tfCtxRvLbGqv5+JuqBz/hbW/A6NDnwStPQZia/Pf+50bcGB22
	N5YtCHB8keWJuwiRmp3vy81F6x3PA7Bb6sq2LSXKwuCbbWFTirpVHbmtBjsiKEH4AwlZ6y7xP0S
	85FuxMb3bybrvSHkhyLwXImQiGnh9bZy8EjK2WdqxwtkRuoHv
X-Received: by 2002:a17:902:9b88:b0:188:620d:90fc with SMTP id y8-20020a1709029b8800b00188620d90fcmr27845596plp.61.1667943179057;
        Tue, 08 Nov 2022 13:32:59 -0800 (PST)
X-Google-Smtp-Source: AMsMyM74u/1SS2WCRO6VZM04gxufQf/tkIwogn2aFn4BzsnsFTbOeo04Kfkbq/L5Z9sbrGMnJiqbRFzjakLsbFoktOU=
X-Received: by 2002:a17:902:9b88:b0:188:620d:90fc with SMTP id
 y8-20020a1709029b8800b00188620d90fcmr27845580plp.61.1667943178750; Tue, 08
 Nov 2022 13:32:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221108133345.346704162@linuxfoundation.org>
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
From: Slade Watkins <srw@sladewatkins.net>
Date: Tue, 8 Nov 2022 16:32:47 -0500
Message-ID: <CA+pv=HOud9PMz7e9N=ffyF14OeDWU0ddDrZJADaqTPP-q7k6-g@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/144] 5.15.78-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com
Content-Type: text/plain; charset="UTF-8"

Hi,

On Tue, Nov 8, 2022 at 8:59 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.78 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.

5.15.78-rc1 compiled and booted on my x86_64 test system. No errors or
regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

Best,
-srw
