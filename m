Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB2314B086
	for <patches@lists.linux.dev>; Mon, 16 Dec 2024 16:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734367167; cv=none; b=UHGB/af/MtEHUjKWan0sLtGjw4icoyhrAYM5SWAaUsImN8GcSeb+A9X0baULyx7D/KXcX88tKsnjLlyK8bqf5wFQsLreleqqpMJHD9yKhqDwRIzKNoxFzbEngnV/+4AdMxMh4SSTVtcPoMaY4zVqUCmXi1A3KAYk+uM1G8M31Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734367167; c=relaxed/simple;
	bh=HB97ptxfQdcGt5WW0Z8teZNUu8TvPHIb+TnixivnxBg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pGK6Xc6aJwSxdPlyxvh5eCyrDcQwf34Ay13Bm+HPZS3PkQtivVqPeViEpS4pzuhAzW0gWsB8qU8CwMAU9B2xTpyZ2Yh6/hHGWiS+Z2E3nrZYJYCDIbOXwwcKAoLJjm1Q0u5o9ib+dGx4DpU9ybRgB95GLdSWaFRHo/tTpF4BNaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c+OituER; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c+OituER"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-728f1525565so5104199b3a.1
        for <patches@lists.linux.dev>; Mon, 16 Dec 2024 08:39:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734367165; x=1734971965; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sD7aXvIEwUa7UnG265vLiK6U26rw7FaP167t0jjQInk=;
        b=c+OituERKzbalJtir7WE61P3Hl/UWxEmOckmYB/3b0UibZyyjXzy8xX9vaJGaWM3eu
         BrmgrowqxIggpNAfLsHHnHpLE6trldpgsL1JIN6iHZFHHEea3BUs4DtI4NiVRNFh5ilW
         oDYbPGp+IQWNCBD70SWup3lLRDBT0RgG7kljaYl3SAo5EFJPlZc9AuTZz7EjQn2ijf1j
         obma03YKducjzVtmysqyL03qx6qMmNCekM7xBHM5WpiqVciAx/RA/2+TIiD7TBFOhn1N
         hL/17Fs9XCB3zvlms+5SG4v5GZ1M5aI+FYoEyvFEI3SLyq9lnx0rYNqKbJLX5P5EgBq8
         SNUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734367165; x=1734971965;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sD7aXvIEwUa7UnG265vLiK6U26rw7FaP167t0jjQInk=;
        b=ugWYMaFFsgoeYdv5RJOGBo3PaawwqvwoUulcRlC/07sNNwu9e6F3DvM4zKGJgSYzlS
         j83buJQi9IutgE0L6sd3jeD3TRXNlrpBjak5cYdMXr34sGnrfvAcIGLr8U0LwU3gG845
         ATerM04y0VCT5JfKvVxE+vqmXL66ASNVghU3VoItacad7trFCzRm1gf5AubzUCmjVTaz
         QhjtKYGbA3iiI99U8BnGEHO36hsLijfw0cJkeCkuQHaHHosWc9Jx+9fdRVV90OE4wov1
         lDcnqPOSdaqtvCTsCkRzHaO9U2BKYdEGovW9odC1U96xMcYpnXzowgmERbA7GHtT4dI+
         l1sQ==
X-Gm-Message-State: AOJu0Ywz6duXXG6BV914mjfqxxAATHzfnjdf3kPTw5tNeDGmvj/yAbei
	NmQYU5k2BCMXwUfGBTO0O20s6PZkC/I8N3beFwpBTGerpXBv4jk8
X-Gm-Gg: ASbGncswVBT69ZvJgOpqS1GXeK9DFWMuwhnPAXTLc7m/hcTobKRC8PRaOWCUkEetiVT
	5vqsoEsGIREQiDH18CnG/34PSW+W1tJKuwaVxoL5wFwBAtC0ObFvb1+UXKohqmaRszVuiEhoVd2
	hTBMx7z9jcdGhlPfyLiOMWP/IH5W855B7E1PB9W/6KZsuPw8UqAvUV/BtG337/bDTM04mWYRGDm
	OwYmoQDpFHxgr29eUziZwfb0u5SXYSTuBlx8goan+ylWGB2+mxI3Z+3ZvJJ7f21tliaXkRvZKGT
	2WToE67ab6zD4EFThq4=
X-Google-Smtp-Source: AGHT+IEOLsWLvI0TSnoLs1Bp5A+f94y/0ymkE8Qi7bPRD4MrLFTHVzKvXSSTvhiUUo/mIuLkVPDFvw==
X-Received: by 2002:a05:6a00:e06:b0:725:df1a:275 with SMTP id d2e1a72fcca58-7290c264d7amr20359969b3a.23.1734367164714;
        Mon, 16 Dec 2024 08:39:24 -0800 (PST)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72918af0ca3sm4970415b3a.81.2024.12.16.08.39.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2024 08:39:24 -0800 (PST)
Message-ID: <626ad436-6386-46ec-bc9b-94b7845385de@gmail.com>
Date: Mon, 16 Dec 2024 08:39:22 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/772] 6.1.120-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241213150009.122200534@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20241213150009.122200534@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/13/2024 7:04 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.120 release.
> There are 772 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Dec 2024 14:57:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.120-rc2.gz
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

