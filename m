Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202916FDF
	for <patches@lists.linux.dev>; Tue, 27 Jun 2023 21:33:27 +0000 (UTC)
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-262b213eddfso231325a91.0
        for <patches@lists.linux.dev>; Tue, 27 Jun 2023 14:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687901607; x=1690493607;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/guY2SniCeu+4ZiuvXjL57Te+BL73R75/hCInNX1NJc=;
        b=eIosBzQmR4GxM4fiKFnuW4rJqG3uok0QNSkZeT/YSHs1ab6lydEw3dxqzidrh7/PI0
         G3ghiVAnUNDAXMbOMAZ2RZyxVilTDqhzuqT9ZJ8yaIRPJAOnlqR79qV3lT5quCMrpbJI
         wsrtOEKR5ewkSZqfEVkBsNJZXi05iPN1of4m9aRPVJ56L7v8KFuk5HDf9uTqfyoPBJM2
         eY+YWj3M/l7hleLwmTZj7Zgalpx/Mr/FBAzW0rDtUhCcW+rOkJfedrzfW8P8tpEGlPxs
         49sEPFIuBTIs0Uz5JUlGBEN2wM3l568U2w7eOTNRkro4AWneqYimtF48GfUhGdjMKYO6
         JhIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687901607; x=1690493607;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/guY2SniCeu+4ZiuvXjL57Te+BL73R75/hCInNX1NJc=;
        b=O9wSvkk98rff5hCax7ZRqhS5d2SRVzAjnIR9ZoydcorNjgNwRJyT+8J5+evvhcX41j
         ORE4z/nZO/iRCMrgLzb5Lf3jIl6xlJKKEnJ37DULboGU650u5x0iiUGlP+NP0oz22Ekz
         K0nDNEFzSHk3WRjVjterYz63MAt7Ap4fZTxWiQfNAcJRcmGHqKPCmuWXvx/ldbc5GSno
         OtAoU8XHfl2Obm3Och7v5rnsEA+65rA1E/o+7CIsLPTrcLXsIfSaRm3iGe4hs8Rr47tI
         trPFGmfxdYE8gOsrCtkzOQwuNidzHuVvRpbNCVfaBju5wzOp+Mhl0m7wlAIkww/QTuHG
         DiPw==
X-Gm-Message-State: AC+VfDzIBt4XmLxLEw7X2lsNgN/ooI1a2F2+Zv4carGemYK2Y+oIy3cE
	XrAEq5ALeJSt0y3HiUYV4BM=
X-Google-Smtp-Source: ACHHUZ5ftZl0RpzB4U3iVzKGkTUEJHhm6RYggP0w1/TJYqDzyy2EItZxHXJAIENndE/9769pVqAyww==
X-Received: by 2002:a17:90a:8d86:b0:262:fe4b:b45 with SMTP id d6-20020a17090a8d8600b00262fe4b0b45mr7832931pjo.19.1687901607450;
        Tue, 27 Jun 2023 14:33:27 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 6-20020a17090a018600b0025bd4db25f0sm7009741pjc.53.2023.06.27.14.33.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 14:33:27 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 27 Jun 2023 14:33:26 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/170] 6.1.36-rc1 review
Message-ID: <4f5e74aa-2fe8-4118-9f59-6760103292e8@roeck-us.net>
References: <20230626180800.476539630@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230626180800.476539630@linuxfoundation.org>

On Mon, Jun 26, 2023 at 08:09:29PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.36 release.
> There are 170 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Jun 2023 18:07:23 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 519 pass: 519 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
