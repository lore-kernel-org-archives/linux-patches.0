Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77EB011CAC
	for <patches@lists.linux.dev>; Wed,  5 Jul 2023 16:28:59 +0000 (UTC)
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-5704fce0f23so84635477b3.3
        for <patches@lists.linux.dev>; Wed, 05 Jul 2023 09:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688574538; x=1691166538;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DsQgEMFM3mtzvgVBpT1aFEHWLRc49D7jcPk8h5Nd1ks=;
        b=q4z/7X9RTw5LAF+sLjQOLpziYsPj5A4zdgh7LlO6BCKh5FMnxFXZm0Z/XLO3zbi6Cg
         D4AsrYwtLuumwBclhsDZOOCfLl8qQsLi4YrsaKe8eZt6wfbb/Q6XOZ2fPtizUvPmkEtP
         OX9/PPe4122FrBRAryThc5YJ5cUQcYL/WY5VxaI/sGILdi8H0ygtPbGkToPOie3wc2nI
         WWKaJ61ISqjNKhv0gmuF5u0bpxdxlFYjoUewplLQsw4hyvRYBgp2r1Znb0jcsh6K4cwD
         a14sDSbrJkn7VNuHiji8WV/7/sUGixEVO2h1ToRhBHGhzDxlDKkzs4rNr5DReaGFbXUU
         fGmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688574538; x=1691166538;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DsQgEMFM3mtzvgVBpT1aFEHWLRc49D7jcPk8h5Nd1ks=;
        b=c4VqKKuLOBu8uGawaPnxmyTRbX/7zPrI4mbLkOW9Y0EJpmGKdTCODM/+v2CK2qXGe7
         3pkkHJnDjjyESC2kJ+fuYnaWmjM9py9hT3IL0IXRg3ZYa0UKd7bIzQPDEsqL5SuAKJbZ
         9Cv9WMjJBnBI0mSBW2LqPYhTk58RVl9OJR/+zBBwS+KptJtM+krN5B+4sjzDOkOb+DOH
         WBJgpHMvl0C4g356Etyq99xzjXSQUK00jTcn6HVkClUlMP+88ix1FWr/EOJPFtoE1Ak9
         1kClKnz2ecp1hNfNmDf/baiXUpc3siekbQVrJLLs+33cqgIgcp5i7/gf1fYOZeXhWWwg
         MjNg==
X-Gm-Message-State: ABy/qLbNb44H+BCWmp4YjEqddQlSX9NcTmPKJbjb9BWT9iQ3Kar2ZSRu
	cWIzWesyfVj+KGJdVPtgQIA=
X-Google-Smtp-Source: APBJJlFN0bjonq+219uKnrBI6oQSBKOMbONnXy9iOf2go4BwsSTLIwR+GlUvclNzSkqBAgQ98KQ3dg==
X-Received: by 2002:a0d:ca55:0:b0:56f:fba4:9b85 with SMTP id m82-20020a0dca55000000b0056ffba49b85mr15875344ywd.7.1688574538329;
        Wed, 05 Jul 2023 09:28:58 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h189-20020a0ddec6000000b00576e67820f3sm4913840ywe.66.2023.07.05.09.28.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jul 2023 09:28:58 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 5 Jul 2023 09:28:56 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.3 00/14] 6.3.12-rc2 review
Message-ID: <8e8c0513-6227-49b3-a9e4-1d00fa163c1f@roeck-us.net>
References: <20230704084611.028211988@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230704084611.028211988@linuxfoundation.org>

On Tue, Jul 04, 2023 at 09:48:39AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.12 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 06 Jul 2023 08:46:01 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 520 pass: 520 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
