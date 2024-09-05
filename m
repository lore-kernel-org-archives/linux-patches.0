Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300F013AA2B
	for <patches@lists.linux.dev>; Thu,  5 Sep 2024 08:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725524372; cv=none; b=JB3hIbet/ILc9aCPV8WaIvwjWGt2yvh0bv5dFwhUNDqik/fyFAtFn29AEaP6jAxm2aOYogj+fFcGu45fNCjfTP2FDZAxNU7fkpv5ve4MfvZcjAbfRfVYdSlNeF/zlC0facBJWGC0O5sn5EaDt/4YWlaKTE2b0wV3/6P1gev5gsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725524372; c=relaxed/simple;
	bh=+BWzxJkQFe8ihuC1pXeT6ySQPYwRlKg+/UwNcRKMcxU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DdqRdHLnFdpKlTkuyojjwEqlgFiH8KISSo2qSd8603s3i6LIMvrqPqkcgceaJNwtA4dIvkAgi2uolNfY07Qadgg2eU8VKyHQ4V0r7dET6pyT1VxA2UD7YE4xx9hCWgfAwGv1ZQIsvmSa5un/eVLac5+yQtndpRxCwc2XkhM+GgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ibB1QwTj; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ibB1QwTj"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-374c5bab490so1008971f8f.1
        for <patches@lists.linux.dev>; Thu, 05 Sep 2024 01:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725524369; x=1726129169; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+BWzxJkQFe8ihuC1pXeT6ySQPYwRlKg+/UwNcRKMcxU=;
        b=ibB1QwTjy5OcqNjORBgwVBPs/fnCqpfKtd1YoUo7kYdBOo+Ea4hKQ47TI7TMThCro0
         WlDviGKg4wDkcClfoiroq6GTMOD2RHGqw7G41HgTzTr3pCPQrSAZ3sPVsxNFw4ZBwgHM
         00BhvFsdj+lJBlW8bpe7Ls/61ZGTCl5jqZRno2zuRfW3ReeVvgukJydWWuP05PW2j7sS
         N9SHussM7dsErBXk6Na5LDxDIf3H4oCRPovdoX5QPhnKVLjXpDj1vCHvNbZ9Zj6MgcrX
         cUfnBO1Pue147IdMiD9uaumISO9HX9KbZHv/u+zFBJc9CAwb7Rz/wx2G1VmYkZg5q0Eo
         nvyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725524369; x=1726129169;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+BWzxJkQFe8ihuC1pXeT6ySQPYwRlKg+/UwNcRKMcxU=;
        b=UPNVPLyxMA35gYqpJqgPSyVP4btcGIhvFVG6mzCTnqpcL7sKyYqpHPYstOiBo+dDtm
         0aU57zgaEsDfLo6GbtDpCcG+8QoUE9bDKnC0XdDjeCgZXtP3lzTBk0rVI9RXcP95OeTu
         0alJzB8Zu/u4ahndN+bv7CnENtSGfsKEK5jI/4NeEVyAKSvhLKcChBEg0BeZ8J/b3Zpe
         QFWR2nTicUifYemiX5sHRoVY2dOhWs+M9uPIaMmFL2VW6YIXjeL3zrnIhaEpx60ELYq4
         qv3iCfeEER7jrUFSumPH53SXm56aNrFDqG8c2XFyBWKhpTuocTxhMHZzN18BCJEkP/d3
         r6Qg==
X-Forwarded-Encrypted: i=1; AJvYcCUK94o6cDjiHWPX5zvQmVCzbtjV0sfbxcjbDqmPNDozBqO5XLfrohPViv77eqrTtCDMFJYQlh/W@lists.linux.dev
X-Gm-Message-State: AOJu0YymgAEInOXVY08APTbjgcjBtAbhiegvo1bLkCyjqRNrrF+OONLX
	B3wVeJZbyptF40tIBnWLdZ0C+tXGBB+ua7AoeGqISDfQa056xBnQcv3TwxQcM7Qp5ekwiR511rM
	ebyjfQ90yjEcgR8iWn3y1+85V7Hi+rhP+lcw1
X-Google-Smtp-Source: AGHT+IFNtCG98xrOuozxty2PtnqpYGo4wzWpPlBR8g6UOkhcb7n2BIa3h2BXieak9ydWu3vH4GF9VvFlUfjcTo8Ol5I=
X-Received: by 2002:a05:6000:1a47:b0:374:cb8e:4b43 with SMTP id
 ffacd0b85a97d-3779b37c460mr2850625f8f.32.1725524369228; Thu, 05 Sep 2024
 01:19:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904204347.168520-1-ojeda@kernel.org> <20240904204347.168520-20-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-20-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Thu, 5 Sep 2024 10:19:17 +0200
Message-ID: <CAH5fLgjfxSOmnPsk_673qNdnpVoj1W11LD+qgKqBG8J7sm-u3g@mail.gmail.com>
Subject: Re: [PATCH 19/19] rust: std_vendor: simplify `{ .. macro! .. }` with
 inner attributes
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
> It is cleaner to have a single inner attribute rather than needing
> several hidden lines to wrap the macro invocations.
>
> Thus simplify them.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Are we ok with changing std_vendor?

Alice
