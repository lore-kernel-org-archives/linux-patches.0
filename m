Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A89640
	for <patches@lists.linux.dev>; Fri, 13 Jan 2023 05:50:08 +0000 (UTC)
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-15eeec85280so168130fac.11
        for <patches@lists.linux.dev>; Thu, 12 Jan 2023 21:50:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HqNxxa4ScNJGjxk7klGYORSloYPx8oE76dAzC61Lnkg=;
        b=p4ddV0JuptdZOehR2aLRBaoQqTdPD82gOV9LZfuAEKpNKMcBxwrZIcQuogwViTgMHf
         Jgg5sacoH+a8c/lEPE4PCRU3aSEANr/xUDTlDdztqdTmEdrECVJv5r98E+beMgmg/Nph
         9fv3pqdaituhLGakYuu/PCNVr1vINH7F52iEKkgZE8PgA0ApTfTQWgzA5k330/AGnyLt
         CWhlJsPXVlOEzj4fmU4wabll/fhGDG+GNLG7bFQlkIXtu+SODzkJg3/VlKiXWDxVTNmZ
         Ada24r17+7v8SsFi0xMRF98HiHWRFa/bzV2NKz9mLeNND2spHpXhu9kcrq5Et8WP1971
         wR1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HqNxxa4ScNJGjxk7klGYORSloYPx8oE76dAzC61Lnkg=;
        b=uUZV94bdMz0An14Cu5h2ox/JRCY4ZxH1EN7MR6s4tF/yESUZlVqqWAjgucjFicLEJ4
         XtHYgq/7/gcGAg00SY0xz13bl1zCU8DKLTjFWT9Ne7spaeescB6U79nhdREqSUDEQS1N
         3Vfe9a4DBL6ndtOx2Aw3GqXlj+cXkJOnnA1S9z5jkbP1TbbPCYZOpL+g1VPVsJVlrGE+
         w9Ryz+1PZeKJdlOxJL7BEwNQ9bUznw9saFGhqoXgc88A0GOijFqujTWNqldHwqfJRtVK
         INnctwJffe0MyOlLwEx2GUrfj2GVBKplyrkyycgqLVIM45AJbPBHlQJEuoWAV25w0Krs
         3ekQ==
X-Gm-Message-State: AFqh2krMWABzzpZEb//nK7/ERqDAMZXk5Vm7KW4uZAlruJEEIEPWVM+8
	15LA8s66/QRFdkODZMOfGeM=
X-Google-Smtp-Source: AMrXdXvrPax+02d4muwq+NZ+MgOLBQt9PlOqphLu5Zn2AQymj45+jD1po2E+sja4vkq+7XpsFzCFUw==
X-Received: by 2002:a05:6870:9c8a:b0:143:6254:7e6b with SMTP id pq10-20020a0568709c8a00b0014362547e6bmr27157996oab.11.1673589007469;
        Thu, 12 Jan 2023 21:50:07 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id el35-20020a056870f6a300b0014474019e50sm9926735oab.24.2023.01.12.21.50.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 21:50:06 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 12 Jan 2023 21:50:05 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/783] 5.10.163-rc1 review
Message-ID: <20230113055005.GA1591011@roeck-us.net>
References: <20230112135524.143670746@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>

On Thu, Jan 12, 2023 at 02:45:16PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.163 release.
> There are 783 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 14 Jan 2023 13:53:18 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 475 pass: 475 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
