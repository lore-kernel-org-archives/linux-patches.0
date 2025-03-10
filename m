Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313ED22540B
	for <patches@lists.linux.dev>; Mon, 10 Mar 2025 09:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741600800; cv=none; b=lgTbO/shA4wN6cHMgLOmzzMPb5vFUBgAtP/F9s7MWfq7rT4qlmYcA/kxEakV9/oGSeswFurX9TN2RFYmVdOWFLSUfGGQM1YSeOyd65HvNP6lehyHL0UckCQtk+tBp4WzLCNtc1phjCe4IP+RYruMNH7OsteUFsRdD8ujeW0+jIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741600800; c=relaxed/simple;
	bh=V/WiqkuxA4YwLXvuQpcmscx/6nwwjOByTFAnW3PVYWE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E8dLzoNFE2eQb2JSs4jG88v+g3u8+cqw7nDbq7fpOhPZoFUOUc/hUmJyU/d3xT2u+yUId3tMZX3LDQ7phPQpra8c7dqncreFl6ZIBMQnt96y2D9vVO3TJDw+WVdfzYpgnajp8ISpZ5A1WMDGkgTh2UEmq03zuo6P+1Y9bJx79pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MNtj3T7X; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MNtj3T7X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741600798;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AQ+pSa8sIsuU2xtscwDYe98bcGEdRUw/0m+Fk+VSrb8=;
	b=MNtj3T7XwPu4R7/eE77xgZVOX1xvKeyTI8h8WabR1nd8vNmRByNrKr85g2qZG+2R/ve6F8
	1TeVZ9tgEJyBLo/dCxMhyvNUVXJLKkrTDFa4yaAPX9jlTDOCu7NQnkNbq86zEBEL5uEQ1k
	n6zYt+UxStrkGp10yLtPahqBPSTMom0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-y-frMhjoNDqDY5CXtEDkbQ-1; Mon, 10 Mar 2025 05:59:54 -0400
X-MC-Unique: y-frMhjoNDqDY5CXtEDkbQ-1
X-Mimecast-MFC-AGG-ID: y-frMhjoNDqDY5CXtEDkbQ_1741600794
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-39135d31ca4so1241889f8f.1
        for <patches@lists.linux.dev>; Mon, 10 Mar 2025 02:59:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741600794; x=1742205594;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AQ+pSa8sIsuU2xtscwDYe98bcGEdRUw/0m+Fk+VSrb8=;
        b=Zpl0H7DSS9DitSsbek/o7iMr8eNHnsoJI7uAbxp8cFom2gKyLBvEf2EoGscuG+Qvqc
         nGJdG0V2A49T2ApLBtkUFG3fCKobS6IMCVKvy7Dz72WlftULf5TSUyciWiXK0G6h1wHO
         TBnMFOfM03pvs9nc7vMBWggvLKRSM/iN1OLx0ZxvJgzIMa2z8yB4IeVsl1tkyGQCyDX9
         VMYzsyzHGFyoJE8kPXYtqChMyYL93xqCrvd++AFSy5T+jfeq2yll6X8pRiuDD+++4SM0
         VUzeaGDVyTjxLUQRLbN7r4IiDwltJY9IPbYdpRnIZqMev2vRkQ2C0z5jakiLxaldqrVK
         tvkg==
X-Forwarded-Encrypted: i=1; AJvYcCU9fD9Asrv8epjMD/P6rNPVEvWXVtDhrl99Cxh0GiWzvQz1tHe54iL0ycQnyFOr+OkENLjxUpw2@lists.linux.dev
X-Gm-Message-State: AOJu0YwyvBHVehLC7qbOZwzbCnV06lyGlB+smKmA/pkM+qgZSyAgHrLU
	m85uv3owyfqyZvPeFAOnmSTOZQQ1dBufYQNVRBCGKikvqT69aDKg/HIEDXOZrS/JaN5bxQe4PBE
	HRgYMjYV5bl9HC0YF4fJxDHQNAARCjTeVcwPLM7Yxu4iv1gtGqNv4Xpc=
X-Gm-Gg: ASbGnctf4MsPy2LZlX7wVIfxyeWyTghAB5tjmpP9+MukRlP2HdNWmP4Kj/o2FB/rmnJ
	vDTduSzio1hKe95MSKO5GDzhOTeAWyYp8EX3er5DqAG4peGpz/4Y/iEFxGhkrT2Mrexg8YGXWlZ
	HUvE03NIwaTqEneuURHe2TZ649WN89tDpYAhNYgQuMvu9v272M1Dy4cRnm+eRUQAkWuV7lMF3pe
	hn6E+ByPCwIxi0zE+W3ugj2yyRNNfvekXjlrkFRH6r3gsmmprOpWVJv1HBq/LXalarJdDp69tvD
	ZO7O7a8eKpmjox7mQRAYJ9C5iy4Z+clCdMcSjSxSO47bBQWaGhgkJOg=
X-Received: by 2002:a05:6000:184b:b0:38f:23c4:208c with SMTP id ffacd0b85a97d-3913af2e472mr5013395f8f.18.1741600793701;
        Mon, 10 Mar 2025 02:59:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGX9wDZkgqzcXWNadk7lA63fXqzI59Xv6gjXmdznaOhUQyAtcnnGk1X47jRovjSDv9uACyJBg==
X-Received: by 2002:a05:6000:184b:b0:38f:23c4:208c with SMTP id ffacd0b85a97d-3913af2e472mr5013370f8f.18.1741600793351;
        Mon, 10 Mar 2025 02:59:53 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:c:37e0:ced3:55bd:f454:e722? ([2a01:e0a:c:37e0:ced3:55bd:f454:e722])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912bfdfa52sm14018794f8f.21.2025.03.10.02.59.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Mar 2025 02:59:52 -0700 (PDT)
Message-ID: <ca830ba6-5e02-446e-87d8-4e120c357312@redhat.com>
Date: Mon, 10 Mar 2025 10:59:51 +0100
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
X-Mimecast-MFC-PROC-ID: ghslxEINUwXx7oD2wiJ4AXFGhTkGCc8zKVA8bzmrpQw_1741600794
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

Applied to drm-misc-next (because dbed4a797e00 is only present in this 
branch).

Thanks for your contribution.

-- 

Jocelyn

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

