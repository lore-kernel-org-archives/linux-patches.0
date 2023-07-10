Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3382581
	for <patches@lists.linux.dev>; Mon, 10 Jul 2023 18:47:08 +0000 (UTC)
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-bfe6ea01ff5so5921773276.3
        for <patches@lists.linux.dev>; Mon, 10 Jul 2023 11:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689014828; x=1691606828;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l+e9Uwr5qc+lETVgqhuxS2sDSgDIyaCoLKWXGQhfhM8=;
        b=EWRHAx0bvPOAglJM0S8gK5Hv9aoMSGq2QqlxfcB8wusYDCJ5OBepPkmptt3/XfyNRC
         SQmiL0wVcnkGLiyHC0ifgymkojTs1kSq9m3OWxDD42HD6cRmjlQszYW3G4wVwOiISE1p
         bZYywsQlZDnE6pFMDRL2x0u6pnBlkU+zRSiABvT4qUwUlQgb86/8iabqtisNH2uM0KWX
         iaQVpfAofBzrghuBYpS2gCDApI/4hMVH4fZdmpusUZ3DEYBCTAjuTLWmq5kWnygg0Bz8
         Mehibba4+SYuc6g3H5sNOhx49fDI2IsLRwOrLTVLu4JG4LHvK5yKR30RX2xbCZddrrDp
         jK5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689014828; x=1691606828;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l+e9Uwr5qc+lETVgqhuxS2sDSgDIyaCoLKWXGQhfhM8=;
        b=i5dNMFE45cTp304OwR3n3NqmvYWErLTcnCTvnyFZGDcfTWOVyXkuVPKuMfOr0gPZ7G
         l4WFg+hoKp+9PeMGiw6fOCzklJV8jPU1PeGT6c4wPaQU46wHijPdxama2UlUZcEjikxX
         Gc96Fz7/Dgge7/Fotj0nfxqlyScsvGzjk6We4rbdsMl3K4z8UslpgpUK9Mnt0sPjMjwn
         dcheuwSiEG24rXJSWd/yb5Jp1yUcY2bV8R6HGFgW2mRS2+FrArzyB6AKdtyZGm1C+k95
         UO8BWIawb07TLMU/TbViq/N80e9glfg1YmO3Ws2lVHXkZMHEE3HMzHU71idVYqD3SCrf
         DsaA==
X-Gm-Message-State: ABy/qLasfNxIBW9z5Bd4WgrVVjGnA4We8L+iFpPwbSVmoeGEApKKbxre
	Y+fLx04q44K6qSRjq25xm2I=
X-Google-Smtp-Source: APBJJlE41i05qAHdgQLCqK7cflEjRGKFjOomlZ9w+N0fqyZicN3jiKw6stBSCJdKy8ilqTwlPRgvzQ==
X-Received: by 2002:a25:a409:0:b0:c81:ea4:c660 with SMTP id f9-20020a25a409000000b00c810ea4c660mr4849770ybi.8.1689014827889;
        Mon, 10 Jul 2023 11:47:07 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y18-20020a259292000000b00be45a29d440sm86689ybl.12.2023.07.10.11.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jul 2023 11:47:07 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 10 Jul 2023 11:47:05 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.4 0/6] 6.4.3-rc2 review
Message-ID: <720d1a58-9f0b-4647-8cf7-047f830f68be@roeck-us.net>
References: <20230709203826.141774942@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230709203826.141774942@linuxfoundation.org>

On Sun, Jul 09, 2023 at 10:45:16PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.3 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 11 Jul 2023 20:38:10 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 520 pass: 520 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
