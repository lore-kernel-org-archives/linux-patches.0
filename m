Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE27213E89
	for <patches@lists.linux.dev>; Sun, 11 Jan 2026 11:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768131623; cv=none; b=TPNHmLGyGCi9st7HHvzbn0eHL5UPaRXRq9/UlUeQXOopFA9lGJnY/LWxtUPs7EB30ZNnd53FVDHJu4Ad+aHbQkSU2rpm/mc9jYStbqctXam/O9GeX8PbtwDWlN9QqVKLGihGy0XIQFTc7AqxTbL1NKc/BvTAMxbGLk06n8hz8WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768131623; c=relaxed/simple;
	bh=Kriie/6edt/7mMffISeRAPE2MA8cV+NLr39NlAigjHA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JhzBSYPyafd1Znf6OS1Ciw69owKM2ipcUMYBwlecnVilmfBQsJITyENk1jB190HDwn3UUDEtM0uEkIPc+1defAVSJ4bgAGSiGB1YkmTd6fYsYtGMhW4adbGlYE5LDIW9ltuYosJJdP+cxdGKGVjd1ZHEsFa91UhKFUzyP0K5iDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W39lio9Y; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W39lio9Y"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-43246af170aso2440651f8f.0
        for <patches@lists.linux.dev>; Sun, 11 Jan 2026 03:40:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768131621; x=1768736421; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sRWWv+edKn1RAkq0Hog4MX2cR+uiFgVxQ3Wo8SvjN3w=;
        b=W39lio9Y+DyjX1QQTDkbhfzX2Rqj6BfsWAmm5stIT0ZU+5axnqU/AKKA/eaTbraku/
         Quc2B5mHi6GyWuqbDlEjvA1zyY9z0GnDC0ouXcc5A0b6fIIF4b0w+vD716UpdtwORbOc
         iw/Kh8PsU0EL45HRrP2bNgm/aCsLautmxe+40fhho7YnTmnbgdQ1bccebwvsR/otlyZM
         HpfxbcVYULYh4QMst+HQ37zkcPLHkli6sreXPbbug5aRN0ARdLA/SNK7THRAeGDk+L7x
         R4TlKaQJqNxafyARKFNNUFTjEmmW9G/DXH9aEg/EEOzqZggKJ7qPdvb16mF5vz9oKb+Q
         c9GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768131621; x=1768736421;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sRWWv+edKn1RAkq0Hog4MX2cR+uiFgVxQ3Wo8SvjN3w=;
        b=JziMIBb6knl7a4S9H+2Aq+E6sPYqOXjzH2OGmWz+5gp49NuzNfMkwvc7r147/MA95B
         RFUIKY9qg5w0yJ2ZxjIa3bUIYpQIPRSJUKMb2MwhA066+DO7S9Hl7XM01/flaR2WgW0R
         XsA0OQwZBRJHH1zIuSjSOBpzA8UQ2Y27ZXs3iFj9C6ucqbZcuHXC5If19GtXBaYQb1hj
         AFJKtwhPL2I4/bjDjyDUG7IHlnhp9+4MG0E7Fmh1uBBWkPGZF15lPsP9liGiMuNnVfxv
         xpy6lQcXETsxaPL51QlVOcAsnm1EQi0oZe1ky7nRnM5+Z8jTjwQaC1E4WBrxcQqiAEq9
         Y8ig==
X-Forwarded-Encrypted: i=1; AJvYcCUU2Ps2UbILS79xqCD8kSTnrU0to+71klpuL578qJ9t45i5M81UVsr4TAEwsUhXSK4FD5ZWg768@lists.linux.dev
X-Gm-Message-State: AOJu0YzhuDDwCZyZc0YcopNBgRoToOg8HBDonw7uNkkhILUe4vMt1BNi
	VhBmkc8zQphXKv00zfaa9Glz9/z3XvSj0kgxH1Bz/rU9WKA9ngilePj6
X-Gm-Gg: AY/fxX5sxeN8fSUSAZCHXvfVKjM/ExM324W6B9/p4mUyHCVP6PBvLJMfzeLkwHTijRY
	Qf1wBjvoDmgm2mkf3CVTVAoheCHG9yl4/z8c1RUMD0dBMgji4nxrQsEcuExVOuvZC050zxbalC2
	ihmvyKlNl0e1YIcS/1xWSKeKB4OX6czFt/aEVI1gIj0WbASuahu42sIwRMI7P6UmRB8B+3J+9tD
	EcCMp/E/oNy9SJdPZV3Se/yTEsO36jMQP4KXmxdcXg7a58AjnDMgyxI55FyAlrPUEUBwd2gT2H6
	2/D34CqWJJeQ35x0KagXN/+RoZiMfNKVT6otQC4jmTIbmWzcS1Ipu7os0d7+M8hs3smx43te9Ac
	+i4IulFvJQmuwYvyOvE72l3ea7PS9D7pG41pq+pNL8C/wJFE5EVHlRL5JbJ0sn3hYanE6XDOv08
	A+Q0hLsvU=
X-Google-Smtp-Source: AGHT+IFIQWniWCR0b7UwIF2liKWWRST+AkRUHhrE04ivSpJiR1aQuBYGg13Oid8yI/q/HQk1uOYN9A==
X-Received: by 2002:a05:6000:2c11:b0:42f:b6ea:5e4 with SMTP id ffacd0b85a97d-432bcfe4a7dmr24434176f8f.28.1768131620552;
        Sun, 11 Jan 2026 03:40:20 -0800 (PST)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-432bd0860f5sm32471694f8f.0.2026.01.11.03.40.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Jan 2026 03:40:20 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: Richard Henderson <richard.henderson@linaro.org>,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	linux-alpha@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	patches@lists.linux.dev
Subject: [PATCH v2 0/1] alpha: trivial: remove ^L chars
Date: Sun, 11 Jan 2026 11:22:16 +0000
Message-ID: <20260111112217.2126872-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove ^L (a. k. a. \f a. k. a. form feed a. k. a. \x0c) from arch/alpha.
These characters hurt general readability and editor compatibility
without giving any benefits.

v1: https://lore.kernel.org/linux-alpha/20251228063440.2623595-1-safinaskar@gmail.com/

v1 -> v2: changed commit message

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

