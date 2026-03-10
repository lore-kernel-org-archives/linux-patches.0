Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E9F2F9984
	for <patches@lists.linux.dev>; Tue, 10 Mar 2026 18:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773167564; cv=pass; b=KS0DfEE1A85AqUBmxSB+4Tp2S2OsrS2e55ukU+yybeqbUNGgveZ5uuxw2PKbCZInhrVno3d5DO8u1WFMFFgsm6EurN5jNeYtvJEmAO2RZtTddxpT+x5BL4nCUeT5U4kM5pVL169cUkzxtVgZLfekK68y5YdOvmSO13byJ0nyw/Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773167564; c=relaxed/simple;
	bh=QxOhPlnUOuK3QwdNv3ft4dB/+yyWxAMuJNP/nIf7nLM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QvUCqUAQKvIMDJrEE1bF9TtKS6Uhpls0iM8B6o1W2xVJjQdUOCHA4vLmOppM1TB9LHQlGIBwpM6hVmUSCinnwZICK+KF2psXL6SznVhgBd+xcYh6AsYYEhEHh5tVGE4opetiK/NFspFw57roZCtDysPqzkgfApgdpQYVJ9tmqXc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=fu9PbuJN; arc=pass smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="fu9PbuJN"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b94358796a1so622984566b.2
        for <patches@lists.linux.dev>; Tue, 10 Mar 2026 11:32:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773167561; cv=none;
        d=google.com; s=arc-20240605;
        b=DJrlkHFqOM/ep4WiVL4LY+kNio19waqkRstCbYLFo5AvIhJwsTHfIfrHPKp1qcB7Ne
         fdmZTaSEVI/Uea+o1s1XMviGAoFTcd0yBslS0SBTRwlQ2wtPBacu0/qugnT3CquUs9t0
         RpAccysrsgru7zmQC3WCM9rMaoAbbsu5PmQhysLKC4K0gSUIA/+0iskGCSuwPCnBZ7Po
         W3ZNpD8xY7jMqbLqa/tEBCSMT3AdcIlIWFOfXk9dZ9CNCR39kzF8cR/Sc7EKxvhbMJoR
         c6v5y6BpfWfyDj77WUQFS7Lnp0HtPdla0LCJv3Y1DiFrBZrSTX3teOFNZZ+EWi2Nr66c
         lF/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=mbo0dPoMaaSWkMG5s+u6BGZf/LQYpArCpui3vZDgH9I=;
        fh=YibR8vDPFvq0pMM6jV60JAJueo3Z7aAgf6SVB2MHO+M=;
        b=AIDqb69TldyzH9Jcn0N0GYxl6RMu6XoW7cweUrkc2CvOosv2tCAAwc6suq+fVy/EUZ
         OzuOuniLi/FSBtASxASHt0YeR4SMS61m6r5LPCI0Uueyum08s4DQD0YajB1eqXLfyvd6
         +3DAYstzgDcFIQ55CT16NZG98lND+oOT6bTRLZAJL/3WNCmKTbPUaj8FVz7jKUAyOfdT
         n5L2loz+YTbn9XF0Ei6p+JvVWSmluTpBnrfH0/slUALXBo+HnxQVhY54a9rAYXWQfmOI
         RE3zTbDDCF9tIjwpsmDjQjBa4HaKBRalkwqxl2+qu0ZJF1TE7Z7CkbxOLyhNPs4j5Avh
         TcqQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1773167561; x=1773772361; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mbo0dPoMaaSWkMG5s+u6BGZf/LQYpArCpui3vZDgH9I=;
        b=fu9PbuJNpKPjwM8+wA8dfRJSzRsmmdceXwPnT1ws76gmvR82ogteMhmMaqVHtnEQkY
         48xEYydMcfXgT3tuDnYH6NBgz05Rkk++VX80M/C52OcxxsgV7FkzxDSFb5szYbAGt02U
         40vb1p9rYFlqEetPJxrfhjwzmJpKDxGZxPPQV+qypJlu3rTl2oKth37f7vtsIpViAbWD
         op6yuOr8frNpugNvGVXVHFhZLeFlx+F11E2XI0xn0UCf3fT/vjJHuN9hpS/tvaaE9RKP
         JA+VeehG89680YIcCTxO6qxj0ReYlcSDMUsVMpbCpeIraSzg5+Efikm5C6+tQ85pUAkd
         OAhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773167561; x=1773772361;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mbo0dPoMaaSWkMG5s+u6BGZf/LQYpArCpui3vZDgH9I=;
        b=Q4rq5XA01MoOoBQKuxtQmafh9UjUBsa4ITrbyvaSSNaIp4FsuEiFmS2Zq0/PP5gj9U
         jrzubb9iGTbogxcCIk8hZTfXz29fX/3MjnWUwYufm0AP/wXKawg61tbbp0UU4kYf2x6O
         +57emktQjRq7g81IBVFkzmPJ+u7c0DGcV57exwZVNiPjqlI28u7WrYAQHewZCyvnHeSj
         JMEVJCDP9TvOKG5slujOOhbDUfZtcQeBypKKAyZ8je3ZVJ2ZDb/Wp5knu8Wo1FrrdGEh
         B0T4LuRMeUrpjlZgKxSN3XWhkCdCqt1i+X+O34eE1Xdlll23G8X3cyD/bFqzEThTKbWo
         hMXQ==
