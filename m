Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 987081F0E5D
	for <patches@lists.linux.dev>; Mon,  3 Mar 2025 09:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740994937; cv=none; b=R7Pzxf/AEH7EsTExZs/6DqnmP/s9fouhkqagOZVmcHYFEE4rQG+07+W2L4tGYl09ewnYtdo5+RTlgtt9o1YthKA7prj8Z/gI4QGYnlB2QJAPxLPKBqblkAoavpUDzTgzXKpcIVVeWEQDRjPV16qgCeJSOJNC4zhB4yTnYEnGG/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740994937; c=relaxed/simple;
	bh=2KZN3ZbiL+bTV7no7mxRpvMRno5EVSR1v8XD6Lj/EcI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KdW8Y9NtzDf3+40/KEvHQKASv/WddVb5Rgo0V3JPjBANESeiLpyPWHG4RRyNaErxATPNlLl0aQHTouX9qcjhVFwUKu+rvRraWQQIZbP0X/Dcx49wlZmXg4Ch7vE8cCAyyW3FbZvmz+Qe8C0J5LtijVPMJ1gX3K5MIX4kRnwCoO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EBA9e15r; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EBA9e15r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740994934;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MBVVdo3tOVYaEl+zgFn8dQqxk+vyBv3FmhJQbHVALgc=;
	b=EBA9e15rnsoy3R0jPIV+6J1Bg6wsUJe7zmhGL7ZEKW9wgy9cg+p/vjGiaPLnUo89G8ekES
	RMlb+0Gb02rrVsQ0Eu+osHqCxsO2xf5c492ML9ioUR1Yj72fXhpf2kHSNzdklP/Q7oh862
	f0bZXiwL9wLdcYhg943eh1AORQgf6so=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-zmkd3b-jO0eG0ujeAZUFnQ-1; Mon, 03 Mar 2025 04:42:13 -0500
X-MC-Unique: zmkd3b-jO0eG0ujeAZUFnQ-1
X-Mimecast-MFC-AGG-ID: zmkd3b-jO0eG0ujeAZUFnQ_1740994932
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4388eee7073so22135085e9.0
        for <patches@lists.linux.dev>; Mon, 03 Mar 2025 01:42:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740994932; x=1741599732;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MBVVdo3tOVYaEl+zgFn8dQqxk+vyBv3FmhJQbHVALgc=;
        b=S3mg7AgD2i6iVJzNRDCLiBLI/p+Zo/CLB50Q/ukcm8nPXSXqs2nNjaZADury+rc07S
         tehnnCvDrtghnhsjaYCDz3pyFM61d2Oh3TtJKgMlX4UaWOEZZWquHibguQzLfpn4MtdW
         wy7sysuANomEqfKCCT9zWLhA6Bn8XVKfeSTMjYBxiHs5q9xa0HgcVNCES/HbwG14JX5R
         9z3CWaslNHPZkKPbwoGrEaoXnmfjrwy+B7YMOves1O01HEw2dJ+/ry6CArriMC9GmYTZ
         zq2d4Okw9KQa5O63dbkZ4glNUPn8einRtlo9YNI4KqZIvPdbQnwQMxNFN29AVAzxgDOD
         drfA==
X-Forwarded-Encrypted: i=1; AJvYcCWaIvzkUmzZ4kdj5cg3rKvia5PZMT0ly7xrqHXaIcXZfWEDNjBKId9MfE8KfG2qxequANeLpJEC@lists.linux.dev
X-Gm-Message-State: AOJu0Yxk3MQo/u3k5aAZsA/lJXONVidCtqW4TuS9/oWpoqA8NdDXAoz+
	vx+LrpHnHWjctupiC+nXtWpc0SW2I804n9Fj457o+LE5rOwaCqyJh3lFeuNGUoN9V3gF6lsD3xI
	z8w375XeTp2uHvdLzSRUT+291HEjMk/3PnxvNfH07EUqSeUshDDXEBgE=
