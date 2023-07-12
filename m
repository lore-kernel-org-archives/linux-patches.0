Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53EF3DDC8
	for <patches@lists.linux.dev>; Wed, 12 Jul 2023 20:46:37 +0000 (UTC)
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-6b5ef64bca6so6416814a34.3
        for <patches@lists.linux.dev>; Wed, 12 Jul 2023 13:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689194796; x=1691786796;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ht8m3JpnPLfdwbNyu/YR+stFiN46jyoA/rcch4tcqlw=;
        b=HZXLcni+Ow6q1V7U79jBQqg0mozLSVlS6mIrhsdQmulgIfFLAdOsMw3OCvtE9j6n9g
         xH2PjYF51TyP7XNrNxU3yDxwvNQzjOsMjvuDkQHmXZ7Q96oug+DkHrScUgyTNv6ZhFdO
         G0KFbq4czeMUJYlQKitJCxF3defmyjmEQzkL9kdoS10Gzz9boFFoIGyCfKvGXrbA10sk
         n1SjeXZo2aCu8hQTjHNKRSGDoi0Ep6GMdE4dTHsejss1GK8jp79rjauA8igLbmncrk5D
         h/c8dC8Tr2CF0fwCnd3FDGOjzTXGXoxroqXxSPZ/LbpVKOOgQ6nZbs9DyW4EOxgvTjlp
         0Ukg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689194796; x=1691786796;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ht8m3JpnPLfdwbNyu/YR+stFiN46jyoA/rcch4tcqlw=;
        b=C2F0wSFdHanD1r/9Dz4NVb4apGNsohmunCHPxWYSAThZGrjyMGtwGnHn2GHnTYhnca
         eCFFmg8VnhOyb/k7diOZm46Z7fZCQ+ndM1C0z50GDXf6bzo3BjGp8vbsLO60+OMAzKtm
         tOghPa+u8sN2TFl7TIRgPYa3gOPP3bw0Q3iTimtEk5CYXXYzX+dIl+G4IBeTK0c/pPeO
         THkE5cvpfnpchb+gbApUwol8FvkW/tOyjGwC0kb8S1UNgEK3KBxF30jusHPA1aAdWg7i
         +J9ngI/QRTTX3EOfQ0gcJq6l3sffcoEMbpjLH+IDy29hzAWqmNMDA4pzjfGjS0hJIfL+
         C4UA==
X-Gm-Message-State: ABy/qLbwzFabzO/5qkUwz8OmfHaR7enLsie7G8DJ/0N2gIVVdTgKqjSf
	xVv3aJHAJwUzEmR3t6gCXjQ=
X-Google-Smtp-Source: APBJJlFBh4EdX43Vi87ClYbGGo4lYoKVRn9LizgIGpKhDitwpjeftap6gzZh0cnr7cXL7OMdDTMRQA==
X-Received: by 2002:a9d:638e:0:b0:6b9:8feb:4930 with SMTP id w14-20020a9d638e000000b006b98feb4930mr5498091otk.35.1689194796305;
        Wed, 12 Jul 2023 13:46:36 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id n9-20020a0568301e8900b006b9aa110e0esm125344otr.76.2023.07.12.13.46.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jul 2023 13:46:35 -0700 (PDT)
Message-ID: <449f81fc-42fd-bd8b-6929-8cd2659d8ea0@gmail.com>
Date: Wed, 12 Jul 2023 17:34:04 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 3/9] workqueue: introduce `__INIT_WORK_WITH_KEY`
Content-Language: en-US
To: Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org,
 Tejun Heo <tj@kernel.org>, Miguel Ojeda <ojeda@kernel.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>,
 Wedson Almeida Filho <wedsonaf@gmail.com>,
 Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=c3=b6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 Wedson Almeida Filho <walmeida@microsoft.com>
References: <20230711093303.1433770-1-aliceryhl@google.com>
 <20230711093303.1433770-4-aliceryhl@google.com>
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20230711093303.1433770-4-aliceryhl@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/11/23 06:32, Alice Ryhl wrote:
> From: Wedson Almeida Filho <walmeida@microsoft.com>
> 
> A Rust helper (introduced in a later patch) needs to call
> `__INIT_WORK` with a passed key, rather than define one in place.
> 
> In order to do that, this moves the initialization code from
> the `__INIT_WORK` macro into a new `__INIT_WORK_WITH_KEY` macro
> which takes the key as an extra parameter.
> 
> Co-developed-by: Alex Gaynor <alex.gaynor@gmail.com>
> Signed-off-by: Alex Gaynor <alex.gaynor@gmail.com>
> Signed-off-by: Wedson Almeida Filho <walmeida@microsoft.com>
> Co-developed-by: Miguel Ojeda <ojeda@kernel.org>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> Acked-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
> [...]

Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
