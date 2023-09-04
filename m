Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C569A10EA
	for <patches@lists.linux.dev>; Mon,  4 Sep 2023 07:48:42 +0000 (UTC)
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2bd0d19a304so17946861fa.1
        for <patches@lists.linux.dev>; Mon, 04 Sep 2023 00:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaspace-dk.20230601.gappssmtp.com; s=20230601; t=1693813720; x=1694418520; darn=lists.linux.dev;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=rYrT/OBD2Zjx+XkX7u24UqYymx1MH3uTPX/Eopb7uUY=;
        b=TrUZ6s6FZORmttA+nYLwwVgL7rnFmQN3XaD0cRbbAfr+SMoD7nV+RGnIra9WXVmcDM
         aFojiy/Ipiq7IGg4tCDSc7sL5+bCLN7Ligw2YS0js95RiSP4YOB6ei1BNvr2+pCU8lTe
         rA4aMs8mMMSiz5vnF/NnW1sejRgwVUYyc8pWSUYuubeRdldMFGF3nGyyqiHTQzb1Wccg
         rk0+QdNYJ8Tz0Ek+6RAPQg1qZuOJSxYVhQcp96vm/lr0bEplsVjvgI5ULL8vxs4ZATqN
         QNmEwrnbqVw8JL81B2KkE2Xu7lfK19ulfOMk8ig+x6ImciT7M0fSTQcQALaGypmPrFTM
         CAtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693813720; x=1694418520;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rYrT/OBD2Zjx+XkX7u24UqYymx1MH3uTPX/Eopb7uUY=;
        b=kk8NbIGAoH77Oskvz/4TlY0C4lMVIVSt3SrjOTmQJKeh8l9xl6IITibFfhf9Dbo4nq
         zh0bHhFSIFXytfDZjInu6kfn6TAY87wLUzFCh0g+6wCIYW+xW/+1zhhfOJcZxdmcxdai
         JC7CLC/ZWX0tiYg6zILO3TTPCHuvzkTDAPLeg4/zZwWJZBRBxM5NJOxh0OJNW1/tyTQA
         NSpXdTorY77x3W8jxL/6ZfGYkOTOs2TotH2sa8XhbeMKAuWXnE/nd6FpMsKPJ1kSU3N2
         cQTnzulI7UXRdGlxLg+P+D5bp6pgfOm4qaE1Xz1RYBNhekFMWpqkARH+2yGYdOX0slri
         tpow==
X-Gm-Message-State: AOJu0YwzR7C4hpGUDWRAkgmiWsNlxS0wt/96Z9jg2ZNKlRmVJCWTwwAV
	3PQuuq89DDbbxRwrqkhUuTYi1g==
X-Google-Smtp-Source: AGHT+IHIoedgWTzQVLwkmmr1H6x7PvoQzeRB9iDwXkD31dT6UvjTDDGRznVwz5aXCithFb0S9liFBQ==
X-Received: by 2002:a2e:8898:0:b0:2bc:c11c:4471 with SMTP id k24-20020a2e8898000000b002bcc11c4471mr6624856lji.21.1693813720447;
        Mon, 04 Sep 2023 00:48:40 -0700 (PDT)
Received: from localhost ([165.225.194.194])
        by smtp.gmail.com with ESMTPSA id u7-20020a05600c210700b003fe4ca8decdsm16341300wml.31.2023.09.04.00.48.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Sep 2023 00:48:40 -0700 (PDT)
References: <20230830165949.127475-1-ojeda@kernel.org>
 <20230830165949.127475-2-ojeda@kernel.org>
User-agent: mu4e 1.10.5; emacs 28.2.50
From: "Andreas Hindborg (Samsung)" <nmi@metaspace.dk>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor
 <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo
 <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno
 Lossin <benno.lossin@proton.me>, Alice Ryhl <aliceryhl@google.com>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
Subject: Re: [PATCH 2/2] MAINTAINERS: add Maintainer Entry Profile field for
 Rust
Date: Mon, 04 Sep 2023 09:48:21 +0200
In-reply-to: <20230830165949.127475-2-ojeda@kernel.org>
Message-ID: <87ledmtm3s.fsf@metaspace.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


Miguel Ojeda <ojeda@kernel.org> writes:

> The `P:` field allows a URI, and we have been adding information
> on how to contribute to the Rust subsystem to our webpage for a
> while now (and other relevant topics, e.g. branches, third-party
> crates, Rust unstable features...).
>
> The webpage/document does not currently follow the headings of
> the Maintainer Entry Profile, but it does nevertheless answer
> some of the questions we have got so far from contributors and
> it covers partially some of the topics there.
>
> Thus link to our "Contributing" document [1].
>
> Link: https://rust-for-linux.com/contributing [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---

Reviewed-by: Andreas Hindborg <a.hindborg@samsung.com>

