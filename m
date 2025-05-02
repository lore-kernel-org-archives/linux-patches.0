Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC44C252905
	for <patches@lists.linux.dev>; Fri,  2 May 2025 13:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746191312; cv=none; b=VIh5nQXuK8ZXlLTM2lhXurUs+VAc0zC3fZ1HyaBaAnroWJsmmaCDjjE3nQBtA4bHEAwjVKHmWwuC1s1YmL1LC4uGVjjc0k3JoSrKzqOvLTr+oa5ixgq2Pf/zWhwWw5ng+6eJIQdoS8RggYH3vueN2G7RBQC6FPHpbMchocsdhvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746191312; c=relaxed/simple;
	bh=gYlKfftzKx3fPajqS1jxu5gnHo9KLvzRgbD3+rtsld4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CgjcJx7Pc+gIVUKWM0nL7qcLQ7oNgawSUHczg1w+uA/5Ok0t8cgz5OJOjG/FsEV8GSgU1DDI1ISSDVBQ06kWnTPjcqU069QbP0TQqeO4xjayCAe7ElyaUNDpAxBe/RK/B7H4NgQMdtwnP3sWFlDO6zNnv/4PPT65VphsLa9Sg3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DbR5NU1D; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DbR5NU1D"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7376e311086so2949485b3a.3
        for <patches@lists.linux.dev>; Fri, 02 May 2025 06:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746191310; x=1746796110; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=HR0asHqF+5I07tJl5Az2gVmDHz5HwoFsUn4X8UeI9wg=;
        b=DbR5NU1DnZ936QnB8pqqd2HwivUwKwd0ZOPQTHxXBL1MtUQIXSYJjsAv51WZeITlkW
         t/Ap/Voc4YRVM3N5IE1VSd1bq3/ykpRwOkyV/23yhK5HfAAC/THfoU0lLUpf4ayv8fgC
         p/I63fJSBC0hHdZMKjIhXnTRyDq/saLaMWtyCNKJE/fVeTIRevD0rQy7VlpqVshZFZgX
         TSc6s1i65YVPgJxOnSJ4LxKdSiTliJdMBMKIqrWqOdLUCvAUfkKP0f9dKR34++l+7UsY
         MRr7bchStBGCePg4nNYlEyy9sXrHUN+V4E0ZYmNwx5d1xeRumZSigAD0R2SxGI2UMnd6
         EPEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746191310; x=1746796110;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HR0asHqF+5I07tJl5Az2gVmDHz5HwoFsUn4X8UeI9wg=;
        b=NtQaJ/l1zygAyeQz7RFLlLPZW9XrYUs7gKHScQdDeBNeONyan+ZJK37Dp6q8JCvumf
         jsfFsJgvPy5Q3Lkvv+Ew0gkbQ77IKx8kRGl/dDka/BZuB7IdEq/YyFr7JW5JYHNQqFUx
         hQGLWoJuYxv8FtCyyHUEwaq4mqqwnnYjtYaKoPjpHWYULTDD2osIgnQZwvUza1uTcS22
         vJEiV8nha+jJg4L8Dl490BHeZCotcljk48k0t/LMJNqmMBw5B7vFCLppljj+7OJOfAQ5
         KUM+K7CGyGWW55gtryvgoZqC2KCf2J4EKxESL/zRI0aIomqfJUmAWForSBmzdVKJsyR2
         IMvA==
X-Gm-Message-State: AOJu0YzQGfpfkhjxKSyPK6mEQniOghS42siOIqb7NLyu4NZLa74Aoytj
	ExWiFZPwXc2ajYlEA0N+G8ZeNm7hpGh12/wJLvpgzixO7gf/b6KZ
X-Gm-Gg: ASbGnctE1Pf7G5D/0wLLS4eMOwjbqWpRTXbV/L7KaTmOAxiHxGN8Gns173OvMuHAcE4
	qxfKYqlmym8JebQDSTZCr2R+izqcg254wokJrxJi+q5bS0y239oOj9Vt4K49hEJAJ+RzpGjjqfv
	MTH6o7JO3YIUvtyMqAGxrMdXwib2HKwY0DCC+xRkql5Ok0mtFT8Zm+xvJ9xlIN4Mjuy4jqeRwG3
	skoeAPVZ2xb/3JdvNnyGbNI6CaacoKHBqJziKbBupQvDaqVNUcnmLtzwgLCxIELhhZfMKnrCL6v
	7hipQNFoX5+1rSUAco3XcvTPm6Avg11XGd0GZr8x8z4iHDblKKNQh8tK0As4+v/Pp7w=
X-Google-Smtp-Source: AGHT+IF4JbJcm2+b0Vy3noTfxGPh/HAHVTgkl3QSB4qkhDr6UhtmUkVEVo5wc2frC6udj+7MhpK3pA==
X-Received: by 2002:a05:6a20:c78e:b0:1f5:8153:9407 with SMTP id adf61e73a8af0-20cdee3ae30mr4327520637.20.1746191310018;
        Fri, 02 May 2025 06:08:30 -0700 (PDT)
Received: from [192.168.0.24] (home.mimichou.net. [82.67.5.108])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7405b36effbsm1272666b3a.50.2025.05.02.06.08.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 May 2025 06:08:29 -0700 (PDT)
Message-ID: <37d34f34-fa84-4899-8755-58b6c1eedfd8@gmail.com>
Date: Fri, 2 May 2025 15:08:24 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/196] 6.6.89-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250501081437.703410892@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250501081437.703410892@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/1/2025 10:18 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.89 release.
> There are 196 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 03 May 2025 08:13:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.89-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

