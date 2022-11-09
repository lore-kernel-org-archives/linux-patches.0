Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A6D17C2
	for <patches@lists.linux.dev>; Wed,  9 Nov 2022 02:54:46 +0000 (UTC)
Received: by mail-ot1-f48.google.com with SMTP id a13-20020a9d6e8d000000b00668d65fc44fso9431228otr.9
        for <patches@lists.linux.dev>; Tue, 08 Nov 2022 18:54:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZI91qSyXBgg5eWntb5w7n4ZnK6DuW9VOjYf9yRXokSE=;
        b=cXMFmMvjmVjDuBDmuK1SNRh4KiUO3IUSV0k3dSyNVmXOiQOr6uUqKMJPmTd9eASZw4
         sWVyHI0WnT8Lort3i7atOLWQSrj4PFbSAiLTO4rn2EYzgDwq0HCdaFqtzdgtE0+DLNbA
         hc+fTdnAwIZiO5SSzfOu64mG56V+9/V0hZ9AS9xUUYiKCuexjhViEpDJcbGBfEz8JoXZ
         LRTFv+b06lpAP+jDhr7SFsIPLIXdXc9mtMJ4kBLKz8A0nRpoS9iXftewIs9CDxov0Hfa
         /fiV+lziClyW6UPeXY8Cl+j5TN/nXmGwjPzxd1DN5fE11FwSXZOsFD1KzhqvORx/dol5
         gTww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZI91qSyXBgg5eWntb5w7n4ZnK6DuW9VOjYf9yRXokSE=;
        b=G//vpDuzG2ngvCOADHY5qoaBy5HhRs8HpbIAyFkzpMQWXa1ui2Q+dPq8j4yQHomWVu
         lzKuIOs9D7UiN0D7VUavauyrZd8+OBcj6nvWecJbPsE85VKLSNo4cZ3W4DnReoPvlJgm
         d50qBq37zcgiL9jh4ZiqHo4o8yBIqSepXNAN8nSdRnsqCDWrNpe4sfx2RZLaPJWj3jSZ
         uVFDGXs6DqLpZ/855cBjOuTU2jPTfXz3vbmO2gyOXa3yhkRRITj9n8KZkVvJnNEcMWOB
         ypDBnkucvAHCIKEe97b6Md8i82qLxbZWhd+YjcGCYQBmkfIUd6dZ52aZ8FjzT60WVWAx
         +SPQ==
X-Gm-Message-State: ACrzQf1rI2H1OO288CzQ3WIfJsnwMepWov4unMXTVkHCVIPUTFb6Sary
	QMTJS6JPABgQoN4pDVBia9w=
X-Google-Smtp-Source: AMsMyM5GNCN92gKAwahnOWtJcYJg8dzgcv5QRL2staVnafL0b7uBDsOXWSq4dS4g96zgJpsJk1RoeA==
X-Received: by 2002:a9d:4690:0:b0:66c:5830:426c with SMTP id z16-20020a9d4690000000b0066c5830426cmr23853563ote.144.1667962485744;
        Tue, 08 Nov 2022 18:54:45 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o84-20020acaf057000000b0035485b54caesm4177955oih.28.2022.11.08.18.54.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 18:54:45 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 8 Nov 2022 18:54:44 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net
Subject: Re: [PATCH 5.15 000/144] 5.15.78-rc1 review
Message-ID: <20221109025444.GB2033086@roeck-us.net>
References: <20221108133345.346704162@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>

On Tue, Nov 08, 2022 at 02:37:57PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.78 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
