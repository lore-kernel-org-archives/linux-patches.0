Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3802F22
	for <patches@lists.linux.dev>; Wed, 28 Sep 2022 15:07:01 +0000 (UTC)
Received: by mail-wr1-f45.google.com with SMTP id s14so20355271wro.0
        for <patches@lists.linux.dev>; Wed, 28 Sep 2022 08:07:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=qREYIWjuGjLGDeO/dgifyqQc1nhCGZnGcZ9iHgJIHrM=;
        b=GpOlj41GbLyJUMgZTtMxvSjwpa8n2yUhASqp/ebx0MgcUs7cDx/D7pm2+8VbyZzjmD
         3vV6sAkRcXKcEZx/eZ9I8mOzSVtUnt5TkZAjPrmCIhmSH3tSItzF6hIvkQ6q1xP6HS88
         drGUhcoDp44p2i6XU91GzB3fZga6p1QKfCuFlJfLhReJpvN8sjOySOsXxXCPpJB5n8iX
         VfCEOoItR4RTeYXX/q+x4YnHl3BX7XY9XWs0MqYM9ane70P1STXIY1VB7N0hP7kN4HqP
         TdQJSDmV/8g4NnKNRQ+zLkxYm2IP09KAYeqbYExrObbyfbgaJjbF6YPFztCXXPukQsG2
         RolQ==
X-Gm-Message-State: ACrzQf00d7XT97s45BcFZ/vnjsPCeV9DxmNtkbh84SUAoWEGDcHnF8ZC
	LueNjM5ybPE2nYmAGGLvLWM=
X-Google-Smtp-Source: AMsMyM5FFV4aX5J6YjdrDCbVIvl3V6P8/lD53lGFfc9W3f5bjY3hHbBprT2F7AKvWApQc2n4Pf+ISQ==
X-Received: by 2002:a05:6000:1acf:b0:22b:36ad:28e with SMTP id i15-20020a0560001acf00b0022b36ad028emr20180294wry.314.1664377619666;
        Wed, 28 Sep 2022 08:06:59 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id f4-20020adfe904000000b0022ac38fb20asm4355010wrm.111.2022.09.28.08.06.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 08:06:59 -0700 (PDT)
Date: Wed, 28 Sep 2022 15:06:57 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>, linux-doc@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linux-perf-users@vger.kernel.org,
	live-patching@vger.kernel.org, Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH v10 00/27] Rust support
Message-ID: <YzRjEc9zQbHeWPFL@liuwe-devbox-debian-v2>
References: <20220927131518.30000-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927131518.30000-1-ojeda@kernel.org>

On Tue, Sep 27, 2022 at 03:14:31PM +0200, Miguel Ojeda wrote:
> 
> Miguel Ojeda (22):
>   rust: import upstream `alloc` crate

I cannot find this patch in my inbox. That's probably filtered out by
the mailing list since it is too big.

I've gone to GitHub to take a look at the commit
753dece88d70a23b015e01674a662e683235c08f in the `rust-next` branch. It
looks good to me, so feel free to add

    Reviewed-by: Wei Liu <wei.liu@kernel.org>

to that patch.

Thanks,
Wei.
