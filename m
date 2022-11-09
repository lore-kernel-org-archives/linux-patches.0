Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD31217C2
	for <patches@lists.linux.dev>; Wed,  9 Nov 2022 02:54:05 +0000 (UTC)
Received: by mail-oi1-f173.google.com with SMTP id n186so17538588oih.7
        for <patches@lists.linux.dev>; Tue, 08 Nov 2022 18:54:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rBLZkJy5Pp4Vpzz0NWiO5S2UOJ9yN9uTsYNq/gfnkYI=;
        b=ltk5/S5XHdqjLJtA8myZw111jK4YqHjyFUd66tIyRXCFvddlDxeXY2V6w31crN1exN
         rV8/oVEY3jfko9wObsLjdRwt3WU6IghTUYnYRoQbTibSVZ75bJaUTdwRQGxhbGMKWwrz
         BftVdHlBkj7e7iamWNLd28QVMjXwrgh5qi1VCrOmvQi98xr/KKRydOEgO0vcWFEzrGTs
         LseOhn8Ag9O+vsmRIh5XDV6Kx8mDpjScYBPObe44OQEi9RvAaaS9Y/S/grGi4yMkF/pQ
         1cDeOsa14AgGnc63jOn06mN4fH76S26Bg8/AXi4vuZ07x1egokjB3/wkZBtv8mUFraZe
         Xh4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rBLZkJy5Pp4Vpzz0NWiO5S2UOJ9yN9uTsYNq/gfnkYI=;
        b=kWiTC8NAthmDJEhrmV6uYmTuJRBxpwNkA3gCAX5uWkt2nM7L2D6V7lm4oZk75kqnRx
         MyT9MhX+oKFYswYhH51IjwUgmJtoefYPPyMxCE68cltOkqhaBg75kWvk5y/zSOQvwKaH
         T+bLEIrUdZHvY6eQocYyEJV0NmoL/7skp03KMdhEyAkZ2tXr0D4FXP5kNfIKKPbrI+o4
         9nNdgoPrzhzw06dDilZLMtsOt5L/SJw/bgpVVo66NduSocky3QBtHD+2gM9riun+tS7u
         9N/YNpCzT+MyHJmi94k6VWQvfuvZz06ELkLcPLBp6MAqB8/mAXXSSuRBnlExPe6G4You
         bUeA==
X-Gm-Message-State: ACrzQf36hguAA0MPUrpE9mJfInZ2augQHfALmJ3QIqW+RxSlfCnrXsHN
	D63H9eCCy3CNtRzRSyaGc48=
X-Google-Smtp-Source: AMsMyM65LdLfRxE0GxhydaG8ObHJgW/wS+FwVUJIoUp1X73R6GIfsgnVSVh3fUuZ+mlbIJsjW9oUJQ==
X-Received: by 2002:aca:b154:0:b0:35a:856:4b88 with SMTP id a81-20020acab154000000b0035a08564b88mr28020880oif.219.1667962444769;
        Tue, 08 Nov 2022 18:54:04 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e1-20020a056830200100b00661b5e95173sm4763329otp.35.2022.11.08.18.54.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 18:54:03 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 8 Nov 2022 18:54:01 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net
Subject: Re: [PATCH 6.0 000/197] 6.0.8-rc1 review
Message-ID: <20221109025401.GA2033086@roeck-us.net>
References: <20221108133354.787209461@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>

On Tue, Nov 08, 2022 at 02:37:18PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.8 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 152 pass: 152 fail: 0
Qemu test results:
	total: 500 pass: 500 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
