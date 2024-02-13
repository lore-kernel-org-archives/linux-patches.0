Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9945FDD7;
	Tue, 13 Feb 2024 20:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707856637; cv=none; b=s215btleW19aPiAROK1xx9kzPr9nWfFe+IlLEVq3LAef71efgruk+MoZpXNnvOKpB757mN3kKM6++F9ud7gw6bAHMSHouqq/wwJu8BFGU5EHEBMWNfLRCPXfiGKiXr+cFdvj7wjXaMEF4FFxfhN8uPT+Rei0LYrT7thiBzLzKmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707856637; c=relaxed/simple;
	bh=n/wW7PIGgqQXSlQ0F7NCV5oNj8FXGjtLdH3aZqJKeHE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CwLoOdMfSMH/a+ZqMmC6Uufiogy8sP3vuC+cY/2CbE3QljMmj/ZQ1GFoe4WtIrEg4Wxo15eQUGnA7C1Zwc9+ZevrXQkBn75WXWMh9DF6uZRmLT0mlNyZhzsO06yBiZ6BtpurTvDS8B8TDa4BUq0nbpi/TFPx0wbE2Qo2pQk9Um0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OGvc+fK+; arc=none smtp.client-ip=209.85.219.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OGvc+fK+"
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-dc236729a2bso1234943276.0;
        Tue, 13 Feb 2024 12:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707856635; x=1708461435; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n/wW7PIGgqQXSlQ0F7NCV5oNj8FXGjtLdH3aZqJKeHE=;
        b=OGvc+fK+romig5bqIBqGZ1YkPy0Z1tn5tatK5hK12CQ2kwa8qi/dBO2Q0QweD2y96n
         Rlw7AdKl9cqDNRHnM5ctbNAWGH/P6PKdQHDUZ7KRksC5r4y5JM52rmOGLym6wVD0Xqxj
         2rmMxh2kEFp39xIdQfJCVSgITdbw6RGO10HGTAhM5LJ0RWqGd3JkjH0ARMXyIJhAngVE
         U0Np6uWugRqk5eyVx4voKXvRepoRCb5KnXOfHyFlF4vTZ+4cogP1oOUgC3+w/y4o3wxD
         pjzPW/VSNaaR04ju2w0Kb8QoE8gxNcstluZunsK80UVPuCTYpJJJeETypTJbRLgnh9UM
         3pVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707856635; x=1708461435;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n/wW7PIGgqQXSlQ0F7NCV5oNj8FXGjtLdH3aZqJKeHE=;
        b=qZceGdeXzf4gwmKzdyru/hGQ7c2asRqbkYozmf89D8oltcyZvGWNMf5Kv2EgLAzhJK
         q6AtIa6WpTj0WlU321JmdfpusgpX73ch5FdQHDCziD7rb8aaL9ef3kY2PQdirKB+HxAc
         bmA/DxUcS1s4s7YRkjfN0Gq+pICNys/pEW6egg+kMvgAnLBi4yHuzLepGx58MvkwpHpG
         ErzIDk5FbmwOX3brNaGgKyFracZeoAnzPusjVh+SGMd3DnJ6sxTKcsJLtxozx2FekttA
         d9/l/H/y67noouhDuCBjhAfxAiX5gA4CCvS8aa3/Y1LxOTS4Q2kL5+EJLFxixlA2UePV
         4A7w==
X-Forwarded-Encrypted: i=1; AJvYcCXY1wyzkPGh9kbe5KBZfc98KqnPfi3V+q+VdnH9PlGrGEfNFW+IGw2Aljovmt9XjZHeI7E8VHqhdlNiuFgx6LhzOKWXdQZuQi2jMWAo0S7Ma/7HDCbBjwqResAJeNo=
X-Gm-Message-State: AOJu0YwyTWK/D8oJBCa7UfFDKQLkXhJ8fY707c1GmVyNpkx+z6AgTdj0
	X4foGneXhg4WHoZY9Fm/0wlIQx2bN4oAaUEaWWzotiWl2rYaHugHPy4olCwxpZUMbu+wF9Q/AF9
	HKs8NcneoPQshRN0Qf0e327ARKm0cLD5+
X-Google-Smtp-Source: AGHT+IE7LRxEWEyLjD3Dvo0o8c7YVHNu9ELBH7AyR73SwTWGh6EmoBFMKAf18L2S2tVVni7yUNl0BAAtY4km7kss1Cs=
X-Received: by 2002:a25:ae16:0:b0:dcd:3172:7271 with SMTP id
 a22-20020a25ae16000000b00dcd31727271mr445383ybj.3.1707856635046; Tue, 13 Feb
 2024 12:37:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240111-dvb-mxl5xx-move-structs-off-stack-v1-1-ca4230e67c11@kernel.org>
 <20240210162604.342349-1-ojeda@kernel.org> <20240212232757.GA3221859@dev-arch.thelio-3990X>
In-Reply-To: <20240212232757.GA3221859@dev-arch.thelio-3990X>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 13 Feb 2024 21:37:03 +0100
Message-ID: <CANiq72nYc0aVOwYKgJ13Fsdp84jZqxPsL=VdCQjGtoFdFVZziQ@mail.gmail.com>
Subject: Re: [PATCH] media: mxl5xx: Move xpt structures off stack
To: Nathan Chancellor <nathan@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, justinstitt@google.com, linux-media@vger.kernel.org, 
	llvm@lists.linux.dev, mchehab@kernel.org, morbo@google.com, 
	ndesaulniers@google.com, patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 13, 2024 at 12:28=E2=80=AFAM Nathan Chancellor <nathan@kernel.o=
rg> wrote:
>
> Thanks for taking a look, this is great to hear!

My pleasure!

I am happy to report that it also worked with the new toolchain you
just uploaded (i.e. the one that included `libclang.so` :)

Cheers,
Miguel
