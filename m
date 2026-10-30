Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793366967;
	b=D/9lu8MgyTRK6qliipF/xWyEo63j2VkjqGsG25o9XeB11t+ljauCuj9CwtpJBLbLhEIk
	 WeSRQkmkY3A8Gjy63q3Q9A92rtqiaAovvCZJQUsGCFzDsJDlTYBOPn8I9v4RvrHtz1282
	 HQjfQvX2DbMS6KUdtPxLAlqCSLP8idY3PpkW9W6UWZb+hKzC/WK4n2uUTYeRVK9LNh/Di
	 qyWUA1CPvGEYv7c2aQ2od3DM2pev5/vewWaFBrf/BSIStNH52ViHHeKARdz/XLkN3ngKu
	 TThZ+L1vLkhj5RMwnVGs3jQo3fDsS5s10k9uzNcBhzVtFYmst2fZ8FsEpBbqjecYKIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793366967;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=c4GhHQfOETP0JBoD1YsAYRSKnFxUsVlKKFwgPkGlhAU=;
	b=dNoHQ/LxbbPk5hVVV86xz1tSY19uzEqYrozc0dT5PkcrJ9mvSViFIEX0jDjqAPwUIhVJ
	 GBzBGiefJSOduTS7VK3xL2y1iNJ0ePXV4/g1l1Z94sbs3ZYhUFWng8hyTUjR1liQnPMXK
	 mOzJgUKSnywJHsdiOyp7RpohkunXh5rr29bnR0CdYu3/VbJvbhTthFR4sR43g/HRGSLzr
	 y0XYcBueZ2a0oQ+RgapEr5oBagq0CKNhdGqJ1+I+lQzAfGa7tCV68JVVma5JT7ovsCBtY
	 LsVYRePFpcPVhnhLD0DA0JCREqRNy5Oe5rnA50hmLPxrRBo/XnY9FgzHz9ogvv1RB8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=MrtFnXB7;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776AC606A31C
	for <patches@lists.linux.dev>; Fri, 30 Oct 2026 13:29:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 776AC606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=MrtFnXB7
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a4d7ae1ae9so6362415e9.1
        for <patches@lists.linux.dev>; Fri, 30 Oct 2026 06:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1793366960; x=1793971760; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=c4GhHQfOETP0JBoD1YsAYRSKnFxUsVlKKFwgPkGlhAU=;
        b=MrtFnXB7y7cyz0NOP24R2fwrs7migNDvGs5pSfUfYduZ5K3W3GobIvsTFc8TCz+vqm
         i8stQhj9VdiiebQudmpX8D2ldOzwWnebclTUvsiDHBP8bkRzloX0SwrWdCjdGOAvAB2r
         vL1lgHZAh9nRieQyEsq5NqQG6b5lUJLGBBeOqq4bNQ0wOR8kaMnnGGXnEDvkAgg4B6S/
         Rn61rCbkMKMthY9Krd3XJxlBOSJ61bOpl5ub7ByjEXyka9kwiPrkM508IoH8h/ugJS5s
         7JE3WjzhTEUTEgkbleVAmr6njOoxJOwnnVlyJkAaWvIek63ctEew+VygcJgZUA3lZgpu
         Nlqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793366960; x=1793971760;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c4GhHQfOETP0JBoD1YsAYRSKnFxUsVlKKFwgPkGlhAU=;
        b=I6rUgUF+thPlIg5SwpqTcWcmGLz5isrSf1i3n74S91lmrz8kPaLukNIZilAspeGstq
         Z02nKXgCxU9i/dAdLun8Xh1kNI9MDuyrW/TLjKLfTYP9Jcb89sv+PrexI2+Bn/cy54qB
         ZKd4tgKTSZ223ZpBrCwWmukvd/vXdq/1iIcwJOKPRYyLMlR/bScK3iugGN7cCm6LHncG
         Z3rdwnCFwo96ew3gtCXA7W2p+koz025+OkibGJUOlrTUCbnUgNJW+fIp3H4OmQNqJYJY
         ibr1UYwfG+CY/ccXRoS+zUDg8i7VDXzXeNCtSTS46yqbqs1vrTiEOJMWUcrrSUPgJRPA
         q5zA==
