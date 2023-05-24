Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E142ED8
	for <patches@lists.linux.dev>; Wed, 24 May 2023 00:36:41 +0000 (UTC)
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-64d604cc0aaso130373b3a.2
        for <patches@lists.linux.dev>; Tue, 23 May 2023 17:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684888601; x=1687480601;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lM8mwZf1wzxcL+2sWIBCczl6sqGrKSXPMj4ZkVBKhOo=;
        b=qNAbacy/jdZ5QIIrU4HSoJTCBeTPSZD4068sdrvfUVmOZFMp+6SeCedv/AeJ+E15mF
         0+UkwUFzlzAf/6hFDe21z+91zH7wZvOa3OpkEFLnZJiQZgUlmvcAdQ55e9LsJwWtlGmV
         TIa10HGUcfM4rjMU5E3wOh3zPLYayMMfD1t+afK4/uZGtIKjRVt9k1tQzW+C8TFzCq6l
         21V7EI+LBo9g05MBp7+h4bIskjcn62mJZ89R5wAjAPUDvaSqXUpv1lHekUUY5RNhS7po
         IKNJRMH9enNn/gDyxM2nKUC1kalvwOETiZPCMG0GnTpdEsY2gULXv8oftvO50yZVuQ5d
         mc7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684888601; x=1687480601;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lM8mwZf1wzxcL+2sWIBCczl6sqGrKSXPMj4ZkVBKhOo=;
        b=fMXucabYiFKkJ1nsA52EEs/bNSmK3sOP6hfsMNR89c34FHb24agUhDAWoI/H0XleZC
         nhcnMFnJYKCID1F+2wSOfTrxtN62iwTvRordbcN2wNkuRTwqH4NjE4qM/12GOxVCcQ+3
         09NiKw/lLhzelIJ+f1kkQm/wb+6eyEAosXYYGPRaI78BfIy51LSPqy8/Ek2q7QPwW/i8
         ynmuQLkKmu1t9hTbmpPmmz11KP9Yg5z++8ldpk/3IEK9d1CfNgEKxV4TcYLS2OloI75K
         6vHyrnYz75haLmgismcxoUkPrvndjWAHkhgkqDrpfuVCEbC6wRr7ju0Cu1KUmvRVeZSs
         DpXQ==
X-Gm-Message-State: AC+VfDzpgYPz95oQNSxKEUsu69HkKVLb8V7MDpslgd1OZMskKkHNpJaj
	/WSwCAZJtXXhblULLBoMz8M=
X-Google-Smtp-Source: ACHHUZ5HSIVPXwLR65r7ykB4jTSX75Gv5mKrFciBfJIMqHnqDHnFeyAEFkNGiBYPcgVvzWXe92/Wng==
X-Received: by 2002:a05:6a00:2488:b0:64d:3227:b806 with SMTP id c8-20020a056a00248800b0064d3227b806mr1078723pfv.33.1684888600567;
        Tue, 23 May 2023 17:36:40 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i14-20020aa787ce000000b00640dbbd7830sm6552369pfo.18.2023.05.23.17.36.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 17:36:40 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 23 May 2023 17:36:38 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/203] 5.15.113-rc1 review
Message-ID: <c9e32599-339c-459d-ad9f-f9e29eae2112@roeck-us.net>
References: <20230522190354.935300867@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230522190354.935300867@linuxfoundation.org>

On Mon, May 22, 2023 at 08:07:04PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.113 release.
> There are 203 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 May 2023 19:03:25 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 499 pass: 499 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
