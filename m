Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32BBD31ED7C
	for <patches@lists.linux.dev>; Sun,  6 Sep 2026 01:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.227.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788657325; cv=pass; b=LkFsLxuEHAhHyZh0dUTBFvhBIWXNinHOQ+u7XoF98jysYRBIwrL/PhvTOI8qk1Slu0O2ubz9k63oxDjM2fuvf1U7mS2U05hPm9vRLL8O/qY6dCJAxbTKqvebmEpsGshM3j8zALDdZHmF5fv9xR5H+Y5xmTMxsNtMH5PgsBB5JTg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788657325; c=relaxed/simple;
	bh=nSiOrUeX0O/NdpVHm2fy9UY6kS7mLYoSftNiCyut3NE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EdhzPiNQ8LtBBBVOpsx5wazyp24D6VchAApWw3HCaVLj3bE8y2AE3M4tNNnTaocu777gSX2UseA9H8BCo7nMs/ZIf8fVWTI6HPgZ56vYw9HbsC/tXmKkXIF10nN1AiMgBE2PDffZEy7nKyp1Peh9WSECKvOfA6gO1o4cTcRt4zY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kpZl1/Et; arc=pass smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kpZl1/Et"
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-39666bed442so432152a91.3
        for <patches@lists.linux.dev>; Sat, 05 Sep 2026 18:15:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788657322; cv=none;
        d=google.com; s=arc-20260327;
        b=FysrxHxJi5QqiVaNAQa83DnbjhuSghAqzbif20lb/Pb9PHTkRYNkgyuVvHLydQbB68
         jslY7WZMAO5Uc7Gdj+3ESDT7iEmYOLz6J9MwwLO82J7mFdHMdjXFaHQPcDjJKGJxxaq4
         ZzSRO9xZd7QQ9+qzuFT3ei7TC1BzrwGEPlvz65FWvMxmHSYySM4C/ahmj9aW3Vf72nb1
         8mklJ65z9IVuFWrSs0q5KgUAd9e5JziHg0veeBenTRk9bseCCIDH5kcdvOGBXhv/4kSP
         Fr5tLAtg+xKmA5b+XNyZk/s2svQql69U4iLN4PMspg1DW2CSDxbcnUQErB8BKLVIHiZo
         fu+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=K9l1UNQdl18CfAL9gkmOy4cmbxzLvH54B1+3p3geHZA=;
        fh=5gZqGCFM239eYoeEyJGqk6u/uwudcMO3KqX+7ZBvWdc=;
        b=cWdmaXry6zb7r4jvIaTl5akqFE7fXh7sCt+eOslJtdsEybh0cpcy1dltUKLN/NXFbe
         cVcGnvjLAJxWDZuI+N1sDvungrA8Nvz29P3CizVH0flJZPJ2TgP6jWVUyk231JROk8Yw
         Asbxzz2EuWpZfwgTcCB22fjsZ5zrMKTfIY/pxI/4e2+lgnPFX5vhB+aBvR/V4hTUrZ9+
         8FSeVMz5ibMO3CKmheaBl9JELeBhGBpy/YI9sbBR1/ZyWmZnxQUYpWfU5PDzqHNlEuj0
         HCqtxsYZosUIXZdsRMs0NbBBEdWW8OGef76ia+BmT+cE/dNGmiHfrTVJHd8eTxGBvpHI
         U6Cw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788657322; x=1789262122; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=K9l1UNQdl18CfAL9gkmOy4cmbxzLvH54B1+3p3geHZA=;
        b=kpZl1/EtWuNStJ8YMOybA0nC3rtUB3Y1DNQFO8SbP530Q41xRPfwZvhB3p5hyE9cAP
         u3ogyJuH4CL+Sh7xxJkCH1T1VQR24IJ8jVrp1isnAk3qYYQyfjSY/fWcbgoOKDxqt50l
         OkOsD0M3D6kxL1U3lj4Tf7RgzqHk34Ce9XPRQ2U8fzx5BGXpFPV3thesfth9GUEvI62X
         1MW8BvNFdByBmOYimMm7M7XlHokJSAVCPM9RtHcKlIHEiNMr/BjEahn0bp1dFbHd0qZx
         QZrtcwLlPAmehkxu+BIrmUoedyi/VVAPnDDvNbRA0svwvWu9H5OC0lstqgfZvqLRaCML
         cDyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788657322; x=1789262122;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=K9l1UNQdl18CfAL9gkmOy4cmbxzLvH54B1+3p3geHZA=;
        b=LzhW0fW9zgX+d3T2KGR3kxifFzpvl0yvFVegIz1BiQOGsOXNYCFF+cVi7hg1GXZc7y
         eFRm6mEtyOuIae87GN4v/8JlDtU1UAmLz2Zh7N2ePJ8+P5Y4tzejcqW1ut0oLJe54PEk
         7tSs1ZcTC6B/flmbOEtiyX35BDk9t/ROAv+1G83gcPIkfjgwnzcWqxuxRtAyjEY6oFPy
         kEMio6b/MZy1wouFIeok2AWLVLyI7FRI2uelzNqtDKTVwJRugEoqxqMOznwacoG5yL8l
         UffEvG3scWIHwTtBMuuc+I2O6gOlB0CINyFXcQzlOeebYRljSFPnRaQhXN0pTEO/1IMl
         oDgw==
