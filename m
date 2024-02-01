Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A6B84FD0
	for <patches@lists.linux.dev>; Thu,  1 Feb 2024 19:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706815638; cv=none; b=bNo1tcdbwVTRZv2g+ZMZ/ls6hOZtQj87kXQA8Z3IJ4fsAbs5CKxDhtKUyW7tD6jRUHvNjnxnGzicFrn4kmOLk+tVZERQyPUeJxL2lxfIQND+cSbhy9MdCcF37NDECKP44ylEo11oOxU+H2wLR2MQZTJT+3Cj9UyWa0GcarPed+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706815638; c=relaxed/simple;
	bh=6CwiqDr7FDp2bs1J3xgVDCcKosNF86VPvbUnyP6zuLg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=amxxewIxfKjhJLgDKC53z+9A0eRRO7F+lvY1OEFqD5T9kUMAOzsd7ZsGIchrht4dyAjRm9rKpB47uqKj3u7d4s1qu+crBC86Ie7xWseM8XZmSMFUpHVHvhrP6XdA/sygpMw+7kpXX/iYTKJcUPQS3t76CZ3ghQIXG/L7qHAaG/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ducCceYs; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ducCceYs"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6da9c834646so933935b3a.3
        for <patches@lists.linux.dev>; Thu, 01 Feb 2024 11:27:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706815636; x=1707420436; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oj3e2y9EpmbMl194n6alw6UOB7/daIK+PfuTYNJ05D0=;
        b=ducCceYsxyrubKSq8RjbXnMpzC+kMIHZweJVuIELiI92ZCuNWbD6prsaCSDmTILjZD
         q0WFcbg4++XVUnerHQyN76PAFiSGr33PWl8WGWrVatVEb2j/qne6wcyWnobAvXmXOSTb
         uoHh8dAgkYenQa/LA8JtYSOtlmO5rTEphSH7+Wa9HB8Yrlz98VYnaz7P6QfRxrSlwk6c
         pv4bi5cqeh/w1wiZ3s/2aQlHCHhdNC+OxftjPuUoGOo4ns9gidqtQuTbUN7fvzT1Z3RP
         U5JcQVA3bwUj9urcPtnFaL5H15Fm0vGLbzq3SeKMjtj9Jm8O5FcZ7Ms5lQXNFwj2RCHs
         FjOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706815636; x=1707420436;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oj3e2y9EpmbMl194n6alw6UOB7/daIK+PfuTYNJ05D0=;
        b=erI1OlUuEOWcz7F+Odv2kC55qxoihJDX8Q4xYEojl9t5QuZhTMLG6FHFsUFOWM/fAI
         tjF5fZzoLD36//og1VRze3CGmXaRPb0c5oYS/w1EuwmXabvgnaYEmojYTkPSD1u5lMZ9
         bzYmk7oU5eG/jUplxw/4k0AI+RBT+1kvqyC2sg3DhgLKZOFc9VH30rqunbHUTACnDipK
         A4LGiIgECL0vh1Uca3ulZySOG5Aer4/lqbC2wWqHG3RdQRW4mQhWKAqX2SaDYErwXMbs
         lgGRl5PngZzT34xw7cmTyvN+AZoQy4KOmwUXwYlEADVjuUuDtwYIEjJR/sX3SNORUtxJ
         5wmA==
X-Gm-Message-State: AOJu0YwdVR5t6t5w4rWNkH+4oC3OjsUG+LYvPAhxioYtwh6Vecc2IqRD
	eRyqnh77ylY3RlsvXVXk3dyhFnskM1s1//3QNQ5P0D8JKboUZ06O
X-Google-Smtp-Source: AGHT+IGadKuNyR9mfVb/6i7kkvOa9s7W0wyqI/AZWjNOXwkr4c/OC6MUS7Oq82TQwF8vs3X27a+gFw==
X-Received: by 2002:aa7:8d4b:0:b0:6de:3833:425a with SMTP id s11-20020aa78d4b000000b006de3833425amr150947pfe.5.1706815636342;
        Thu, 01 Feb 2024 11:27:16 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCU+RFWTDRMpESHATIM9+GebvVOYsYlINEeehtreTsfBsKgv2fzlThEityuR8FWsuCj6KWlJnb0OEOJzmQVsHmQTbMW0QZtkQzGRsdFnCSg50vr8fhumXNptlRpgWNWuClsD+5Lmf7dvnjRXMMmiIIczYCqnUApYvh5NMl4eAdR7aEvacn/mslYM0nluHKyE4C27b8gyPtsBC+iwqukWtMyatSfb1pg5afcTKXQnGJvWF+eYMpc+LHEZlqG3fNozxmrTOOZpNHQNRug3Ba+igXVtuiZs+ZTLYV+HTNisBEUbqJivqzp42KhLiEmDIuFMpHfNleVNegXBMyyhEy7yK9DX5UZgYh5+XEhYQI4ZumfXIC97E/c8CRBcYF3GDgcMNVdmTo+weqaXQDKpxW/DjJjYE0R1wDNk
Received: from localhost (dhcp-141-239-144-21.hawaiiantel.net. [141.239.144.21])
        by smtp.gmail.com with ESMTPSA id x188-20020a6263c5000000b006dbe1d91426sm109957pfb.84.2024.02.01.11.27.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Feb 2024 11:27:15 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date: Thu, 1 Feb 2024 09:27:14 -1000
From: Tejun Heo <tj@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] workqueue: rust: sync with `WORK_CPU_UNBOUND` change
Message-ID: <Zbvwkvn1lZDCoNby@slm.duckdns.org>
References: <20240201190620.18064-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240201190620.18064-1-ojeda@kernel.org>

On Thu, Feb 01, 2024 at 08:06:20PM +0100, Miguel Ojeda wrote:
> Commit e563d0a7cdc1 ("workqueue: Break up enum definitions and give
> names to the types") gives a name to the `enum` where `WORK_CPU_UNBOUND`
> was defined, so `bindgen` changes its output from e.g.:
> 
>     pub type _bindgen_ty_10 = core::ffi::c_uint;
>     pub const WORK_CPU_UNBOUND: _bindgen_ty_10 = 64;
> 
> to e.g.:
> 
>     pub type wq_misc_consts = core::ffi::c_uint;
>     pub const wq_misc_consts_WORK_CPU_UNBOUND: wq_misc_consts = 64;
> 
> Thus update Rust's side to match the change (which requires a slight
> reformat of the code), fixing the build error.
> 
> Closes: https://lore.kernel.org/rust-for-linux/CANiq72=9PZ89bCAVX0ZV4cqrYSLoZWyn-d_K4KpBMHjwUMdC3A@mail.gmail.com/
> Fixes: e563d0a7cdc1 ("workqueue: Break up enum definitions and give names to the types")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to wq/for-6.9.

Thanks.

-- 
tejun
