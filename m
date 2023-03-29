Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D4E882B
	for <patches@lists.linux.dev>; Wed, 29 Mar 2023 21:47:41 +0000 (UTC)
Received: by mail-yb1-f178.google.com with SMTP id p203so21187058ybb.13
        for <patches@lists.linux.dev>; Wed, 29 Mar 2023 14:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680126460;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x6b7CKS209zMdBnHZLVLNcY2yh2aKCBJcpnImw7wREA=;
        b=mSIAhN7r6i6Pj6ULQWJFhhCnun70kb9gj9b28YPMUFWFjWGYiQTu/NgVd87w4HzoRW
         hBJ3P+RcIQHliRw7bzO+JkytRkCg7MNbHxrjv7LEMn0vRzazN9OOR/NBBpjthleHDXnt
         pPrafHRYASGiLndJ4pDlQiawr2omphfuoJZuZofNiBQPvilumt7VmD3e+5qIyI4/OAqO
         BEzlnBf05oxQqSW4UOr/T/lTFdDETrk8NCZX2oQfbdwLpHeXSJYu9dXyDkpeCfSjWrex
         W+v4f+hKJluJZ+tyEoI4CbbOUkGXyPe563wQYoml1qm3M6pkcAUgAvAY+cUpsEhIVvDu
         b01Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680126460;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x6b7CKS209zMdBnHZLVLNcY2yh2aKCBJcpnImw7wREA=;
        b=pW5Kl7T7cWLWhLd+OV37Axn3uX2tAdqBb4UqchXKYVxRVVyvM5S29ihCvWH5yheEue
         Hi1Ia+XxSgvG97ARBLPayPvnJfkXKdoS30PuTguhKPpblN/yWOZkrOTefgmGuoVLoTOn
         5ly/Y+QvKA25ef1AOjORYjJVt4/oyq9d5Q9D9eviW4muUKRxH+dOJgQe8LuXhxmqtmiB
         j+HLbsTflNDoUuzzEJDeiQZPhZZ49K3DUPILCKl3bnydYTRrNs4HL3UulcgpquAqkKv6
         g6lyqp6DB2MfewmJeCy/TSEL/iyyQz0O7N1zc7+Wrnnhh8fkPdJUtEP/7ILcxPC5HPcK
         v2NQ==
X-Gm-Message-State: AAQBX9f3N6tnXmNpvJoiRk3vAggeu3cWJfaMKbfF+DWmUlFmYEgECbOC
	qMzU0+RO4ORiKL34gJJTWk0=
X-Google-Smtp-Source: AKy350YN/zLVsUee9gX7Mk1DBoxF7uvlpor0UeqiZPvZV8sbKueE7xlvN6nBCQRF3tVJuowwep3Q1Q==
X-Received: by 2002:a25:1f87:0:b0:b73:bdc5:948f with SMTP id f129-20020a251f87000000b00b73bdc5948fmr18919680ybf.15.1680126460112;
        Wed, 29 Mar 2023 14:47:40 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 79-20020a250452000000b00b7767ca748asm3716520ybe.39.2023.03.29.14.47.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 14:47:39 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 29 Mar 2023 14:47:38 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/146] 5.15.105-rc1 review
Message-ID: <d8a7a58f-cb32-4bdf-b2f6-507be8ac09ab@roeck-us.net>
References: <20230328142602.660084725@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>

On Tue, Mar 28, 2023 at 04:41:29PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.105 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Mar 2023 14:25:33 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 499 pass: 499 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
