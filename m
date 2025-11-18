Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A56C3624DB
	for <patches@lists.linux.dev>; Tue, 18 Nov 2025 14:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763477898; cv=none; b=Nhn/D2jYwLrrRUl+ww08OEyvpV1d4w0NlCl+uL9Avv3GAN7OG5Pu60f0AzdSfBy2iNwzzx3D3dTt2KJdOinbjGSL1dbq+IeFV1a2K24VBnQW5Zk0h8d6Tgzr+kRhFMMt2TkzL8/IzNHHbLn2PMMiBlHx6iZSrEo5RXZIw5h9xtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763477898; c=relaxed/simple;
	bh=DPfztGpTpKeZwjuO3Y+4RpBkmoIsNivSOXSgBqsyN+0=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=LPAxwS4LNdTk7wPNYQ3yLGOBYaa4E3ad7DipMtbRMmLqvJ38cYR+3+AcbnUvomANq02+jb2tHDmk3JCso8nq+EJW2Fj14q5nHBJGHSOCXq+rqFg0NUdGSE70mRQEEzOMh3G+7lx+h6N1dJQ9p+FVj9lUX8cR3caNdA95eQo8AZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--gprocida.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rlO/Kxrp; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--gprocida.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rlO/Kxrp"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-47106720618so65640825e9.1
        for <patches@lists.linux.dev>; Tue, 18 Nov 2025 06:58:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763477895; x=1764082695; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DPfztGpTpKeZwjuO3Y+4RpBkmoIsNivSOXSgBqsyN+0=;
        b=rlO/KxrpCxEeMH6LJmPYyPmh9+WdzY6RXcHz46vEfBDTN24J9neUFgPDUd/PGMRXJN
         MrTCg83yn9Rv9VqxkN2sJWwbl9FdFH/QgQJauz/u+WoWfeGBENygTMCTJk4FMn3QYhqM
         FleicwL/JkIJUHKqRpkr3yyAL0xTYaANKMYFhqhefX3oZ+6Tbkqy4Wf8Cf0qR6L9tiw+
         XG+9alYrfsxJ2kLdit4k4Dke9FKKJiSjbAfwy+/7I9nGl/kvA2P2cu46KoVpLtFjCEdD
         kM6CABLwaoyV/QZgA/g3dn1Wx1V37lTLbGFXPSjGt2sNaQlMnwtaFsiP1MUQQx4IvjTn
         n88g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763477895; x=1764082695;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DPfztGpTpKeZwjuO3Y+4RpBkmoIsNivSOXSgBqsyN+0=;
        b=cD+x3wALPXSkWPfuXxpUK4Qr/oX3AwgFg98Xd3lpt47E7tgqX7zRikAqX4iDSAhG8s
         S37/YyAHaOSEfSwqPBE4m7fNE+Hn6p1iPNvsAyqje/ZVV1FiUmGey/nlGxtOCzibDsxI
         aAYjqq42uBagOnKsRhTJwcokN/iQzIzxoGRLXGybRgb8i4KiFm6oVH/gBa1hJyrrU3rd
         x7NH7o6elZgZXvWzP2lDCeVvinS3/saOTMu0+UtPeuXNskgmLSh1mp5Ykal2I90Z0400
         mLI2HFSLOzBnAlOiLxcXsjSvsKdtnsKYzqbDf+xMVDwNaSk7Atw1d5EurljJstLZU07a
         S4vQ==
X-Forwarded-Encrypted: i=1; AJvYcCWmeKbruaS6Me3Tr3Fi//GIOu0zVW9TOYrqONiKAXC37q+iBrhd3YT1WQzuIQae4AVfLCiVUfDe@lists.linux.dev
X-Gm-Message-State: AOJu0YyhcuXzGKGknELspMaWT/1epyKZot72GjEF1jupUGZY7GIVxVMy
	W7OnLqJXx+DzgAqRdde25OrDm62i5ZO+46inj3RQVVpjQlZs9JiUG+9ZtYDBgzm8E1/6wMl25fr
	iB1VvmS4bHfmuAw==
X-Google-Smtp-Source: AGHT+IF5IuKqsfo4fGvtEqK6+inM6Wme3e1NzVR1nM/R1oTA+LPa6JsLnhIYst5T5QUx9HKDMNad3Q0W0SjPeQ==
X-Received: from wmpl35.prod.google.com ([2002:a05:600c:8a3:b0:475:d8de:fe5b])
 (user=gprocida job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a07:b0:46f:c55a:5a8d with SMTP id 5b1f17b1804b1-4778fe55101mr148495515e9.4.1763477894678;
 Tue, 18 Nov 2025 06:58:14 -0800 (PST)
Date: Tue, 18 Nov 2025 14:57:36 +0000
In-Reply-To: <20251110131913.1789896-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251118145741.1042013-1-gprocida@google.com>
Subject: Re: [PATCH v2] gendwarfksyms: Skip files with no exports
From: Giuliano Procida <gprocida@google.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	linux-modules@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org, 
	Haiyue Wang <haiyuewa@163.com>
Content-Type: text/plain; charset="UTF-8"

Hi.

> Thus do the last one: don't attempt to process files if we have no symbol
> versions to calculate.

This results in the -T foo option being ignored in the case there were
no symbols. I think it would be better, consistent with the
documentation and expectations, for the file to be produced empty.

This means that just the for loop should be skipped, say by adding the
condition there with &&.

If you disagree, then please update the documentation to match the new
behaviour.

Regards,
Giuliano.
