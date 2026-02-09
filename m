Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1FC8336EE3
	for <patches@lists.linux.dev>; Mon,  9 Feb 2026 20:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770668667; cv=none; b=CI60zDhO7OX0dmvQYfQzQnPBJwQsoNHtMd+rufV2knyskoYx/D9Xur/JYljEMbMmTuno4qGx2jkyyJ56qZPgcUK9KJB7agFDjUFP9DWU7Ph38gY3ZUKmr/YiKt0/hDY+1SRuR8B0vrM2R/9KcWhSLJb5Nc+TsUT3B/hQHvxpLKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770668667; c=relaxed/simple;
	bh=3/eidtbor3vGsUs5wfO4Q6med4BbMqoBLLkCHX4pvzQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z/TRd00WNPm5yTGAutwBFFiKc+ap70CaU+CWALkkROU6hFVx7xGWvWZeJ8ReZN+ksy3QYc5GBqZtlGBxoQtJUCzSKrCiWhGydTNfPE4GqkHLKqO5Dn15K3eAaP8llPQuLvzjdKXazQZkke+XWU2I7fFbpf7ec17xF8nZwCHUUSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=aux6Xjjp; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="aux6Xjjp"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-47ee76e8656so2062915e9.0
        for <patches@lists.linux.dev>; Mon, 09 Feb 2026 12:24:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1770668664; x=1771273464; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wXzmvqnsXTGi1Auvh0ztV+o2gDRQH8T0ZKaV9J+SPpI=;
        b=aux6XjjpUSrDT737a3z0oyQyDWiFTXSk4SVE4pXuXooSPFHyaNW8JW86ZxnbpZKYFb
         NLjbZPo55Wmowl8MCOtP2GziEFiMIBrtWPe/vq3gFDGa8xPkBGgkUK/4Du6uFQlLlGA8
         ySBjSlPC/5vYOnSM2kd9qkLR6nXwuisC6zSbcCQCJQzp0JQZ/W9Z7LNneJNrFSjb133e
         bYql4ea2wCUEmRKFbfstiEc2XUPuA8Bmn4NBEX5umgJ8mcvz6G2MLmAMYhGiRNrZApxk
         uLI9AgPrbHWnCNiyLgoD7VtmY4ub+NX47jDkUDu8qrnqQtXDnDIxXz0zUhNcxZLZ7Xob
         T2wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770668664; x=1771273464;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wXzmvqnsXTGi1Auvh0ztV+o2gDRQH8T0ZKaV9J+SPpI=;
        b=gUzja3i5XpUTuE/apu41D0Jfh1veeudH1C09YMAg+o7WGdQe9egSH15U5vshsPZ/bz
         eigxbBcqHE8Gv+JVmsikE5SRPCJN2TEFyLZPWEKhg0EPeS5xi84bQqgisA+DBpV0/Pn0
         FPi/jyUfdafhhw7DCOwZAdk4Q2bQYSLiX9ZkelpMceXbZ12fu5NCYgdFYNlH0nf+ZAIR
         e5PF1q0zsF+7ebpOszLJSv+RMbZEASKVHz4WX50A9i75T4ln/dx64pyYkY0GptcFZgQk
         4q6w+IIhw51HNTNQfT9qWcnQu8/Pva2yWR129PO7mCFOIYnTIGqnFSgN2zkZ617Uh7nC
         srbA==
X-Gm-Message-State: AOJu0YxTIdsVGe0t0snhH5zRV8yNAbhljEoyKJoZQbgBL2gqMSaZtIrm
	rW99SIMTL3raiy+qiyuDX7t3w2egEwlJdELC3SHN67NfSsncFA+r2vI=
X-Gm-Gg: AZuq6aKologe1jBFkmD0x17C4UrKtDeQbjo4KvJoZm6AXcEoCWNrB5IRPlPR0AFlg4Z
	rFWzMrJbsjEk/8obXv4OJC5WWRUVXZzSBMVLY9U5dxNuZDW0JCZFOXXoT47JHquepfgzzQ9Gymi
	1JSFwzj40JZUQKKAGxHGn3B13oIm5lf57Ze5gLgvDJWiIbzSHsq1JtY+Tn0iL3vqCemXGCQ174g
	f67XS2G8J9GWX28fVAKUoC3xEkyN3j/YkuIvTIz3bOSr+PKKX80uJvrs5FUqenQXWPfkK+ww1QM
	iWGZ/OXlPSDrfGydoO00yTXVlH7KMgQAVxEheC43weQVUi5CtU9sVpSC4RrlHXJ+rjlwxAbyrnK
	o8QjueAq3qwHXXiH9kjHDXCFccSots7slxUug84bG0U3c1f/27NELlAO4InaePCm76RpaIc/yv3
	M81jMDI6jsWVTEI874rx+uQNREMdFSnt8T9GBXa3tAPgJeeH1sybtXj/IjMI0xuHN/OI03VXcZ8
	Q==
X-Received: by 2002:a05:600c:6289:b0:47d:18b0:bb9a with SMTP id 5b1f17b1804b1-483203393b7mr195515835e9.33.1770668663758;
        Mon, 09 Feb 2026 12:24:23 -0800 (PST)
Received: from [192.168.1.3] (p5b2b41e3.dip0.t-ipconnect.de. [91.43.65.227])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4834d7d55c9sm10964945e9.8.2026.02.09.12.24.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Feb 2026 12:24:23 -0800 (PST)
Message-ID: <65e125eb-2d2e-42f9-ac6b-95c4832c51cc@googlemail.com>
Date: Mon, 9 Feb 2026 21:24:22 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 000/175] 6.18.10-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260209142320.474120190@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 09.02.2026 um 15:21 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.10 release.
> There are 175 patches in this series, all will be posted as a response
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
