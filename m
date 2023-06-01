Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7FD21CE7
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 14:58:32 +0000 (UTC)
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-19f6f8c8283so1070877fac.3
        for <patches@lists.linux.dev>; Thu, 01 Jun 2023 07:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685631512; x=1688223512;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q1PzCp5p/rvf4kSiJkiDCK+IFfQHrtapNUn7i04+cHk=;
        b=LfyI1grSwMs7fTAWnYBYdm8L198ljPsLAzS537iEvi7Nrp1L9VW/4QFOjBgbWeoZwE
         WjfKFQ5eeANG9bwUCVE8Io2n+9CkiEs3mDHWeGVG1qPPzd7A6N1WXm3T45neKD/EZPhz
         ie9f4ZzedU0H+qhn1kafyQjD1XQCHea76XPyoBbbONwtbXXnI8a4yLsdVeuGLzAHfM8d
         IGv5Xp+KrDGRbo/yyaIuzs6eeT95k5tD8rfwGEYOc3iCaPf3oBUkN8MoYRZxZb3TyMo9
         faDaxal3yot3T3pVx8X8lhPzDaUND1uYjNU/8qDFeq0cB+S6gfCatU/IqEcf4jRP3d9c
         lzrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685631512; x=1688223512;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q1PzCp5p/rvf4kSiJkiDCK+IFfQHrtapNUn7i04+cHk=;
        b=VNuF4IMwNtvPl17voPZTCzPjkRYd/TpTo+I6jQuj+rbUdfqiqvTBqJLKm0kSnpliTY
         3oqkwSnDp0AqYkAPkM0NKMaNlnnHmBHNSNmKn35MUMC4rrIi4B/pL21E/7P8LgbyKRbX
         SB+mwg8OajsqnDFe8eZKmf/vrfAFJ0cMAunqTqw0SHpoiWvSh4lTXOArZ7hOgqWnJDG8
         9qpuIQaKfL3uNvs/UUbR8QdEqKcjCxVm9vlZ9jdXSZ2lX8wJl/8Z0DQeeQMiNXh8Gh7J
         T9ExuxfE0HLVbyiZ/yJ2ODwM9EAqeM3ofrRF+9ZH9+rg+ORi8sJzIO/wZayfDmqS0oww
         q1SA==
X-Gm-Message-State: AC+VfDy42UhAiS7OawWVJk1GWqHGBsiZCdmhR+cxofM3towdv3WxuElf
	zVcCIWAlGM9OPYf52+5rR5c=
X-Google-Smtp-Source: ACHHUZ6BaHH9bv8aUrjOFDl/HHR2HWNrtoBmIfI763T4M9M1LJO7w/KU0E9X7QBpUdvCil4MizBZZg==
X-Received: by 2002:a05:6870:6287:b0:187:d229:2781 with SMTP id s7-20020a056870628700b00187d2292781mr7493236oan.6.1685631511579;
        Thu, 01 Jun 2023 07:58:31 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id v7-20020a9d4e87000000b006a44338c8efsm1624177otk.44.2023.06.01.07.58.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jun 2023 07:58:31 -0700 (PDT)
Message-ID: <f9108f3b-3d2c-47d8-8ab6-d8896c27d9c0@gmail.com>
Date: Thu, 1 Jun 2023 11:53:49 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v2 7/8] rust: workqueue: add `try_spawn` helper method
Content-Language: en-US
To: Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho
 <wedsonaf@gmail.com>, Tejun Heo <tj@kernel.org>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=c3=b6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <20230601134946.3887870-1-aliceryhl@google.com>
 <20230601134946.3887870-8-aliceryhl@google.com>
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20230601134946.3887870-8-aliceryhl@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/1/23 10:49, Alice Ryhl wrote:
> This adds a convenience method that lets you spawn a closure for
> execution on a workqueue. This will be the most convenient way to use
> workqueues, but it is fallible because it needs to allocate memory.
> 
> Co-developed-by: Gary Guo <gary@garyguo.net>
> Signed-off-by: Gary Guo <gary@garyguo.net>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
> [...]

Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
