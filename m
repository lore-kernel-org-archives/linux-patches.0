Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3F3D2F2
	for <patches@lists.linux.dev>; Fri, 24 Feb 2023 04:27:13 +0000 (UTC)
Received: by mail-il1-f181.google.com with SMTP id 4so2292128ilz.6
        for <patches@lists.linux.dev>; Thu, 23 Feb 2023 20:27:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=t+DpcZDS2FvDgnuMoKZFyv7FRUek1ue38SSe6bohPe0=;
        b=RU4EE9eHQ2IgOSNy4B0fyMUnX+s3TpS9bbx7ql0OKkQouTzemsqLnUYKSTFPURkNtK
         OEuC1hR+r5Qc4XD3VLkoQQtZp1LqQBPVgOAVzmhMiv2yRElrAFsq6Vz4NyTmFU6wzB/q
         0ORLASft8jUYOrvDVECBvopyvM2/zPVyrlyvn+6A5GUSRlL8T7dqrADhxrfMzR/qHaV+
         9EpmyJ8yXsWh7vw+bEmRZmwTFYx57a+WUQm4ZrSvNIjhe3yPs2XMAH5R3OxBTNzm/vBu
         bI006IFzP4nUKg6nn9otByoURZhobbqVSTRhnNiSZH/GH6LXww99jgQ1A4XeOkbvlv7r
         Rb+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t+DpcZDS2FvDgnuMoKZFyv7FRUek1ue38SSe6bohPe0=;
        b=165C9IeZkKwkkXtQ59qSFLyQ0/Bx6nHYfC7kNCf+IO7bJNA1WPJliQDikTJfZAmRqV
         36HPEseGSSXUFSzCQC+J5ojAYt2bgXU/dQXWtbDoti8CC4Gv6yPNO8xKUo2REbeMo4NU
         56d/DLJlXqXzqdkOBA5tVrFWOC1nD6mEztmR7zrEonygFSK//AXvmWb7KUWealMLGSB+
         yZli9cmGiEAwObV94rE+iWADa+q49LB4t5mokIJvPcHyWgaVHZqQPUSMJwvKq/FW5jAl
         XEJqJJ6RKeWgavYB3zx+AygASQ6v4i90IefP4Vxk4mBryz02HGrhRZCuZQsbdATk+6XQ
         UeYA==
X-Gm-Message-State: AO0yUKVQfDo/csfytUuGzCYRxnvH3qRQFSMorPUPiErAv2YCWkZQ3VoG
	yrBQH5nYQeVp5kJhaS7J5jE=
X-Google-Smtp-Source: AK7set+B1PgxUeVhk+CzJ4fyVf8B8ploSe4nm1k86TpZlF+Hcie3ifEl1mbTCuOVSXi/FEqcbcUmkA==
X-Received: by 2002:a05:6e02:1988:b0:316:f93f:6baa with SMTP id g8-20020a056e02198800b00316f93f6baamr6387299ilf.31.1677212832290;
        Thu, 23 Feb 2023 20:27:12 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a9-20020a056e0208a900b0031578323bc5sm3305138ilt.56.2023.02.23.20.27.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 20:27:11 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <805e4f64-84d4-37a8-2529-8ed65395ab56@roeck-us.net>
Date: Thu, 23 Feb 2023 20:27:09 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 4.14 0/7] 4.14.307-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de
References: <20230223130423.369876969@linuxfoundation.org>
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20230223130423.369876969@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/23/23 05:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.307 release. There are 7 patches in this series, all will be posted as a response to this one.  If anyone has any issues with these being applied, please let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 13:04:16 +0000. Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 425 pass: 425 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
