Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E2B6EB63
	for <patches@lists.linux.dev>; Wed,  6 Dec 2023 18:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J0ZXYeNj"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6cb749044a2so147052b3a.0
        for <patches@lists.linux.dev>; Wed, 06 Dec 2023 10:44:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701888277; x=1702493077; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fnaxgfkiXgtg5q1WFZwHiIF9qvQwoLET9HzIgaLiLzA=;
        b=J0ZXYeNjfWXuZKViB+AOfHfp5LxMZnlJpaaRaMPRqj7Nk+VUsyinz2xtL+sCXqm3wK
         /p/o0pegqVb/Qsbp2RgLvzZs2b713NBQF2bRsrqQABQ6jdBA/qj3a1w+MlRI60Xj6Iam
         oHE6KcXmzday+mcNFspt+Yzwm66yX35QFggaaw0mTAJqJDCknhMcnb9Owu6BzCljJ6XV
         ZMM3Dx1wuu5bPI9morpNVvvTaZWr0zAFzRW6Vao6RRsqSB0XdFlg/zBbgy9diiAYPJtQ
         BJllPi0SD2on6rWGZ0RuUODyHmVl1NTtVIqT7C6aHjIQIGCPQ2LQHEBJEWW2jiFOrNgl
         6H4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701888277; x=1702493077;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fnaxgfkiXgtg5q1WFZwHiIF9qvQwoLET9HzIgaLiLzA=;
        b=leqcqGDXdN6leZbVfgZO3sQGtowKkJo+5CaF1c3fGuTL1yazAOOXMzTTUk3YKW6rG+
         p/wUi/G64SkqDWjRLL/iwBx0xTURKMJrJUBwDvRF5mkXindADzcJ1j5ATJ6cFZvG2NOI
         PQPDRATL8GoN1krlZ9ZUw8BTtRm+HuLxKEhSLjaiui+oZzMB6m8q8WePyf03m/uiPWyq
         zAQbBH5+g4xCZ9bHoS3rNnCLzZRjSwazludKSRUlxEmXiDCyShWH0rIhYxSkcRqQZsVq
         Iz9Qtg7bm4VYJRtI5uzQXlGLyNPnXoAD5wqX7HLPJ02FJbuC1Hmk4hHPaNfBlTU28JT9
         qRVw==
X-Gm-Message-State: AOJu0YyleXNmeeY6259DxI+PD7uJV0xZFnRRSWhnwOa6Vj4+c2GaubRW
	n/uT3BWmnQ+02Cmh/gpgcSg=
X-Google-Smtp-Source: AGHT+IFcCGSlNJ87ePdiNLXx2zvfxCBK7xJK64DOejojIosppVqLQqonHrsCF+h+LQVhkk2kSoqlJw==
X-Received: by 2002:aa7:9ed0:0:b0:6ce:2731:e871 with SMTP id r16-20020aa79ed0000000b006ce2731e871mr1163893pfq.56.1701888277214;
        Wed, 06 Dec 2023 10:44:37 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m7-20020aa78a07000000b006ce538550bbsm305874pfa.74.2023.12.06.10.44.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 10:44:36 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 6 Dec 2023 10:44:36 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 5.15 00/64] 5.15.142-rc2 review
Message-ID: <f400ca67-5c9f-4f22-b554-fa2af062fcca@roeck-us.net>
References: <20231205183238.954685317@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231205183238.954685317@linuxfoundation.org>

On Wed, Dec 06, 2023 at 04:22:31AM +0900, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.142 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Dec 2023 18:32:16 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 158 pass: 158 fail: 0
Qemu test results:
	total: 517 pass: 517 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
