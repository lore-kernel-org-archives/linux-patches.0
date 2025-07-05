Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68EA752F88
	for <patches@lists.linux.dev>; Sat,  5 Jul 2025 20:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751748423; cv=none; b=Lxm60jz2a9ftZgLxCu0qQ4mNl7ZztOfElFVqI/2U5y2rIISDoWCfYY9ZsyMXkmlBMF1d398gClP+7hU1bfiGEQd7pDcj7aXDP9IQWJ1UIa730VL20RqHmJq/OrLrj5wkpZVD0/h23sDY3FoV/Uyza+/572xrQLWZE5QL5xpQtsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751748423; c=relaxed/simple;
	bh=zFGuRV2cG5CzUo/Aoerqy5lgiWmL8JQKW2TMGse2440=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uOaf4Ch7fJMUiICT2mEavA7euK+KADc/TKGwIhWV56CvcoZ/igsOZEq9NBbI+2Z2hwfRzS8yJsIU4gC7D4rfvk4VCJyKfHgG7NntcFaVMmGCYsFPYFZ6XzT4nztuCYG3prxVxlVtqKG96YD48FBCWlnqVZWk95iqMih05z6wWVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X/d7e07p; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X/d7e07p"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-23aeac7d77aso16197205ad.3
        for <patches@lists.linux.dev>; Sat, 05 Jul 2025 13:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751748422; x=1752353222; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=v+hVyjh07/W7CV2rJVVGUElqHTpLBuuhXyMFO0QkYMY=;
        b=X/d7e07piYL8dD54N1UFmv6TXHyyD99lv/PWiJ8dos/x9/1GDnk+nU0Wl5IKBdjlDX
         C4UaVbxG9VVSZlIrPKaNSxh8qP/0vCEQP96ZRw8iNnG+hOUURjZuJ5gEpyNe3sRkboya
         i2ZYVj56mm9S2NumRa0V/LobLueCxRQ8G6+C3Ts7CGXfyVztFkudw+uoKonCvUd6tMK+
         OCSl6ahFp+R9HVBl3eGjSWE6rWLsA6/VNWAO1+aPEHXvX2ueeiYCJ8wwqUIIJFXN8qrb
         F8vgOXl3cRa6SSqVu8Zk5K5yp+r9E1n10bii3IrOg7kNfSs9rZKDUQ0MXzpSiQsqdUIr
         8I8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751748422; x=1752353222;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v+hVyjh07/W7CV2rJVVGUElqHTpLBuuhXyMFO0QkYMY=;
        b=XGaID13LqfajmqF9QA85YZfZORQHm4rqXJ6mggWnWUOVAh1hrSiMnNvAS3BqCRzEIC
         KYk7zqxjJvS73vJOzZs5LCadYiKlkVrg1rXGq3kAhN+C/2i/Hx/T7/VW/yZRPDY0V7uX
         ijqRtp8ZSPjaF+D/QSQ0FVO0HqmwQUAGumWIaDUOdP/w0phD/qWZWrmM7CPbgznP+DX9
         FzEg/GgNMR5869TZkGryB+4AE34kJD0t1Ckz0gaOMJ8u4GwFcxV/0vI/gvyFo6YC6F7y
         zT8dc1w2PnyEWkQEn3f00e5vCpqjKBKaxDOElecQ81RlO0dnNwW74Xc+vmN0WV9KQyVE
         CCMQ==
X-Gm-Message-State: AOJu0YwS9UNhyaaE2CrQ4aM+AuLnBPTX1688OP/yRgOHLR0oss87eNTk
	PrjkFn2ZFcT/d1mfUaO7Cj9rQMl/nZA7r7uffAvB/sFNy6olstQ7qrJh
X-Gm-Gg: ASbGncvVot/4i85y3OYKhVWEz+yKhDpkU9jHgyUhAOdDNVIhpUbZy2LanPZSJDR0/rd
	xBLGwvmukkRNKQY7IaVijp6vopcOxQH3VSOT5uE8z39DmugvXeBQnFQwUNm1DD9V4pB2Oeddx4q
	fnhOGtNm1e2tz/rel4nb+de2omVhM8BV0vhk4VOD768wPKPJRZKJodO3e36fA6bKvnnA+IGta4J
	+vsjkG1JzSrOuzinrj15Ac0kSZHl15ErFL6j4ZAtWqVjvmdIgi4sTXdOhjf+LsT22Lzu+UX5S4r
	UCP0BTGUQSoTohlxxDjVq2a59J3G/UeInQb0HvZALDB6aSDAJC0790aW+RGOslYBiGrwZFfvfjO
	6ny5hVA==
X-Google-Smtp-Source: AGHT+IFU5GN0HkKwah7/42huJ5KOK/lMZ2nmdkCrAYE4o0hRh/3H4b0VANKqmsJMXvc63vNnpvDc7g==
X-Received: by 2002:a17:902:f550:b0:231:d0a8:5179 with SMTP id d9443c01a7336-23c90fe85f0mr39965985ad.23.1751748421638;
        Sat, 05 Jul 2025 13:47:01 -0700 (PDT)
Received: from [10.230.3.249] ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23c8431a3e5sm50507355ad.2.2025.07.05.13.46.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Jul 2025 13:47:00 -0700 (PDT)
Message-ID: <a591dfa7-6e6a-4b5e-b410-ca2cbd4f32b4@gmail.com>
Date: Sat, 5 Jul 2025 13:46:58 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 000/263] 6.15.5-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250704125604.759558342@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250704125604.759558342@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/4/2025 7:44 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.5 release.
> There are 263 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 06 Jul 2025 12:55:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.5-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
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

