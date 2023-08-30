Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F307EA1
	for <patches@lists.linux.dev>; Wed, 30 Aug 2023 02:04:18 +0000 (UTC)
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-76c64da0e46so174316539f.0
        for <patches@lists.linux.dev>; Tue, 29 Aug 2023 19:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693361058; x=1693965858; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CTtXfWy3siOXzQeZ46HnlLwi43B/raOmYWONvMXKE+I=;
        b=h79ceqQKsPZpb4q2ZUI+tmvFBOF51r1ajD1C9RoxRU3YIHcb5LZccVW/BHidyV37LQ
         TKZcBFixrb7b1mkWT8nFwwEJYivKk3Y4Zicyt582RfBonafdU9RnWPEh/5kTB2kMC5rh
         QuthTcA8BYq9rHRv8dRrGqTpx3Univk3ke/RKhJvakedy61zxhtT2QXmSZM1zfRiDozS
         VqFrV3bgqf/FHamMwuMAwjwP51lbtazsCzqrJEn7hdiTWAZEQkd+HfbHz/ZaUzEiOKqy
         FXerGsTurzI96MrlqUApd0nygaZn9D1gFgEgTNC3nbum8c4qngcUls/3KU/Jd9rx4bpB
         zCUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693361058; x=1693965858;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CTtXfWy3siOXzQeZ46HnlLwi43B/raOmYWONvMXKE+I=;
        b=MHgU+TmEOaOtiSSjqEVvZVcAnhiXsZnAB4WRpmYtXHgM4F7CklxD2ybDPOEIOf/6Oi
         JgzPRvdPTLpeqDFqF83f2uHCG0CdAm/WpYbHrjyEjDW6hFnhP2P2a3lb4J1CbbEVSEfX
         KZZ6lfrXvONP3At+t06kRgcKz9EbYoEP/f48xfp0Se0RpGSKEey+jmvwRIcwygjwI5Tm
         EBhewtvdF3SB8R/AmOlz5r9bptQqeilmizML14uSJlzmy8I9BechZVTIIkR20TZAAxGB
         zF64/W/CMuOEEdkNDkBhD9KpLdgzTrOvpWq4C5EKLfegCKG1Q30wZhmiFuvO2mYOqvSr
         6rHA==
X-Gm-Message-State: AOJu0YyNbagmkDX4rVWu8J2CarJ1U60NswbMebSyNV+JkofUSMqFIyS3
	5IsP6Z03h/ZlpoeHqp0IMFA=
X-Google-Smtp-Source: AGHT+IG8nMrw/xTXVOLdRnwnw6/1vDoK/H4V6wWT02ni4GkNDQhr6SwQmKDGyjzyPHC0i1BW5WbkPw==
X-Received: by 2002:a5e:a804:0:b0:790:f866:d71b with SMTP id c4-20020a5ea804000000b00790f866d71bmr1147268ioa.13.1693361058123;
        Tue, 29 Aug 2023 19:04:18 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f22-20020a02a816000000b0042bb09e9345sm3472062jaj.90.2023.08.29.19.04.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Aug 2023 19:04:17 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 29 Aug 2023 19:04:16 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.4 000/129] 6.4.13-rc1 review
Message-ID: <6b336824-42b3-443f-8c3d-356626caf7fa@roeck-us.net>
References: <20230828101157.383363777@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230828101157.383363777@linuxfoundation.org>

On Mon, Aug 28, 2023 at 12:11:19PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.13 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 30 Aug 2023 10:11:30 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 522 pass: 522 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