X-Forwarded-Encrypted: i=1; AKwUvBwp5+m3BBTNHgsNWIysBPyd9J6NeXeNrZZu1Mf64Fxcj15MM86vdhXOxri1v8eW9o3/26rr02N+@lists.linux.dev
X-Gm-Message-State: AFq9FYKpw/eOkCujEDVQPXTINoNlQt5uYSWwfZjiCaculQyK4P4PIE3x
	Ya8ggChQT1e1+Gu2zWFod9YI4IaPTVk2qdoOwRSoxMO/ENQW/FRWFMISf9fYrPGm06w=
X-Gm-Gg: AYBFou3UqZEv+bnbNspSbvZfbgrgZSdm8fsebORb8OWWQw77Dnb6EYjrSTvzfCpRSx6
	YEnmLEAdnDbds1L0g7TrpgBdeA5NKX5FuA089mlYpH00u8hXq/bbKb2qRbRajKh82g8LI/MPXnG
	W66WN60L75ONORaMkzSoOdHbCixNHwJXxGzZUzT1Y20RhMAtLdf1XpJEkRB4w89rcySZTEYsyj3
	qW618epe5oIkKYRF5o3QLzwRdMxJtbOG97dcr2UDV3fQzO6Fsiw11MPilaxxEs0/90sP4IPdsKb
	k9n5f8jwLKdvyQKDHd1l4mMX1CfADFfERwaLd7t2oepQkx7+mKWr9vfYx1o75FnscxzVMMesnoz
	rxPrIOGILj3Do5m2IGWbZ6MDWurOf5sny6e5TcfTKg7VuHGrOGaOjpnlLrCz0Gl6B47wgvKDqgH
	iI58OEtQ7LyR+s0t6BMx1bGD58SxQ2OrhJes/GhXvIRQDV/6ensiCQHogSrlOI3w0V2WHm3L/TE
	3DGMqJ+0xuGym8cCYiLxKQiTm/a0/1aH+OQuJjP9O4Fkvud09hes6Ie+WdFfhUPWACREq8XbbbD
	mwTqwJrYFQQ2gwLdqDj0O0cBh2BFzSQpMjD/9g==
X-Received: by 2002:a05:600c:1c0f:b0:4a1:ac66:6059 with SMTP id 5b1f17b1804b1-4ac19233381mr48752555e9.26.1793366959078;
        Fri, 30 Oct 2026 06:29:19 -0700 (PDT)
Received: from localhost ([208.127.45.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abebe33e79sm45074465e9.2.2026.10.30.06.29.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 06:29:18 -0700 (PDT)
Date: Fri, 30 Oct 2026 14:29:14 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>, 
	Alexey Kardashevskiy <aik@amd.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Steven Price <steven.price@arm.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Jonathan Cameron <jic23@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, patches@lists.linux.dev
Subject: Re: [RFC PATCH v1 01/11] attestation: Restrict inherited operations
 per instance
Message-ID: <auSa4z54poQuahuA@FV6GYCPJ69>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-2-aneesh.kumar@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028152618.1356860-2-aneesh.kumar@kernel.org>

Wed, Oct 28, 2026 at 04:26:08PM +0100, aneesh.kumar@kernel.org wrote:


[...]


>+Per-instance features
>+=====================
>+
>+A provider descriptor describes the maximum capabilities of its instances.
>+A child family may restrict evidence retrieval, verifier verdicts, TDISP or
>+trust-state reporting and RUN through ``attestation_features_set_locked()``.
>+The features must be a subset of the descriptor. Verdicts require evidence;
>+RUN additionally requires verdicts and at least one native state reporter.
>+Providers that do not restrict their features keep the descriptor's defaults.

This is already covered by CTLV op enable/disable helpers. Why exactly
do you need to duplicate this in features? I believe they should be
fixed.

[..]

