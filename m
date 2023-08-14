Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9742C120
	for <patches@lists.linux.dev>; Mon, 14 Aug 2023 14:04:59 +0000 (UTC)
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3491516c4aeso14037925ab.1
        for <patches@lists.linux.dev>; Mon, 14 Aug 2023 07:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692021899; x=1692626699;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SV6sC89XapYZVMX/+VdYxzq6EyZ0EWd1ZtLJeqKLEQk=;
        b=QopZHpibMKfchlO2kbVDZ+nGghMuuDea0R+TfjJ1dN5Qdqx2Ew6oGdQNX8HtIhDuHF
         yTO1XoOFX7dyo3VEJWMmhGh9gW3Bq9SfQ1dhYvHbeotAqn4tT6miA5xIBQYN7fpnwYzQ
         4jq3RUdjCTo3KdvY7ZzxumNZFUCe0UBQEWy703w7d+56I1SiMTGpQnH+rdFUqQIq2l6M
         avYjFizniwwi6b/DOD7Lqk6cHEWxPULWCjVqnDueddkq75X+8IbYG1ew9XqwnKc3onb4
         FzjQrOpB7q+AKDkroXKUuVUUSluRZ0wI1RcYgXbBwbFZdgvO387oS2kJB9yFZTwvQAuv
         MriQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692021899; x=1692626699;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SV6sC89XapYZVMX/+VdYxzq6EyZ0EWd1ZtLJeqKLEQk=;
        b=ZBOS+giaVQP2V9H7F6W5jSjxi7UADnxbXZj6Fb0ftefeVmQTcuSo2+sAireq1pCU1r
         wJDnmAeJQioYSempFLfB0nEvFVdgOCrPNE098sqnZiZw8VQK/bVnKctugKj3uPN3NLie
         M/qPsm+nCSmBJvyELTL0o7Fzw+AFkidzQUkqFro90HzcakPHvMJbOw62VEKW467rFcs/
         GEOPl9Bz1RB6gCyxQPHDAXqovmm5Y03rjvZ1kHd6Z9/jeBropYzuoorMEKdSDAd3SxS7
         d9uXrbEWF0/eChvtiXkJZTBAkB00cE6Q7XAVhQKAZWEJCWuSdWKtZaWFPwD78yUTBUaH
         B+uQ==
X-Gm-Message-State: AOJu0Yyu+pAgxdVPtl72qsVBqSluyluiy7kuLpLeq3/J9nxQeBn+0k9C
	eFezjzrhQ5vxA0jsk4OTch8=
X-Google-Smtp-Source: AGHT+IGIB82kZi2sR4+R1Uj/yPYzrGQoPS2ZRRUXuUiCM6qKgcOMpHCZsh5vkYECo1Xcr7StrG6qPg==
X-Received: by 2002:a05:6e02:1a81:b0:348:8ebc:f759 with SMTP id k1-20020a056e021a8100b003488ebcf759mr14316486ilv.6.1692021898776;
        Mon, 14 Aug 2023 07:04:58 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h10-20020a92d08a000000b00348abdfad8esm3147800ilh.32.2023.08.14.07.04.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 07:04:58 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 14 Aug 2023 07:04:57 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/149] 6.1.46-rc1 review
Message-ID: <b392e1a8-b987-4993-bd45-035db9415a6e@roeck-us.net>
References: <20230813211718.757428827@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>

On Sun, Aug 13, 2023 at 11:17:25PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.46 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 15 Aug 2023 21:16:53 +0000.
> Anything received after that time might be too late.

Booting with f2fs root file systems still crashes in this release
candidate. Would it make sense to mark f2fs as broken in v6.1.y ?

Guenter
