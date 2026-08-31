Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2CE7443E40
	for <patches@lists.linux.dev>; Mon, 31 Aug 2026 17:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788198642; cv=none; b=dmdiyjDqROdSBXbAqL9K1/ggE0+8okwztI5Wi2Kx1ALcXlmPRMOFchAViDLrmNwejVVEpOoYaIEoIyY9ku95k5nn/wWj4E5cYCsb9ojNw3HVXDbSyVv+XGlsAHrhsCa8gVA0k3UKHclVndYkNheRlRKcXEXWrKSARbbVuYj3Xnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788198642; c=relaxed/simple;
	bh=nQ2OzwrZKHaYxYFAxN/IhfHiA9sv4Jp6iArmTITeQhw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dBUNiRfy90lW3kq0E/3dSjE828PaZmD1MIPFvnwByW7Vkb7c52ofpmuRlw8wiIam60tv5H3idTwdod7+yB3Z4uEpmDfh7JoZW0Eg0PBFd+UQSotlEfrhmP1f3LQT5aOuvnnknZLO85DZ3OVYMcWnazJnBE2FykH4PdizD5FXmWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jbJtKqSk; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jbJtKqSk"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cbe827e3cb4so4093899a12.3
        for <patches@lists.linux.dev>; Mon, 31 Aug 2026 10:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788198639; x=1788803439; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lbLc580QKHQB87a0tif0AwXX4z/fpS9vCcyNo+ew9kM=;
        b=jbJtKqSk5jh3nRPns6JnZh862mlr2Xpc4a/TIh4aWqbyykHtY+xp0Izhjalt0d9wuI
         MZkdrnWzuwUq1FMZ/lM6PHTY+gIL69gXduD/EEAndbN0DDOEjPlFFsFmwKVcr4X4Lmw7
         Gjl0nWLnltFBN2rVycYgfKchLN7CVfXB7cjmXnaDX3AgBQSSmTnv0Dv/kJ+CVOnZ/42E
         w3205+uK68fGJ3w0rkLofvYUnhc+dgeER0niIqW2lCq7enZt/URXJZY8wlO46Uom36QQ
         a4ttFiS6bV70pDuHD5dC2atYv3iMpBqs9xPXt6YggoHDl2WfUVfNWVMvwF41TnwJcF5L
         s6qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788198639; x=1788803439;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lbLc580QKHQB87a0tif0AwXX4z/fpS9vCcyNo+ew9kM=;
        b=mGCYOliMdYvMBU5Qa8BCv+ptbGHU/Kw96SDehgT92ogPaC6G65fqObAxDmZrxIequq
         zG9qks0mDFlStKwLj1w87Mq/MNbx5uazP7+wqq6pKK9KIgfBLZU32hdTniU2nFa9g57Y
         XgVYvUphHw4/a52fljtd36OqJNf0NlP3eT1ALW+QAvKilv4ODHdlygM4JreQxUxqPnCR
         x9shAMnVMYaGC6bSgkyxOJboq9GubtHZkf2JJWFnaN5pAwmeR5e1DOT4Te4Suyb+mVWI
         WOMC//Lcv+tq8HlMT8Rt12x/UxMq/Hd7vLj4l+eUhqycLu8yvKvj/mMa0PRnkQs72ch3
         Idmg==
X-Gm-Message-State: AFuF++nIAAd3P6zTCDQ7SWuz85ucsJKU7D4dpwbGzKo+4CDBMhOJQtit
	V6BWEoS6XiUBDlT9DoshVwBv2pd05cau5+1XYnQY5QHUOXFwGDqc3Ux5
X-Gm-Gg: AR+sD1243FJzOctApowRPznpgitIdteXyLz2CjtDqyPRG/+dOa71Wz1C9zqp50eiWom
	qRNMlk+vIroxLolgW/XkOYaKbwUc9Ewxh7gPqdN+pEaFoCN7F6g4L+16P+hSTST8OXA7PiX1iYx
	XfR1z+rEOBh/kXRPDIq8pNkIKgGZoQeT2tiZCCrU5p4sQHLyjC+yJriiKm4qV3D1DbVfw6xei9Y
	rPtECq8lVrKcimyD8W22IIEotWK/+rVlzx9ovIzaqLEmNlvp2iUeshTOVtivgz5jJHmt+NBpLAO
	EW7Cf8JI8Oe2KuWxK9ERg+3GYumYSWi0hKsFVAt5HytjVOWKuHvJxSpXFvJFc4k8fy3vdD4L57T
	j/C0Bemaau3whYHlf6+Ucf3VCEWmtBbrbKFyU5lWRcPFWuqHzm83EUUq5mmTygSQl6nIQhPcnBE
	cvrsLENMYAlZzXg6QZYb9ebLVaELngBBm+/YDMELKZeunKuKtxBB+UfxG4QyWKO++VDZT7xjyD6
	T482SPfqEyao4AdO1NqWqj8b1l9XQ==
X-Received: by 2002:a05:6a20:9f92:b0:3d2:3e73:29eb with SMTP id adf61e73a8af0-3d7adec0469mr4503090637.1.1788198638790;
        Mon, 31 Aug 2026 10:50:38 -0700 (PDT)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3286f95a160sm31383185eec.18.2026.08.31.10.50.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2026 10:50:38 -0700 (PDT)
Message-ID: <674bb3e7-e61a-4535-bdde-beff6bd1c2ea@gmail.com>
Date: Mon, 31 Aug 2026 10:50:46 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/92] 6.1.187-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260831133359.482388899@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/31/2026 6:33 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.187 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Sep 2026 13:32:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.187-rc1.gz
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

