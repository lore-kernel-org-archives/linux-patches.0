Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794597772;
	b=PjGU5L4dqBo8YC0TkBlSt/y1dAwtEwFYcK67OCKVhlMV3yBBAAoGVZF6C0+ZKUP1r9hy
	 idDy8SqeOo+yT2pL5DTZ1NhCJCAT42Pl2XF9q2PevTpc+6OEoz1IeNgutYAYFmLPTumB0
	 WvYsNTV9MiDE5ZKXMGiZVxOrhoAz0Xre+dxqwhhRj+x/mX2z7P+AbQBUQIHMyu6CP7ndh
	 QDOTHhHKUJiPwEb8ZEMRykjMpSOon4hxE0ib2PA3WyRM4oNXqPEtQAxMHWOeR15QBgZvM
	 cZBH8aYl5Z2MTvcHMJwCaSDRMlcfoQKceucJpgacN8vXMcDV6rw3hDcUq7ZMd5zzCVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794597772;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=hG1EB293hxr3Jgg2QdT4ZHxs80rfcC0WBpvazP602rI=;
	b=i8IUoLyepxNTlEeExrybzS7BArp21D+91hU6GadjEflgK9ExapEt9zaxRs3rhApczAdR
	 FZD2rCtkq8B9OcnmnfrsURaERo50ct01IPgCN+C9EJ5A9rF0w7n6SSsnCT+6XJbdUKWXy
	 GTjKKfSe/bYovK6tHL2Qvg15UrjczeCfy0vnbUcHw9ZA0L5IHT0q9tLzQQZw4OMb6e5eR
	 Ubj5sLHD1kvby4d+MMV3xIoVf29T/WOYL2VZUvR0QL6PQHLOIVLaVhNLqu1ey4TEQz9OL
	 oTj7OBQGFORA30N08VpaNtFX5qlCGPI7Pnutr7dGLSYnhRKd5kilhg64LBdB8muGK8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xZzs90ih;
	arc=none smtp.remote-ip=209.85.210.181
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2DD606A332
	for <patches@lists.linux.dev>; Fri, 13 Nov 2026 19:22:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3D2DD606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xZzs90ih
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-8b6b22be970so471436b3a.1
        for <patches@lists.linux.dev>; Fri, 13 Nov 2026 11:22:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794597771; x=1795202571; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hG1EB293hxr3Jgg2QdT4ZHxs80rfcC0WBpvazP602rI=;
        b=xZzs90ihIkykCMnKF4e3UohRgmxg9PDb3LiK8nKfdRtxhFulC950mRaJD7GkoZoLbz
         zDuxVj1hNtb18AjXzs39m8skVbxvnd2A8BridocMYYCrco4LjB3GdCRTwSc1HGTgjpMk
         tOl+fSc9+wAPo1ICyWZmAPpIdz+rrOOrFXtHcc9FBOfJyx0qDhjP3hyJkLUq5+jUlMOF
         WYrdWyBPUEXRzMBWOovc9O2uhYR7JyA0eMt2Oy80T1gLjdWAdzuZb7Gr+Wu2sFsCBAPz
         Gw9bZUxrZvv/j74UH8V4qcEdLW6Jrm7Ixhv6zO5gOeZ26Jy5hUhoNPSkQhfl9OI+Tl+L
         mYwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794597772; x=1795202572;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hG1EB293hxr3Jgg2QdT4ZHxs80rfcC0WBpvazP602rI=;
        b=WTVB/AXVlfbhsCI+0X30ZGzUHIJ4UrjZP3NaJnsS7GuOnVtk+KtSr6kFej5qLeeOi1
         rmz/TqJOvhD6zYwMmnQAG4Yv+58MZFZEX6VQ8BWEKPR+7VR/duU9O+fMUbTLMtNNkd/O
         VkSo+9y7QlnWvMSAQ+gMpyLKuPVXPZ2FC6+fM4yiTa4ILZduny4MF+mLlEDHolaL/iLh
         DGLQBvQk4bLtYn51N78xWQ4mFPUBzlSJgoRaJuEjnORKNHTreUMHeptKQRNqDCX/e3qK
         70Mu3wCKGw/Cyjjo/fZjq60Ika2F2MUqlbc6g3F++frOwwwGh813vLsKsRJY9VTlMjXl
         q0iA==
X-Gm-Message-State: APuU4Z8a/BvLhXFAbRn2hZtrhnxwoNEKgl9UOjf9YKPZUIi7Bf5zjgLb
	icBbGfY9YTxTj/tIirH7g7c2Lbhi822X6hMdY3uOtCCY9k3Sw051TGWX
X-Gm-Gg: AYBFou0KoS1v0GmglCUkDVIKoJotn0CwKRkW7n+KYGa/qISg5WwVXIpkdKA+Dh+sVWH
	b0N6dQUXIa1FlRnbJXjDemhCjWNTG7CVNzjzNozvDywFpFUoVYcHEtyCIruoiHX+iLpirbOUufo
	GAYN7ve9vLlaxCE64XQans2AHVwv6CMvziV2KsypPLNJfjuHPOryAK7w2YpMxyLUHLLkWVTWUIj
	zMPT0a1A1tPXNwPhGPnRIVdb5YRAMPVmD2QeRICROAItwK7Xzib3tODSgdpC+4xk/dz8pGmTv1+
	frJGbdjefEZhdxhE2guWLPMSH/wlE/V/H+meJtAyo6g9A0E4mr4EeFzLqD5TqvZLUUpbr9mEoUS
	8TY8IzIc7oEzuYPlvD7FlQrUINvB/JX7z1aAQNJRX7xp9HF6S1XeFlJ8X1YVBWpxhcHKGnVXvqB
	ENnKwZhrDVOI9dpf3teBgMa0iUMs47rOLSwXZ8CLJLs48dixIBTXSI7APVPFW+mQYfqSm18rn7s
	Aw+XuK4WTYYGLP/gsxDXxm5og1Ztco0K+/8YbvNA1FYnv8AZwcJFbsgQSk1+2KeYRid/zSBL98u
	Yd4E79smMJbSZ7CPDGYFdDSAjKOAahnht6j9S2Z6TbSY8QsEcXl7XN2reigViiGwy7YAhZuLlm1
	h/w==
X-Received: by 2002:a05:6a00:b49:b0:8b5:ffa4:d618 with SMTP id d2e1a72fcca58-8beb6b771d3mr3233331b3a.43.1794597771515;
        Fri, 13 Nov 2026 11:22:51 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bed1d6207fsm1601457b3a.32.2026.11.13.11.22.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2026 11:22:50 -0800 (PST)
Message-ID: <36d38251-994a-471b-94b7-d1356326355c@gmail.com>
Date: Fri, 13 Nov 2026 11:22:48 -0800
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/670] 6.12.118-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261113153811.177190860@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/13/26 07:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.118 release.
> There are 670 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Nov 2026 15:36:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.118-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
