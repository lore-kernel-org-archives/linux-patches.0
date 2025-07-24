Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4E92ED17B
	for <patches@lists.linux.dev>; Thu, 24 Jul 2025 20:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753388953; cv=none; b=S1jsLF3yLTHNwmRU1NoiJ1N8iXg6GEWfTAg3tNnAOqAsnQPrS0/zYWwPPgf14myNBMqxTZp3xhdEjeTaISFV98T90PxStUmHxkmEInMTFa7cP6fCD/w1flJyZdxZaI+f0yv1xSlNACu9tjjveYNOR2xM3hL00ClPvK/X0dm5e2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753388953; c=relaxed/simple;
	bh=ZM/cVPMjqnDcAHexC1gwfwrsHc2MgoIp0pKcizUhlwQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y84O2KmKofAfGH8TeuphwlwHrY1JDkH71oeyPM2Cd9xPJUTWM4WylQVnoh1+bXHxvnXEOc+62dSZlnZysMq3Ql+aMoJizn/L2ZIR0gbt3l6NCYhihzGEMeILVHv/rRz1UgnKocCCuLxCckORoAY3L8hFcwZzRk+YzZIKFu94kIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jh8rSQHc; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jh8rSQHc"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b26fabda6d9so231516a12.1
        for <patches@lists.linux.dev>; Thu, 24 Jul 2025 13:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753388951; x=1753993751; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZM/cVPMjqnDcAHexC1gwfwrsHc2MgoIp0pKcizUhlwQ=;
        b=jh8rSQHc4+8kcDSu/T8hiVWEd9Xi0wGuxYWA4DfDCYUB52QwKafRV799bFKMkbZpBo
         ign8A4YEU64bljhyGCy0PUahfVo+s73A2zvH3TQYgC03eFf9UCmDk/3TtvjwyzHp7HF+
         oDuEKC3pDDOXe3IIvCKjN2n+bjhpEykZcsUeYHQrJA2tLSSsYgOMxUrqpb/dt1pvDlIO
         s0E5HmZa+AYF8AmEbNAmYZ+lauJhrIp++jQMk8w4ppTatRHNms1aGZlmcIjP0sJGIMv4
         0wTHDJfctjrNXJNoMtVn0MVaR1fCid0cBIihs0ISYOgVw0V/OwLF2+BPukE+4MBAJT1b
         QBZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753388951; x=1753993751;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZM/cVPMjqnDcAHexC1gwfwrsHc2MgoIp0pKcizUhlwQ=;
        b=CS/cIU/gKpdpDQ1EVW7v+5smw3EKabE0FzPmm3na622spBy/1JjATHXYE4awOCQRmw
         5lIG1PfIG7WCJD7PUmAOvFcqDUueQSF+1D+vw4sp8fjdRnMrxYWg5tRjTvREx65Due5E
         QzfM0QJ5di9rHuVYR2jvOdWOqv3pAZZoslfj4Yj02qfFym4v/35xAFHT74R2yB1l1g3g
         1l2LOknwgIRVjr9Qc6axAQC4ha87j0C/cI70620d04cJDRrRmWwbpWEuToFVwzGZGJCq
         WYtCl+qNHgmKH2GcbkYVUXh+r/IO5OFSVpMb+3nVhDe9k79pRW1XWlsEncNcaYCrUCyB
         R16g==
X-Forwarded-Encrypted: i=1; AJvYcCUsPAwHK0E4yy1fvQNna1Cg+B5bee5nVEfCNvaSKnqNWBWZYYC/UcDLYt/2kwChKKcHJuOMw+OO@lists.linux.dev
X-Gm-Message-State: AOJu0YyVzqv+w18LR0EFMHIx5JmJh4EdmBBaou0lwW6n7Hs6Uup01u81
	dF0VXtsBZBTAH4WukpW+XdOsOlKDfGJSg8eEuuluMG15A6Dkb9mv3w6z+aenvl1baxYtxvcl77T
	SBo5HzOJCKfUi73hH8WMGTbnNnhfSKSo=
X-Gm-Gg: ASbGnctozH86Dj+AfeLejN4Fn37C6x7XNJQlG37hdTyc8j99EO2OmL/2ksqPvuVDy3h
	MHQsLQ0LP/kbDRHrxoHewsEhEdxTsMAI+w/a9aTEEdxjao1nP6IsVhKakAnxCLqHYw1DKijLfz/
	ROde5qyF1rPx3JOFD/+CLRplrPN7sNecRgNvi4kFan02Pv30kci/z+wU48nDSwOKEc84YiR7PeU
	CMPRFtN
X-Google-Smtp-Source: AGHT+IEAGFB37ZidsHLIIaba8FiGeBk2ECZccsALYfokim6qqvD8w9f6H1DHr7EVTrqZ0BiawsUQhH+jUVVtuE4an9o=
X-Received: by 2002:a17:902:f54b:b0:234:ba37:87a3 with SMTP id
 d9443c01a7336-23f98172235mr43503445ad.3.1753388951451; Thu, 24 Jul 2025
 13:29:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250724165441.2105632-1-ojeda@kernel.org> <DBKG6CA32OO0.368N1Y6VMIUTL@kernel.org>
In-Reply-To: <DBKG6CA32OO0.368N1Y6VMIUTL@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 24 Jul 2025 22:28:58 +0200
X-Gm-Features: Ac12FXxpi3gEikt92Cs8uSRLZnJHZD2m6LWFkt4o9DdE2xrir2WW5NTAjXO6LT0
Message-ID: <CANiq72m+t_vvBsSkgmHCtUvXOG0EOVTBoOij0XZTM1mzd7mNUQ@mail.gmail.com>
Subject: Re: [PATCH] drm: nova-drm: fix 32-bit arm build
To: Danilo Krummrich <dakr@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Alex Gaynor <alex.gaynor@gmail.com>, nouveau@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 24, 2025 at 7:05=E2=80=AFPM Danilo Krummrich <dakr@kernel.org> =
wrote:
>
> Thanks -- will take it through -fixes once rc-1 is out.

By the way, in that case we should probably:

Cc: stable@vger.kernel.org

Cheers,
Miguel
