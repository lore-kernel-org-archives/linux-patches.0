Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB1A5F1E8
	for <patches@lists.linux.dev>; Tue,  5 Dec 2023 16:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GZydJ2BE"
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-6d858670630so3183599a34.0
        for <patches@lists.linux.dev>; Tue, 05 Dec 2023 08:44:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701794658; x=1702399458; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3zC0jkdkYRUNrXPSR+3nJSIkrw8CIUlw8B0SSsidNcI=;
        b=GZydJ2BE4H8tiine3LC/wV8BLFTB5DddMdZl7XPlxbqWwLqMeYOxVlslUtQ2Ic6BCk
         ao0/qTqs7WnRVd9a5WQy3PvSfcDA2T2KIzmGGSPkJ+LPDKXZLMbALDxC/4xU2d6Um9nu
         lmQm99oQM1pZcBMzRryvAs2sYMzUq3MNaAi0I2EnnQndWaEV9vjnJzCR9HyeXbALF39W
         8tmdjJB35AqWuIkwBb2H5tbZqkigWPRgEPXKDLscWzUR+mzvbXDmfw8FosZdAEst7EB5
         Dx5zrLRHx9+cmegHYTPacKKAKUbY65ZbhP0yk8dQ+k2ldv1ZtoUhnLYN/4OYAGDgbzok
         Fvtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701794658; x=1702399458;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3zC0jkdkYRUNrXPSR+3nJSIkrw8CIUlw8B0SSsidNcI=;
        b=nQ/vEMfMnHn2WSSppLtAanCnbfuppMSFGDk9XJrA53SIgR89w7BZe8EEkF7WFkb5+R
         BOfYHHW4Byoc0h3HrTgXzrl8vsrXSPv7oQTYdJoM4UCI9qW7hQH0x0YH/4i+8NFWRy/6
         N/cSw0/9/DkZewd3sv6TmsaJwlI33uUDUOWf3DRQu7ZBqGvbxEfT4zBOxrN9R+oHSVNx
         LF/OsHrW25kxuZYFuN6+jG9NnzADnb/clAIwDLJgdHabehWh8pXWZqHnqaLxXCzDgcUf
         xDwa6Tq8Kpd2qwj61RJsWGf82dKnZgabDb3mZAmmG/0mKcjCJ3rFlEoB1609dUL1vgXp
         278w==
X-Gm-Message-State: AOJu0YxTMEfRIANf4N9BHE56K8jP5Gg9TVjbuCthy3ZWEZihughO7Ku1
	uV05cMsl7g+H3jDsR6BDby0=
X-Google-Smtp-Source: AGHT+IFXwhJ60+DmuGGe2hCYSg/v4QQ4X6790ptuWg/gW1gI08VvtwzdXK5WZLNvwqFxMJbYsBcRNg==
X-Received: by 2002:a05:6871:4417:b0:1fb:100b:a25d with SMTP id nd23-20020a056871441700b001fb100ba25dmr8042737oab.74.1701794657735;
        Tue, 05 Dec 2023 08:44:17 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id wc12-20020a056871a50c00b001fa3c734bc5sm3389122oab.46.2023.12.05.08.44.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 08:44:16 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 5 Dec 2023 08:44:15 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 4.14 00/30] 4.14.332-rc1 review
Message-ID: <fc6da6a6-2867-4399-ae6c-e22e7a57648d@roeck-us.net>
References: <20231205031511.476698159@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231205031511.476698159@linuxfoundation.org>

On Tue, Dec 05, 2023 at 12:16:07PM +0900, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.332 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Dec 2023 03:14:57 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 139 pass: 139 fail: 0
Qemu test results:
	total: 438 pass: 438 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
