Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6812D02E
	for <patches@lists.linux.dev>; Tue,  7 Nov 2023 18:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nFhM9yme"
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-3b3f6f330d4so3512380b6e.2
        for <patches@lists.linux.dev>; Tue, 07 Nov 2023 10:54:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699383278; x=1699988078; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mGow/u7Vib+2Ht5vsLhy73C5dOs+P6UgdII5R1yP8AQ=;
        b=nFhM9ymebp46nMDhBN+y4TLdprPlHKiau69g+deJvXmOrkGmsBeje+5yUvqiCN22MS
         n8G9bmKIzNhzkwh1TCL2MFpYuKGlsSmR/doDjhtQ3eOBphqpZ5i5FKaVAus4rOX3ZaMM
         hUh71guPTXLv7EwROt5hYmk0d3vQZuPsu8pQYomIgCge8Id3itR7yGojrMq2QMiZCPHI
         p2vvZBpZKjX8mcaCbBTacc1mAv3+2WgkJ/dZZmIESxVvveAUdGgCl/HIaGf20EmgEuCE
         zoEHBeh9RYAogv2g37GQcItYKC2j93sIzNJvcx+JtD83JWB1LQ/1dHiromWVwyZWE7IF
         ROwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699383278; x=1699988078;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mGow/u7Vib+2Ht5vsLhy73C5dOs+P6UgdII5R1yP8AQ=;
        b=HHCNMSDNyv6Cr5jnPUXEy4W7lnzkaqOgFviSQH2vqFuZ8A//jnN7N4BmWhdcVY9NW5
         lPHZuwmEsdknaXg7O7SSPZaq6iYdLstfofmgBMii0Wvyb/E82AI35Xf6GLW1LLjH2Uuj
         DQEcotqe4dqNxB4JlkPQY/xyiXX4WKlAaiCmsQmY9b0RN8QD49Q3Rv/loELOchTi5EMh
         aRBGxuk2BTsRq2WOMVp0aF2T4o+Ml152fYSMtORFqfNMN15RYn56e/vd4fpto8Hm1w6O
         SnOZUY9X4zxyYwiEGOq96vIAVpEPqnNChKJU2zU9cFaaOIGWLxsMtzfJtXuzv8m451ly
         U3UA==
X-Gm-Message-State: AOJu0YwkNensStlzZssTW4FujjUP1egJTst92d5hpf8TGJJA4tsxWw09
	KilZ0aRQU5ccAmzOou0iGWM=
X-Google-Smtp-Source: AGHT+IEeCsmGrryvOpIbn0s3GUQ9X/I5dVQhL/HXW4hqvIOp/Kca1LSoJK6n1GlYM9BR2iVmeibqCA==
X-Received: by 2002:a05:6808:6389:b0:3ae:1e08:41fe with SMTP id ec9-20020a056808638900b003ae1e0841femr29939908oib.57.1699383277975;
        Tue, 07 Nov 2023 10:54:37 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c3-20020a631c03000000b005891f3af36asm1666523pgc.87.2023.11.07.10.54.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 10:54:37 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 7 Nov 2023 10:54:36 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.5 00/88] 6.5.11-rc1 review
Message-ID: <a27b0a21-8dac-4d23-b3c3-38382dce79b6@roeck-us.net>
References: <20231106130305.772449722@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231106130305.772449722@linuxfoundation.org>

On Mon, Nov 06, 2023 at 02:02:54PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.11 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Nov 2023 13:02:46 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 530 pass: 530 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
