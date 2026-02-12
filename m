Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BAD7344D94
	for <patches@lists.linux.dev>; Thu, 12 Feb 2026 12:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770898325; cv=pass; b=pPuOzERDwfyM/w1ZrjCx/epk8WKX5m2XB5cHKgFP5z6GLw7Lp/AL53joB1dOAhyHly225NY+c1qvKzcYkRdDOdL+0uQHHog6his28mSynq51Ty1ZsTJyag+ae/xNwpiLpVDda1lrZ6wM7eG/06cnn1ZAqh1baOwIqDUxvRLN/Js=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770898325; c=relaxed/simple;
	bh=hdNJuliFV+u1aeBSpWRoouGk7YA8j6s817VbVZUsNhU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j6wC17P+Tqm/K20nfDxzuYOr+5CHk7jnbB6t54Pa2+W4VtQ9tqDlzrYIPu49WlHMFJSIbArRHjvNUShB1YNlmpJ+RYmkjxkPcgKCtiCE5fbtYSrt8i5Q8EBO7nsE1l8ooVLWHYd9aZpY64y1J+TZDe5d3goi7u+LSbEbJfDovH0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GMH2FDsU; arc=pass smtp.client-ip=74.125.82.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GMH2FDsU"
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-2ba76e80509so318330eec.1
        for <patches@lists.linux.dev>; Thu, 12 Feb 2026 04:12:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770898323; cv=none;
        d=google.com; s=arc-20240605;
        b=NchB75GqxAodbR2HIjiDABfKWS2htqVn0LF7H/YgOddSqtn/uUlclkY14WiU0yV33L
         p+k3xIcCmBMBzKOoWYxzJrqXRVDnxepd16h0EpAepTLchuRvsoBgP+4UozamiMKrhJ4S
         ToyM9RHP3pooHg6+t4cV2Wl/L7qE7bSESq9l2PihiHsqxum0Ks9iTOVdeteogGz9x4Jc
         9yvnN553m+c6ZIA6RusQ7gJXHC9rbry3/e+aw2yoWiDOoAQa9QNwxSNvdwjT4ZRiwWX0
         H017fImL4spK9fX7mmhxPVw73fiz93Dx3btoAI7zjM44yGrqTUBxjMwuiemhOPmuG5a3
         oC+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hdNJuliFV+u1aeBSpWRoouGk7YA8j6s817VbVZUsNhU=;
        fh=bOQFa6qpYz/tiwnhji2/fUVhq12LSYN+qn/llN7yKzY=;
        b=Yo9jBmAO6tKqNEEs2V65oMCmS4NmMrM423c78Q77pCYIcJ28AZHRAt1HbpGu7a4v4A
         BuklSELdW0A9Nxo8mx7/o/LCP8RRwAHBFN+iszmT/vGvVFngcjMs+91VLqt6Q2lbpqab
         E42VgL0C/Eh9YyJA06m7lTPAwtSLYURvHmIcCgaebJXrqLOvxIWfUo7uMrlXpP7SqQ5m
         ImWyAthf96bZV3JQiR8U7C10DvYv66ydNL6bBUitlGJQmXdxdTAAyrAAJyRzXUla4WJM
         Ln9G2Z+K2E7DnsY+AriP5Yd5kaREZ60YhB7E5WQkRghiPmVi4TE/lhPOcrrGLfT0FiWP
         bBLw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770898323; x=1771503123; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hdNJuliFV+u1aeBSpWRoouGk7YA8j6s817VbVZUsNhU=;
        b=GMH2FDsUV26xuEX2x2uAQQF85Qv6IPQTmEw+e3ieHcj4txVcncwsqJwKAvdd5KZdpb
         49Ccsba5o7cGLx6FqjE54rXE9sRX2MtVlMt4XV4TrgTuwVUxIG6krlMcmJOebn+No9n5
         aZuNfuqfpyW35CPD16EYhJYjWWx1Dftt0ja+/yW6m0eHa2MP1jD8bHB1okquCs/Iotwi
         iUTUbX69boPvMjU1FVJD3AZYMhQYNhGegI3Gr5B95SeC50lT4TCU07twmFpwVcG22uvr
         PEaoAaq/9Y6YXH0i5Wq3KX3xLP7C3ukMH5PQ3qxoDvHl0JkzDqzLaqCG6dVHB9NVJJMW
         wIWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770898323; x=1771503123;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hdNJuliFV+u1aeBSpWRoouGk7YA8j6s817VbVZUsNhU=;
        b=pDBx1OZqRpdwyruDzxPFweVlssJKbLWhU+CSwJGm1b7gEXuQhe1m/ewC+dfgkhFB9z
         yH2bZnHK9lOFl8beABH6pKQPwuiISZuIX3aJ7GUFL3BJsX9hA27JmjAfhFvR0ksdJRSo
         b2EycRYDNIeqhAX55d6rGxgSSwc8vFOI+BESn2FDaFTwtCHNSfmnlLAb56YklL8b4WKS
         yHjMrsjMXaRz3F4d2Jv38QGGbzhJ0KQvXFl41LVKMmy1ACQS6jl7m0VtNx7aVlOSpk8I
         sDgRCe7E184w9xCPv8slmsFGvCnO6XFsm6T/1krsNM70RD8f4Hlbe8bo0dYyTobT8E6N
         3/Nw==
