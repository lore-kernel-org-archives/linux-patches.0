Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56B2161
	for <patches@lists.linux.dev>; Fri,  7 Jul 2023 00:03:15 +0000 (UTC)
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-56368c40e8eso911090eaf.0
        for <patches@lists.linux.dev>; Thu, 06 Jul 2023 17:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688688194; x=1691280194;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z0xeKtw/QKzo9rX8om008UjxAfMA64TNu1z2SedRUUU=;
        b=WE4WfIGHEStb4rbtrszjII2ACnX3KDz6sv1pyDsT1uD5lcWi2z6ZR++awNP7Z7lDnT
         8KoyxNfiCUBEVMLus7BHqz0ZIB5mHzwq3yWD2NKLtbqGxmdITk7BFTU6BcGaUK5aXW/k
         HolzyHN1owEPG/FgPPphenMKaOIcsZozErVkeby6m8knBCAdX6ZiEiBQIRvvKiWX/pN5
         e/kmjNbDcXAiXBKW9npW03NGc9g3Pj2RC+9zUun0VrLJnUGAPZquYGPVQWZBhm0CGxrO
         XVePmvMGRPde5RizHtR2IVsuM8+yBKKrTV/TnZ6pEbhQDK1ik4ZfdSWP18qGgyGjIy/t
         KTKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688688194; x=1691280194;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z0xeKtw/QKzo9rX8om008UjxAfMA64TNu1z2SedRUUU=;
        b=a9Xx30xq0XoQRbBnIPAEae0qvWwEnV+1Kup4/A25GVwPjp7jq/0mUgPk8/NwoEOYI0
         gzSwTcn4+ttqi9tOQpQr5OXnRn/QXFTBbxL+CoJKRxiRyYL2T+nMgnFMBHPw7WzMCvGu
         o4nS5qr981aCWqdlREQ/87k+nOALacD9+hlpc2I6YJX4QOYuiRkBbPSacQGzkI7nW4GN
         JSQk+fVqRlGPVfZLSb4+IZRRIMHgwgzAkFJSfzw1V05LWLODL9w/dulJVUdsp+a6qR9E
         yBtFZo4GwbNB0tuM241ikuSKBa/C44lEbUZbfyh6DIkVawsPBT/gaIMLVlXLNhSa0kYT
         jQqQ==
X-Gm-Message-State: ABy/qLZsc+AXXfDU/kx0j+ItQDvlUYD2dxEuZtZeVMPvIgpGE/Gh7hGC
	rC5rkpzPsacwQE8Dod2q2TM=
X-Google-Smtp-Source: APBJJlFXPrJCt4o7nGUeqRp683jCbt9adEX+CBk/cxVXAoT15ll6Hv8vh4gBsTSocoWhF1ajHOrJTA==
X-Received: by 2002:a4a:4f0a:0:b0:562:eda7:52a4 with SMTP id c10-20020a4a4f0a000000b00562eda752a4mr2382893oob.2.1688688194530;
        Thu, 06 Jul 2023 17:03:14 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id l2-20020a4a4342000000b005634ef4f1c0sm1067284ooj.31.2023.07.06.17.03.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Jul 2023 17:03:14 -0700 (PDT)
Message-ID: <298e5b95-19e4-f2a0-4994-cca17b27213b@gmail.com>
Date: Thu, 6 Jul 2023 21:03:10 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] rust: delete `ForeignOwnable::borrow_mut`
To: Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho
 <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=c3=b6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <20230706094615.3080784-1-aliceryhl@google.com>
Content-Language: en-US
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20230706094615.3080784-1-aliceryhl@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/6/23 06:46, Alice Ryhl wrote:
> We discovered that the current design of `borrow_mut` is problematic.
> This patch removes it until a better solution can be found.
> 
> Specifically, the current design gives you access to a `&mut T`, which
> lets you change where the `ForeignOwnable` points (e.g., with
> `core::mem::swap`). No upcoming user of this API intended to make that
> possible, making all of them unsound.
> 
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
> [...]

Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
