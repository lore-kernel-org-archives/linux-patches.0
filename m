Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC64174E8
	for <patches@lists.linux.dev>; Tue,  9 May 2023 19:54:47 +0000 (UTC)
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-24e24b0193fso4714836a91.2
        for <patches@lists.linux.dev>; Tue, 09 May 2023 12:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683662086; x=1686254086;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VrVMLpxtsXEq0miSACw7WBy3JB6wSxJy7i4yWvfaf+o=;
        b=YCjelijlPfBaocwl8sr5OwbLT6+0dbl3jr/REZLPgEURMt7uR1z01cLuviDaxM7oP8
         dxndzecac6G1+bm9L9X2GbpNSM+jf909zWeXjFrtTi0owClfg9I3K0GsUwtZjWSMSRNn
         vNtIolpmhqw6Yak1qSxGUa2ggnMLTm/ijPRxNKEhdrqAFyjL94jwE4PFRnRhPXX6ODDq
         9tF65EgVK3beOm9/CyqrYMKGGx9aaQWdewdlFV2p6fiOT5VeOTKKfBd/o05tcs0qcWvh
         9ioAurEa11i+f6V70eJNrWBlul8PVJXFipJZkFgR3SN0NCtpAhqmxs9uDsSfY5tSAdjq
         3/tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683662086; x=1686254086;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VrVMLpxtsXEq0miSACw7WBy3JB6wSxJy7i4yWvfaf+o=;
        b=frrWQEOFyLLzvk+n3WdksPeHBHERDyJC+ga57K6cOKZMJTuTbxWd37XVMHce7cppiE
         8oysKhx02qDic9yO4zaVy/20I4kWcRvPwwNJGW6JrLqxPjliF96DdPRB3Vs9wegTumOH
         NZl3Pb6yW3m2FASRW2XIhP/zckewe08Eq9BJzwYBSQncW9HcXbj0Zffej+Cs0UT17VoZ
         GJt7esY8vQQwyFQNLl9uMw2PfoJggelmOZKkJLyc//V8tWUUM/rJ47KiuQMVSYhZ5jw7
         8Z1TF+5Ggrm8L1rUJrHd9mVnZICEgQILsgQW2g6Fm24T90BojYVD1JfRVDJo9+SShzUP
         AlgQ==
X-Gm-Message-State: AC+VfDxsJatxo+C2r4r+1opxcgSMs9YR3iIVW1pv1DdBqml9PDfAdAGC
	deOr2Ogs3BNQtZlW1wpEV4g=
X-Google-Smtp-Source: ACHHUZ7NL5MWUC33nq/O/Q7kW03yeQu4uK/BMBxCBDGTehcQwaqbcJxLZw1lglgy/SOOFczujWJnEA==
X-Received: by 2002:a17:90a:384b:b0:24d:dc79:5901 with SMTP id l11-20020a17090a384b00b0024ddc795901mr15716506pjf.26.1683662086512;
        Tue, 09 May 2023 12:54:46 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g30-20020a63201e000000b0052858b41008sm1718442pgg.87.2023.05.09.12.54.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 12:54:45 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 9 May 2023 12:54:43 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/370] 5.15.111-rc2 review
Message-ID: <a6e27b30-b9b7-44a2-8b11-4d732e11cb56@roeck-us.net>
References: <20230509030611.521807993@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509030611.521807993@linuxfoundation.org>

On Tue, May 09, 2023 at 05:26:15AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.111 release.  There
> are 370 patches in this series, all will be posted as a response to this one.
> If anyone has any issues with these being applied, please let me know.
> 
> Responses should be made by Thu, 11 May 2023 03:05:05 +0000.  Anything
> received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 499 pass: 499 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
