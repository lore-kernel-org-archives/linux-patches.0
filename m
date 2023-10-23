Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0BF1B27C
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 18:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lwwZCJGV"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1ca6809fb8aso23328955ad.1
        for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698086581; x=1698691381; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/weOLyJtPWlh5siUgFN5Itg3AwgyF2jPHeNmSxivo64=;
        b=lwwZCJGVllD3Xq4VnVdskNX4XwWa0HqJxSITP1nICa3UCsbqaX6rOsZxceKhAjStLC
         PXZPNYwYPSs2AY4SKiE35OIrvn8d9am6FUE5qh0+IPbfaziIYEZ5kR81cNCLIxNqajas
         bw+DYN1leqsmw7NbCh/jb2EcBNhmtBi0HnnHgIUSL42H65L+cPbzzSVMw+5yyXYMtqpY
         J0YJ3+S9OzJU7sdtk52q9ZlFz3GSY0gravld+oFSghPrlLG+lTsk/5+n3QDR16u51YOf
         HGIx394M1Bq7AopUXzbNSY0TuDDQ7vYsMWjYvGDK02jSiLmRYqiYXRFaUzxHx0aOH5XE
         Nryw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698086581; x=1698691381;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/weOLyJtPWlh5siUgFN5Itg3AwgyF2jPHeNmSxivo64=;
        b=KRgIgedQVSKeZNme8pth5Dq96IkPEKN7KYOzVrMUbVXm80Eu7HdAhMJVeEMw5FbQVs
         L/h4Cb/tpFmKh6tyT1el8xF0T/azij1rsux8sTb3usG6ciEWDJEexwKxXwfkiuytPgFl
         VnSjYOS9XAFFaeAVb8T385JzB+FhJ6g8Uqi+a+hV3zaTb9Uk5bCUJDC18lf2q6eC+r7r
         AwhFryO+Q6Gz5UBQuKA0NfRrXiNHD70/WPQVfTpLaB0bfRkPkUCuiVt2JnHKuQxKf8jf
         FQj4D+uhM+MRNGeZwbGhpV/rpUeZJ7uyttJZcwv6Vhf90t2YMgd1p/gO3O1/jodXkHyl
         kIZg==
X-Gm-Message-State: AOJu0Yxg3e6K6P81sJ7sC72Kcg0g2DZl2VaabKBwj7R84rC0PfhO8wK/
	pYphvi8gk+QgzP+mkXpZ7VM=
X-Google-Smtp-Source: AGHT+IEZD90O8n0Vj11F0UcDsagtID81H9xP0zBmAnLN9X3dVPcTNym3zFvCwwvylZStx4FAQ/jzVw==
X-Received: by 2002:a17:902:c215:b0:1c7:3558:721a with SMTP id 21-20020a170902c21500b001c73558721amr7044165pll.58.1698086580961;
        Mon, 23 Oct 2023 11:43:00 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id i6-20020a170902c94600b001c9c3c377f2sm6238806pla.203.2023.10.23.11.42.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Oct 2023 11:43:00 -0700 (PDT)
Message-ID: <f53536ca-ec5b-4cdc-a340-e9c739ee30c4@gmail.com>
Date: Mon, 23 Oct 2023 15:42:54 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] x86/rust: depend on !RETHUNK
Content-Language: en-US
To: Miguel Ojeda <ojeda@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>,
 Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>,
 Andreas Hindborg <a.hindborg@samsung.com>, Alice Ryhl
 <aliceryhl@google.com>, x86@kernel.org, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20231023174449.251550-1-ojeda@kernel.org>
 <20231023174449.251550-3-ojeda@kernel.org>
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20231023174449.251550-3-ojeda@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/23/23 14:44, Miguel Ojeda wrote:
> The Rust compiler does not support the equivalent of
> `-mfunction-return=thunk-extern` yet [1]. Thus, currently, `objtool`
> warns about it, e.g.:
> 
>      samples/rust/rust_print.o: warning: objtool: _R...init+0xa5c:
>      'naked' return found in RETHUNK build
> 
> The support in `rustc` for `-Zfunction-return` has been submitted and
> is being reviewed [2]. It adds the needed LLVM function attributes and,
> with it, I got a RETHUNK kernel build with Rust enabled that does not
> print the `objtool` related warnings, boots in QEMU and can load a kernel
> loadable module.
> 
> In any case, until proper/complete support is added to `rustc`, make it
> a hard restriction until the mitigation is in place.
> 
> This may have an impact for developers that may not need/care about the
> mitigation in the Rust side (e.g. Ubuntu offers Rust as a "technology
> preview" [3]), but given we are getting closer to having the first actual
> in-tree Rust kernel users, it seems like the right time to disallow
> it. This should also avoid confusion [4].

I'll mention that I've tested boots, both in bare metal and QEMU, with
`RUST=y` and `RETHUNK=y` and they were alright regardless of `objtool`
warnings. Although, if you had an issue in the past then I'd like to know
about it.
