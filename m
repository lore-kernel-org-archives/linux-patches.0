Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA07194A42
	for <patches@lists.linux.dev>; Thu,  5 Sep 2024 07:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725523071; cv=none; b=BhDAuKmxF8Ld7SbyFoyuY1HMX9gCsL19+SNYP6LqoO/LmzOwZJkAz/3qpoJ9tFiXA+AENurMiY1DA95UzNZQHXScta7qLdpw/bklY6s84Ybmsh/o36Jx/DcwLwb1/U61Rd0s6QraAKXRIt06HRymIQ3quAe2Ath6Do/TybK3xzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725523071; c=relaxed/simple;
	bh=uzqoXNG3+qdG4fZg0Gqs2RhJ7NCXI4GO3eiiknmlaNE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C60XQgAYe5iCDlq3TaOSqOylIsTlXJb3utB/N9fjTBp5a3pg71HKF3GfrjNCLlfvGY8345EmBFh7qHTDh5zIc6fA4IX87tfFhOJ093F6y+XvQ8R+Yqe82ZGbxAj/7RnrKACKKqMh4LqbWnw284py/bc8H3y+SFqRR0KG68f2QCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=erR5vxTs; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="erR5vxTs"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-374c1e5fe79so263350f8f.1
        for <patches@lists.linux.dev>; Thu, 05 Sep 2024 00:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725523068; x=1726127868; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uzqoXNG3+qdG4fZg0Gqs2RhJ7NCXI4GO3eiiknmlaNE=;
        b=erR5vxTsTUcmp+8hQJQOG7JV4iPUlhrYpCX/nAjDKkqIFrRJuW9UFugWlQDgp8hWq5
         v+13Ly7lSjR+eW2XygO54Wev+MS8t+xleAns6ALbdkTJ1kMjW75ns4QST5w9as9hzYgl
         jhaYIXGeHLDtHP0uaoC4Le03Yoy1eXR2mkvwFwdAcMft7frbZWxc53hdrB1jnD53EIT+
         xTPzck0bW6nfNrJBHWhSiwRNRPlDp/U/zYNj8uvEm/R/9ufM8IqqiT3tIoho/7VIfrQf
         lspsiqlmPjivQWl3DFcGGW5G3cvkNcxhc3UyniSCTtLBxaUyuEUV9Hgwhfj4ZJR96Ltd
         2LYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725523068; x=1726127868;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uzqoXNG3+qdG4fZg0Gqs2RhJ7NCXI4GO3eiiknmlaNE=;
        b=cYg3AHb3Mpt85xUetVduXfvyc1xGL83PmaJa4vsBu35TQ36D9NmZuWIHs8SPKmbVwm
         YIDIkaX0+K+zM9h3USv2wGkZH5HwPANW7nPftB6INqyOA0su516XQ2RV8A2jr6ldMdTR
         o75pqcZE56sFTACsD6+mFKN7dwE4QdIgD6229xbwcssapYQziwWhjzvTI/GMuOwAbp5Y
         dR90fpYWu4678numiUVntLE/0jhBOhBHhC4owD8D7qb2QceHx5cLqua1cuT92IDb/nf+
         E7egdc7suZXDw5AdhwzD0G1lr0zU2ozNWTdJ91enT3QxD25wM+Kfgz9hAZuWFpYIMXnj
         9n4g==
X-Forwarded-Encrypted: i=1; AJvYcCVGOiWdySSBkqXnASr7EqC22FJfopxNhR2u6r4pDtYwWkTFrlmGcEMCEsWx+GeVc9mluDRidHJ4@lists.linux.dev
X-Gm-Message-State: AOJu0YzQy6MwJ5n6Os7udwvwDqujt/bWUa2Vxgeq0/l7a5ael6Jn895c
	tCOAcnR/cJoqZ/E0udfQ7KWKP85QCwjnAks2S9njlH2M/J954S4YEe567yDJBzAtbTrcDP0WLIk
	08cUaWGAjcc/RFY7oERUBqFpEzEvfAgodsrZB
X-Google-Smtp-Source: AGHT+IHTjzNnIL5A1Fd+8dZPOcunE+C0lDt4qQ8dgmGxe28nKfdYYnM8VoMndW494oUXHykAwYo0jir5Q6p0G0T9D5E=
X-Received: by 2002:a05:6000:4013:b0:374:c621:62a6 with SMTP id
 ffacd0b85a97d-374c62164damr10875495f8f.47.1725523067641; Thu, 05 Sep 2024
 00:57:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904204347.168520-1-ojeda@kernel.org> <20240904204347.168520-3-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-3-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Thu, 5 Sep 2024 09:57:35 +0200
Message-ID: <CAH5fLgjte9RYaRMHeKfRpefPBkXuSYp8FnCq=9Ftr9eV+V3S2Q@mail.gmail.com>
Subject: Re: [PATCH 02/19] rust: sort global Rust flags
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 4, 2024 at 10:44=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Sort the global Rust flags so that it is easier to follow along when we
> have more, like this patch series does.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