X-Gm-Message-State: AOJu0YyBFzRbaddRRh5nx4FRqVAP3Jjq6S+8Thq4loYAfkTYbSeWztIA
	4wz0XqMOUjGqmCZ1cyD3hNfsavxTvxx+fGvomkJRXy46vj0jyFbVqunyxM0Bd9691pN/Vniqqeb
	Ffqwf17njJgq2TMWQEuhUcBOWF5CMad0=
X-Gm-Gg: AZuq6aKFOhdr5GA95f56dcj5CpwAuZKVqr2ptHdcPEOA8ExsJo6YwE/fA2RFKmub5p4
	oRRzOXj3GUsyFWepgl2VuR68Z8RbsElIceEMdeS3yRHqBhVUiR4jfsnPFV0+2JgGCH6Ef/xyQG4
	T75E25LgrzljtX7OiiiOdVauEws9Are/I1lOk/UVoWr2jAKHpNQT/WBSHg7NyD7COwA2te/u24M
	VW2mOVi21EOOB1J6+WZCLwUmGzGrT3Ohf2fCDklqDU4Uu+hT53QQpTCU/9AcTLm8uOgFtWTGlu9
	jokR8Sx+hqe7i5Irzm9k7UWnEQNrhAdQnqZQc4a2H9Mb/OCmqQnl9lk8+VupCP/HHYsilgCzdJn
	8Nz6NtX+AVXl5HVNc4KkkaUnj
X-Received: by 2002:a05:7300:cb0f:b0:2ba:6f02:2939 with SMTP id
 5a478bee46e88-2baa7f6a42bmr632842eec.1.1770898323327; Thu, 12 Feb 2026
 04:12:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260212010955.3480391-1-sashal@kernel.org> <20260212010955.3480391-23-sashal@kernel.org>
In-Reply-To: <20260212010955.3480391-23-sashal@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 12 Feb 2026 13:11:50 +0100
X-Gm-Features: AZwV_Qjq6JjCaY13QKYBUvVQv4H6RyUaa8vYnCFiiN4Ovi19FySxcmcySYnCq5A
Message-ID: <CANiq72mi6_UrGoFs2=ch6AyKP0hhCon3epSkXCzwiGUGmfswOQ@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 6.19-6.18] rust: sync: Implement Unpin for ARef
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org, 
	Alice Ryhl <aliceryhl@google.com>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Alexandre Courbot <acourbot@nvidia.com>, Benno Lossin <lossin@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, ojeda@kernel.org, shankari.ak0208@gmail.com, 
	rust-for-linux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 12, 2026 at 2:10=E2=80=AFAM Sasha Levin <sashal@kernel.org> wro=
te:
>
> This is a **build fix / type system correctness fix**. While no in-tree
> code currently triggers the build failure in 6.19.y,

Hmm... If nothing is failing to build in a tree, then I don't think it
is supposed to be considered a "build fix". It may be still good to
have, e.g. for other backports and for downstream developers/vendors,
but it sounds more critical than it really is when worded like that
(same for "type system correctness fix" -- one could think it may be
referring to unsoundness).

> - The commit is still in linux-next, pending mainline merge

Wait, shouldn't all stable commits land in mainline first? (modulo exceptio=
ns)

...ah, it is actually in mainline, but the AI checked linux-next only
I guess (?).

Would it help to hint at it in the AI review instructions? Or, if you
already only ever make it review things that are picked from mainline
anyway, then telling the AI to avoid checking that?

Thanks!

Cheers,
Miguel
