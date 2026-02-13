Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1705F3624C1
	for <patches@lists.linux.dev>; Fri, 13 Feb 2026 17:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771002686; cv=none; b=ieSK71G2uJAYLReRMqPzhvgoK5PvXW2UcWJfwLAPT2yzDbGQR8PiJAGwf4G7oBtLXOuSCJjd+hClodzx/jLua6Lg2erHQaM9mbiFKw9J8Vp2Q+IoumT/N9I331V4/UqDdvAQWChPHTO2p5mPXZfqg1CfVJwm6kmpvoYWWofinzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771002686; c=relaxed/simple;
	bh=gl4PEukzUchS9MtHb7r8yq3pzUDHwXAMVaf8FCswoYg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SuaRPCO8LKVCfCWcSuRfxjOsjsJzyZBE7XqS7ZocmxJQCfCm4uEvccciPqScptMs5+mbLI78InCKoamcwlPEUtxTZF2TfK+nEhTJCd7PHm9AkSG8B5KqlGkQOMKbpZNowFwSpl+7mGp9rfEA/mCrPcYXo4cvPprBoydl+hb2Oxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=lWgcSWkB; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="lWgcSWkB"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4362197d174so799472f8f.3
        for <patches@lists.linux.dev>; Fri, 13 Feb 2026 09:11:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1771002683; x=1771607483; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IELCj+juPsgvOxizJdp9L9Ol4icmAH75LT40uFXWvW8=;
        b=lWgcSWkBQPnFPX3eVvQqKH14Tf7GfJ0k8GlN+irtfepTudiI8Vrtwt/Sgqe1tbzW7T
         tfxaiDPQxPQxyPMDRrvF7j3Q/RbNELaVlwiCXDwisaPYVAu0eGMPhRS+Hho8CA0SaHFE
         uUlm7On5OqPDAl7HnbCRI5PjHi/HXwqwUU0udgy7eWMUJYFEYLromOD60SiqciNJvt8v
         xU7rS5HBVzgBbzGrwbnJBx/g8k+bp/UxLSfM7iItsZUvaiFNUjkAzs5CNo/eJLNFrCaZ
         aJMr9NnLtVB4J7TGSYuedAz4u2ICTJU2KKCH8IrfG0ZQN60UYAOdNr+c+lQz6XWbdHhJ
         U+wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771002683; x=1771607483;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IELCj+juPsgvOxizJdp9L9Ol4icmAH75LT40uFXWvW8=;
        b=B0z7UF/JZSIRHs0OaqOLsPphZNUxoKRJlC6JBCkUYehZaZWPOGzzEjGuzk3H0Cncnm
         IgPjfEZSmYDCli1TlTlMF1GfM8ZTGc9Z7DPV7pTHW7CKTi5mOVoz1r8xZshRuq2gr2w1
         vlcqhZLx0Zrlf1sYNq2uQmkohT3Ju0QU1uZerNCduVD0wyMwh7KJQSE2ZJzKKltzeSgv
         WCgcQoxCLshUkbOKR36TR0fGQ+Gggigzf6Oyy8b0wO9ljV8xVu0Chdy5hU2MoHIMlZvw
         J1FOSzmsWbZhNLLrMijkBMBqjCw7RiHydgLdBR5RDYznKTjHF7trv+2FBp6sT+FCLIT8
         D2VA==
X-Gm-Message-State: AOJu0Yxb47qQxrivpakiAFYOxEa9OJG6lj8Rx/zg63xJo7TRx5wM1RG/
	tJdFSTJTG5KpqDtc60tUxiF2Aria5r8cccoogiKmlhJlKi82l6ZMl0I=
X-Gm-Gg: AZuq6aJnOpvjbOXntu56Hlt2xwIssJMr9+YGT7mUSAvQ3b3IPRG8Z90f221DWgG95HC
	wN/jD95jJUwrQrpWwFctq7yN+jYgDmD8h1Ul0Anh84K/VdKqn1bQF5FwT8aw/7W6wDbTPizWvOs
	zqNSizdzWsdNNt+8RQU3dMa2QISoMRnxY6PUA1L+4mFTq/D/8F3JBoqePQZpLH+n09f/vcfEj82
	CR7Z1LrD0+0flRE6hOc7CDjQl3bk4q3Ke1ovKn9BRHVDUUgjvzcHk2Srk5lyEwXYJmFmCdHGv1g
	crLmKfjkkGqaJjK+6Q93V8HfBp4CY6daGq5PwKtJiiSa3Gsp9UYttNIeHTXxkqfShpKKabA3Lmn
	1tF7CTlGBPxchVBq40fsiOpEjReNOM7+ztDABosImT2KeXodfUmVcRIevHlfZ+oZVqK1OVPlN3i
	VDobaC+8WPKq6/moxWMRRk8j+L4d9Z2U432T3ikpEN+YwI97UOwkJ1QwAvH3//OmO5qxekcxMM3
	6tE
X-Received: by 2002:a05:6000:24c4:b0:435:94dc:8c78 with SMTP id ffacd0b85a97d-4379790e785mr5171308f8f.40.1771002683292;
        Fri, 13 Feb 2026 09:11:23 -0800 (PST)
Received: from [192.168.1.3] (p5b2ac4a9.dip0.t-ipconnect.de. [91.42.196.169])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796a5ac87sm7738189f8f.3.2026.02.13.09.11.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Feb 2026 09:11:23 -0800 (PST)
Message-ID: <d568f5d5-6e4f-456f-8828-55e24f359169@googlemail.com>
Date: Fri, 13 Feb 2026 18:11:22 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 00/49] 6.18.11-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260213134708.885500854@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260213134708.885500854@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 13.02.2026 um 14:47 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.11 release.
> There are 49 patches in this series, all will be posted as a response
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
