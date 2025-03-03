Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C781F1515
	for <patches@lists.linux.dev>; Mon,  3 Mar 2025 09:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740994910; cv=none; b=KKUkp+Ia3CDkOOQp9IUXXXJH9DmkKbS5zaYIhpLUKyJ3CVFFQpuiYQdldiPyierYcfvwrne40dmHuy/+X1R6aCIUoq3/PElD+u0DJkNrY43lZ3Tr+7Vbv1nkfqeXQHYuHEjrD94BmBjD3tc0u1sHcuI1lZlIKXH45OMGgVM3m+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740994910; c=relaxed/simple;
	bh=kGP9kieYy3EZ0kvFmMM0hh/2O/yfpgHUuO7Mb3OLz+o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kKBubrE94c7JmUyoDEcyDT2PW8E/lSbxhIIRb8BXNTvOqOF4z8MyVCM5dhpQhlWCD/laXYOUuX9VPrF+KBsHjmrz7mP1CarvCwoNc8PXiWwXE6FmR2RF1jGCJkCyUHmh1VqKZBWJ6YkfsLoY/2KtF2GseKJvCGz28nmagnDcNgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CdvNG4ga; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CdvNG4ga"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740994907;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LbnZQEekEL5+7VJfe+tKFsSed1V7olIdl++NfvcMfSE=;
	b=CdvNG4ga9z/kW8f4MCZQLFH/OG5QwDFWGbxGX71QBEV25u4W4KSqhr2l6dLEpPS+IZlt/f
	WGrKAPnTVUA4wr6vgX3lGVxHxcoSPlqScogvivlehJFak3sTVjUNWGTTb1VPg/M+mcckkL
	3eRGrWmSV0dzJIyJX/I7FMeKZoEtbpo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-371-YfKnx6YGMoKM8jzMgwpHSw-1; Mon, 03 Mar 2025 04:41:43 -0500
X-MC-Unique: YfKnx6YGMoKM8jzMgwpHSw-1
X-Mimecast-MFC-AGG-ID: YfKnx6YGMoKM8jzMgwpHSw_1740994903
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43947a0919aso36556835e9.0
        for <patches@lists.linux.dev>; Mon, 03 Mar 2025 01:41:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740994903; x=1741599703;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LbnZQEekEL5+7VJfe+tKFsSed1V7olIdl++NfvcMfSE=;
        b=f6NMKsUJJP/yKczceWwOkD46WlOlSEtHfJ7ZZ//VGQvIx9b1fBFGZt1PhfoB2A/eGc
         SiJvOVtm9jy6b315kY+eRK18SmHUif4KZ++IghniCwPYcexHpcFIC/f9+w3eD6YOUtP8
         +WXGPMqTdGNS+DVr9q8iRaM5vdhYt7i4VLnQvxuGsrY5xQCtNq0ScnP0BXxsfDiIVMIv
         Be3yHp2ki46m+83fxDINC2tx4N9jEN7A+sWTNtMBiggBzVN4mL+1iU0l27ou1AtvLzHW
         io1b+T7QowA1+WD6jwJbUJUSiue/vh9+VVFNk1b7byf0rK4vkQO4lI4mPuq8KVI7DJXg
         zIWQ==
X-Forwarded-Encrypted: i=1; AJvYcCV2ry+1EBiuJNlaTB9YqO+2CeTOnaBWaUUWmyJRbawe4YB/jUINkBmcEAMxs3/iwnWNeGYPqk68@lists.linux.dev
X-Gm-Message-State: AOJu0YyfZl7Ix4qfzIe1/zmf+JgfLflMMqq3ms34oPs3hL+kHbSZPRlN
	GAhVJhyrjYbRA8HrGy/anNa7P2nq/YhbYW5mVlVyVtgaiM1Pnyk+G0aZqFnBcJYdVUUH0DsPh/q
	cOrj5WzFxtmaXyndDZrtQfqdb7taRvLBjfPI1HG22vpLHZXb8mK1UJac=
