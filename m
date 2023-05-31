Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2A22578
	for <patches@lists.linux.dev>; Wed, 31 May 2023 19:08:34 +0000 (UTC)
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-1a208e249e3so132031fac.2
        for <patches@lists.linux.dev>; Wed, 31 May 2023 12:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685560114; x=1688152114;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VQpBRBiUI2V7LS3F3uEGBbOSqBEboVJ5Y6bOHcSXqj0=;
        b=l7G5U07jd0Hq+nLti5+Q4XkcQ8oPuzIpAHMGCUoor0JOwvKwLXW57cg6gG+v2aHRPI
         sCe3onbbXZ3fm1M4PyfuFRumw8guMMcrTAPqVn8OxwBpM/DsZBF4IG75onMUyU6858Gv
         p7ETmWFvMIu5dpFWabOIqyJXjULkUxexwzKv58HB22GKTJQEpxqocMQottkUV9pf0CnV
         AExF9wQFoeA6RB+UEigPqoX9RNELF40E0yek2WJ/GZsd5kksON1A5W11U0WuyxJ2u67R
         7UVfwiSEjpeJwUUtB9a9LTgxXbUXuR4vq6ydZCNnlh7jYXvfkhOUvV4v22V9R5exBC66
         /C0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685560114; x=1688152114;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VQpBRBiUI2V7LS3F3uEGBbOSqBEboVJ5Y6bOHcSXqj0=;
        b=XWETVclrn5VK3QxH7Jrd8M4pCGX0uLUwRkuvfyaXcXmFHvux++Tfijg6voQQNzmVyY
         qQnkb7Mw5H7nayvWTBS3h4W1sq2E2n3GpSytcBrTTIyYLDp6ZuHTVP9lBCtvAzqaI1Yh
         fx68gRS4UrK5YA8rWdVg1UQU5CD62zBoEqz+kkX2yJFYJOOFO9y9Yy919Bw+8eosw+k3
         ibxECJbGJGrg7VJb4sc+zNa2qDUzXHUfTwPzB0UoWNjqFT/0WIgUCs3bEcmiB0Nzjpn5
         REsmXHoF4IMReT8CaxE1z7AjoiOExqzp33JWXQ8InPy/srpQYupbDgIV6YNGsBF9LbC5
         gWGg==
X-Gm-Message-State: AC+VfDz7RJE4oV2raBBJ1YpbWNjUAd4gPqmOeIsKULk8GMWAp38umhyH
	3jYInI/1p3ZrSlsDAafMWoc=
X-Google-Smtp-Source: ACHHUZ4N/tUMZbG0loQlfqUR/SHUVvNft1dc/NpUkWdBisWgrIM65SU8M0mb3uNClrGMVLOSZp3Xuw==
X-Received: by 2002:a05:6870:9894:b0:18b:1936:30ee with SMTP id eg20-20020a056870989400b0018b193630eemr4883265oab.56.1685560113987;
        Wed, 31 May 2023 12:08:33 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id d7-20020a4a5207000000b0055554a51353sm7114205oob.1.2023.05.31.12.08.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 May 2023 12:08:33 -0700 (PDT)
Message-ID: <de3a8297-19dd-4854-3311-492ac0875e40@gmail.com>
Date: Wed, 31 May 2023 16:08:29 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v1] rust: error: integrate Rust error type with `errname`
To: Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho
 <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=c3=b6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev, Wedson Almeida Filho <walmeida@microsoft.com>,
 Sven Van Asbroeck <thesven73@gmail.com>
References: <20230531174450.3733220-1-aliceryhl@google.com>
Content-Language: en-US
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20230531174450.3733220-1-aliceryhl@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/31/23 14:44, Alice Ryhl wrote:
> From: Gary Guo <gary@garyguo.net>
> 
> This integrates the `Error` type with the `errname` by making it
> accessible via the `name` method or via the `Debug` trait.
> 
> Co-Developed-by: Wedson Almeida Filho <walmeida@microsoft.com>
> Signed-off-by: Wedson Almeida Filho <walmeida@microsoft.com>
> Co-Developed-by: Sven Van Asbroeck <thesven73@gmail.com>
> Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
> Signed-off-by: Gary Guo <gary@garyguo.net>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
> [...]
Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
