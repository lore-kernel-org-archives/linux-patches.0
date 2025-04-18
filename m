Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C96213E71
	for <patches@lists.linux.dev>; Fri, 18 Apr 2025 15:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744991557; cv=none; b=am4Dn0EXjMvsIBPZaVN7oRTZe2qBuszV6LaDSoDCk+0264s/xDpjJsc6JesHFpGea6jrRshv6LwdGDVxNShySkgQOlf8fiKwvWFyhjeH3VJv1uWczmPMhmw3KX3bUxJ64AjK0S3RsTyjwZQ0an6NBI6cHgpgsPMCYNhkVCEVTqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744991557; c=relaxed/simple;
	bh=F/FqzNZ9qlnPa1jemkgvzEU/JpEsiXoIVKP/J4XS9H0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Lw/SQfHjSe64GGNhVFQG6ABE1tW5yMlrQCo7CLIN1/5xvwJ67vUc68VPHUAhxx+UYFTZA4h7LxzR7usXY+ReJOFrPDrxunA21SPW5eHorfqlU4qzmpsjCjNm1d0ExZnngVqPUoF6OXfnSKnkPTX8JikVDigs2yaL4Q2cPphSYRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N0u+B/TN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N0u+B/TN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744991554;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1wc26qQbycqhuxkUDZ6Sh+SUpqvdXJSaAUblqosEd3s=;
	b=N0u+B/TNvBR/ightFvb3CU7X9BRk+DW3HNHhWi4gxkgmKSAodKpLR5lgaehXM6CWr3KHSh
	PrGBbtEdCISPgF7MZNMGCQkJ69G6INYuGrOeji+jnsBCPgK5uW2CSFvoW7ec3XmXPnNggc
	WyiwlIDhawP8Mzt1a3e3nBIy3f+ct/E=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-668-OHPxO60gM66tvkWwDkNWSw-1; Fri, 18 Apr 2025 11:52:33 -0400
X-MC-Unique: OHPxO60gM66tvkWwDkNWSw-1
X-Mimecast-MFC-AGG-ID: OHPxO60gM66tvkWwDkNWSw_1744991552
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-39135d31ca4so880702f8f.1
        for <patches@lists.linux.dev>; Fri, 18 Apr 2025 08:52:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744991552; x=1745596352;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1wc26qQbycqhuxkUDZ6Sh+SUpqvdXJSaAUblqosEd3s=;
        b=XmwohKJwwX0qLoCvHYf37QJFR2bneGgVoV2su+4YlcQeFfFXQdDLhLsB4zejgVsDDO
         Elj87DekBlXQ8VTgkkOSqxZLe9gURI3Eh0kYp8hZg2bi5yPkSnuAufYYTwGoGnB8lJ6W
         AJaKqDBzkM9l/Bn5JZzLTDThyBYrqRuOSMtfOJAh4rtuuREHbvud9VdXaasOvLR/uVSG
         FkICLFysBa0vmM38Z5JFqkV4p+1GDN6UNUpwM5YgkfFieA+9cMCg9weqOvu6k/bx640X
         ADS+njuPd4ePCInOR4m97P0ScdQxb5sC229PfMjitoOsGnELPdABVM6uPKmPO/cpm/1u
         rQXw==
X-Forwarded-Encrypted: i=1; AJvYcCVI60v5HwSjPXCNK4KqEwV3Sjx86UUU9b/ndI+pwJeNOLa5DDXECsx5uAtxX173Dg20kQJvFCAJ@lists.linux.dev
X-Gm-Message-State: AOJu0YyjNHOeUYu81e0r0ENOJj1jh3NXyUlxOUocNVUzXgv426uRHXMq
	tBbhKOGs62YDfmXdQlyWwVjcu35J+2hsTQFKOYm+B5/ySVIUI7EV3gWPilN7SzV/99dO81dS9nF
	EKp4meikP5gct1ZGJtknzaC36aQQQ2AezF8iR2xViL9a+CPjXBsOX6Hg=
X-Gm-Gg: ASbGncuPKSLc+RbWHxnUH96jEq+aJpC1s3fJDI95UtzlsmaAXEEEKBAIIaaEHDLdnbj
	NUM1x2AnTmVmQKiqvpVONusg+Z+WvlcdZuixyqB8P0DonyuQrfCZva+MmtyNvacgks9l64yav29
	pHyF7Ehga8wI2qxYCUo13lZoGqW4GZJc3VuvH0Z71+se7Ri/tp6lqSi5pjhU08OeosTAN6ErVjM
	ldIs6UTLfaDwHdtwggt+zJONoDQRKqLVFwVsvcwM5H2oZXmLZZuWZ7TN2VuJdYcdxHhNWcQT9Pb
	lBOpP394ZpVtxF6DNDGf/nvU8YZ+L27R/DEho1rUasCd1xXg4J4=
X-Received: by 2002:a05:6000:1886:b0:38d:e3da:8b4f with SMTP id ffacd0b85a97d-39efbd007c0mr2568840f8f.0.1744991551745;
        Fri, 18 Apr 2025 08:52:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF8hJOtqgZKvHmMFX8Sr5+SXl0HJhOYBEusxbHJ4Nl8XaJ3wP71Jpwu6vFmp9aQLWT50/PDaw==
X-Received: by 2002:a05:6000:1886:b0:38d:e3da:8b4f with SMTP id ffacd0b85a97d-39efbd007c0mr2568820f8f.0.1744991551365;
        Fri, 18 Apr 2025 08:52:31 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:c:37e0:ced3:55bd:f454:e722? ([2a01:e0a:c:37e0:ced3:55bd:f454:e722])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39efa433191sm3168492f8f.31.2025.04.18.08.52.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Apr 2025 08:52:30 -0700 (PDT)
Message-ID: <7be276bc-4c55-4144-ac29-b734b1f44667@redhat.com>
Date: Fri, 18 Apr 2025 17:52:29 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] drm/panic: use `///` for private items too
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
 Miguel Ojeda <ojeda@kernel.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Alex Gaynor <alex.gaynor@gmail.com>, dri-devel@lists.freedesktop.org,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>,
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <20250416122106.2554208-1-ojeda@kernel.org>
 <CANiq72msZ7FUo0=KXQjMkXjfm3jVaNhhVDCu_BFXRTL_xC0vog@mail.gmail.com>
From: Jocelyn Falempe <jfalempe@redhat.com>
In-Reply-To: <CANiq72msZ7FUo0=KXQjMkXjfm3jVaNhhVDCu_BFXRTL_xC0vog@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -cSeb2VuvBrT-iVW6O8aLiOf5TqyBZ6OhRzQrQ3TCXM_1744991552
X-Mimecast-Originator: redhat.com
Content-Language: en-US, fr
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 16/04/2025 14:24, Miguel Ojeda wrote:
> On Wed, Apr 16, 2025 at 2:21 PM Miguel Ojeda <ojeda@kernel.org> wrote:
>>
>> `///` should still be used for private items [1]. Some of the items in
>> this file do so already, so do it for a few other clear candidates in
>> the file.

I just pushed it to drm-misc-next

Thanks,

-- 

Jocelyn



>>
>> Link: https://lore.kernel.org/rust-for-linux/20250416112454.2503872-1-ojeda@kernel.org/ [1]
>> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> 
> Sorry, I forgot the Cc: Jocelyn (it could be nice to have a
> `MAINTAINERS` entry for this one).
> 
> Cheers,
> Miguel
> 

