Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E859305977
	for <patches@lists.linux.dev>; Mon, 10 Nov 2025 10:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762771391; cv=none; b=UuYdSw7mCDG2GzlEV49meZR3De/8aCbW/5YM8ARztHJYvVxhfFCYSDY5yOZFD0U6w2IE5Wkdlv70dA/n1apB5RDvuaPUcGICPVIC3kRiDnq97W9A6SEKDbJ+Ss/cTwDs8BePZV28nxpjgxW3IdjQSsdSdYNHHEFpeHH6jgxOxwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762771391; c=relaxed/simple;
	bh=PaK9aaWb78+gpE3XwxvDFLq4iKRgKHKKrEr/MVH+uOg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IefS0xbR0ypRpRfM1qIea7i1H1CGV1DKbfNnEPHeXVvEKfs0GLKaQG750/z/bT6fFlfjFqNG4uWTcSRoLLcvtMAam5kIcENy4M2ddNC5Zz3CzZ/ppy20QXxF/t5Df2SC2FrJPUj7nZRxnRoTEZPzgnTmlKXBP15TWMC10oeIIzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PKQiHsjg; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PKQiHsjg"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b7276057a5cso258041866b.1
        for <patches@lists.linux.dev>; Mon, 10 Nov 2025 02:43:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762771387; x=1763376187; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=v6sNizUOGkciptOGTci4SybgbOhVv6AEZQncHw0dXTs=;
        b=PKQiHsjgLGP7GRKQcuHJm4i4WdCRxvsIizCNtCP9QUwzJG53+L65yIG9dy6bDp+ggb
         Za0zzMM1WTBACR6u/JE2vpvV2d1pgluL9OpAubE2Hi/WUBttEnvxssLtxd1CrCZFzUka
         nrkfl5+MKwqXdCYMR/6loPqh7rXHSkNUzIO2jGTTIqlFi4eHPM5nVrYZhQNHrbwXD54k
         taxgumoCP1dBk+GsdKUDEqpjB5+ezBnc1k3Wz7SKpyvy/VIamYcdCXFTrxwVNMhMzWM0
         KCqtF1HNMRJre+rSnhetPLqY0n8N41yT8n3IF1qoY5s2/835lLXfancbX+eR+g3IUc5g
         BLhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762771387; x=1763376187;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v6sNizUOGkciptOGTci4SybgbOhVv6AEZQncHw0dXTs=;
        b=LgYrhptORS/2Z5tqaG/bQId4hskcHehTJzuT4DXITCGxYtdQawenKNlpyWBa/zFBZT
         BuzpK+IK6S98HKDytegFih3oGY1jtok5sJkjTaUtu1kNRjGOGXkuuZEYSlN7AAEWtnxD
         oeZaf16kDhAlKmqA82P84peppWOKF1J1MGK1SvnxNAYB9a3SQNPP0T3Mw71BlrJaUB6F
         Z/VsLtg8NZIeY3Mwigwes8munz1KXFSQ2JdNAPtPtb1673qsjKUg9KKKTrxCXR+u0eBE
         tvBjq816bvTQw4MsKE2d3M7j8FM085FUuiNmkzLW0ypGFqDKem9lbSx4sfltVQJVnBW+
         nwZQ==
X-Forwarded-Encrypted: i=1; AJvYcCVWAdYJQehTtoNwv1plP3rYig6APZ3etCi1d2XDgSOy1jktB/AWnO24el4jH7F5G+F3XxrSN+vz@lists.linux.dev
X-Gm-Message-State: AOJu0YyEuTSx+l/7unLwDNCS2WF2eJVmnLa69a6fvJP2RglrPOrzyH3e
	jl/T7pIertlPcZ+LZUR7H5/j7cLyC3qnsvCeKcWWthxcdJYh1Kti7zXR6JJf2ER+rSOJvW1hk6T
	cql/zWZuKcaxHanRYzA==
X-Google-Smtp-Source: AGHT+IFY61ejHKFEIykzrnpB2o0ZUucS0nhTdm30eA2AKho8jI6G1MrYig9/jVIr/y6CqyP5/ec46LFxxBld4FU=
X-Received: from ejctp27.prod.google.com ([2002:a17:907:c49b:b0:b72:ce97:7786])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:9812:b0:b71:34c3:d5a9 with SMTP id a640c23a62f3a-b72e03ee841mr671805366b.38.1762771387730;
 Mon, 10 Nov 2025 02:43:07 -0800 (PST)
Date: Mon, 10 Nov 2025 10:43:07 +0000
In-Reply-To: <20251110095025.1475896-5-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251110095025.1475896-1-ojeda@kernel.org> <20251110095025.1475896-5-ojeda@kernel.org>
Message-ID: <aRHBu3RoOLTrMA8n@google.com>
Subject: Re: [PATCH 04/18] rust: kbuild: add host library support
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

On Mon, Nov 10, 2025 at 10:50:09AM +0100, Miguel Ojeda wrote:
> Add the a host library rule that produces `.rlib` files to be used by the
> `macros` crate.
> 
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

We currently have two kinds of build rules:

* cmd_host-rust used for host binaries such as generate_rust_target
* cmd_rustc_procmacro used for proc macros

This is a library for the second case, not the first case, so it may
make more sense to name this rule procmacrolibrary?

Note that HOSTRUSTFLAGS is passed to only the first category, but this
naming makes it sound like it should be passed to this new build rule,
but I don't think it should be since it is not passed to proc macros.

Alice
