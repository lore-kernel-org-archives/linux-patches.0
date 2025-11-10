Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A613301010
	for <patches@lists.linux.dev>; Mon, 10 Nov 2025 10:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762770462; cv=none; b=uCs7PdxGBAn5S/uxvgKX+w7NA4an55eOmq5L3/2/pyIY3RURENHdAeLpJWmSxPR+sltmogUHB/natEUX4twTxDYlTaHvc46fyzpuP5qSXcg160gLcHnF11/xGF/xQkWZD/dx6nBRDsp2yqa17LGSCS+6mXSwSJ8FRFALyLntHdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762770462; c=relaxed/simple;
	bh=qOc2Yc90dsMYkDqxDQPjAtDHWYmR39nkh+FTIYhuNTo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F2PSSw1PQfUFe7wyx8axT1OHo9YDk8+m2+6ZROs4rb3vDyNfEG3+05L/AGJdc2LSQ3aJqvH6PvXQE1DFMtG7tZ+Sh7SvrsqUwFXheUYjPdDH37xTzgwEgp7k2eYDz9hg/9uRHGlNh03BcurVrS7ydFZZtNM8RfIMddrxF3gGpow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vL+0tgd/; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vL+0tgd/"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-64097bef0e2so4062098a12.3
        for <patches@lists.linux.dev>; Mon, 10 Nov 2025 02:27:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762770458; x=1763375258; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Egm6bH8haTO66pWlj9ItuOdMEFY5snjzdOZKIxF5pdA=;
        b=vL+0tgd/AFJcGzJZDmsCHz8wKSk/HXopevvKgjCaqzsFG8CXOH163/qvrh8BYxvVKG
         8ri3NiVkNCkkVTjtgFG73x8N1oXtekUoTEsEgN0UVtVUScCBXzHIJNaubgJSmcNokjyd
         0adKLjank1ZQIsao4wvi2dVQkPyxJHayIouxtTYEEXX0rAsJO/GRomrRwcV5An1xkXWC
         2l0ZOSkHdx7hnVuzlvdkk48+siQXYQcOX2ifFwSnyGI1eICGYbSIEE+DYBbtsKVPkEyE
         Z43r2UfetKTmpQQm329YV5XYnv2KRuOBC+iZbBR3OhxqlTA0fhztw9LJDDo9mY2IHITy
         88vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762770458; x=1763375258;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Egm6bH8haTO66pWlj9ItuOdMEFY5snjzdOZKIxF5pdA=;
        b=M8dzmJnZ88t3seuJ2IXDuRBY+BAuTKEFm3QzSxr1qrcET5DiM/0yJqedgsDm8aclvB
         qXWZNlbyYI/WhXJREHjCAyRcmjEeTN2g9DNntfZmL5m/wUjfHWAYbz/x6smLXBDgE4+H
         A6crnMssrlVS+0Vh/+WmtLPC5KHP+71jY/zDUmmCuT9rj9a9pFZpQwGuKQRbU3aaI+LZ
         jQ4/Tj0wy2V8KUZStYQqxQGEkcDYDC0hvKT1isoeCHBVgqHuoLX4JLa67YKru1vxQhC6
         n/O5JNCOR1OQB5D+wb0sU1v/XBUWkJp0Z9XwTTTDMeu114IT4N2RQh5gw8HXzU+C5EpL
         26nw==
X-Forwarded-Encrypted: i=1; AJvYcCXVFCo/mRklG9aqDmqYib+Whd0yUcG1JTmnKVD8C9ASJ6Ng57Hn0+6uaOHbrCrdgOlO1bzwSLyx@lists.linux.dev
X-Gm-Message-State: AOJu0YzFSXvrvrGbylp5h0jzdEzZOjN1JJakKu+hImVhmk3v2smWaM4e
	o0n19NeT2UOS5wgWmqTWo85b4kJaCYn1jOIY+rP6tOBxAk1/Q/uocHzNFN+cKQYyU1GahThfnhr
	OC9B9pSSfByOan+/oYw==
X-Google-Smtp-Source: AGHT+IGusiuHZLT3Jzp+Pn6pR0ClVUPAC/bjvfmAH1j2yaYh3CBjTcnQebjmD6hy9yf32AJb1ySOZAn3SaTPK0g=
X-Received: from edhr13.prod.google.com ([2002:a50:8d8d:0:b0:634:4a04:b8ff])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:84f:b0:640:c95c:be17 with SMTP id 4fb4d7f45d1cf-6415e6e759emr6717600a12.16.1762770458616;
 Mon, 10 Nov 2025 02:27:38 -0800 (PST)
Date: Mon, 10 Nov 2025 10:27:37 +0000
In-Reply-To: <20251110095025.1475896-3-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251110095025.1475896-1-ojeda@kernel.org> <20251110095025.1475896-3-ojeda@kernel.org>
Message-ID: <aRG-GU_I3MjT46dQ@google.com>
Subject: Re: [PATCH 02/18] rust: kbuild: introduce `core-flags` and `core-skip_flags`
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

On Mon, Nov 10, 2025 at 10:50:07AM +0100, Miguel Ojeda wrote:
> In the next commits we are introducing `*-{cfgs,skip_flags,flags}`
> variables for other crates.
> 
> Thus do so here for `core`, which simplifies a bit the `Makefile`
> (including the next commit) and makes it more consistent.
> 
> This means we stop passing `-Wrustdoc::unescaped_backticks` to `rustc`
> and `-Wunreachable_pub` to `rustdoc`, i.e. we skip more, which is fine
> since it shouldn't have an effect.
> 
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
