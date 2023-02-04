Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E43C1365
	for <patches@lists.linux.dev>; Sat,  4 Feb 2023 01:51:24 +0000 (UTC)
Received: by mail-oo1-f48.google.com with SMTP id h12-20020a4a940c000000b004fa81915b1cso677198ooi.4
        for <patches@lists.linux.dev>; Fri, 03 Feb 2023 17:51:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e1hnwrQg/7TrlKiWRJR4hcEttZPGMMEcTVNIQ+LbzmA=;
        b=eFIFeueLVEjLat1j3tzYef0iCRSXaYNriZQFGtlW5SMwAGBBHnmvjHGan6KeqNyyKR
         5EnDF8KnCrdM/FVW9nHbwovNqXAXyBlbCxTnVpPM+BifQdUMcpHSE3lxDBs+LOaeiS9Q
         lNhSisOSgGwJaU4lZSoZ5ujkMcBO0OGWSE9FHJcxiG5VKKebG0p2AyckxFdoie8dmwRx
         2gsR/gLbG5GGzj5VhQZsdD6tQOa0ID4a4eBDSTmtgPw6ZuUxq8dVkRHIjcNS5zhpnyvn
         qvVNtqkTXOw9WQbuedSiUSHMm75Dy4Yn7s3krr4DLIT8+EskXQDfLmwSMkQmzIncOmbe
         b4Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e1hnwrQg/7TrlKiWRJR4hcEttZPGMMEcTVNIQ+LbzmA=;
        b=AK72YobbTU95NMaYtOeDI0pQ0YZpXxWlq7Ecn1fr1ubaW2KdL9R0rN6rax3rJKG6MS
         Qm/ZtKibkYN/Vqms585JLvz9pa9oSICkkjZ7QZTgjDEr5VQOsQ4WEm8GiA8ySeKXXWAZ
         lnhVp0fAbT4uV9d1WVgr2tThKvtvochb/vQ15AacRtb0IAiWJpDuNuqBMteLFes4bB1c
         zdzfWOVSb/iXIuH/oclhEYHXeXkPc0/trbDuaXV2liOmpfmjb9J5ZdbfSqeZOn7MTAXY
         RuJJqod5/O+lDMyc73qfm8YdTxI+tM0aWUt5IgRzhOgHNIo6oBDb09/BlSWNWmQ0+joc
         oDqA==
X-Gm-Message-State: AO0yUKXF12OlZ79ooZMfAJUwJMUmw1xzwfNRkhWuqj3CB3ULpfZQXS4w
	Vt6eNI0KCrIt0KL7+HuEohY=
X-Google-Smtp-Source: AK7set/p2A8FdtXyfiQ00tDpRUMXqwb2TTooDavd11tdWB5qJQv1lo7zQ55/9bEQ692IyMch8SriyA==
X-Received: by 2002:a4a:e38c:0:b0:517:afee:a386 with SMTP id l12-20020a4ae38c000000b00517afeea386mr5626564oov.2.1675475483713;
        Fri, 03 Feb 2023 17:51:23 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h13-20020a4aa28d000000b004fd878ef510sm1616569ool.21.2023.02.03.17.51.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 17:51:23 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 3 Feb 2023 17:51:22 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/28] 6.1.10-rc1 review
Message-ID: <20230204015122.GF3089769@roeck-us.net>
References: <20230203101009.946745030@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203101009.946745030@linuxfoundation.org>

On Fri, Feb 03, 2023 at 11:12:48AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.10 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 503 pass: 503 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
