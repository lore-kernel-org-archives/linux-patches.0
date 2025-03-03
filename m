Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055A21F0E51
	for <patches@lists.linux.dev>; Mon,  3 Mar 2025 09:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740994873; cv=none; b=L8+RDoTzGap4t5m1mCLzt0xVo9m4GYqgdAiU7jDjs5bohgHsmL06dqfhdUxUHpYjCksGHOMNFFVqQ4Q0W3BXs0XgyEgGla/2A/aqzGXEFscdMJH1VT5mQ0xbr8LRpmyMWq1/sJfc7fkwz59CfF69j7/TehkWBLF6Nt/g8E/xb8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740994873; c=relaxed/simple;
	bh=dQLYc6BsEprEKBA6DtRFuQ16bOaLXoXn6GQNmtYK31k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LsXsJPeYyXrkWvEi3fCGJQVsKy1H2lOhwP7fOg4aqC9fUNl+6YJo0gmopuSSB0zodLZJ2tcXTG0nSjuWrmyVeqgT7Ai1Vc6i58zYNw9zq9MUHWrH8d/DFyHgXiJRIw+RcgtrBrZIz+H4pzGb1+lXs97b4kJYTjbN0mT50WY7Ccs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YM1qO2QI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YM1qO2QI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740994870;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D46wI1otbQqaNSu8WnEzDU27WQjj8NKTR6dNsZngyNk=;
	b=YM1qO2QIUMyOiSesWjYI+4FmVPrqgrpTgzW/GnzZhySQ0hqN99R6rKAf8tLRFcOe7sxZ6A
	ct+A8gdw1U9VVkaVpU0ktvZhxk/zckvhMWt8mGWm6DCUZaYdt0EAwKsnLnvMecEnGkcJMQ
	OVMI+x8lTHloc8V6sq3e1PvmF3TUhaY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-563-p75gVUqbP_WGCFU_OtCejQ-1; Mon, 03 Mar 2025 04:41:02 -0500
X-MC-Unique: p75gVUqbP_WGCFU_OtCejQ-1
X-Mimecast-MFC-AGG-ID: p75gVUqbP_WGCFU_OtCejQ_1740994861
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-39101511442so455790f8f.1
        for <patches@lists.linux.dev>; Mon, 03 Mar 2025 01:41:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740994861; x=1741599661;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D46wI1otbQqaNSu8WnEzDU27WQjj8NKTR6dNsZngyNk=;
        b=uEFZEBPKrIXXUhaIRR7RA0z6BlQX690mZWGlM/xcxt+JBpJ6gRi/2FztPQuEdpu67z
         IXQZdK5kUzYwJ1aQvppbkw+4AnCBpaKsDk2On2ktwWFXM/h1HxoDgotIYe3YImT8T7xj
         Rc/ow4yd7NQ4DrAl3kvYUwcYIq8kV6PlP3PGmLc++a+BPgC4lzE7ylchlYqVpZV2GgHd
         GYce6qVRt+hPPigbGCpVwDJ1A+sDSFzHemqzXz3SYcAlWzt2UaxS6OyzX62paoHcR686
         Uu508FODGXtxqnLB4Cr4fV1zRYw48ENx61/EA4t3A/dnib7l/WOCLLkIC4PuDOcA9lTA
         5fNA==
X-Forwarded-Encrypted: i=1; AJvYcCVQy8KuB+hWCOJaPIDu5R5zo8bi3XEgaRnuSBJND8uhUuQjwl9BC+OwWOT6k5114WlAZ5q9uxWt@lists.linux.dev
X-Gm-Message-State: AOJu0Yx0PpWb2LdzndszgIhIKq9YAOhdjcFsS9/NI+RsIcC2ZU1jJtqa
	KJhQiE2Ymd3Hg4oBLUg9VaKNGKlf78O/QJOHR0UQJAUAI4DxHvjTcDVZZaC7trD/FG0uwMLUWIQ
	oAoh78AVSym0td5QVO8SPZyAu0WgNzupoHU3njkCMAXRqyvrFGE5m0d8=
