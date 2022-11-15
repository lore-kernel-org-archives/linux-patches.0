Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069801101
	for <patches@lists.linux.dev>; Tue, 15 Nov 2022 00:12:23 +0000 (UTC)
Received: by mail-pj1-f47.google.com with SMTP id d59-20020a17090a6f4100b00213202d77e1so15356056pjk.2
        for <patches@lists.linux.dev>; Mon, 14 Nov 2022 16:12:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yS8quBXtR/yZJG+3YWdsCaXAYDD1DION2BW//xVXiSo=;
        b=UxLB7F3uLDdvPr0y2llH7NpfVYM9uh0kL6whhLpWmbe9eJIEyX2MNCzX1TyEQzbpdn
         UEl9gU5JBcOionZdsJdHM8P2RB5nss0eeXyiiYzqrN/6x7sdDTMeLR6oJnHF0XbsOk/s
         ofznJbUscHulmGue6Uw1kU3y1H/n5yw9icg3bFnbz6r3rBwmw1+F98kuFM8aF/hYOJO0
         vbB9LfY7F3JuErGTUYJt7ez7cBqo1WO4S7J/+DflTZEuogbJTEjVtdMNsxfJawqqhzV5
         /TksXIFsevkXUgB0OgRaff5/ksPhbWCrqu/R+d/klAHH3KvD9auWKS6qa7im6Id6fHu1
         wQUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yS8quBXtR/yZJG+3YWdsCaXAYDD1DION2BW//xVXiSo=;
        b=G8L6WXD7uR2EyFa4QqLqBX2SR2QUA/624fKB5RYhPl7Oc+9m4cZW/v9NbP2IIzXMC4
         r8eTE4R3NObs0C7qabnZ4MVDE3XtKY5p6Z80BF3i2g4QOLaSg2NMus/IqNI/tYt5wDJ5
         rs/Y475UK2287M8KbNM43ySRcIHMN3EtTRku/bOffK1p9hpysc0ghIw9Vvj3phlL3Bl/
         QYXb3OHw2W/XvaPPoIL8h53hUlsmjcJa99CNj86bZwqaxGzU0Tlmtr1GZnw389vkhiPX
         8LDSzQfE5yY9+wgD5uzQ1R8O5ZZyVD2HgvbGje/5HjtvDS9/3prQojs7bWh+gPeU/ztA
         bQfQ==
X-Gm-Message-State: ANoB5plCklFUjE+zAdXeICf849ZDTtQlv03EVlHPafQjlhkADQ56GmxU
	573aTATIaRvM6Apb13DuKvo=
X-Google-Smtp-Source: AA0mqf6uasNwzRqJQkRupqH48YzsspBUNwVsoUbhrMVLMzEVF2NNiY7c5XUI8+AGNleFJ866L3SaFA==
X-Received: by 2002:a17:90a:2b0c:b0:20a:aa74:175f with SMTP id x12-20020a17090a2b0c00b0020aaa74175fmr15755279pjc.194.1668471143465;
        Mon, 14 Nov 2022 16:12:23 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id iz17-20020a170902ef9100b0016f196209c9sm8174791plb.123.2022.11.14.16.12.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 16:12:22 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 14 Nov 2022 16:12:21 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/95] 5.10.155-rc1 review
Message-ID: <20221115001221.GA2291336@roeck-us.net>
References: <20221114124442.530286937@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>

On Mon, Nov 14, 2022 at 01:44:54PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.155 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Nov 2022 12:44:21 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 475 pass: 475 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
