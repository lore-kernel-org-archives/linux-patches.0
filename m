Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1781F3D2C
	for <patches@lists.linux.dev>; Mon,  5 May 2025 09:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746436989; cv=none; b=FotUvK3HIVMIIDs+LZcr/Ni2bM7BDQzaBDBQbXayo+FQ0cDnHWrUnZ68OV0BitmZQjngAv1KEKn42TOcgtd4q+A0cRR6vs+tSDpi004KPCCvUEUSoahzIaS4T8YlFSNbMTYpr8QCKRBIlqwksrrZoIUx+d29i1d3hLLh6nFyN/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746436989; c=relaxed/simple;
	bh=VOdVgXxRjUc9ZrK+YEPI5gJ5KQN0O3vZhuF2gL43jZY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VsgYjPh6z8UsA+Vk0rnKBxdehgayibdX/+sq1e8813oKzJEZhxFi8WHVoak2l4thS45+I6td14L8ddKAx+TfIePA2cUIJVOJqwPSG+WF/LfmpnBNVAxLP85SJjCEhIzsYi87Dgv0bRI44Zj7+ZaBzjJG5FTRqkI4yJ6iOhR87yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0nZKesee; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0nZKesee"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43eea5a5d80so22128645e9.1
        for <patches@lists.linux.dev>; Mon, 05 May 2025 02:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746436985; x=1747041785; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vYhLhqsz0QgAIGtWeBREADtT5U6NplMqh1ZF+EYzXS8=;
        b=0nZKeseeimO+FRXkX5nAGOFkfMpllTXcpV+p5z6Ndh8tqZxeC6qz1wTg6zO4li5OIp
         0fR6BxC9GQS6cD60Ni+8NkTTXnuUd8dfmDHBiRvVekOhQ1XoAoG6/gnUQrnGvV+woeuc
         ESgxIJVd5JQg3Bk4HWNw0dS++oz5D3Gp6RdbDYfk9Ba6nTvevGqtQnUWC7q4xmDH74Bc
         sU9qG3MMGMqy1XqJxUAlHl41p3YYSC7sASto05WUFxZKpBT1g4eCuEaok8lUnule1cma
         s4sDEEPSO8MFI1q2oR1tkplQvATR2dNvYOe9pd/4zJI1PYA9b0uK5VmofCKtWBFNqMiK
         m40g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746436985; x=1747041785;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vYhLhqsz0QgAIGtWeBREADtT5U6NplMqh1ZF+EYzXS8=;
        b=d+zOeuYJAyU4fFmJjaZqG+Ui1ucJ1N4ij6ZytwrofRW2im83w5aXTjxMYQefECleQD
         P6CumBZOxyXioxe9CIowPC/vV9ToT4xDmK74KLGpiyHmzODP4QsiIpD5pvwCegDCUylq
         yYP2xFEtLGUUwktFWahP9d4xF2IdPjQrOjClzG98EcmqWLIxbEr67zbGzgQMrcT+OFMV
         hZdUrhERiXA1/IYpG00qcD4YaAubyk1AnHZ9nFYdpBam0Yq1NF+Jms4TJ7x2Sys1+yat
         VOf7tJHjpjOFA8uCT8iHNx9RuA0QlJD/TXruDjTCkZKjVt3CdOwfyLNNXfU2baV4BEVM
         rQ6w==
X-Forwarded-Encrypted: i=1; AJvYcCUlPf3r//L1nJEI8rYmJzjaXxYf7ZY8KBzwDBN9Th+dItLX/3PWGtjcJ3Nifu7HSTdEN5IxdLAo@lists.linux.dev
X-Gm-Message-State: AOJu0YyUbzHORyeGKLEjsi7r4fyONjQU167a4aYcXKr2r5uLGBB50KxM
	b2vXjeeRaaTqmsj5eOIs33zcSdm5zdEIOkyHSXMSrzMw558yNypOZjq3sB+q6o0znaz38BhmbLM
	9+APl2moqT9WXLA==
X-Google-Smtp-Source: AGHT+IGKmUkyRXUGCux/8W5tzNoSQGrev54dx73LRy4mpzycYZ3R0Lrs7YdSqxCw934omv5QZx/C9TtcgUJDmVo=
X-Received: from wmbbi5.prod.google.com ([2002:a05:600c:3d85:b0:440:5e10:a5a6])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a41:b0:43d:94:cfe6 with SMTP id 5b1f17b1804b1-441c48dbdaemr51294055e9.16.1746436985561;
 Mon, 05 May 2025 02:23:05 -0700 (PDT)
Date: Mon, 5 May 2025 09:23:03 +0000
In-Reply-To: <20250502140237.1659624-3-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250502140237.1659624-1-ojeda@kernel.org> <20250502140237.1659624-3-ojeda@kernel.org>
Message-ID: <aBiDd43KSHJJqpge@google.com>
Subject: Re: [PATCH 2/5] rust: clean Rust 1.87.0's `clippy::ptr_eq` lints
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Fri, May 02, 2025 at 04:02:34PM +0200, Miguel Ojeda wrote:
> Starting with Rust 1.87.0 (expected 2025-05-15) [1], Clippy may expand
> the `ptr_eq` lint, e.g.:
> 
>     error: use `core::ptr::eq` when comparing raw pointers
>        --> rust/kernel/list.rs:438:12
>         |
>     438 |         if self.first == item {
>         |            ^^^^^^^^^^^^^^^^^^ help: try: `core::ptr::eq(self.first, item)`
>         |
>         = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#ptr_eq
>         = note: `-D clippy::ptr-eq` implied by `-D warnings`
>         = help: to override `-D warnings` add `#[allow(clippy::ptr_eq)]`
> 
> Thus clean the few cases we have.
> 
> This patch may not be actually needed by the time Rust 1.87.0 releases
> since a PR to relax the lint has been beta nominated [2] due to reports
> of being too eager (at least by default) [3].
> 
> Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned in older LTSs).
> Link: https://github.com/rust-lang/rust-clippy/pull/14339 [1]
> Link: https://github.com/rust-lang/rust-clippy/pull/14526 [2]
> Link: https://github.com/rust-lang/rust-clippy/issues/14525 [3]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

For the list file, it might be nice to import core::ptr instead of using
the full path each time. Or maybe just disable this lint.

Alice