X-Forwarded-Encrypted: i=1; AJvYcCVZmWtOI+tpGEVg5qimKsQ/2frOi1PeWb+FJwHNjMfGxfNY6cigHJHLf/k9sxOudgkivPZAXjWE@lists.linux.dev
X-Gm-Message-State: AOJu0YzYLT1M8X3gikXxawrRGmZjC3qDTMiEmvihR9gBCbxXhOpIRFSb
	RVFLAFFgrP7Lh3IWTTaaD6vkL4XZGZPJ/Mo1Z2jO0XmMta2NZy2FdBiqPRoyTCS+1EiIg/z339f
	4i1Zu9qv4bD1GY9dpwF7QquH26g5R34Zp7/ZadgLwAg==
X-Gm-Gg: ATEYQzwVoJk3phTFUvU5vjrc7lBEwIWX/jhYN/FOSye7fAx+aTl/HqYOmsRM7lCOazD
	g+zTdTzs1Qi4YYZOnUrQH+q+uiaKpDA0OlP2hT2MghUoDXQYv9+psEr4hQnXML+q5NDRs2tIdj5
	/6JoYZHEWtYk2K00nGwejozaNBIZpmO5FmioR9dUPhJAx03rWmrN4Sy7LHnPFkQyZxENzLGTvvR
	BPGYTK/LfjYHlRlG8z5eRi9Hvfl7WgUZDzGJawNlD44XL9LwJC1XJKeB4jvtEAb+sDCZQ+6N5IJ
	XEqK5EsioRMWOsejg+lWs8UkjuQAxeMLGv68yNY2b8DBitH+MVs6XKhSjuYxg6o92sjZTw==
X-Received: by 2002:a17:907:97cc:b0:b94:1722:fe4c with SMTP id
 a640c23a62f3a-b942e0b51aamr858980666b.33.1773167561195; Tue, 10 Mar 2026
 11:32:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1773141554.git.sashal@kernel.org>
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Wed, 11 Mar 2026 00:02:04 +0530
X-Gm-Features: AaiRm50wJbO78u3xD_IDjgs0AvrnuKVl9tfImWNR0N2-rU_nei9UoqVAU1J6em0
Message-ID: <CAG=yYwnHhuWoszJrQzjVdsQ8jOnynO98O_KyTZGXyN-Z5TNY4g@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/314] 6.18.17-rc1 review
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	gregkh@linuxfoundation.org, patches@lists.linux.dev, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org, 
	sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"

hello,

 Compiled and booted  6.18.17-rc1+
No new typical dmesg regressions
.

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>


--
software engineer
rajagiri school of engineering and technology-
