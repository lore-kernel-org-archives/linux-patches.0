Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B6017BB6
	for <patches@lists.linux.dev>; Tue, 26 Nov 2024 09:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732611848; cv=none; b=N+ns7AAxOy3OAO9iFETamqjkbBNPH2n3CtPWEgD000aQDl5spuigpqHdR/NCIw3iQIoGhPmLK3gZk8AVF2H/RBuFXM6IkxrE6/IIeZaLOxGIiUoNXz4gcf7Oby9irJrtWTdxVgHOtS9pIGYm1SpGjMC/nrxM2Rfs+oIcxL9rNCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732611848; c=relaxed/simple;
	bh=ZWmrGQ6M26BhXo9m6RKEZU+fsqbwL7LzDsPFnAheZho=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uZoLTczvOg76HUTyVEpnWwMN3X51oO4cCe44iqiFEx3qEK32wLYfnP7GWFKo5pxmTHIavwJPIyO7uXn2dC439i4dj6eEgRyKFAvXO3APXyllDprSsvqAMMrxtyIsbGK4b3nsoODpQegcYyvRz50P00KZMOz1NZ0SLxJz+CXM+eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VurHXpDa; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VurHXpDa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732611845;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=im/8o06WdRL6AvUGxWnBVgqT+amoAsT42x2YeIRHNPI=;
	b=VurHXpDaRTtY46UE8xiir02F4tL7Fn5/zAePHR1iaHClCa09mihb7dSI4uhdKCWSVbqZuB
	FTs+FNlONUoZDtNNtp+2HLqudraSF732F1o5xftAkoPqDMcMaO4Vt8C1xOaI2qKu2MPOdQ
	e2ocHcjrGAANHoNVRn1GttucCMZc5jk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-361-CWov_UOlMFWdMZBpMJfSUw-1; Tue, 26 Nov 2024 04:04:02 -0500
X-MC-Unique: CWov_UOlMFWdMZBpMJfSUw-1
X-Mimecast-MFC-AGG-ID: CWov_UOlMFWdMZBpMJfSUw
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4349e97bfc4so20369765e9.3
        for <patches@lists.linux.dev>; Tue, 26 Nov 2024 01:04:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732611841; x=1733216641;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=im/8o06WdRL6AvUGxWnBVgqT+amoAsT42x2YeIRHNPI=;
        b=kxQeSXp8732dRzl6hr9X1jRoqnrHXQanihOC1YPWz7UrF9VEomdaTsPIj+n8oGB6yb
         emodOBfosn3dyOO8s7Mb2KRWFY0CkRB+6n2DIZFHBJfXrsFd9EfHTme6iBV6U3GX3MzS
         KwQEu+32gLWyHzx2XwnCq3hAYkijW7JfEY+IMQy3UtLoMP5+7llJCEH5y73571RyaOa1
         +IoPf/JlhljJGXbvsSPGHzVJ30pRRg7kJ4xDF+IXMcb9ZhoALXIZpnBmkz79uBQmG/H3
         8gGbR5YTNVVrWojzgdTK2/dAJ2tfGnt8QKy/fd2ygLj/qaXlQQjLsum/dQlIIImzc93O
         mn3w==
X-Forwarded-Encrypted: i=1; AJvYcCUADG6PykXXVxfqLA493cpdCDZBsoi7NEUHmbr40+tEBnQ6jb3/rBQf0SN3EyBsET+XOJdZBiDo@lists.linux.dev
X-Gm-Message-State: AOJu0Yxe0gZYACgg6oIwyIBypme+Za5ka8lGuhi+sIJ9rsPt9V3uuxqr
	BcVvUiSCw8UtfzL1CpUZeDeAW5dVXyLMvul1ywsqIJ9pleI1UNnVfrRlo1AkD/ZAu5LgJqxm9V3
	oL3vcrP2BxP6uDk2256thQUonEZTd+/vfb3kP2Ci9GC5mJBbE7dFXyi0=
X-Gm-Gg: ASbGnctPCsqfOpQxeXvxHeQputpxuN1ckkzV94Imgpyap6HNpj0jQHzGpgwoMu08xiN
	3gIQejVvK5z1gLc24EisYjyGJ942PDApOqwJsQxugR8VxCPvHIWfnyr3RVFRf22OfZM3I1C4XnY
	aG1jAwi+88rOiX+uzlZOrd+a7YeiomofHU5dRYSuv/ERDeohGPMaYN3K8B7SqT2/tMWyT5KXBPN
	13nc45+b32qHu6kh3JfrRz65NoM0p2TD+a5hfke4k4htSZprYv08xq6EaejEuvpP7H/eMEuQenm
	ivaIceytEyNN+Q==
