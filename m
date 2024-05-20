Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23339224F2
	for <patches@lists.linux.dev>; Mon, 20 May 2024 09:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716198082; cv=none; b=W+iKRE0UzDMOBDEsLUrLeAbpJD/SU6Ob008je7k0qqNmFhvy8zxQLC7NJUTAXVuJIh0yBdmKcXbXSdHCxssxVnOJl1JaezQBcaf+BQGn2cdC/n70qYp867763FPX16VdVQcjczrMKhdF0LLZpsAZa5RDWuRqLRh2cuj5TYwj0zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716198082; c=relaxed/simple;
	bh=7uuugY85m3skoiVn07kJvXcB4zJBbm3CV5cNkHDjjBE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f+mb3DZ+t26UMfB0eJ/ckh38jwnoZB4FmrBvdgo1wvu8jmi42KE+aCI3M3zW5E/CGKn+gQqPZkZEv6r7YirwjyMYAcJDW6tjhIS6uDS1W72zTlyshOTqJ2ejzw3UwTcYM2QcbCdwybxFzfyJj6AcrX1RM9X93ItEFhsxRrshDC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HTAALj9+; arc=none smtp.client-ip=209.85.222.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HTAALj9+"
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-7f82c932858so1283131241.0
        for <patches@lists.linux.dev>; Mon, 20 May 2024 02:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716198080; x=1716802880; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7uuugY85m3skoiVn07kJvXcB4zJBbm3CV5cNkHDjjBE=;
        b=HTAALj9+efTfiVzmYbMkRlMLyLzvEF1Ckarf6j7eeXg0tgSbybQP+IU4po5oWs5DKD
         rtxqZ337/Rhrpn8PJ84v/9AyW+rT9m49cjiHLVa7YAxG4OzsgsSlh/dm501BUpYoUD6G
         l29wnwAJLsyaRdFFNK2aUuA8m0+kmM7Y3oqoxeqkX1UInBkr6HTmdnInmPhQuoqoQ+9v
         qW5thgM8mYBhSgj81NCutFUU7WtZkM1jtWVvJHOJduwCSMsNpmS4O0tnuxBVr9l4QoNX
         gwvl1wMLKt7j74D5l9FntGiLyr11XGqfSq/q6T8mbavFqNgjyos6Rj/6L2N3+NDYBxyo
         Jozw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716198080; x=1716802880;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7uuugY85m3skoiVn07kJvXcB4zJBbm3CV5cNkHDjjBE=;
        b=PZBpZeLJ157wpSSEQoIvyfhEthDRC9QOVXmW5HJLDAsLVOAgTVn5iLZjEYMKEuwr6c
         JLhwcF4A3MB4HXHSpYRnLs9hHJPfCW+/Be2UejhAu9MGn+TtLdO4M1s3I9xS6w6HhMMi
         O3z3RGvmGhP5G04RM9sU24EV0YTWLie0nhX/9ABLNUjvtUQBY2Miv1yqs/bJJ16h2rhE
         OhXADfi86fN+W9BOelnN9ZbHhUCWKrtG1pwKZPTOly3vN9QLbEyfjQ7PymPu+5A8Dfzg
         lGiQsGi0asLME/2f2FkDmA11Z7/6dbnv17o2IO4eJSQhG1rOT6ZQw/L5d78brFgChxqV
         j+gg==
X-Forwarded-Encrypted: i=1; AJvYcCXQsBPmWJ0Mb5ZQcLZLnwGlCjvBTXkC/H6P/ZGLQ8th0wsvtWUJQNjEz3GhQ1zTr6nU1RuqreO6agUeqV4jHKdx3lXQ13hrFQ==
X-Gm-Message-State: AOJu0YzQiQM79y06dd7xbh96X3LoHokWwSh4y6czEOo8d8z5aJSb8zhD
	u4VpCQzPabjsDjzEyrI1/6Zh+tWSeAbgxmdrHMQbAiOl43Qvtpyei3c1q1SZRY2YlUaOfM/CNZ7
	YISTtSAkWn6/YeUzP7PqXucfIobj0KsvidzJ/
X-Google-Smtp-Source: AGHT+IHIRXk83gqTUdQImOJqZPIX0uv6AUm05mTPSzxJ+VjagPZfmFf9nOGa5CXpYjIsVt4/l7jOnVOm53CKwZsfOTU=
X-Received: by 2002:a05:6122:200d:b0:4d4:e92:1a71 with SMTP id
 71dfb90a1353d-4df8835c8d1mr26014914e0c.11.1716198079941; Mon, 20 May 2024
 02:41:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240519211235.589325-1-ojeda@kernel.org>
In-Reply-To: <20240519211235.589325-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Mon, 20 May 2024 11:41:07 +0200
Message-ID: <CAH5fLgjiKzmmwTrfiAx05tzFYVHDQUsiFmroMcWd3t=P+f6spQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] kbuild: rust: move `-Dwarnings` handling to `Makefile.extrawarn`
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	linux-kbuild@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, May 19, 2024 at 11:12=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> Following commit e88ca24319e4 ("kbuild: consolidate warning flags
> in scripts/Makefile.extrawarn"), move `-Dwarnings` handling into
> `Makefile.extrawarn` like C's `-Werror`.
>
> No functional change intended.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
