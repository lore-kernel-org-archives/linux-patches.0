Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715807473
	for <patches@lists.linux.dev>; Tue, 27 Jun 2023 21:34:46 +0000 (UTC)
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-6b74791c948so2619276a34.3
        for <patches@lists.linux.dev>; Tue, 27 Jun 2023 14:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687901685; x=1690493685;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZoNIkdlIM68z5SetPdRPA7///fyuGudIF7ZaSXzBhYM=;
        b=dcEN+fI86VBdAR0QHrg3+bEaX+Z4GeThNqqS4tP+iMKAMlqNRVLfM9Ng3dFwz/41BD
         DXVfP9vsSX7EPWGp/Jel+s510eBGtrU2G+vNRHiJwl8A1i2trlsyc9yBoRz52OCV9CUn
         G2hPCd0sLeEahC4shorBtaCtQdr2EIxO5hPuEEvVA38iG0Rn5po10aaveozb15Zr8fZQ
         bcmhPzxpGpK2+4oh0dUiI/YD/8gVyytT/f98zQmiJrfZIpFq/Mi9kIYun0xajlcyjrVc
         3hKvuHORwxqvRCZwJ1r0qN6fJNYN8jhI8EUA+UPvJYPWfl+i8ivyWT+koTtinLzBR+G3
         iFCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687901685; x=1690493685;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZoNIkdlIM68z5SetPdRPA7///fyuGudIF7ZaSXzBhYM=;
        b=Ewdnl8wOh8DY3763FCPBnE7ZB73Yk9IWYgl9PnD4QwEH7LOpX6rSD/ebo1wL80dU65
         mfGnOFEomAiCLbvLZ/JmokF+D4nzZabgE+lcHB/rekJSDCv7KQJMuZN6J6N8dy99qLct
         KDVyi2P3IPfil7KhpISNdMgHOpyZiZyV7iheOSYPNvKXwe/SnEYNLSv5Wf5nm7r6FVaM
         disOc/gkc+ESM4CtCIHmkkpWMFG8VWMMMX6ygDLFzMd8/T1y2Rr4aCaGooZ/CPO5xVAW
         cUaJrCwf7DjhGRAl/72SMIZSqmmQzrKlqy6RFJVGHlpCLIR4XUczjxLp4u4mRLijbDVp
         iLaA==
X-Gm-Message-State: AC+VfDxF0Hn4jq268NRf2LMPvoowJxFtEifXa8Z7UjDW638QYeP3ARjW
	5JM3Nepew7rDdb2Cij6Q10k=
X-Google-Smtp-Source: ACHHUZ5w+b9NgKl3jYcpgPwltg5qsZDlTcEatjyr7WUFzMb4VT6gWtInaoVHHZ/14rQHD/ai7hXEnQ==
X-Received: by 2002:a9d:6343:0:b0:6b1:d368:557c with SMTP id y3-20020a9d6343000000b006b1d368557cmr30900092otk.30.1687901685457;
        Tue, 27 Jun 2023 14:34:45 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 38-20020a631166000000b0053fb1fbd3f2sm6123749pgr.91.2023.06.27.14.34.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 14:34:45 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 27 Jun 2023 14:34:43 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 4.19 00/41] 4.19.288-rc1 review
Message-ID: <effdb8fc-0796-456c-b93c-3968278ee442@roeck-us.net>
References: <20230626180736.243379844@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230626180736.243379844@linuxfoundation.org>

On Mon, Jun 26, 2023 at 08:11:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.288 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Jun 2023 18:07:23 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 431 pass: 431 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
