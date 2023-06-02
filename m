Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68BC33301
	for <patches@lists.linux.dev>; Fri,  2 Jun 2023 22:34:32 +0000 (UTC)
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-3980f2df1e7so2121996b6e.1
        for <patches@lists.linux.dev>; Fri, 02 Jun 2023 15:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685745271; x=1688337271;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WqgmYGczNFZ/NxuK8wUSUG9yqFsVwQYuKEfZ0hxfcuI=;
        b=Pau58WkbrvLUeyPHeliMwhF+v3NSg8tdaG+Vil9evApTw24yHFmLPSaahDwHCSfsPQ
         DPadvrd19GnU3ftpTfTexEQXmRQ7nurdfZOrSgjSNjWRzHRlMWIQS7kiz83rWBYmswg2
         fVx5opTMhbWbKC5I4vGiiXeSsK3wyQeO3CitBiPbOsH3dL/KYwtbkhRAKagU+b+fLAfG
         GgpfBvaCtcsfwxm4iIKmgwEzpqATHCiJvOGrpEjVUYS+cR0dVGUkB6sgv1TYr2tEYQpc
         MBkleYRU+llEQ8SUk/YnU0JALSL1WObhKg6UuoTSg4jc6QEZCEEYfcVnkS6D90BZENES
         yXng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685745271; x=1688337271;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WqgmYGczNFZ/NxuK8wUSUG9yqFsVwQYuKEfZ0hxfcuI=;
        b=f5o7H+XhPTRonuICLxVdsMF81wfn2xzZd6Mx51k7FDNMgDDmjN+Ey5k6Wetajb3ll4
         yfzXoONZAYUfnwVNIAYyKZxhN2fzeQxpLSzgTzg7zD73cKVl9dIWzJoC13ssIiYmXkV4
         WmF+2zwbQjCApOJqQlu0wtqV4s3GH0xnfy4+BeNoCSDa59Gq1G4lAlH6YFK+6UStm7e6
         xGEYeDVBoFcoZvC7s3g3Y8tgB3cqry5ErVBGfLjj2ZfjgjWuZt+8zS0Xma5SBIbUesha
         xPsyL0OCvQYoqRLGq290tyJ2NimESrjMz70eBRWrJdEcrcVVgjJ9xTG2VM5OM1RAwiHo
         JzfQ==
X-Gm-Message-State: AC+VfDwOJ7SnsNtvxNuCUJr7GYIAiUf5BHuEFyYHvYtGdBF+hem5LYjj
	+XS87xP6c9dpMdg0XqKH2go=
X-Google-Smtp-Source: ACHHUZ4XJbgsdVwI44qv7xOu9RXIrKEn8UqTb1mGi7hqfdPEll6EBUbtwK0kfYR/CLFF6KVUi1ZUgA==
X-Received: by 2002:a05:6808:3a4:b0:398:f84:2862 with SMTP id n4-20020a05680803a400b003980f842862mr1067523oie.52.1685745271635;
        Fri, 02 Jun 2023 15:34:31 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v6-20020a62a506000000b0065007825f51sm1425344pfm.79.2023.06.02.15.34.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 15:34:31 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 2 Jun 2023 15:34:29 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/22] 5.10.182-rc1 review
Message-ID: <6f7030fa-e931-478a-8eca-31208e2d1769@roeck-us.net>
References: <20230601131933.727832920@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230601131933.727832920@linuxfoundation.org>

On Thu, Jun 01, 2023 at 02:20:58PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.182 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 03 Jun 2023 13:19:19 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 485 pass: 485 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
