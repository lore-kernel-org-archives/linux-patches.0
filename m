Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B014B2F3B
	for <patches@lists.linux.dev>; Tue, 25 Mar 2025 09:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742893348; cv=none; b=D2GYfy5UUnEVckJ7DlW02XjOKvaoguUlTiotjKbuoGompMflJSSHIKGwSowS5j5x6lz/p/AkR1foB0EpsjUFtD8Vs4AsmJbxcpF74TF02knTJZGBa3Qto64zZaTdolUe2wylL3TEQ/b4NNgSed1SYeTY+D0+URIfiqAajWFzbrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742893348; c=relaxed/simple;
	bh=wcSRVHryt2bmCq50gGdWBD1baQzrF0iPIIeTmkanllw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XJzqIBXzVplY4/9MxqGIorzRoXjhLAYln9TsUN1qX0raJikRZXgAOa4hWXOW0aTxHjemQnIJdd/mY8V2iDMqmXB4F/CyvlIvXWEP4eJiYQ6cBUhIRnxocrQttD05ioKf9E+q1QO4KSC9dJ8XussMQ29lhnU/2BTEK9PmHRwznxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cqIgXJhP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cqIgXJhP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742893345;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wj1IChreYTEW7S1AiPXdgyUmHcauFp5NeY4Eqtc9FGw=;
	b=cqIgXJhP6I41/vnODt3TOA0hERa5oE+mdkse31lW+vv646KnVDBGH7kL/2ueOxF3YtYX/2
	Y9+JnXDbRm+LyqNxNlkp3rWP409wuAyTIpc3rxhkjNS94HFgn9vraaUijlLm5wz5csV73P
	cgK82KnDkekbF/nE4tuML72nJ0hJDpQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-652-kRkda4_VNnGYh3XJ9W8GjQ-1; Tue, 25 Mar 2025 05:02:24 -0400
X-MC-Unique: kRkda4_VNnGYh3XJ9W8GjQ-1
X-Mimecast-MFC-AGG-ID: kRkda4_VNnGYh3XJ9W8GjQ_1742893343
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43cf446681cso29741805e9.1
        for <patches@lists.linux.dev>; Tue, 25 Mar 2025 02:02:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742893343; x=1743498143;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wj1IChreYTEW7S1AiPXdgyUmHcauFp5NeY4Eqtc9FGw=;
        b=QDZ5HzgAANb/y9Wp2Fi/ablR3X+viF9FwFvoC/cHRPYvLEFloQDqqFe/ZbX5uAb+rJ
         Kkal0uSTOujo6iSYpXtPY/41ZrzNCXy+TH2QxTIm2fHctcXkh5H4VWE9miKnRlK8kP/P
         ow2a+boZMky0jSof6GbClW+jfId6cp82ZYzIxsbSfqegXwU5g151dwBzk2qe6P0uts72
         ZLwawmotu75RKSW/lAWWuye9i8Ldafwui0U0dx2ZkQFfRNE0MuxjRViz4mOht1wE4zci
         gOjKtVSj3GdF65pHGAlqUMKSytEVPPkaI8HrLlsIvAjUx4OML+rOLXna8c3smKdmoJJz
         4/LQ==
X-Forwarded-Encrypted: i=1; AJvYcCVCrKd/2AOYvA4Ht+kgdjANvVCW9V79T9bLSkmn1MQjl27NZAnWLnl/OfYQvbuFQdYVOxO27vFc@lists.linux.dev
X-Gm-Message-State: AOJu0YyIN1pUwqmd9s/ibksRkGmyEsU9VXMatXm4XmJ+MeEhGJmFwWD6
	TSkYVryiBAmFjxdJufFq2jhXSIU+8QvCOx2SNGzvxEoVm6yYXd305FYUrlsSpyETM7EuPqQEAzh
	yVaf9SDjSYvAWR87Ge/+M+4dFFfDB2+fEsSpHYl3LK62U9YnYZeCpNfo=
X-Gm-Gg: ASbGncvrTWgWDX5r5ppdz5fjEq/br5U9QE+YkdCMooirS8oV16u3cSzdvG6tpkbMqCN
	HodEe2wEvfO9HNs5MuMVegrFk15trfc5jkt3yvRiQ5Bg4CZG+ZKkeFBSt4FuTBkfmdWssK6tUaf
	0MAotG7sI0/kJUlOIONY7s0WyZn7/ppXSzUhrjY6uQSMKNvEBvNRBO71l2iZi9Sep+BY44PSU0p
	r0uxsTDyFrxAzNCa4NLWNpTrb8B81x+gQnkQ/Qqz/ZfhaXKv4w80D7BDF5gYJAIU2ks6a1bTRcJ
	1UDKIhPY+K4DfTRhrSexYi5Qi5vSlkFejtcaz/XxAVJXMojWqkNeoGg=
X-Received: by 2002:a05:6000:410a:b0:390:e8d4:6517 with SMTP id ffacd0b85a97d-3997f8ff121mr13032937f8f.21.1742893343067;
        Tue, 25 Mar 2025 02:02:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEmIfLZm7khPWjwEcKM+sZzsNS9/OV7LqARaa/EFUtim00jKs/LTQtUTCr53eUD4BnsaUPNvA==
X-Received: by 2002:a05:6000:410a:b0:390:e8d4:6517 with SMTP id ffacd0b85a97d-3997f8ff121mr13032888f8f.21.1742893342596;
        Tue, 25 Mar 2025 02:02:22 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:c:37e0:ced3:55bd:f454:e722? ([2a01:e0a:c:37e0:ced3:55bd:f454:e722])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3997f9b409fsm13375318f8f.50.2025.03.25.02.02.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Mar 2025 02:02:22 -0700 (PDT)
Message-ID: <2628502d-5b43-41da-978f-66a68623889d@redhat.com>
Date: Tue, 25 Mar 2025 10:02:19 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/10] drm/panic: add missing space
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
 <20250324210359.1199574-2-ojeda@kernel.org>
From: Jocelyn Falempe <jfalempe@redhat.com>
In-Reply-To: <20250324210359.1199574-2-ojeda@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: W3MfbuPUV341PS0mY--E24W1xsVwTWcVbKSDwWUDs-Q_1742893343
X-Mimecast-Originator: redhat.com
Content-Language: en-US, fr
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24/03/2025 22:03, Miguel Ojeda wrote:
> Add missing space in sentence.
> 
> This was found using the Clippy `doc_markdown` lint, which we may want
> to enable.

Thanks, it looks good to me.

Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>

> 
> Fixes: cb5164ac43d0 ("drm/panic: Add a QR code panic screen")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>   drivers/gpu/drm/drm_panic_qr.rs | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/drm_panic_qr.rs b/drivers/gpu/drm/drm_panic_qr.rs
> index ecd87e8ffe05..9bd4d131f033 100644
> --- a/drivers/gpu/drm/drm_panic_qr.rs
> +++ b/drivers/gpu/drm/drm_panic_qr.rs
> @@ -5,7 +5,7 @@
>   //! It is called from a panic handler, so it should't allocate memory and
>   //! does all the work on the stack or on the provided buffers. For
>   //! simplification, it only supports low error correction, and applies the
> -//! first mask (checkerboard). It will draw the smallest QRcode that can
> +//! first mask (checkerboard). It will draw the smallest QR code that can
>   //! contain the string passed as parameter. To get the most compact
>   //! QR code, the start of the URL is encoded as binary, and the
>   //! compressed kmsg is encoded as numeric.

