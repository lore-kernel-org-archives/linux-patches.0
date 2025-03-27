Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F37189915
	for <patches@lists.linux.dev>; Thu, 27 Mar 2025 15:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743088972; cv=none; b=A7ASryQzU9rkFG7xulEUi2xpQDONPZPG0jESE5ZR4JjGgpNN9pQ03iyLWDuyfC2uPV02jXro7JumlVJ+cblC1jEzpy3Ogw6C7898KTNvz9hofwUjviakC5Idw7fj4Dc0AZOM8n5HPg3Bzw91JNIvkTCy9H2xiHQYaF+cU1rZBTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743088972; c=relaxed/simple;
	bh=1nGruMCbppY7qn4neYE0wvu8NfeEHt8bZVd8Orps9qk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UZs8xfI5+dXvAg3jvVn6FmzfB99RmMLTYfE2gFYll5GEok67Ee0pY3UWKksCQ7MQIkGGQIhvxNkJ9BXIDhra0jiTBVFkLn4+y/VjrbNv/mSirZDHHIJm2l6jeBU0oCoRIgLBKG9yG6AcVmDiQXMPARiCJwUq21sDNIooqNrfLS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aoJjBXvT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aoJjBXvT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743088969;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KyIB6mZ7OHIQ8TN1E0AWKE682onUFLQ3XEbxIz51DMc=;
	b=aoJjBXvTG6ZabkrU6jjp2FKkMwfICmt9aNTrfHqMv7BVc/7Z6s6PX+nf1KYQSNT7w6gAYr
	3yyfrr6M24D2/YWWX+B4Y2yAAmNVvt7U9Q7Q6VEZ4KLmiSPZqZQ4JWNZAYWZlibccnB2nd
	RPyfNc5JXN94i09798iZYfOaOhlN8GA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-267-xJHPyb5fOfm0baSKVxmVKg-1; Thu, 27 Mar 2025 11:22:48 -0400
X-MC-Unique: xJHPyb5fOfm0baSKVxmVKg-1
X-Mimecast-MFC-AGG-ID: xJHPyb5fOfm0baSKVxmVKg_1743088967
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-391315098b2so490518f8f.2
        for <patches@lists.linux.dev>; Thu, 27 Mar 2025 08:22:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743088967; x=1743693767;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KyIB6mZ7OHIQ8TN1E0AWKE682onUFLQ3XEbxIz51DMc=;
        b=JqX+KWa5fFcw3X/7s8dvYhjCGTO1QkCztl/j0r1wcInoi8W56+Uzcp8IbxKWR3xqYB
         LGXpHvViphqN1S3ng8edm/Ap1OMlhfdKvon6dGw4r37VJ3WBQFaJARGqVw/84x95SPNO
         8KiFp4NyryXgrwGk6SPD/zJkEbg/PMaUkJ/l+g/B8prHecz07rHYe3e1hn+7M3c8LGkn
         TQCP1D7Njs+C9hlyLYQZ8i3Bo2FTmhctJP79RDtmd4TeSQ9OKKW4LZoAY7YjJzCOSI29
         93eJSJO7+ZeD9nCY5hJHI8Ef/qgSs69+sM0qm6NZpIfIAe2y31GAQBs4sE9IJ3aSAHLk
         H49A==
X-Forwarded-Encrypted: i=1; AJvYcCUhx2JLJ9JU/eI7nrAHzvMw7VKmlEcgehWuDMNy2gKRReU2nvj9kHhRQr8e+OUOLwqiHIh1XImG@lists.linux.dev
X-Gm-Message-State: AOJu0YzltuAK8T+IRkzkyWs09SZP2ETcQxw7BHBi8ZIKu/pNYT6gxsGP
	IaEfoi6nX2gc0XpRqt7oKOZ4qPoPbglzErf5ASKk5ebW4iqaJSpOG/8k5pXZ84rJ9PBkHDgIEQl
	yYJquRs6jrEXO+vpHkbMhjM2yw+3UhMEwFn9Cm1D0EliWIEB3g8zQoYA=
X-Gm-Gg: ASbGncvzlUd0V4WHD+7w3CBUiKI64Xh1jiS9P+BaZWXnk10LHyq8nNqsgKDnxMQYE4+
	zgpx+Z4r7lZ3ElxnO3+k9EQK3RmewUyrhyq2JB7T6gI51pW8pv/+dvvvomuWJ+bXKMWW3k8JxLT
	UspwA8Q7qkYHe2YTKcbLUeO6hoWo2rqj1saLsn4i1C3XAB48e99D8oTi+gTi+rT4otYdi1t0SGr
	qd9CCJAt7Jm0rR5wkqupHj4RaUNHBKCJvsgaG4rtH7Amrh3sQ6m1USivXPm4XdB+lFexvdcdA72
	PYJY1AlCuOC8WwJ0FTQt6AEIGGw30QZHP+xKM/Cxswhj/kyOUPBKYFM=
X-Received: by 2002:a05:6000:1f88:b0:38f:6697:af93 with SMTP id ffacd0b85a97d-39ad1740e6amr3598507f8f.9.1743088967257;
        Thu, 27 Mar 2025 08:22:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF9Nh306S6nC8D3y6/2MymAxytzfH2EE+T7OhkoPuApxgDdG2zQZrGWFxbxp5lSU2j1CNBGxg==
X-Received: by 2002:a05:6000:1f88:b0:38f:6697:af93 with SMTP id ffacd0b85a97d-39ad1740e6amr3598456f8f.9.1743088966782;
        Thu, 27 Mar 2025 08:22:46 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:c:37e0:ced3:55bd:f454:e722? ([2a01:e0a:c:37e0:ced3:55bd:f454:e722])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d82dede98sm41019095e9.6.2025.03.27.08.22.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Mar 2025 08:22:46 -0700 (PDT)
Message-ID: <a495133b-7fae-4b88-8254-78d65677990f@redhat.com>
Date: Thu, 27 Mar 2025 16:22:44 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/10] drm/panic: add missing Markdown code span
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
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
 <dd1616d5-4808-46be-9167-6fbfe76e0c73@redhat.com>
 <CANiq72kz9SW8Rexj7feZRvTAhgF+cBwarpFnqu0TSk6C2r9SRQ@mail.gmail.com>
From: Jocelyn Falempe <jfalempe@redhat.com>
In-Reply-To: <CANiq72kz9SW8Rexj7feZRvTAhgF+cBwarpFnqu0TSk6C2r9SRQ@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YPyyZxINEkYRFbuXi09b1gOgLf5KB5rTZ7VnH6i80J0_1743088967
X-Mimecast-Originator: redhat.com
Content-Language: en-US, fr
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 25/03/2025 20:04, Miguel Ojeda wrote:
> On Tue, Mar 25, 2025 at 10:05 AM Jocelyn Falempe <jfalempe@redhat.com> wrote:
>>
>> Thanks, it looks good to me.
>>
>> Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
>>
>> You want to take the whole series in the rust tree?
>>
>> Otherwise I can push the patch 1-2 to drm-misc-next if needed.
> 
> Please take them if possible, since others may want to take them
> through their tree anyway, plus it should have less conflicts if you
> change other bits, plus these are independent fixes anyway that can go
> in on their own whether or not the lint gets eventually enabled.

I just pushed 1-2 to drm-misc-next

Thanks,

-- 

Jocelyn
> 
> Thanks!
> 
> Cheers,
> Miguel
> 

