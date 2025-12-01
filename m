Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265F8301498
	for <patches@lists.linux.dev>; Mon,  1 Dec 2025 10:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764583677; cv=none; b=H6R+22RtJxlHZhUDEvMrgCUpIOLw/7yl4gyJKYr5iAGiICd01XGtRgr+OtTUa04NM7MMS8bQICiJ87dSk1DnvDNIF/Ai4/EfR0TNsfiobFtyga8+UdFz72fBu2QhzFQjvjz9IHhbA0flsnlOTybQTZciZhBzQwwBOJLknmDAFh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764583677; c=relaxed/simple;
	bh=/tOIwCXkCHpEc853DZjChDkaxfhNn+7tc33Ws0sdTrM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FkGzodJh+8nVdHIO9BBMShxQPVAs+HQGz24LMtaTzBWM57FJTeaIoQuZ8tL5+OkCHbKk8AXXEp9VMKHkBJNeNUkoi7Dz7Z/aSzrCU4mb+PZBcxP9fGln+mQaISIAmW8jrInY4f9Be4R/o65Jnw16U7cXAQcW2mjqZEpBtEFccC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tj4JxL/m; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tj4JxL/m"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4775d110fabso31649135e9.1
        for <patches@lists.linux.dev>; Mon, 01 Dec 2025 02:07:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764583674; x=1765188474; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=guaiVnq5wSGt0j6wYWbgKuppdOTiHe+D0rabrZE79JU=;
        b=tj4JxL/mdHlXLr2QnjuEzQnZHqijIzYEDvXTF4iKmFb8p9FMuqsIYR6ymq+833q4+k
         SwSaWXyYUzSRmvgSakDJ7dsKTJ1086aHzNOG9g2VjV8/rE1ZMY3pXj4UZu09WF4sKCKJ
         e3cz746HrhlmW3kPWOUhetRb4AX7UYsbAUxI9kQJeZqQteInECZuz8LvPkVG9fcXp39q
         sOJJJR0D+n00NNqpoVGGTKyL8idu13PIaDwb2uq5X0v39dhRh+n7Dqe9osaQ6z6TVNJi
         lP2GkfDcWcP5t/u/APbUlZl1y5Q/Hl3gMvMkDAv2gOGMsVOEcwBdPlJvS7sSuGik5dy7
         +gwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764583674; x=1765188474;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=guaiVnq5wSGt0j6wYWbgKuppdOTiHe+D0rabrZE79JU=;
        b=S4E6SEVT10aQa870zVvhsErnOOXyDEWz+xO5zlxpZh9UqCY4XA/oFl8AU2lLLsLl8j
         BRgcwQahgmC5hKwTRxFa1tFjVpdr0rSyc6rYZmtfljFz/qp/I5CFBPHTUb7+GfTMbtDK
         lX8wIvt0bOIG/6OPtScTun4YKtNtwreYMVwOua9pOFhxWivO66pKAK2s9zT8eBMpv0lZ
         jHVHFHhHG0y5SOj3NXHoirgdpxRfPQ5xctXRPtBEx0JY6q2m3eEh7qzhueeEHx3XNSHh
         HEu9IBBIbYhzxULMTUTKvBwG3V/vPS/2joruVyEuGK3zJ4OgLIyoDsdWbBt8reIXRilT
         NqNg==
X-Forwarded-Encrypted: i=1; AJvYcCUSwWiCdOFVadNtMRbmhqMGApD30AnuXBX8xvCbAvZJIk2Fx2l2GquluFPT7+bjYhkI3+aPRdP7@lists.linux.dev
X-Gm-Message-State: AOJu0Yy3o8Ax/QugwuEBfp2nbxLy4pwEOXTNSBtMaQnRoGqmgMHlWHEO
	puQeEhetb91PmgUFg7Dlowc4mrmKqqP43Fs1NI4tuNZKS5WcUe2gCRUyd6/jd3Y3SQiZQxvUR5Z
	ySNgbfrGd3A4uc/MYHg==
X-Google-Smtp-Source: AGHT+IF+F04jPnA8raxrrj0to7TSZ7tXuzclteHchQpMYkH1WruuUrR180MkD+2drBszGe2sUCH4YjcIrlB2WME=
X-Received: from wmlm9.prod.google.com ([2002:a7b:ca49:0:b0:477:9e14:84dc])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c8c:b0:471:1435:b0ea with SMTP id 5b1f17b1804b1-47904b242eemr260534545e9.24.1764583674469;
 Mon, 01 Dec 2025 02:07:54 -0800 (PST)
Date: Mon, 1 Dec 2025 10:07:53 +0000
In-Reply-To: <20251201000949.1626363-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251201000949.1626363-1-ojeda@kernel.org>
Message-ID: <aS1o-f-_2s1QI9ja@google.com>
Subject: Re: [PATCH] rust: id_pool: fix example
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Burak Emir <bqe@google.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Yury Norov <yury.norov@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="utf-8"

On Mon, Dec 01, 2025 at 01:09:49AM +0100, Miguel Ojeda wrote:
> When building with KUnit doctests enabled, `rustc` reports:
> 
>     error[E0599]: no method named `acquire_next_id` found for struct `IdPool` in the current scope
>         --> rust/doctests_kernel_generated.rs:6722:24
>          |
>     6722 |     assert_eq!(i, pool.acquire_next_id(i).ok_or(ENOSPC)?);
>          |                        ^^^^^^^^^^^^^^^ method not found in `IdPool`
> 
> Thus fix it.
> 
> Fixes: a5726454470c ("rust: id_pool: do not immediately acquire new ids")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
