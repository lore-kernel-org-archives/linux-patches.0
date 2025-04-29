Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B4D221547
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 15:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745939905; cv=none; b=IHBpszOu9uDzAzWWXZSQv5qpJFHZK2MlXHT/hhKv2MV8qxLp0Dwd0q2tsJ/rEvWinGkyxSjoGdAcNFQKRKVY5qIHbqrikN6DEhjdmA3mWp9bQ9nhN//9Gpv8DyUEgNLr3L7A+UTJFeQAbBsuYT0Upac6U5J43D5w0XcCa0tdZQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745939905; c=relaxed/simple;
	bh=/PCu2WNCG8+pXYZ1IyFXr8HBm165qrsZ3+TmCh3ue8Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Qq8HisnhVK1YlngzDaUaFmmHNZomija1rvV0B71OFxMsX44nMyWPDNEPz0v/gI0cbup3KuWynlfg/Nr61Y4jN3EJkK6+JiGYthjM6MNV1ocl8jYE/+Gc5CTY72XQvnG5G9VP9XPOV14eHwn9gkSyJjvwxENmwci4SRopYzHyS2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1oDU5BNI; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1oDU5BNI"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43941ad86d4so26980025e9.2
        for <patches@lists.linux.dev>; Tue, 29 Apr 2025 08:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745939901; x=1746544701; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JPDHd5nmuz8UCmPYQ1xuDtBVeP5aG1Pr6OYzhTl7aQs=;
        b=1oDU5BNIU0Lfd9a5eTPS8q/7uL824qLklSxJzDjjfT1kD0rh+UKGpa+EZsyYW2DfLK
         //FAfE1WCf7SrewR8WtU8HIDJWatq7xMWgztwXMK/CBBw2xKUM2u6CXgQ70Pwv72isjv
         t35u0NvdzA1DLxw1hA7Ph4OtTYPw1xWBtC8rqOTlTS1pDHVb8zNaVR76bNN02BXkr4d1
         FTS1sELXFLbOQEN/QUoqgT8JCqU+76FSMGCXZDxd+a/gN7pxK7KusBiX59hpft0MghgU
         I9/2QY5T5bYa3mCCwDdElyU88K44WD+ghjymwtJ3H2Tf6wglwYG6KVDk6i34r9FQGPBP
         aI+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745939901; x=1746544701;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JPDHd5nmuz8UCmPYQ1xuDtBVeP5aG1Pr6OYzhTl7aQs=;
        b=Jmkxf/GNBe7MfLJ6itRJygLAkEENHgvLq28TDV8VaX2WnsG5A0ix58GnsfgYILcOis
         o9Ml6Vaau8eI/vDvNWe72e1qRVZfQ7ulS+hR4xA1dFSEpBBFzX8sHQNbgFs36VyGfNNe
         ResRU/IbRJTNyOeKXpxBqn0octLjbzhdvJED8CgWQzqnNZ0mEW0B1EPPLJfxjZD9pp8Y
         RuRSortzLMKRDpNpOPl26KdeLStW7T5a3zD6h6Kxc6dAxviU9IatK/GgaIJP8WgN8rUB
         9m+8MbSGvFErNYWlaKtok3ks1cApIW2LIgbrGoRuO6sitpf/x9qRf7GyC2n8A5Q0Lhj4
         mCAg==
X-Forwarded-Encrypted: i=1; AJvYcCUJlOUFQMwm5dN2bJZtpJgMU6v8z+HUUKOEajlayctoAR1CRihhik+yfDAxHMZngGKfaooimoIb@lists.linux.dev
X-Gm-Message-State: AOJu0YxDbEPeQnyKMRupQVSYmxS1muMTWC2Rvt+2tMXfshysRW00TGXS
	y1z3evP+Rb9qIPZpT5eqdkJGhezzXb8HAiFxyXg54bEEz06jAjBSOFVPH3zCNiwKEluF2yaciTk
	qx3M7NInBH4gQKQ==
X-Google-Smtp-Source: AGHT+IH0OQ3Fn2PmiC3/SXJZlwPP2g+GPNm02BRczf+LepVg4s9KBAT779yrqPUW/iEFczZ49lueIXx+4oUVZKk=
X-Received: from wmbgw25.prod.google.com ([2002:a05:600c:8519:b0:440:59df:376a])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a016:b0:43d:42b:e186 with SMTP id 5b1f17b1804b1-441ad3b43a7mr28023995e9.8.1745939901572;
 Tue, 29 Apr 2025 08:18:21 -0700 (PDT)
Date: Tue, 29 Apr 2025 15:18:19 +0000
In-Reply-To: <20250429151445.438977-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250429151445.438977-1-ojeda@kernel.org>
Message-ID: <aBDtu0oAlRYNa5l3@google.com>
Subject: Re: [PATCH] rust: uaccess: take advantage of the prelude and
 `Result`'s defaults
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="utf-8"

On Tue, Apr 29, 2025 at 05:14:45PM +0200, Miguel Ojeda wrote:
> The `kernel` prelude brings `Result` and the error codes; and the prelude
> itself is already available in the examples automatically.
> 
> In addition, `Result` already defaults to `T = ()`.
> 
> Thus simplify.
> 
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
