Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90FDD1F947
	for <patches@lists.linux.dev>; Mon, 18 Sep 2023 18:41:34 +0000 (UTC)
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-34fd13f2e1bso7088955ab.1
        for <patches@lists.linux.dev>; Mon, 18 Sep 2023 11:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695062493; x=1695667293; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s4pMJlcBx7Iv5N3R0L03IsAsqiIz37MeRVBUdijoEyo=;
        b=Sfi9vJgFSs5hLTyNl9D/0jlvRkYjxq5YPynZFtFzXyS5udu7Lf1n7dg9TOg784go5d
         wGAJRZrucUYd5ToAVvEWjZuN8SLzZJo7zak7m7y5A1nJf8mX669lMfxZz4h8IHOw3BKq
         jPdntV82zO7zib6zLw2lSWhnZGVRjPS7yfSNmvCwxB1vTZX1o+tgyutQcEx7AUGxznWF
         1lZncpLRMIn7uatY8z/LIVd7KWPcBGjkzI0e7Iwv/Z/j7Swt4CO0oIbpkl29hXRFGS5+
         TaT1IWnTGDqo2YurkyLsBNcsTnKhbAsXTmCqLrD0i9L23iVc6cFE1z9bkwlNWqbXR3gg
         N10w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695062493; x=1695667293;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s4pMJlcBx7Iv5N3R0L03IsAsqiIz37MeRVBUdijoEyo=;
        b=cAt5mEnp4K0kD2fakLJknokHB3ExM0Skf22BO4q09HrBTxqQsu2BvFYHhucep06Je6
         0krQGuKbJU1TZRpROZL9T6wEIUfGjBcpRsj6hNIUqbtyYaAw6kcBoycNK2Pt7mEdj8W1
         hcPTOS8sYite/1s2U5FTgG7b84GKSfEk5r+ICEye9gROXP4eYbbhbbJKei8Jn+QChPpr
         IsfAL3WA8qa6sKpnMPodHoVCPxqEiWP52qotSmJeRzKBDDXpCAaI67ZtzV7pdz0nv5vr
         Gcqkd7lOMEcCXrDRQTs/u6VodsT/C1UJjAs9zyBgbnH5mv5OI0y2/IBj2yH7C4RvK+r5
         btvw==
X-Gm-Message-State: AOJu0YyRgP23M6R8UGXTNuDbgLGUvkPqT5vOnv6+KhhiFnAPzR6ZrYmR
	hGAqhCzLv/irt7PF9fb/Koc=
X-Google-Smtp-Source: AGHT+IEtS4MnfBIjLj4uPjcgSvARC/uLLok3Ub1KvS+X+c0NM7hmAeuYY8ScgDBA4ydgOkc8dypTJg==
X-Received: by 2002:a05:6e02:12e4:b0:34f:203c:2432 with SMTP id l4-20020a056e0212e400b0034f203c2432mr14553894iln.12.1695062493686;
        Mon, 18 Sep 2023 11:41:33 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b11-20020a92c56b000000b0034fb49fe2dcsm2786559ilj.58.2023.09.18.11.41.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 11:41:33 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 18 Sep 2023 11:41:32 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.5 000/285] 6.5.4-rc1 review
Message-ID: <1463f73a-b9a4-43c3-a02d-11af57a838ea@roeck-us.net>
References: <20230917191051.639202302@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>

On Sun, Sep 17, 2023 at 09:10:00PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.4 release.
> There are 285 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 19 Sep 2023 19:10:04 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 530 pass: 530 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
