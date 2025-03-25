Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2891EA7F5
	for <patches@lists.linux.dev>; Tue, 25 Mar 2025 09:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742893524; cv=none; b=n5jEQWirpC6BjZdb6AtYtNkLqPwwyO7CfmigIDdPcsxsVfy+FppN79Q7bdL/77LUS8Umm9btdgu+5g5GB+GeZaXDDbG7XU8wYNbtW5bOcmr8PBB6T59l+q7DrmuXGaIvtXgKk9XOopKgbRG8AthGzdqzTUemfOT07JqzkU+XbL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742893524; c=relaxed/simple;
	bh=mKJ++G7wNhJzW9MVSALnmcUFApSRdiNlAhwjAt23yKs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cWBUJTneFI4UpolZvBN4/b7qEmEhM3qdfDBEqxi6kNf6OKC1nXsLiObFyvj3AfZrthBNNtpFuX4nIhVSjdNcTTcRv7/2wxc+zQKzg4IjjM0GA9/PbW6WagJYdyl2O1oNfSIEoQucbaAxtO9kRL79e0dFb0tWTsxKmJzNTyQAZCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NkjWQ5kY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NkjWQ5kY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742893522;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PrC6whXEB8tIJZm3Od4OEZVDDngb94gqrtSVDSXgtaI=;
	b=NkjWQ5kYw0ANzeXmplBPO3TbStEQB6yz1LA5OMKqVGO48ZP3PVaF+AyTxBqKdbwQfc/qEI
	FYSqGqNKDIHMB9UReUXZ+fkkO+Kc+OlxrEVXKYwuLzLTt3o5cFrJPPi9vyN0B2D9Mon1pQ
	MMlPfwHIDYu4Cnitm+uKlBELKlh/usg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-221-LeB5GdWJPRmbXe3hf-vhmA-1; Tue, 25 Mar 2025 05:05:18 -0400
X-MC-Unique: LeB5GdWJPRmbXe3hf-vhmA-1
X-Mimecast-MFC-AGG-ID: LeB5GdWJPRmbXe3hf-vhmA_1742893517
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-39123912ff0so2335791f8f.2
        for <patches@lists.linux.dev>; Tue, 25 Mar 2025 02:05:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742893517; x=1743498317;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PrC6whXEB8tIJZm3Od4OEZVDDngb94gqrtSVDSXgtaI=;
        b=wc56rJw2615rozHABu6xRLJfv4oIqSJAsbQG6QqUqwZJl5dx/iKQ0q7MDVKItOmN1s
         hko1taS3Xz//lUmJhJRZAxx3Z5yyV8C15t6MoIy6qlNUCeJhurrxYB8DSWJCijlkJ9ND
         bVr7midRTLmuVpU8RDExLF70xaxrVChBR4YLuiIiPm3DImIXQf+o14tt6cAn8nuOKrIZ
         yp6tMbl+UHsdS/CmoIPpAgR2bqxxEWLlE5D4sLatpr26QBvnSyFm11NTRMnQd+E1qcS+
         J8T9tsDOrpE1t9sD9jzDyKT+kHR6wMsJA1loAGsLjg6SA2HJU/fmLUGaNBcCWQdbN7Fn
         SfQw==
X-Forwarded-Encrypted: i=1; AJvYcCUnmeqzG+HhEcRYKwFXIPeoe7GhJhy7DM8yZFJ4TDiRLBX73IQfPpTrfIpQa8XecTpV1Q/a4SxT@lists.linux.dev
X-Gm-Message-State: AOJu0YwtSXXi/uwuFE47KjCYStIP8XFxwkJchzwoL1sQQKkOURS6zfo/
	9AdaauCcbdP0/rTaKntDRb1Q5XhCaxMNznziUTXf58jxbLTyBEImTAHXS+iCeCIIJd0l1cFKV+H
	KXaytZD146j+iMxkVliUIh/FXypKGHsotvJYWQ3J2f1MAuQ2GgJgbvkI=
