Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D71306B20
	for <patches@lists.linux.dev>; Mon, 10 Nov 2025 10:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762770268; cv=none; b=jvAjbqsnciMOwezYSH77Opam9Xoh7/+PNvZMGlwIlyqKhEk5MpxIAzWn+55vt/zA//i9UgE4eMRSjYaB+41eG153+O6YeLAMEekVlrfLPXWrLruxiY1f5vqgiGjghscSWj6FvBOLv7agAxiBryACQBFuCulcmjaPZG2aguKrok0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762770268; c=relaxed/simple;
	bh=aE0cpumrRJ1UXIBWA3mSkc4AapKLk4WpELDVIiqYqrI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=U79iIPjqivrEVSjDujQGUwM7JMNvruk/zu18acAfhA7Cmpr7lQc5i5Nh+y1YuuLM1LYgFFFOnQAvM3GJabDHpsg6H1FyBkoUKXoTsMoG57N0Y3PhM0ON5cYtKkrGIm6tRqfmyU5jTaJmn7yHBppo80J32fxmne08ffQpECfWoiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3zY/Z3WD; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3zY/Z3WD"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b72aa7eb745so236992566b.0
        for <patches@lists.linux.dev>; Mon, 10 Nov 2025 02:24:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762770263; x=1763375063; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nNv22iO458s//Cdaagcdl8KtQQ9ntxwjUMQVBshAGaQ=;
        b=3zY/Z3WDpETvUDkP0XMAa53gnafNG3i//q8yGwuBXhr3RgoYRkTm5k8zmCiBtXLVKY
         MQngMeVnn8u+W9QUlDBamyqYbXcSwx6PxVH5ydMYyt7HRm+ijN6bKPZB/lcEr5ViKoxy
         FmgjpSvQGbNWJUY6KP03XDeCqwY+F7dkQQl0ocDLI5xgdX4H6DMLkwepisBVNtZC34SW
         kqJxD5RTWDj1azrjhp/VOWFmPSV9nHl+mmo2bmZmu31lxJwuYKTxBeMWaJa1w9Yq15HV
         Df0CB0ssgPLy5d35cRhKNsgx8wKNKJh5gyb1YJxyVkLoxUJO4/bwvyhYNkg3SKlJaQGm
         SLkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762770263; x=1763375063;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nNv22iO458s//Cdaagcdl8KtQQ9ntxwjUMQVBshAGaQ=;
        b=wP3f/jFntpCTP8RHeN/hMsi7LnLEgQKmOzw0esB1IFlwLjxBuTYlMSE1u+lBGXJdSF
         GUyvAK6udtEqc36zQyDes+kvyWzSiLiTBU8ducWG871tO78GFVsUFRLsJChA2IEJ3xun
         Cql9LE5AeDQ8XTqncDUQEXgM33BLx4s+caxndUMgT2s0kqYIiCBl1FUHw+ETjE4GWw5g
         9ivB07+zXuXa75dmGteWf1W4LFLWvGMrlsiSbKX8hCnd033rV0DksrRAWOfb41tk3eNM
         tTJVJJOhGQjcpbI2Oc/KB+klqOxrW4B/FxsukykQuw5ZcaByEJozU0zkHRQOMIaXyQSl
         KOLQ==
X-Forwarded-Encrypted: i=1; AJvYcCXUe98JBzI/8HXexD29nVeu3JiCSLnZZ4xCMZcG+b/SkbNtk2Lhs0mA2yiXX9yri8ySoEmJO77v@lists.linux.dev
X-Gm-Message-State: AOJu0YyWh177SQ4bIUwTD8NyPaAtbZzQEmid5OTDf6g4qaTuuK6NyPO0
	uL/u5N8s6RGvkkQKev698bZRVz4HjIW5EX7G6L6EkHOHe/5AGbBrMbkq7uf3U2Df5+tRvSnUemV
	i76bCuOv7H5gjtASPAQ==
X-Google-Smtp-Source: AGHT+IHF1mfHQnJtzIm6KGV9avfylPLNTU2wZn2/rVrhlMwC4+Dos2C8BVWng0M+4Mg0oVxmMCdjIYjJS7RxIbY=
X-Received: from ejcvi8.prod.google.com ([2002:a17:907:d408:b0:b72:41e4:754b])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:7f26:b0:b40:da21:bf38 with SMTP id a640c23a62f3a-b72e041276dmr757987266b.36.1762770262892;
 Mon, 10 Nov 2025 02:24:22 -0800 (PST)
Date: Mon, 10 Nov 2025 10:24:22 +0000
In-Reply-To: <20251110095025.1475896-2-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251110095025.1475896-1-ojeda@kernel.org> <20251110095025.1475896-2-ojeda@kernel.org>
Message-ID: <aRG9VjsaCjsvAwUn@google.com>
Subject: Re: [PATCH 01/18] rust: condvar: avoid `pub` in example
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="utf-8"

On Mon, Nov 10, 2025 at 10:50:06AM +0100, Miguel Ojeda wrote:
> The future move of pin-init to `syn` uncovers the following unreachable
> public item in an example:
> 
>     error: unreachable `pub` item
>          --> rust/doctests_kernel_generated.rs:14683:1
>           |
>     14683 | pub struct Example {
>           | ---^^^^^^^^^^^^^^^
>           | |
>           | help: consider restricting its visibility: `pub(crate)`
>           |
>           = help: or consider exporting it for use by other crates
>           = note: `-D unreachable-pub` implied by `-D warnings`
>           = help: to override `-D warnings` add `#[allow(unreachable_pub)]`
> 
> There is no real downside of keeping the example as-is until the
> `syn`-based pin-init is introduced, so there is no need to treat it as
> a fix nor to backport it. However, we still need to change it before
> introducing the new pin-init.
> 
> Thus do so.
> 
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

The unreachable_pub warning normally does not trigger for documentation
tests since using `pub` in documentation tests is not wrong. So this
sounds like a bug in our doc-test setup.

Regardless, I don't mind changing it here for now.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
