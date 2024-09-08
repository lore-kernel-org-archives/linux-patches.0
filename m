Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F065E76036
	for <patches@lists.linux.dev>; Sun,  8 Sep 2024 08:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725785425; cv=none; b=pI+uDdxbbBkC5T0tlyv8ZzVK9s1HJEyZPYSCYrPwNpyZ5wvOyaX+yiq+EiDRpzt2pQZOfT6XBdSTUmeYu+68xajIJLvBatGB/8+TAQFuVydy+t7DP2JN0EcDrb/a4y5Tq88432/jRh/wdlPEqXyda2uav0QEewLHLywPtsW8dMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725785425; c=relaxed/simple;
	bh=IratKjSErCgP4bqKJwZyOcaZOPuZPbvpYf28ITxn7vc=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=SLJ/nylz5k5Ncgzccq0oD0tuAxF1gDNUj203FHQIQThbiLwp14P7MCiC2FmRyva//4c38g4KFInYa7EkQnOcpDrLzd4p00+t46ZcH1/FRoz4505cRcEfUNri/HXlg5Kh8aDP1s4LcYPx0yUPWcySeIfGy11RcjbP3J+XfAUDoFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JSbvpVZ6; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JSbvpVZ6"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-374c84dcc90so1902066f8f.1
        for <patches@lists.linux.dev>; Sun, 08 Sep 2024 01:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725785422; x=1726390222; darn=lists.linux.dev;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IratKjSErCgP4bqKJwZyOcaZOPuZPbvpYf28ITxn7vc=;
        b=JSbvpVZ6p3RlH/97lwS6M59eyEdlAx9OeXpe/jle/LxFIoi6ULXRkFwUtY01Tv/+42
         cc6eVQ/DJ7UYxJnW0AzvpnE7TYbH55REdQSlCa7Rl62F/x8RsnTav4fYhtHZcYdxRAwN
         w6uZwrMa39+OpZ0mm3IKGVtLYwu4C4/StmfoL5M8YatgD6+mbtao7POJ3ZtERDj+P745
         KTsMzDu3Z3QHO7Zh8qmEKlLgMm86HCVgfwDOlp1fb2bmpB6bSMFNYussnET0F8yAcxlX
         362XKnhj2xewN9jPbAmVa5KZR+ByDhS3jeW9V0Y2ORQnf9OWoEzf0PzLBineEaOlXXSI
         mOJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725785422; x=1726390222;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=IratKjSErCgP4bqKJwZyOcaZOPuZPbvpYf28ITxn7vc=;
        b=tiZh3trnORUNamc3vsFhVhVqUa9hFF3mLNv1EFgGH2ZWrimwyp+VLCe6DMjvchI795
         uWpBY2oUhchzXxJ01M7Yu36BM88+IweVzyXmrUFn7gxPCFtBzoHz8wrUCwlDU+nqAS0n
         rv+7C+ftGHiycMVygDgsPqumK2EbSlALkJ6Hoakfk4TuhvAuLzU83k96UKTtv+jtczKu
         iT1wbYPtWBEKUL7amwGt/Ur9t03L1oiAdXLU7/rf4aXaUuRF0hXnsy+bQdzB2tKf5Z5d
         yfgtrpw50cvw9GwMJWeqlDD5ayTwqDVq6MTMdwf9uKobPRZF6/jcd+S1HgOz7rh+fZpM
         EAqA==
X-Forwarded-Encrypted: i=1; AJvYcCU/hwHt+xIMAW5CjuULJ/8KJGFpC1bIvrgU4W2eRNuWHUJJVIZar0+sGioUBCFc6J6Ua4h4uI6c@lists.linux.dev
X-Gm-Message-State: AOJu0Yyxf/eQ5eLROWtWC8uyypme5TgaWFRdGGnMTH/IMqOZDmfNsfRG
	gPkfT6ERupL5wqs++iSdaatqmnQuE/GJTZNqSrwZWYoPjuH0eu6T
X-Google-Smtp-Source: AGHT+IFoZ1XBFN1TqW6neFNuQh1nG58pN2f5+yQJ4beQhi8+I8oR/Q1Ywr2WGGB/Rkv/6yFCkfse/Q==
X-Received: by 2002:a05:6000:a91:b0:368:37e3:dff7 with SMTP id ffacd0b85a97d-3788960fe95mr5265498f8f.34.1725785421928;
        Sun, 08 Sep 2024 01:50:21 -0700 (PDT)
Received: from localhost ([194.127.167.96])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42caeb21b1bsm38396455e9.2.2024.09.08.01.50.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Sep 2024 01:50:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 08 Sep 2024 10:50:19 +0200
Message-Id: <D40RVGTQMNLV.1GL02UF7AWB5P@gmail.com>
From: "Vincenzo Palazzo" <vincenzopalazzodev@gmail.com>
To: "Miguel Ojeda" <ojeda@kernel.org>, "Alex Gaynor"
 <alex.gaynor@gmail.com>, "Wedson Almeida Filho" <wedsonaf@gmail.com>
Cc: "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Benno Lossin"
 <benno.lossin@proton.me>, "Andreas Hindborg" <a.hindborg@samsung.com>,
 "Alice Ryhl" <aliceryhl@google.com>, "Trevor Gross" <tmgross@umich.edu>,
 <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <patches@lists.linux.dev>
Subject: Re: [PATCH 19/19] rust: std_vendor: simplify `{ .. macro! .. }`
 with inner attributes
X-Mailer: aerc 0.15.2-211-g37d5fc691aff
References: <20240904204347.168520-1-ojeda@kernel.org>
 <20240904204347.168520-20-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-20-ojeda@kernel.org>

On Wed Sep 4, 2024 at 10:43 PM CEST, Miguel Ojeda wrote:
> It is cleaner to have a single inner attribute rather than needing
> several hidden lines to wrap the macro invocations.
>
> Thus simplify them.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---

Reviewed-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
