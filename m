Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87AE16AA8
	for <patches@lists.linux.dev>; Thu, 15 Jun 2023 13:33:41 +0000 (UTC)
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-39c84863e7cso4823625b6e.1
        for <patches@lists.linux.dev>; Thu, 15 Jun 2023 06:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686836020; x=1689428020;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gXGICQ50G65MHvELHZmzGRAZEarhLjbzAG5FaOgvnLk=;
        b=TVq8vXX7rBUuz1raSfavfMpyFMZdl/D0YFUzwlxrjAgFYRLapZtAol4AfXy8Sth7F/
         KiuhbO6MEgfu0ptmk5jHIXTMISXJuPlan4DQAcq8el+1Eb2Ei6YxVwL8fCfdeZjcQe4b
         tYwvEnxtu8tiuEtREuEFoq2OKfEk8+AFBB51Yt53KVEJP3jC575PEM1FS6LbPJm4cjXh
         r5E6BbmOxPaXuOZOndJzNabzfnsHk22rwfpWH6eXtpizWq1tsPRxtIbna6Kj/ZlE22z1
         7//effT7X6dAI8lr2ocinPekegaHt+31CT2WQ2saucHVUvbMGKgITT+BaxDWusf6j1w5
         t17Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686836020; x=1689428020;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gXGICQ50G65MHvELHZmzGRAZEarhLjbzAG5FaOgvnLk=;
        b=ZVn9G9p7sMvmKyPuyuONpsHvH3AUHJkEkQSRZK00IAe2Xyd55CF6unvtskuECq6rgU
         VdbZGLaESW7O+qFR6tDC8tclT0kWewOJ2toxeA5WYdBvIgg5G7Ywao4kVlKv1QDqgMzO
         /ChCEoote1apNYd2Q9wQKOZIeViI2NfdKz7r2+YlQiDre/Y4qR/ezhCYbkwIIG36IUdZ
         zjJK/1KJaLDUEbBFl4Eq6s4le4b1Dj3Sf3XWRJ4khBgVXqjB7xMNIQ+Slg7yWEIWg/KT
         +MxDBrfdtMh1hkGP2E2a3njwkEDmhIJG8RPBYEFZyCLD4cVJosfI4iifVL8CYBdTs9Ew
         K6vQ==
X-Gm-Message-State: AC+VfDxkWtt3+NQOe/ap8UTB+hA/C7I0oYCdBhNgWOc9skC1ei8UY8NX
	79ccn1FWmPkpfkDIyQyewcs=
X-Google-Smtp-Source: ACHHUZ7UWifzdJSDkHoWoiOZrjE+y0salSHzFZ9WHDKVYNMAp2o6swaqzv1eZus3VRfE/ZrQG22lKg==
X-Received: by 2002:a05:6808:1782:b0:398:465e:ec68 with SMTP id bg2-20020a056808178200b00398465eec68mr14760468oib.4.1686836020404;
        Thu, 15 Jun 2023 06:33:40 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id e19-20020a05680809b300b0039a531d9b92sm6850679oig.56.2023.06.15.06.33.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jun 2023 06:33:39 -0700 (PDT)
Message-ID: <5835c052-c101-ebc1-3609-88d6e12f13ac@gmail.com>
Date: Thu, 15 Jun 2023 10:33:34 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 1/6] rust: init: make doctests compilable/testable
Content-Language: en-US
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, David Gow <davidgow@google.com>,
 Brendan Higgins <brendan.higgins@linux.dev>,
 Wedson Almeida Filho <wedsonaf@gmail.com>,
 Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=c3=b6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>,
 Alice Ryhl <aliceryhl@google.com>, Andreas Hindborg <nmi@metaspace.dk>,
 Philip Li <philip.li@intel.com>, kunit-dev@googlegroups.com,
 linux-kselftest@vger.kernel.org, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20230614180837.630180-1-ojeda@kernel.org>
 <20230614180837.630180-2-ojeda@kernel.org>
 <2b4b23ce-316e-b998-7faf-e529b121a8b4@gmail.com>
 <CANiq72mApAXEtoWgkaLvZJu6gn=9CkyogRXVfbYxPsR5TeFUVQ@mail.gmail.com>
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <CANiq72mApAXEtoWgkaLvZJu6gn=9CkyogRXVfbYxPsR5TeFUVQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/15/23 06:31, Miguel Ojeda wrote:
> On Thu, Jun 15, 2023 at 5:52 AM Martin Rodriguez Reboredo
> <yakoyoku@gmail.com> wrote:
>>
>> Little question, what's the purpose of `FromErrno` here?
> 
> It was because `Error::from_errno` is `pub(crate)` in the `kernel`
> crate. I should have added a comment -- my bad! :)
> 
> If we decided to make it `pub` eventually, then this `FromErrno` hack
> can be removed.
> 
> Cheers,
> Miguel

I think that `FromErrno` should be made public the moment when more
doctests rely upon it, until then.

Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
