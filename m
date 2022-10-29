Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F622F2D
	for <patches@lists.linux.dev>; Sat, 29 Oct 2022 18:23:34 +0000 (UTC)
Received: by mail-oi1-f172.google.com with SMTP id l5so9303693oif.7
        for <patches@lists.linux.dev>; Sat, 29 Oct 2022 11:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gxoLAPS+9Ecu1s/8uDx34AXuA9lpWU9Z2smUFzhiANI=;
        b=FK30Xs8FfjGtUVZ701Q/u/E0K1xxm8c9h+UkHm2O3zOMPKAqIQn1h9Fmk1DzlhrNJY
         D7nWbR/fOZYEbLnPP7FF9oqz45BfN6sv37CKqyeFH55U2nsdbY0CjDWVTPjRpMyEmKIh
         Us53b1zCHyMg2DKt150e1V7XHIkZ3EumCqwi4vLSOlTGCXsIc1BPCim2stkACt/yxYPm
         YUHk86gUYe83QNj8MsHauRHwUBuMyApRY3sDucRtN5TxSY+LkX+yHn9IEe9wWkGe+7FG
         f5iO2owRwcStzOsTjw22iwgAfHfngVPKZdB/wf2LS16SruDIaHSC76qIoD3Y3cXkIMiE
         DmBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gxoLAPS+9Ecu1s/8uDx34AXuA9lpWU9Z2smUFzhiANI=;
        b=ORd79qaYTJmJJbMHjOrfl01Sjvk/DU2kyVceXvihvyZplK+3Wv86AeH8xOKhfXQYGE
         v51fLRcBgb9JBDv9f6LaOcoWcjMTv+IobK5uilkisvzyw0TBDTUpvrdmzSbVCrcK5iMa
         I3Yr1aAhnGnfaysB04Zfe143cyyQjDzrf7/P8qpzZ9PHF5N4GiZXogXHZx5+VG832RlR
         pY0OxoreXjrpxnWQe0u//2NiG1vT+AO1BVc+50WloYWUAcuT5rWQcUyP5BzRX3Sp4iHc
         Om8khO1EDQGOmcIsIF3+rzrHNio8OeLiBGXWb0OPcfwBHuZVA9Df2KIZN54JBJlIcwYa
         V67w==
X-Gm-Message-State: ACrzQf3PCf/2/SusdTIQjkBi+xsURJo6FqY9Z7MQHrr2W438qN3qwNfy
	cdq3whWIsqjyJLigKvUPj1I=
X-Google-Smtp-Source: AMsMyM64g3+ESxXBhNt55ABceWhd+VO4/vMH3BZ88BwJouOpyU7NkhgGB2mYjf8nfDYsgaKxWigPdA==
X-Received: by 2002:aca:3d55:0:b0:355:1ced:909f with SMTP id k82-20020aca3d55000000b003551ced909fmr10680391oia.60.1667067813195;
        Sat, 29 Oct 2022 11:23:33 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o4-20020acabe04000000b0035494c1202csm712709oif.42.2022.10.29.11.23.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Oct 2022 11:23:32 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Sat, 29 Oct 2022 11:23:31 -0700
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
Message-ID: <20221029182331.GA3324354@roeck-us.net>
References: <20220927131518.30000-1-ojeda@kernel.org>
 <20220927131518.30000-5-ojeda@kernel.org>
 <20221029174147.GA3322058@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221029174147.GA3322058@roeck-us.net>

On Sat, Oct 29, 2022 at 10:41:49AM -0700, Guenter Roeck wrote:
> On Tue, Sep 27, 2022 at 03:14:35PM +0200, Miguel Ojeda wrote:
> > Rust symbols can become quite long due to namespacing introduced
> > by modules, types, traits, generics, etc.
> > 
> > Increasing to 255 is not enough in some cases, therefore
> > introduce longer lengths to the symbol table.
> > 
> > In order to avoid increasing all lengths to 2 bytes (since most
> > of them are small, including many Rust ones), use ULEB128 to
> > keep smaller symbols in 1 byte, with the rest in 2 bytes.
> > 
> > Reviewed-by: Kees Cook <keescook@chromium.org>
> > Co-developed-by: Alex Gaynor <alex.gaynor@gmail.com>
> > Signed-off-by: Alex Gaynor <alex.gaynor@gmail.com>
> > Co-developed-by: Wedson Almeida Filho <wedsonaf@google.com>
> > Signed-off-by: Wedson Almeida Filho <wedsonaf@google.com>
> > Co-developed-by: Gary Guo <gary@garyguo.net>
> > Signed-off-by: Gary Guo <gary@garyguo.net>
> > Co-developed-by: Boqun Feng <boqun.feng@gmail.com>
> > Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> > Co-developed-by: Matthew Wilcox <willy@infradead.org>
> > Signed-off-by: Matthew Wilcox <willy@infradead.org>
> > Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> > Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  kernel/kallsyms.c  | 26 ++++++++++++++++++++++----
> >  scripts/kallsyms.c | 29 ++++++++++++++++++++++++++---
> >  2 files changed, 48 insertions(+), 7 deletions(-)
> > 
> 
> This patch results in the following spurious build error.
> 
> Building powerpc:allnoconfig ... failed
> --------------
> Error log:
> Inconsistent kallsyms data
> Try make KALLSYMS_EXTRA_PASS=1 as a workaround

I should have added: KALLSYMS_EXTRA_PASS=1 does not help.

Guenter

> 
> Symbol file differences:
> 10c10
> < 00009720 g       .rodata	00000000 kallsyms_relative_base
> ---
> > 0000971c g       .rodata	00000000 kallsyms_relative_base
> 12,16c12,16
> < 00009724 g       .rodata	00000000 kallsyms_num_syms
> < 00009728 g       .rodata	00000000 kallsyms_names
> < 00022628 g       .rodata	00000000 kallsyms_markers
> < 000226c0 g       .rodata	00000000 kallsyms_token_table
> < 00022a2c g       .rodata	00000000 kallsyms_token_index
> ---
> > 00009720 g       .rodata	00000000 kallsyms_num_syms
> > 00009724 g       .rodata	00000000 kallsyms_names
> > 00022618 g       .rodata	00000000 kallsyms_markers
> > 000226b0 g       .rodata	00000000 kallsyms_token_table
> > 00022a1c g       .rodata	00000000 kallsyms_token_index
> 
> This is the only difference. There are no additional symbols.
> 
> Reverting this patch fixes the problem.
> 
> Guenter
