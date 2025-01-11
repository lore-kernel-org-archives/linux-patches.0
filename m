Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4C71B043E;
	Sat, 11 Jan 2025 19:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736623659; cv=none; b=mGRdUAQ4ttr5nWNyTzGCZPnO14WZVaNuXY4vWt4MPWE7it+YTYgtnmHRZvlJ1hfkWEEDBNdKPpwKkp/jxud1BVRmmSY/wpBmu75YcLqIdnXPr3OX6qKzawmoO1t/9yUJYQpFl6h9udsrY0iBBBUGZ6U42+LrKsW83r4SXmHUJQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736623659; c=relaxed/simple;
	bh=CfwpKR+2LZXVDs9rJcHICXGzOU2a9Lg/d7i7j7kAkas=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m16RxVtc8c6d0zU8UR9A7tjSI+0SRrbUzzOYGJP2sjNO1AhIsi+aMcZGYvDrIvQNGc0xGXltUGZzWQXiUfuIJNuAQoHytaMetmOL4V0O+EfCwqHtpAb7wSJcT9QAXsJLn9WydUGWQb9s1PK6x9BDDO3LclaKti67CrRHc6GFWow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XzyT3wgD; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XzyT3wgD"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2ee534d6800so681438a91.2;
        Sat, 11 Jan 2025 11:27:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736623658; x=1737228458; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CfwpKR+2LZXVDs9rJcHICXGzOU2a9Lg/d7i7j7kAkas=;
        b=XzyT3wgDsonSL4P3xiVHJbH/Ym4ISzhmlRD9vxpvIDMLyBq2mqOtzSonIBhT7okod/
         LUy9LFA0v45bnZz9dMZn2Qjdq3QMsJi1IzTLSmknVV2lQ1hWC6ZPkJqX3u8kGC6+ryW/
         MrKxBUPCi3/3QN5W/ANY4zMt6gXXKZtzwvG4D9J/bVj1ATaxZR4f+evSOhP7otck6soW
         h8lmgx13+7PwAsfP04Pelvt0sJI4EqsOOvbGo6JNdYNT2YbF8VnUOScQO8P5DvDq7g44
         Wb5bl2A1vQsNRQgL4sVyfAhY5yVu1TzYJSrExjlu/OSHBbjjxngKX5731Ltg7k4t9xqc
         lMkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736623658; x=1737228458;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CfwpKR+2LZXVDs9rJcHICXGzOU2a9Lg/d7i7j7kAkas=;
        b=lzoV8J93swzGfqo2+ryomxf2WBr7M+WVUS6vRTuhQOjzv0bH9PN/lrbNIO79nDMn/9
         WJWKYPmI+anmS53kzRFxHaBKnkAWGDEDnepbOhGUbRSJGuujXoS+xyVK9pmiPoGxn1Cm
         MZHA6ON6WWNEdxyv2dlKu+Cfd+w4z3WYHGzfV48l2eiXVZ5TkXMRPKJPOjUX6xEYwwbi
         dwxmcCOQ3glbbYAEpT3ks6H9uZQPKE/lYv8KknPN+rDynzT+Arv/rW6CLVeZ6oj415Es
         CeFd7dQ9iw/e4HyY03UHbU11r9Oggq5x+xHYVUmnp/V8KwDKMmrpin6M7jMHG7Ct75Fw
         xnrg==
X-Forwarded-Encrypted: i=1; AJvYcCUV8adRKsikZxIcsV3iu3J41mSy/hg4TdyQ4Wyo3vorI2maoT7KlXRAvbusteCbxdYW9uB+@lists.linux.dev, AJvYcCVhoGaIYNTTFA9nK35iZXLjF92Ee7VHqxeTgIb8vidMHsJT7S42meiJfaoh18h+TRokY8ji5VJyow==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw9ie14pyY0wVnrr+FcX6bGFvF9Gpwll8qCXdH1CjGcfrNvXVKm
	pWS9qDPWhTcgIuYrYvOHxn96b0pd5g5GB/yOFXvAjj0d6L5dVXNRJUbgu260lxCH7NzhRmkd7X5
	VyVtyYMLalRXWMolLjHM30Nz3RR0=
X-Gm-Gg: ASbGnctOTAkZ5QlaWlhXkFkgFBTE6tNNnZtRBEHeRwNPghBMg4hgQxuj3KyrDYI+lhG
	eHuJjXjxsv65OLTa8z1c1RcIL345NgQIcspGZMg==
X-Google-Smtp-Source: AGHT+IGhZwUzkEh+DpckkqR/MjURM5moqDg715p8zsHuYl2YtO5TfToWhx68Yn70vIliBDudFsoCIatJKla+jEhtLG8=
X-Received: by 2002:a17:90a:d887:b0:2ee:6a70:c5d1 with SMTP id
 98e67ed59e1d1-2f548f1ef1bmr8556990a91.3.1736623657797; Sat, 11 Jan 2025
 11:27:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250111-spi-amd-fix-uninitialized-ret-v1-1-c66ab9f6a23d@kernel.org>
In-Reply-To: <20250111-spi-amd-fix-uninitialized-ret-v1-1-c66ab9f6a23d@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sat, 11 Jan 2025 20:27:24 +0100
X-Gm-Features: AbW1kvbCeEX-RVceRqr5kUTnEyvsVpIAE_SIlsCCDcXFsJEw2-aR6KBDnwyi5y0
Message-ID: <CANiq72=6hA20fmBtO_iOTQkk7afUo2Aw9=WLY5kUD8OYgCM5jA@mail.gmail.com>
Subject: Re: [PATCH] spi: amd: Fix -Wuninitialized in amd_spi_exec_mem_op()
To: Nathan Chancellor <nathan@kernel.org>
Cc: Raju Rangoju <Raju.Rangoju@amd.com>, Mark Brown <broonie@kernel.org>, 
	Miquel Raynal <miquel.raynal@bootlin.com>, linux-spi@vger.kernel.org, llvm@lists.linux.dev, 
	patches@lists.linux.dev, kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 11, 2025 at 8:09=E2=80=AFPM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> After commit e6204f39fe3a ("spi: amd: Drop redundant check"), clang warns=
 (or
> errors with CONFIG_WERROR=3Dy):

Reviewed-by: Miguel Ojeda <ojeda@kernel.org>

Cheers,
Miguel
