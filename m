Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3831F7B
	for <patches@lists.linux.dev>; Tue, 25 Apr 2023 01:04:36 +0000 (UTC)
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1a98ac97d47so2971075ad.3
        for <patches@lists.linux.dev>; Mon, 24 Apr 2023 18:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682384675; x=1684976675;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FARWeYOPpB4n6dDxng+zXr9ela4FGRNet1WYVOEHIGk=;
        b=MZJEJzgRxL+pwRL2J45JRGzJYxx0w2AWiMaTSJLaYje3PVn81jEFIIJCw+Rut7LXMI
         eYsBT2xlINCXJ5T0tuiY9GkFiBt+W7fp+hX2XiET1VpyYADpIvIddjmxHYYF1mrSaK8x
         3t5CvKWQ2vyOwIinTsfTdvWCxby9Xz1wsboNfJPFvDt4apQ+w9vSqCIh1F6vRr4Z8mF4
         NDifR15PGnolE5EDcKJ4wqJWXo7taw0yN+l2M2Y8JzhhsiSJNpmL+A6ZEYSIBVvQa40Q
         KCCxby9HnsZ5dhIACI2lbBruCtN4Hyv8XQ2HA/9xfardLmWXlyAUJ2LVnHhOELXYu7Xr
         YEFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682384675; x=1684976675;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FARWeYOPpB4n6dDxng+zXr9ela4FGRNet1WYVOEHIGk=;
        b=EFFBIZGN33Xp63eqI1aMuo8A2tmZmrMROn7RH2hHJK04SkwDpc/lfbcN/AMtsYo8M9
         fq8WigYhDlK32Cc2yiBgsH42BEjo5S6sgFhc99bYtSq26VhZKTbtmLt2EplB066RgaKI
         Lz4W3yrzr5hUKN5KlTpHz9k1kW1zLvh2FB4BSILAtl1+jSxlRsIF9cWAlA8qrf9v4W2K
         wB8x/2WzLSC8W18qOA+O2JcM9cvCGm51FQjnkOuYb9Id1Y4KCz7JZqdQeEINlonUqBTf
         A9vWRQ8nbgo/RpSJFWUAqnsS6Wu7OS+QzDzqluUv768emQtyJu4bUtHixJimidrf5MAg
         6z1A==
X-Gm-Message-State: AAQBX9dhUZfRYnP1jnGS8WS3K2hjw7SVmo/fEt1GdNBIjBwzy1HnKjnH
	qgXrBNh9PtDZIykRUURHuUpvVTMAaiY=
X-Google-Smtp-Source: AKy350ZF1ND6/05UJhKnnCCHDMNjFl5lNdDvX0H8Ab7WJxbquc2uHHpXj6OKO7jkZ+5h6lJe70HKpw==
X-Received: by 2002:a17:902:fa90:b0:1a2:c05b:151c with SMTP id lc16-20020a170902fa9000b001a2c05b151cmr13529878plb.34.1682384675643;
        Mon, 24 Apr 2023 18:04:35 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s1-20020a170902988100b001a1fe40a8dasm7049000plp.262.2023.04.24.18.04.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 18:04:35 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 24 Apr 2023 18:04:34 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 00/39] 5.4.242-rc1 review
Message-ID: <b2bf3e7a-be03-42ca-93aa-3520e3b961fb@roeck-us.net>
References: <20230424131123.040556994@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424131123.040556994@linuxfoundation.org>

On Mon, Apr 24, 2023 at 03:17:03PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.242 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 455 pass: 455 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
