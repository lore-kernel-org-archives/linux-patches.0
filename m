Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD08AD27
	for <patches@lists.linux.dev>; Fri, 24 Feb 2023 17:55:24 +0000 (UTC)
Received: by mail-pl1-f176.google.com with SMTP id ky4so299643plb.3
        for <patches@lists.linux.dev>; Fri, 24 Feb 2023 09:55:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OYejHnHCd/0NM5wxYlzbguJDabqND0i6mKg9xEzuA74=;
        b=i1dq4emqpx6xG6yMZsrPDX+J8bAjHV7sjol1HOnvBtQMlkFX34sMdYER2riwEoApxM
         K72VY6qoBWVvT7f6HF+cNZcME9+teYLqYhrl7MsdrrDb/hydzsQZF0uJ7oUYbzMKzojJ
         rXRYnWaLiJ5jZ2Lbut3Q/VrgYUxbUGSfsPUcmPiBTKas4N9dien6dxW+QZbrZjldM/OL
         gVUIVDSgG3getHw/VmeXh1ILTHzRvBuae8KBzEpLRVvHJym2X5CsOs18czGuC9iUTcyG
         i1awIYiMc2PFIHTMKlG3BhN3pm/r5okxhwjNRmyM8B69YFEATDXeERn/M8TLylHfHYn7
         M1xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OYejHnHCd/0NM5wxYlzbguJDabqND0i6mKg9xEzuA74=;
        b=T8ztl93fN+deyu4LRkQCEDKV4Jt+JOj2/bII2j0KDJe0AXiKh5ydI9XJmE0AJvrjRI
         QnkDRZ4OgBJywF2wRoJ3VTSpINzMtfd02daJDloIRFrrodwXmzOwcRDIRMCzdAPLLdLY
         NxoM6VlfzkXNATKt7w2jsjwc2UvtzWuOFyvCufPqd30Vhil9Re6Sk0MeJnzMYcNZGs0O
         GJOGrS1XCxwc4ugiVJxXobbyzTAXIyRVWaE1sLJFTpRDn0Hay+Zwnqq29Dx1jUp91oNt
         50nLcoGvwmDRk6uEfk/2yEJ3PduwTxx8kHUDIQkZlm6asTkTUSpFS7po3IfCh3q2jpdT
         alSg==
X-Gm-Message-State: AO0yUKXz6JZVEwFs6aC7jx2Qe/oUGTzgdpzxBRH5rn83/uj5q1GioeOo
	kQ1pK/e274Kc9LtXJg40wDMJy36if67NZZyVh0pOIQ==
X-Google-Smtp-Source: AK7set99bb6Ur8cDdsqPYjrECSI1xBnSAc48RH2LFjf40927rAhzf6Wba3b2MUqRmkdto4EWC/CMiv5lwnJcPJ8di7s=
X-Received: by 2002:a17:90b:374a:b0:237:3d0c:8d58 with SMTP id
 ne10-20020a17090b374a00b002373d0c8d58mr1960736pjb.5.1677261324524; Fri, 24
 Feb 2023 09:55:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230223141545.280864003@linuxfoundation.org>
In-Reply-To: <20230223141545.280864003@linuxfoundation.org>
From: Slade Watkins <srw@sladewatkins.net>
Date: Fri, 24 Feb 2023 12:55:12 -0500
Message-ID: <CA+pv=HN5MeWYBVts6GNs6eA2nBYXn3k--m=1imMDvjox4UMnWQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/47] 6.1.14-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

On Thu, Feb 23, 2023 at 9:16 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.14 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.

6.1.14-rc2 compiled and booted on my x86_64 test system. No errors or
regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

Thanks,
-- Slade
