Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA049A31
	for <patches@lists.linux.dev>; Tue, 24 Jan 2023 02:47:36 +0000 (UTC)
Received: by mail-ot1-f45.google.com with SMTP id a1-20020a056830008100b006864df3b1f8so8479225oto.3
        for <patches@lists.linux.dev>; Mon, 23 Jan 2023 18:47:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YqexzIVMo40KP8hIDZ4Shizea2o4Dbmk1MKMn4wNOtQ=;
        b=UDKZR+Go9AIqlZ4sWp2iWsmkDb5CBx29aKwvioHxza+4UnQK29g+4zpcO87nTwopdj
         sSqa+ekMs9nNtjGYZFoCzQLK7DsMRsuKMMidQgRQ3uCNmxgfyBwVp1iTIo1As7N4fhoV
         /BQEyY6blqChslzEKOfJZU4XPvvHxT9kf47pWBRyl3P9jgenCroGOxIYGndg2d5VR1To
         YNc9A3a/B8rdRpmP0sOaiy9KqJq9H2cKmacYl8+rkQ0C2+R5kAxXDNMlczDzRjh33ChT
         Ru1yfYPJnWlPjbIRy1xYV4cOsJYVEywGolW/d4BJQ3bFmfyJNroExu9tE8i/udMSxTRK
         h4wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YqexzIVMo40KP8hIDZ4Shizea2o4Dbmk1MKMn4wNOtQ=;
        b=ftUjIekph4T3kRby4XrfKz+jWhOdjfcl95cZwCiUj/37DrqIJXjEFjoiZHYPoXQ0Nj
         m260MUaDjPq66tXXOZlCwOFzenCDncF6MJFjOj0FLHFznuXZ/nqYU2ocoAxe3GTuHgvA
         oF2dMc6caXUgasu7/wZGN1S1yPDTA6D+J6w8cFBpifRvQEOwwCd94a3CldRq61wT35gJ
         DDHO/POgr3JWw85f1xGLuIXWqvOK65fXy8LHWmgckNFuvKoS6ZGlpQHr01JqLMyIfP0H
         KWOt1ihqsQIH9EnXz1RsX01dolIxUzcH51xf+LsxL31bqPh+m1q+5Vl8HJMz6b+sX5Bn
         tviQ==
X-Gm-Message-State: AFqh2kqBk5IlwY1qy5CNJKfyWlywBCJKrB3eEBBxyKlxaN+NFkut5cJj
	mE72MyUugczT7QXi1ueRbKM=
X-Google-Smtp-Source: AMrXdXsiCbgg7HVN6mXN7b30bstYk+4L2gna7rlOHKvcnJ4xcDLaSqhzHprZxFED6URZlv57ZqLidQ==
X-Received: by 2002:a05:6830:61c:b0:684:c128:5495 with SMTP id w28-20020a056830061c00b00684c1285495mr12704506oti.10.1674528455878;
        Mon, 23 Jan 2023 18:47:35 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h22-20020a9d6016000000b00670461b8be4sm414495otj.33.2023.01.23.18.47.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 18:47:35 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 23 Jan 2023 18:47:34 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/37] 4.19.271-rc1 review
Message-ID: <20230124024734.GB1495310@roeck-us.net>
References: <20230122150219.557984692@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230122150219.557984692@linuxfoundation.org>

On Sun, Jan 22, 2023 at 04:03:57PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.271 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 24 Jan 2023 15:02:08 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 154 fail: 1
Failed builds:
	i386:tools/perf
Qemu test results:
	total: 426 pass: 426 fail: 0

perf build failure:

util/env.c: In function ‘perf_env__arch’:
cc1: error: function may return address of local variable [-Werror=return-local-addr]
util/env.c:166:17: note: declared here
  166 |  struct utsname uts;
      |                 ^~~

No one to blame but me, for switching the gcc version used to build perf
to gcc 10.3.0 (from 9.4.0). The problem is fixed in the upstream kernel
with commit ebcb9464a2ae3 ("perf env: Do not return pointers to local
variables"). This patch applies to v5.4.y and earlier kernels.

I'll leave it up to you if you want to apply the fix or not; I'll be
happy to work around the problem in my tests otherwise. Either case,

Tested-by: Guenter Roeck <linux@roeck-us.net>

since this is not a new problem.

Thanks,
Guenter
