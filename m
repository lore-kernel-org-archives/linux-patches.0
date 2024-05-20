Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8ECD45026
	for <patches@lists.linux.dev>; Mon, 20 May 2024 15:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716218679; cv=none; b=gKkn5Dj43wH8IfA5JaNM9je0mkFuCsabZr3L1DckwGx5esmyv5lMtWnqZpYY9BahE4vPDSh2qI3wFbrmRAMp2dXO+s0wKYHuJ2Zn/+u6ceEwANXtD/aKhcX4dbzG+470Hj0FCt7OiNQV2ipWCFW+i17Qinf4DKUyDrAYxKDMrEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716218679; c=relaxed/simple;
	bh=/bYutIsSrxoty/i0tqxvH1agSRzviA7eI9qMo7lmngg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=sMJTHo73SlRok18lN6jevYq8q6WCTiGZgBTcs9YjxrznzNOkBipW4uL+1Tk0b3EULYxNW3FzEPzhGShnkhwspwJGCIv8f3HyBKgSHNqkrGEWrSz1Vp9TG4boMYNH3uhPM2rtM8nUw4I75z/i41wy+OqxulYZEG1L6YKfGObdfVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J/NxzsHE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J/NxzsHE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716218676;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MPzD2EYz+Tws56HwE5fNBA/4Wwv6n6zB3tlyojChHUw=;
	b=J/NxzsHEf6OCSitqSjOsgtr0U/A95AAJbZkP52gRbIOND2QALRM/mwoonwxCvkZu3M7l7y
	amxxSbNjy1E4XWdNdWaUtd2T4oBO5M7U0w4Wm4ryoH4sMkYJkxmNqbGmilO14csCVFjjs+
	f8eYrdAO1H7XYwGxaBo1meO2s2trLvM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-124-dpyqvjXeOMGGZLYaTeWFSA-1; Mon, 20 May 2024 11:24:35 -0400
X-MC-Unique: dpyqvjXeOMGGZLYaTeWFSA-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-42003993265so43458525e9.1
        for <patches@lists.linux.dev>; Mon, 20 May 2024 08:24:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716218674; x=1716823474;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MPzD2EYz+Tws56HwE5fNBA/4Wwv6n6zB3tlyojChHUw=;
        b=XzEp9m/k5IMS+rgETAbyf++tJIIN2EAkuRs1grrC3DxICZHG2ddPKLGdl1MxgU6K78
         QJzl2SSHI7bu5kra/wfKfONK10au6znys/Kle1+YEc0Wd2sk9VIkpnts6+2t5YO8u33s
         ajzUjaOIumuZvkttm36+scymGKodcSXjl4WqX3JWl/KrcoIuNgm/KrsDJsT+4A2hbhIq
         UaQG8g08SPpPox51Ju7OUSiMUcdhhcaNdjspKCaS3os5/IDCl08nOfZpZyfT14Rvi4Ic
         bQGBuXceq0njxWsnQEqWzPk0CmKJ1hsBy/JUnx7w4krWbHsCYTEUNBXWtCdPsZDqxjZu
         Rcrw==
X-Forwarded-Encrypted: i=1; AJvYcCXhu79bK33xK+NUC2LRVyGrFcn46D/P4qTvsaqJc0or+Vd65lZcVB3lXy+bCafLexegjnlmklvbHO1leQtb9yE2AHej6xe9wQ==
X-Gm-Message-State: AOJu0Yw8uF4DGhNcSLeRiMG3k3UqRAnoogqctUMA1Lmxd6vUSNARNdCN
	0u3QqWFA6L2oiyDVRCBe0IrbeSzh1WBwQY0YSXMCPabSbNh0qV/4r83c6nyGySmlb/yVGb9/Ypf
	ykNnDsiHjBcmX3hfqRMJMiHlWTpaZvSEc0JM/IXBU0sKrpcCmDNriIbE=
X-Received: by 2002:adf:f746:0:b0:347:3037:188d with SMTP id ffacd0b85a97d-3504a737594mr27533412f8f.34.1716218674167;
        Mon, 20 May 2024 08:24:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFybBVRF9qV0XR+xTmYzrgRY5zsNr68gufSFbFaQHscL73I++QGoGy2M8cBG9NDuhAutpTMuA==
X-Received: by 2002:adf:f746:0:b0:347:3037:188d with SMTP id ffacd0b85a97d-3504a737594mr27533388f8f.34.1716218673765;
        Mon, 20 May 2024 08:24:33 -0700 (PDT)
Received: from pollux.localdomain ([2a02:810d:4b3f:ee94:d829:d5ef:3adf:70e2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3502b79bc8esm29279979f8f.15.2024.05.20.08.24.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 May 2024 08:24:33 -0700 (PDT)
Date: Mon, 20 May 2024 17:24:31 +0200
From: Danilo Krummrich <dakr@redhat.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] rust: avoid unused import warning in `rusttest`
Message-ID: <ZktrL5YcHx6kKtLR@pollux.localdomain>
References: <20240519210735.587323-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240519210735.587323-1-ojeda@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, May 19, 2024 at 11:07:35PM +0200, Miguel Ojeda wrote:
> When compiling for the `rusttest` target, the `core::ptr` import is
> unused since its only use happens in the `reserve()` method which is
> not compiled in that target:
> 
>     warning: unused import: `core::ptr`
>     --> rust/kernel/alloc/vec_ext.rs:7:5
>       |
>     7 | use core::ptr;
>       |     ^^^^^^^^^
>       |
>       = note: `#[warn(unused_imports)]` on by default
> 
> Thus clean it.
> 
> Fixes: 97ab3e8eec0c ("rust: alloc: fix dangling pointer in VecExt<T>::reserve()")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Danilo Krummrich <dakr@redhat.com>

> ---
>  rust/kernel/alloc/vec_ext.rs | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/rust/kernel/alloc/vec_ext.rs b/rust/kernel/alloc/vec_ext.rs
> index e9a81052728a..1297a4be32e8 100644
> --- a/rust/kernel/alloc/vec_ext.rs
> +++ b/rust/kernel/alloc/vec_ext.rs
> @@ -4,7 +4,6 @@
>  
>  use super::{AllocError, Flags};
>  use alloc::vec::Vec;
> -use core::ptr;
>  
>  /// Extensions to [`Vec`].
>  pub trait VecExt<T>: Sized {
> @@ -141,7 +140,11 @@ fn reserve(&mut self, additional: usize, flags: Flags) -> Result<(), AllocError>
>          // `krealloc_aligned`. A `Vec<T>`'s `ptr` value is not guaranteed to be NULL and might be
>          // dangling after being created with `Vec::new`. Instead, we can rely on `Vec<T>`'s capacity
>          // to be zero if no memory has been allocated yet.
> -        let ptr = if cap == 0 { ptr::null_mut() } else { old_ptr };
> +        let ptr = if cap == 0 {
> +            core::ptr::null_mut()
> +        } else {
> +            old_ptr
> +        };
>  
>          // SAFETY: `ptr` is valid because it's either NULL or comes from a previous call to
>          // `krealloc_aligned`. We also verified that the type is not a ZST.
> 
> base-commit: 97ab3e8eec0ce79d9e265e6c9e4c480492180409
> -- 
> 2.45.1
> 

