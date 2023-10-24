Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7471224F1
	for <patches@lists.linux.dev>; Tue, 24 Oct 2023 18:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X7ztRU+4"
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-5a82f176860so47687787b3.1
        for <patches@lists.linux.dev>; Tue, 24 Oct 2023 11:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698171084; x=1698775884; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0rsW/EgRuVA5grGUYgdsjE0Nu8wETyCyvWRl/VLfipY=;
        b=X7ztRU+4oXdee2ykMYd63NfoHFLOUIXf8vm22b1/XPVsAWiUQxBt34TKR7zOUydlCL
         ylksjp3PpqRTgJJutPjv6tboQgLlUhfRyNZojnDi/CScHnxnweQQf1Q23EJTfF0LuaBz
         a6hBJAINv4wysFVYI7g3vO6jSnW5AW6UcPbDPtILOrkmSj0f5eJ4E3d+Qa3bVL6b0IeV
         +WSqI7/COvGTy1jwGxLfLfj/6cN/1zuvUC8ozi4bSqVUyZfEtVjvPjDGlQQBdK3I+hAg
         YH0aHyhIPsVFu9WeEHQT59tjYQQ8ZbuhhYv8Es69yDHi/fHW3XdKWaqj9/YFrDM2ubZ+
         rrVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698171084; x=1698775884;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0rsW/EgRuVA5grGUYgdsjE0Nu8wETyCyvWRl/VLfipY=;
        b=dC/kpp8EWatv7Yt9wGC/r1rvCSG1r6Thqs01+IRhAQ7Gr7TsHuVAAsKO9nNTicjXXB
         bUpVYXSAgOyxWhao8+3cSaS/gNiQ0rlS/E1FHkCAb/LlTBZWZmRWqFHmHBnGNm3lo3TW
         bhMgwi35WniF+6cDJU/I6qLXpq3WO6rYAKphyyYnIYiYO/t8xFRPl6rFjBfokz9tSMce
         80/G0Cdaeid+iP7taUL5I+k0AWqiOn4Fc7C1NgKKHQgkxExLOm99PgHVGw4jXq73b441
         ektq5vly0C/l1d5KIyesOHnkpgTr0km3KeT18KSkKMVPXFyX0MrEs2C5jjkSnsNELm8f
         30NA==
X-Gm-Message-State: AOJu0YzSylv04t9p+V/bTem9v0Zprxnj8YTlVU8dMjCPDoXsH7B3jqb6
	Z7pdYr/E8IFUmm/2D9qzR+k=
X-Google-Smtp-Source: AGHT+IEMCXpLO3cmz/C+HN7t8nzF5mpaQehzEgqMLJUU55Sz/ZBNdZqE/d0csOZtg4bavdFaETuCuA==
X-Received: by 2002:a81:784f:0:b0:5a7:b900:a373 with SMTP id t76-20020a81784f000000b005a7b900a373mr13518269ywc.0.1698171083553;
        Tue, 24 Oct 2023 11:11:23 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d5-20020a0ddb05000000b005a80102fe3bsm4289491ywe.13.2023.10.24.11.11.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Oct 2023 11:11:23 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 24 Oct 2023 11:11:22 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 4.19 00/98] 4.19.297-rc1 review
Message-ID: <fa45af33-46c4-4b15-bab7-e319410bbe7c@roeck-us.net>
References: <20231023104813.580375891@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231023104813.580375891@linuxfoundation.org>

On Mon, Oct 23, 2023 at 12:55:49PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.297 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Oct 2023 10:47:57 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 149 pass: 149 fail: 0
Qemu test results:
	total: 441 pass: 441 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
