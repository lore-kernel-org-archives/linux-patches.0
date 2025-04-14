Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BFD827B513
	for <patches@lists.linux.dev>; Mon, 14 Apr 2025 14:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744641755; cv=none; b=WkpCHx/fbNl22wh6V0tU2RL0zs2qj0oROtnOW/7JjehPmr2yBZAJI15omI7xEAMEwfZ/f5EdBX9KFjq5MvA+nhAGhWQW0Ua2uE0/1bVzwOaqVa0Xwe8U+W3MMFaMgR1L2Y3sfwK/AYrREgNXKljkMBwprbilFt/r9LUSkpDzpZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744641755; c=relaxed/simple;
	bh=djtPIricfHsVI23PycDI/GBe8v9Mj3BQR5+LxJFEu9w=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=Yy8Szjo28KoORXyfC4cpiwIluJy9vLuQ+/4d9gCFKugRkb8FJZaTBjxDQZj9/EAkJ27z0caSiiHurNPlnk3vRcN/owEBSkN/1oCqwaHzEvKf8CeMdPc5xQ9I16e4ttQSDfofzhm8ld+xgk7sDCavftahLcSnszYSbhMPpP9Eqa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QtlytO3N; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QtlytO3N"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5f3f04b5dbcso3000663a12.1
        for <patches@lists.linux.dev>; Mon, 14 Apr 2025 07:42:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744641751; x=1745246551; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=djtPIricfHsVI23PycDI/GBe8v9Mj3BQR5+LxJFEu9w=;
        b=QtlytO3NdkucWHzyZi7k1dmNvBXjsr6ngLwEKT4LeL+BxohNKZw5eQV4PRpbMEeuYE
         6Ca67om4bPm32n0Eg79qRuJp+iQbwG5TXsKdpQ6vvhARtrtFvGK8Jy06RanbsxpwLtuh
         WsGzOnPNLfYCUPAkcos3NIP5ClPOfv5x0Igm3SPupgH1jXd/RcZUuiJovBXiXRcaocbM
         +2iWRN5b7tNErH8192yps9Sx3cWm/gGMp65sXwb5juJFBfOj7jh7frpG+5HKZXQr0mgF
         6UkreF9eFgyQZw4vm3aZRG+Se6Rp+HgHO05PM5NC+bp1gILNBCGYf6HPSVoMBDu+tF9T
         85Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744641751; x=1745246551;
        h=cc:to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=djtPIricfHsVI23PycDI/GBe8v9Mj3BQR5+LxJFEu9w=;
        b=DHUr+uf+J0TYGACBC7Pv/crYNKxtPo8c7piGjuolVkJSPFkiTv8FuKLdtawR24pgsr
         8txVTok1jOLELGeec8PcbBbfn5VImyYlaAiEu6AsfgLa+IrfYZn4If9jiXdQFLRVm3Ea
         ZLvZeXUTuS2m/fVtzI2c7+fddibjadwZPGIfv+8DJj1LgB+lABe9HjH0EuZrNcIgIhYB
         Z6z2Dmfn3L9ebcR/+57aCLRAzI2shUbw0c2dpA65sXjIFOykKS1lVToHl+hubkGihQK1
         VX61cdiqjpdopWE5ZLTBu2Ht0oQJfcRnakOyZ673Tp0EtDPwzUTrPTDw0qnwcj+6KZ40
         SMqQ==
X-Gm-Message-State: AOJu0YzFk2eY72VF1s4gWj+0yKcyyXSkdysMoQOuveXWEYyrhaDfUGbA
	96wqAdsmIBBEgBKE+GRwb408gMPtaCrFN6LQ76eEUX5yi8+Rwe2F0khXr772VwaiHpHpVlTqUiC
	xFGDrrdScrhfKozCaKlNroVUQVjw=
X-Gm-Gg: ASbGncuwoejlKSgHvLimtp/JhYOiSyPVr4fX0xLKQqOT6/cqtUp6G7FuJgs739y9pXr
	3C10CEhlceUJcPOi0SoPMHoerOD/4a+f5MZMm/FWpVFeKDgw3HuItXUDulw9sDfiSunSlpiB2d7
	I0lBcKta1VvbPCCynxvmCYSA==
X-Google-Smtp-Source: AGHT+IFsEcGGKysAt2vnofSURYifpIKNzH9MB3cjbD3WlRr9gBUyEtpSG8hJvd0FN0uCbpU39LWRCsSE6cXDMGEfYF0=
X-Received: by 2002:a05:6402:845:b0:5ee:486:9d4b with SMTP id
 4fb4d7f45d1cf-5f37014465fmr10040923a12.34.1744641751210; Mon, 14 Apr 2025
 07:42:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Reply-To: ludloff@gmail.com
From: Christian Ludloff <ludloff@gmail.com>
Date: Mon, 14 Apr 2025 16:42:20 +0200
X-Gm-Features: ATxdqUFBVoO29GwOxxkKyUuhT2RpIRz1JcuDmC5FOD6Sg1krHAdXW8vFt8lFRwM
Message-ID: <CAKSQd8VKwk=d+ymSp8t3Y6n+pJP45FRXJXWRWmzc4-DTm=6f9Q@mail.gmail.com>
Subject: Re: [PATCH] x86/cpu: Add two Intel CPU model numbers
To: linux-kernel@vger.kernel.org
Cc: patches@lists.linux.dev, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

> [...] propose we do the below.
>
> +#define INTEL_DIAMONDRAPIDS_X IFM(19, 0x01) /* Panther Cove */

Make it so.

(In light of the fresh RPC = RPL,BTL mess.)

--
Christian
