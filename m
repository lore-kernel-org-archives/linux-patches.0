Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0633D313E22
	for <patches@lists.linux.dev>; Mon, 10 Nov 2025 16:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762793345; cv=none; b=iDVFPa+3eJFMIvzBi+0I/nhfaGxtIe7+uZA79NoZ4f6oCDUZA+6sRHdbrN9SQJcHLk1kwgN5mcy8xOEc7j09E4A8EPhpA/09jK7lJZmBwVHKEMLi7edraKidjG4Zjg4g+ttlMz62fBKpk+AEALHT3j82KQ1l64sxmVQPkrRmtQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762793345; c=relaxed/simple;
	bh=WCn2M9Pn98zQCwXGhIe94Mp208rWyyDEa7Ij/HDRHtE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H4iGN9zjyaOwshXniDCm4B7BZTLoRCxRm/QBd/27doV6OZjsFaBgIV8bnXkKCBPcBPJmobOp8nAWidmbO0rnG2mRpIgNPeKQ+BrLLkRe1XOVsZLBpsnITtMMDpAFlCUL6fcr6ml0/ncYvYFZ0tartZb3ZNFzuQSfGzM9TZJ/cgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kZffBVVH; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kZffBVVH"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7a432101882so227111b3a.3
        for <patches@lists.linux.dev>; Mon, 10 Nov 2025 08:49:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762793343; x=1763398143; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WCn2M9Pn98zQCwXGhIe94Mp208rWyyDEa7Ij/HDRHtE=;
        b=kZffBVVHuzl1msQHl0J3RW9d92HsMJGeFIp7Afw/CEcxbMEcWOqaxZk3lWtG7F0QNy
         +yfjRSYn46nb3cBI31y8w8kF3O5AgsdO7sjlJ5IFrv39/FXSw9mHMCafpmj9RAkwsqsD
         6LN1O3XA7TA7TnV6Fj90RuwRLOmaX7DHuiDKiKF/zUH+pSbgSrIdC69CBhiM1cA+E7NB
         GWFsr7wDeKrykDSlDFX56g1LKvLIi2tXbo8xxzrpHtsTZNLUuKPvL8ojE7cySxDFC+lv
         Nh3WuD2X1NJa4l1ZADB3jmVF8sHeJmhnyRaE5bgfcBLwflv/gxaYeGhe5H03rnP9mewC
         JyYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762793343; x=1763398143;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WCn2M9Pn98zQCwXGhIe94Mp208rWyyDEa7Ij/HDRHtE=;
        b=QLlNPyRiMvvPXGPFaBoGAP4iXrRQpWLpXDWwnpg6jXD58v8qYFjhV6bGA1wZhZjNpk
         uBITa81SmFfZxwbBz7djcA+oAI6Im0aaxP/EEfU2Qz2FQKdVsz5TnH8RIxKasks0x3xE
         AYyJ9NgNzg7mNI5hpfLiztgsgekZt6pB0e3cGO0OVEk1Vl8IOBW1rX4HyHS0cu6vckDq
         t/TRj5wtH0OeTBaW/Bd9LNv9iAB6RVhfCgp138Kwvc7dPX7/ARaNUohqaOhiMCZCPq8k
         Sa0kDacR/w/OBFQ2vA2EVYh0PLO2oZ/YBIrJl+qKfsX/n0wO2s9Mc9zaOe6+J5BgrWMd
         ITQA==
X-Forwarded-Encrypted: i=1; AJvYcCX6mCAD7hIwt1gJtql9I9hMNRkeP+SBMC48uVFWVX9EA6LD2fQR5uvhXyss4e4o0q+ZJI2vAi5b@lists.linux.dev
X-Gm-Message-State: AOJu0Yxnwg+u8lWM3nw3ZQkC3o4MicZB0Azm6tBryddAoI8kZZLMbQCa
	oaGfZgplM0rs/AaYISe53qod6WEaZDN2tKIQmEYSrJRTxZD69+JCrb1GMEIrN2XaAnl7LLd8mbn
	b7W1Kutaaec375teMlGIH3U0gB1n/PaA=
X-Gm-Gg: ASbGncvkxh+ZpCA4//cgZJny2uvr/hgyLylurZsTNvAjCJRMzng+ciERG7Uv+dUWTVA
	2uTS+s1hzeOMfvzWim6SrWCyZsqnP1b9ksfOEZzcBxDGzuin6G9bViEODdjqXXF/elTbhAASG16
	owb5Erf8dZn572la1ouTVJjqREek7OZ6Wr9BnllaJZP6SQeGtcf++WLeB/QuzO6rwWG9y+0hZrt
	fRf8CH0TeTeEr0C0h0x0VnRxwLbQY5yieFRpyN0yw6GY49djn0qExqyg8VGaR4NM4DPNp+slnE2
	P43vnbb+Cybhf7O+dT9oM96+n7uudlj9Omc1AYJ3+OI3jyiwlQbKWdaQiCCWL/viR5IfJ5tBuWA
	ALL+2xrj4yP2o+w==
X-Google-Smtp-Source: AGHT+IH5I1+eyd6kWRNYzgBd7iVcE03A1u5jBf0zW8VtsXhcRPQLzp8sRacyFb9Hd3dmI6N+ld/TjvRphEHH4nekiBM=
X-Received: by 2002:a17:902:d506:b0:290:ad79:c617 with SMTP id
 d9443c01a7336-297e5611fd3mr70148695ad.1.1762793343249; Mon, 10 Nov 2025
 08:49:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251110131913.1789896-1-ojeda@kernel.org> <aRH9Tjf0tszyQhKX@google.com>
In-Reply-To: <aRH9Tjf0tszyQhKX@google.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 10 Nov 2025 17:48:51 +0100
X-Gm-Features: AWmQ_bnW52r8h-0gmyLN7ivgaSD0gXN5MS8PTRXx5xySmJt3bBV43-xYwc4HHKc
Message-ID: <CANiq72m4K+UZxodnKqdx3cowbYB+Mj_Z0gB63j=3jE+E-x+3UA@mail.gmail.com>
Subject: Re: [PATCH v2] gendwarfksyms: Skip files with no exports
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, linux-modules@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org, 
	Haiyue Wang <haiyuewa@163.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 10, 2025 at 3:57=E2=80=AFPM Alice Ryhl <aliceryhl@google.com> w=
rote:
>
> Is gendwarfksyms actually present in 6.12 upstream? I know we have it in
> Android's 6.12 branch, but I thought we backported for Android only.

No, you are right, this is just me being overeager. It should be:

Cc: stable@vger.kernel.org # Needed in 6.17.y.

It would only be needed in 6.12.y if someone actually backports the
feature (which does rarely happen, so I guess someone could have found
it useful since there is no Fixes tag, but hopefully people would grep
the log in that case...).

Thanks!

Cheers,
Miguel
