Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C6A30BF67
	for <patches@lists.linux.dev>; Mon, 10 Nov 2025 11:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762775441; cv=none; b=hB7vSyRLOyr68c4MhDS2OW+hrt1t0t1smlJcv7aj1RNOspPD9zZAtJwR8ks2H75UPsjxVf7UGVNacj7VQSK85lQPbrIaX0/Of5zSIUaO1Fb0FoVC2xj/nk7edwp72Qfpn3ElVmoRAK3nCKMmvFWaThgq4kn4aGtC3uxli19PPKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762775441; c=relaxed/simple;
	bh=m8FS1LKsvEj23KYUxGNEuRyY+Er+5K2VdZOMGbBWuPA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YEidpilbT8jCevvZxECU5zggu/2yz0YKBFlCVr3PJGdC9foBAOZbnBwplRR1By1wnpuGazdha7TxQfHLbh1wcq0L4XUURZXQDozYXJD/8eweCBeqqeO2bq13cbzcA+Jl2vWPVUDTXrDCmIu7pkMOMEhANJx86tPNRxkY5YUKzoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hywGxMui; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hywGxMui"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b70be4f20deso270410066b.2
        for <patches@lists.linux.dev>; Mon, 10 Nov 2025 03:50:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762775438; x=1763380238; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m8FS1LKsvEj23KYUxGNEuRyY+Er+5K2VdZOMGbBWuPA=;
        b=hywGxMuiNygIOZh2yifoK5zeiVjVDzSHA6v7zrLN99ki6mpXxC2SoF2UY5SOpTeZpx
         jupI8A2FJOtqxeXTMYRDA+9ANw0LB/yA8lWHJRnNYUWAUeAxPxRU3Yu6gbOIEZS6zuDz
         ACc3n9J4uM4/kew/EwZkK0dXp6LCyb+w81+FlWNmNfwSjaIC3XjTwdEol8/Ag4+AqZPw
         zSZW5b+1oHmfpfYiHTExkHUp0pHqRMM+xRa78F1KB10q0/0QdacMr8MS4uBN7yqE9scd
         7CDaW9gArlOufkwclh1VZc88dihqYtdDPNdgJjEvMFrtESgqpd726FvdId5MHMIbD3m5
         t8vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762775438; x=1763380238;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=m8FS1LKsvEj23KYUxGNEuRyY+Er+5K2VdZOMGbBWuPA=;
        b=Iu1R/9amwT9mZ7/VXt84/idDzvtRGqJqFTbDhJOK79PpSsOuc3T/5qctIUjUG7wuB3
         fgdDscR/IMtWwnyM4WDdvjyU/nFz8XJ7OMw/L0puhv7mjt/Wt8nJq58ZtfXOHnJFpZiN
         tWuXZDzdShBatG9Hlju55EkpHl4LEU/qYcYl2AgLeLvMOszYCtkUnBlYe3rozFzR3Y8p
         qQ1d3IoJMklNIjsm5Hkm654jUUv1rYxOUybYQpjFJyFSJWfyvscTEdAmp3kYE2/UHg+j
         qZeikck8mCLA+JurQJucfaeo4FXzQUqA2d3FZq06zpH0puNOx9+59OFWTMc03riQozy8
         4Diw==
X-Forwarded-Encrypted: i=1; AJvYcCXr4sPOd7tmFIAyRjP6uBy0XWEVInKSmZtfGQOMKIbHnId1ozzNYOLoL6CvVaapwUfQBduG3+pq@lists.linux.dev
X-Gm-Message-State: AOJu0YyIuuFHR6ZX3U9CXp0WbzfD5zgl0EwEbNX3CoxgLUQJniP9e5Rx
	rpY7Jo5EsV94Agu8A+LuiYvFiCdeQyRCsC7nqpWg/DCEHyr9hNO56rpQSGRWozsrvbJu+0wZ2+Z
	Aeb8ztmZHMdC3Jckgyg==
X-Google-Smtp-Source: AGHT+IEdN/OzNgvJoDSQXjw0rImyZwQBZCotyROrmcQM6Hiiz8GNRc/HF5cFI/FbvnJNkDypZwcJNKuHze4K1U4=
X-Received: from ejcwb12.prod.google.com ([2002:a17:907:d50c:b0:b72:41e4:755a])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:3dac:b0:b72:d2df:641c with SMTP id a640c23a62f3a-b72e04c520bmr672023066b.49.1762775438697;
 Mon, 10 Nov 2025 03:50:38 -0800 (PST)
Date: Mon, 10 Nov 2025 11:50:37 +0000
In-Reply-To: <CANiq72n2TDN9oa7Yu2otk=HfpJQ7NA_X=up4uGO=JszGvaGspg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251110095025.1475896-1-ojeda@kernel.org> <20251110095025.1475896-3-ojeda@kernel.org>
 <CANiq72n2TDN9oa7Yu2otk=HfpJQ7NA_X=up4uGO=JszGvaGspg@mail.gmail.com>
Message-ID: <aRHRjaSHO0z9R_Se@google.com>
Subject: Re: [PATCH 02/18] rust: kbuild: introduce `core-flags` and `core-skip_flags`
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 10, 2025 at 11:19:19AM +0100, Miguel Ojeda wrote:
> On Mon, Nov 10, 2025 at 10:51=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> =
wrote:
> >
> > Thus do so here for `core`, which simplifies a bit the `Makefile`
> > (including the next commit) and makes it more consistent.
>=20
> We may want to eventually use `--cap-lints=3Dallow` here too, but the
> skip flags here were already feeling a bit more than needed for the
> series.

Using cap-lints allow for core sgtm.

Alice
