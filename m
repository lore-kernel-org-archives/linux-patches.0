Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84AF8625
	for <patches@lists.linux.dev>; Thu, 15 Jun 2023 03:52:38 +0000 (UTC)
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-1a9a42edfc9so77178fac.0
        for <patches@lists.linux.dev>; Wed, 14 Jun 2023 20:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686801157; x=1689393157;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=37lHv1ZqEN3KbKhtxEWcsRVwfI/2kLKmjExzPbh8ooc=;
        b=dy51VvehrZ1fwzi0O7yTUQ0MfM2PAXwnBuvoanAgrqOZ0n8k11P9QxQ0ulItXcs+Ze
         wj02CoUxXohWMARbvesT7zXzdP0o0JI6OyNfYL47uxDHmEoH2lRwLu5JYgP3nht6MhTo
         ZTZv3Qjc6N8O5fyWTqt47NvhJXm/EwV2TIxIf5l4lLqSi3FM9jOBd+q2xxR8Ws9bxfnV
         4GHb/limbu09Bj7BpTJfxqCgjgcQU58psWjxzhZ/+0bweOi6sbJe9fCN5KgtP3wvsnOX
         4t+/BExGUTXOEqSwRiu7QeBgrf5ruQ4joUX1eVHDY5x/VYcxgRPurr8rMLIkYEeCRn5O
         Y8fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686801157; x=1689393157;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=37lHv1ZqEN3KbKhtxEWcsRVwfI/2kLKmjExzPbh8ooc=;
        b=ZXgoYVmIiYHn6FlZqsAXuvLSwuXFzaBPAVG9k8cq5KRtmY10wseNV8Ybe+AbhpAtwk
         sXBvQ7tRzBmxakmZbRUVs0DmjXDibb6DWx8SMpA7mF3P7rk1u7OFYQgoS/x6TZOMCQpB
         PximiqBPO1rTlC6cbigEsxu4axfyks/MlHne1OFLqP5YBgu18t2QGjzFCfdU8xfxAsYe
         T2pjXlN+9MhPIDxXsPK+YlJfDsVDrOgyiEFmikQM4M0I0MlrC6SIsNuao4zix41aRJyz
         cdl9SRMto0euOBzNwfujJ1Z+8kATQCceCChfD9vGox0aZlRJVPd3Fzk5tsgA+n482ut0
         zMgQ==
X-Gm-Message-State: AC+VfDwEpVoLyPWrjEYOc8HW0TTCk9YOX+araycJxGPWgdWHD148elDk
	pCOY/B+H+NLnBtlSzRxkqZg=
X-Google-Smtp-Source: ACHHUZ5PE1QRcro9YWkg0G4/ovm+qWCIn125P+6Wmq3YTj0Aum60A6KI/m55XZBYuS2chLsSXrwnng==
X-Received: by 2002:a05:6870:e895:b0:18f:11c7:9404 with SMTP id q21-20020a056870e89500b0018f11c79404mr11255152oan.38.1686801157530;
        Wed, 14 Jun 2023 20:52:37 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id z10-20020a9d62ca000000b006ab1ea1af9esm6353844otk.68.2023.06.14.20.52.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jun 2023 20:52:37 -0700 (PDT)
Message-ID: <5a81fbc4-ff8b-4ce8-d8a0-a87f6d76771c@gmail.com>
Date: Thu, 15 Jun 2023 00:49:54 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 6/6] MAINTAINERS: add Rust KUnit files to the KUnit entry
Content-Language: en-US
To: Miguel Ojeda <ojeda@kernel.org>, David Gow <davidgow@google.com>,
 Brendan Higgins <brendan.higgins@linux.dev>,
 Wedson Almeida Filho <wedsonaf@gmail.com>,
 Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=c3=b6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>, Alice Ryhl <aliceryhl@google.com>,
 Andreas Hindborg <nmi@metaspace.dk>, Philip Li <philip.li@intel.com>,
 kunit-dev@googlegroups.com, linux-kselftest@vger.kernel.org,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <20230614180837.630180-1-ojeda@kernel.org>
 <20230614180837.630180-7-ojeda@kernel.org>
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20230614180837.630180-7-ojeda@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/14/23 15:08, Miguel Ojeda wrote:
> The KUnit maintainers would like to maintain these files on their
> side too (thanks!), so add them to their entry.
> 
> With this in place, `scripts/get_maintainer.pl` prints both sets
> of maintainers/reviewers (i.e. KUnit and Rust) for those files,
> which is the behavior we are looking for.
> 
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
> [...]

Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
