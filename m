Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73BB54BDE
	for <patches@lists.linux.dev>; Tue,  7 May 2024 22:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715119737; cv=none; b=dh0O1/SAcHcwA+FRKztmhM7Q7sL2X4aBVdsk/DM253Vsefeu/Om+vokl+t8wxyCL9RIGdFzoZ7OqXxqOC8rxgPnNKpgakYfTs2Bn4pkbUiOnSBHWti5WWoD2bYupb2z3UKQqy4SnSg15jye8/6lsnbIBEjKQs0Vjw4I+IG8/tmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715119737; c=relaxed/simple;
	bh=Qf1W05Wsq1RECY5871UQtu6YYQQ2FFsJYl+cvLY91W4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WZUxmfT/LrX5H8QZnrw70sflHSCpWgVbqk50X1mpi17nCVZ2Z3IkTQBDjHokW/gYwzv5uKAInnSnFpynVEHTxOyjnLbkP0VNN1QTDrlDgZF8ktuGJsXzd7HZ2tBALpDeMizN727eb/taUuCxP3nOLUOWfODnUIoGzk5HiLku0BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qg0UxoP6; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qg0UxoP6"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-6f0307322d5so1870228a34.0
        for <patches@lists.linux.dev>; Tue, 07 May 2024 15:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715119735; x=1715724535; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :feedback-id:from:to:cc:subject:date:message-id:reply-to;
        bh=p3+3MfLUAKF4/pyGWC5WWqt+QStMiPGpndQCb8QPFNA=;
        b=Qg0UxoP6CYgGJlmP76PwtY33eNaPlmc9mtMiv2wHR116X4QOxtefyItK5dFWuFK6M4
         ULkGq91tx/JAru/SqkCaj8X/GeRBsf7N1rrE7WJcjk7PXQUdnI9ewX8q4xC5rs33rtAA
         H90Zpb70zcLcCBCdtl3eCtdrRRac3AjM+5GSkAocar5FyBWS873rg6nlvWuwxmnX2X0T
         j/oDropCj5yIrXklNAIOjGwf5HXrdB4KvTHV7vrrzZnd9W4DH6pphNtM4SoAVnlRbWl9
         DaP6DP2h+DSF/ehLT3VCPFtVIQ7MXvDULQqKevlBv0SBJ0wVzfBoVfSXxc4VtajPPjLJ
         6dpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715119735; x=1715724535;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :feedback-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p3+3MfLUAKF4/pyGWC5WWqt+QStMiPGpndQCb8QPFNA=;
        b=pZSDv0szfI0tOmBzPdn46xltRvsUyqYbH977tHl174XIV3Ln1TtVygEkng+BCP/MDv
         g+oYBjUab5rQynQJqDkSOfKDGGqbD1+6LydEBW/n1oghtjhi9Yxjhz/znBFTuaKgcjS/
         ckoAMWc2iwOU+3B6hf2UZiZqcoFm11PILggvPKmBtRP3qNZ1wnrmHAw0aG7RN3lZ7shA
         eEXUIZdpG5Dlt1fOj6VO736QD4tsGVNQfhWQtMzd+Zt91RLxf9NGpbvvdz/QcG5Z5WuE
         y1NURcF1lohtjyvwb/XGQ/N3GeZvKoMQQNGSfw1iIuzWalBkSy9tZ9HqBcwgFkYJ1eNQ
         0msQ==
X-Forwarded-Encrypted: i=1; AJvYcCXxFuaiMX/veDfbZxEsUOWsHkv8l+Vik9X5jjB3W++N83KDVDKGhhhX9VCM6MVLWkLBMbkTPpdSMIq9KFbxrlUqZralOEaZoA==
X-Gm-Message-State: AOJu0Yz4CwRGTmQbA34hVGimDpXyj7kG06EMDE9QqWcvT2/awX/7MmgB
	gO9VIBBMqssBQLLq88bhHQ5GDksDSIUtMIgrCoX55aMEr9Smf3xA
X-Google-Smtp-Source: AGHT+IFqAzgfZRwusaHEZcuv1Ns5uHfe4qjx+iM2rzZ6X9V0WgPzMGL68fJUAfE0eSEilsOaCTg2Og==
X-Received: by 2002:a9d:6756:0:b0:6f0:45ad:24b3 with SMTP id 46e09a7af769-6f0b7e9723bmr839188a34.26.1715119734884;
        Tue, 07 May 2024 15:08:54 -0700 (PDT)
Received: from fauth1-smtp.messagingengine.com (fauth1-smtp.messagingengine.com. [103.168.172.200])
        by smtp.gmail.com with ESMTPSA id po10-20020a05620a384a00b0079299933594sm2367246qkn.95.2024.05.07.15.08.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 May 2024 15:08:53 -0700 (PDT)
Received: from compute7.internal (compute7.nyi.internal [10.202.2.48])
	by mailfauth.nyi.internal (Postfix) with ESMTP id C94FC1200032;
	Tue,  7 May 2024 18:08:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute7.internal (MEProxy); Tue, 07 May 2024 18:08:52 -0400
X-ME-Sender: <xms:dKY6ZpnY9VmC-D5u6nPmqGophoFpqwkpzT4OMVdYpFuCSrAcOIdj3g>
    <xme:dKY6Zk3LSNGOiWA-CgHrh3tClT_Oz7zHSDa9v2Fq-reTK7B5Dva8dt4kC1Vl-mLBy
    UzFea8uScsT1I2vCw>
