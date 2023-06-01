Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EA223A1
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 14:58:14 +0000 (UTC)
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-6af812703b6so532604a34.1
        for <patches@lists.linux.dev>; Thu, 01 Jun 2023 07:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685631493; x=1688223493;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X7JUXb4aekIO7D0dwVI5AuAQfE3+chmPdfkriZKP4oc=;
        b=hUtoI2Xw9zWxiDj/JBLrkcDDAhfU/tIFo3Ygbc1lvfNWZeeMG/Y0A2tU/mGCGwp5vX
         Em13bPhvXK/egyjaa2iz2O92KWyyEFX6flvLFNvKPP8k7hww5wkwMmOJ3OkNXIYpneB7
         DDe2Qn3htGY7pp6PKL/E2r8etImEyb4WkeqYRRA8OmWldZmZX06VoQ8EqEEb1NWMvwCf
         nhhE2DsdGl5ELAF0nhgeL/J0z5r6b29PlWpK29HRKv4sbPhozZ6S/bxZWYEgeIBCxf1V
         XLyvXmdfb8PdUEjExyV76DzTMKNg6Ciq9IuM+HaiODcBQqmKySJpDx59DJn8L9f8mmEV
         /pFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685631493; x=1688223493;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X7JUXb4aekIO7D0dwVI5AuAQfE3+chmPdfkriZKP4oc=;
        b=dxbwTg45Y7N0yMAcggiMJI6PwN0/HjWzWNStDfajI+3AVx6WSeVQJmGtE6TbOeloY/
         jG1zw/fl8nEMjz0Cnad5Uf5eS6XUgY69yZyj7FlWtkWQxFPu/ya7KM6/T79M8rLVapxE
         ss0hOKeegYmZJwLM0MJNga4Y2tlaJYGTh9z7V5yFvoS30RuRUEOkC/QCMDLM1Bo9EH+U
         Fqx0L/pqDYvJGPbYRJ6/UUzfp67/zzw7tZVrN+gCe7Mt2bY40cO9oo15CVyDMmmLhKrq
         m9FwqfeUreeU7by10DrAUMzNP0EMrDx/yfjD+Q7uTuufEEfwr7HHWWawfmqxBKPxB6QM
         9xTQ==
X-Gm-Message-State: AC+VfDwPmZUQT26NBkCkra0ZPnmDiRaveVUtl6KiMz/6fkZNWcCXda2D
	BhdWnbwTRJSdIn4DZGV/MnwcxJIsVf0=
X-Google-Smtp-Source: ACHHUZ4YgNF1X1qC5DtatbgdKTWP9tAFJUDfB6mX3y1C/RZoBttT9v2AoVM3fzFwTLLeRJ3zs0p8sA==
X-Received: by 2002:a9d:6213:0:b0:6b0:c711:8dd1 with SMTP id g19-20020a9d6213000000b006b0c7118dd1mr3410348otj.14.1685631493201;
        Thu, 01 Jun 2023 07:58:13 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id w15-20020a9d638f000000b006a42e87aee4sm1593045otk.32.2023.06.01.07.58.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jun 2023 07:58:12 -0700 (PDT)
Message-ID: <77706c31-7fc6-9af7-bcbc-bd27a9757806@gmail.com>
Date: Thu, 1 Jun 2023 11:29:11 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v2 1/8] rust: workqueue: add low-level workqueue bindings
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
 <20230601134946.3887870-2-aliceryhl@google.com>
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20230601134946.3887870-2-aliceryhl@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/1/23 10:49, Alice Ryhl wrote:
> Define basic low-level bindings to a kernel workqueue. The API defined
> here can only be used unsafely. Later commits will provide safe
> wrappers.
> 
> Co-developed-by: Gary Guo <gary@garyguo.net>
> Signed-off-by: Gary Guo <gary@garyguo.net>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
> [...]

My Reviewed-by is missing.

Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
