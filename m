Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408BC246A21
	for <patches@lists.linux.dev>; Wed, 15 Jan 2025 09:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736932248; cv=none; b=Fbn5pVpq0unVugJBkyhsSzMZtlrZKNQ32w5EZS2EXDlqFAstPfKVNC9+dsxpR57cYHjIhXHxuGsuLkbPADOemg2d2AwanwSg/K2tOu0n2F++HRQ2detxSF19aXdVYx97AAj8YP2N8EuWULhgtDvlY0HbclwFrxmfta5CNhphPjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736932248; c=relaxed/simple;
	bh=s4gowUCkR8ThPcXmpLKlGclM8lC6TIMzjSkqs9savQ8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hqAs5hb+BpqifvBarFHovWDjCFkXe7MxNWQni1Ssy82r12bWsIsgPA9XKI+fYuWtpf8KT/M0LVKsY7dujmmMZbN8VJFYcZFbTMuZ+NxK8zesWANH5C50jrCvkARTX9bKibFodo9ne34VdOgO+DOwQmlly1RaD43SDgQzUjzwn80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nAlmyG1n; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nAlmyG1n"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2f615e14d0fso843545a91.3
        for <patches@lists.linux.dev>; Wed, 15 Jan 2025 01:10:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736932246; x=1737537046; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s4gowUCkR8ThPcXmpLKlGclM8lC6TIMzjSkqs9savQ8=;
        b=nAlmyG1nIz3j57MfjQsWLdUEoD5uZNdLhlQQ5k76d42IRsN1wFMZZWLliibKeOGAgU
         GW1suCtOI1Bq1u9dA6eSz08VaIXnqVuaR043f8Ch4Sg+5iIlBqxnokBtBglNApKyagjp
         QlbkaS+D2jk6pvrdhBGGbEnvSMiHpUzRb2YGWQzlppgLu8MOPivqvSNPr6Dr26Mxh0Ga
         4hqykzxoA+juEvhWVB8KvFwKXYq12lNXno4npIqfWK8JruMaLQjMPMnmkrWSIhavnqlA
         QMKvvvgAhW700HMiTuyGJoR7Dgj7gXR8byb+IAQjCnP14xhFJCAOuR0F7hkX1wKpcH8U
         poDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736932246; x=1737537046;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s4gowUCkR8ThPcXmpLKlGclM8lC6TIMzjSkqs9savQ8=;
        b=kXVLFTzBLr+33B3s+zcr2KwB43MPsyNvJ7b7EiuVbMZiw8Ym6Nz+nCXjN0XAXRXqjA
         HF0cayn+UGP+BNwlJIJ6QyVjQh2KG4RRMhJRwb5ZCeo5bb2o1JpMuGaAPaRD/sqOtgLp
         gi/kRrjvFZ8814GDhUiVYZ+W9LhmqEeqBOlmrc/m1cBL4M+C1BWXBcEbGuBFRiWEFBR3
         4NnNAOuCROTgHFE/G/akC2Fz3aYffzOcmkND11DZyAEy4K7YVlTP7dJ1RCuoLY67JnRl
         Ij9WhKxdt65Oo/4yM2atETlgV4EuOYh8HbmUzc6OaBqdXIshDmxp/7Nis76j3XkYrMpP
         6arg==
X-Forwarded-Encrypted: i=1; AJvYcCVf1Z2kwVNZBgKXdcR4ZZiwqeuO6AUduXy2XynUfbPyxcK7y/QNONhhK2vrfZqxYwGbEenfMXb0@lists.linux.dev
X-Gm-Message-State: AOJu0YzLMe4rkhr/hLrRwothG0+SJCsbBRyXWnH3sqChCGliZhNT0g3p
	mXU/YBmW6GUYl48iVzE8uO1nADLSs35Vo3OOHz9A+kxPgUuSrPtKAHM46NToz7/A8taoZCVBBJK
	jtY0I5iyCwqOPNSd+y/Uu4mW3ICQ=
X-Gm-Gg: ASbGncuq5DHfInQ9MPiuO0gIt5ZRqFNSamSv6so1rydK/1hV+yZuPCzDhXKNYwNc0S6
	rg6pdqMP4b+bfP49u5Hq0Quhzk4LMaKWUHZdotw==
X-Google-Smtp-Source: AGHT+IF5o5Fngx9F8mAKdkHS+kf8BLRmpwBINYjoHVCcfYVIb4s1YvcCTtZ+OZrv6w6UeWm6DL+Xl1deyoXsqkgUcPY=
X-Received: by 2002:a17:90b:37c3:b0:2f2:f6e5:d28e with SMTP id
 98e67ed59e1d1-2f548f1c677mr15527940a91.3.1736932246563; Wed, 15 Jan 2025
 01:10:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241112184455.855133-1-ojeda@kernel.org> <CANiq72m+k07miKu=vHfp1-A+nu092R+khau5b95Ugq8M8sksFQ@mail.gmail.com>
 <CAK7LNASXLdya8d2Cjo9H2j5J2d8ukj27aDNStqWEVbDQFgsP2w@mail.gmail.com>
In-Reply-To: <CAK7LNASXLdya8d2Cjo9H2j5J2d8ukj27aDNStqWEVbDQFgsP2w@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 15 Jan 2025 10:10:33 +0100
X-Gm-Features: AbW1kvablhI2XqwtFDUl4ZnT060edaVgVSWH6gDoFIWIPktYypdDmv7lacp_u_Q
Message-ID: <CANiq72kpCMcDgpRuUA-5oJq5dYgtLW2bVkk+H7fU6CTtKAw4SA@mail.gmail.com>
Subject: Re: [PATCH v3] kbuild: rust: add PROCMACROLDFLAGS
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, HONG Yifan <elsk@google.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 15, 2025 at 3:56=E2=80=AFAM Masahiro Yamada <masahiroy@kernel.o=
rg> wrote:
>
> Acked-by: Masahiro Yamada <masahiroy@kernel.org>

Added, thanks a lot!

Cheers,
Miguel