X-Gm-Gg: ASbGncvpDuXUmsguSbOnezR8Cozuv5Tdy+qBrCz8Ta9qCGdIK40GRYUf5/Xm545Waro
	rjVxLm6XGPOlzdcTuImWM9t4XQfFEJ4ZDw0boQsl9BbQ+e69UlL+FMyMOWkv78xLZpZf3AK5J+J
	6zRMHiBgQ1oaH6RP/spMnrCHkBy6oYad2i2EYFWz0Bd6yqozQKjrBNxE7tP5H3FOCo5293pmDh+
	//CbHa6x+s4/ajtSEs/0XzhwGrTqe0GODpJn+Qn9bjxoJ4TxbGwQVPz67pQqq1cfRdgHiBOmJ1V
	3eQn7h+cLQrjGQHWBO3VJep3W7aAj/rZk/cBwa9MYwZOkgK0mAoZwVg=
X-Received: by 2002:a5d:61cd:0:b0:38c:3f12:64be with SMTP id ffacd0b85a97d-390eca06cdemr10490956f8f.35.1740994902684;
        Mon, 03 Mar 2025 01:41:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFVizEggt0+gnRtA0jge53v3XHkF35Zs1QmzZY9VyL57FFl+Hjzngtfu34rhJup5F7TcFTjTg==
X-Received: by 2002:a5d:61cd:0:b0:38c:3f12:64be with SMTP id ffacd0b85a97d-390eca06cdemr10490932f8f.35.1740994902233;
        Mon, 03 Mar 2025 01:41:42 -0800 (PST)
Received: from ?IPV6:2a01:e0a:c:37e0:ced3:55bd:f454:e722? ([2a01:e0a:c:37e0:ced3:55bd:f454:e722])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-390e4844a16sm13917054f8f.79.2025.03.03.01.41.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Mar 2025 01:41:41 -0800 (PST)
Message-ID: <eecf227f-8f79-4572-95ae-7370f907579d@redhat.com>
Date: Mon, 3 Mar 2025 10:41:40 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] drm/panic: fix overindented list items in
 documentation
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
References: <20250301231602.917580-1-ojeda@kernel.org>
 <20250301231602.917580-2-ojeda@kernel.org>
From: Jocelyn Falempe <jfalempe@redhat.com>
In-Reply-To: <20250301231602.917580-2-ojeda@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Tkeokq6al6Hht5JIZyhr73XIYu2kA8r1y5jxpXQ7-cY_1740994903
X-Mimecast-Originator: redhat.com
Content-Language: en-US, fr
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02/03/2025 00:16, Miguel Ojeda wrote:
> Starting with the upcoming Rust 1.86.0 (to be released 2025-04-03),
> Clippy warns:
> 
>      error: doc list item overindented
>         --> drivers/gpu/drm/drm_panic_qr.rs:914:5
>          |
>      914 | ///    will be encoded as binary segment, otherwise it will be encoded
>          |     ^^^ help: try using `  ` (2 spaces)
>          |
>          = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#doc_overindented_list_items
> 
> The overindentation is slightly hard to notice, since all the items
> start with a backquote that makes it look OK, but it is there.
> 
> Thus fix it.

Thanks, it looks good to me.

Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>

> 
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>   drivers/gpu/drm/drm_panic_qr.rs | 12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_panic_qr.rs b/drivers/gpu/drm/drm_panic_qr.rs
> index 8bb5e52d75cc..6903e2010cb9 100644
> --- a/drivers/gpu/drm/drm_panic_qr.rs
> +++ b/drivers/gpu/drm/drm_panic_qr.rs
> @@ -911,16 +911,16 @@ fn draw_all(&mut self, data: impl Iterator<Item = u8>) {
>   ///
>   /// * `url`: The base URL of the QR code. It will be encoded as Binary segment.
>   /// * `data`: A pointer to the binary data, to be encoded. if URL is NULL, it
> -///    will be encoded as binary segment, otherwise it will be encoded
> -///    efficiently as a numeric segment, and appended to the URL.
> +///   will be encoded as binary segment, otherwise it will be encoded
> +///   efficiently as a numeric segment, and appended to the URL.
>   /// * `data_len`: Length of the data, that needs to be encoded, must be less
> -///    than data_size.
> +///   than data_size.
>   /// * `data_size`: Size of data buffer, it should be at least 4071 bytes to hold
> -///    a V40 QR code. It will then be overwritten with the QR code image.
> +///   a V40 QR code. It will then be overwritten with the QR code image.
>   /// * `tmp`: A temporary buffer that the QR code encoder will use, to write the
> -///    segments and ECC.
> +///   segments and ECC.
>   /// * `tmp_size`: Size of the temporary buffer, it must be at least 3706 bytes
> -///    long for V40.
> +///   long for V40.
>   ///
>   /// # Safety
>   ///

