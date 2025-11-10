Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39DAA30506A
	for <patches@lists.linux.dev>; Mon, 10 Nov 2025 14:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762786643; cv=none; b=VV7/i0R3ta8xXwvoddp8JW4zkgpuR3KLKPAwR4aco6Mv0VJP6UtQaQsGKu/1RcnM+DAZc9+kF+UlElkO9J/Dg2yLvvWZic1vJXcVdU/SEZMv1hNu8qzCdcGwv54NJbuSzcYXrWUgASEUPkeaXWej035rJo5vO+0fLXTA7ta68eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762786643; c=relaxed/simple;
	bh=XrYjurcXwMFuI1n6vQ4mS/+j3z0zFW9n2Q2HRAorD/k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=E0XSaXzHdnKwnhZhni8Yv/LC33Ie/SRAbFN3C6lq/s5qegLgpLtziEASzQ8L40yhZytGl7s01yW1qvEcLoGOGNj1SjajMtI2s9/i7bN3QHT5J7lAsKB2vhGwzki4aidmAal8Yl78d9paPJuCIJRanVgkakeiwJDBAkgVVrYhh/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n+1WbeV6; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n+1WbeV6"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b72ad85ee9aso356763366b.3
        for <patches@lists.linux.dev>; Mon, 10 Nov 2025 06:57:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762786639; x=1763391439; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XrYjurcXwMFuI1n6vQ4mS/+j3z0zFW9n2Q2HRAorD/k=;
        b=n+1WbeV6D5YOKCqUFgss5UbnCAZWSzOQxgqxZbAm/yWhSxCh5t4YRZZm97zxZb6sKp
         IBJJH3H+ayBKj2a/4hfTWBxbDG3ZAOeYE8QX/J1hZH4VIfAit5xX3jaPCNmofXCIyx0G
         /07u7iOymMeYisleF4j4/6UqWPalYMU2vTMb4zrcZX4MM3+BPOzaFpiCbpZGe41d4sRm
         B1Kw1/Bm2jzcYuWwcaZbbJdpgOOWLAnTWAtLvIQAir/GLcf4cErS6qd8KmlrS9aKupFu
         FY3PR6O2jXN8SFfJPzARxteFpt8DFLS0+S5qq/bFH0Fs0QGYPLC1OrcTHPX/wxngD8kY
         NNjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762786639; x=1763391439;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XrYjurcXwMFuI1n6vQ4mS/+j3z0zFW9n2Q2HRAorD/k=;
        b=GTl9ZWhYi75H7oNAFUHHIZeN5WQlp7Mhn/y1SOIdaJ0v8/T1jlagmdiv2jrW7mIdvD
         Fd21Qmvxe9a+kmPrEbSnupuh4xwXYzemvj/3LdWOF6wvI4AEqjlHJK7JEXNEIlGAk4Ar
         +jSMILOs3SWdpkLNKgAv5Xrf3ZR+qHadiqfUHHVtBGpMpzlbRViJHgiv1dPcMM28LApj
         sTi5M0i7UqcaEzr+E99/RHehRg1NcdnNo8ioeja86KBazX03YoIMbTuR1QDYvw5B6Wii
         SGKZl3TtbsgmTx69HO5QdsYSE1fXXAA69/ZFLBq0kPesWn9IyuIFy9rEJzjdtVl048pX
         gaOQ==
X-Forwarded-Encrypted: i=1; AJvYcCUYKDP+fAmJwaqDdD8BtFToBGFiybQOv8DVkPbdNwnjMXMv/XJbNz43W7SDyNL15coVvkwqEDdh@lists.linux.dev
X-Gm-Message-State: AOJu0YzwU4Nn7PqDC56ObfxOcHmfrmtcvAKWc+gu2MEKqUQTExHVpx3x
	creJoIWS6RPtBQ7obzWGsn9lJ+5GerbqfmAlC2UGirMFn/aqx+vAq4HTRzooDhVPEuqVcsEmQUS
	RtSatB65NJ8wLLG7QwQ==
X-Google-Smtp-Source: AGHT+IGOnlG8lE2H2BKECccs5w83Ie0qMvDDSxYqNCeNyk/4OUCiSM9N6qmdcMFCMYYfeMybQOzcZG1uqwa4NcY=
X-Received: from ejcvb9.prod.google.com ([2002:a17:907:d049:b0:b72:b433:246a])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:1c85:b0:b3b:4e6:46e6 with SMTP id a640c23a62f3a-b72e02ca1d9mr839517866b.1.1762786639240;
 Mon, 10 Nov 2025 06:57:19 -0800 (PST)
Date: Mon, 10 Nov 2025 14:57:18 +0000
In-Reply-To: <20251110131913.1789896-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251110131913.1789896-1-ojeda@kernel.org>
Message-ID: <aRH9Tjf0tszyQhKX@google.com>
Subject: Re: [PATCH v2] gendwarfksyms: Skip files with no exports
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	linux-modules@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org, 
	Haiyue Wang <haiyuewa@163.com>
Content-Type: text/plain; charset="utf-8"

On Mon, Nov 10, 2025 at 02:19:13PM +0100, Miguel Ojeda wrote:
> Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned in older LTSs).

Is gendwarfksyms actually present in 6.12 upstream? I know we have it in
Android's 6.12 branch, but I thought we backported for Android only.

Alice
