Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F11A55
	for <patches@lists.linux.dev>; Wed, 21 Jun 2023 00:37:52 +0000 (UTC)
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1b50e309602so42932265ad.0
        for <patches@lists.linux.dev>; Tue, 20 Jun 2023 17:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687307871; x=1689899871;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k8k3mdQd8K4USROd4w8UPhJY2YwWLEAlecS6pG0RGVs=;
        b=kwf/gC6mLX5KQYsz7kvzn1TS/gHOjeUK1EZeQnJwTSb0i+VN5zrBqU5b1JXi3rmQKK
         e0rE72YyERLEhi8tNFKfMJxZDGdjtqIwXAB/29iGverXyu0HuGWXwMj1ogWZWIAvQD/M
         w/Zn61gbn/H6E5B9kERWixe1H69dzdRPcXWKEm3PvW0o3zGHnRQndwlsCtlqdXpsHRKJ
         L9LSIWF3ZeUqfPteTkhjVBp/NZY5nSeaxPNI69UUY8zZtrdXDzcJumO7lT7TU387vPTL
         SyThrx/BVWC/ZIp9QRG6ST4Sg4ya95Xreej/e0pplxB6UgOBgqPJwFhejiUVQB6VUNxq
         2MDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687307871; x=1689899871;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k8k3mdQd8K4USROd4w8UPhJY2YwWLEAlecS6pG0RGVs=;
        b=FvMNQ7d5KbdG8GI6g7CIaARM36f1Qdnmhy+5ZS9+Z2Nb5yMZTRJR2fbwhmIMiDAG89
         hCvuXZKzxF5dQ2qmNBls1TK6ebbDUF/UejIL/ouskIG0c4ns+vCD5oLYKictQR7SdqSi
         VrTfZF9mXyvW7aEDhGIxPDebnfXyiy/79qFtSjtkkm5zZOdhN/dkJ7aj34jwFpkVEQWO
         EJHBDVCtO6rLK2KZYKjCzKBLg+RXqG33iEZChmT/YbtKGshpbX4T7uMUhSVQy4fYoSXt
         aUm1K1SfQvt1znNLs6jSWLJwrQ/WuYPQW8uYkpf/oa3ZmtNx+ld5fNHduZNsL6JizJUf
         PwsQ==
X-Gm-Message-State: AC+VfDyVbIdGsxxtYBf5HBwY6BBG2vOCEBEYKPQPs4GZeKV176RJ7x5w
	FTe0+4+u9yVfsy6gAyAClafNRwyPakI=
X-Google-Smtp-Source: ACHHUZ6u2x6A3/oe3ZEQbeVpQa39a7cqvoctDIYRjmqTifSWDRePMgmrRczhdpUwDjLMPFDfrRimoA==
X-Received: by 2002:a17:902:a3cc:b0:1b3:ee49:8334 with SMTP id q12-20020a170902a3cc00b001b3ee498334mr10720833plb.52.1687307871466;
        Tue, 20 Jun 2023 17:37:51 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id jd10-20020a170903260a00b001b562175158sm2135786plb.244.2023.06.20.17.37.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 17:37:50 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 20 Jun 2023 17:37:49 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/49] 4.19.287-rc1 review
Message-ID: <4d153532-0664-47f3-95a0-115c94e983f5@roeck-us.net>
References: <20230619102129.856988902@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230619102129.856988902@linuxfoundation.org>

On Mon, Jun 19, 2023 at 12:29:38PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.287 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jun 2023 10:21:12 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 431 pass: 431 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
