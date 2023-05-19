Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339C78C16
	for <patches@lists.linux.dev>; Fri, 19 May 2023 12:04:44 +0000 (UTC)
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-19a500ca4a3so693723fac.3
        for <patches@lists.linux.dev>; Fri, 19 May 2023 05:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684497883; x=1687089883;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0jmpizCaVOeCP1r1p2VyeIJckntY5BckfPqM9Nsz8n4=;
        b=V/Yn4/NxgQPXvWF8hVm4JaNB0A7WHvHdopqNl/U/yuGD4//t6lFyb0d6MhEuhy41Z6
         BS8LJsvDFBbOUxV/1EQzeCx8Wc6vIMIU6THXj2CUofkjq722/e+L/q1DhdiUac2x2HuN
         twqL5w6vzUTTycYx0gbjfrTpx5FuB0LZG1uOVO27oizvAmX34QlXMtwjf8aOMkdnH1zS
         lglD5aoNF65wVXriGzrJ0acuJYeLdWzzhjfBKYTyWdwQnQINA1KyJC+JfvAspTfSVAVj
         99P11UrSB46FDXp7rU+uF1qKhXXcSc2g1BLQ5C3AnBBCqUU1zjTFi5BPwS9fnnw7DG+v
         Sg+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684497883; x=1687089883;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0jmpizCaVOeCP1r1p2VyeIJckntY5BckfPqM9Nsz8n4=;
        b=H8jqQggzGLF36Uijgt+UtUZ6nYdT2mEtwSAlQQYzailAcc6ImriX/kHf8R+atcUOnV
         HwbNHK4xjneaENG5ORDbmYqweduTiaFoIC7PaF9oebY9AJYDTZLWBHXEgvShjpzJA1R1
         2LmSC2dPEBIbrBFctyGlOby2f0fOyVyCFwnkdAkQfrg6Fz647pRNxOCXvpZ5FUnJsWvM
         BYCdaCGpHQc7fmMN2ZedbTr6LS+TXX1kWI7iZSBh55u03x3lO8UQh1a2QDowEhaEPmeM
         PRrbkUo0eWttR4//wgRNf2ENVGLYrmn5oJilRLTv2sUTzpmTBMRIAdmHq906qlmeG66e
         Ay0Q==
X-Gm-Message-State: AC+VfDxfSxvBMd0Vbec/l+nyagLTVPjEnmv5IKwCn8+uew9N5F4LD9L8
	5tp7YFxR3vJltasN1qg6ojM=
X-Google-Smtp-Source: ACHHUZ6jWONxjseiTxpvmAU7vOOx9nwPIKW7k7HlSt6MQyAC7YvKhLNkrZPKsdvwRNbVhk+geIoX+g==
X-Received: by 2002:a05:6870:7406:b0:18e:2f29:1099 with SMTP id x6-20020a056870740600b0018e2f291099mr869338oam.53.1684497883167;
        Fri, 19 May 2023 05:04:43 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id b1-20020a05687061c100b00199be6e2b75sm1832109oah.41.2023.05.19.05.04.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 May 2023 05:04:42 -0700 (PDT)
Message-ID: <beb2932e-7f16-e368-9cb5-edbe115fcb67@gmail.com>
Date: Fri, 19 May 2023 09:04:38 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v1 1/7] rust: workqueue: add low-level workqueue bindings
Content-Language: en-US
To: Alice Ryhl <aliceryhl@google.com>
Cc: alex.gaynor@gmail.com, benno.lossin@proton.me, bjorn3_gh@protonmail.com,
 boqun.feng@gmail.com, gary@garyguo.net, jiangshanlai@gmail.com,
 linux-kernel@vger.kernel.org, ojeda@kernel.org, patches@lists.linux.dev,
 rust-for-linux@vger.kernel.org, tj@kernel.org, wedsonaf@gmail.com
References: <8e42aad3-d94e-3cb4-ee59-90ded31cea9e@gmail.com>
 <20230519094042.3432952-1-aliceryhl@google.com>
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20230519094042.3432952-1-aliceryhl@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/19/23 06:40, Alice Ryhl wrote:
> On 5/18/23 16:51, Martin Rodriguez Reboredo wrote:
>> On 5/17/23 17:31, Alice Ryhl wrote:
>>> +    /// Enqueues a work item.
>>> +    ///
>>> +    /// This may fail if the work item is already enqueued in a workqueue.
>>
>> Wouldn't be worth to mention that, if not implied, the item it's going
>> to be worked on an unbound CPU?
> 
> I'm not really sure what you mean. Can you elaborate?
> 
> Alice

I've meant that if it's good to mention that `queue_work_on` is going
to be called with `WORK_CPU_UNBOUND` so that API users know about it.
