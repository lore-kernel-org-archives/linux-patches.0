Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B48B2F2D
	for <patches@lists.linux.dev>; Sat, 29 Oct 2022 17:41:50 +0000 (UTC)
Received: by mail-oi1-f176.google.com with SMTP id p127so9221860oih.9
        for <patches@lists.linux.dev>; Sat, 29 Oct 2022 10:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uZvdF31LC8VEmM14x7xGiLTuqVkM63sQOLgHXVoVBzI=;
        b=NkQnTJI0iUr2kPR1GnapnO9oLyFU4/X22orc6ZFoZwhiooiQy97fVEwcPTZvkJ0nDn
         9D2wUbfBCYVD0laJJQI3RzFkVLtKtPecjYW89/bnkxzyq8SzLK/ZG7EZ0pIPtnD/RAaK
         o08xgPfYGl6foqO8+gciIoXfr+f8zOmBOJpgdtkl+tUY4ctEzJMJJFfG7K34pfa/vBP+
         FgdqIvK0IqJI0sxnOUDgYSi4QiYS6mdTQpERege0T7BxWrIlI22Z/d5pq6WNxQFebGNs
         M4iEREA7J2IIX3F8Y4ztrTDqbAuaijwABpfE+bms15Ixur6x8MAenL2Lfto9PWvPs8V1
         y3rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uZvdF31LC8VEmM14x7xGiLTuqVkM63sQOLgHXVoVBzI=;
        b=j3IPQpXcLWGPokT3WWFykF2w6QdWvXED62hOvaQ8+cSIEU81Qpl7zyCpAg9XGb778w
         6IZzrGB3wYw0M4q8Oqt0AkP/jAy7Uu2ps/vPRCZQzRMGYwFvRtcT7ZHFH4ymhr0r51V/
         truWkAOxJFA8ZSfkeL4vIRvM4nBbItTeEfZaLs20QAQs+LUXdZ+eHtef6VRTUG+pEoPI
         cGHBq6wOr0ha2SUDZsW/i20ECE+8vrd3ly0GNNxBbUNd/391iX0yISiGJ7dv37ujrSAs
         Lf8i/Mna6KXhVV7uUMrggukEko+7cfSpXh4MnI4XqGkqNEh9X9K+thSsJllkV0K+DxNI
         HMig==
X-Gm-Message-State: ACrzQf3rWyrbVpnEV+06aELQlJ2gg66pctO72Iam2hwWpYlCY2t5UPFK
	+TfM6fzAydTG8xK35LcQYVQ=
X-Google-Smtp-Source: AMsMyM5mMkBG1Gwv+jozQGrHxWn3biXJTmbq8UVa5xheGmmWykn+TfoIdLw7B+xZW56318OfuMhLfQ==
X-Received: by 2002:a05:6808:1886:b0:354:b8ea:4ddb with SMTP id bi6-20020a056808188600b00354b8ea4ddbmr2681448oib.222.1667065309129;
        Sat, 29 Oct 2022 10:41:49 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w7-20020a0568080d4700b003546fada8f6sm704370oik.12.2022.10.29.10.41.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Oct 2022 10:41:48 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Sat, 29 Oct 2022 10:41:47 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@google.com>,
	Gary Guo <gary@garyguo.net>, Boqun Feng <boqun.feng@gmail.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v10 04/27] kallsyms: support "big" kernel symbols
Message-ID: <20221029174147.GA3322058@roeck-us.net>
References: <20220927131518.30000-1-ojeda@kernel.org>
 <20220927131518.30000-5-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927131518.30000-5-ojeda@kernel.org>

On Tue, Sep 27, 2022 at 03:14:35PM +0200, Miguel Ojeda wrote:
> Rust symbols can become quite long due to namespacing introduced
> by modules, types, traits, generics, etc.
> 
> Increasing to 255 is not enough in some cases, therefore
> introduce longer lengths to the symbol table.
> 
> In order to avoid increasing all lengths to 2 bytes (since most
> of them are small, including many Rust ones), use ULEB128 to
> keep smaller symbols in 1 byte, with the rest in 2 bytes.
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Co-developed-by: Alex Gaynor <alex.gaynor@gmail.com>
> Signed-off-by: Alex Gaynor <alex.gaynor@gmail.com>
> Co-developed-by: Wedson Almeida Filho <wedsonaf@google.com>
> Signed-off-by: Wedson Almeida Filho <wedsonaf@google.com>
> Co-developed-by: Gary Guo <gary@garyguo.net>
> Signed-off-by: Gary Guo <gary@garyguo.net>
> Co-developed-by: Boqun Feng <boqun.feng@gmail.com>
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> Co-developed-by: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  kernel/kallsyms.c  | 26 ++++++++++++++++++++++----
>  scripts/kallsyms.c | 29 ++++++++++++++++++++++++++---
>  2 files changed, 48 insertions(+), 7 deletions(-)
> 

This patch results in the following spurious build error.

Building powerpc:allnoconfig ... failed
--------------
Error log:
Inconsistent kallsyms data
Try make KALLSYMS_EXTRA_PASS=1 as a workaround

Symbol file differences:
10c10
< 00009720 g       .rodata	00000000 kallsyms_relative_base
---
> 0000971c g       .rodata	00000000 kallsyms_relative_base
12,16c12,16
< 00009724 g       .rodata	00000000 kallsyms_num_syms
< 00009728 g       .rodata	00000000 kallsyms_names
< 00022628 g       .rodata	00000000 kallsyms_markers
< 000226c0 g       .rodata	00000000 kallsyms_token_table
< 00022a2c g       .rodata	00000000 kallsyms_token_index
---
> 00009720 g       .rodata	00000000 kallsyms_num_syms
> 00009724 g       .rodata	00000000 kallsyms_names
> 00022618 g       .rodata	00000000 kallsyms_markers
> 000226b0 g       .rodata	00000000 kallsyms_token_table
> 00022a1c g       .rodata	00000000 kallsyms_token_index

This is the only difference. There are no additional symbols.

Reverting this patch fixes the problem.

Guenter
