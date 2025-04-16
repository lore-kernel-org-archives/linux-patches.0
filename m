Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E59B2BAF4
	for <patches@lists.linux.dev>; Wed, 16 Apr 2025 22:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744840884; cv=none; b=WucJ3AQH5TpuWkXpCPafl+sNdLMo3O+OOIhHfd16NSDO7U/6Hb5CPHrb5q8DR/Q6xb6h/tdz5a1d4gFVj8QFqWNA+QfVQrCOInrxBWLZPaJG/P10BICAGQVvxawya4SGuRAfZri/h6H4SQn2WVOpjvRVE4e2+HRgbdZjDpbL+P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744840884; c=relaxed/simple;
	bh=L4MgRch3n9c1KufpkXn39X1HvR5hlyU7DSGSXUBqQSc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d1ym9853ex/kziCooMBzIAJGS9A4YS4SniQHMjVT5KLbJE6d4w7z15YjbU8seSpAzU/hoVit3fP/fRqbXmIfW1/9HCn0xmLcj+79r9or5Mmulb0+NEi2pw/1SLsn0WQKr/IMfn77kTspyxI/bfDPiIn79TuEgpAg2A1Ac5Lott0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IyAozVyP; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IyAozVyP"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-43cfecdd8b2so1018345e9.2
        for <patches@lists.linux.dev>; Wed, 16 Apr 2025 15:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744840878; x=1745445678; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/lV6+CInPTSw7XEpvqqKGuKnOwypfMwE2pBhOO9OjNU=;
        b=IyAozVyP4aiIy5oo50JF9Quo/8p4PtUjcNFJ9DQ8zFIMhXcCHC6YcI0Okgnf6xlWfC
         BtOm1sXFnY/tRwsmrJX5K0Kohq9Z5aJjXc1DJzjNdIkB0oMXByRbOZeuz97C8stLE2q3
         A5jn0wGhQN1eA8FFOqsUno1CBNGYUz9JzIksxXrR12M2xOJ5iDFTckOuA3r9IWLTjm9Q
         UzXDkTmjXEL3zmcV4C5P1JqUOGfvtUrKRtrkWolehGEJih/1u4F0K/R11iyrYOiLv5bU
         CVnnmq5G2QRVnRPDPj1GAoHuNkw8cwOkvcvtuRtTx55dyRhUB4Rv6MW+tZvT2ysCb4pG
         3i6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744840878; x=1745445678;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/lV6+CInPTSw7XEpvqqKGuKnOwypfMwE2pBhOO9OjNU=;
        b=WYC9UcamB19J+aqienx7IDWxcbY9sDlydy4W2+CkC08l9LcyM203pNwjaXq2GgYEhQ
         2dhqZ2QeiGK3BOjt2F6AQSdLPfKM92aPm5yTUDB2m7jLzVZp3NaKHygkUvGBADDbU0oH
         87k9wxp2+shpRPfFC3K3NB4sdpFR6sS8CKs+EKKbwKs34p4mHEJ/YOc66do8BbJ7J4cz
         QTCDmXjDtINp8JyZNQMHQvc97/4+Z4a/TcG6+M7zS1VJHl0yiZ3ZGcoY3Te1ADEqVnCM
         vod3zRO6Om+JKrtMJGhfp0YPctpuPWLG21pJW8vwRaBYprGOmns/MJhnXlFtCdm96ceN
         XYhw==
X-Forwarded-Encrypted: i=1; AJvYcCW0phKDmmn08iKwYISNwTuqBegYiCCgnVX9SgsrPLooaiGTMiNb6VXSQRzEidixd5CdPn2rwCr9@lists.linux.dev
X-Gm-Message-State: AOJu0Yy4aCJe76TqTL219XaEjbhtxcyev8f6YONBAT66fz7qSCpsZisS
	54Y5/9nIORRwPyOUVS8eHGUzgUQg2nhaWt+oPNZs0WE/qbOhn4Np
X-Gm-Gg: ASbGncsS47otTidJ28bS+SmR5n9TNqELkTLUqgHfuN+rHHUsUbqWJnScf1dQc2oRdAX
	snC/6Jra0IfKdL7rz+mj4Cn2CxPwneqRdRGB4vgP3vZhV2vj5CqbUSZeTcjF6z9vCOcODly/boW
	mPj45OMsWVgm/Av2xbqp/soiUW2BmqRJixqAmWKBs0MPtPRsyxWvi8cXA9/bQITG6Ns4bz8ACta
	HwKo2O+FwbsM7CiH7F6mjNc3a7oD6/Y8hbZpM3mqzCi2Q2f2roD8VflQf34YsvTnzKzGDIHLaL+
	SNgck3PKDCxF1dzANdlTzRuV3xpvm1MUgM/N6g8EEnuyD87D99R1nw==
X-Google-Smtp-Source: AGHT+IHDB5igOdf8D7I91/XLgiiql7EqukCBRn3xTUw2ip02ijIJoY5OBJ2FUuERlwy+bQ6MNRxlLw==
X-Received: by 2002:a05:600c:8519:b0:43d:9f2:6274 with SMTP id 5b1f17b1804b1-4405d624d6bmr38577325e9.14.1744840878257;
        Wed, 16 Apr 2025 15:01:18 -0700 (PDT)
Received: from ?IPV6:2001:871:22a:99c5::1ad1? ([2001:871:22a:99c5::1ad1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4405b4d3453sm32129515e9.16.2025.04.16.15.01.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Apr 2025 15:01:17 -0700 (PDT)
Message-ID: <e18be147-faa4-4ec6-b52b-4ff7d2119a27@gmail.com>
Date: Thu, 17 Apr 2025 00:01:16 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs: rust: explain that `///` vs. `//` applies to
 private items too
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Jonathan Corbet <corbet@lwn.net>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>,
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 rust-for-linux@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 Viresh Kumar <viresh.kumar@linaro.org>
References: <20250416112454.2503872-1-ojeda@kernel.org>
Content-Language: en-US, de-DE
From: Christian Schrefl <chrisi.schrefl@gmail.com>
In-Reply-To: <20250416112454.2503872-1-ojeda@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 16.04.25 1:24 PM, Miguel Ojeda wrote:
> Sometimes kernel developers use `//` for documenting private items,
> since those do not get rendered at the moment.
> 
> That is reasonable, but the intention behind `///` (and `//!`) vs. `//`
> is to convey the distinction between documentation and other kinds of
> comments, such as implementation details or TODOs.
> 
> It also increases consistency with the public items and thus e.g. allows
> to change visibility of an item with less changed involved.
> 
> It is not just useful for human readers, but also tooling. For instance,
> we may want to eventually generate documentation for private items
> (perhaps as a toggle in the HTML UI). On top of that, `rustdoc` lints
> as usual for those, too, so we may want to do it even if we do not use
> the result.
> 
> Thus document this explicitly.
> 
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Link: https://lore.kernel.org/rust-for-linux/CANiq72n_C7exSOMe5yf-7jKKnhSCv+a9QcD=OE2B_Q2UFBL3Xg@mail.gmail.com/
> Link: https://github.com/Rust-for-Linux/linux/issues/1157
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
Reviewed-by: Christian Schrefl <chrisi.schrefl@gmail.com>
