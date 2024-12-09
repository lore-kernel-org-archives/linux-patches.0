Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF65819DF44
	for <patches@lists.linux.dev>; Mon,  9 Dec 2024 23:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733785521; cv=none; b=NhwWnxNCzp3l3Po4NhzRTvQMDiR1uksIVtLXXRUXJzakkMohnOCYIh9vLLOBqmjU+/nxUmHZsJuQ+w1tIX2HQb/UoKFeUHq98jPWI9edB9kSPhEuEWjWM1/MBz//IGh1art45RK6NJe0zQkgC/lVislyU/nDA/BGTL5Y0z0Hk0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733785521; c=relaxed/simple;
	bh=E2wMVt4XnzSAoCFwFJpocVejZtumHBk9+rnpvzMGxW4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qzTWV2lzJZbSkHXOQ/r6uh8ZQhjE6G1J1UwcmtbVtWWklcRc/uJTtCFXecAtaoFnPapvAYCK6gMhR/6x9zaOQyvsi+/lyNqP4w11ZXanbEwth2HgVmLxuZ9Jl0rcY1ipAQJR9wAK0GP2UKkOnzfxVH317du6QwwojpP0gyBDmF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XsUHZkPk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XsUHZkPk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733785517;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rtXPjJ/UW99vVDZpFTpb2RZPeH7PKMqMj5zaKL4gx1k=;
	b=XsUHZkPkjVLnVvLDz6Y1u2pq9PuQF2sAqPtt40rAuYyNtZ61oMwb2Y3olADWjcpOIx2LEp
	7SwpgUgO7l5mIDdniI2eFpYqFvF2nFIzRAkjtcuNq8ZAHjdnM1SDjHy6/RpAKqaT2KeD27
	C0ec3rHUmBBRjhHSWrZu1eTNNpGLvSI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-391-gnVx2hZHPbu3h50or3S6lw-1; Mon, 09 Dec 2024 18:05:16 -0500
X-MC-Unique: gnVx2hZHPbu3h50or3S6lw-1
X-Mimecast-MFC-AGG-ID: gnVx2hZHPbu3h50or3S6lw
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-434e8beee61so12529315e9.0
        for <patches@lists.linux.dev>; Mon, 09 Dec 2024 15:05:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733785515; x=1734390315;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rtXPjJ/UW99vVDZpFTpb2RZPeH7PKMqMj5zaKL4gx1k=;
        b=RBdaD2jUGgnWlZJDvtvle6ogDLnCNSFzjDZiD4gJtT1qK2hzMJs5pd2Tb6DiVrFOWe
         9D9ZseKZcaFjGj85WJA5HexEVes5DS8pUXu9OSZ/M2EMB4JW2JRc1dbuGsLMfr0R/ass
         Xoz3YmTytTLI8YoK19p7Zn2/lTBQd/s4ACEC2UJ59U/SVBhkeh1/dJtcE1Jaj49iaMK0
         nQzUh/gGwtA5efiisuDBh9i+k2/WhaHiLrptwW6Z8bnI6+M/sifNhVgMVqekIv9/uz8Q
         +ciiz/RSmOngwxlCNg4F7sW36c/ZEoVOoa/ennHgOQDSCBm/DKQ3uAcDVhvsoALFVG+p
         5tiw==
X-Forwarded-Encrypted: i=1; AJvYcCUvMu60YcEV96vSqXW4CLGl6db9FsOfodtVRBCLbFio3omfxMY/Z/mK4iaV29uLBJfzbC962aqw@lists.linux.dev
X-Gm-Message-State: AOJu0YyVf+ZGGxdVZjVwDhOcQgCqF19lqXAIYHuuoNCb+T4qKt8WBGH6
	23cmaj3URXBXVLpQ2tlwQ5bWk5+JPxy5/g5woiUEa4DlKsC2VpA5BDUjyWjhdgYvZtTHEo7vhkY
	43lGIuHYhkti8wpDiH4M/brwRavX0wCFVepO92nwsYUoa8qhQwaL26CM=
X-Gm-Gg: ASbGncvhQb/HfJZ1C4fyfWRDf1WOJQZ6dzpiPqOEZxwEujGUujivDt/INcik6SQLAkd
	MgMoXw3zAoUTmkZd0NuV+NFcx7AtfC4ePHpVCDtslrV54PdOF4TIELMhvY3kvPJ1VgV8ChtmN3j
	TTs1hCzixdU+rW4NB5YGMxuUVocoLb9UZoD9LZfku3/EEYDBseyZup4nrKGBhCKtw09tByWHFwQ
	9iN4UmzmA3aFDa1zPvrH90NXYDeRD01EQXn85oM7gj9GyW6tljIA1XmH/U1t9LayzlVgs3U4scH
	rED3ELpx1PqoYHtmLg==
X-Received: by 2002:a05:600c:18a6:b0:434:ea1a:e30c with SMTP id 5b1f17b1804b1-435021d9c95mr8234775e9.13.1733785515311;
        Mon, 09 Dec 2024 15:05:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IErGKM+mO4OjrHPaFMSgaVoG1GHOIII5oaFReyZQhrk1MzggllJFKQWOp6TcUYxwWwXNWck1A==
X-Received: by 2002:a05:600c:18a6:b0:434:ea1a:e30c with SMTP id 5b1f17b1804b1-435021d9c95mr8234565e9.13.1733785514969;
        Mon, 09 Dec 2024 15:05:14 -0800 (PST)
Received: from ?IPV6:2a01:e0a:c:37e0:ced3:55bd:f454:e722? ([2a01:e0a:c:37e0:ced3:55bd:f454:e722])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38636e05568sm8337911f8f.39.2024.12.09.15.05.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Dec 2024 15:05:13 -0800 (PST)
Message-ID: <e544c1c7-8b00-46d4-8d13-1303fd88dca3@redhat.com>
Date: Tue, 10 Dec 2024 00:05:11 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] drm/panic: remove spurious empty line to clean warning
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>,
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev, stable@vger.kernel.org
References: <20241125233332.697497-1-ojeda@kernel.org>
 <fe2a253c-4b2f-4cb3-b58d-66192044555f@redhat.com>
 <CANiq72=PB=r5UV_ekNGV+yewa7tHic8Gs9RTQo=YcB-Lu_nzNQ@mail.gmail.com>
From: Jocelyn Falempe <jfalempe@redhat.com>
In-Reply-To: <CANiq72=PB=r5UV_ekNGV+yewa7tHic8Gs9RTQo=YcB-Lu_nzNQ@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wYwzN-iW3J9uQ7SRbPC6n5iE0h6LQdxNlJKq9ClKNd4_1733785515
X-Mimecast-Originator: redhat.com
Content-Language: en-US, fr
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 09/12/2024 22:05, Miguel Ojeda wrote:
> On Tue, Nov 26, 2024 at 10:04 AM Jocelyn Falempe <jfalempe@redhat.com> wrote:
>>
>> Thanks for this patch, it looks good to me.
>>
>> Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
> 
> Thanks Jocelyn. I thought DRM would pick this one -- should I pick it
> through rust-fixes?

You can merge it through rust-fixes. I have another patch [1] under 
review that touches this file, but it shouldn't conflict, as the changes 
are far from this line.

How do you test clippy, so I can check I won't introduce another warning 
with this series?

[1]: https://patchwork.freedesktop.org/series/142175/

Best regards,

> 
> Cheers,
> Miguel
> 

