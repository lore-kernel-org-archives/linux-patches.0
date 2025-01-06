Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C152B1DF271
	for <patches@lists.linux.dev>; Mon,  6 Jan 2025 23:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736204734; cv=none; b=iAYDC64HLiA69jCJ/0zOUkzxWmu8hNxd9LBe3gH58HjEaAIHH8vSpJuEXva+1V3CimBMqRgBOM7e0cO2eJGyyQbwG0YKhOzrDDuLa6a83XQC7zV6Yn/tYuEDMypg8czzQofFfwFtZJGnbHKpJ+wwJnzyhGrUm/dzxnNpFb4zTWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736204734; c=relaxed/simple;
	bh=ER5Yz9kOS4M3qneRwV1W+hbll4azflGc7w+oKnUTlGU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dFX4LT9hSaRo8MHRePKm/XJThmKUDpXfB7rIwvdkbqu/835MhBJtI4IEUTwt6kDHIl8gfqvoUoWa8sNq5wVDQx0VjzJENhSbuX25JFRJHVqFkpWum2xn/kD0t8Y1eDzTBAw8bOOnUO3HBSw4w7qOVtI0d20MVyCa9+ovWsmdzl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BU2m3Ond; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BU2m3Ond"
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3cdce23f3e7so21264795ab.0
        for <patches@lists.linux.dev>; Mon, 06 Jan 2025 15:05:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1736204732; x=1736809532; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WO8rgVVnKrlIP7QnNtiMdBIDZhjxV64FAnnGDxLCHec=;
        b=BU2m3Ond8cDN5HQ5z4zXTzkFgjSixdtJQByXsSm+bf3vTdea+NNBFioo7DuMcSxNH2
         IjzQPSZ2c/14piOHtJeCn+oMgOSsw4GeaSqdtPL19ersauoV+6sHy/wlzEaea9wgGjQd
         Z53zi2T7rbEUfWYqhhIn/WoLjqNsDEqfDE9ow=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736204732; x=1736809532;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WO8rgVVnKrlIP7QnNtiMdBIDZhjxV64FAnnGDxLCHec=;
        b=F3EBQo9QY2mQCTtwGEBbnXIEFpuRFGUxOQJ+FxbxS6ha7rpM9hQzAtjEX0FMwbaDOv
         oLto4e6L9m/btZbuHEXwPOEAxnJKqZWOtVwF0lblzUmy4ORXg8wYSi9KwDFFDIr2vaC9
         QhS/14ureH2IQlliHCqguTKsNojuAm8Ns1YzudoY8kPMD9u+IQkVI+Oy38V03/KGNbRQ
         gBROYzADb1MIRfNDBXINpQj4SwANfrlImv7v2Gw3Ixb1YbphMVW+se7f5/y6Aqc1YCf6
         e0srZ0MFjr6vBSmwOeCtfgWQXgLdZlYt9u09LuJ1eZokvx1wqnfcZBlinfkWPqMEmYBv
         hvXw==
X-Gm-Message-State: AOJu0Ywew33izyqCB4Tx62FuMIKB3gBraE9XFWD9pmPz3TIrJpj9Qxn2
	i/Jj/ODR88GKmlXEmVl6ADPSjHI12uMIT1+cBtHgNaNdPwoRDl8x2kogu/0QSu0=
X-Gm-Gg: ASbGncs8TbvNqwf0Pfo7vfMyGfvoNe+jpzuVPsbl/ZRtqnHLNzhvO8bPrcQXOfVUWtW
	8r6qeH1EUdHJmqv2PkEHZBr3MyHCThxj0u8siY19CuK6rv5jczX1TqPAxWzprOzm5GRJ2VkjpqS
	pFTq4YRiw2wIOm6I7pn6nVJ+ZsO1OnFRVwBkmYGha7p/5dusTPMwdkodH1SeGgTU0JLu4EuxBWd
	8Wy/WXhQ3F3rfSrwjXo+FYN+JYQ9L++kabqUXZlmK9uR8vw0gapYlfaGErgpymq/QuJ
X-Google-Smtp-Source: AGHT+IE1ug/ECMGbNrZ04hdqCJXBEemo+rZ1EKtJhngCH2J1PkN1z+o+R3HTuRNgGuKy8C5cyCciog==
X-Received: by 2002:a05:6e02:52f:b0:3cd:d6a7:dbd1 with SMTP id e9e14a558f8ab-3cdd6a7e190mr63730045ab.13.1736204731905;
        Mon, 06 Jan 2025 15:05:31 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e68bf7ed01sm9645635173.66.2025.01.06.15.05.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jan 2025 15:05:31 -0800 (PST)
Message-ID: <d0e2b7d8-cde9-48f7-a931-ba204deb3a47@linuxfoundation.org>
Date: Mon, 6 Jan 2025 16:05:30 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/168] 5.15.176-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/6/25 08:15, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.176 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.176-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Build failed on my test system with this commit:

	999976126ca826e40fd85007a1b325d83e102164

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=linux-5.15.y&id=999976126ca826e40fd85007a1b325d83e102164

Worked when I removed this commit.

Errors:
  CC [M]  drivers/gpu/drm/amd/amdgpu/../display/dc/dcn20/dcn20_resource.o
drivers/gpu/drm/amd/amdgpu/../display/dc/dcn20/dcn20_resource.c: In function ‘dcn20_split_stream_for_odm’:
drivers/gpu/drm/amd/amdgpu/../display/dc/dcn20/dcn20_resource.c:1945:40: error: ‘const struct opp_funcs’ has no member named ‘opp_get_left_edge_extra_pixel_count’; did you mean ‘opp_program_left_edge_extra_pixel’?
  1945 |                 if (opp && opp->funcs->opp_get_left_edge_extra_pixel_count
       |                                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
       |                                        opp_program_left_edge_extra_pixel
drivers/gpu/drm/amd/amdgpu/../display/dc/dcn20/dcn20_resource.c:1946:48: error: ‘const struct opp_funcs’ has no member named ‘opp_get_left_edge_extra_pixel_count’; did you mean ‘opp_program_left_edge_extra_pixel’?
  1946 |                                 && opp->funcs->opp_get_left_edge_extra_pixel_count(
       |                                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
       |                                                opp_program_left_edge_extra_pixel
drivers/gpu/drm/amd/amdgpu/../display/dc/dcn20/dcn20_resource.c:1948:41: error: implicit declaration of function ‘resource_is_pipe_type’; did you mean ‘resource_list_first_type’? [-Werror=implicit-function-declaration]
  1948 |                                         resource_is_pipe_type(next_odm_pipe, OTG_MASTER)) == 1) {
       |                                         ^~~~~~~~~~~~~~~~~~~~~
       |                                         resource_list_first_type
drivers/gpu/drm/amd/amdgpu/../display/dc/dcn20/dcn20_resource.c:1948:78: error: ‘OTG_MASTER’ undeclared (first use in this function); did you mean ‘IFF_MASTER’?
  1948 |                                         resource_is_pipe_type(next_odm_pipe, OTG_MASTER)) == 1) {
       |                                                                              ^~~~~~~~~~
       |

thanks,
-- Shuah
