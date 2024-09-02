Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6911218028
	for <patches@lists.linux.dev>; Mon,  2 Sep 2024 17:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725298815; cv=none; b=G87OkM5qfUzPKVO7Or2Sl0k/33l7wgjnvmKYHL/pj8q3wB87pRaY0MdAAU3Hh3CIWVncW/8lr9CYXpp/+7uaV4ATGm8s1sbS+Z9dmL0c5PbZym0W0V7lSaMFAcBWbr+J4CN2+CF70EGvDVyIwABReee/KgHM5r669l01aZsTyww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725298815; c=relaxed/simple;
	bh=HBs4C1YpOhw80pOB6SXY9L19aCPNafrPulLVQGMWfiY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M7lMSgFWRUKL7YGywErH+vYhJhIhHwyWo3a7QvSl+Sp1ujsceflp9N2iB0jXR6pa/ZtIfA94u75Yo2sprd7SO/+0bYwoxJ0Cld7BbEmM2amMN7XdWeAV0M0piSOl1U3F8iBcgq03RwaRF2ez1HRLMziqWlWgMgUntOm6PqLcvlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UP20b2Ty; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UP20b2Ty"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-70d19bfdabbso187343b3a.2
        for <patches@lists.linux.dev>; Mon, 02 Sep 2024 10:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725298812; x=1725903612; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SVAMC1/G3+ekR0YyzFtCAEDUHcSAt3pXnMJFe7EYTDU=;
        b=UP20b2TyN8eBQhRHXvLaXQ5TYSkIZFrv5SkC4LYYIyxQChSX7hizt3QbZvfoyId99C
         n9xLiGvSr25U8vz6m1bJLw5hRjcmrURrHqhPyyP5QdkMbz3Z5Rd4/n03Ek9uOpgXWkR8
         RAD23nHl/BJfhqnJtMuSz4JbMJwCzWifVFQc7zQMW6XtStDtp4v9K1oIrajXP78OXVWa
         91NoQ0M1ix2yz1hZ8V4Qdn2R0oAzapsbjTqou45oeqiHfwrsnsmCmBB7QCexpowVzdLS
         +fGMOE71Xf7q7AdmlsJCHRsRlDeEOTF3dFOCJD4zSdxfPEG7wMMGBu8aFQGBC8oiWTM3
         h05g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725298812; x=1725903612;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SVAMC1/G3+ekR0YyzFtCAEDUHcSAt3pXnMJFe7EYTDU=;
        b=E2xyfUqtYQ4X//sskujDIbidDa0aoZ/tE818sTYg0CUEuRQywta0qP6m+DWc8GNbZu
         aJ483YkfzQAweJxvB5fv3FDrvstUbyMLFsU3jiErxdKNJ5FNcOkV9f/YDlzedwP90MEa
         YLNKe/4S676AH+YLW/jqdY1w/lT+29kzgKTeZEiT1yYUPo2fWdb6yhrW6Oby7ZOj5gvO
         +x13z28GKPb4P6g203jszvfs6KVraX38aGbahQ2fpwJ257je1Mlz1A63X88xahcGkkHZ
         Yl016eOhraPSmJh1KoHVD1ehd2psoReTuzpI6viGmQqh39f5RgQ+i/eIfuh33j2qGG+a
         CO/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXQ5mQVj5eHw/JOpp1qTl6pFhbVWB/BYnz5KZvULtHLNW8jueyM8FzD35SxboY7fGl6uUbsbRRF@lists.linux.dev
X-Gm-Message-State: AOJu0Yxm31tn/OYknMTSFeve0x1Ht5or2w+rrYjgRPmEden+gL122ntI
	JzqPBYboJKLnAAl2JaicWXjGk28kT4H8HvRXDb3QdPZsEY8dKFy1aTXm5gLc0QSjE8RqciNzwy+
	zxxs1H82KCMtO6L8Ic06/f/rr9ho=
X-Google-Smtp-Source: AGHT+IFcIl+gz0XdiG2Z5jROYRwruDz8uSHuM8r4esBBGXdGA8l1J0fJAPNwGCzbeTtoPcYziXWsqrPDd7GqFqoVzWQ=
X-Received: by 2002:a05:6a21:3385:b0:1c4:af14:d9a4 with SMTP id
 adf61e73a8af0-1ccee3bc42dmr6232439637.3.1725298812608; Mon, 02 Sep 2024
 10:40:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240808221138.873750-1-ojeda@kernel.org> <20240808221138.873750-5-ojeda@kernel.org>
 <20240817-cute-doberman-from-shambhala-6f42db@lindesnes> <CANiq72nkBoiLUDQjBZi57OYwMpnH8D5Q4wR7XKWMry+mdwFOHw@mail.gmail.com>
 <20240817-ambrosial-zealous-reindeer-de0f25@lindesnes>
In-Reply-To: <20240817-ambrosial-zealous-reindeer-de0f25@lindesnes>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 2 Sep 2024 19:40:00 +0200
Message-ID: <CANiq72mPaLb0NSQ0Y7VMrQQWm6NO7Ejauo3S_3xZG9Ux3cpfbQ@mail.gmail.com>
Subject: Re: [PATCH 4/6] kbuild: rust: rebuild if the version text changes
To: Nicolas Schier <nicolas@fjasle.eu>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 17, 2024 at 5:50=E2=80=AFPM Nicolas Schier <nicolas@fjasle.eu> =
wrote:
>
> oops, I missed that 'core' is delivered external.  Sorry for the noise.

No worries at all, thanks for taking a look! I appreciate the reviews.

Cheers,
Miguel
