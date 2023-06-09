Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD6C7E2
	for <patches@lists.linux.dev>; Fri,  9 Jun 2023 00:27:45 +0000 (UTC)
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-33e585a0ca6so5468245ab.3
        for <patches@lists.linux.dev>; Thu, 08 Jun 2023 17:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686270464; x=1688862464;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Po9Dy9wSvVitTC0WGqOFPWrqIn2b/C1fHPDDyFi+lIY=;
        b=DDzm2sWUh49bSRGtl7BBbKtxFMd/l7wAzJoSBmrRe0cmiXpgDMlr/fcOC0pZnjDAJB
         QW8CJu3jW6VBhCK8hJ4DBb4isx+sO4R1E1ow7nyCH5YdO/9VxPr/6fqPgJ/WoprMVG0n
         Z+ZcuogQM0U94iNa6Q3mbQx6CZpoQuZg4ECUCEn9ZSlOVNTvn03J6t8hr1eyFh4iAFrn
         /94+j4sSFDqtKnK+Nz+Z/h6Pbll7TlgUHpK0DVIRfbiFe//Ev31v9bIXdVrrTPu2H74q
         GJlsMfQYdiYFbqheMVzhsBXWqG6lykOZ7upY/mCTKM3Rwlw7/8E6hv+AllbMWG934lAe
         SVZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686270464; x=1688862464;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Po9Dy9wSvVitTC0WGqOFPWrqIn2b/C1fHPDDyFi+lIY=;
        b=K0ZjzY/4zGR+sWXFlReq1wA3VY5wzQlJfXzxKPUg97oH0uiG3wzkFEQX9lWmDWfBA0
         mneGvkZWJRL/MF+k4Ux5TAdZIaOqcx7QLgqlIBWu4GAZtxF8avMiu7QKkT7SUkOSXT0/
         YJGI0AvjofsdBmF54D6bu/ZqcXfDG0X+Q6lDbN6kD11eIcr+r3pIfxUsZAnu2Q/hNbeD
         4e6qABxP43ik7jykLABnAdYFsLnNU6yowHoL5YtJe3wLJsr+dKKPmniyNFAy8W3UtOd1
         J6m2aCtA5WCTDafkRcJFstVYUKmdfYW3IVKrCSn3IuLpoyM2Z4eGBqM4/6915u1E/J6l
         001A==
X-Gm-Message-State: AC+VfDy55+GtOGL6AMzTwSmwQib/FDG6Nt5qWZdi89QihXDDtLJ04lan
	OgLCRdthzYxCZnBs+Q3iVz4=
X-Google-Smtp-Source: ACHHUZ4SVvYC6WrqxmkcahYuGNedbdY5nBQEAVvsZlnRy3l6EP8YXQFYn06X+EJKTvy4L1IqRreFbA==
X-Received: by 2002:a92:cad1:0:b0:33c:b395:a89d with SMTP id m17-20020a92cad1000000b0033cb395a89dmr169905ilq.14.1686270464113;
        Thu, 08 Jun 2023 17:27:44 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x42-20020a056a000bea00b0063d47bfcdd5sm1600578pfu.111.2023.06.08.17.27.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 17:27:43 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 8 Jun 2023 17:27:42 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/120] 5.10.183-rc1 review
Message-ID: <c6a21be5-1991-4975-aec9-f4e84f5266be@roeck-us.net>
References: <20230607200900.915613242@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607200900.915613242@linuxfoundation.org>

On Wed, Jun 07, 2023 at 10:15:16PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.183 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 09 Jun 2023 20:07:31 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 485 pass: 485 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
