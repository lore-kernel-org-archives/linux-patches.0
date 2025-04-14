Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7CE17A58F
	for <patches@lists.linux.dev>; Mon, 14 Apr 2025 15:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744643322; cv=none; b=d6aWqYaSg5W8qWvcEjCkRo3cj6ugavdm1sm3j2TTpbGiGbkoJRlDyR7KdvYETL9EIXeLbtC3eqvBRHH4u9Q2shfhV9WFO/oZEQ0+78pTNoWcN1FwhrgN+yS8GAs+yuHUEFMhYRTyn4L9QxclrEo/74X0QZIWY1h79QzF+T8I/xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744643322; c=relaxed/simple;
	bh=DK4Qu0qldN+pzv3ZrtGi5/PL9yAuBfEn1jbExHHQuoI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=plbL/oweM9JFFqm8WsbTxaDJOyipkM9CBSQE5bPjhAMNpBCvw+F02C3buNSyFkNMtvkWYNuTPLgB1g33PElBK2WnAse9uXI11/iBFV3egqZBy5Zq5hz6pwU0HE4a5TKWWtQ1mJ/u+HpUPLaBYFo8oABJTmOVNb5PRnBLOKPXSTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lb+sTH4P; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lb+sTH4P"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b07698318ebso117772a12.2
        for <patches@lists.linux.dev>; Mon, 14 Apr 2025 08:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744643320; x=1745248120; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DK4Qu0qldN+pzv3ZrtGi5/PL9yAuBfEn1jbExHHQuoI=;
        b=lb+sTH4PAq3nOOAFj/rahSOryJTwezj2dZ9hvgrGUA5SrHCSWUGLBlC1ebxJHYXZAL
         /wZA/LEzQJeJ/KzF1N2PLkcF7KZJs90n95CSfiOKFiVzO+L290x6j0+nl3BoLbjKAGk9
         aU49kThPNOT3OPNIi9CHKKRrQXLEOLckKvPIVKbFrZ3Ot7lS9FLL6QIiPbe3rEwzcPdS
         8avYlY0/oYLtxbQhQhR8RudDoutoHqK69yvYCexJNVCYHEKGZnOHZNrvX/2rVTZTvlDW
         acAjEDrTAg2YGTnPlOAGBP6RKZXPaj8JwHH8v/DeRF7ohYuVoNZ7tBINfA0EV/z/2KTj
         wnsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744643320; x=1745248120;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DK4Qu0qldN+pzv3ZrtGi5/PL9yAuBfEn1jbExHHQuoI=;
        b=ETKWLj4NfUyGTF3pCLtoBofWEoFK3wfVa5cakuEAfhMOcoXR9fxPuy+XmaqQFvIN3s
         QQxPfUGpXDGPLax4IIRpK/ihilKb6kDaseaKJXQ6Po1BwTPGsUtQ+dLQx3olozm/ew6u
         Ld3tLbncDSA4JowWMapqMFZQqgen5DRnjzeHzv21WgZ5C1KnCJYY9Cx9aIVnCwXJ+BWS
         8d3zztKgceFbopRTC/vACF4Xdfsrz9+NW0rutRQjxbNfWFkY/NCoC8Vtwrf4zburw2Xx
         kUF12QQ7DnBQleO2xe9MBDFGlpNGPMo2ncVvNlJR5+I3yMeUhJ4WBrkRpECa77R4/Mhj
         HPhw==
X-Forwarded-Encrypted: i=1; AJvYcCXAaKoxbiuI+Ok3Koxmim5RuH9TgyGz0W34sLGXNI6NU1Zo784utGsGMCcmY2IhAM6BiHA5Gddb@lists.linux.dev
X-Gm-Message-State: AOJu0YyQ4STPoTzgCRoY8P4V/n9rpfw1BRABG76+32He5cu83zY8CYul
	AecL+4xWx1+viE4P+lqxr7mscqogdnZThrw+6L1KL4b3LRq1sqAnLy8T9TuwNiKX5Kybxbeb2EP
	Vbt+gBGIbxCDFC0VF+jMBku2EL+M=
X-Gm-Gg: ASbGncu4WYFUd+ZpSUml2pJnURHEsh7S5fiOACD/BKIgn7kTqlm+21Pwc+QYe/BJQuU
	vrCheOK1/F0Waw1GvA/ViJphL0kjujJUJy28U/g2RAIIaXXkWTO6hXRrLVSkBUhulzAa/Yzk4PS
	WLxg78Q03MgqBnZTGb+0NayQ==
X-Google-Smtp-Source: AGHT+IF/3Sug4cH71Iy1yUd34jEFWmX1uxiWoMXWWYEYLAEU8PckJu1uG0PfMyeFYO7FJKOwZzJ7L3pUGCudlaYn1Cw=
X-Received: by 2002:a17:90b:384b:b0:306:b6ae:4d7a with SMTP id
 98e67ed59e1d1-3084e75753emr84387a91.3.1744643319470; Mon, 14 Apr 2025
 08:08:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250413002338.1741593-1-ojeda@kernel.org>
In-Reply-To: <20250413002338.1741593-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 14 Apr 2025 17:08:27 +0200
X-Gm-Features: ATxdqUH6rGk6r6-lQ_KWE9TQvnHIiYAFIJPEWNi0sSuE_uUs1uqjOst-DwFVQ_g
Message-ID: <CANiq72=W_JOV+WLWFpkqt=cbqOiOKkxbsa4wvyuW82O80srMoQ@mail.gmail.com>
Subject: Re: [PATCH] objtool/rust: add one more `noreturn` Rust function
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 13, 2025 at 2:26=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Thus add it to the list so that `objtool` knows it is actually `noreturn`=
.

Applied to `rust-fixes` -- thanks everyone! I applied it early to
start to get testing -- tags still welcomed for a day or so.

I changed the title a bit (adding "for Rust 1.86.0") to avoid
confusion with a previous patch (and future ones), since a bot already
got confused.

If `objtool` prefers to apply this instead, please let me know and I
will drop it!

Cheers,
Miguel
