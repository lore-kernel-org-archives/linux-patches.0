Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4A52046BF
	for <patches@lists.linux.dev>; Mon, 10 Mar 2025 07:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741593000; cv=none; b=IuAWNLbgF3PdHxy87OUXvhsAtFLWhr+TqVHLhHguAmJh3LIdSGagjcWm6gOhZJkFDtzmaIrZ0CD6Bihvs1PytfNL4yRtwQpYaQdrvKxctTS8UOzMUwW939d4dKSF+JijuRUfQvN+GAVLmKwlpxk4PFKar4x+Nanx8THIX+JJRtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741593000; c=relaxed/simple;
	bh=2taqIQQXceogYRxl+WbwaFPfpyiONZBcxtV+IJvWGc8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NTm1cf9DFYs/FzdcqOxTCRtM55lRDGKvIvrJ3JZTa9wg74uYqQg42zUclUgJBvMudg+1YAy9JdT3ivGBMsD9RJetAR3Q0Zl2DAQNJn33nWX4+JgKeEXrTBYE7h1uu/XsYlCemnV05r1yzrj3uMBwmPKxJEhAAhCmadeMdsOvouc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Oz+0SvF8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Oz+0SvF8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741592996;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u5kIvy1af+TbHcL/hyxVpb8RVtEt62vD4Y3oqmjYEDE=;
	b=Oz+0SvF8Zduz9Qld7rX+A8zfwGhUBqHrglcYglyP3rS3xwPS0i0akW/qHDrqdBJk/Xp0o0
	BFxF+y1P5QpuedaO3z2pQtHLFDYgy2l/2XLsly8QmEtLc0KXjvxht6HgSHYrr2qA0RUGlc
	aJLgKgCPcIwVLEIsze7rFJ/CGFRp1BQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-Xnwwup59OMe-2HQmOr4YxA-1; Mon, 10 Mar 2025 03:49:55 -0400
X-MC-Unique: Xnwwup59OMe-2HQmOr4YxA-1
X-Mimecast-MFC-AGG-ID: Xnwwup59OMe-2HQmOr4YxA_1741592994
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3912fc9861cso1458610f8f.1
        for <patches@lists.linux.dev>; Mon, 10 Mar 2025 00:49:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741592994; x=1742197794;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u5kIvy1af+TbHcL/hyxVpb8RVtEt62vD4Y3oqmjYEDE=;
        b=HZogoRPkN6JD1HlqDR43AGf5CXDPH4xZkDXOgoeHaeJXEXiPd4WfP6dGWmKikSOsxI
         2T73vRIpv/rWhvGXEz262rFI919ThYZng6evhNssZLXlbVEZe3X2p9i/CfmcnoYAuRJ2
         1oCly11zTvcr3K7cFzBbl03f5a1r7FXeuzyCr5pxyEdf0ZSEgw/HL1Rff9m6ViK6YcmR
         WB0UFNyxfXsrlSa49AF87sPTNTw1/FU6w7hMvhDPlmq4pCm+xyV0/PNxJETQkRsplZXh
         6TyldsAi75eMibLhKkVH9RXCMaDml2jEgGYGhmhCBzsXVjll4iX6MXP3sogd7VQ4coK2
         hOKw==
X-Forwarded-Encrypted: i=1; AJvYcCUzuSAZ6hbzJxyOGvDU69Re6CjagsAfhTq3ICYj1PDWT/5lmyhLDxVe7Q1lejQA91Ny2i8YBHzR@lists.linux.dev
X-Gm-Message-State: AOJu0Yz3NmZw8wFkGjK/e9AH8Pmo3EPIO62czDQVYCTXiLjRAW/iFsMU
	cmsMlPMD8FaHRm8166GnxUz9Zl6NpkJar3KIgkWNWDh11VDy1OflAy0LGDiL0b/fy1nSdMyEHh+
	XRkNR1/ab/w0qoDHs9LV4rTzatd0ruOgzeSuJVwgkmQBIM9EM+fN6Su4=
X-Gm-Gg: ASbGnctZ1AOEFFRFXjdRAtVvp5bFCuu5xnfMIeRGt6HNutX9fPEuel988gZIvrrVlnh
	Zcd7fK8SrpxQ5MC+yS8WzUg10zVWVTJkNDTMHgj2lpdVXgPuToSJy7THTWBcx0MDjxmAsIAdH5D
	EknchmShM0ClTGITY6IEveZezQP2uEd+FCHYlyUmRKc+8X+AdW3n3hgEJkBBSyYmpbCfy/pNQqy
	pMeUarX4NYfAcpps7t46Ee47f/ekOzAHWH8oBsYDNcNyw6C/XqF56XshP6NDCZbsas5VKuTBiiV
	+kYnGRyT+eCresWY+gw7ITuhzHruhyUDkugwH1u6/r63OocH1IoYWXc=
X-Received: by 2002:a5d:6d09:0:b0:391:34:4fa9 with SMTP id ffacd0b85a97d-39132b56eccmr8992849f8f.0.1741592994110;
        Mon, 10 Mar 2025 00:49:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHFGDJo2dCkSOhn/W3s56Mf4MrQ0JYSQmeOFCRJ3rj6SEOpkuthbr1LKEQhE5Wn257lq7BmQQ==
X-Received: by 2002:a5d:6d09:0:b0:391:34:4fa9 with SMTP id ffacd0b85a97d-39132b56eccmr8992816f8f.0.1741592993752;
        Mon, 10 Mar 2025 00:49:53 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:c:37e0:ced3:55bd:f454:e722? ([2a01:e0a:c:37e0:ced3:55bd:f454:e722])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912c01cd31sm14138878f8f.52.2025.03.10.00.49.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Mar 2025 00:49:52 -0700 (PDT)
Message-ID: <7fa51125-3015-446a-93b1-57b07a7ee8f5@redhat.com>
Date: Mon, 10 Mar 2025 08:49:51 +0100
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
X-Mimecast-MFC-PROC-ID: GXU3XExaymp3NdztiH6pajHLR5RnDrJGuRAQi4mgXu4_1741592994
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

I pushed both patches to drm-misc-fixes, with the "Cc" tag added.

Thanks a lot for your contributions.

-- 

Jocelyn
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

