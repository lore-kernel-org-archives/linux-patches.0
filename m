Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B1D87C
	for <patches@lists.linux.dev>; Sat,  4 Feb 2023 23:02:02 +0000 (UTC)
Received: by mail-oo1-f53.google.com with SMTP id i21-20020a4ad395000000b00517895ed15dso836025oos.0
        for <patches@lists.linux.dev>; Sat, 04 Feb 2023 15:02:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aJ0+krcbY3WL7q08WP1cx/1zC6fiLkizNntUPLraJrI=;
        b=evSkKOLksPSEKuNHR58hNmgSVknBlpAokZ7kZmbqDhG8WFaWyp+uqz4PEt2lplKt6W
         s9huChIaJN0lBFVBsRjmGEUBpMAQt/6TIywcL8FYsX8BYOH1pQsI8FoyzCH//T7S20dN
         11J4HmtwZGYpCNI1rYt2E0fQo9hgIth37ShMRmIuGfSgCQOzyLEQDD12Oof2atqdc5MB
         6ktaYnl9EBdtGlGQm8gsdfVABHFGTuM6a4op6y4VQRh1pKEc7LzTc3mwwHFyjeln/lYg
         Cise3LWurI9mXcPsth/qKdKIOt7B8ltboBkxAIwGhtWg9jR9ZKIdf95Y9/RmrdslRrrv
         agng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aJ0+krcbY3WL7q08WP1cx/1zC6fiLkizNntUPLraJrI=;
        b=72TsEl8t7Xb8esbbJvSDzqRSHmUGbx3dxaCF7oKDomBP2D4mPK+lt4Yl6XvgeQ9+1U
         BGs9HM5N3g5DadZWlEFmdKXtN6HnrZnnefUoHTnRW4sdFjtBylNK5qjFE2x/D80pcWHW
         jqZ15ZXb9xwOyGJ0UR6by5XO96ekYXu+aE/cZChJq7ngN75jrvMTajIkgb8ZtPsVzgKp
         gnfrAdgvmNBmyrt07pTPsyn54CF2IB6Jt+XrgUlNBF6xm0DJwSDlY26dIcTyEEkQm83U
         O9iiViOAZOHcqFgsH4eSZppFdbsWmkzUoii12J+FIEJxNM54gNWOcvUzv5JnFj2MS9Vv
         F6ig==
X-Gm-Message-State: AO0yUKUJycn37LbcuXeScDPu3I5SA9ksyHhJFpLFuvelDvZlrhFTiYJK
	oYYfVQ5KnD188WijGbCG2KQ=
X-Google-Smtp-Source: AK7set/nmffb/dPq1BcM/yMms9PqlmgcT2wD0f9xcCr2vVd41PrHN9FImLFt/+T8/XnJ05YLq89CTg==
X-Received: by 2002:a4a:83c1:0:b0:4fb:cef6:5c9d with SMTP id r1-20020a4a83c1000000b004fbcef65c9dmr7933037oog.9.1675551721574;
        Sat, 04 Feb 2023 15:02:01 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c17-20020a4ae251000000b004f9cd1e42d3sm2536820oot.26.2023.02.04.15.02.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Feb 2023 15:02:01 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Sat, 4 Feb 2023 15:02:00 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/79] 4.19.272-rc3 review
Message-ID: <20230204230200.GB114073@roeck-us.net>
References: <20230204143559.734584366@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230204143559.734584366@linuxfoundation.org>

On Sat, Feb 04, 2023 at 03:42:31PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.272 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 06 Feb 2023 14:35:41 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 426 pass: 426 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
