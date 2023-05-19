Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0C27C
	for <patches@lists.linux.dev>; Fri, 19 May 2023 00:29:13 +0000 (UTC)
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-19a08412723so2153335fac.0
        for <patches@lists.linux.dev>; Thu, 18 May 2023 17:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684456152; x=1687048152;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EbAo41j9dwaocJzq5AJ7mE2sUYUnT4TmOl4fPIqDs6s=;
        b=kTOQ732NQvlCQq8Zzwc9xoIYIcSmprkzUZG30JzSBdEgY2MmtaPfV0f3oysoGflmm/
         acHaoeFG/jlLweltf2uVCVj5AulWWpl27cfd/70YzZQc2p/+ok93tpzXCPwU/U7MmIiq
         /C/fmMzbXvca+xixezrYHLNyFW/2EXxmbmHCA3XPG0eR1EAKTrULfDAZwrqiRO+I/xJ1
         ISEWQhIRibpp5HlMeDBYu0wuUV6ihxFTG883bJgbUexDaBY0rUXKz0mJO04Ty5cwUzVR
         NA3krUtJ9U/mc0K6fOgkEQLE1gY6+flTFftaFQ3SM920uMXopx07txrBlP0BL/N752yb
         1RBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684456152; x=1687048152;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EbAo41j9dwaocJzq5AJ7mE2sUYUnT4TmOl4fPIqDs6s=;
        b=FjshGN6Z3zMSdFrr5teyR+H9rdI4jycqRqAPrRZLydJ0+dPjdyyNP9g7DTrIRL7+WX
         1+N2wQiLJmJkZEbhSEMz3/PU4ik7yuGkcimg1mJnr0dRmlqwJbuCjI8qbJGg8CZhGae+
         D5AYM2EGoASbDvjIuRj9HCOUqseCGLaqFJDWuBKxUDPO302UaAmhTra4Tb/ttajsMnnR
         7C/siH30z4er4n92wo1dOMpk7D4w4TIAAVdew7oHb/b41Lxbmk5FusbKtRQp/SZKnP98
         s/bK/u53sp4J8OMpJ8RcAiKQduXJWOGb5sHAdjEfnu/2XJpaRzIuFXAboBCH/OVoEWIR
         LMLQ==
X-Gm-Message-State: AC+VfDx7Q6VhAYUeixxI/T26zu931OI82WVDuVAEqQ1iMCR2lcq5y81N
	oImOGZEQfEkjiC37xl1Csdxn8+lhdQg=
X-Google-Smtp-Source: ACHHUZ7R0NSRLuks3+Tvx1V18EGuJSFwkjrX+Vq0Aw9bVeQUXZre/pcYUkY2csM5F5hPc5AXhjt8kQ==
X-Received: by 2002:a05:6871:721:b0:196:331a:b8f5 with SMTP id f33-20020a056871072100b00196331ab8f5mr326266oap.3.1684456152497;
        Thu, 18 May 2023 17:29:12 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id oh16-20020a0568702c9000b0017ae1aede32sm1376614oab.46.2023.05.18.17.29.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 May 2023 17:29:12 -0700 (PDT)
Message-ID: <85aca422-6799-a2dd-cff7-99e0ec564ff4@gmail.com>
Date: Thu, 18 May 2023 21:22:33 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v1 7/7] rust: workqueue: add `try_spawn` helper method
Content-Language: en-US
To: Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho
 <wedsonaf@gmail.com>, Tejun Heo <tj@kernel.org>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=c3=b6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <20230517203119.3160435-1-aliceryhl@google.com>
 <20230517203119.3160435-8-aliceryhl@google.com>
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20230517203119.3160435-8-aliceryhl@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/17/23 17:31, Alice Ryhl wrote:
> This adds a convenience method that lets you spawn a closure for
> execution on a workqueue. This will be the most convenient way to use
> workqueues, but it is fallible because it needs to allocate memory.
> 
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
> [...]

Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
