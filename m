Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023A67B
	for <patches@lists.linux.dev>; Wed, 18 Jan 2023 01:37:54 +0000 (UTC)
Received: by mail-oi1-f174.google.com with SMTP id v17so6180905oie.5
        for <patches@lists.linux.dev>; Tue, 17 Jan 2023 17:37:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ia/Q9WKwsAe0fHRlJDemb98849A5UJ9ZYQ4kp5Qk6BY=;
        b=oHPCUinx9Sz6p4HKy0ltNW4nuRdMMEJCKPKQ6g4jzgQhkMTiLuupElh2yks8LiKOKk
         UrCsh/G9M8Si3/RfSdvn3Mz9sDldLVbkJu+eqpSwvni3bzm7mR6GmywrWtItF4lupE1O
         o27v/snrJrC6RdWaoPcQ13Siam24Rk4p6E+utxi0K7Lac0VuU6MMHzH4pYsvpdl2MU30
         We62cQ0gZOq6b+GbmQSJQsWydsg28zhuvC2biF4Vsz90JYdQCN6mSFrAC425aDMPbrgv
         x5c/6K5k5j1C2do8ISghVwCtIT/92k78WTAIla6lUF9LxJ5aZoNRt954lcZMUSSzHP4c
         /F6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ia/Q9WKwsAe0fHRlJDemb98849A5UJ9ZYQ4kp5Qk6BY=;
        b=qnP/rOr/X8JUUtx7C2aGxFDrMbfs2GsdoEiJLFxzxs9GP1eqzlvaHFRuip3xR6pJnm
         HhLHnweB1DxYdX0z2o7zHdn2LPgRFctIZSVfu81xGq4A4mDZInqzpTKdCHxRkeIqBjo6
         pztemMKe/fhSHkKVe6HGwWNcnRrht5QeVJn/1WdZ0dlq9uEny83f23QnB04w7wm2f7Ho
         uw0DaKi/QtKo/d1oIQ6IMIGCYoRg8agKDSz1LLyNaS7dqnQlLdu/3Wpilm3HaZLN25L9
         PBhw8gf92jZoyXTbnuEoyg5gvy7J8GZykYtU+C88nDz5e55m45z4cYrYNFyjyyNdN9Iu
         3tkw==
X-Gm-Message-State: AFqh2kopGiLhseYBVGo9PWosXJwA4VjpxGKdGL88M7HFQ8tRPnabs+9R
	mnLpdxdyNneTWJe0DskTWv4=
X-Google-Smtp-Source: AMrXdXsiIJ8X1hvftOxm/F6SRpU3Ecgnat49YhEaWN+HdOLExdn2khyksVITO1Jk3dIDe3c8MpN8mQ==
X-Received: by 2002:aca:bf09:0:b0:355:1de9:3929 with SMTP id p9-20020acabf09000000b003551de93929mr1933183oif.47.1674005873936;
        Tue, 17 Jan 2023 17:37:53 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y16-20020a544d90000000b00367080ab4casm3223782oix.35.2023.01.17.17.37.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 17:37:53 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 17 Jan 2023 17:37:51 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.14 000/338] 4.14.303-rc1 review
Message-ID: <20230118013751.GA1727121@roeck-us.net>
References: <20230116154820.689115727@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>

On Mon, Jan 16, 2023 at 04:47:53PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.303 release.
> There are 338 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 424 pass: 424 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
