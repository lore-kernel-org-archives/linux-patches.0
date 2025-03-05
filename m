Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB2F2080E8
	for <patches@lists.linux.dev>; Wed,  5 Mar 2025 23:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741215730; cv=none; b=U0gERmzaWj4r58DbtZplApXHvQzUTldeQc26816xIKpTJGIgfj8XCPGCXdp91pNg7TVAB9MbiTv96o9tW2dzvIqNIKEahNFF6KDfLF2Cwpx+uuNyzcF4AyIJEFnHGnj1OfFepCoqnsVgW+kRMQj+9AdOW6raiv9GJxj8MAGTrZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741215730; c=relaxed/simple;
	bh=rgcs8jkGVo3NHV3xZ6/0r5NLYIo7kc98WvHTCah+c3I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SA15+7j919FkN44IKHeAk6Do+or5YR3FeQBhXvAZZSD5KVRZWM5UzHF+C061igRFmu4Ynj10POd7Vb6pplpkTN7mRNkL61PZmeftHwhvRPfGOXVNgYvWpwueLbtQWQ6YOo+gcqF1KoPDroVnAaH5+4Rf174E3ZQim7iX/8pRVK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B+y1q6n1; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B+y1q6n1"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2240b4de10eso538755ad.1
        for <patches@lists.linux.dev>; Wed, 05 Mar 2025 15:02:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741215728; x=1741820528; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rgcs8jkGVo3NHV3xZ6/0r5NLYIo7kc98WvHTCah+c3I=;
        b=B+y1q6n1oDAOWq5mdtQS/OVXN8rarkaFq3M6kXl5p5GKZwpWUVSULnkuLvlzZJLPPh
         fxgdDJtiqg/I3xgykhPNF4D3VZ6v1+U8d73qdRN8A9XXy2NmtAOYBjWav/LUcr2pbRoA
         yniX2pttw2cZL8gfTuDBgvdHIR1M5MNjZN8y3aYZmiqR4wNfmt7vdJ7DCouAQ3n6wEG7
         FK4CP308zYafnambvYXWGzIOP4MFyab4gZ2er3d40SKVP03V4VOneiH5VeoWy7MMQXL9
         EOZ07TER0OwBb5mF/wnug8pSv+hZ/1TyeCXWvjEzPUsRjpUogNofOz09Q53XRHOQuNbi
         lMXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741215728; x=1741820528;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rgcs8jkGVo3NHV3xZ6/0r5NLYIo7kc98WvHTCah+c3I=;
        b=aVlPTzqQf7CWwc8QbCoukrrn6LBzgb5KxgLu8nK/ZVlW3C2rZTZ5N5nuGus3DDKbxN
         QHipDZvGQuZyezysXptRtfEhhpw62k4gtJ/TflWDvduZfSg10VfZ6A/r0jdpXUROCERI
         dZZlmYEwGxzc8SBoijQgqgjMz8O9BHeJvgi7LKA2V58Mo3SrPN0G7OBHqjDtMErw5aLn
         QXhpvbC23o8lde6S6g/RGwRTMe1eBPJPwdipALhiAdvnpDJVX41Fafe6bAdF8ZtDl2Ti
         0VzFcOyIOfY6Lf5sdCaAz8tBCFm0OVA5ehRN6c36NLkPVX8zmZQR5sS4yn+Lc+fgxtaX
         v0nA==
X-Forwarded-Encrypted: i=1; AJvYcCVTLcPt0jZsg+zLBUWnLLKvk8rtsi4QG+ywFU0g9VQnPSWkPf4HByo0YR56CVHcCp/P3F+gvHZo@lists.linux.dev
X-Gm-Message-State: AOJu0YyAmO8qjITkl2Ww0vw/mmOnHpna6ukSBLG8POtaBBYM2pYUAbkf
	m2mOpjFKJFbqGP6AOxX7FSt32Q0c2s5PO6/6nVBXGiAcmb2/5SIaVmEfmtoQGFf1pXek2HEC0un
	El0qeThIMkw3KanczhmsyZtiXEK8=
X-Gm-Gg: ASbGncup0AoN0+iU0vjYtxWtBUlaBP4+A13TY6sVPP3krFAjeryVwZG1YA63CxMBLdO
	155jGjYL81F7YSgjsEAvCKoitgGFB5RwW7rOhG0NleoOcWThDDufSW+jVOTslrstpx1z+Qjzr1t
	VtBdnO/5bmFO2TlRcaBh0HTcaV5w==
X-Google-Smtp-Source: AGHT+IEOHQytaLDZQAvKtNTBltPyvqtYSsB5GrP/DGnmAkK70fPpVPLtg/WQaJM4nJWg6uLzp9GDjBc7m87M++pdEDE=
X-Received: by 2002:a17:902:ea08:b0:216:30f9:93db with SMTP id
 d9443c01a7336-223f1b87ad3mr29085005ad.0.1741215728049; Wed, 05 Mar 2025
 15:02:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250303171030.1081134-1-ojeda@kernel.org>
In-Reply-To: <20250303171030.1081134-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 6 Mar 2025 00:01:55 +0100
X-Gm-Features: AQ5f1Jr0OQTle1lIKSehc5uqZjrZL6QS1aOiHJlFeVVcIb6JdJy8vamJVkQrFE4
Message-ID: <CANiq72n8_rJq5SzRV69JutFmbbJak=pb_ZekSgsLtL1evqy8Qw@mail.gmail.com>
Subject: Re: [PATCH] rust: remove leftover mentions of the `alloc` crate
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 3, 2025 at 6:10=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
>
> In commit 392e34b6bc22 ("kbuild: rust: remove the `alloc` crate and
> `GlobalAlloc`") we stopped using the upstream `alloc` crate.
>
> Thus remove a few leftover mentions treewide.
>
> Cc: stable@vger.kernel.org # Also to 6.12.y after the `alloc` backport la=
nds
> Fixes: 392e34b6bc22 ("kbuild: rust: remove the `alloc` crate and `GlobalA=
lloc`")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-fixes` -- thanks everyone!

Cheers,
Miguel
