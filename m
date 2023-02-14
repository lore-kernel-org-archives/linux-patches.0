Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA244BA54
	for <patches@lists.linux.dev>; Tue, 14 Feb 2023 17:54:31 +0000 (UTC)
Received: by mail-ed1-f48.google.com with SMTP id v13so18546397eda.11
        for <patches@lists.linux.dev>; Tue, 14 Feb 2023 09:54:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gqG/enM8HfFTvnPDTpPzWk+Glm0amvtJkxf2NVo378E=;
        b=F+u65dsx99puM87w0HTzdq91Z0GfWip8hAbSdGjMMAN4XnQWUxvrD78auJ/6uRGwB2
         n3MHj6R+v/jFIpV6WZGax/PLLHuAW73dsd51EGdX4rRw1ddLtG1dK9u5CFfbwyz1CWP3
         bMtMSrbwjB44kodOjX9RvlF5yKfhU3XqIfoI4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gqG/enM8HfFTvnPDTpPzWk+Glm0amvtJkxf2NVo378E=;
        b=L5UanxHe/Q9BkmV1lK1Vu1b2IzXO5+GzzbJtNpd3EIq3qr9bbYb7WcdAf6yS7NO6u5
         m9Mjn2vFnD+CqoaCRUXKvq5EnLGoUILMNZrsf/CbPh5Ekw51Dm5WeQjWvZ2dVEKYKSzs
         2O63TraEKg1qzXgVYOZ15dd0erRuUnxmGylaIIASw3jLKXQaWmTW7tZ9rJgztCU6s4YL
         mjkAdhecLxsUEN0BWKsXOcHEvGlYgvxXJTLADPMGuhfo5PTXiWzDY5oNOk5PBRz2nDAK
         06Jj152MXRLJsQ1MA6BiQTaj0JEkljiPSswuYRzS8n92Kl2fXDq4Q9ipHciB65JXTLJH
         5Gow==
X-Gm-Message-State: AO0yUKX8noLBOeTAbznugZZGULb2hjAiJJMdcjNOse8YUwVfzs8avhaM
	ra0d1vTDybmmlr9DvSEI0BbqE0MWVNDxv2EJjrA=
X-Google-Smtp-Source: AK7set88DLhBUAgDnzSfiIxppn7j6ZpfCt35pnHliSqF1hfFgKawDLWnAdbDxF2VnJqeP9ds/6YEbw==
X-Received: by 2002:a50:cd9d:0:b0:4ac:b309:3d76 with SMTP id p29-20020a50cd9d000000b004acb3093d76mr3289638edi.31.1676397269587;
        Tue, 14 Feb 2023 09:54:29 -0800 (PST)
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com. [209.85.218.42])
        by smtp.gmail.com with ESMTPSA id f8-20020a50d548000000b004ab33d52d03sm7392692edj.22.2023.02.14.09.54.28
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Feb 2023 09:54:28 -0800 (PST)
Received: by mail-ej1-f42.google.com with SMTP id rp23so42061235ejb.7
        for <patches@lists.linux.dev>; Tue, 14 Feb 2023 09:54:28 -0800 (PST)
X-Received: by 2002:a17:906:8585:b0:8af:2ad9:9a1d with SMTP id
 v5-20020a170906858500b008af2ad99a1dmr1732354ejx.0.1676397267927; Tue, 14 Feb
 2023 09:54:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230213144745.696901179@linuxfoundation.org> <05984672-d897-6050-3e8b-3e7984c81bd9@roeck-us.net>
 <1cd10087-87fe-048e-c9ed-0a5d32c50764@roeck-us.net>
In-Reply-To: <1cd10087-87fe-048e-c9ed-0a5d32c50764@roeck-us.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 14 Feb 2023 09:54:11 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgnKpVzL14X0+cLQcWuQmjPAvgrDGF69JRMjgc4rA0VfQ@mail.gmail.com>
Message-ID: <CAHk-=wgnKpVzL14X0+cLQcWuQmjPAvgrDGF69JRMjgc4rA0VfQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/139] 5.10.168-rc1 review
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, 
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net, 
	rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

On Tue, Feb 14, 2023 at 9:51 AM Guenter Roeck <linux@roeck-us.net> wrote:
>
> Reverting the nvmem patches fixed this problem.

But upstream is fine?

                 Linus
