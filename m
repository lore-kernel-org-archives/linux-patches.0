Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10B027FB3A
	for <patches@lists.linux.dev>; Mon, 24 Nov 2025 20:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764014435; cv=none; b=HNxUwQPuWLo28QuVK49z3VW+dZgaOJD16+JMbxJTEkIrby+x/Zd0ALurvaak+AdUjSNN1vBNh8hvVDvhudcLBH3sx8kGRHQFIghOhqXni6P3596H3mog8xIeXRzJSEeD+1pQmWD2VXstxIDcMMm4ZO8eH++A9BLhUQiqBtCBmJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764014435; c=relaxed/simple;
	bh=Lqzo6KuYQIpSG74Y1hMug1+AjSFkQw8fGrQ/Uz8sHF0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MkU5hid4lmJM5CKV2IAn7zvvIAuaP2tMT0T37UvWdqHeGu0UL0fYuE9GOAnVSlpaNyfsUMiAiHwi12XyKyDAWFwj79/QckuYgP/aBHARolvFrp+SjLx4P371h9yP57XpmdB5qVo80Pw/5rXmYrfX0rt4tbKAKz6ptZW2rauZp1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hRSU3owW; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hRSU3owW"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-bda175a2013so241183a12.3
        for <patches@lists.linux.dev>; Mon, 24 Nov 2025 12:00:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764014433; x=1764619233; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lqzo6KuYQIpSG74Y1hMug1+AjSFkQw8fGrQ/Uz8sHF0=;
        b=hRSU3owWua7SyCghrUNYbNrkkxUz+lqEcGOkkkFg9nDSp5WW/Iwe6nJHsirfTdUbB/
         9sTeINLU0jr5nLVqGJJov1bxhOQ3uNd9w5kTV/Ksj6YctYrYEhAUKZxwIcCFqYf6Q6NX
         ApBqtpo8R/P5N0/ex1m9UeLZtuHFv03ccHugFZnHXrzGPCuyGr3yg0lBY8WYYj9I5WEt
         EZz6IifNb7oxBUaLmoYiIr44vVjOn4IhVZfFi7KVImjXnnupnsoAzwZhKeMsGq7BFVOq
         acLNzNi3CPmpdooni5nH35Bzh2hrcNxsd9TncbSOnqTrxrR6xRlwMilylI1jZCKQ4Gjo
         UVTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764014433; x=1764619233;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Lqzo6KuYQIpSG74Y1hMug1+AjSFkQw8fGrQ/Uz8sHF0=;
        b=iikwpBiUc9UkIeEWs/iLliaYhU2I8sx219VVm/ldMbIMH4+RV8s4gs+byMtimUQjcN
         ivRJYgD3wDCo8RNv2fBIlH0nXAirOxcIn1/+khnX2aT57tKCxOGawjFzGr3PWt/gCCOw
         B1f9R9hsI9A4bsseTBC+DvkW8OIk11/HstNVxVfcl5ZM+EI109nwjRxd/hMHt3Vbb0oF
         B7wp1J7hxO5pQcOomE7Zbf1JGW+i4QF9tjTPeyRlHCE09z8zJdJhG6hx8+lLsbbz+fX8
         OpE3pbao0sxr+w75efwJCboydeuQl7RequJ/eUdTUE6G9Tkvwbz/PJjdMBKQ2DAKDxjo
         4ZtQ==
X-Forwarded-Encrypted: i=1; AJvYcCXAzUsAhmaJLGyNBkLIKRL17cWoPEsHGUKtVCM3VlW1yeL0j+IF2nIjoR1F5uRQKu/D3W8tNM4e@lists.linux.dev
X-Gm-Message-State: AOJu0YwqJzF+IQNOnDOHeTcxhK053jr6ANvMHL1vtvdMoRm0d6RrGg9w
	pqyrZVKqylW4Q+tr/t9MOE7YPoFk1OfhAFAf58VkNumlyCo3AmU90hJwmL3aoBiAVAfFgmfUxYP
	tvEULwgS7IWJKZqZHLMXCVcSSBRcCveY=
X-Gm-Gg: ASbGncs7dCKEKDa9EjS0cjaO8WUFAHj8TIA38kISOvQ5UHDri7SsCHdrg6kXxHHEgK3
	OcaUl2fppykmBN9TZYiu6sZ7wm0wvomj5HONbjC2Yt8YHqDSt+5QYhQFBleZOskyVdfddUyHXRp
	W+aGOlzM6PNbB9VU0VfbDJ5SQkmkGofFzilWjCcOs+0QxOT7EkmzDJFXdCkrSa7RlzLduTTid+N
	o0qd+6zxIjV+hwqjSA0Ym4Vl1MsLWFOHFFAaVUyovHcQo6alLD3TKhqXwSYNslUuJOnyksrLDwY
	HBT/bCUzAOyBMDtEK/hT1ojzL8CCpMlZ3kR0oe+MDR6M44mc7QFWiAWoNAPsUDlwADuN3R1ixRV
	99zuGUbhw3zYlHQ==
X-Google-Smtp-Source: AGHT+IG4tizPpCrTS+t+qkNKBZLnkOofnp+IcXAXiJUxVZzoCXq66aOaGTcbmuC/WZL2HHhfomtNvIkgZR1CwBs8/oc=
X-Received: by 2002:a05:7301:1906:b0:2a4:3593:5fc9 with SMTP id
 5a478bee46e88-2a7192a30bfmr7648989eec.3.1764014432680; Mon, 24 Nov 2025
 12:00:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251110095025.1475896-1-ojeda@kernel.org> <20251110095025.1475896-10-ojeda@kernel.org>
 <98e549da-b7d5-45bc-8a9c-d05eb06a75e6@nvidia.com> <CANiq72mcQJnW-F+nb=Vseoa_amcwwhkC26N9BOs12MVfMVOdVA@mail.gmail.com>
 <27735776-7538-495c-b4b7-2ae8893d28d6@nvidia.com>
In-Reply-To: <27735776-7538-495c-b4b7-2ae8893d28d6@nvidia.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 24 Nov 2025 21:00:18 +0100
X-Gm-Features: AWmQ_bm6tYrxXRTZPykfJMBebDHDGbX43F_-36XRzN696OPkPdmldh6vK4MLJ8A
Message-ID: <CANiq72nAJeGZKZUND8Cwmd=V5_rWAmA=KYUD-TZ6auV9qmCtvQ@mail.gmail.com>
Subject: Re: [PATCH 09/18] rust: proc-macro2: enable support in kbuild
To: John Hubbard <jhubbard@nvidia.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 24, 2025 at 8:37=E2=80=AFPM John Hubbard <jhubbard@nvidia.com> =
wrote:
>
> A minor thing, but, it looks like maybe this was forgotten or
> overlooked in v2?

No, it is there.

Cheers,
Miguel
