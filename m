Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA377621
	for <patches@lists.linux.dev>; Thu,  5 Jan 2023 00:21:22 +0000 (UTC)
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-14455716674so41614770fac.7
        for <patches@lists.linux.dev>; Wed, 04 Jan 2023 16:21:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o0bzxs8vT1edO2FJXRZYVsWw5T2NkBAzXWyaCPQ3eXQ=;
        b=GXTugK2j/bMB/msseOunjbhl8k3GHOWmo8UlmNC7F3jNGVDXFQbCcn0h1zUKXzinQn
         O56/w2TxzzYlu1CA72oTh5U9RzY3lUhA6KU2ylGQLt5om3F9yuZ+b9M8b0sQxdi5Ub+T
         YwSJ6dApX+l8Cy506sgewXWw4OxoFNIPzusUUOe4ShOAfhpT+tIrjwd5zsc+rb9v5tmN
         S2koTLYKjHfYl3lCflH8riMjBygKIsh9MYs3e1X4E7tE3L1WhiheGO6w2aLzTcSE5QQK
         GyjSPb6F4A1s4RHpaTooc2yRGnQv/sU+nKMJiQrcNRvb8Fblf2OutmGiK/hQwmM221/l
         wiGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o0bzxs8vT1edO2FJXRZYVsWw5T2NkBAzXWyaCPQ3eXQ=;
        b=gJjwPDvUEZj4w5eUf/QtwX7VebDNIlHv1Chk/K9sW387S9yRR1KrTgBnwPaCNN36sr
         RSJV2CyHp5rpn3gdrUlQTRi3fLS4wd91M8Tqq2DDp/3kSJwWNTLSY9sbsn8yLg8zhOJi
         QRecUc86Joa7gt+WO46FTeMY99M9z08C+Uh7SnOHBUtaUVHs5tbhMTft06r8H9hWIT7z
         M/Z2PoiVuEo4bXE5uumYjOPnB2jEnKHI4JO0qtcehOrbWcVHP4mshUnX9Mwcdp1UFXZd
         LWaPMeFJmBpNeJapVItzccDgS/tpHoUG9z0u8hYzjzoCun5kCCcK0ce/jTAIXm+Er+nM
         I52Q==
X-Gm-Message-State: AFqh2kpeZfCrDM9TmN7CbnTq/HkaAETBM25LePCYMeMYL18VygEzGx+C
	o06I1Ckv+bRvmRqwnW0t2i8=
X-Google-Smtp-Source: AMrXdXtqb60Qxb9YJksIcDr1nnNmGMH+8VQoS0u1d2uA1M3akETZT3pTpdG0hc9YF9bV/rThNEiDxg==
X-Received: by 2002:a05:6870:e30a:b0:150:85b9:7943 with SMTP id z10-20020a056870e30a00b0015085b97943mr7589192oad.34.1672878081852;
        Wed, 04 Jan 2023 16:21:21 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d20-20020a056830139400b0066db09fb1b5sm16634661otq.66.2023.01.04.16.21.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 16:21:21 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 4 Jan 2023 16:21:20 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/207] 6.1.4-rc1 review
Message-ID: <20230105001720.GA2458003@roeck-us.net>
References: <20230104160511.905925875@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>

On Wed, Jan 04, 2023 at 05:04:18PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.4 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Jan 2023 16:04:29 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 500 pass: 500 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
