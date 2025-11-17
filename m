Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41A62D877B
	for <patches@lists.linux.dev>; Mon, 17 Nov 2025 07:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763365677; cv=none; b=FDgPuLByOGvTZ7TfcgO0ngXAkCJxz24si7bcdyXl+JsbANod+ugu6ezKY24buztJ3R0Kud/51AxygL2hpowzynftBBVpYH0bPlVJU95xkMQHdjAADrrrAzGzwtext7c6kGGJC364chkFOg190qRG6BV6BBomDgBTEMv5n4OTuQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763365677; c=relaxed/simple;
	bh=6h03JxPLBCObWAwhJP4a2KbRLMtLdHN8HAsaICDJ4Jw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K2OREZVzJtdrR/dkl9LKSrzZmfrOtScdKYOUZlrVTO0qCApcujoE4cyyTAgEJdGOPspsTkV66uYlpw75qGnKHKm+Z5BTYWDYLJOhvfPKzn1jWu1wecs409ebXv3XB83cTZvhmFP6G8zY7k3iUHLo3Ycc2nLOeZqd81w6mDUWVn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MqLRPx4/; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MqLRPx4/"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2960771ec71so7278235ad.0
        for <patches@lists.linux.dev>; Sun, 16 Nov 2025 23:47:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763365675; x=1763970475; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6h03JxPLBCObWAwhJP4a2KbRLMtLdHN8HAsaICDJ4Jw=;
        b=MqLRPx4/5iSGgPY7/KLOw1OJtwXK28B4jjoS/y7nRvM9f9YmccXKqCxjUT5jUd4h5W
         vD3j403JMfXlGfJgdQrv/DVxMMWD2h0e/2jkpJG7jaMsXgu7YL6wstiJXtWBZBMBABhV
         Ct4S25HhI15eiT4EnUWqtEydj0mVJKd38zlK4L12CUM3JWL0B0hwTd0M6ulYIvmmLqia
         zUQ/PoB0KP9A6m7exwYQMMuvK++EFsL7W8vPzsoEGI5piRS4eAPMGPieHc6/rDPg/tKz
         HOtgVCFs6IEN+1LdZYtSPDN/p/w2G1UbxWkcKRTHDbuIwaRLyv+fiC2+ml9+RIgcl0i+
         8yBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763365675; x=1763970475;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6h03JxPLBCObWAwhJP4a2KbRLMtLdHN8HAsaICDJ4Jw=;
        b=P8GNyOgqZ5RZh8/q2QPfmR6I0kqlcEZdiAxgY8G9Nsj9pqSf3fXYpmZIUD2WATfkRy
         HDNwBswmEEQTpS8353KJu3PcH4enEieRLYxdnGlgO/NZhFrbVBR8LyKV0MIBUj1GJ/ES
         Q+jv0ys3Szm4QCte74uWKBHjaZoF6NJxOC0jtnhRwrJjHnRO8RGEFIaWPKIOFgrOBbb2
         pPJ04NiXiYp6sR4QHdBKGNyBLmzZIM0WVWoTrnuvwH1XdQpfmRVkg4rvg00RZcDUAhA2
         FEzrzPqcG9atYy9Q/ItyW/xSxNuq6VuYXIYgzqj1dxGKnfUJvKBdALt3XLEnIhPWi/SO
         GNXg==
X-Forwarded-Encrypted: i=1; AJvYcCVdVZ6Cq8KchOn7Q1IGGfJTdD/yxRy4X6WN7KvueeXv6oHNO4mK2XpRGvBbUekeb8g6M3G/vnCu@lists.linux.dev
X-Gm-Message-State: AOJu0YxXR3I33lFLpV+FeXk7tt/9gkLfpuDxfnaqRWLnEsNTwysJW9h3
	q8rs3rLVPyjuxI2p3xR8PA6lMW8zoferxW85bLJISz3Hr0g3Few6vNdDP11Y34J3OlmdJ/ZRVEP
	cGvKKz9JjH4NlWh56prnsqROAvtTv/z0=
X-Gm-Gg: ASbGncvgLV6NHrha9GmwlL1wbCmThY+Y77N9wzg9V6BJgk7bAgosFZDRhYjzu+W7/KL
	CsFWmlD7b1DLxzMzHxeQnjSdslnIWp3EN48ZfHEHHatDnuIUnnzE3J81CoOygyTS5cwxVH3/PIA
	Z5kkMyGMKfTdc1u2WDK4LxwObFOliCqrFdAOTLnz3Q30pUoT5fm2sLczu0gefkXXWOo/fj+OU7q
	pD4tjoT4BuL68B46Bks8p7CiEmYoBGFPnsOWCzwNprYjCJXwhoOwObpxApYHyO5Mjps2aelnozG
	fVPswTIbYpPM1zSb8vCEnw957FpRG3tTRuku+SstaVMlXzivsSkRuGg9fazAs1d6sXKAsl6AQzw
	IWnM=
X-Google-Smtp-Source: AGHT+IFFDBs3uvggDFXgm4+aW5NTqsoiQZXkDqUFQSMJ0CthFqmTdAaDC8RRnD9kMAtxX7gN4X6R4AMduf8hjUblQ4Y=
X-Received: by 2002:a05:7301:1627:b0:2a4:3593:2c07 with SMTP id
 5a478bee46e88-2a4ada4d389mr3165047eec.0.1763365675064; Sun, 16 Nov 2025
 23:47:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251110113528.1658238-1-ojeda@kernel.org> <aRHSLChi5HYXW4-9@google.com>
 <20251110133843.37ff0749@eugeo>
In-Reply-To: <20251110133843.37ff0749@eugeo>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 17 Nov 2025 08:47:42 +0100
X-Gm-Features: AWmQ_bmSKtV3tIFKwvS6r_Sme3lOlGmgdURMZ2zwl8YB1szsDQkVnRqRV3WGudE
Message-ID: <CANiq72mO_g4uXV5GBGKECx4BMO3XHPNgYzmyjX7Q=Lfoyu=How@mail.gmail.com>
Subject: Re: [PATCH 1/2] rust: allow `unreachable_pub` for doctests
To: Gary Guo <gary@garyguo.net>
Cc: Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Brendan Higgins <brendan.higgins@linux.dev>, 
	David Gow <davidgow@google.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Rae Moar <raemoar63@gmail.com>, linux-kselftest@vger.kernel.org, 
	kunit-dev@googlegroups.com, Boqun Feng <boqun.feng@gmail.com>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 10, 2025 at 2:38=E2=80=AFPM Gary Guo <gary@garyguo.net> wrote:
>
> We shouldn't
> try to enable all clippy lints on doc tests, especially that clippy
> doesn't run today on rustdocs at all.

You mean on Cargo / userspace projects, right?

Yeah, I think they want to change that -- it is a part of the kernel
build that works better than the usual Rust project, in the sense that
Clippy is quite important to have in order to enforce things like `//
SAFETY: ...` comments.

Cheers,
Miguel