X-Received: by 2002:a05:600c:a49:b0:431:4f29:9539 with SMTP id 5b1f17b1804b1-433ce4af26bmr148804015e9.32.1732611840676;
        Tue, 26 Nov 2024 01:04:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHqku7owNzsRW4AuiyjR+T5rbYPu8TV/N4RKw6ZJEgH4GkTL9H/M9yM3mzoUSyueykAQvBQkA==
X-Received: by 2002:a05:600c:a49:b0:431:4f29:9539 with SMTP id 5b1f17b1804b1-433ce4af26bmr148803685e9.32.1732611840280;
        Tue, 26 Nov 2024 01:04:00 -0800 (PST)
Received: from ?IPV6:2a01:e0a:c:37e0:ced3:55bd:f454:e722? ([2a01:e0a:c:37e0:ced3:55bd:f454:e722])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3825fafeceesm12715211f8f.37.2024.11.26.01.03.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Nov 2024 01:03:59 -0800 (PST)
Message-ID: <fe2a253c-4b2f-4cb3-b58d-66192044555f@redhat.com>
Date: Tue, 26 Nov 2024 10:03:58 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] drm/panic: remove spurious empty line to clean warning
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>,
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev, stable@vger.kernel.org
References: <20241125233332.697497-1-ojeda@kernel.org>
From: Jocelyn Falempe <jfalempe@redhat.com>
In-Reply-To: <20241125233332.697497-1-ojeda@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1-d3ayd-Z5g-KQuDIYsx1lKdD5aXpT_KrXbWQZSsRvk_1732611841
X-Mimecast-Originator: redhat.com
Content-Language: en-US, fr
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 26/11/2024 00:33, Miguel Ojeda wrote:
> Clippy in the upcoming Rust 1.83.0 spots a spurious empty line since the
> `clippy::empty_line_after_doc_comments` warning is now enabled by default
> given it is part of the `suspicious` group [1]:
> 
>      error: empty line after doc comment
>         --> drivers/gpu/drm/drm_panic_qr.rs:931:1
>          |
>      931 | / /// They must remain valid for the duration of the function call.
>      932 | |
>          | |_
>      933 |   #[no_mangle]
>      934 | / pub unsafe extern "C" fn drm_panic_qr_generate(
>      935 | |     url: *const i8,
>      936 | |     data: *mut u8,
>      937 | |     data_len: usize,
>      ...   |
>      940 | |     tmp_size: usize,
>      941 | | ) -> u8 {
>          | |_______- the comment documents this function
>          |
>          = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#empty_line_after_doc_comments
>          = note: `-D clippy::empty-line-after-doc-comments` implied by `-D warnings`
>          = help: to override `-D warnings` add `#[allow(clippy::empty_line_after_doc_comments)]`
>          = help: if the empty line is unintentional remove it
> 
> Thus remove the empty line.

Thanks for this patch, it looks good to me.

Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>

> 
> Cc: stable@vger.kernel.org
> Fixes: cb5164ac43d0 ("drm/panic: Add a QR code panic screen")
> Link: https://github.com/rust-lang/rust-clippy/pull/13091 [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
> I added the Fixes and stable tags since it would be nice to keep the 6.12 LTS
> Clippy-clean (since that one is the first that supports several Rust compilers).
> 
>   drivers/gpu/drm/drm_panic_qr.rs | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/drm_panic_qr.rs b/drivers/gpu/drm/drm_panic_qr.rs
> index 09500cddc009..ef2d490965ba 100644
> --- a/drivers/gpu/drm/drm_panic_qr.rs
> +++ b/drivers/gpu/drm/drm_panic_qr.rs
> @@ -929,7 +929,6 @@ fn draw_all(&mut self, data: impl Iterator<Item = u8>) {
>   /// * `tmp` must be valid for reading and writing for `tmp_size` bytes.
>   ///
>   /// They must remain valid for the duration of the function call.
> -
>   #[no_mangle]
>   pub unsafe extern "C" fn drm_panic_qr_generate(
>       url: *const i8,
> 
> base-commit: b7ed2b6f4e8d7f64649795e76ee9db67300de8eb
> --
> 2.47.0
> 

