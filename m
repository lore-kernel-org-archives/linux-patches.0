Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F29A1A596
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 17:21:21 +0000 (UTC)
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-690d2441b95so832702b3a.1
        for <patches@lists.linux.dev>; Wed, 20 Sep 2023 10:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695230481; x=1695835281; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4Bu8XpvjZ8gfoAYQP/ge6F6IM0gqUOA+cRgVZfRXgSY=;
        b=WcVN1mkUfZ5Q7VjCLKTv/9XujJXf0gHnTgKLg6ifXoV74dRReEhayPwt0RyDkR9RI/
         iN7JLb4nuJ3jMs0r1RhmaR4sLLFfdIQo0Jf0VEtXk2iayOd1qY2LdiLSWO4KkPTXTJdy
         8GoNXrctegRRjYK5V02wGd7wdFidX73yils/BDPG2UKmGh8PxDQ9gqQ+gn0qQAwZ91id
         DccWLtxvvxw5RV3/HN0HPPP9KHQcNRkIG5Fmf1KYV6ktqHmS0PVVx2o9zwxvOg3gWlBD
         YZ/whK7uVO9e+GHHGgEPvDb864Nc21hwZIulhkRhWXcZIelgPp+VCXo/qud5f1Zz7b0F
         dmNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695230481; x=1695835281;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4Bu8XpvjZ8gfoAYQP/ge6F6IM0gqUOA+cRgVZfRXgSY=;
        b=jOC2w0PoRwmAKDSHK5IxXoavC8hjvn52+6CstJUVIeGFhsdgqw0BReo956lmMvCbPH
         UZQGHLtc85BNy0LEx4OOw8YUXVBhwgJ16KbVmscF9iemH+YgJBEuW75Yzw7Ui+0IPIJq
         WXravahqtL9uXwdwmcrSXTd8rVE5tp9P4R50APqJKewvu0u3gm7kgUTZlIktPbndVnhk
         k1OAfgZWtP9AuZq/LGqZUBGfZso4C25qkhZ5cA/e3lZnYxD/wFgedhsfEFG/T1w0SJfi
         ituX7SBzk53a9WTzlelarGJ3aG6DCC2G+sWmGoFO1bszEadVCUWcFRFZLa/Qc+i6tb7e
         3lqA==
X-Gm-Message-State: AOJu0YzDmeEsav6bqsZ+KJxQCpuFoKlsVvMYMloxe0c+xQM6wrZ3/+07
	WuStqDKmiGBLX+IVJu9+HyQ=
X-Google-Smtp-Source: AGHT+IEMY5ePH5jK9wyR98gxFyTuY52Atn0lCRfd+ThGE3tsETj0oFGpKKAAY4utQB0EgSyEqZdpcQ==
X-Received: by 2002:a05:6a21:999c:b0:155:1710:664a with SMTP id ve28-20020a056a21999c00b001551710664amr5102634pzb.18.1695230481142;
        Wed, 20 Sep 2023 10:21:21 -0700 (PDT)
Received: from [10.67.49.139] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id p9-20020a056a0026c900b00690c52267easm2954411pfw.40.2023.09.20.10.21.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Sep 2023 10:21:20 -0700 (PDT)
Message-ID: <166b5b43-adab-7d00-e3f6-c9a1dfd29f52@gmail.com>
Date: Wed, 20 Sep 2023 10:21:18 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 5.4 000/367] 5.4.257-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230920112858.471730572@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/20/23 04:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.257 release.
> There are 367 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 Sep 2023 11:28:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.257-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

perf does not build with:

libbpf.c: In function 'bpf_object__close':
libbpf.c:4205:15: error: 'struct bpf_object' has no member named 
'btf_vmlinux'
   btf__free(obj->btf_vmlinux);
                ^~

due to 34d66b750e83d49c7d3d33d59e6a1b49e0d5db15 ("libbpf: Free 
btf_vmlinux when closing bpf_object")

the btf_vmlinux member was introduced with 
a6ed02cac690b635dbb938690e795812ce1e14ca ("libbpf: Load btf_vmlinux only 
once per object.") which is only in >= 5.6.

Suggset we drop that commit.
-- 
Florian

