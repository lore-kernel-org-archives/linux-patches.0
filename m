Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5E74D8CB
	for <patches@lists.linux.dev>; Sun,  8 Sep 2024 07:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725781147; cv=none; b=sXTMHIUhfgjMVT8BweJXgb3Pr/CkMtAHxc9zP2AeuoCNq7cz1DtMdVL/t06K3dbZ9wrKECphpSQ/IJ8c792Nc6TtzX8VCZNv5pGb8zMqqiI+Y/zVmMSNYjLlOeh+blJdUKogkzwyW9C+y7AbjoizzZrzU+XKh3RPjQh6Nf7NXpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725781147; c=relaxed/simple;
	bh=64I7vfErZOzod4k7qSFK2tbeV/wuaOMW25Nmg9N5vL8=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=KxxYiPFK9IEH4qemq6A59Sats3v33D19cXSj/kG4h0QOIRJglhYh/dfXWCtbZ/0NwhSgHbJpVWrSfzH5Z7tzAZNSX8I7sf/NSk4Dr72mCAIt4WV0UGe3hqMm4rzcjX/tmNuSAfxsQFtDh2oZk1I+mrYDWtkoFez5oBP77F/YSL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bb8e1dgd; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bb8e1dgd"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5365cc68efaso1323372e87.1
        for <patches@lists.linux.dev>; Sun, 08 Sep 2024 00:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725781144; x=1726385944; darn=lists.linux.dev;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=64I7vfErZOzod4k7qSFK2tbeV/wuaOMW25Nmg9N5vL8=;
        b=Bb8e1dgdQpVfD6oBJOOZDsy7JHuX6676f40qQDOO7MrNBFPt9CS+PP11+bEsJr2whK
         H0rKhzhBm6L2dTuBbGp/TWq7xtMwPeLoK87jlLxjqhAawko+LVE/sUjVERy+clsLe915
         4dzO6RM1yXfmW7uASJpOLgDRVCMFK3IWRZqmj+XBiG7oHYlRdUrgq6MWF2INnJpb+tfj
         sdQpfWJtStioBgxDvvbvrfG1VzF4DT9OL2EThmeNeaI1Mi+dWcRq1pjCyuNMH4GahIH9
         eTooGnE6sB4yKiHbQgAUORoRRLgDMwB3SGJhzWiPX30NPl3X0ALyyOHT3VYyHS8WbYoQ
         rbBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725781144; x=1726385944;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=64I7vfErZOzod4k7qSFK2tbeV/wuaOMW25Nmg9N5vL8=;
        b=hW3W0JcFBCBihoXhHgAT4wEP0sWyqyDA3eDE2cM7qnadcloNU2ZRpFuSr3e7bZqrHv
         hXkBOeVRTQz1oPbogMYk4l6ukwQSwYRean/EPgW9/GpKafkNZv5XOoUL0p984nJ7wfYA
         ujYf7mn1dYjVjrOgPrcX2WlMhtXiIWijSRHIiprmexBENfmWQGzUxNXtzA5gSOpLTA4c
         WBlCNFFJSyJseBl9sWV9vQWAb02aYTaSYB+eP1Fs8g9hq+KCYNaxLFyHBi3e2f40FkRU
         r+ZQhuc7IipFX4VAKD1hp9CNhhbPF+zmSy8l4+RkcbTOiNklnDVhesw3M1ou+01ZylmS
         WigQ==
X-Forwarded-Encrypted: i=1; AJvYcCVLfakDLQ23VW6HpmrvXB5VKi4qwBgdLK070ARiXD9qdE4CExCCNshkzsaBvkKIw3jF3LVdcQKB@lists.linux.dev
X-Gm-Message-State: AOJu0YzatC3PpjVGAMnFQU+CrzOva2Wj0EZvnwdIcCXmSoTPWnoNB17g
	+bgyEIM6znlYm0mNazbVqDBqVYnNL3ooug+VNyPxf1KBVACeserd
X-Google-Smtp-Source: AGHT+IGYbQ/tZ9A7jEdogRo13GnwZSRpklkA0CVbhjhsug/z070+DfvvvS9FBenqCOz9K4c+wdO3vA==
X-Received: by 2002:a05:6512:2313:b0:533:40dc:8248 with SMTP id 2adb3069b0e04-536587a5453mr5317598e87.11.1725781143815;
        Sun, 08 Sep 2024 00:39:03 -0700 (PDT)
Received: from localhost ([194.127.167.96])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5365f9139e4sm352736e87.302.2024.09.08.00.39.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Sep 2024 00:39:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 08 Sep 2024 09:38:59 +0200
Message-Id: <D40QCUK9BVHC.8W0E99JLSXX3@gmail.com>
From: "Vincenzo Palazzo" <vincenzopalazzodev@gmail.com>
To: "Miguel Ojeda" <ojeda@kernel.org>, "Alex Gaynor"
 <alex.gaynor@gmail.com>, "Wedson Almeida Filho" <wedsonaf@gmail.com>
Cc: "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Benno Lossin"
 <benno.lossin@proton.me>, "Andreas Hindborg" <a.hindborg@samsung.com>,
 "Alice Ryhl" <aliceryhl@google.com>, "Trevor Gross" <tmgross@umich.edu>,
 <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <patches@lists.linux.dev>
Subject: Re: [PATCH 05/19] rust: enable `clippy::unnecessary_safety_comment`
 lint
X-Mailer: aerc 0.15.2-211-g37d5fc691aff
References: <20240904204347.168520-1-ojeda@kernel.org>
 <20240904204347.168520-6-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-6-ojeda@kernel.org>

> In Rust 1.67.0, Clippy added the `unnecessary_safety_comment` lint [1],
> which is the "inverse" of `undocumented_unsafe_blocks`: it finds places
> where safe code has a `// SAFETY` comment attached.
>
> The lint currently finds 3 places where we had such mistakes, thus it
> seems already quite useful.
>
> Thus clean those and enable it.
>
> Link: https://rust-lang.github.io/rust-clippy/master/index.html#/unnecess=
ary_safety_comment [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---

Reviewed-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
