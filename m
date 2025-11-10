Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974CB314D2F
	for <patches@lists.linux.dev>; Mon, 10 Nov 2025 13:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762781717; cv=none; b=mArRopATFrG5GUsIBG39HhlbtzVb8+vegOhF4XqVP4lDFnXgNGQPS7IWx7g3FwPiAxz6pMUXZlGASgsTfxEhZuZ40ekO9rYOKYQx3iHSnnVFj7BO7luqQOybAGR6HCJkIB9KZNzARqkMF4Sv9t1MgmWOIHZBoRnHdwwsBQac30s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762781717; c=relaxed/simple;
	bh=lJTzHX80gcOt+ynIbaRl5FvzwWQVyPrlRODf/k1ryGc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jH9nHC8L2lBLqsykyJ4SKnv2dQ16eSf6s96yI+THvknC8igrj8xJKGa67HFKD/WXPMu2ePPl87JZ2qP6sVf+MM+hbUJ57oosu/rsvBvZ3MGUwdgee5x5eAwOygbGMGNkKme0nIMbOcDgI6DDRPLQU2oMODrKVUaGFHhpU0kbUGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AMh6gluG; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AMh6gluG"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-429cceeeb96so1511386f8f.1
        for <patches@lists.linux.dev>; Mon, 10 Nov 2025 05:35:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762781714; x=1763386514; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lJTzHX80gcOt+ynIbaRl5FvzwWQVyPrlRODf/k1ryGc=;
        b=AMh6gluG+DtWcDATv7p0/UdqSoI8x7aCQ15Rar5rQJedDE+vKPZ/JKUL8+h25bqJgm
         XaS/06KjmDXHydeXpDON57rujibH/jCnJs/vJrQqGLTFPihGmiADd/EDLVPbvaS7puBI
         0bnzLS1H2S9jcn0v9bhJVRFu4WyR2nVMOuGSdFvvUXIRWfDZQX84OcWLoch2+nw0RjmY
         83whcUuuKT01W03N7TitnXWfoTJqbEuSI8AK4zR4/kucHG35L+vVEm/j/NnarU92pH3n
         iwuh5A3GB5DNVlZJm/fyTEp0OMaOjCrujYnRKEmX8qzVl9ycMsy+KftpHeB3iGngv73q
         HUiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762781714; x=1763386514;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lJTzHX80gcOt+ynIbaRl5FvzwWQVyPrlRODf/k1ryGc=;
        b=jbGbniMDrY4+3H8kIhz+oP8t2bCarc/fNMzms4U7kUG1iVpN5rUjOy8iETe0T466cH
         cwP1YauJwgRWvgjWSH258GeMDZwtbIJH6BTo1EOj5cajLjBb2oR0cOBe40EhJNEFFYHG
         fHQe0XTdzfvWLOyHXSycseYl9sGYH//D8OZ/uNitdLXCdz93PVuFylTHHKUSICqJId1X
         6Bn6slkDzSYqO+UDfmXb0yGseK/GXJxJJo8XbdAHRTsQYpChsmPL+Bi2q1SYq2HDs+ar
         Syx2sph+znqMUGkkeGDcwy/V3oarKpVNJVdUW6Pqb09ILkgQw/QogC8qJ5LK2mltfmyZ
         OOkw==
X-Forwarded-Encrypted: i=1; AJvYcCUqU3sfLG50mX0Zb6A73nxetQaSJMaaWBdBhdqq3+/CuZukpASBxulYYw8rf3GpwpkS71tD87++@lists.linux.dev
X-Gm-Message-State: AOJu0YzCDnTwPW/v7gyG49UsIdVoB+vbktQ0JS9IeVdP62OJ3FmteU8G
	rQh6rLaMAbKAJLCIjiENf/ouiSznWf6zYIrpY6oIF8918nyMit+pKv1DKNunnIkbit/kOAEX3H3
	99CiPxgBvMRtIjBzj2g==
X-Google-Smtp-Source: AGHT+IGnJplCiE5BS7Zbk5yxG+qcfdSbsxfffIFOw2vKoXQs/5pM3T2FKjbg9K9S0Pk9TrgnCi+z7Nq4/0WV7WQ=
X-Received: from wrtp8.prod.google.com ([2002:a5d:4e08:0:b0:429:c4e9:626])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:288e:b0:3ec:db13:89e with SMTP id ffacd0b85a97d-42b2dbe331emr5614498f8f.7.1762781713969;
 Mon, 10 Nov 2025 05:35:13 -0800 (PST)
Date: Mon, 10 Nov 2025 13:35:12 +0000
In-Reply-To: <CANiq72nkjWbtEktSU_TrEfY2Agy7FK0-OLBWPLqTvp_p-CkBUg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251110095025.1475896-1-ojeda@kernel.org> <20251110095025.1475896-14-ojeda@kernel.org>
 <aRHQA6FEoxACerIQ@google.com> <20251110131326.309545df@eugeo> <CANiq72nkjWbtEktSU_TrEfY2Agy7FK0-OLBWPLqTvp_p-CkBUg@mail.gmail.com>
Message-ID: <aRHqEPN-aCI5YkIr@google.com>
Subject: Re: [PATCH 13/18] rust: quote: enable support in kbuild
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Gary Guo <gary@garyguo.net>, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, Boqun Feng <boqun.feng@gmail.com>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 10, 2025 at 02:22:53PM +0100, Miguel Ojeda wrote:
> On Mon, Nov 10, 2025 at 2:13=E2=80=AFPM Gary Guo <gary@garyguo.net> wrote=
:
> >
> > This is to be able to skip over edition flags for `quote` when building
> > the rusttestlib?
>=20
> Yes, it is needed to support skipping the flags, which isn't needed
> until this patch.
>=20
> It can be done earlier separately since it doesn't hurt -- a simpler
> option is just to mention it here in the log.

With that mentioned:
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