X-ME-Received: <xmr:dKY6ZvoVAqtYYLtuGvX9zlZxWde_yeRaay1etZVxQWXARIKkVNsY-rf8vQI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrvddvledgtdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggugfgjsehtkeertddttddunecuhfhrohhmpeeuohhq
    uhhnucfhvghnghcuoegsohhquhhnrdhfvghnghesghhmrghilhdrtghomheqnecuggftrf
    grthhtvghrnhepuefhledtjeeijeeuudelieekudfgkeeifeethfelgfekhffffeehgffg
    heffhedtnecuffhomhgrihhnpeiiuhhlihhptghhrghtrdgtohhmpdhkvghrnhgvlhdroh
    hrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegs
    ohhquhhnodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdeiledvgeehtdeige
    dqudejjeekheehhedvqdgsohhquhhnrdhfvghngheppehgmhgrihhlrdgtohhmsehfihig
    mhgvrdhnrghmvg
X-ME-Proxy: <xmx:dKY6Zplj_QIOzR3y0oKEwyRbYF9ERQx4DrkEgr6EdP447XGLpxdkKw>
    <xmx:dKY6Zn2irqgGWuu3TTydWHdF6C3OGGyGrxKA9Tn0c1V1K6fLPwddMw>
    <xmx:dKY6ZosZemq54WiSiHmk0FdSG2nu3UsZ_rk4-6H9A2vwXq-S63PN5Q>
    <xmx:dKY6ZrVTsZHXFhKR6iY17Pv4qJV6OqNpxfLcUPAMsIkwLtOcd58Ucg>
    <xmx:dKY6Zu0OQoNgfQr9MzdNJGVIExjBgNvmO8bUc9M6oX3rDiZcS8DDweZF>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 7 May 2024 18:08:52 -0400 (EDT)
Date: Tue, 7 May 2024 15:09:00 -0700
From: Boqun Feng <boqun.feng@gmail.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas@fjasle.eu>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>, linux-kbuild@vger.kernel.org,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Sergio =?iso-8859-1?Q?Gonz=E1lez?= Collado <sergio.collado@gmail.com>
Subject: Re: [PATCH v2] kbuild: rust: split up helpers.c
Message-ID: <ZjqmfIhRz99BqXtD@boqun-archlinux>
References: <20240507210818.672517-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240507210818.672517-1-ojeda@kernel.org>

On Tue, May 07, 2024 at 11:08:18PM +0200, Miguel Ojeda wrote:
> From: Andreas Hindborg <a.hindborg@samsung.com>
> 
> When rebasing patch sets on top of upstream Linux, merge conflicts in
> helpers.c are common and time consuming [1]. Thus, split the file so
> that each kernel component can live in a separate file.
> 
> Each helper file is listed explicitly and thus conflicts in the file
> list are still likely. However, they should be simpler to resolve than
> the conflicts usually seen in helpers.c.
> 
> Link: https://rust-for-linux.zulipchat.com/#narrow/stream/288089-General/topic/Splitting.20up.20helpers.2Ec/near/426694012 [1]
> Signed-off-by: Andreas Hindborg <a.hindborg@samsung.com>
> Reviewed-by: Sergio González Collado <sergio.collado@gmail.com>
> Tested-by: Sergio González Collado <sergio.collado@gmail.com>
> Link: https://lore.kernel.org/r/20240416074607.1395481-1-nmi@metaspace.dk
> [ Reworded message slightly and fixed nits in it. Applied commit
>   84373132b831 ("rust: helpers: Fix grammar in comment") here. Added
>   SPDX license identifier in new Makefile. Applied Markdown formatting.
>   Added `.gitignore`. Included `helpers_combined.c` in the `clean`
>   target. - Miguel ]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

This overall looks good to me, one thing below I think should be
changed..

> ---
> This is a patch from Andreas that I was going to apply to `rust-next`
> with the tweaks mentioned above, but I noticed Kbuild was not Cc'd, so
> we decided to send this as a "v2" and thus give a chance to Kbuild to
> take a look for next cycle.
> 
> If something in the diff to v1 is wrong, it is my fault, not Andreas' :)
> 

[...]

> diff --git a/rust/helpers/build_bug.c b/rust/helpers/build_bug.c
> new file mode 100644
> index 000000000000..f3106f248485
> --- /dev/null
> +++ b/rust/helpers/build_bug.c
> @@ -0,0 +1,10 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/export.h>
> +#include <linux/errname.h>
> +
> +const char *rust_helper_errname(int err)
> +{
> +	return errname(err);
> +}
> +EXPORT_SYMBOL_GPL(rust_helper_errname);

.. this build_bug.c should be avoided, but this function should go into
err.c.

Regards,
Boqun

> diff --git a/rust/helpers/err.c b/rust/helpers/err.c
> new file mode 100644
> index 000000000000..fba4e0be64f5
> --- /dev/null
> +++ b/rust/helpers/err.c
> @@ -0,0 +1,22 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/err.h>
> +#include <linux/export.h>
> +
> +__force void *rust_helper_ERR_PTR(long err)
> +{
> +	return ERR_PTR(err);
> +}
> +EXPORT_SYMBOL_GPL(rust_helper_ERR_PTR);
> +
> +bool rust_helper_IS_ERR(__force const void *ptr)
> +{
> +	return IS_ERR(ptr);
> +}
> +EXPORT_SYMBOL_GPL(rust_helper_IS_ERR);
> +
> +long rust_helper_PTR_ERR(__force const void *ptr)
> +{
> +	return PTR_ERR(ptr);
> +}
> +EXPORT_SYMBOL_GPL(rust_helper_PTR_ERR);
[...]
