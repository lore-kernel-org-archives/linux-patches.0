Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504E021345
	for <patches@lists.linux.dev>; Thu,  7 Nov 2024 02:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730947837; cv=none; b=szuKMAqIJHo2t7xoVZef5dVDt2yopjqRO8rPZv/oHW6KRqGPY8Wt6lLTurTHJIckq4JQnc6cTo12YLgOTfvhTK9vtJhikF3DD6bUzbJ4f34llPOQKkBlWD4wnNfRxOCbUe2UuZhTDw+UcZhXHH9GT8Y33/n+YCJ2tzqsst44MM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730947837; c=relaxed/simple;
	bh=iU8Yq5U1yq8Ri6s5bvf1TqjnMP7Fji6Q8Voe/HqPewE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J7Fwxj+GQN3aw0xfxZBIh5bjS/IxQWrAZfWJDW91Hda14dbpIOz+8edABrSi165+oBm7PkHfRhvVfzuknSqa9N9yX5aDdR+cnBUA7rPr1xgpOeB+1YUKbV+VeRUw2Asko1zhlFDbf5wikLLSkYr0uCAm65ibUvluZhd3UoVItUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WdVvATfi; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WdVvATfi"
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-83ac05206f6so18130139f.2
        for <patches@lists.linux.dev>; Wed, 06 Nov 2024 18:50:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1730947833; x=1731552633; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gDxrDipU5XMaVDAVRRPsfjldbqgDYPtJ2JLlKFXqBUE=;
        b=WdVvATfi45QKkxY8Ka9cR19F1W4417EeEaO6n5jDwGLFTWLXB7VmVC6/675uo6oKIp
         AwcJ5mANd2sQDbw79mLia68fokJO/Ihkk+fISEB5uRLrvEhU78DiDOJSbR9dhy3DDLNx
         myd1bvVXGfoe3rlMQ1bwLgk1oDgUfakX4qtV8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730947833; x=1731552633;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gDxrDipU5XMaVDAVRRPsfjldbqgDYPtJ2JLlKFXqBUE=;
        b=pWoXneZVMGc1Z4pb6LZhSCpgYgPZTus8/1k+zBlKjy8DbgAnqkTyU9oJj+RbtlZmzj
         0p19t8gW9q8PJk7kImCPM/wxFTveaaOhcI9OBfoVlZf0CL7ynixtJKFcDgKxnqbA0Z4O
         MXm2SR0S9tff4eosU81MwvgfNJYwI8EoO4+cX38EQtg5auyiAsiIDi0pnksnCbIk2lD3
         n9blYGMY57E23ypwJEarVMiJxGtfejmJ9NVbBO/I3ugmsT7iYqK2z4eRKcOx8nHBqNQm
         QI5W7BdT8dZPn8cQIzS7eaR6bp9Wo+sO9um1DXLLZJujIlIEZCff0FlXNSkm0p46ISyp
         9Pjg==
X-Gm-Message-State: AOJu0YyJaYF3WiPcGqWsPgBfJkkbXZoLOdIZQVP5ZqSq2/m/yuJw4n05
	z/szzJHkenrhvjK9gw977vBsX3OWLUdmSJeMQ2qI1NgisehJAhxf0WvUjVVhOa4=
X-Google-Smtp-Source: AGHT+IGBvf28hdnALdep5DYPaLK3n1z+yemXA42Tqufg2eRrgyLynA7ZBGCqASfmXtRd3eDSpLE6dg==
X-Received: by 2002:a05:6602:489:b0:837:7f69:eac2 with SMTP id ca18e2360f4ac-83df57bedd0mr71429339f.1.1730947833196;
        Wed, 06 Nov 2024 18:50:33 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-83df50fbb74sm10662239f.47.2024.11.06.18.50.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Nov 2024 18:50:32 -0800 (PST)
Message-ID: <d70c2c3f-aadc-4fe8-8816-00eeb25e59f2@linuxfoundation.org>
Date: Wed, 6 Nov 2024 19:50:31 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/73] 5.15.171-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hagar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/6/24 05:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.171 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Nov 2024 12:02:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.171-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
