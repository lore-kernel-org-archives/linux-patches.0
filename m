Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7505B645
	for <patches@lists.linux.dev>; Wed,  4 Sep 2024 00:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725408952; cv=none; b=R/PwzsTw9p1qApzK0h0it2YPoJygp1yTqWyU2vqIoB8XXiWpT7Rxk2LUveulTa5h0n8CASa57Wk/pdTnB2viw+VBh/U9h4fbX824+OwxTmFEG9IPBN360zDMdm8JTT99IJQo+4ZMdrx1f0nZFaNMLXG52iv4TAER5m6xod4R6/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725408952; c=relaxed/simple;
	bh=d4HzHlcyWhxhYwrf+ZdncBLTDdqhz1jAA19ceRLiAdc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EUu+ZMunhGAgbqp4AeARkXEqSBeOzod6JpNsAlnuUtHXgoJlmy6XzU0L3Az2IUCM4K4ZE+QLcRTviHQRUYMFnBFuTYLDZIPLAyWJqVtofGbFMc9s7mTMAKzDTo6ozAxScJoGotUpgX+VCSX7pp4oii+9aZmRXrlxGofuIALuv18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dksDNLL/; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dksDNLL/"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-7cd80d28743so677439a12.3
        for <patches@lists.linux.dev>; Tue, 03 Sep 2024 17:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725408951; x=1726013751; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NvNhaHXkaFL0Epr1sED0M5HwOXo21A0WSrifM/juZnE=;
        b=dksDNLL/EGdzj9RjDD5YHqcUXYCTPi76oetlhQB2sZESXg3/S4P4SwMjSMvh3XMsEP
         xV5OSpu5+5fP8mRas9kZ2Vl7WTagrSKJU5tnyIILcT3xONxGmCj9uDFh/0J/2n2FtfU9
         VtO1DicfwPLYWZBcygcJ31XsTkBnWermNcW8ce8Wc75/dNroO2RrYFvqndFOIx++Ggfk
         YYPRl5Fek9Ed/ZBm0DqhhKH2oUEjWW4MPhrBUpYaZOSCFweBEcFD5DjOP3NzGWbRUCYo
         kPeRbGin0MjYvdRMi26x/7k9diZGM6DYZF8wuMYHrGMjJZBwnLzo8AGo782EbyjPdCrl
         aWTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725408951; x=1726013751;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NvNhaHXkaFL0Epr1sED0M5HwOXo21A0WSrifM/juZnE=;
        b=iyDpJ3qZyq74zCH6YwLccVGaIJ7vK5KXyHGI7KvOtAUdVnNzPmyLq/2ReKEv4uMP7C
         +dGyA+aIsjT1yLWA66Nn1lndOulG0Jp7rHFIQ6PO06hBL7CO0ORnLvliGNC2hPS4xTkv
         +d7R285UxF7EU1WjyjZTZ8rN/iRjxp+DUN7b/6bLpURZhHoC13o1FSuuaRd7e2HNThVh
         HksERlHlbiR0Z+PwinP0b00jzSD61Uryc1x346ZX+Zc9e0Psa/7n0hG3Y0IFkh3tTsrA
         ImBoxc+fpn4Axm/TYoNR2MfOHo2NgTqbTY2H4UECMsmHrjmN814l4vnW1XDFjCLkQ6ie
         BMOQ==
X-Forwarded-Encrypted: i=1; AJvYcCWVm5K3t7G7tRAQdQRn+mq55L1KnOvynt2oAmSvv36QAK10DpeRzAKw4cO5JKP2bXhoTo82DnHe@lists.linux.dev
X-Gm-Message-State: AOJu0YynTOQXQmsfhh5EhypJWC1FQQtTx+0RpZB4JyoAdcg6GIPcmfkG
	nT2aGigL9kuqiiDVQEhJiS4xZFDZBvKsz39Gfs+dyrBuxqhDgWIDLCkSv7XjIbNXf2xiHHbJRxc
	drXlJlhiDFDvtET4M0LCFQA32TRo=
X-Google-Smtp-Source: AGHT+IErZy5Q2Ts0A0vkjKg869s0jLwCVRYZCjG3no5WSj++BQIHoeXoTs1Dabp+pzStx5LKZYTJqtuSltaEX5UC6Bk=
X-Received: by 2002:a17:90a:157:b0:2da:71f8:7ff with SMTP id
 98e67ed59e1d1-2da71f80949mr1686174a91.5.1725408950587; Tue, 03 Sep 2024
 17:15:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240902160828.1092891-1-ojeda@kernel.org> <20240903-super-elk-of-bliss-eaed2c@lindesnes>
In-Reply-To: <20240903-super-elk-of-bliss-eaed2c@lindesnes>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 4 Sep 2024 02:15:38 +0200
Message-ID: <CANiq72=KrOnx1utXaM17x07B=V-6zmW5nA+zYKS0AU8Rd+2v9A@mail.gmail.com>
Subject: Re: [PATCH v2] kbuild: pahole-version: improve overall checking and
 error messages
To: Nicolas Schier <nicolas@fjasle.eu>
Cc: Miguel Ojeda <ojeda@kernel.org>, Masahiro Yamada <masahiroy@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 3, 2024 at 9:49=E2=80=AFPM Nicolas Schier <nicolas@fjasle.eu> w=
rote:
>
> thanks, no objections.

Thanks for taking a look!

> I'd rather like to have
>
>     output=3D$(echo "$output" | sed -nE 's/v([0-9]+)\.([0-9][0-9])/\1\2/p=
')
>
> here (thus, explicitly check against a two number subversion), so that
> we can detect also versions like 1.100 or 2.1 and bail out.

So I didn't change that here to avoid more changes in the same commit,
but happy to do that if preferred.

However, do we want to make it too strict? i.e. I don't think it is
very unexpected to get v1.100 or v2.1 -- it may not be what current
`pahole` does or ever do, but I am not sure we gain much by being so
strict.

(Similarly, for the ^..$ suggestion, it could be that `pahole` decides
to to something like `pahole v1.25`, i.e. `name version`, like other
programs).

Either way, I am happy -- I doubt `pahole` changes too much, and if it
does, we can change this too.

Cheers,
Miguel
