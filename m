Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC061AB6DC
	for <patches@lists.linux.dev>; Thu,  3 Oct 2024 18:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727981246; cv=none; b=GE9XtDCv65Z82izc1jdECJzD0sNqrdR50LD/x12wol+ftUvnPT+rsYzTfUKwU2eqtqSeTtQQ98uf9XhB4KvynOXxF4shT4/jrt/6gy8Ta1R4ZZPPw9ujuany2lt22q9CWs2iMItaqOFE7CR+1/vUD/jjq8XbYHYw0EHUonJldCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727981246; c=relaxed/simple;
	bh=BHzOqisEFLFox6mXku+m3ttFgkN8Btbj94wO+ixxN0E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IxGFnoE60tmzyzsBmJfit3965hMI05I15kiJYowrEiw3wEJTJIV1d40lVT46DCdrNESf/TwVRr+Rl2RmHqAKWfxf36uR92SMAffrHy75NyKTiQGSwlqyFYkAS2oWQoDXLFfFkLZ4V7OtIOzzVBy7h9dFSHyaujk0iK8WW6dl9qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UGzWQVT3; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UGzWQVT3"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-718ef6a26dbso64347b3a.1
        for <patches@lists.linux.dev>; Thu, 03 Oct 2024 11:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727981244; x=1728586044; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BHzOqisEFLFox6mXku+m3ttFgkN8Btbj94wO+ixxN0E=;
        b=UGzWQVT3QNi6+IXgxmF8FcvIW9siGISQzdVK9bCF0vrpdRpAWuRlDYmPY9Z1Acy4Z7
         lXQJyShhme/ZmEmql8f73L1KqqR3munbC10K/Bmajp3xxHZkXbxkslv+zFe8Z2AtXgZb
         cUg6O6ds9G0PhfLU4O+H74+txPjk2sAnKoQ2x1tmsE4G/7yp5RsE+KBsncF8jWcIIqav
         z5zfbnwclLBdp1eRAtgOBBIJneCClDrEBMaqboB1Ifc6I85KadSxQK5J3o7tnK8T8JMT
         Y8NwtjMueU0Y+rVuaSyENTu60qdkDnZ9c8MKeok6p1Rt68gZVcNRw+RDgsbXamOGB58y
         BmyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727981244; x=1728586044;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BHzOqisEFLFox6mXku+m3ttFgkN8Btbj94wO+ixxN0E=;
        b=K8m7chJad3gbnMh3XRDrBEuMB0RhV/IcJW24cyR58cvRkyhmYxGFT6qtUj5xVlUii4
         YnTaxSdohGy2de2iMwZ212xYjPpTmPrYxH37OrUG16ihKK1K5upL0f0viKmSLxBAQ7K4
         JVCAZdHiNOV7pDbFo7is1OHT/HRNQR676qcW5rTqDYvkp15/gTawLHrtYL9UfX8I/P/1
         9Kc/iyd2R/r5HkYGshSSGYQLn1ZEzW+jvn2IMCsB93x5pjT66Zg0ulP0AyZ+7de9ykZn
         TGEOHnCq4DMBVvQdxO0vWVrbOgWnyQfqvIExduRGAdqvVMTf81rTVRHSU8ryvfSiD9T5
         hQhw==
X-Forwarded-Encrypted: i=1; AJvYcCUFc/oKDGEYAOwWpLIUacBzq6AniyRPkBYF/iPfE/1N5lAlZ8XP/h8OwoojiFEaPbhUe5CwebkS@lists.linux.dev
X-Gm-Message-State: AOJu0YwpxTZpX1UMOOrQNXabJulsyAgCMEba5+MJojJUlvDsRIDzoNnT
	Id79lGh76CQmguAAPwjL4fN8yOdPgXv3vtZlBfNhsmsJl+u3/JfLuMqJtF9l42bu3D/TQPhBQIu
	9wWPKMzWyqjZ5wvFXpeBziumbT+I=
X-Google-Smtp-Source: AGHT+IHQSKPGH5/k/nFbWQQSbWal0hDnFnxx3XKzOECbMsBCPokb9Hn4CYRGnqUL19UtR5ee0tB2w9mdue7VRvsAH4U=
X-Received: by 2002:a05:6a00:464e:b0:70e:acd0:d8b6 with SMTP id
 d2e1a72fcca58-71de22e6819mr86562b3a.0.1727981244078; Thu, 03 Oct 2024
 11:47:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904204347.168520-1-ojeda@kernel.org> <20240904204347.168520-17-ojeda@kernel.org>
 <CALNs47s=kCJUJstB4WW1KF_b55-e1kYQ_1rZjPu=LWxv2gmF3w@mail.gmail.com>
In-Reply-To: <CALNs47s=kCJUJstB4WW1KF_b55-e1kYQ_1rZjPu=LWxv2gmF3w@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 3 Oct 2024 20:47:11 +0200
Message-ID: <CANiq72=ZYgJB-fcFfrnq-wTYAAdqxg5zXJNZGEzbMtvQtSZjHw@mail.gmail.com>
Subject: Re: [PATCH 16/19] Documentation: rust: add coding guidelines on lints
To: Trevor Gross <tmgross@umich.edu>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 29, 2024 at 7:03=E2=80=AFAM Trevor Gross <tmgross@umich.edu> wr=
ote:
>
> s/ocally/locally

Fixed in the version I am applying -- thanks!

> It may be good to link to the docs on this,
> https://doc.rust-lang.org/stable/reference/attributes/diagnostics.html.

Done too!

Cheers,
Miguel
