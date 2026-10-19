Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792453655;
	b=y0l1QvNHKuIdh89DbmQ5rXzzTxjfrKL4MCkcb+kqB+7xghZzumuWq+zN7FMGRG2x9tAg
	 9aUX3V6fhle5D9dCYF4n9FM8yC4g+oJx75Kw7gjMRv5ysn4UoLxMdgtIN0CyxyVD2xsf2
	 WQB/GyxKz9KijzfKVsfJecSr2OO42PO/jRN9Cs1cpPIOrHBtvpGLCS4DRlWSZ+Ni3Vcs4
	 GtVmFdXoyrDsmd5BT1enFB03TVR4GxZjCgA5nTF4fF9ZV/fh512IPVBykUG04DdbJVEMx
	 ufmRu/d3FlUegh5NduVpMYok0jrpzhYMbTb0NRyPZTekdrEqs5N+tIsTNuEHhwY6D7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792453655;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=lLQd+nNRjjQK1gHuHRMSTNd9Ep3awT51rCIPEqdoOwU=;
	b=YNhwKgJ1n1Y5yb0KR1iNG86kMRIfCu8muS6rSe4dBZ+qhhXcmF8uPQPRt9PoRVIF3DI2
	 1g3lyx9gO6Nr5i1UalIxLW+OfkIyFPhogtHSQNcnureb6wrqWz4TR0kDJbrUMADaMF5PQ
	 CFUcD8YZA4pIrMKzFO2vb6XzOLCFHlLW4YnfTnayFmr0154WqYvT/+cYi9J8FKMkuGOTz
	 9MOKtrtwfJHOvryjWC51dNYcaY2i907VmYEyT4dSPLjAZBOahZlc6utd/5hje5/+xx7Hl
	 tVcZuALqbP3rIzdZKpzSDmgZerFpJKxYaJ/PcnBwXmWy9oxrNYLVQxDpJyn4Ny8FqQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linuxfoundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=KvjNA+fV;
	arc=none smtp.remote-ip=209.85.160.53
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23339606A31B
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 23:47:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 23339606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=KvjNA+fV
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-43bf9548df4so2462057fac.0
        for <patches@lists.linux.dev>; Mon, 19 Oct 2026 16:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1792453653; x=1793058453; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lLQd+nNRjjQK1gHuHRMSTNd9Ep3awT51rCIPEqdoOwU=;
        b=KvjNA+fVE5XhX/ouxH5rNdb9DF6jaKV5zpofGl/b4+0s8xw7d3OoNMKva0/+TInORt
         1CwxcQ+DQkNqQY9BOv4CzphXWIWAMt4hzy3UE/HodaEr3E3be3qcqCRENq/wKiSKXV5E
         ELYEeWyBPl4s2uw7vWXYKknMG4qd2Bk+orp80=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792453653; x=1793058453;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lLQd+nNRjjQK1gHuHRMSTNd9Ep3awT51rCIPEqdoOwU=;
        b=n8Hff90VEyT3BodQU/6kHNViqxiFhRmTnG1Y3NhDa82BA8DthliAcNnikpufRbTc61
         x9R0HOQa+Ysj6CsCgcjKPVzJRldBE8eEjV9McN9q72pM2q2r2+5jtPmPVP4FXdfvW8h3
         3RNjg0R3s2uHTAHq5CF7n8G3yKVCKCw/mbvOeHVqmNL4MqBgk+c/dl8Tt2kNlnLFIksc
         OIQuK53KoJ9GxiGmJmFgir2uFxu42BfOs4On+UKCne5HOaMXvV6UqbONGCYg6jBpJJdr
         SdlTC+E4N5UDm8CBDyFxJkV8EtcRQb2J+d6VPKJ4N5gvrtYfOq27z0INK/H4qoCjP3ep
         uYpQ==
X-Gm-Message-State: AFq9FYJcQ4CfUaktGrEzbDo0nA2KIf10Dd/D9GwfWOlPXCm3EoWGM8+/
	aDaQfuJkW23e/zbbVRt9kHPGSzseG0jQEaKvgpeI552N6OFnvjtUAdi624YnlWQYOUY=
X-Gm-Gg: AYBFou3vRWrkkMLAthIpZxDMQHkksVusq1b1lZtKGgT9Z0sxiHO0Zzr0ZbuA9V8b5We
	eMzhI1x8WQoU9PfifHeOcXvjJn6/jqtqys0BSycE7pl5FlJ2CDpeREukItHPn4qHyD33368+smF
	DzWvEm3Q6IVkDSGjvyhxLjaZnSvWyrJo4egeQEwle7Dg62XFHt0NlkLOUr5rPznFn+3N2mAlMph
	f0y3Dzo23qGm5NFErHXb9S494/AOEr6aFI1wAOTacuY/23qEsmw7uNMF4nCdMFfvEDzGmUxgCWu
	L0RUZYi9KRn+/fdoYyTHASQRJeMPhc+9kEv45wsQQ58c6AhS8MfaiX6qM8ubTsDvJxqo7AGhC12
	0lxWkz0yqz1ksHOCubxNmkRhBjVIEqQ1AICLvG/DWADQxe22VCJys6eM9D/fSYJVD4AmSZGB+cH
	+Jn2txBICBXXdy1jNK8hKcTiLxpilnx3PctieRE693pLRRKLEfGu25K4sUHD+nbwpcUg3LKdEWd
	vSOx5yEPuEV4oyC/nvToUb2SeABZGbKjLk92VxY7iWaSWoPEWetSk5PYGT6iuu5S/IBPaeq2sQn
	pyE8L+oPB7o=
X-Received: by 2002:a05:6870:6b95:b0:4a2:4c6c:c9d5 with SMTP id 586e51a60fabf-4a7575d32dcmr6867719fac.7.1792453652907;
        Mon, 19 Oct 2026 16:47:32 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4a73b2dc57dsm9724967fac.1.2026.10.19.16.47.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2026 16:47:32 -0700 (PDT)
Message-ID: <3f8954f1-7a06-4901-add5-fe81b3e0ae8f@linuxfoundation.org>
Date: Mon, 19 Oct 2026 17:47:27 -0600
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
Subject: Re: [PATCH 6.18 00/52] 6.18.58-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20261017155104.830766652@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261017155104.830766652@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/17/26 09:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.58 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 19 Oct 2026 15:50:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.58-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
