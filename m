Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669D4AD28
	for <patches@lists.linux.dev>; Wed, 17 May 2023 20:46:57 +0000 (UTC)
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-199dd37f0e4so917914fac.2
        for <patches@lists.linux.dev>; Wed, 17 May 2023 13:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684356416; x=1686948416;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tOWjDaNo3/cJ5irwgAWSl2hXx4QRdUNNrZTKP14O2Xo=;
        b=DKhNLAOxM7f1QqxL7ESIoOIpDxHgo31eq97FmRl6lrjFs42gZeymo5Y0DuuXWMPsVt
         qFW7Gm3we0p+BJ/HK2pzFKC8LM34kFMYICsOSq6KWoDmS1tvNric1jAPpMdNZS9OtWCt
         iDg9+/XmCTklCtzCDH9T3BGqgJ3lmtFKIqxmhVuNSdzpBN6hrpXR3CKylIw2efJPBVKB
         Imj1pATGnSmMHr83gCVz0TR4Uz3/e9hjym2wy/LIVbPnKc4IYLknJ0vrzo7NKDZoeGl4
         XnqphKA/6CJtr5/o2GZ0yn8YXwgmYnnD8vTmCfMBotd6RCNZ3eSzXmzRLUq9mQ+2eFOK
         i0bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684356416; x=1686948416;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tOWjDaNo3/cJ5irwgAWSl2hXx4QRdUNNrZTKP14O2Xo=;
        b=lEKsCOZtdahfAia5ZV8ipgCDdqbfoa86H7/nUTT64i+X/uCegJn1YFlUnsLQQfNxmc
         5mll5tmWf96shgqGGOQt4i7eSxTwQBMCVVfiVLUmQxVOvaVC9fmjyr3Nc84Zc6zPV9iz
         0zprP5P5QHOgPrhbUJ8vhxyzyL2J7H9VwM86Gre/Wts/aCXXdxO3i6FYoEGidHAakUEK
         Quzevygnp8/tTKwSoYobUI5hbZH8JcIxldQ6xtSXBXfXxs9feV/9/HdCbusj5glJISFL
         tPL9SP3j89CBbsE1N/oMNHXPpYfwrNUrvgtN+fLP6BepWPruukSOi3/47U59Uv9XpwiO
         IWUA==
X-Gm-Message-State: AC+VfDxCwYghGPrxIOvN2C2iI+1AA7CO9e0J0sDsH5hDHv3lL++Hyo1+
	l1wSXalNgO45VLm/sVQVa7Q=
X-Google-Smtp-Source: ACHHUZ4Fy1lnnqBoT3R7pNo7eHnEXuk2Q1IeKoNRk5GFRNws5g5Z4uFR+rwa2Fery3DNzuDAMENGuw==
X-Received: by 2002:a05:6871:8504:b0:192:b536:259 with SMTP id sx4-20020a056871850400b00192b5360259mr96231oab.19.1684356416433;
        Wed, 17 May 2023 13:46:56 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id g15-20020a9d6a0f000000b006ab1dd9eedesm9048otn.49.2023.05.17.13.46.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 May 2023 13:46:56 -0700 (PDT)
Message-ID: <ed7b485c-a700-ed59-5480-01417977fa41@gmail.com>
Date: Wed, 17 May 2023 17:41:11 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v1 1/2] rust: sync: add `Arc::ptr_eq`
Content-Language: en-US
To: Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>,
 Wedson Almeida Filho <wedsonaf@gmail.com>,
 Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=c3=b6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>, Will Deacon <will@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev, Wedson Almeida Filho <walmeida@microsoft.com>
References: <20230517200814.3157916-1-aliceryhl@google.com>
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20230517200814.3157916-1-aliceryhl@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/17/23 17:08, Alice Ryhl wrote:
> [...]
> +
> +    /// Compare whether two [`Arc`] pointers reference the same underlying object.
> +    pub fn ptr_eq(this: &Self, other: &Self) -> bool {
> +        core::ptr::eq(this.ptr.as_ptr(), other.ptr.as_ptr())
> +    }
>   }
>   
>   impl<T: 'static> ForeignOwnable for Arc<T> {
> 
> base-commit: ac9a78681b921877518763ba0e89202254349d1b

Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
