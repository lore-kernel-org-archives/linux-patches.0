Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74ED7C
	for <patches@lists.linux.dev>; Fri, 19 May 2023 00:28:51 +0000 (UTC)
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-6ab1a0985eeso1999697a34.1
        for <patches@lists.linux.dev>; Thu, 18 May 2023 17:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684456130; x=1687048130;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OSFENBt/zyLmxBAw3RVTXpbG4Rk4EEr4uJ7eZEA1Bvk=;
        b=NsA92l2NeEZt3bLIWlShHKqkIN6z/yTqVBwk4rcmWb/bIkdk0QTF9J2NjYr7Mf02Vx
         IcmZY24N1xJa099XLoMMlaEDrv4lWsTJ4gyqfumkU6TeCAm71JQDZQ25JgzOxwH+9dR2
         a0XSJ55P7rqCroaDSbk78vkTRqXl4LCGV0rtyrnF+R6Pz1IfI2lhg7o36f6R9wowRo1d
         1AwxYXagUtb0Mzz2hvUNEBycdWuNf/JmG1zNxPjdpoSwm55t4SvKJUsBVeKVwVexZ4d9
         4P0bA0irm1dMcABjxdhokgThO4zdh6VJiLf7JXyJoZ2Zx5Z2u0SmiimrLx2/2Yu1SmOK
         ghLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684456130; x=1687048130;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OSFENBt/zyLmxBAw3RVTXpbG4Rk4EEr4uJ7eZEA1Bvk=;
        b=aE4UypruCQKNit6ArwRsAJ1pR3soF35Q/Xt8tA8BzD3AwdEYv2Lgu869YCVWnNjO4m
         sW8uh0HHA9f2i0JggoINT8xXFrvj9ndueRwd6hB39ZM6iOfx+gH0IclNg3Zcu5aDDZF2
         O5gNOpwsc/fG6VD/44jHBCQxaqXCeHihQroLBDotZvxn1IGGM/NJ3URSvNDPjpIy+oEN
         +dCxjHDsCr3vn6huaoLaNuPGkEw4/KGeIDI/Qq4gtrICVEXw07eYiBPPcK1a1E3ECkBZ
         42fEcQ/rM6+Du98OVKaRx4CKBrxvKDRP0TL/g6RX3QfeWuDpdJy/7DDdjaQQgHdtiOzT
         Rs6A==
X-Gm-Message-State: AC+VfDyMc57j15+CrBd+sGsX6poOQzZpcgcAaZG5LfyQ+2tLH75GuWro
	J6Oijhx5cNaZthMwpB7eFsc=
X-Google-Smtp-Source: ACHHUZ42ZxwdYP/yb7j19gJwj6zpvdzcAaklXDT2EJzihujviHWGn2qVJpzJ0h/eWiTZuHnPgas6/w==
X-Received: by 2002:a9d:7ad1:0:b0:6a4:2e3a:6e29 with SMTP id m17-20020a9d7ad1000000b006a42e3a6e29mr162554otn.24.1684456130654;
        Thu, 18 May 2023 17:28:50 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id r4-20020a056830134400b006ab36a64f6bsm1173608otq.51.2023.05.18.17.28.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 May 2023 17:28:50 -0700 (PDT)
Message-ID: <f73f1caf-a1a5-5bce-58af-2a961c301789@gmail.com>
Date: Thu, 18 May 2023 11:51:42 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Subject: Re: [PATCH v1 3/7] rust: sync: add `Arc::{from_raw, into_raw}`
To: Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho
 <wedsonaf@gmail.com>, Tejun Heo <tj@kernel.org>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=c3=b6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <20230517203119.3160435-1-aliceryhl@google.com>
 <20230517203119.3160435-4-aliceryhl@google.com>
Content-Language: en-US
In-Reply-To: <20230517203119.3160435-4-aliceryhl@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/17/23 17:31, Alice Ryhl wrote:
> From: Wedson Almeida Filho <walmeida@microsoft.com>
> 
> These methods can be used to turn an `Arc` into a raw pointer and back,
> in a way that preserves the metadata for fat pointers.
> 
> This is done using the unstable ptr_metadata feature [1]. However, it
> could also be done using the unstable pointer_byte_offsets feature [2],
> which is likely to have a shorter path to stabilization than
> ptr_metadata.
> 
> Link: https://github.com/rust-lang/rust/issues/81513 [1]
> Link: https://github.com/rust-lang/rust/issues/96283 [2]
> Signed-off-by: Wedson Almeida Filho <walmeida@microsoft.com>
> Co-developed-by: Alice Ryhl <aliceryhl@google.com>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
> [...]

Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
