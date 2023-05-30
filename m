Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFD8134C8
	for <patches@lists.linux.dev>; Tue, 30 May 2023 13:23:14 +0000 (UTC)
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-19f454bd2c8so2288894fac.3
        for <patches@lists.linux.dev>; Tue, 30 May 2023 06:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685452994; x=1688044994;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fMNSQewRslTTM3ryH1hSW9tsjlBjJbSYLIcYAPdfTm8=;
        b=Ngm/jZ0C5Q+NbA+yGe/TmaSY8mt/WOmGrqzXtYoxvTUU8NZfrDFO1HwI5IJQdbHqhn
         lowU4zLein+etGYsdpQWXsifP9hlwMeeiXGXNsZPi8ovnJnuWGrl9ijUEFHorVUdJRR5
         h5uwfkdwJwNHKYMQCM+SpHKySNsDNYUTC8Q0N91QuO9nKOrQlOmSk1kGXWzVX2H2/zOW
         Mlpb8jnAIU2omz2E5NZKtYPDuAg8DbznalgJHV7ZHSMpLSJKXe1ccuhDZdcWrN1oD6nv
         Yv7viv/NWEsYhqqm+NMlDD0xFZBhnuNBXieb1kf+PmsFhzKmdpU1zrOdJQxl4xjcPuzq
         9X9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685452994; x=1688044994;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fMNSQewRslTTM3ryH1hSW9tsjlBjJbSYLIcYAPdfTm8=;
        b=ZUR8nvZGBq78dAwfKIOvaQbC0cDdDRr8Bra+RyapDGlTE0OKA7/yF997WdbFwPhlfm
         fgD6UMMyiBYUVwvj7IQrfF/eQP6UnQSP1BsG9qkM+Aeqy/nOZ7vbdshYy5HcUVKSEjY/
         8qQdC8Zl7503Fj8U7p6bZlRwPtjd8Qlzq+Wb9eWDLxiWNhLx8Icxj6rf1hrgET4SKz4+
         mkyMyQut02gfJdqc4z4srUjdeapb0YiaBp4SwFOJzWXY9vw361rrrnI8MaQFlyRz4MKS
         +cw3XEeDCxKd12bX8TXE6xk2LJCPnz4LGhhzjtqH2cVoMxx/q6Cl2l3PWhgjsjb0N1MH
         wqgA==
X-Gm-Message-State: AC+VfDwW4hf8iUnV9fm89RMnOQoyxojU1vKl7JDOZhCei3mmN6Eoz4hT
	l90y7A5sBKh4JBNDyYHIPMI=
X-Google-Smtp-Source: ACHHUZ5fJ5/CZJU+0D+6o27bvrgi4iHhxfbFd9EVzO8mHxFNv8cO6H+JuweFU8OBq7zmgNQqBVYwmA==
X-Received: by 2002:a05:6870:3c11:b0:19f:9dc5:c0b with SMTP id gk17-20020a0568703c1100b0019f9dc50c0bmr705762oab.12.1685452993776;
        Tue, 30 May 2023 06:23:13 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id g7-20020a056870214700b0019edd086f33sm5692768oae.41.2023.05.30.06.23.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 May 2023 06:23:13 -0700 (PDT)
Message-ID: <08508ddf-fda7-0a19-a8ce-b65c0e9a7903@gmail.com>
Date: Tue, 30 May 2023 10:23:08 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v1 6/7] rust: workqueue: add safe API to workqueue
Content-Language: en-US
To: Andreas Hindborg <nmi@metaspace.dk>, Alice Ryhl <aliceryhl@google.com>
Cc: alex.gaynor@gmail.com, benno.lossin@proton.me, bjorn3_gh@protonmail.com,
 boqun.feng@gmail.com, gary@garyguo.net, jiangshanlai@gmail.com,
 linux-kernel@vger.kernel.org, ojeda@kernel.org, patches@lists.linux.dev,
 rust-for-linux@vger.kernel.org, tj@kernel.org, wedsonaf@gmail.com
References: <b54801cd-1afb-2190-3b8a-4a095d04fdff@gmail.com>
 <20230523110709.4077557-1-aliceryhl@google.com> <875y8ab7y0.fsf@metaspace.dk>
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <875y8ab7y0.fsf@metaspace.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/30/23 04:19, Andreas Hindborg wrote:> I prefer the first one, but both look OK to me. Is one more idiomatic
> than the other, or is it just a matter of personal preference?

Pedantic Clippy will deny a boolean match and I prefer if-else over it
because the latter it's explicitly purposed for boolean control flow.
