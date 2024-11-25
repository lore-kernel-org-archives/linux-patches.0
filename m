Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587D718FDAA
	for <patches@lists.linux.dev>; Mon, 25 Nov 2024 09:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732525884; cv=none; b=RRRfs/irYCSxs0+fnR1P6DazZM1swNv1zd+nHp7+pFQQMZpvImrMQgl1cYka9DReOHU6AJ7fcCjAC9Zyv6UuJ+BxWJyTI66Oh/f7smVzWgJM68Oey+KlNHnAKz6rhdxbX2wYUj06PxaBj1BH3SVOD+CzKXIOGi0GHnhV8/pXpLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732525884; c=relaxed/simple;
	bh=wT2QX0BLl+SGVNLChvroK93Yxa+Mm8ft6/n++IH3SKg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CUkfuqWcMPF3VxFDDoB6qOdn/dbWRB8exr/Jr2sNxQnuBjlJMR947/GmJY35ZDUinDUwqso9WQ/nkZCZT+YRScDu0ObCsZsDrZdkz9tuTTrv3lStJliH/vhjry8XU9TID/J8ypd+89gl9PT1eiBobeRwuKDlrECoSzetbrftPyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Kj32SAA7; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Kj32SAA7"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3823e45339bso3130026f8f.0
        for <patches@lists.linux.dev>; Mon, 25 Nov 2024 01:11:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732525882; x=1733130682; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wT2QX0BLl+SGVNLChvroK93Yxa+Mm8ft6/n++IH3SKg=;
        b=Kj32SAA7CzHo84g0npJqesAwvF83VPCPfO4GlzvsQVfbdmvAfsCyFa8acNYZ2jydrJ
         b8axc/pZ86hzQ6TvhgE1O4IJ9czBCL8SR9+unx9AGDCcVCV5ooaPAWEVPVXi7kTgFoUr
         d/HTWgg2BvJRTeLdFNGh4nDshvtAkkgG/gjMJaSPK2Ah7z0Wt9WwgmJzsouMgf2jQS0Z
         DZDMGFWoYktshLeFMEBq2VaNUjULmxFsVDPrtIjb8vDx14Hwi3KB6eSwoe+ZiDgvGYqI
         rfYm3f2EP82zREEM7YadDcC1pz4rKxMIZv6zktE9X5BbphOa8N9IX9JkKipSDBnv3xNI
         swvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732525882; x=1733130682;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wT2QX0BLl+SGVNLChvroK93Yxa+Mm8ft6/n++IH3SKg=;
        b=BVJfurFYzpdhLahDp3N0kOF7UJ39hPF4muzAyAvmf2fvCsCglAbEwKP1BTOiLoKOCQ
         kiqxis09VF7KCbeH5ppRpZNsM/DGMIami59lnjqpkR3s89hck4b93rbxG6UWmPgLBHEv
         +ZAX1Zzg3/qzau15jOeZuFz8sd2Q44SXi6tOzi0d/X1EnMSkuALUAfnFmdLSE0RrjeEn
         Q0IEGpO9CtmsNmbJpyp7MnkVdC9Yc3tr0TmWM/92k7soOzso9H+D42rjQFBXGagSn+Oc
         wK3F8WQqoxwQFaW3Ihveht/nzWSHRiPstMQdSHzRaNkWbROO2mmSezGbiJrtNH4caB1T
         mAtQ==
X-Forwarded-Encrypted: i=1; AJvYcCWwDTnQibl2NNL+62gLwDaBNHFzoyj2gjnbmx5yEOPX3fSMHtzk1CFksXnb6CWxQwyNkTDKwlju@lists.linux.dev
X-Gm-Message-State: AOJu0Yzj9eL2Y8UkE9+Y8FtLLvi4FPSjaJfRQGC15UO1gMuzfpQWLym/
	2Tgbc0uvIYwAUuHwE3ovWFdi3406wPtn5xgCHxa2DShbqllNA4/0LGqGgIIZt7Ofi8xV1DoiXQB
	EiuBkQxTsyLYpY0jag65+tlDn4JSlTVVM+qXh
X-Gm-Gg: ASbGncszFICs1Jc7GqD7N8sPYM5A89HOQqJ5n1/p3bu1QiI9whhfzsDiF4+4sGR6/Ub
	K9UkbZ8ttspjkDAsQA+YClkmuZ8e68JDp1WkzmDp28ov8v0acTAJONw1iN3mYmw==
X-Google-Smtp-Source: AGHT+IH8xUhObePFMXX+6uJ4DZH46fnDECSOgfgui5FdlJfDvg099oVJfy7l8jGXt9Hpo3OEBqlpkGLGHf9ruibw67E=
X-Received: by 2002:a5d:5849:0:b0:382:59c1:ccdf with SMTP id
 ffacd0b85a97d-38260bcbb70mr8904576f8f.46.1732525881617; Mon, 25 Nov 2024
 01:11:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241123222849.350287-1-ojeda@kernel.org>
In-Reply-To: <20241123222849.350287-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Mon, 25 Nov 2024 10:11:09 +0100
Message-ID: <CAH5fLgiOHnX14CtN2rtC8ssUT03ECLOAGNLYPfA5ELSch9fONg@mail.gmail.com>
Subject: Re: [PATCH 1/3] rust: use the `build_error!` macro, not the hidden function
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, FUJITA Tomonori <fujita.tomonori@gmail.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Trevor Gross <tmgross@umich.edu>, 
	rust-for-linux@vger.kernel.org, netdev@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 23, 2024 at 11:29=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> Code and some examples were using the function, rather than the macro. Th=
e
> macro is what is documented.
>
> Thus move users to the macro.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

I've introduced a few more instances of this in the miscdevices
series, so you probably want to amend this to also fix those.

Either way:

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
