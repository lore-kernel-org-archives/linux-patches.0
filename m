Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD1D15CD
	for <patches@lists.linux.dev>; Wed, 19 Apr 2023 02:45:30 +0000 (UTC)
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-6a5eea94963so880764a34.3
        for <patches@lists.linux.dev>; Tue, 18 Apr 2023 19:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681872330; x=1684464330;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=E069ZTY6nFYszV+/5FzOjU5LbuCwW8x4gHc3aSQEBg8=;
        b=UhQs5Y/3zpq4zX5sMEGThvciVqiFLBfm1teJcsEZzz5FG1jhGuAJZkW4WWBG0z5odO
         sIXPLrBUHBnj8uidXCrTBCqtfVRG8xeEpmxLVT4wVF5v9L7mSJMNlOrg6HfxAg1TN5dR
         YJlOs7ksl1ob5qSztI2NE/qskge0XjDaEErG7SKNd9xxyH9QG3TH1LBOiA7wf8f4POs7
         agk65MtIa5mBrXA3Yv3GHJazl3hkeLYE/yUpkGWPB8cBiJSR8ViIxrBVPPpkobNj+paK
         XBKV6NG2FlizvxxbwP0GNoFJMjyPLaCxkz7LXDqjCF8abkw55v26qf3Q6kGodaDE5j3z
         vsSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681872330; x=1684464330;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E069ZTY6nFYszV+/5FzOjU5LbuCwW8x4gHc3aSQEBg8=;
        b=MNefiYhWo3ZkZyfnlylis1RSqawuBCC26nTKXCpsj5N4pUabn9MDsO1tJEuRa/fR7w
         /Xf7QsFlJ7BC+p3wJ8U0TnyKYN8M/rcnuWltk4wz5XHrDNenB1eO1XFjcfuEWLne37St
         Raxz5orwepriJ21kLIwkRVkw9js3s9OXH+76tuBui1yrMMXft5L3VdbAkHA7XuME5ta0
         qpLsF+PmyOEYPjDpUF6G+IeQeq90h4oamO63p/nXr7doa3SPb7n6DlJDak9xWlD4910f
         v0fgCrC/JGUZm1QufMS4Dn/y8lU6qlQ3jnrcn9+HKeAKQhMCkzXyx0/gv0nRzkK7ae8/
         lw4A==
X-Gm-Message-State: AAQBX9f8OnhRGFQsH3YBH9xjxE71+iHykLUePuXGQz3bF2R+bMZ6zK2e
	mWH0UlyRq1010BPi88fCUNM=
X-Google-Smtp-Source: AKy350b+TpaRh7+IMRxW7bQHLeOF/kqFYVzDURhqDqBXE7Ss1mrHoC4nEcZ4sXwTsyTxEAG+z4Q4EQ==
X-Received: by 2002:a9d:6d0f:0:b0:6a5:cf29:f310 with SMTP id o15-20020a9d6d0f000000b006a5cf29f310mr2239494otp.34.1681872329921;
        Tue, 18 Apr 2023 19:45:29 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id m14-20020a9d644e000000b006a4308f1e2asm6165250otl.54.2023.04.18.19.45.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 19:45:29 -0700 (PDT)
Message-ID: <2fc535da-0d83-049a-53a6-e310d12a884a@gmail.com>
Date: Tue, 18 Apr 2023 23:45:25 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] .gitattributes: set diff driver for Rust source code
 files
To: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho
 <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=c3=b6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>, Masahiro Yamada
 <masahiroy@kernel.org>, Stephen Boyd <swboyd@chromium.org>,
 Jean Delvare <jdelvare@suse.de>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20230418233048.335281-1-ojeda@kernel.org>
Content-Language: en-US
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20230418233048.335281-1-ojeda@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/18/23 20:30, Miguel Ojeda wrote:
> Git supports a builtin Rust diff driver [1] since v2.23.0 (2019).
> 
> [...]

At this stage in the game such an improvement in diffs is required.

Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
