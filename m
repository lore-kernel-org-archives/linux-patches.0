Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9164139D1E
	for <patches@lists.linux.dev>; Sun,  3 Nov 2024 17:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730656308; cv=none; b=d1RR8/IgXMwPC8t52ysxtQlB6R+mRxSd8P8xPtsKFheLp+EztqyGmWhEsZJRzkDlsXV0S0kBk7maHTGbNpE5OaNKvjOwTOPQ6T+/a4s8w2qQQXlRqtUPJXzgWtYMUcbUHYiUhI2CYji2WWreeKELweWvfRWRuL0kM896V1QuUbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730656308; c=relaxed/simple;
	bh=FLG2f05LkEeYZob0yszPx8hLpLN3B+TvY0BOe099AUU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PQgyMuuIGM4E6QLQSFf1bHHF+QNFlM5O6TxlpcHiJJY9MhuwDs1IyVvKotOpQPvlxiNLPOrjBUhudJ8NfLuAHJJ4G+xKYFZcaV+I8QxkcGL3/NCFgNZI9PFvGopr36t34lqJcXVycqCBGqO6Z4LokTURw+atVbjcGPLAGosBBTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TAx7T4Il; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TAx7T4Il"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-71e8235f0b6so3041618b3a.3
        for <patches@lists.linux.dev>; Sun, 03 Nov 2024 09:51:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730656306; x=1731261106; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=83CipENi/E14T1N6U9XqWtK1+m5dWrxg5YGxo4DsMkw=;
        b=TAx7T4IlO73+0mC5dCxQkXX+M9L3ta5ZDARJuZvlCbcFD8tMFKP2r3Rnk6NUJKv3+l
         alFzeDw/fDuDIWwjWJqJSPe7z7t3SN3DlCDgoX9ORb/MEcRamdbpu3nTskELbIioDtt0
         gKVpSXtugXz9Dx6f0PMxohP+RKmwTuwtW+wTwc71xxUyUCp6bg3eZxLXM5ou/2RBH4YA
         mniP5KBTWU0RePF2RBZ6pcL5ZrlwaEHMY6GhwCtNjRV93YsklfIUkPBcYf40D/IjJDPZ
         A/PEMWp8bfo/k5tkTGUXwtILZEv67t2NCr5suAR/pN91nG3sp70WpY7Vd7K9mT1YqhCE
         HOBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730656306; x=1731261106;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=83CipENi/E14T1N6U9XqWtK1+m5dWrxg5YGxo4DsMkw=;
        b=WzAJIg4J8sWa5dHPm6ppQFDTeLbqZY5F2TkKh4XO3jwelJscBFaUEdXGSgVOfLh2oy
         5CFM+nduHq/moiVtzicu+inqgjT73IXRR9xQymqcTCRYEGJ8unz31dp7u3LFNDPamVqH
         6nJHbyUWn1NnUg0owwfsCmvID8KqGjYae0e0CVrZ69QRRf7jeyI48W/i6XMuKt6+aaNV
         bpO/QL8Bb+5uCmiBDmscFT+sTqeTF0b6QC9sIaBiTiVx5/Ydx5hr8OAlcdh3iyP58I/c
         wi4UMGlubfGhIbZ3MqtdjoFrOIgZa91x6uF0ePhQMPf6zPvoIlFKdbwAF9TMm5LBja1f
         0Y8A==
X-Gm-Message-State: AOJu0YxWiQB9LPPhBbZaTgB4FYJAHZ7DNsUqTu4hrYtghG4wzUYj9mHK
	OlYepXOaLb8ykQoeyzWoHCr3XXYkIpbqMa4HLI3Mi791mvusDTHJ
X-Google-Smtp-Source: AGHT+IFjvb6h8xJL3LKBGCWn+mahx6xK3PlGyeLb7uhoJLsD4eF9Xngqe9a33xSOZTmilYd/6lbLZQ==
X-Received: by 2002:a05:6a00:4b02:b0:71e:693c:107c with SMTP id d2e1a72fcca58-720b9c045fbmr19120123b3a.11.1730656305800;
        Sun, 03 Nov 2024 09:51:45 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7ee558f1bfesm4560925a12.1.2024.11.03.09.51.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Nov 2024 09:51:45 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <1c37c634-3824-445c-b303-372b89b86113@roeck-us.net>
Date: Sun, 3 Nov 2024 09:51:42 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/137] 6.1.115-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
 allen.lkml@gmail.com, broonie@kernel.org
References: <20241028062258.708872330@linuxfoundation.org>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/27/24 23:23, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.115 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 30 Oct 2024 06:22:39 +0000.
> Anything received after that time might be too late.
> 

No action expected, just a FYI.

perf no longer builds in v6.1.y with Ubuntu 24.04 (glibc 2.39). The error is:

tests/bpf.c: In function ‘epoll_pwait_loop’:
tests/bpf.c:36:17: error: argument 2 null where non-null expected [-Werror=nonnull]
    36 |                 epoll_pwait(-(i + 1), NULL, 0, 0, NULL);
       |                 ^~~~~~~~~~~
In file included from tests/bpf.c:5:
/usr/include/x86_64-linux-gnu/sys/epoll.h:134:12: note: in a call to function ‘epoll_pwait’ declared ‘nonnull’
   134 | extern int epoll_pwait (int __epfd, struct epoll_event *__events,

The offending file was removed in v6.6+, so the problem is not seen there.

Again, this is just a FYI, with no action expected, just in case someone
tries to build this version of perf if glibc 2.39+ is installed.

Guenter

