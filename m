Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E879211CAC
	for <patches@lists.linux.dev>; Wed,  5 Jul 2023 16:28:32 +0000 (UTC)
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-579dd20b1c8so55193447b3.1
        for <patches@lists.linux.dev>; Wed, 05 Jul 2023 09:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688574512; x=1691166512;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D8pDRtkd3JT3S574w5/FXocHz4F6TT7I/bGyhLdaQUw=;
        b=R3AFoG50WHNT0g9ebP9pViGu3d3OjscDZ4YrnLRaAqUtpXk42R/hs1J6NLuOt67l+T
         fclQ8jTxb9lrAa9U10eImZbZYZy4wu/8KacId+37+gjY99hghC4T7eJYKZnyZHCFtxVZ
         fk1Pwjf+pO4PFXwbESK0rhhMXz5TCJBcMRRZo5oCwKju9GYBAxgeZeDKKIDTxtgGevyR
         N0Fz9Jayl9ceSX/XPS6fKnwAh7iJyuqYIC2Y0JM5LA0StnJZcoUvEdfOhHhwpows12Kp
         73d364d+Xx6rxr+E0b2Kqj9AV8DL9kCzCZm9Wm9PUVCZNb84lDzo4IBElZ6u3au1iQsj
         ZqrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688574512; x=1691166512;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D8pDRtkd3JT3S574w5/FXocHz4F6TT7I/bGyhLdaQUw=;
        b=En5vzCF3qFviV9fsX6MrsqFhqo+vy4vzNeUvBUlxSkj5P+dSuzNcXtrpUaxMNdRX0S
         tFr7nOSPQpARrjoN1Ss5mLU6DHvNWENlHUFu8o9tqX/jnsSQSI5u4/3s8i5Bnqw1ggmg
         lANHTYJ8H5W4ZrDLwFddYdVFGAtnsQ4oDWp8aLul8eTBEGo5iJ2jMKR8s90Qk3OLqZzX
         GCCLFjlkc3sMRBkxy1QmxJh0wPQgJExlkYTRaEWAxa8mRLdC/0BVLCXYL0QaL05DheQj
         lmgkhee8RBQGCVzX2JqswwzIt1pSj57AvwyxM9ZxLxGWSsxukX35l7boT5UluTize8HJ
         3U6Q==
X-Gm-Message-State: ABy/qLYcA59ZDy5bhtAiwnoU4Fk72V53nlymLmh/D94evPbT1Pfl3yig
	WvwKB3AgjVzCYBvIt0kit6o=
X-Google-Smtp-Source: APBJJlH7aD7KQvhlGlrFzCnWuSOlcqeoprHc8559PyVECNaejWnhz6y1MqUAj7XSxt7o+5u+uXEqgw==
X-Received: by 2002:a81:838f:0:b0:579:dfac:f507 with SMTP id t137-20020a81838f000000b00579dfacf507mr11634636ywf.34.1688574511825;
        Wed, 05 Jul 2023 09:28:31 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v78-20020a814851000000b005771d1c7756sm3904604ywa.51.2023.07.05.09.28.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jul 2023 09:28:31 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 5 Jul 2023 09:28:30 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 00/13] 6.1.38-rc2 review
Message-ID: <519b0b43-895b-4735-aba2-1ff660ff6c11@roeck-us.net>
References: <20230704084611.071971014@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230704084611.071971014@linuxfoundation.org>

On Tue, Jul 04, 2023 at 09:48:32AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.38 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 06 Jul 2023 08:46:01 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 519 pass: 519 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
