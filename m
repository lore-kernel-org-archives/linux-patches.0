Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6E1225A2
	for <patches@lists.linux.dev>; Thu, 16 Nov 2023 23:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gbf/cXGM"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6bee11456baso1299964b3a.1
        for <patches@lists.linux.dev>; Thu, 16 Nov 2023 15:43:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700178216; x=1700783016; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uOLzRp1jFV4lvEHHrJt5+/etVwFfd72UkkZsGfejAIM=;
        b=Gbf/cXGMx4kccamOMXAGB0tPH7y5dFu7/J6zkPpcyn4/It1fp2EwUs5q0A42O4eO1V
         Rc9AfbnUYZPRoUjb/0LuhGxh11gxIdLBPVSZwUT5hZsOusngv0AbC6ToaJXxe8J3Gjbu
         HIUPiAf9QuRANwHm2gehx8bC52f8KGnqHjOzth8i6RU/2l99hQIBaEn0X8V7viHCTXPG
         88xnXVJooxfPTtTvjkqhlRVggzAWEa2ReAT5RbvoKDREpRxSl1Tupii/OOmuLpKY51lX
         i5ME6ZPlvidDILTIoiG6rJIJboViRAPWJ9NoiHSwYjmJ2KlXpSWGUrgrYveJUTpb5lom
         0JYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700178216; x=1700783016;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uOLzRp1jFV4lvEHHrJt5+/etVwFfd72UkkZsGfejAIM=;
        b=Ynybghu+hyUBGRK7kSLK5XTiUTKCMx0Gs7n9ECKGz1Jxle0b0Vt5aPnJrB4vy5wMJq
         apoyxAgP1qzFjcMyb6eHEmfIMPTLX63cu5Ffr76TqBS20b2WaqIBiEuftf8fOPP7gikT
         NrtRQMtiGbSFvEPyWxQhj94KJPP9CybpQ2U79f3DN0asQTuBAwanU+n/HjgjiOKObwJ6
         ExFRYU1l3/ehKGMkH+Ph65L+qkvSVZ36DsKPTxcXeMEV39ncb63EI333jgYhvpJWQlhD
         CCUqjOoecrEfgJ8lCW54tv4D5z8PHlSF83acp9VptGnfsdtPNxm0AK1iwyfshlka4gne
         LmTw==
X-Gm-Message-State: AOJu0YzWIHAJaS5DqkCpBpygNQINO4y6MVSF2ByTXnqLKrIXBvQBxi+d
	X/7I9YWg6xFDLR9ZiPBOsr4=
X-Google-Smtp-Source: AGHT+IEsnogbn0w5gfWapOzjXy1LB76mKSieHFNS5GzGCdx7PaFaWqobcYGd9UzXeGygXqXWJ3zxig==
X-Received: by 2002:a05:6a00:93a6:b0:6c3:3bf9:217e with SMTP id ka38-20020a056a0093a600b006c33bf9217emr17557480pfb.19.1700178216221;
        Thu, 16 Nov 2023 15:43:36 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y10-20020a62f24a000000b006c69851c7c9sm267380pfl.181.2023.11.16.15.43.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Nov 2023 15:43:35 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 16 Nov 2023 15:43:34 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/379] 6.1.63-rc1 review
Message-ID: <ea986ccb-c09d-43f1-b2a1-18468735585d@roeck-us.net>
References: <20231115192645.143643130@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>

On Wed, Nov 15, 2023 at 02:21:15PM -0500, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.63 release.  There
> are 379 patches in this series, all will be posted as a response to this one.
> If anyone has any issues with these being applied, please let me know.
> 
> Responses should be made by Fri, 17 Nov 2023 19:25:27 +0000.  Anything
> received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 529 pass: 529 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
