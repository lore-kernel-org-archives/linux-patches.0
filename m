Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45F6218AA8
	for <patches@lists.linux.dev>; Sun,  9 Mar 2025 19:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741549866; cv=none; b=VGVKniQzIQ5qlKJRrO/cTxrwoOBxwqDh9aRHiv9PnanXF6BW9GvRDMZ0ud8h6QL0W+GjR+Zlkqu3Gs8EqcnzIWhZNkfRbUfQSVCo7GWDd7DWBABAGD2hivvX78NUeUY+gHkN++Km/viJVcmMgd8dt/h5pbzk0FLoTnoqMgrK+RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741549866; c=relaxed/simple;
	bh=dzyVokZIpDqiotKHrpU8Dw2U/v6X92xZQXOd24xBzNU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CRxETNpOKuwPdTN0lcUqiWF2g2K2Zu43GLILEy9rGs7ZCMbInJtzKp0wPHRWdzEijZi3lyTKEi4CWKXmdSWh+fQDGNDrpZSsHYozi9DUxwx9VOGN3GeDtg7HclH3y/k/cdiqB83kArf5zhn5CVO6ZKU6IiH1nJYum8sG2Hv0Eqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hRNL/am1; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hRNL/am1"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2ff611f2ed1so969518a91.0
        for <patches@lists.linux.dev>; Sun, 09 Mar 2025 12:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741549864; x=1742154664; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dzyVokZIpDqiotKHrpU8Dw2U/v6X92xZQXOd24xBzNU=;
        b=hRNL/am1VK3gEHsVoNpElCqakRjHEY6AFeXM2GKDboMU44cMUbm6hwgQneiGpgub++
         bGijiYbEOHkjD1hzswAeB5UGHGxWQUjr0QEXA+/mEStweKDs1Kyjr5f+bwacTOWNBJK3
         7IteUs1ue3t/xv/rXpKZKpGxS2nMqRjo3tx6rYQH968Em59ZjSfEmoltqkqEMKsEEy3R
         COjEcdiL1UQEAkh1e+ut4cFjzBr3vtombGoNJm+ziL7MzGzUff+qfdmWSVepaF1raEh6
         LvWajacGLu9MNw5odN3s0vApTWdGiP4W9iV/0wnX7XPcjeGccqAzVfbbBmV+ca3cMjvF
         aZKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741549864; x=1742154664;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dzyVokZIpDqiotKHrpU8Dw2U/v6X92xZQXOd24xBzNU=;
        b=DTVm5B/2SOC8L0nvtIMfGj9kzqOaH0K9+ss0lgMO/5aCsKyhQkJyN4E37stz+UzpRc
         xs/9QQj6Qd+TORyEJU2aNazk6LuQC/Vsr4Oyx1HEWGbos+vUfEPxykQKT5C80Y0R8+Du
         WK5Ugc5f0JjS66hbwYtq4Wq+NDQxvYW3lP3gwuuXLM53tDZYnLPQdIUOi6hlF4FMlPd3
         lVTvwXZlTEhpaepm+Fhue7AWBJxj1Fp1DmgVl7cOE2c14bzFxLArITYGAiOr2Qaq+XBS
         VsupTvYoqaMYQeQCdZFVlOtYRBn9MUiaczSLUqxiPnq5Sdzfz5zk4/BD6UyjCYMl914h
         M5nw==
X-Forwarded-Encrypted: i=1; AJvYcCVY/choe0QoU0Hu+s+viZBidaJ6WBUa1+beannGFCzk2ZWNO45tek1on8aH9hliYHN0+K8VWs6u@lists.linux.dev
X-Gm-Message-State: AOJu0YxKIt0bxqCf2RlZDz21ockyPPee+2u+djzX+lqRZCDkGrYnFT5A
	ZijSbQvBT/JetphFG/qMlDxR7U+6YruGkVzyuz3du3ylqqWPWVFZFcrjVrike5uovWh/S+k1yxD
	PWm7OXmM6OEgj5vX9h0PMdTOH12k=
X-Gm-Gg: ASbGncsauEJ/Uum6Yn+2r3ZOBkcIZBxcny+J+vWiRyHbSCwooeKVzAnq4Oygsq2ZUNp
	TVUaG4hjLTsO3W6i60As/GvE7ngj9BdA/nJlVMUkAsFqpPOnq34QbscNFSSLd5NuoBwoNZeC/y6
	cYythZQT6obgUySoHArJ4hJD1cMZutgSqTRyPV
X-Google-Smtp-Source: AGHT+IHGCe9s2WblTrFMgpH8Di+4cRVJg4iC6xm/DMHz20ImOgtpVp9OzKQEgou6f82JbNw9B8+VEacVtEr6D7BHyc4=
X-Received: by 2002:a17:90b:1b0c:b0:2ff:7970:d2b6 with SMTP id
 98e67ed59e1d1-300a5788588mr4066553a91.5.1741549864193; Sun, 09 Mar 2025
 12:51:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250308164258.811040-1-ojeda@kernel.org>
In-Reply-To: <20250308164258.811040-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 9 Mar 2025 20:50:51 +0100
X-Gm-Features: AQ5f1Jp1Zj_Zln5b8Z8a8RBt1caexSZN8jo1ccd2tN0YFf2udtob6FXxDOKD408
Message-ID: <CANiq72me1J36RdY8_hYhOcMCF9qJH31HnE1Wwboqdz5UbNHN9g@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: rust: add tree field for RUST [ALLOC]
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Danilo Krummrich <dakr@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 8, 2025 at 5:43=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
>
> In the Rust subsystem we are starting to add new subentries which will
> have their own trees. Those trees will be part of linux-next and will
> be sent as PRs to be merged into rust-next.
>
> Thus do the same for the existing subentry we already have: RUST [ALLOC].
>
> Cc: Danilo Krummrich <dakr@kernel.org>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-next` -- thanks everyone!

Cheers,
Miguel
