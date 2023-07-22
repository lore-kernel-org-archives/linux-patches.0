Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2540808
	for <patches@lists.linux.dev>; Sat, 22 Jul 2023 20:40:42 +0000 (UTC)
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-783698a37beso170559639f.0
        for <patches@lists.linux.dev>; Sat, 22 Jul 2023 13:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690058442; x=1690663242;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f4jiZ9yoW3nECNjmz012PrnX3Wx+24JFZES9eeuORWI=;
        b=Kxoi6EkGhWxRwbYrfkf1yveF7rmC3iKrY15+WMk7IDcxN1mr7DXVltUadCHYAQapCu
         KofhL7QNm/hWAdyMK0qty7FieDTtQ87F+yY7nLgGBLoYpdMI0xm77cg1huQq8PRrtRaK
         Mrp9oKna4dCb78fcwg8atpG/xmD0f7qT4VEaCxzwg0Dy2I+lZAAtuQZd2f4ZU+1SHkao
         y0/WSz7MLkBd3dznFVvmAy+5X+DS2x7ptmR0PBx75zzWsKvmSviajeC96qIzZKq8yDiN
         zKib4Nrab9pG4SYKpxtDP3PQQAlOZ8vkHFXnECHRevUrk6OmPJII1b8vbbP6HZcXZAly
         CzWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690058442; x=1690663242;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f4jiZ9yoW3nECNjmz012PrnX3Wx+24JFZES9eeuORWI=;
        b=byzfMCLyyYxq17Bkw1/MsmXufh1QO0MRrTjL29qyqG37jVQnmvbxc+tzW2Wrid6nbK
         HIZ9DAeEIoEcQDwUeZmjrj+A5t5Ez5nunC+R9XtVQqV03+jiSN8GRnQ1pbsUUR+PNtMa
         Ufps1U6ANhwCMwQ+XPzbSERIBY2M3CA8zQa6xTFCazI/4u+Bc0yZXj9csV85A09Jeg5k
         mkUP7aPpDt9jGaDPRljBzUMGYYt5bMez5s971t9A2RsvvE4Ax1STTNrq6jhPQx5RfSzr
         OmqAczyWNtDZe8Dufqge1hBpKjD8jvazsM7inOaOtwaeUYZMPJx4DYu57iY3ZC+7K+5c
         rrtQ==
X-Gm-Message-State: ABy/qLZrJsPCqcZejdDGxcu6kqblDuP6LiRgel5wL/Axd3sa75DSCaeU
	ScgrS/O9S3TGeJ5U9TM1+tU=
X-Google-Smtp-Source: APBJJlGWIX+Iz1P6gV2gbY8VEivFKVBjLhA0QbnZ4oheIoaoBLxznL42H4lz+aqrTw5s+M8zeWfb/w==
X-Received: by 2002:a05:6e02:1090:b0:348:8b32:7ca3 with SMTP id r16-20020a056e02109000b003488b327ca3mr3642134ilj.5.1690058442087;
        Sat, 22 Jul 2023 13:40:42 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s25-20020a02cf39000000b0042b3bf0baacsm1849286jar.138.2023.07.22.13.40.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Jul 2023 13:40:41 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Sat, 22 Jul 2023 13:40:40 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.4 000/292] 6.4.5-rc1 review
Message-ID: <d1bcf006-3d4a-40cb-b0bc-fb499a37c5df@roeck-us.net>
References: <20230721160528.800311148@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>

On Fri, Jul 21, 2023 at 06:01:49PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.5 release.
> There are 292 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 23 Jul 2023 16:04:29 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 523 pass: 523 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
