Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794599379;
	b=E0QAfhaFtyfF2kVHlUwOBs6ytx9NkTqtCEXaA9xqlNNQAwsq9g7he12GU739TQ8zmga+
	 OEg62KNfA9/xXetnZ/ykA+0BK8VcZHbvDB0yCoOoMKo0+h98UurXUiuhfl/iDu0eAI3zA
	 JMogwFrc+gObTDm3e0euPNWd8HLiwtX45TJE7MbBjYBWuah91ytBPWcJ/cLbX2uos0e0T
	 VZwAm5TVXqKkpCOsnbIcJpJ6q/HiPDzMUvHHtkWcsg0JsRP8f5G837/uQkikDcBsKquvR
	 FrT9ADmbDkfZh5RP6bKGtps0IN61Ya+BzkYiPeYeEnlOF2PDqCvicFOZY2uyMKWlo7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794599379;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=J4rSsefiHQznT/qIvnLX1QXXlawJ9C84nNyE3ha35so=;
	b=sdJbvc4NRZGdE1ugsaxGfMGtE+IDO40PaXJadTqkGsdG3L5DgGGVH1KZnehPvQzVJJks
	 8t2pMQd/oMYCNmln15MSLdj4sZ0Nu/awjbKBbvGstiPNSKJeeAITrvFwNRqRwLEhHt7Ez
	 c3syL3B4oVfUFpcnY0KKHIDYzwOFszRMsfq/t3t7uYYyfWN/i+QAe29xstN4QwyB22rer
	 2OL1DWHxrCbPdirVMIJ8Nyi2ci5McImtcSUMKvu9qWzVTGPvQQ/GPUPzQJo0enI7mHPyn
	 gcqhm5CnNffUwNxLIkm67+74Z/DW0zHJuNHYItUqfQPwoGLaPKfec7qdM05aTHN8otA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LHRy9MZ4;
	arc=none smtp.remote-ip=74.125.82.53
Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76EB606A33F
	for <patches@lists.linux.dev>; Fri, 13 Nov 2026 19:49:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A76EB606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LHRy9MZ4
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-14394530ec6so1736553c88.1
        for <patches@lists.linux.dev>; Fri, 13 Nov 2026 11:49:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794599378; x=1795204178; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=J4rSsefiHQznT/qIvnLX1QXXlawJ9C84nNyE3ha35so=;
        b=LHRy9MZ4nnPGbghOTtx0WZaKzWw5B8RMmXYysS1kAWWuJ41Gz1oAkSBWU1/CKwwUDa
         U8V1DGnEiKwwAyht/sBSjLQSn9yP9xJhpeIPE/K5Gqy9e7aRaUShcUBvxd7FLfkjl+k4
         ZQxfKAtTRqo2QJX591CGG2viuhtLK+xdhD0EvVACKUy7iybNrcId5D+LRkcgOjkWSUj0
         6bk4ZaO/VAxAR7mV2FQ4JrGz6FhnK9ARlKh5IvgluodoWUQiRRM4Iqxib3VB+o6zkoAN
         qJMZNvOBav0Nuba+esB45CdHgyOCWtyb5WNKtqMre79NAM4DJnQu+DsODJrpIqRvsBac
         pYqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794599378; x=1795204178;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=J4rSsefiHQznT/qIvnLX1QXXlawJ9C84nNyE3ha35so=;
        b=kaT1XeNSxHijbFv3WEmeAIxnT8HoySy6Zz0DvF3TLv3URmsB2ne9hQgxxWKlLubT37
         SWPUEKGUPMsAH+4D8pvCKpF4cUb/mrfYI2pAshfxVkJx4HwdEQhOQbw5QgOvOZR/h4u8
         aVyryvrGzm27r3qSqpFmv8Qfonn5PWBLENG4fCDaL6Vy7CGi6SneXGRn1vXBY53ufG2Z
         w+igXoJsWO8SQsMf/CoTx4hPkNQc2oXdQ1fSTVkONA1Vg2EIbtMAuwYHBOx6K2rHGY8q
         zZagvL6pfmKoV3vD23qczsRLoB6zG3zP8N6LuwG8dKtaKTxwn/aJ2R8MV/slwGDWL77g
         2OBQ==
X-Gm-Message-State: APuU4Z8qPq5M1a7hBB09iJBYjAqBt5J2LTx2V47eXVbiVPFEm7est6Z6
	9QNqlUPPjzYZ6dI/ZpVPA9Geen0mR/KFNbfEjDPLRRq1nBlifxYdPwFk
X-Gm-Gg: AYBFou0BpRfX1FEZrGVplG+Xn9e36pEjsLUyBqfKMznIo3rYNKSQL1Uv7NFFElJ+E+N
	TQdJMCqDQN5f8oHAB5jN1oKZe7pGNbhmcSKXD3Y2+JTwLIRF5/9CjR7zoiEdVjEi9FsRC8Al4U2
	W08FDNdmWPwGQujPjCrWPqszuQMV3fbv+jROo8PyR3N64+Ven+C+d9syrIYBCnnkHUb7YFrtynv
	8k4TFjlXIEMkzH7GeSlnGO4awXuStpi4xuFDMzu70fd+Ps4vpjI+SSxOdQem/UdaaZ2JqKAgSmo
	bjQpqCf2Y8IFHPTMauQQwMQWUGnezFqStIsC8yEP6JRFfeepjeoRO1ejKgT0h/d6tlt0v8pfKaT
	F3B/aXZJdGRGOwSOmA/rYvs7TZC3SqdisEuj6fZcXI9QYdJCEl4dOeRXozR6EdnPD31Y/zRWuqL
	SZHxlndwStIAh/ESQ60u9ONAGZDzqC6TRs6uvhUPCH47YCx4mG65QUrwBLbP6+cnYY+XRrvywk3
	VZxAAFONnXHBRWY1PdUY1ZLZPLtP2Cvb7gUM3TTGiwwi3+2u5L/i6gZtYJ7LYA3HQLQD5LluhlQ
	hTOcQAHlT507aFAAGdYF9v7fxwwK3fi71e9ImbTkE3qfOP/ay7AHQAt5
X-Received: by 2002:a05:7022:1205:b0:138:30b1:4c00 with SMTP id a92af1059eb24-1b5030681c1mr3144140c88.3.1794599377651;
        Fri, 13 Nov 2026 11:49:37 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b50316d9c2sm8290085c88.7.2026.11.13.11.49.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2026 11:49:36 -0800 (PST)
Message-ID: <79c5c501-9619-4d8b-8f95-c4e364331db4@gmail.com>
Date: Fri, 13 Nov 2026 11:49:34 -0800
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
Subject: Re: [PATCH 6.18 000/686] 6.18.64-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261113153820.902362109@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/13/26 07:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.64 release.
> There are 686 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Nov 2026 15:36:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.64-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
