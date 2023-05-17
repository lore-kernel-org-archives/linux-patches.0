Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B73D17D0
	for <patches@lists.linux.dev>; Wed, 17 May 2023 02:57:44 +0000 (UTC)
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-643846c006fso210875b3a.0
        for <patches@lists.linux.dev>; Tue, 16 May 2023 19:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684292264; x=1686884264;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8hhWsXrhhZhUyOAd+do84J/5IkDaxDP38fgUKTDS9po=;
        b=I0nd20kpV5l6NQNhNgzvawU9SA6riyj1/DSyTP0RDTDFlY/UAKsR/upbbc9q3zMksh
         Kmisjoji5bAxbawPtyXcrQY4ITobRdK9HzK06Yb000+cda/RkGrDED0PSG9Leef6Lxgp
         yz+d59u/lggvkb5+Z2aDdnnZKfwXqxOdFVFD/pQwqxYzlg86yx23w9N9vz/lP0JlQZkR
         k4nx9OZhM3WWil6JYK7uWAx1aJszmNfumz3EDhGZ8nM+IenyLfEWwkil1LB0SPIoWDto
         LD4EFn7GTmCwjBAa9znkZkiWDtwRqjIOsFsfjFGzxni1jASeHKTIRA6EYpfR4azhiFh/
         P49w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684292264; x=1686884264;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8hhWsXrhhZhUyOAd+do84J/5IkDaxDP38fgUKTDS9po=;
        b=gk3iPTvXRxl/kmp+zJr/10eu0MfP6/FEM1j5eYzJgfULsfsyC+ZxssuKKjn62RQ81j
         kawIFpfAJcYvrE6zjYtl51W7rpV9yIw/uLyBN30PhlaxiRGhbOF/qajFSEIX9GfEtrtW
         dYv3ONuRsB555to/VEB/gaJgbX0CMe0lBlxRF7STV2gdcjdCumvDvOZlKF7vBQWNbRpr
         PQtJiSqp/kIEBDTAXPZeAH2laDP8G9f1cDgy5ExKt30ds6mgqWQFl6cFKC/ee+7x2vlX
         M6LjZFBiMbWciLLlpQKNiZR4f4+DxX+Mxirb0Cx3IDFoyopaBI/AZKzOIzpo+pvCtS6D
         q2tg==
X-Gm-Message-State: AC+VfDwVOpB6aJtYTg64rQDr/pnGLMSUNtS7FI/NEuhYvkb1JzUl8/6I
	lUpvGjPFWxfQZpuvsNAGsOM=
X-Google-Smtp-Source: ACHHUZ4SkYvhKzyOuwuMkeSAGtRizlHOIh7L633LB33QjkzLke1sBtx0dyY6basPkaFBJBD5rsiPaQ==
X-Received: by 2002:a05:6a20:3d09:b0:100:5f62:be76 with SMTP id y9-20020a056a203d0900b001005f62be76mr43080303pzi.54.1684292264065;
        Tue, 16 May 2023 19:57:44 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r15-20020a170903020f00b001a1a8e98e93sm16265340plh.287.2023.05.16.19.57.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 19:57:43 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 16 May 2023 19:57:42 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/134] 5.15.112-rc1 review
Message-ID: <a56446b6-ce5e-407d-acaf-94e7680a89b0@roeck-us.net>
References: <20230515161702.887638251@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515161702.887638251@linuxfoundation.org>

On Mon, May 15, 2023 at 06:27:57PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.112 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 May 2023 16:16:37 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 499 pass: 499 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
