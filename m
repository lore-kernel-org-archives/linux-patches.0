Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600603451A6
	for <patches@lists.linux.dev>; Tue,  2 Sep 2025 17:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756835356; cv=none; b=ExmCAPmIm/z1Ty26FMd0xLEwRT8OHFIiCqJ3aIhPz7x1NXIDgR5i27K9sLR3ZZDaj365kDCQWGDs8RM4gb7+X0aBJOvN3QGiyHSKz7cltLZbeq2db6GijX/rTaMwQjEPEQ57lUW4PSk1AKGXbFkXF8BQrVHwcvN1rdi1qhA8s6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756835356; c=relaxed/simple;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G/p+6yohcMT/2svMRCV+q2fp0//lt+H1Z6d7X6FpZMHut1XD1f0XBIOelgKxiakSkGmFRZvtUErsiHZPr/fLaJW3G1rbUZP80urElmeSNNBYPCleBTJEhJthk1uUM9aRY5emk2Q4dPnNUb1jpuwE5txcIrWI2vbL55rSnwfWGow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=hMpau7uh; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="hMpau7uh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1756835309; x=1757440109; i=rwarsow@gmx.de;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=hMpau7uhJ+cImsmAkPK+JpjUgoKoRHcdx1cuQk/kx7k8XK0avez2AFoURxdOP2Zr
	 UBaKvjta1EB3wqwnAoHHYHRBGRmDxBSVxj52BDSYpwvZkKnC2RW2yrm5AU0BsuCQ4
	 W2ge/jrNXN/Uv1AFFzUl6Txv8jPtSRRFiGLgbBydb6PRxBDgqUsjcJy0lEnXOcfKl
	 vdva1Zbzxz6kmzc5BpvfS5JNM3TwFoPZ01C4bCUOepg4hr+Z5TvmpamVivO7j+WQm
	 AwdLfjiGzAkdO+Jaqkq/rb/8WpCXLMSuDjGFPYeHW/ZgqFhUpBiIonCNeDnWNlzZX
	 CZ5Lpjbb5sQX4q1j+Q==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.34.249]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1N0X8o-1uWcY43dYK-015N7Q; Tue, 02
 Sep 2025 19:48:28 +0200
Message-ID: <06ecd35d-523f-4827-b456-5504a91e8553@gmx.de>
Date: Tue, 2 Sep 2025 19:48:27 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.16 000/142] 6.16.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250902131948.154194162@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:xPgOoSX50QuD7Pn1cXh8cUnDXCfZGAhTa1E0oWetZ6lNv3ExWVy
 ZSFOxARoS1GqbkTDP+InvHemGPb2OX/Mz3noctMyQ29kpynq+Q8CSDoJcz1C6zHaamdVAtd
 BiGkJSgrsHVgjCQ//wOAiEVDFPbavz1MXEnOjWRXocbCn+Sa7i2f2Dg4cQ9cK7DMFvHZwcJ
 B0jfhbTkKxs5C90XdI/FQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:GC5lMw3ggOY=;9pKy5BJU7VTN59nETNXtnRh6f0j
 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

Hi

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