X-Gm-Gg: ASbGncs3h1XWbH+b6pOjEj4sGRs3Mv3e9YF6GSZ21uH2TGIpMYxiH6rdTGcRRw5B7vT
	o/DM7K8jm/uj+5S9Ns6WNMKM+zYPqh1Ar4NFDhI0WzBqM//itHjZnzSH6pM77X1mytS6RVSDvL+
	XCR+p5IFBAitAPLTEvj19JAD9+Xh48en6oKBAtzBYvMYmKkMQaCK/E6PuGP+nWH+OPSPp6GSikG
	v3qs6d6q4zuTb6H2g0q4F1OKTEwIc721FxZU8ATNjAl6byyx+mJjVWRniX3jaKZe+hKG3guzO/V
	olEZHG6UuC9L+iMmcy4LNj5PkJV6JkkBRGXLHAvdFAvwCYejrKnCLNM=
X-Received: by 2002:a05:6000:2a4:b0:391:ba6:c066 with SMTP id ffacd0b85a97d-3997f932dc7mr15340758f8f.35.1742893516846;
        Tue, 25 Mar 2025 02:05:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGTBT9UgEXQQoZOQCZf+geD9eCV4pZV+LkpuIAC9M/oAzFE2WYScIhUIhi8NX1J2SaBNujAOg==
X-Received: by 2002:a05:6000:2a4:b0:391:ba6:c066 with SMTP id ffacd0b85a97d-3997f932dc7mr15340713f8f.35.1742893516379;
        Tue, 25 Mar 2025 02:05:16 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:c:37e0:ced3:55bd:f454:e722? ([2a01:e0a:c:37e0:ced3:55bd:f454:e722])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d4fcea6ecsm145624925e9.5.2025.03.25.02.05.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Mar 2025 02:05:14 -0700 (PDT)
Message-ID: <dd1616d5-4808-46be-9167-6fbfe76e0c73@redhat.com>
Date: Tue, 25 Mar 2025 10:05:13 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/10] drm/panic: add missing Markdown code span
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>,
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 dri-devel@lists.freedesktop.org
References: <20250324210359.1199574-1-ojeda@kernel.org>
 <20250324210359.1199574-3-ojeda@kernel.org>
From: Jocelyn Falempe <jfalempe@redhat.com>
In-Reply-To: <20250324210359.1199574-3-ojeda@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ChkXRuZM5T8v78JKTpo93pR1OlnzUlFwh3wXru_3wfI_1742893517
X-Mimecast-Originator: redhat.com
Content-Language: en-US, fr
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24/03/2025 22:03, Miguel Ojeda wrote:
> Add missing Markdown code span.
> 
> This was found using the Clippy `doc_markdown` lint, which we may want
> to enable.

Thanks, it looks good to me.

Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>

You want to take the whole series in the rust tree?

Otherwise I can push the patch 1-2 to drm-misc-next if needed.

-- 

Jocelyn

> 
> Fixes: cb5164ac43d0 ("drm/panic: Add a QR code panic screen")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>   drivers/gpu/drm/drm_panic_qr.rs | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/drm_panic_qr.rs b/drivers/gpu/drm/drm_panic_qr.rs
> index 9bd4d131f033..a8f832598c70 100644
> --- a/drivers/gpu/drm/drm_panic_qr.rs
> +++ b/drivers/gpu/drm/drm_panic_qr.rs
> @@ -914,7 +914,7 @@ fn draw_all(&mut self, data: impl Iterator<Item = u8>) {
>   ///    will be encoded as binary segment, otherwise it will be encoded
>   ///    efficiently as a numeric segment, and appended to the URL.
>   /// * `data_len`: Length of the data, that needs to be encoded, must be less
> -///    than data_size.
> +///    than `data_size`.
>   /// * `data_size`: Size of data buffer, it should be at least 4071 bytes to hold
>   ///    a V40 QR code. It will then be overwritten with the QR code image.
>   /// * `tmp`: A temporary buffer that the QR code encoder will use, to write the

