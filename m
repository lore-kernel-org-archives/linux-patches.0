Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6172924B47
	for <patches@lists.linux.dev>; Fri, 15 Dec 2023 11:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tm21XQ0w"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-40b5155e154so6127395e9.3
        for <patches@lists.linux.dev>; Fri, 15 Dec 2023 03:16:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702638963; x=1703243763; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1tF27Ct5v6tce6o6JnCer2vKNDZ4X+jcuur9cRoSxGk=;
        b=Tm21XQ0w86M+x/5zOcShzzWbkbsKJ+p8kkC1QvyoVu6h5kYtWZDZloNrt/CZBO++zE
         sATZjzGRwOSExQ2wmentzUJpxsetr03vKyRHbJHSV06GismNcgeOtFVaNi/r9oJdlR7r
         UH3HIHAMkflsc1Xf93oBTP3l1Ol1A+ogM8bT6vALfW9xlb1cNNJ9sxhQN8pFnNf32pBU
         B2TM5YgmsWniWa/kVCHe1vFdgLz1hcNNINcbwK6F8bqwkoCwAVVLwZ0IV41K7ob/65J6
         zxLBNhnmEPuYiEztTuFgGkqwg0UHO0meyPFDlKLK1nfiQaDHs3IAWrzwBbQwPh4ILQZj
         8QlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702638963; x=1703243763;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1tF27Ct5v6tce6o6JnCer2vKNDZ4X+jcuur9cRoSxGk=;
        b=PBr51gcLIrJg+LgGvGJ6SNqYCiPuR04oO/0jvXTkEN2MDWw/imQ0vAm7rA0AiMbqct
         kPOQtNk1lFc90zlbBw0I41lgWQB6iBDOTP0FZO9LHutPIkZfZCpqz+m59++gmvGLrL09
         T+QGZRwJAlyHV9dVkk+m+ynB6kpz6qf1h+rXgoz94vegKnqoGc6hoEAX4yyoEhVlPRSy
         AhwL9wCbzcOL1Pxr6D2drFgB6jZVc0eAdF3q9iE1l4zOtbQ5+AC+Hi5cHdmo8nhINFH7
         tiKJtTyok6VR+4SkcDm+txdkqgGT6JrBJCHhNyS95sV1DuQcCMgp+Yw/OcdLCJJjTctr
         kS9g==
X-Gm-Message-State: AOJu0YxGjAeUxFDEIc4KK705Codcsi1a0459n8oDU6kwVM2pvTmka9nN
	UYrpp9VKT60gM4yDxkcsMQ==
X-Google-Smtp-Source: AGHT+IFCuPwJgXD4EEADZbIlN/xvhbXNUl/sRTkKJI012vdsN3bVbwt2nXfBaxVUmHzxpw1nDySk2A==
X-Received: by 2002:a7b:c4d0:0:b0:40c:3272:1fea with SMTP id g16-20020a7bc4d0000000b0040c32721feamr5519222wmk.87.1702638963391;
        Fri, 15 Dec 2023 03:16:03 -0800 (PST)
Received: from [192.168.1.148] (224.69.114.89.rev.vodafone.pt. [89.114.69.224])
        by smtp.googlemail.com with ESMTPSA id c17-20020a05600c0a5100b0040b4fca8620sm31500952wmq.37.2023.12.15.03.16.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Dec 2023 03:16:03 -0800 (PST)
Message-ID: <a92a0bff-057a-47aa-b82d-4d13b3a01e01@gmail.com>
Date: Fri, 15 Dec 2023 11:16:01 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] kbuild: rust: add `rustupoverride` target
Content-Language: en-GB
To: Miguel Ojeda <ojeda@kernel.org>, Masahiro Yamada <masahiroy@kernel.org>,
 Wedson Almeida Filho <wedsonaf@gmail.com>,
 Alex Gaynor <alex.gaynor@gmail.com>
Cc: Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <ndesaulniers@google.com>,
 Nicolas Schier <nicolas@fjasle.eu>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>,
 Andreas Hindborg <a.hindborg@samsung.com>, Alice Ryhl
 <aliceryhl@google.com>, linux-kbuild@vger.kernel.org,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <20231214222253.116734-1-ojeda@kernel.org>
From: Tiago Lam <tiagolam@gmail.com>
In-Reply-To: <20231214222253.116734-1-ojeda@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14/12/2023 22:22, Miguel Ojeda wrote:
> When setting up the Rust support via `rustup`, one may use an override
> in order to select the right version of the Rust toolchain.
> 
> The current instructions at Documentation/rust/quick-start.rst assume
> one is using an in-tree kernel build (i.e. no `O=`) [1]. We would like
> to provide also the way to do so for `O=` builds, but ideally in a way
> that keeps the one-liner copy-pastable and without duplication [2].
> 
> Thus provide a new Make target, `rustupoverride`, that sets it up for
> the user given their build options/variables.
> 
> Link: https://lore.kernel.org/rust-for-linux/20231207084846.faset66xzuoyvdlg@vireshk-i7/ [1]
> Link: https://lore.kernel.org/rust-for-linux/CANiq72=mvca8PXoxwzSao+QFbAHDCecSKCDtV+ffd+YgZNFaww@mail.gmail.com/ [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Tiago Lam <tiagolam@gmail.com>
