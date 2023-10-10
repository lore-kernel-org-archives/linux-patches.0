Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657A4225A6
	for <patches@lists.linux.dev>; Tue, 10 Oct 2023 18:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N1E34srC"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1c894e4573bso24368065ad.0
        for <patches@lists.linux.dev>; Tue, 10 Oct 2023 11:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696961952; x=1697566752; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7gQb8404J6lWgFy3ohXNTgpCeEXU82HEXR0Rg9JNexQ=;
        b=N1E34srCOK9rvLeXQW/cOsgK5K3WsIu33JLOzLOxiocVKpUjDhGqxwPNWmRdKtG8sQ
         6g9EujtSzqaL35pqxusOLmo3kO4Hj6amEM+uyuC58e8X9qEFJXcsP/B+TCIW4unIMfHP
         tYCGdvhiZYP/iLn7lVKNwNZQkl18GduM0ETtG6J9+vXjtmlVrGDXdExkoyDFaRMgTNlp
         TfvAAIsAQIF/dy3uwKXcQF5iGbElBy+wMkHtXJKJjb7K5aF96TUrYvZUV9PVlF2JnC6U
         8MQ5MhGpopISqRLMI7NrTgPQXgEmpAM0uMk7usVb7h6iVja5YJsp2H48zPP8TnH/lm02
         7faA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696961952; x=1697566752;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7gQb8404J6lWgFy3ohXNTgpCeEXU82HEXR0Rg9JNexQ=;
        b=PJLq4gP9pnrdAcx52FO4yJp9c7/JQGXUvbIwEhMp/4QQhcdg5yrrHKkKx8S3ZKp7x+
         4Vn4JWCrA/2UeFKAgNxPt7V+wJdmDcPUdvvgJzm4b7w2k07y0jYANjkVIcIOjokfD1xV
         d64+1tymo5oodm8RF3riol1McMlNe5DX5FXZTbtLFwVGKvumrUmoPSK0kT5upn301LGB
         tRunzFAHAuyFoB7Mze8lW9FEfBUAJssYmYojs5dBtm44W7vqNxo5ILK/6sREmS/YSQuQ
         zJ4rANg4IRtKYzWDFeq0vgm8qN5yB7XiE3dpyUtSW0zYCcn4oFwLQFXeIsoeGp0buDY5
         uXmQ==
X-Gm-Message-State: AOJu0YwY6Ljuz7rr+59KsTpVl1vRbHjlCRoQeh+rLnsevPO+i29NywtN
	YOpqhxg2niGDPaI32C3dLck=
X-Google-Smtp-Source: AGHT+IHvf+r5B3JiSJqEQuunama4l2ZFEyMx2/gHPwZS9pHkMtKfH+0SxmLtDE8nV5ngNEwXiy5vfQ==
X-Received: by 2002:a17:903:22c8:b0:1c3:845d:a4 with SMTP id y8-20020a17090322c800b001c3845d00a4mr16881354plg.51.1696961952556;
        Tue, 10 Oct 2023 11:19:12 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h6-20020a170902704600b001aaf2e8b1eesm2000429plt.248.2023.10.10.11.19.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 11:19:12 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 10 Oct 2023 11:19:11 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.15 00/75] 5.15.135-rc1 review
Message-ID: <484a39a8-161a-4c41-862e-f268174b98b7@roeck-us.net>
References: <20231009130111.200710898@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231009130111.200710898@linuxfoundation.org>

On Mon, Oct 09, 2023 at 03:01:22PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.135 release.
> There are 75 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Oct 2023 13:00:55 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 509 pass: 509 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
