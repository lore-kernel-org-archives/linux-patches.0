Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D048215A4
	for <patches@lists.linux.dev>; Sat, 31 Dec 2022 00:18:55 +0000 (UTC)
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-14ffd3c5b15so14794227fac.3
        for <patches@lists.linux.dev>; Fri, 30 Dec 2022 16:18:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U65gfQUYRoplG6TAS3ktSDbsYgSOOmACnI2ukxtDlsY=;
        b=IlemQu/qq80xBMvKyMaTOjQE4pvyH4fOBgWLG50ekYVT6p6q7zpu43bRoyO56pMJQG
         V3YKsSwgwYhq4CIXVF6HYvb7N+VF3N6/tbg5YoLclz8LRzGRSivcoPXubM5SE313qEkn
         s6A75rM//ch5SkaMcC/6Am5saNT6HojhWrrdoGBoObGoSK5Wp/H92ZudbGvuNzNtxyB6
         pB+MuR2//GRg8Z3rYO2/qYe7ygLoMH7cYQhlONcEXUJQUKlPcTJCO7m6QNExtC6q9M+5
         7rh03WBRhPPitZk/I75C6pgA9myx1BeTDr2xkmRp2JzzsTXhFV5jOgIxbDs3ibdOX8im
         1LSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U65gfQUYRoplG6TAS3ktSDbsYgSOOmACnI2ukxtDlsY=;
        b=jSRbjfnE5nD9TWQjkGs0w0v4YxnwTM2alvMuuNxn6Ps4wJICysy7daLXOkGESPleGw
         PJIAu9c6+tFMm+WfYWfUA+funwzFGm/sdQ8/4wwZfT6zVast/8Vfu/yQ7mXAlvO13Zlm
         aOtU3n2iLF4Rlt9EONyEi5O3sXNupA/PX13YApw9cCGyqL2tY6IeLYOHGgt+sz0cvkoI
         gTyu1CdKXQGcZj4tWOVv0GahGfo8+kEztojbZ0iX5d/+2Rb/YOW1jjBI4bHmJT6dxyDh
         ov723L2llsqyI+YI4XfF4AW9/jGe4EZGK60EPNGaphk14tlDWaFuJYRFINOqqaQov/oF
         V2UA==
X-Gm-Message-State: AFqh2koy7NfXqQwmj9GkTy+vNrLWeLZZmwM4tW4c/NrTChhdVq5z9BQo
	W5isrdpGqDQ7iXq57Rxk580=
X-Google-Smtp-Source: AMrXdXsWY3VWmDmV6hLbhsL6BYH2lvTNsv8dDWthRzf7qn5EoGWPcHNEPSMYBz/yEiSMMnYwpQ2gvg==
X-Received: by 2002:a05:6870:8a21:b0:14c:8b5d:493c with SMTP id p33-20020a0568708a2100b0014c8b5d493cmr18225299oaq.0.1672445934915;
        Fri, 30 Dec 2022 16:18:54 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id eo32-20020a056870eca000b00130d060ce80sm10440198oab.31.2022.12.30.16.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Dec 2022 16:18:54 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 30 Dec 2022 16:18:53 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 0000/1140] 6.1.2-rc2 review
Message-ID: <20221231001853.GC2916712@roeck-us.net>
References: <20221230094107.317705320@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221230094107.317705320@linuxfoundation.org>

On Fri, Dec 30, 2022 at 10:49:32AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.2 release.
> There are 1140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 01 Jan 2023 09:38:41 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 500 pass: 500 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
