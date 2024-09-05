Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756851953BE
	for <patches@lists.linux.dev>; Thu,  5 Sep 2024 08:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725523695; cv=none; b=RaPQK4DOHQ80MZTrnr87+mGHx3XBmWDN213rsELDyAdY/cCS7oVZty4q0/qWDOfqhEEc3F++ATddlJkJm1fBvXdsNDzEuGzUF8m6sVJDY5GceiXKNW8SBROohPBniwlxYshquclET9gNPDqNJfeIgFi9UxokKqs6IGLfZZRZJsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725523695; c=relaxed/simple;
	bh=poBaygU7+HWiLDKkFSk+8ccL2GmYFP/9Qk2v9fz7F8E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ay2p1P7CkL5aH/V5kjMK7oe4/mBWcsRMBTgzGTZ5zpOjmqXV0el7ws8QSviauMd0vwBjCxUwPuZe5etFOxOpcHWBWnzAfQXE2lqZ9Bu9hst1H9m3uyMgHqz71y9/eRmIWrTBaR673Lq0epFqPjqJsUR8KyGf1E+K3VaDfTrNSZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bFjWzsXD; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bFjWzsXD"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-374c180d123so223062f8f.3
        for <patches@lists.linux.dev>; Thu, 05 Sep 2024 01:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725523692; x=1726128492; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=poBaygU7+HWiLDKkFSk+8ccL2GmYFP/9Qk2v9fz7F8E=;
        b=bFjWzsXDodaO/3JyF8HiazwaIcERJgxyzPLte+IYwqv9T26OG5cdjTu7uu4noiMbpj
         CtI1BoJT9bTfXpf+/X6LJhiGho+lKE6w636h3+8AR6aCWcrCkx+sZ+OWdKBYByY+q0In
         CvDrQPqNty2Gs9J3b5hXYwKj+S7Aj0W+G4yQ+2vxW4iUI69U4Lct9wQulhyqzdcb2NaH
         vDAdUrWaTlx5h3HpZjJRJkNsxSSc+TMRoyhBF3XZGnrzeSXSXuVDLoQj1jtfi6buAFIS
         tOfI+WdWVGAoGMMOHcjNlXbeBRhQuzgqMMz1jWcOn8boXwfNlmRB77xIBnNxVR4BM0xr
         m10w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725523692; x=1726128492;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=poBaygU7+HWiLDKkFSk+8ccL2GmYFP/9Qk2v9fz7F8E=;
        b=oWLJREgAMRVvvvA+/40GTpo4ctUIVda6O0rkWowKToPc2co5MShJNbPBzuAGjGYFLt
         jevPvx3+QNNG5ggEeUmROfeRGdwBgwL1/vTV3ROkdEbY5XVNFZvUtU7skaZP4vRZXcEB
         tUDldiHxs5klK9DSiGdNzAmeX4lqjutKBpnzx7WaWkuBud+n7mjKnVdIR4Z4P1YLSenE
         Cz6tElp2497cBxuSDsocy+FHNh8vxqtFKxMel3nq8y15H6XTx8naRulWI+7d6OU280En
         uXtWiPofny0F4WlIQfJkXAcp4BfIXKyNzh21uIeXUCI+wZ22FGQgePhkXcGeXCJ2Ifp4
         SEXg==
X-Forwarded-Encrypted: i=1; AJvYcCXwJlfB+vJLjs3yWBoKOZjMuTDVAg6t7LLF5nDHd7IlZqWm/RZMGAZQx8CjfWeY6oyPM/awcp7a@lists.linux.dev
X-Gm-Message-State: AOJu0YwtiljRG9APfJ44bbHMg4B5RPngr7oduYbzL7iKJJxcxQrTnKuG
	Q7Mmg0EdKcOvkP165ahc+rkEU39hvhoxix/g99OrIVllg7Q6miRo+SY/Kw1KNRRafIclFNN0LSE
	v9Ba/UQCT41WE7JnulsSGzssSlYN0T7qIeb2N
X-Google-Smtp-Source: AGHT+IEQUylIRonA2uVlZFEoYTcRptbEOhXQeLWztRoXVHu9gmPqIPrVqsbgBqz3oJzQ8miyvaRCKs04O6ZvMsW8VkE=
X-Received: by 2002:a5d:40c7:0:b0:374:c05a:4046 with SMTP id
 ffacd0b85a97d-374c05a41e8mr9249377f8f.19.1725523691535; Thu, 05 Sep 2024
 01:08:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904204347.168520-1-ojeda@kernel.org> <20240904204347.168520-7-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-7-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Thu, 5 Sep 2024 10:07:58 +0200
Message-ID: <CAH5fLghKkzUpt0zDQVdpZCeUYRv+kUXCqkS7coUpFtaxNk7Bjw@mail.gmail.com>
Subject: Re: [PATCH 06/19] rust: enable `clippy::unnecessary_safety_doc` lint
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 4, 2024 at 10:45=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> In Rust 1.67.0, Clippy added the `unnecessary_safety_doc` lint [1],
> which is similar to `unnecessary_safety_comment`, but for `# Safety`
> sections, i.e. safety preconditions in the documentation.
>
> This is something that should not happen with our coding guidelines in
> mind. Thus enable the lint to have it machine-checked.
>
> Link: https://rust-lang.github.io/rust-clippy/master/index.html#/unnecess=
ary_safety_doc [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
