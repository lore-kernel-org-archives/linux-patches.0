Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0BA10F6
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 02:55:18 +0000 (UTC)
Received: by mail-pj1-f51.google.com with SMTP id x20-20020a17090a8a9400b00233ba727724so2899481pjn.1
        for <patches@lists.linux.dev>; Wed, 22 Feb 2023 18:55:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XQPHO+gl/DhYC4r22uP7h9xL0tCG9iAevyTPVtriPQo=;
        b=Ffzo03v+l25EXyWJifw244XNhDz8wJghOb7k4p1ylBpVzAQQ1mUmUN4ZX7d9fSyhjZ
         N1wUjMyk73kCrZtbKAuYc0AbzVdWH0+DQdTnLSKNaOFffc8tG6sR1p02579PPIbzSPxN
         MvU7odQaG0VUedi0VCGmQwSJ+J30gQZvnM8KB2qc0K4mdl6U48lLX9LbVz3qW23wGVfv
         RPzc9+ITya5C4t1bJFimdoWHUmieuiVHEBFpHlZ3AHF8BdvHD0/C6MCkulAKgCR9nrae
         LjIlK4JS24XDnSWjzllL2ZNxAITY0l8EkZgPbxk9tO0ohsGK4TRd+DNU7HVWDLWUsVTl
         /WOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XQPHO+gl/DhYC4r22uP7h9xL0tCG9iAevyTPVtriPQo=;
        b=105GNsSei3TkACoXhrI1a+y+nb0d0VQc4WzFxj7el3VYvN5V9iVx8rzCV48QnZZOyu
         DBTVo7ZRXt/ogpOxKeT4OSKOJfgiikvzNbKBGTHIxv5tTHRXmdZn0IpBwvGYqfignl4z
         BShtE3klC72/gu9CvP68zdpO+zJUql+9hqztUMHGqdsZt0iNN/KwrcolV54M0bX/fJdA
         iMAzLJVti5nBqq5Zn4aiNBzaqvOWE8p0Dvmklk58iuxW12oZ3ej7CZmWQq9eWdkWbfPv
         lajXXqo4omaUGpNm175g4ZfwrrILoJ+9uY1PT805/Ncees2oeLgE5eZb0Rc+6tbxcIUA
         JTvw==
X-Gm-Message-State: AO0yUKUSJ7KAGQovuUeTDjNtvar6ZwSorp3CHmDTp9ucszon5ggUCWv9
	jWS4nyLykNcXeRR9KNvnqU67gvplT0FDF4fG+xw5NA==
X-Google-Smtp-Source: AK7set+sXcdhmJLQhp1HnsxoaWEiNvC2w5ODsm67G7ZcQMIsy1veA0VxS0igMXfb2hiUE1B6yJbPUxrsOn16CMsbPJI=
X-Received: by 2002:a17:90a:df12:b0:234:889e:d88d with SMTP id
 gp18-20020a17090adf1200b00234889ed88dmr130880pjb.5.1677120918304; Wed, 22 Feb
 2023 18:55:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230220133548.158615609@linuxfoundation.org>
In-Reply-To: <20230220133548.158615609@linuxfoundation.org>
From: Slade Watkins <srw@sladewatkins.net>
Date: Wed, 22 Feb 2023 21:55:08 -0500
Message-ID: <CA+pv=HP1Jv8m_eSv=h6fKFE-ynkgHCdWNB1dnmFZUqsrcGN5cg@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/53] 4.14.306-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

On Mon, Feb 20, 2023 at 8:38 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.306 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.
>

4.14.306-rc1 compiled and booted on my x86_64 test system. No errors
or regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

Thanks,
-- Slade
