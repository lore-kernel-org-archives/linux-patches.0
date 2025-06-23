Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52643226888
	for <patches@lists.linux.dev>; Mon, 23 Jun 2025 22:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716751; cv=none; b=AaM2WbWW3BBCTvHgcXz/+ZCDRvxHz93nliuCIViUxe8LuUWyWgDzg+eJdV8SGpTPSUTYryLVaAK0/kfuKsAz+bb6GGwfr2RRcafxwBxAOopYQP57TNp0h30rY7syqRalUItJP4ae9XnKAG6EHuf7uU56D/QLFaTsMnvimClmA1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716751; c=relaxed/simple;
	bh=vX8V9d5czqB7qJFtk/cKvJmbgNp7qUz5USbg6t/IFEg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Sfev0LOdsLP+0vrC8/qogAfbzOKpqTyDGdwBLlek7koyyvsLDcdEzhgxQZiKt4SFckPaqVadNi/4sU7IDVzf02L8O6cGbpfcrK88S9BOjQXt4jz6d+avMtBOr1fab30EQTooc0cxvbbA7Ht51gnIHl+ruLZfgTD0NLMOxrZ3ChE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZGxATtxK; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZGxATtxK"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-74924255af4so2159254b3a.1
        for <patches@lists.linux.dev>; Mon, 23 Jun 2025 15:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750716749; x=1751321549; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=rNNk9iay4TFsaR3oROHDPyt7j9eK6fHVYAQhw0ci6+U=;
        b=ZGxATtxKxIlzX2/OnL7oSyJdGcjQhf/81Og+RvjwNOBZ5VnWwwAnP252Ki5zEODGsr
         6TYmo7BZ08wUKaXivaFtve+QCL7AfSGcOuGnQNm+2iOMKv799ANAGrIvRhkko+8QE1Cg
         M9BlRdtCTHZr/RzRthvbyQz3Tm6PAEaOAjTK+feE4EqYyoReEJL7+rvWVj4NA0wYCCLz
         9M0O2z1fef/8PucQxhtx6sCWkWAAU9zofJADZwjagXkwP8uWeDgWU6W92ARkDAF3nvgF
         HAFZJMdifx9Ym4dFdZHtTliyHcoSyzzlsA1esM2wQ3k3u04yl/VBtfavCD/k8rATtxPi
         LppA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750716749; x=1751321549;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rNNk9iay4TFsaR3oROHDPyt7j9eK6fHVYAQhw0ci6+U=;
        b=Zq4U8rpm3KAEWlmuQZPKM+gVCfPOxDnu8pm+JNjcT8ygOcy3dYmZi2VHwIudijx0AZ
         AH8WAXGOsI3054rMllA1QMWRbxHZU5nB0JZRIiheMM37NPuNwnxVIBAE8h7RtdkL/yGS
         T/lTimZmzc3swxUlvrZT7g3ciMZ9hJVgUegyONCP9u+73VKnv6v6G7xydIhGeLorvR8U
         WAhQHjJirvBRVgFXuoyPvcHb+ULKpEFoggZlx/ZB16OFy86KDEllR6qqW0DON2BxFPWr
         3YRBqceTviFDIyPV8zhezB8WbNq1KxDulh7RjN1qfI7EvtVNpE1lypbdjXUzn/BJ7HUA
         4JRQ==
X-Gm-Message-State: AOJu0YweLDkHKSCBs6nO3Ck8RkSWu3yyXKQOR/JlS9hJPAMC3IwXAbEd
	2h635yLXHFxVBoBaaiVOnOU4garEVMH9aWjEo8JsOXL59DqPvWzTUUJ+
X-Gm-Gg: ASbGnctb7Bpgam55e5n4jEoqaQmWNW9HbgPNWhzkQCdvpiEYKGFbfZKjoWI7wf1OpDX
	h9Hr5DOX1eTdBQNqYCU8SAVz4PSoBnHRUthkumBtC5H37r4jUfcsRKZAXC3p8uFpqVkT1S5tAAZ
	AzEgga9dGM4sDhZ7zQpMVpnWg7YzcJ3YnBTG/jBUppfNkzqf+fZKq3kzNDOF/jfzikIutHIuose
	uTvJ9NZ2e7fX8fQLE5eSbA97q9LLMAiH6mAxPg5Noq26yF61ExD4pwJ6oqSfaXsWLUk4W7frejn
	iAJqfYK1fN1cr5UECRNS3mnWampXRIMss9xnLAVlsZfW2QunzsNXf6mQ1mZl40lx1Z3Lu01vIFD
	mFdInbpkT8kt7GZYQzrDnX77y
X-Google-Smtp-Source: AGHT+IFkA9rLLTXE/wzSDCD/eX9kG0gVoLWTteo6t/0lF66T7wkylkPLNX8ySW5Xjw4muC09909y/A==
X-Received: by 2002:a05:6a00:4fc2:b0:736:35d4:f03f with SMTP id d2e1a72fcca58-7490d52ca7cmr21366005b3a.6.1750716749472;
        Mon, 23 Jun 2025 15:12:29 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b31f118e851sm7376633a12.4.2025.06.23.15.12.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jun 2025 15:12:28 -0700 (PDT)
Message-ID: <2a1bcdf7-a6e9-4035-b85f-123c76e4ca7b@gmail.com>
Date: Mon, 23 Jun 2025 15:12:25 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/508] 6.1.142-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250623130645.255320792@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/23/25 06:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.142 release.
> There are 508 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Jun 2025 13:05:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.142-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
