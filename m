Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF07236F913
	for <patches@lists.linux.dev>; Tue, 12 May 2026 22:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778626075; cv=none; b=nKAzxAd3Tle/JFv2vxE9LFU8TodHgNByFT0iqx8JRoVtwJGacA1p6RC6jxusUN5W83PNDn9WvTpBfHCD1vHX37pvl4yWVTCd/+lnatdL6Nc3Eoa88C52zkLq/O9hK4dBznSqcmAJ4k6ZPyObTn0zO+HdLVqY9c2qqtwMtLH53JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778626075; c=relaxed/simple;
	bh=zfpFbvjNu8Qz8JiQuWtUBPET2Js7reg1cMZWRxqrmuo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=irczXryqFma23GJdxEjtEmtWBLzpB7+gJIhxe//ffPaTBcqh8P2UEtyn/JCyVOIywtYt4OtFpHK9A20VtSGy1Wgqd2RT9frvjHU8wtWpRZN3VoTjIS7CXKS3ZXnDAPfz9X4pWayuezFnEg/T+rb2zOVsVfUDQrFKHVnjMwtkcvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=RsP7mSMR; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="RsP7mSMR"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-488b8bc6bc9so38139705e9.3
        for <patches@lists.linux.dev>; Tue, 12 May 2026 15:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1778626072; x=1779230872; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZBq3xod0iZ+2KYlXZD+8zZsLf/sBfNo4uGCP/2E34QY=;
        b=RsP7mSMRXnFwQHmXkIr89cF9p2SZV4OMAY+o5aaEr4G09cyPW3Se2f3xAaEI+B5NXI
         FzMer3FePGXiInHn8P/m10DrzwvwmUjv+KdiNRhslVOVBgM3Lsl1DRWoCJHJwkkUrCNU
         dqRHTfgZR3CaN/B0dHTnPqUcIVTYI7gr6+CxCsMBm87TmZPQ38Cc9kO4nVsN0PVUidpR
         NYvOCFKiaMfEve2evsJOvafphrL1mc8aq+vvtnKWehuQkgvx7EGAnQU40ZfhvYo/WQk2
         VnpwQe/v4NqdW3sI8cUG57ZWUzigOks8Z9G54Dj5N//tlGL1XzQVzxLZR57ieoqUVsM0
         uCBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778626072; x=1779230872;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZBq3xod0iZ+2KYlXZD+8zZsLf/sBfNo4uGCP/2E34QY=;
        b=Bg7ovQbf2SZAQLDuHvtksp3JKyqoLK2lxH9iL/Z9fR7vBCltEWCcEuZgqdpJC2WM+w
         6zJDaE5fLbKLTlRuWSHPRIUwyWavOvgP+tDyi6TzLUGTmonSwAXOmlMJIq3Ovd9ChPrF
         bQfPvUJ6PlTAe00XIZvJf0mE5kk5dXuZXtN2eNiNQRqq1pdMku/HtISEpkOFhPmpamxh
         oNdF/EgDBLhcztAEDwC8jmbvlBAMcTi00ZdZ2JFH3Mxk/px9U2d/bBgYhE4Tkrzmckwm
         0C/8cAfpFne0AXax+Lmj7h+TgtcVDhqk+aAPapIt1Vz6eWmdSAyQAKUfPW4A6XdMT/Uv
         S7iQ==
X-Gm-Message-State: AOJu0YzwEBeevyJUuhbQKULaVmuLf8MilM980YGMZ+BOchMBDALiogE4
	oS7ESAy7ggN8gkxr6w7L5TargKaGC+C+VxtQXcdd/V7E4vhNxOrgxYA=
X-Gm-Gg: Acq92OGhB/nbR5X5ImxObeDNQfSOwNd9Xhf+MDiMZssEC8PX8PHVM5dCHL6TOpHl7Mi
	9Ygd6RZFKmLRYLsuTWf1T3Bjwaq7ZmsE1VbaNq80MT8D8MTxEe6c88vLypyH8g9wx4grblBXb6G
	1mIdV3W+61e6rs9Un/vfLmX+elWGsbb9RSKeTEFDOXSOKfN5qIO6NtJpkLEKnzJaveDz1cRsxVN
	gb7ehrRTBZqDBGzDkYl0H3uffI8xRqoTP6eGwGsu2BfbcDgAzKAJcxX3SCYfflaaQQKQTBBC8cJ
	nSb67m/LjXF8zsBHXMIrNMEFOBVXLRsUCypBGQnhnK6Hlq7DMO/Y3k+Bv5jXClKHevAt2neIbYL
	oavLGSt7ay/+xQysd6iJi96428mdzH3zmuR+fjvmqKTu5U2+dShJ/GqBshMzCrwcWz1kbt6G6q2
	HbgF083teIlwEAVKJqI84jEytN05TCM7cBS7dBDrGkQMX+AeVRknYFNY/PbCLX58SJhA3If4aGR
	/wVfdtMX4Pfvw==
X-Received: by 2002:a05:600c:4ed1:b0:489:a4:e555 with SMTP id 5b1f17b1804b1-48fc9a41e96mr8792015e9.21.1778626072062;
        Tue, 12 May 2026 15:47:52 -0700 (PDT)
Received: from [192.168.1.3] (p5b05786a.dip0.t-ipconnect.de. [91.5.120.106])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fc8d27d31sm46408225e9.8.2026.05.12.15.47.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2026 15:47:51 -0700 (PDT)
Message-ID: <d6770326-38d4-449e-a3a5-ed43400726c5@googlemail.com>
Date: Wed, 13 May 2026 00:47:51 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 000/270] 6.18.30-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260512173938.452574370@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 12.05.2026 um 19:36 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.30 release.
> There are 270 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
