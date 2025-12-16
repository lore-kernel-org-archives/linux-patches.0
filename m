Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E722C320CCB
	for <patches@lists.linux.dev>; Tue, 16 Dec 2025 21:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765921722; cv=none; b=HSBkbWRNc2MWbDGeYikZFyUfPcJarRBTknwLxlNhkCObiMQ01upiIUjrTc+vi1wppZMOswF4zyTuDu3g4bfFuGXtnaAFfNVf0NamzDveOZcIS3cIVSqmqXcnHza1OQVY693Ui+jlu5eDzBLFAK1xQlFzb7ZGrH7lLoP9exld/eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765921722; c=relaxed/simple;
	bh=I3khe0INvGbPezO8MZGli6eEOt5M5BEU8F4wdYbG+KU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cm0FgWYtG5AwpTudSwHeBqPgKNwoYz5kF4OuPkq2wXc++wzH8NqceE2ww68NK+slAz3oUoJU7mF3oDhFMpsymiX9Sm+D1n3W7TDCGMcMW+3C3/JO+v0yimVlvEHTihwWxO8rEgk1/M09ml95UxHM8Ancg/6Cy+agXkj5Zb9iw34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qt/KEzvT; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qt/KEzvT"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2a0d6f647e2so44012945ad.1
        for <patches@lists.linux.dev>; Tue, 16 Dec 2025 13:48:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765921711; x=1766526511; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eMTHmxf1vh/B5qiF+nhjuqwN+fGfM3fi/VSYaVSs8Ac=;
        b=Qt/KEzvTWxrv3bYlPTBGARJqgcggo62CCHlsJmNtnf4WEG5SRoi+h6lWniTbQhCK5N
         cq/utMI74ZtBy/TtFSCN8FlXNCSOOlLdsNQGr5INqjZ+EvEOak812C/X0bkZZpkE6YRk
         b79HJyHKYp0scCyuiEE8U1cfN/hH9/bnomdq4jgamKzPRqqOEx16IVtbcJ3Di0QUm5c9
         kd3jTwkaFvpzpsJLmnY1NvN1bhbsMbLOrFpOjUoDDxO2CEjE3LmPIAOUTQLvOVxPBXw9
         3gTVtxbZh1BDUC3B8c01IBH883fOnvg6XnkiWKWOWhGgbY46YiCNMJFyZT8dXgdVQyCx
         nbTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765921711; x=1766526511;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eMTHmxf1vh/B5qiF+nhjuqwN+fGfM3fi/VSYaVSs8Ac=;
        b=iRvtexH5fuKr0Bs5cpt1+W3OajshXXfwkYT74hd8OV5wPQNLjG2rqiojCv1aP02Us6
         wUM+hOzvkHHHldc8ZLEcIqbWsJmA6g2oJpE0g0YG5JTY+6nTkd/4DF+v7zobHTEtz9Jb
         fp2MrTYXUz3Tudb0u6KfLFoHthwNBADKrhrAjWm3ey3Amu0FtH6cTsnIi8CpTAsn8HZB
         MZ3+TZ/gp7e/sCuAdwwIOVYr2wD6VyhUiLD9tCCz/4hJkpemPYI23GgTzQsrYsqqjH0y
         xVHx/q8aHBFnO6MgyVijYYIH24sQl9KMSqPNZMBpITWA1Ne86VaeJ/ng2fdqBhBgzTSi
         hXXA==
X-Gm-Message-State: AOJu0YzjmprArs3ulxRk5baE9cpbJcqjMGlCkg2zCQbnYfhMfERxBrz3
	BgNTsolJqNy2CQQC1p8QQAAIw5HjOhjGlgrs8O4XHaF00RMCMXejEeGP
X-Gm-Gg: AY/fxX4S4NOw4uMy/sNKrqhdl7Rhwp2aKcajsVY90qHatZotvXW6ZGMSPljK4C2nphs
	AIrGs2Fc9dzQ95OMkMTc7BuZTt9XQOQmQxaBIT5A1f23mmSv+jrWY44nRw5igZBCupaQO/F74sg
	F41de7cpUjuRcol5BbUcbk0k567aS/YN8vfIgf1gI18x5UDibqXaYVAc6wlUSvtI5iNyiP30b8M
	Jz9myZWVsM9my+RXe7O6Z7rDAvSyeH9vX2YtniMBSRide1tS/occiUDk/X5Xgqte2uetPoK1l2M
	FIo/pEp0qpSdaFHrZ6PEjEgD491YSQfbExQLObBFpCQL5cWp/LC0GcTc/44DTZvanhR7ulZ+2lT
	WkIQiYtbampakajBMG2bGukTg4NhMFxDGEe0zNuotuz4Gq5VPQ3dXVOpq2Vj6JiicnEVuM+RhPA
	vBkxIchCyTfMHP8kxKFCdC+EwHMnPyzygYZkh+4w==
X-Google-Smtp-Source: AGHT+IFOlKrP5dymtFfEhr+JD4QtZshAYy9tk2jSUN52Wv1Dnrw/OYGy8yUGpFmBSM94R3467aMp8g==
X-Received: by 2002:a05:701b:2309:b0:11b:8278:9f3a with SMTP id a92af1059eb24-11f34ac5418mr11887492c88.8.1765921710596;
        Tue, 16 Dec 2025 13:48:30 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11f461a0ad4sm15625722c88.14.2025.12.16.13.48.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Dec 2025 13:48:29 -0800 (PST)
Message-ID: <011fb0d4-bdc5-4997-858b-466a381a21c4@gmail.com>
Date: Tue, 16 Dec 2025 13:48:27 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/614] 6.18.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251216111401.280873349@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/16/25 03:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.2 release.
> There are 614 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Dec 2025 11:12:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
