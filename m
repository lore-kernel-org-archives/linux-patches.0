Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6257B277CA5
	for <patches@lists.linux.dev>; Sun, 28 Dec 2025 06:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766903691; cv=none; b=X92yEQ9N7ZIah1ypeEJlgy5+a1RivtWC/yeiCt23Bt6t/cbvb/z6Cw1WF9x6n4rz0pHmdR9DaI6xFYArukFEtvwODtK5/+LLKauiWiwCXa4VrSxK81TrtTrVT+lH0Us81jrjLB9+STVoQBh7BBsWTtgmRx7eCrtpQwnlo28wSUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766903691; c=relaxed/simple;
	bh=+dBgwafK1WHE+TP5vVX3Fb6vaal8og5lmnIAu5wHwks=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mU7ig9RWNaXPZsGbcdLVJJs2Jq3H1mBihPf1Hx6Fi4xK9IYyZFeWAP8gUII48yNogUqbD9FZUl3oY3utVCSEbF5IkuL/gLVKOdoS4njzoaJY+o2YgO4q6hktLIIKe57DXBN+QUbmbaWhIB5fm2FU6+fj68XHMV3Fdf818ndoheg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ePDs1A1Z; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ePDs1A1Z"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-595910c9178so6860501e87.1
        for <patches@lists.linux.dev>; Sat, 27 Dec 2025 22:34:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766903687; x=1767508487; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8ze4JDOO+w/8r4IHqJTt1vUQMM6G2qXdySjviR/vKtk=;
        b=ePDs1A1Z28k5GXBCRO/3NE64RkJCP0vOU6GgQX1fkrib0n7aPjwyQxouJsR7cZRUOJ
         GqfuUICe1oOTTL/5/VVdsfNRS/pEfiiGdbHztJB2JiIvWiZtZyOMTuBs2XcfvlewS3ih
         hqcVCkkWDFb+A0oJsTRWtFEcRpB+Ppqdl5C4h8H4AD7cDyIHOek12FHhbWCyU43oi7ZU
         jJkI7ZHEaVfa0i3G1FDgsnWHUlViUAzfCykF+uzD3OiiGJ7gqb7fll87cUudYz484zpI
         qqGWf8gjuAo5pitTWIxFZrQKJCN+e1Ckyhezglp8mPlqr8gR7N+DS5bV4gRySdTz1B+f
         Xftw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766903687; x=1767508487;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8ze4JDOO+w/8r4IHqJTt1vUQMM6G2qXdySjviR/vKtk=;
        b=V1iGz+1SD4TN+vpmHpV3sUACt6wbDAKCTCzV/g1oAMUnEvEya74SpKnRK3y94Oslms
         YBYYIvbcRFvu0fkEmDRV1Vfeifa1FtDtdATQBXms+ZTt9dvRygp5bOwXR95U/GvDbtqF
         iroslJDnd2RbHXH1wF0PnEuBajVBipyAs2iOcI0pgRyI5wa6LBNC8fUqp81Iwilv8HZD
         D+IZGt+Ui+jhW8L0tBaxZulT9r66XwTQGRLpfVthNraK4OKB1mNQTze6l5MRzZAc4SXo
         FGz/iovvC3Nw0lgHVBvmXfL5CKkrkEOd7+hGgAxbl5MJrONhyS8cgmn6XVRLEzfx/PXL
         tJJA==
X-Forwarded-Encrypted: i=1; AJvYcCWmWPJ2bS2KPntfBRxylYWrsMU5nRVPCFY+LUH6NugpOprvr3bJI1hhNyp6bosPUhy1Qmtnz+jF@lists.linux.dev
X-Gm-Message-State: AOJu0YzCNvZYnSboj2+FUu6zwfKfbuMyaR0QnuQSlGpbxzemQ7a6LXoz
	P3L605pEd1SZWnTVYz8UMpwQanmb4t7KZG1z4kq1bvIEcAgFxlOzRYp0
X-Gm-Gg: AY/fxX6/p/FT7zrT/YyJn6Q69qybYKlvQqecR9TSlU/F8vBxgbbe/egda70zyrPVeF1
	yaTyCZuLrOjV4Fnailj7rI/o54gNxpFptHL0hMWdnUYw2+mwpcXHoIR0fXgnc/UhTtk4QRHykHw
	PVdxhuo/9tSXzUjtyDCfPvcE0d8OZevlicHPERZPa0gQ+LvsCkR6/xtxCB0vCXpLn5aeQceY3sD
	w1p3zPPNtP2G4EuWU84IlqYKaThruc7Afn3pFnnvftTXvylEjpq4UIwXwBDLt7TyDvEavl0tDDa
	apS2c5po1sewItogCkFgilb4mHA/w6NQMCoC5n62aeLTyXJNJAKdDb8VvUvvuOerVjUQAXnOBN5
	tm3iixALlGkjSagxt0IvGjYifGwJy9W+W+EF48pGiObrgVuG8AAJ5o1Xl/imDMNVcdPgepRfknJ
	haJzDN1gPI
X-Google-Smtp-Source: AGHT+IEScK39qWney1DbtmJfqqJaGXJZQS1q/KrTQSNAdJiqhkIYncms5uKKRBKKHWTE3Ts9fsYWUQ==
X-Received: by 2002:a05:6512:3f26:b0:599:fe3:785 with SMTP id 2adb3069b0e04-59a17d65082mr9941339e87.52.1766903687301;
        Sat, 27 Dec 2025 22:34:47 -0800 (PST)
Received: from localhost ([194.190.17.114])
        by smtp.gmail.com with UTF8SMTPSA id 38308e7fff4ca-3812268ec5csm66332301fa.48.2025.12.27.22.34.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Dec 2025 22:34:46 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: Richard Henderson <richard.henderson@linaro.org>,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	linux-alpha@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 0/1] alpha: trivial: remove ^L chars
Date: Sun, 28 Dec 2025 06:34:39 +0000
Message-ID: <20251228063440.2623595-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove ^L (a. k. a. \f a. k. a. form feed a. k. a. \x0c) from arch/alpha.
I'm attempting to write my own tool for parsing kernel code.
And these characters complicate this without giving any benefits.

Askar Safin (1):
  alpha: trivial: remove ^L chars

 arch/alpha/kernel/core_cia.c      |  6 ++---
 arch/alpha/kernel/core_irongate.c |  2 +-
 arch/alpha/kernel/core_marvel.c   | 18 +++++++--------
 arch/alpha/kernel/core_mcpcia.c   |  4 ++--
 arch/alpha/kernel/core_polaris.c  |  2 +-
 arch/alpha/kernel/core_t2.c       |  2 +-
 arch/alpha/kernel/core_titan.c    | 10 ++++----
 arch/alpha/kernel/core_tsunami.c  |  4 ++--
 arch/alpha/kernel/err_common.c    |  4 ++--
 arch/alpha/kernel/err_titan.c     |  2 +-
 arch/alpha/kernel/pci_iommu.c     |  4 ++--
 arch/alpha/kernel/smc37c669.c     | 38 +++++++++++++++----------------
 arch/alpha/kernel/sys_marvel.c    |  4 ++--
 arch/alpha/kernel/sys_titan.c     |  8 +++----
 arch/alpha/kernel/time.c          | 10 ++++----
 15 files changed, 59 insertions(+), 59 deletions(-)


base-commit: 9448598b22c50c8a5bb77a9103e2d49f134c9578 (6.19-rc2)
-- 
2.47.3