X-Gm-Gg: ASbGnctcSLiBsb83IxxaZQ1F7TXHOqmLmFvFk77RF4y6L2CFYC1QUQgBOOAjhXY/vY8
	u8lihDdMeLdUBsMW4MnVJIcqmFzOfU2EV1sE3sTMOWhWoXq2ewXDkjQ4jKWsrmBU9vBWAPQF1ns
	Smwe2keW+2XINbr8NX9JzIJ9O+68DolAkwz5cEfNcYqpIRiQZQgXLUAljEOVH6sM+ppvZqeP9VV
	FLEK3ORgxbbjjbp3qtXdPt3V3SzU0+5/SHrQxmkp5cuxNBrR18vYuYma3wdLsTWPSbm2qcmXgTc
	lxpKDvPOwhOQdP4SJCg7Q/88nF/uMT2r5oTmac4nyiVOySmjYXd0upU=
X-Received: by 2002:a5d:47af:0:b0:391:a74:d7e2 with SMTP id ffacd0b85a97d-3910a74d9dfmr2504796f8f.26.1740994861459;
        Mon, 03 Mar 2025 01:41:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG1de8HYVkepPP08FYSHZESNB6/TmqfVP389HdGHarD00Xh+lNows9m8q7gT93iwcJAAY8o5A==
X-Received: by 2002:a5d:47af:0:b0:391:a74:d7e2 with SMTP id ffacd0b85a97d-3910a74d9dfmr2504754f8f.26.1740994861034;
        Mon, 03 Mar 2025 01:41:01 -0800 (PST)
Received: from ?IPV6:2a01:e0a:c:37e0:ced3:55bd:f454:e722? ([2a01:e0a:c:37e0:ced3:55bd:f454:e722])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bc63bcaafsm13675235e9.28.2025.03.03.01.40.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Mar 2025 01:41:00 -0800 (PST)
Message-ID: <b0dcc390-6e12-43ff-972d-1aca96fa374c@redhat.com>
Date: Mon, 3 Mar 2025 10:40:59 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] drm/panic: use `div_ceil` to clean Clippy warning
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
From: Jocelyn Falempe <jfalempe@redhat.com>
In-Reply-To: <20250301231602.917580-1-ojeda@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fidTBNH8IBU5N8HRUgisnHKJZA6GFkM_AGvWHSGAlxA_1740994861
X-Mimecast-Originator: redhat.com
Content-Language: en-US, fr
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02/03/2025 00:16, Miguel Ojeda wrote:
> Starting with the upcoming Rust 1.86.0 (to be released 2025-04-03),
> Clippy warns:
> 
>      error: manually reimplementing `div_ceil`
>         --> drivers/gpu/drm/drm_panic_qr.rs:548:26
>          |
>      548 |         let pad_offset = (offset + 7) / 8;
>          |                          ^^^^^^^^^^^^^^^^ help: consider using `.div_ceil()`: `offset.div_ceil(8)`
>          |
>          = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#manual_div_ceil
> 
> And similarly for `stride`. Thus apply the suggestion to both.
> 
> The behavior (and thus codegen) is not exactly equivalent [1][2], since
> `div_ceil()` returns the right value for the values that currently
> would overflow.

Thanks, so that's the DIV_ROUND_UP equivalent I was looking for.

Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>

> 
> Link: https://github.com/rust-lang/rust-clippy/issues/14333 [1]
> Link: https://godbolt.org/z/dPq6nGnv3 [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>   drivers/gpu/drm/drm_panic_qr.rs | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_panic_qr.rs b/drivers/gpu/drm/drm_panic_qr.rs
> index bcf248f69252..8bb5e52d75cc 100644
> --- a/drivers/gpu/drm/drm_panic_qr.rs
> +++ b/drivers/gpu/drm/drm_panic_qr.rs
> @@ -545,7 +545,7 @@ fn add_segments(&mut self, segments: &[&Segment<'_>]) {
>           }
>           self.push(&mut offset, (MODE_STOP, 4));
>   
> -        let pad_offset = (offset + 7) / 8;
> +        let pad_offset = offset.div_ceil(8);
>           for i in pad_offset..self.version.max_data() {
>               self.data[i] = PADDING[(i & 1) ^ (pad_offset & 1)];
>           }
> @@ -659,7 +659,7 @@ struct QrImage<'a> {
>   impl QrImage<'_> {
>       fn new<'a, 'b>(em: &'b EncodedMsg<'b>, qrdata: &'a mut [u8]) -> QrImage<'a> {
>           let width = em.version.width();
> -        let stride = (width + 7) / 8;
> +        let stride = width.div_ceil(8);
>           let data = qrdata;
>   
>           let mut qr_image = QrImage {
> 
> base-commit: d082ecbc71e9e0bf49883ee4afd435a77a5101b6

