Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F9A219ED
	for <patches@lists.linux.dev>; Tue, 24 Oct 2023 18:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gj6cLlTP"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6b497c8575aso4779466b3a.1
        for <patches@lists.linux.dev>; Tue, 24 Oct 2023 11:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698173320; x=1698778120; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DFRAuWK32VTGr08EDsBUV/zh4O1jsXdg+48RuQhbEtQ=;
        b=gj6cLlTP/eIOYtA55uef1GGP7NVjmdtCdBLFBptyEjCAgRMPz9GxoIHSs6JWfsX6gt
         AAydrsXbto4chpSt+l/6GSVpfXVnV25Q5PmY10qT1Pne1/0VJgkOqKZA/2D5Jw2/kQyO
         eECUITtquITowKsp67zAEqhs6pBYO74EqV5kzjIZbNSgkif5n1fOF7YVsKf8Fn3My9nb
         ZyKQKAm6hXrxiBmVnZ8Y+0XIbYWczmD9SwlnmJBe9pfGPL8EevA+ps9P1cENW2pjLiXi
         Bdzwy1GjizhbWdps3HW5R+btJhF7rUGbgGCiqvJPotRBC34ChTBqjeT6zm6ei8nT181V
         hVKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698173320; x=1698778120;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DFRAuWK32VTGr08EDsBUV/zh4O1jsXdg+48RuQhbEtQ=;
        b=rJRYPHYR+4s/8YY3jJRXmsyd7T4G31iEJdngK1/7IXAxDVFtGVNkX/YAc6O1zyKjwq
         UDP3jH0Lx4YRx07oaTEfFk47O7x2B828zj2YJ4K+PlgwlgVdppjlOBb+kp5101mK4+Dx
         2IS752Apt6tdvDuk+oD2BsDaGVMULBCu6QfmZV8ZO+8m899hwzX0wGfXIDWKrh9a9aOu
         rh386alzY55Y2Lm0rojc4JBRe7dT9U00cf137+ZkosY91B6qcAZNRPFRnVR+tKBCdm8n
         zo3Z+88aF9kT9lXr7lF1g9YsOX/F4/hirlriIC8IDuybjZB4Bwkxlz/jMc15aofGmyGO
         U+Vw==
X-Gm-Message-State: AOJu0YzhEIJDr4cL8BZqqg7t0soIInVuHu9+FHhNlY9/DeoBk0n6z9xx
	cEFlNIb8WUVLXsKiP9EC9ss=
X-Google-Smtp-Source: AGHT+IGYqlQhFzyXGwIJxZYzz10J32/aPAHvTNFD/mHPn6Cz/ujm1FsJgr5vpKqfqwNFp0i0LrBu2A==
X-Received: by 2002:a05:6a21:1448:b0:16b:c725:1dc with SMTP id oc8-20020a056a21144800b0016bc72501dcmr3160186pzb.35.1698173319867;
        Tue, 24 Oct 2023 11:48:39 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id h1-20020a625301000000b006be484e5b9asm8297905pfb.188.2023.10.24.11.48.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 11:48:39 -0700 (PDT)
Message-ID: <cd0eb23b-6c46-4069-ba29-9820c99b8ca8@gmail.com>
Date: Tue, 24 Oct 2023 15:48:33 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] x86/rust: depend on !RETHUNK
Content-Language: en-US
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Wedson Almeida Filho <wedsonaf@gmail.com>,
 Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>,
 Andreas Hindborg <a.hindborg@samsung.com>, Alice Ryhl
 <aliceryhl@google.com>, x86@kernel.org, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20231023174449.251550-1-ojeda@kernel.org>
 <20231023174449.251550-3-ojeda@kernel.org>
 <f53536ca-ec5b-4cdc-a340-e9c739ee30c4@gmail.com>
 <CANiq72nTE_qua9w+EeqiPCukst4876Gi7gHeusFLofYZRoJCDw@mail.gmail.com>
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <CANiq72nTE_qua9w+EeqiPCukst4876Gi7gHeusFLofYZRoJCDw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/23/23 19:15, Miguel Ojeda wrote:
> On Mon, Oct 23, 2023 at 8:43 PM Martin Rodriguez Reboredo
> <yakoyoku@gmail.com> wrote:
>>
>> I'll mention that I've tested boots, both in bare metal and QEMU, with
>> `RUST=y` and `RETHUNK=y` and they were alright regardless of `objtool`
>> warnings. Although, if you had an issue in the past then I'd like to know
>> about it.
> 
> These are mitigations -- things do functionally work if they are not
> applied, but you would be vulnerable.
> 
> In other words, it is not like e.g. IBT where you could have noticed
> it breaking by running it normally if you happened to have a supported
> platform.
> 
> Cheers,
> Miguel

'Guess you have a point...

Acked-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
