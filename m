Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D72C42501
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 17:52:33 +0000 (UTC)
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-3980c92d8d6so970586b6e.0
        for <patches@lists.linux.dev>; Thu, 01 Jun 2023 10:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685641952; x=1688233952;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YhHv7Mf1I0a9KUS70IwOalIiIIv8ejIDo/fZodYNL8k=;
        b=HOB24OuDi1C/6DAQgZs817fnfsgBhxZkOLLDUCUziA3HXojfTukCfOBLXfnIcTXVCx
         7eupU0HBaRu2rdHAlTXgf8fc9eFlbk5rRg6HPzcGvc4Kkk79laPcL7bI+L2TbIBXvpVa
         9kru9imOxuIKT3RA66Fc4yKViGjmwaLDG2VMGLDtjaRqvkgJg9sHkpg5cQPzrQAnT0D+
         fFbwpEmGJuH+4vGe7fepwT6UZ+I0Smt31npE+YO4hvFUERXtShvL9GyBJ7wIg9OY7jW3
         Ds8xx6HF0h7XnTsVx8RItLTznRSrpivoQmZF9Qxu9eiEfYZH2huewBKvEDAUpHvAg9IE
         l5bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685641952; x=1688233952;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YhHv7Mf1I0a9KUS70IwOalIiIIv8ejIDo/fZodYNL8k=;
        b=A1cAZXi/T/67JRkEtbkE4+UM+bj47l119l+nyoWXYOgffWyTqP2cDLwHrlQHY4Y5V9
         N4vKlpHuisqbxY+6h/QyCmSbFa2FfToC9yWopTAa9JqhtU5TUNeI3ba0VR6WY7alQHuB
         KdYv8cJM0di5saCu869INxDhuINKYA7wRDSeB376dxtDmpAg41LKwY6cy9agbl1FEi40
         koK+niYJ1YEKnbD57gJFlb3kuZVNRhEOBeJn0Tym5U4kc+gdTIZLdK7zP3D+17oXNW7R
         +j5jpfO+Z3rKMHfZIb+TYS2tVI4L6XXVKPlyaUgXXanjjsSq2PBmb8c0qeTZq83K2Z7W
         aezw==
X-Gm-Message-State: AC+VfDzOhcXeYU6dkAQk9OORcnIuSf7PGo5q31v0i2dsYjVugNEBcP4+
	OgoZISGDR66I0+7Xl6Cg2Qk=
X-Google-Smtp-Source: ACHHUZ6HwjjCbGWMwb0fPKqlW7kvU5qZZOlvGOlgsllBEHfiHIETvn6Y0pvj5+Z0kM1na1LsqU8OSQ==
X-Received: by 2002:aca:1006:0:b0:39a:6895:66f5 with SMTP id 6-20020aca1006000000b0039a689566f5mr52330oiq.3.1685641952316;
        Thu, 01 Jun 2023 10:52:32 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id c3-20020a544e83000000b0039a21e8c620sm1917130oiy.3.2023.06.01.10.52.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jun 2023 10:52:31 -0700 (PDT)
Message-ID: <54ab41a1-2982-aec3-bc03-454a2770aefd@gmail.com>
Date: Thu, 1 Jun 2023 14:52:27 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v2 4/8] rust: workqueue: define built-in queues
Content-Language: en-US
To: Gary Guo <gary@garyguo.net>, Alice Ryhl <aliceryhl@google.com>
Cc: rust-for-linux@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>,
 Wedson Almeida Filho <wedsonaf@gmail.com>, Tejun Heo <tj@kernel.org>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>, =?UTF-8?Q?Bj=c3=b6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 Wedson Almeida Filho <walmeida@microsoft.com>
References: <20230601134946.3887870-1-aliceryhl@google.com>
 <20230601134946.3887870-5-aliceryhl@google.com>
 <20230601183002.237a31fa.gary@garyguo.net>
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20230601183002.237a31fa.gary@garyguo.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/1/23 14:30, Gary Guo wrote:
> On Thu,  1 Jun 2023 13:49:42 +0000
> Alice Ryhl <aliceryhl@google.com> wrote:
> 
>> From: Wedson Almeida Filho <walmeida@microsoft.com>
>>
>> We provide these methods because it lets us access these queues from
>> Rust without using unsafe code.
>>
>> These methods return `&'static Queue`. References annotated with the
>> 'static lifetime are used when the referent will stay alive forever.
>> That is ok for these queues because they are global variables and cannot
>> be destroyed.
>>
>> Signed-off-by: Wedson Almeida Filho <walmeida@microsoft.com>
>> Co-developed-by: Alice Ryhl <aliceryhl@google.com>
>> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
>> Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
> 
> This looks fine to me, so:
> 
> Reviewed-by: Gary Guo <gary@garyguo.net>
> 
> Just one question about style: would people prefer:
> 
> 	kernel::workqueue::system().enqueue(...)
> 
> or
> 
> 	use kernel::workqueue::Queue;
> 	Queue::system().enqueue(...)
> 
> ?

I can compare the first with `std::thread::spawn` and the second
with enqueuing an executor with a future. Both makes sense to me so
I can't decide.

> [...]
