Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720A3D2F2
	for <patches@lists.linux.dev>; Tue,  4 Apr 2023 21:21:37 +0000 (UTC)
Received: by mail-oi1-f173.google.com with SMTP id bm2so25289854oib.4
        for <patches@lists.linux.dev>; Tue, 04 Apr 2023 14:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680643296;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eP4BMC4T665hzA4eSCHbf5yPiTELBpn2jLQP8DfWLC8=;
        b=NEXI+BkZt1Tr8a03bk8Ot+WCl7yXj/vTyyUBb6J1JgCyXeJHaoC2E7BnKg4Q7PC89B
         mFEI255oufVGX6b40Td3e3aD2CNjJYNJAtlnQ+dThakqfhx888WXdf7n+UOi9MYzZLvu
         qfC0wd4y5kPdP5ASo526H2KqfKbVmxi+r4QfEd9kHaI9J2imQSuRMjYPwJi4n35avi+g
         Rf/l/l0WXp2/1QNyRcEzW9wm9u5XuCIFcgaJmI6tcuLrqHQwC9XhsjI15OZJDqJyLPA2
         8uEZgbSYaHrSZzRCjWYRswMQT7CcQqkqP0Tb3g9bdg+4ltUk8oBDshwlhBq5VHdigIKo
         GaiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680643296;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eP4BMC4T665hzA4eSCHbf5yPiTELBpn2jLQP8DfWLC8=;
        b=hBaWTnxhsSLbGElZ8PpGUBc5FFsMqmSyAghmTCWQ7+sETp3BF1rU2aA4U0sUu9Km+T
         fJIawyGcNuW6iaB1XSlien5UIfTqTlo6rnQIOjJSypLJC7auJlZaabEaUDPxtRKXhQQL
         oGgDwPsc68d1xZMXed9sKEASRC1oEH/sGXc5bl4ocFuIwPHmmYxyV7RYY2U67W9LIV4m
         j0k0/o4b2A1kGR8gQy5NKtN+/kBrwDvvTh0TN+dCVgmJLXLByKdVi+xLCE3cj6ts1WQB
         0e0iwxqRioEF6pmpQcK6V36PuBkRec7NjPgrIfJn2YFHBYXfDqsW5a5B3mjLKn0plBKR
         BkDw==
X-Gm-Message-State: AAQBX9drgOOtIj1rJK0ux0ozjykJu3St9SY9cRqj5rhn1aFVl4kvYsje
	vQKsC70A9pcOMU5ROGC2fOc=
X-Google-Smtp-Source: AKy350YpM7yruTDmEqu/zN2TFlzy9hOmTlj7NaWwK1DzcszbxolbvQq6UmpH71fCNDN/Mf6CTNcW+w==
X-Received: by 2002:a05:6808:14c4:b0:386:e851:71fd with SMTP id f4-20020a05680814c400b00386e85171fdmr1758177oiw.42.1680643296488;
        Tue, 04 Apr 2023 14:21:36 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k125-20020acaba83000000b003876369bd0asm5625629oif.19.2023.04.04.14.21.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 14:21:36 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 4 Apr 2023 14:21:35 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/99] 5.15.106-rc1 review
Message-ID: <e92bc7e9-86b8-4838-9149-196acf6ed599@roeck-us.net>
References: <20230403140356.079638751@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>

On Mon, Apr 03, 2023 at 04:08:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.106 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 499 pass: 499 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
