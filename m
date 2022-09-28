Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507DA2F22
	for <patches@lists.linux.dev>; Wed, 28 Sep 2022 14:59:00 +0000 (UTC)
Received: by mail-wr1-f50.google.com with SMTP id x18so20224936wrm.7
        for <patches@lists.linux.dev>; Wed, 28 Sep 2022 07:59:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=4bbjkrUOljrgmRoZno24QNrvhVLTbzBU814ynKHACuc=;
        b=SPjY34f//zLn1/lT/YHa9EEYUPdA4xqb6h6rIl7elqC9r7sXEezwCmxdz8rsirybzf
         ZxmX/Fp86FVHt2uqASquuNDmQXcK8TJfMxp+5s2Rp15/YfhlUj9XfTDqhWsTZQrvYEwL
         NH2SOwKchV+obSfqNnVg7J5jUBpo6YxvhsIWpOdYQ3bahq1jjGYn7kKZBY/PuZOA6OUU
         tY+LdHay/3gC66R86CyYeUpZqITYpyBxe526H+PN52RPVeIrXhVWrg9UFOlUmuf9RbxQ
         iYrNnGKvNZBdTB7tSK2RUh3Yg7x7KfSdKg8bI+Y4GUswPKQsqQQ5cvzrdv6q6tsL6lPU
         GVEw==
X-Gm-Message-State: ACrzQf2fk9XFKZVuntIEc6jnY4IX6dDFS5KFaLd2j43uBuNlFTDEiVsA
	yEz1AUqbLUbkLMjbaJv/wVg=
X-Google-Smtp-Source: AMsMyM5RKbnXhzfaWq66o8aetgmUIRnVCf4JDu5bDRQ8blAeKzo1UhI1ScAeK0mArkDtTC0Zqp5D4g==
X-Received: by 2002:a05:6000:1565:b0:22c:8da7:3cf8 with SMTP id 5-20020a056000156500b0022c8da73cf8mr15576161wrz.688.1664377138583;
        Wed, 28 Sep 2022 07:58:58 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id m21-20020a05600c4f5500b003a5f54e3bbbsm2206752wmq.38.2022.09.28.07.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 07:58:58 -0700 (PDT)
Date: Wed, 28 Sep 2022 14:58:56 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Kees Cook <keescook@chromium.org>, Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH v10 01/27] kallsyms: use `ARRAY_SIZE` instead of
 hardcoded size
Message-ID: <YzRhMBE+QoBpghNl@liuwe-devbox-debian-v2>
References: <20220927131518.30000-1-ojeda@kernel.org>
 <20220927131518.30000-2-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927131518.30000-2-ojeda@kernel.org>

On Tue, Sep 27, 2022 at 03:14:32PM +0200, Miguel Ojeda wrote:
> From: Boqun Feng <boqun.feng@gmail.com>
> 
> This removes one place where the `500` constant is hardcoded.
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> Co-developed-by: Miguel Ojeda <ojeda@kernel.org>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Wei Liu <wei.liu@kernel.org>
