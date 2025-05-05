Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F07E04A1D
	for <patches@lists.linux.dev>; Mon,  5 May 2025 17:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746464850; cv=none; b=gBetVIClNHUjXPXhWdkSJY+VUTo8/fB6c1IO1iv+BYAnWtsPkZxWwYD4mAT1T3Y0mmcmNlBNqq2f0EuAO3v35+d1xl2zt9YALQLVu85SnmawraGAwCOBEHzI/tyDMPMOI0CPRec1dTSTZuQe7mK0bCoPnMWXH502ljh/H3LTJ7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746464850; c=relaxed/simple;
	bh=Wgko8I/m9BqxxB27PfRkqwDAClmx9QE/pUan8G37ook=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R4UyzfZTA6D9OJsizT/Euyf9V1WCwHcktj4fW9d/mDYSeIMgB1nu2SFrpQkcio5KGHPQGwb5XOQpzeAftcxySSmI9DcyQJkUXSbLRx1L1kWB8L0OXVqFhDFyfagfS57x3x1hc2U6iuq3tdXT/6AXSqiggB1WZqaSSTZIOny5M8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ra63QXzE; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ra63QXzE"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-22c50beb0d5so7605985ad.3
        for <patches@lists.linux.dev>; Mon, 05 May 2025 10:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746464848; x=1747069648; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wgko8I/m9BqxxB27PfRkqwDAClmx9QE/pUan8G37ook=;
        b=Ra63QXzEdmoMXTdXIsOv5Q/apYg1C/vw2uXUVLh4Y9KZoX1jOu8XaYsIZTbiYH88Pq
         zaf+tIpHnxPBDKSNfnoKmmpve8yKhAzjg1TWSLQGoAcYv2B++SuETcfhLWbwAEvvrRFm
         9FMV19SeMsRKARehRsYsJTVG0ch4y4wmCPYU51MAzn9G8Nr+gh2JZHabs3VCSKSRivrx
         CrAdxvWGPGZJMDNqgv1Ge/CTpxaks26mT8iSAw6k8hK8IAMg6tTguTndP8lYNGQeOpNA
         eGeuy5dyFiHQJm4EEQqsZPCXVtr84oil9OOfHmgOVtb5Pm+iMa9ozyFxvJXdezXdLH5r
         FEIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746464848; x=1747069648;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wgko8I/m9BqxxB27PfRkqwDAClmx9QE/pUan8G37ook=;
        b=FMoARRPB1GxqiqdZyLuKeIMjYjzvBvk7LyhVe9SFi6ucoEydfddickez39+DCcxpa3
         jENI1hNwJNFi4ngzn03+zH2HDEDvsLNuyURQgmH+N07NeyNUw5Fag/FZQq8LPnFNUGRG
         Im76ylxqg3OA0n2GLXQ0tVB8+qi5AbAkx9RbmrP/tRnuIY45IGc0yNk8S/TneXHtiFbY
         oft4QkZl0KF5DP1wU80xaxzxUVeSAj0c3AKRtsAQC0P7T4iZbLXeZXGVcA1WfueYDbHN
         QMzw+FJv+Yj1YdUb4Trwi+/JZB9FCcBDCC1EGtBfrUiYzfeVsVMcYgJcOZGMHMStMDX7
         kwkQ==
X-Forwarded-Encrypted: i=1; AJvYcCW42V9/PuREfKApxT7OUOaWS7cM3qkuemcMNSiW+z4Fo/FBIeiLSKwOPNSPao/pybEW0qFWPInt@lists.linux.dev
X-Gm-Message-State: AOJu0YwguZ4f463xFA9oxLjqOkH5cFeGgbwQFFSUAXmyVvAMKUewy5sf
	k1KEuY+oEItpLAko1C0Sx18U+I5awSJJ3oTU85qRF4Xc/ZstG8UFL/nT6cXB3f08nqOfQjSYf7f
	kRxnypLEReLa9ke5r8vMNE3V7mMw=
X-Gm-Gg: ASbGncsWrfhi8EIU6pzojVVluOKvkTd1llFG7FDOJjKgB8WukNFdtlB5X6KFigFmLst
	Z0ShaEYx+NVuPh9ll0Y0UTxQEe3yeKFcDi+TsYQiLc0CKaTM181gyH7I/Q+9jCGnnpylDzl3YqB
	B81qNQxTZE392CoTN1yDld+Q==
X-Google-Smtp-Source: AGHT+IFLxWjul1SJF7ZqOgOBbbo9BHWzWJnRRxBf0NBIcb0vX721AMZ+hB1vr+RFDd/SU5sNyV4H1Xw17bDGwqpnmp4=
X-Received: by 2002:a17:903:1905:b0:224:10a2:cad1 with SMTP id
 d9443c01a7336-22e10373938mr79787315ad.10.1746464848170; Mon, 05 May 2025
 10:07:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250502215133.1923676-1-ojeda@kernel.org> <aBjuCIHH1ZCIVs_0@polis>
In-Reply-To: <aBjuCIHH1ZCIVs_0@polis>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 5 May 2025 19:07:16 +0200
X-Gm-Features: ATxdqUGrqf4jwWLSpQZ_Dz46MOZsF8WvrNskaiy2DPAE2SfbmleZGwbWqKSwNaw
Message-ID: <CANiq72mKKh437k7HQBuyr+oBqAZ23Z=VKgo42TnQjD2s-VoF7Q@mail.gmail.com>
Subject: Re: [PATCH 0/7] Rust KUnit `#[test]` support improvements
To: Danilo Krummrich <dakr@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Brendan Higgins <brendan.higgins@linux.dev>, 
	David Gow <davidgow@google.com>, Alex Gaynor <alex.gaynor@gmail.com>, Rae Moar <rmoar@google.com>, 
	linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 5, 2025 at 6:57=E2=80=AFPM Danilo Krummrich <dakr@kernel.org> w=
rote:
>
> With that, do we still expose `alloc` primitives to userspace tests?

I considered removing a bunch of stuff (even the build support for
non-`macros` `rusttest`, to be honest) -- you are referring to the
`any(test, testlib)` bits, right?

I think we can wait to see if we need it, or we can also just remove
it and re-introduce later if needed.

Thanks for taking a look!

Cheers,
Miguel
