Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652E1429CF8
	for <patches@lists.linux.dev>; Mon, 17 Aug 2026 21:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787001544; cv=none; b=Jga2ZZUYgiiBhL7viXr33JZgOK5tTba3jK3M1rbaUK80BUCkfqHKOkF/m6J5g/NeL2b+WlrXViNXDuqJxbf9FpvJ8pWSbA8yp+Vqxg4yH4hohJv+yVKmk73WU3ex9RP35+T7UOo2YES2wHrqLUi35xbepGU4bqsPJGTlrs7VQ8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787001544; c=relaxed/simple;
	bh=ctSpOgg3OTBlJgkxlyU6B0eTcy3Hbwx8zqDs6L/Yndc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OF55KR8aexxdl7SaVgLAtPwOM6gXY+HNzBUz1JXSiIJawZmaziA7zQu45ZlIW4otgxv7XdXPdA8SC5Sr418N6wbF4nz8f8+ut3AxvZcGAbyc1arUSiEld107YgegiFyWMmrX2clF71O2Y8M5axJm9vteXSNfTQ86mmPeMG097lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ApJu5k3C; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ApJu5k3C"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cc11a905ba5so2009403a12.2
        for <patches@lists.linux.dev>; Mon, 17 Aug 2026 14:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787001543; x=1787606343; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RoEump451F5wZQU3lSV2OnKWKG1y5qtyIVMVnMIXcNc=;
        b=ApJu5k3CZKwqZ409PE6V9ySLCL10bONcNLjjoyqB7sSdk2DRxr+pDoAXBcxMaVO2sH
         6XmSByREPtse16EKdHkejHJXdpp7LGa0ad/oNR/mXomlxJmtqBSedBzHTlae4HGwmh/C
         GmuDbOyrRmnRXEMOp4Nl3iW7XMgwMP1jyPNsT/89vCTsXbdIkeGForPMxvHlVtodeoqB
         wcn+nAliiTASvjzWgyoe4j0rGtxF4Gqdy78qOXiXIVCV2leZutZuveG/0gWKHpEV8MEJ
         r8wqnfHwjnBch/kShzSziQUWqwE4S7hKlBwKuLbn0CT7PC4vvVIxvcMG2jmEnb8LI3Gr
         6xeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787001543; x=1787606343;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RoEump451F5wZQU3lSV2OnKWKG1y5qtyIVMVnMIXcNc=;
        b=s2TrraKyjTg0dOkzplwbH6DVGicyASh1Ifac1s8P29Xk+tdM96CAnFyYraPiJdkYyx
         ILf/e8htc0/m528nK4Etkr/M77jkPLtdSfUScOtXBJJuNCLyzB9DN8K3k6d3Jj4uk4Oo
         0jOKe8PmUVWsIsJ+7x1tavg/anxt0WZXtnoCeMUHrStXYSb8zOHtjrCmcuDp+d9OjEPb
         twROGeCUjzebQIDcu0/fyoymzvcHh60fKeXDPs9c7qUQQeh2vAU8F9+yeqBqkZTG6eDs
         8SPAU0JdDv8nwEygnUaOhZtUL3MLUQLLTjQt2M9BZwR3dzuxIJIOGhTnNk3HVIzNd8ox
         dZ8w==
X-Gm-Message-State: AOJu0YyjhO9Yi7YSGycLmraRboqfjkQr3XbX4iQcHSglOBt2BcT1Hy4T
	PsTYOtxK+dRFI6e31VJmFfaouBHJ8Lo2DYK6tgKnrQCVshD4FiUYq4y/
X-Gm-Gg: AR+sD11w5mSKwqsyA5szdcNnlZ7/tYmd1KZKiGms/Wmkx3ylWmX1u6ThmqA6zjDEh9P
	l/qT2trvxd6t3rwrtcoCerwo0b0A27/IR75S53zfDVyfWzrDh+Wq91PreroRJm+iiSN5ZbXPbba
	zM4HBiXt1QYYC7yk81CW80o5lYAhdVY1UfoPXWJqGwxDPO7qHZJw7c0kg5pkRBReBeNXIsR0jxn
	fBZOfS3dHG40+fs7eSDFF1JMlPw9gQXrdgr7P7clV/f4nRQCMnslHiBAl35G6vVsb36TUXCcPDN
	EMryZjgDHmvide6X+B0QHhh/KuR9bdo9ZTMsKf3iJTAe5NgkDgDk4MTadyWoq0qOlqSrpBSKbY1
	K4oq122eMCVFEfVsFZcqTf6FdF4FbX6nHsRwIanJl7+hQVRmznQ2cMmKcw/0DG5JCTXbCUuvPkj
	d6OzpqBDA9ZeR/VDRZX+7/+v2WYGMVI4AEGxhbrXstHBb7T3js1glbTuUkyqoRp8TEWkB0Zw2uB
	pS+QZyDH78IHl4Zx7MzSl5SJQ==
X-Received: by 2002:a05:6a21:3511:b0:3bf:6d96:ac40 with SMTP id adf61e73a8af0-3cc71a26092mr35765658637.12.1787001542568;
        Mon, 17 Aug 2026 14:19:02 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-32678dd08d6sm13309702eec.4.2026.08.17.14.19.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2026 14:19:01 -0700 (PDT)
Message-ID: <50925f24-3272-4a6f-b981-ccba54fc9dc3@gmail.com>
Date: Mon, 17 Aug 2026 14:19:00 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 000/271] 7.1.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260817132536.752504388@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/17/26 06:28, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.9 release.
> There are 271 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 Aug 2026 13:23:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
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