X-Gm-Gg: ASbGncsEydqub4I+yC3gTCNxu97Qn9QFhAeftIeujN4BoYFihMPqOEfwFYyRb1ZWo1o
	w63PARYLgPc6OLo4fla0dl9qd2ttxJZgFG93v7slbT5+UvXIkX9kcUoLzb6IXChd445bBEKbjkk
	hukcHeiFiCcC7OoMwcGBY4vcFCkhYJvzmAFjTAK5c7HHMygD2KAqzr9c95HZO5/6pFF9o+T0DaL
	Sl+HQYuYwkQaX2DmLsvjqrtHBfOsfo6b97fjWDsCEXtvjN8HoWjh5wHj6zEbnnSD7pzSsngh4qZ
	LVMvpcKwiZQ1Qb2bobIXbRLVRkq9jpCg24UWn2KwP+UFHFPtPV0LZw0=
X-Received: by 2002:a05:600c:b4f:b0:43b:c638:3433 with SMTP id 5b1f17b1804b1-43bc63837a3mr9723245e9.12.1740994932383;
        Mon, 03 Mar 2025 01:42:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFDYmizeCfEPwnub6ZUt8HoyBNoVBgCgnBfss7JKJMNfK/DcWCCY9SyISgPNOR5yKhrWm25LA==
X-Received: by 2002:a05:600c:b4f:b0:43b:c638:3433 with SMTP id 5b1f17b1804b1-43bc63837a3mr9722845e9.12.1740994931899;
        Mon, 03 Mar 2025 01:42:11 -0800 (PST)
Received: from ?IPV6:2a01:e0a:c:37e0:ced3:55bd:f454:e722? ([2a01:e0a:c:37e0:ced3:55bd:f454:e722])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-390e47a6a6csm14062502f8f.30.2025.03.03.01.42.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Mar 2025 01:42:11 -0800 (PST)
Message-ID: <739acf08-6978-41f3-a4db-724acc03ba06@redhat.com>
Date: Mon, 3 Mar 2025 10:42:10 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] drm/panic: clean Clippy warning
To: Miguel Ojeda <ojeda@kernel.org>, =?UTF-8?Q?Thomas_B=C3=B6hler?=
 <witcher@wiredspace.de>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Alex Gaynor <alex.gaynor@gmail.com>
Cc: dri-devel@lists.freedesktop.org, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>,
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20250303093242.1011790-1-ojeda@kernel.org>
From: Jocelyn Falempe <jfalempe@redhat.com>
In-Reply-To: <20250303093242.1011790-1-ojeda@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zSQ4-iTbaTvlr-tASm-64RGFWDYC4LH1mIsGbCgQkKg_1740994932
X-Mimecast-Originator: redhat.com
Content-Language: en-US, fr
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03/03/2025 10:32, Miguel Ojeda wrote:
> Clippy warns:
> 
>      error: manual implementation of an assign operation
>         --> drivers/gpu/drm/drm_panic_qr.rs:418:25
>          |
>      418 |                         self.carry = self.carry % pow;
>          |                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ help: replace it with: `self.carry %= pow`
>          |
>          = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#assign_op_pattern
> 
> Thus clean it up.

Thanks, it looks good to me.

Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>

> 
> Fixes: dbed4a797e00 ("drm/panic: Better binary encoding in QR code")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>   drivers/gpu/drm/drm_panic_qr.rs | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/drm_panic_qr.rs b/drivers/gpu/drm/drm_panic_qr.rs
> index 62cb8a162483..3b0dd59781d4 100644
> --- a/drivers/gpu/drm/drm_panic_qr.rs
> +++ b/drivers/gpu/drm/drm_panic_qr.rs
> @@ -415,7 +415,7 @@ fn next(&mut self) -> Option<Self::Item> {
>                           self.carry_len -= out_len;
>                           let pow = u64::pow(10, self.carry_len as u32);
>                           let out = (self.carry / pow) as u16;
> -                        self.carry = self.carry % pow;
> +                        self.carry %= pow;
>                           Some((out, NUM_CHARS_BITS[out_len]))
>                       }
>                   }
> 
> base-commit: c0eb65494e59d9834af7cbad983629e9017b25a1