X-Forwarded-Encrypted: i=1; AKwUvBxujaiQz88MApMbegPZLMxQyokHYvuXH6xki7JBD6XHfnVodQZBf3vmfdjgaD6KkaCnWFJ2rwQC@lists.linux.dev
X-Gm-Message-State: AFuF++kAyWCmzUcCDLTkEjcEUhZfmH5z2BhO/7KWEPC+bFxVlUttf18v
	oOui0VqUBYHPfY/EAFC3t5hXfZQHvWqrIl/SaNNRTehTwNIhC4GkB7E4EQT+addTg4021bx/sBc
	/1S402RcLzDI/fivhAc0qChG3WYnCf3EP8s4E
X-Gm-Gg: AYBFou32zvgO7S3EOBMFHqnyJX8lwFkyeIjX18H/v5IwGQ4XgRpFudZteh9yajytIL0
	a5WY70WpjrNMeN7gQvydRbmfi3ZlSitch5mBkCI0e6f4IPZRnQVCz1S+BYBUjZfG9rEkvzRD66+
	kf8faj9koKVjwWqY0In1cGAcfEhcICXcIcgZS2VH9iXWTcyz9v4kvSoVO/D1D0yhwTRHr4OoqLb
	HC2TvL1pbM0E2G+jcnxm8+0cu0/b+hHuiLmKAxrzgi0ecNKV60sPmhPlEVF9EGmB9A3hrsS3tPI
	3NNGqjfnHjmQ08ncG+C+CuGovFw5AcjZaNiNIMA0Ru2X4ZApZArVf5J1TdoNZy1Hemttus7o275
	ljJ3+0VYryanjGkIm8Fqp6wcKh0kS14JGn7rmDEahW6QoJnvZDw2vMGMLw4m+
X-Received: by 2002:a17:90a:d64f:b0:390:af7c:fe5e with SMTP id
 98e67ed59e1d1-39b26741434mr15019221a91.2.1788657321824; Sat, 05 Sep 2026
 18:15:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260904045747.813364717@linuxfoundation.org> <20260904045748.373148168@linuxfoundation.org>
 <CANiq72=EounScE9CxhQVRYTMe6XxgZzfid_cJZ5dxmkz7MQ2kw@mail.gmail.com>
In-Reply-To: <CANiq72=EounScE9CxhQVRYTMe6XxgZzfid_cJZ5dxmkz7MQ2kw@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 6 Sep 2026 03:15:08 +0200
X-Gm-Features: AcwNN1UFX5rjdj7_KLFJKMDwiMUh-IFANsRgF-3WCWVLBFVMTTj267Yzu5Wf_BY
Message-ID: <CANiq72kOxeRSi7Pria6hv4T_HeL_hRVXdq61nvdGe66GpQ0AAw@mail.gmail.com>
Subject: Re: [PATCH 6.18 024/552] rust: bug: fix warn_on macro build error on UML
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	FUJITA Tomonori <fujita.tomonori@gmail.com>, Miguel Ojeda <ojeda@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 6, 2026 at 3:04=E2=80=AFAM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> In 6.18.y, this needs to be:
>
>   $crate::str::CStr::as_char_ptr($crate::c_str!(::core::file!())),

Or we can just drop the patch, since it is still our `CStr` in this branch.

Cheers,
Miguel
