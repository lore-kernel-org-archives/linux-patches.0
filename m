Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3366521CE7
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 14:58:38 +0000 (UTC)
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-19a13476ffeso1091710fac.0
        for <patches@lists.linux.dev>; Thu, 01 Jun 2023 07:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685631518; x=1688223518;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kKA7bXeTxOFAGtKnHALKsnYjOqM8LI5Ovc7qv8nHXy4=;
        b=VbnEgHTh9xF4ebL07QtrT7IKBEyHLCw0QVrUCnHaD6hD1lvRPslcpTX91zn3hAvWzx
         ulibMwWZFHmSArR1Js46N5RKP2nJv9bdUpXM2WSng5LizAhofHiXTVQQfqca6v+jPXKe
         HvtDu/CfmB1slVve+kXxvvQ0BgNQJ3XFLLqvuZMoYiQKb3LIzutxDOewUsQMmH2E5ZVa
         nUHXWQZZVE+BdWPLsAQyGecmA2uHxI7IzhaUVupAxOYA0OiDDmvfeGiXAf73/Shha1Et
         jaG3ST69YQfcksirDQfDNwj+0zv225EuOKqX49xfmOB8NdSNiTprBZaCstS6qLkW7u3s
         Wowg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685631518; x=1688223518;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kKA7bXeTxOFAGtKnHALKsnYjOqM8LI5Ovc7qv8nHXy4=;
        b=FQp4khVUuwqq+yHqenLEOuoraFUSMJ/t5qc8ZBW+EtSS+LpiuHE+UpJYG7L30IA+99
         U+6KiFTq1g8oFBsaCbvjW62H9T3C+4ZD8T8zvre8qZca+WUtygjQd1/OLwq2UDlFXs6i
         9IJtc0bVlox1ve9eNn0V5hS/peXuw2ECDLVpTpU+L9Mq0fhKxXeotdSJaDPNLc5wZcA6
         Gyfx/OKAgq/Dbl0HFdeH0ixENq+ZDahhlwE1YV4GI4FvnVwBBpdJFbw/g+S3Pqq/CptK
         JA9YuAZgsTYerB5NdCCu+QSY6ttsd1aU4oUhYdWn73n3tNaWARxl1UKq9baj5p4WvyFv
         fE5g==
X-Gm-Message-State: AC+VfDz3CuZqyebvyFkcNa+wrDyrPqjB3V6QiCYeZKoDAqjAizYOFxV5
	GPn7TiwLQidRYqA8tuOf/+o=
X-Google-Smtp-Source: ACHHUZ6yE1Id0grKqywwZgmTdnr0O2dPuH6cit6vXBQMcYrvks7tA0S44ZEnYsykFDZRKmPXN90PAQ==
X-Received: by 2002:a05:6871:6bb0:b0:19f:af14:9e60 with SMTP id zh48-20020a0568716bb000b0019faf149e60mr5853140oab.8.1685631518122;
        Thu, 01 Jun 2023 07:58:38 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id q7-20020a056870e60700b0019ea8771fb0sm1757100oag.13.2023.06.01.07.58.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jun 2023 07:58:37 -0700 (PDT)
Message-ID: <5e5e1590-ad97-4590-1db8-8ce89840b9e3@gmail.com>
Date: Thu, 1 Jun 2023 11:58:01 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v2 8/8] rust: workqueue: add examples
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
 <20230601134946.3887870-9-aliceryhl@google.com>
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20230601134946.3887870-9-aliceryhl@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/1/23 10:49, Alice Ryhl wrote:
> This adds two examples of how to use the workqueue. The first example
> shows how to use it when you only have one `work_struct` field, and the
> second example shows how to use it when you have multiple `work_struct`
> fields.
> 
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
> [...]

Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
