Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F1CE1F956
	for <patches@lists.linux.dev>; Tue, 10 Sep 2024 11:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725966888; cv=none; b=bBDXoK3O3owH92ggJGLYHGn+qeL5MiQCn4u66qoBnQhcdXmrwQOJ1KmT9v5N157Oxv6sc2UF9MnwPXCsjkX0zSy+9pkg1snU8MRQaNmEaZZGpTOYG3fBQFtI0684bELcCVCmUBesk44NyxIsgaVoR5GJr0UKsnZUSqdOVMM+7VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725966888; c=relaxed/simple;
	bh=7R70qvFxYRQKCjHDlVjVMuioejDKgflNF55Yu8sguNM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eKuaRnl07cs7QsF105uG6HK6FjYvnqApifBGk5WtANfu75tVhC58ElZdUJEmPCKigIYaLclzi+Au/0DuUoOP82xmQRb7ijMjUY2HJ9f9kdkzFq2YdWF9wmV3u3ZyDXp8V2OhkpkEPtTFF0JSI6aRrihesHn86qiEagsu3TitKOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kvq7Yw5z; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kvq7Yw5z"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2d883286bd2so296594a91.2
        for <patches@lists.linux.dev>; Tue, 10 Sep 2024 04:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725966887; x=1726571687; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7R70qvFxYRQKCjHDlVjVMuioejDKgflNF55Yu8sguNM=;
        b=kvq7Yw5zzFFiKNk+SB2gk4fjq2XCDe0EzlgTpW7OMH0UARTEYCkBsta7CzvstrOOND
         QBiv9b1Q8GuIMC3KOTOU9Pe8nI7AITMifWMWYlwoZNSiD6kVeW95yow1wvzrV1QpydIq
         KP8po09c5iix6bmjWWga8/hINQNsvl2WMtW1kJYNBNk1FxEG7C/r1nRjaFpnivH27h6s
         bpOzYO8bNgOQV9p/4jf06xmzoz94VYfhClYaeNQ1wwei96ctUCDRtRl79aeZQkpzKFAd
         dosUnPZXWHpcKqCXGp4IXSU8okvf+hWPD85ulVc0NDh4HqVPpApf2Wg400MnlMa50EVV
         YlAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725966887; x=1726571687;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7R70qvFxYRQKCjHDlVjVMuioejDKgflNF55Yu8sguNM=;
        b=avDbLk2/hCoHvkVoBtRXZq+1I8n1xUj4nKECXxlToCrBaV68nitRhto0o3wV/RuN17
         YwA3Y35RRyuwMG9tArOSTWd+hs+3RkjvG8ckDp1dM4i0sHwmW3/ff1jMsiXzm/zUIyQJ
         uRgPwBHxr7fJoUstOv3V9u0qe15l9i+TKkmqhalWTY74y3NVmQqU90WZSfZi5HPAZUrz
         SHgcwJZtbyvImWbeXvjWIHm+PF28ikPHarVKfbWVOzPXlkYeD5i/Po/ZCceoc4o0U2ok
         wq7RXK1TkJnbawl1HFqC7NH5yzz0A8Ln24HaFcKzZ8tvLpEKWPSWg/BF4Kq5ybkfM526
         5kSA==
X-Forwarded-Encrypted: i=1; AJvYcCUFKUOprEOsRNj3wWHXSE1Vwtg6sMkgAQJky9CCrCZZuB5Ud11xIZvxx4rKRLmwa8lvMchZS9oi@lists.linux.dev
X-Gm-Message-State: AOJu0Yx932o1OMbfGADdKoYFXW8Z/2+s8OGzV0yt8QuGDxDasnLYabXo
	pLlroH+eEH8x/epSuaO5aiAOvrOqOAUCzOFSbLKibSfRHrhplIvLsl/vbhGRDzMmMtAfSPvFiVo
	GSBjHqDbDNTDqrzslHyL5l71zpo0=
X-Google-Smtp-Source: AGHT+IFA9BIl5K6nzzFm26HbZ/XWC2bq8ZUkUz+X7SI61EMsnik7yYHU0TsUVMbVKdAcFYqRNR1EofIDip33sDTGX0Y=
X-Received: by 2002:a17:90a:604a:b0:2db:60b:3668 with SMTP id
 98e67ed59e1d1-2db060b3bd2mr4322899a91.7.1725966886696; Tue, 10 Sep 2024
 04:14:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240910092557.876094467@linuxfoundation.org> <20240910092604.257546283@linuxfoundation.org>
 <CAH5fLgi7_=3W3WdPR2KcUW73Ma=SXo-dX20z0xx+AK4S_N3SwQ@mail.gmail.com>
In-Reply-To: <CAH5fLgi7_=3W3WdPR2KcUW73Ma=SXo-dX20z0xx+AK4S_N3SwQ@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 10 Sep 2024 13:14:34 +0200
Message-ID: <CANiq72kvESNP0StA6DRukSJ7K4q2a4EtTsNTDECSAsWjmhp5-g@mail.gmail.com>
Subject: Re: [PATCH 6.1 153/192] rust: macros: provide correct provenance when
 constructing THIS_MODULE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Boqun Feng <boqun.feng@gmail.com>, Trevor Gross <tmgross@umich.edu>, 
	Benno Lossin <benno.lossin@proton.me>, Gary Guo <gary@garyguo.net>, 
	Miguel Ojeda <ojeda@kernel.org>, Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 10, 2024 at 12:25=E2=80=AFPM Alice Ryhl <aliceryhl@google.com> =
wrote:
>
> On Tue, Sep 10, 2024 at 12:12=E2=80=AFPM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > Fixes: 1fbde52bde73 ("rust: add `macros` crate")
> > Cc: stable@vger.kernel.org # 6.6.x: be2ca1e03965: ("rust: types: Make O=
paque::get const")
>
> The opaque type doesn't exist yet on 6.1, so this needs to be changed
> for the 6.1 backport. It won't compile as-is.

+1 -- Greg/Sasha: for context, this is the one I asked about using
Option 3 since otherwise the list of cherry-picks for 6.1 would be
quite long.

Cheers,
Miguel
