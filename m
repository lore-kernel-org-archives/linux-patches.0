Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2233D74
	for <patches@lists.linux.dev>; Wed, 28 Sep 2022 14:59:24 +0000 (UTC)
Received: by mail-wr1-f52.google.com with SMTP id n10so20178270wrw.12
        for <patches@lists.linux.dev>; Wed, 28 Sep 2022 07:59:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=AX/XCxhpdbVVHbhyunySUg3dFfYwUm6jVR02ydVl864=;
        b=RHFBv2/Dg3Ita56AKDv0L7K2FeECo2qPJwjP702ml1aWx+0S6J88drHahjkXoqsSdu
         8uJt3HyQ+ecCAFknQ61C7SQhotqgONfwp/mgSN/pcaTvXKWqvaxJcazX3Fpj382wslJ8
         T4+vV5Lsx5EKjkvjN6CQMLlssEi2J06n2vLohtqH+dhWi/Gb/y2zRXVmu/JF+tzcxk8s
         d2pjba9a7K+QmmZ/nkQMdKWni7/feFh8rSVGemAD9+VUQlR8pAHqn97Hd52od34T6w0t
         izNV4uYaTUTtljamEip9pizBdKmlnn6Kyx8mfmxRZ9b8268eDZapATztI21XKn+E+nDs
         QmqA==
X-Gm-Message-State: ACrzQf0dwU04eJ/u8YAJzabacHD2BYzMwfTSMXre8UG4QY6C3adifpK2
	fVlYTUcDj3nfTv7OdZAnd6M=
X-Google-Smtp-Source: AMsMyM650KPDXUhvVyBLF0kqvjrxyaYRuq5nqe51aXlk0h3C0AQ/x0l1j5SwC8jkwKaQOnXhBILMaw==
X-Received: by 2002:a5d:5b0a:0:b0:22a:f83a:2b6f with SMTP id bx10-20020a5d5b0a000000b0022af83a2b6fmr21403721wrb.176.1664377163416;
        Wed, 28 Sep 2022 07:59:23 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id n3-20020a5d4203000000b0022acb7195aesm4458839wrq.33.2022.09.28.07.59.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 07:59:22 -0700 (PDT)
Date: Wed, 28 Sep 2022 14:59:21 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Kees Cook <keescook@chromium.org>, Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH v10 02/27] kallsyms: avoid hardcoding buffer size
Message-ID: <YzRhSaJph/wo0OqY@liuwe-devbox-debian-v2>
References: <20220927131518.30000-1-ojeda@kernel.org>
 <20220927131518.30000-3-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927131518.30000-3-ojeda@kernel.org>

On Tue, Sep 27, 2022 at 03:14:33PM +0200, Miguel Ojeda wrote:
> From: Boqun Feng <boqun.feng@gmail.com>
> 
> This introduces `KSYM_NAME_LEN_BUFFER` in place of the previously
> hardcoded size of the input buffer.
> 
> It will also make it easier to update the size in a single place
> in a later patch.
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> Co-developed-by: Miguel Ojeda <ojeda@kernel.org>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Wei Liu <wei.liu@kernel.org>
