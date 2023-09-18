Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217ED38FB7
	for <patches@lists.linux.dev>; Mon, 18 Sep 2023 17:03:27 +0000 (UTC)
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-7928ba24936so162045039f.0
        for <patches@lists.linux.dev>; Mon, 18 Sep 2023 10:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695056607; x=1695661407; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LAN6eFd4fB8Jue9t+rReqiCy+eBs2TmxKe/oinfuoLE=;
        b=PdvaG0mZLOPb3+x3qzfct2UfQAOy7SWVeTwm4lfPbBkiww6nhAOTHBGXcEAbtZwRLA
         ZnxLYCSGAedrwxhnUe0VZ6mRwwo9ersTsj1zpOIladsjlPNMVm1Ja7+TwmfujPW5r7m/
         MjFyEKos2xbnl/L0FFWFZzzsh5QdS12gaoT+QUig/PVEjkp0+gB/LTVOUTrUGDDcK+Zw
         lZSpp/yKbbPWDsxVEj0UlcaJvrnEqRlyaduwckqN9FzWk2jQo9Ag/Zh7/0EqPPMkFYML
         WPnS/LmJQQ7/HGE0VjNGw44Lcsgt7eiWUAOXfH/tvNKzeZKue+1XT5FxQGkCtjbvqdIY
         OZAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695056607; x=1695661407;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LAN6eFd4fB8Jue9t+rReqiCy+eBs2TmxKe/oinfuoLE=;
        b=aRqPPYjdCVNZ6Q4Nz8LGxhEMqT2N3MCuSCR8sLFo4Mz4wKCKtpa347Zj98Ueu7aNPL
         826ChXbWVf6srGhYpRKnNVXdGosOEmNu/2C+a1cltKyx11hZEjploWOWadpAOuqmwuUI
         wInHe7IEkpdZCUbefFzLxnQCsAn73M48VRa5ga3xutbM3MQRlHYlGhpKBTY39BXaFQBC
         CKDK0SyP2kabzJJQn74UTS2vJ23VegKXHB64i8KFyM2/E7mzdEvwdhFoyN5qIiExiw69
         fSVB+e1aRbbICtd6k3eE0pLdaSawWuBcsCXACQ1MzWSA/IVTbVnz+EpYo3LeaUriOWAp
         LlBA==
X-Gm-Message-State: AOJu0YwRI9pi4PNCH1t7qR+ykRWzEppeyk/rpWfHMNl5xpjJX3npox6P
	lwjiY7oup2g4VD5l0v4DZG0=
X-Google-Smtp-Source: AGHT+IGK7meVu2qpFrRpwKHUVrO55cSDbF7VstRtUdvHnRD8iWEdQS7od9KpvMDyXqsrVafFxATjhA==
X-Received: by 2002:a6b:5c18:0:b0:795:16b8:85fc with SMTP id z24-20020a6b5c18000000b0079516b885fcmr10619896ioh.0.1695056606987;
        Mon, 18 Sep 2023 10:03:26 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id gw23-20020a0566381ef700b00439e20a2c59sm672740jab.144.2023.09.18.10.03.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 10:03:26 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 18 Sep 2023 10:03:24 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.15 000/511] 5.15.132-rc1 review
Message-ID: <79a88da2-70cc-4d4d-b322-c44135365969@roeck-us.net>
References: <20230917191113.831992765@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>

On Sun, Sep 17, 2023 at 09:07:07PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.132 release.
> There are 511 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 19 Sep 2023 19:10:04 +0000.
> Anything received after that time might be too late.
> 

ChromeOS build tests complain:

fs/ksmbd/smb2pdu.c:6256:6: error: variable 'fp' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
        if (work->next_smb2_rcv_hdr_off) {
            ^~~~~~~~~~~~~~~~~~~~~~~~~~~
fs/ksmbd/smb2pdu.c:6367:21: note: uninitialized use occurs here
        ksmbd_fd_put(work, fp);

That is caused by

> Namjae Jeon <linkinjeon@kernel.org>
>     ksmbd: no response from compound read
> 

The compiler suggests to initialize fp with NULL. That _might_ be
a feasible solution.

Guenter
