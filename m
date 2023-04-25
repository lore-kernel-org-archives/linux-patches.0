Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E037B
	for <patches@lists.linux.dev>; Tue, 25 Apr 2023 01:04:13 +0000 (UTC)
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-63f273b219eso2178222b3a.1
        for <patches@lists.linux.dev>; Mon, 24 Apr 2023 18:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682384653; x=1684976653;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fsQqb2H+qRpsMxKuYszpVTWj+hhKcaKTqbB2Oq+E+xU=;
        b=Wm7VbjnqzCkn5n3G5cXm7zmTnejDV7bOZZB+UJZGHas2fMvYCp/mHogoCK9j+Q9wCU
         Z0v1QhW5zDF9Fo5W6j5sLtYkWdypJGiUE92aiyEzg4nbZgVWQRghq1YSgbHaLtMJNF0B
         5Cf5maEUCNMY04wJfRSbrMh0JLE0L7RbszxWgAg0fJ57V66hW/khsU6WISquyafLjZas
         a6OVmuwepwkP72EeeQ0xTCFRpse+z7J0lCNZFKi7RBqk2aU8LVifQQQ1agg/2S9O5/nO
         AmbaLsNQyomoqc9htGk+ca1HSPBmjD0Efixfm4zhs53NagX2uAVMyYwhp2Q2uOFNIKbU
         Rvtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682384653; x=1684976653;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fsQqb2H+qRpsMxKuYszpVTWj+hhKcaKTqbB2Oq+E+xU=;
        b=h4YyWjdHUF8bobCDHKEPBr9RJxWZt0iYwxDGDEfWqRwWOl0EJmvW0K4XO7Pvgx73v5
         kdAILhQQxCxEHtBlz05A3d/1KxhjVaBAk61gc0xxXjC9PTQ/GjPy9B1pqfq4tBof5HxD
         qMPNdcUkY5iFM8SWEv+bteXSqfdhGDSsjPCLu5CUZD1gCan0cPjkXLh9Tea2yGKRWoit
         h2waz4sawjC3LabENcK3N9lg2aypRkcASWSta4v00j8B9VnqgaPIqKE1kt0IL7tpzPsL
         7eYmQwB55F3ASRFGRlQHvVNKcPXEAD1/q9smMxXs5mUU8ZyW55XQCd9OD+5nbE2fQRkp
         IWaA==
X-Gm-Message-State: AAQBX9cBLHA/hmoPyWnG9xRXDgN8zIISJ/ws927RQiwYjbjMfh5vWu+B
	RKXNCBOousAp/meUac6x4Lo=
X-Google-Smtp-Source: AKy350YhtlRHdLXNB6OF9hPuJYKhs8q6iWIx+5vUHb+/bE754932eSzmW8qRpIV/hWXoFm7j7ckWLw==
X-Received: by 2002:a05:6a00:134a:b0:637:253a:531c with SMTP id k10-20020a056a00134a00b00637253a531cmr22924038pfu.27.1682384653265;
        Mon, 24 Apr 2023 18:04:13 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x35-20020a056a0018a300b0063b6cccd5dfsm8044024pfh.195.2023.04.24.18.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 18:04:12 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 24 Apr 2023 18:04:11 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/29] 4.19.282-rc1 review
Message-ID: <49c952f5-1ecb-4608-8aa5-f184f74d9eb5@roeck-us.net>
References: <20230424131121.155649464@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424131121.155649464@linuxfoundation.org>

On Mon, Apr 24, 2023 at 03:18:27PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.282 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 431 pass: 431 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
