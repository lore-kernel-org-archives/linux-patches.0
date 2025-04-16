Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE08D946F
	for <patches@lists.linux.dev>; Wed, 16 Apr 2025 22:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744841115; cv=none; b=NFvuSpOvYjHrjMddSZItF5DuGFeDbQJP0HwTDsbzRyIkh9ypQ+gTBREcw2FQmq7Y1LhD9jzPGw4I8+Jx4PBon5NW3iZ3Z7s/eIV7t8qaYkGq0OOFn+70KFxFYqeFym7VvQfsGlRqgeuGbOx/BuOa3kaHyuq2x9tAd/3+LMVC+MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744841115; c=relaxed/simple;
	bh=qCD1vFXSI3zBOXBAJ1SOeNHV87e7EHRpPPWphDyj5AM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D7bdJKxo7LGF4T4upPcoV6Aq4+r1ji5lz4+G68V4LCON4SlwYYzHd4vE+KF2mEzkgpJD4qRtSlC3v7ye0OqsXIDwrjbF8/Fq+onTtgQGyPOpSHioUJSFVngf7p31HAxWp3c+zdk601uPfNxaRW2miCx0Zg7y8UMZVUfZqQ/YTEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GHFOX2nY; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GHFOX2nY"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3913d129c1aso105194f8f.0
        for <patches@lists.linux.dev>; Wed, 16 Apr 2025 15:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744841105; x=1745445905; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oHayVKFFsJNmr2sjJkndFwEOAkhvbxML2QrMhdj9R5Y=;
        b=GHFOX2nYJHIFGlYgfAb/vF6dtkews205121vkKSKK5/xU62I76hDj5V5ytixAX/F4p
         mepZsjgIbdijLJvhYHoaXIOrOj4URRPvvxFktnh9Dizt6Cpxnlc7ETlPQCh8+tthVWlJ
         cuut5dBJoCeD+Qfl3QnOyTTBgvTdNb+9B3U6a/wJfyWdRT3s1JMPheNUFI6cUpWYSN8R
         fDIWKFLxQOwhBmQy1dWGapB1SFB5QFv1EAmAq02mPicRV1TxESMGmNRfKkd/713U0sw7
         dtrr5s6Di1yt2h3x11c9+h9INA3Hl0zi1n1HYSH6UgK1Ly/uZsdfq1hbKey0C6iyh1mW
         +oiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744841105; x=1745445905;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oHayVKFFsJNmr2sjJkndFwEOAkhvbxML2QrMhdj9R5Y=;
        b=QVQ0J/xJNDQnuSAF9rVTFYOo7kg6VuEMOdLW7bmsSPNuIi3E2lWyBG3Derl5hbhnVz
         pBfcR/1N/t0S2YcJnmhXsJyqgrfVA3f2loYe033JTYxbH65jMRH6Tj7CWkTG43RJmjuW
         MectfnRurzpheKRXlerS/3p5N2tw2I9ILdOLb0ekRUwAjiEApaGlIoo1Q2+ARyaBHpjM
         XgD2CjPIXpC99VNtFYFT7jEv24yDxLNVg0sDctKdWQbNs4xrBKU5/OqEr7MzkeGara/4
         pLVud9OSus2tx1g4WwJCYS15deLmuumzP2aPfInwSSxyg0FjJjqOMzqiZGEZ1JYV52nd
         Wa5A==
X-Forwarded-Encrypted: i=1; AJvYcCWWSph9SyRjJFGuQYTbcvoGz0ccHXXjbT55lRjsOsLyxT65wpGoUZAnw0CAEnxELE6B+RtoE0Eg@lists.linux.dev
X-Gm-Message-State: AOJu0YwgjChm3c5EJqxOohln+UntWM9pzu6IOb4zh7VmPk6OjEhrQWPH
	i9Glf+OlbaRbUS/YVzd6NEaPwhunQean8aADYYgu8eo7JBYn235E
X-Gm-Gg: ASbGncvQundAeaDVfqD6T7ZmErbzsukB1Mk92Fw4iZC8rEX447qXCNz/cNbnpy6QEWl
	WJ8DYvyVFlyS/q4/rjJ7Vtd5LhpnKYToDNjibCLpYM8NNsQruu+VuBSTQhk3FRiuioI3Pl3Uxhn
	atBn1nz4FNVX4SSdcst2w0TAH2i1q4lhhbNMnIzf9e3+Y1952GRykLvg+aTCVulGXs2gAEoFtc/
	9A/eZLbOADzqTjv27uQMr3a2kae59MiJM0CEuWVpyChiO2zBMc+tYCF9XVpHisgqsOtMhWRlbXL
	eubAnybxjoR1YgavBV2ZxWMsxJlBCe3zvFgZP7Amrz/yMnNw9Y/0sw==
X-Google-Smtp-Source: AGHT+IGC46S4S5h4Q5ailbC5feqlplYAzWogcdOjZfAGKxveTGmXYrJirUpLbhifwMOyo43pOFOhPw==
X-Received: by 2002:a05:6000:2509:b0:38d:ba8e:7327 with SMTP id ffacd0b85a97d-39eea37a7b1mr334295f8f.8.1744841105179;
        Wed, 16 Apr 2025 15:05:05 -0700 (PDT)
Received: from ?IPV6:2001:871:22a:99c5::1ad1? ([2001:871:22a:99c5::1ad1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39eaf43ce3bsm18546012f8f.66.2025.04.16.15.05.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Apr 2025 15:05:04 -0700 (PDT)
Message-ID: <f801975c-a796-417c-a7b2-be493b32068f@gmail.com>
Date: Thu, 17 Apr 2025 00:05:01 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] drm/panic: use `///` for private items too
To: Miguel Ojeda <ojeda@kernel.org>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Alex Gaynor <alex.gaynor@gmail.com>, Jocelyn Falempe <jfalempe@redhat.com>
Cc: dri-devel@lists.freedesktop.org, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>,
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <20250416122106.2554208-1-ojeda@kernel.org>
Content-Language: en-US, de-DE
From: Christian Schrefl <chrisi.schrefl@gmail.com>
In-Reply-To: <20250416122106.2554208-1-ojeda@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 16.04.25 2:21 PM, Miguel Ojeda wrote:
> `///` should still be used for private items [1]. Some of the items in
> this file do so already, so do it for a few other clear candidates in
> the file.
> 
> Link: https://lore.kernel.org/rust-for-linux/20250416112454.2503872-1-ojeda@kernel.org/ [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
> Not sure if you would consider it a fix, but please feel free to add Fixes: etc.
> if so. Thanks!
> 

Reviewed-by: Christian Schrefl <chrisi.schrefl@gmail.com>
