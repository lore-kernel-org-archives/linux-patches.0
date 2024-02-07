Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B596B8002F
	for <patches@lists.linux.dev>; Wed,  7 Feb 2024 17:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707328207; cv=none; b=DeXVRDFaoUFHyuZDFGx1O0+xcTTg4JuhYPgccfIbbO9LPRWyLTcHeYAz/x6b1JorY7yEkt6vezkeWkKRp6hpbtJKFd31AEkHcVIod+E9HOPon0aunmIjc3RfYaC5dW7wNMq9Phx7gMF81GGnVbhGGvAwLJwW9Juuzfn84flPvDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707328207; c=relaxed/simple;
	bh=/8YYwTt1AJRdGmjsL44US76/DLuIf6PF+50fyO09ea4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Deq+D/4vIrrK4L9Akfhvk47QAKymT7wYvuCLYu+sum+oKAf/c1aVOlCh98ErBdEZO1C03rfa0xmgUVEOCwVODA52xnZhMtXjDHroAwLT6VbRcbUrFmz7MZWPRYCC9exEW5sYg18U1gVnOBvQBhaNnYzDvq4Llya7cE1k1JiPpPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kECpmzdh; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kECpmzdh"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5601eb97b29so150425a12.0
        for <patches@lists.linux.dev>; Wed, 07 Feb 2024 09:50:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707328204; x=1707933004; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=z2FSP0AMac+5+E+PTkV33ahdwTRCUgCpOnh1itA8xHg=;
        b=kECpmzdhA41mJHozqp+N019M0gZXbJbV/LADmQea/O3wTVwxdzbdFLPLNtyfxJobbo
         09XGSONX7Vj73cGfghdzp53lpr9v2QkcmKxo2IKhpwqQPX+keb4ZjIJDoX0fLOx1E9NA
         Y4UDIu0LjOFDAUxZe5405zqPfNUJ3758t+fRyso6CZTEcosGRr9v+v1EIMLe4dETEZUO
         T7UJ8/Nf1gcgotySdVgLOWyRdIlKvNXToiRJpK4KldPNoChPEZA7G+CsXRQId9aI1+2u
         yWFh5iJlGsJRF/GLMMXCs6ie/0k+p9D7BrQyfu8ssw1n/NUlqgY291tPuXDzWwIWBsoN
         oPbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707328204; x=1707933004;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z2FSP0AMac+5+E+PTkV33ahdwTRCUgCpOnh1itA8xHg=;
        b=AEgegSXtbJ74hz3Cvx4LePG4zRr1I85u3sx8Gd3M3KOREFTqGILFEb6mC72vsE31P8
         RCi+/OtRvkPI1HF93BFpQYHpJVOVusXxQfdK1ll/nla79dRuJ6ZvmyrkUeVAU8rqWCWf
         TWDGTqG2AmGjjhWlyZEUxIPUoKiBuF2u/yQYNk6hqwikr3BLV4y2tbAdsYMuO8DiTS6W
         Y8xP79H9MyeRwnvShw9AYDy6uh8tpKoUGwtnth8sKNItvA19jXDbzYsUmpChJ8b8Jy6a
         vkPlWjVrXmWVKz0nHIgnJxX4P7XobTa5zmkBLbPttu886BalQyD04eSjVKzhzDPJwo/L
         3lRg==
X-Gm-Message-State: AOJu0YzKGGS4TpzcUbsmBOJuWc/xPwvsALvXMY5f1/xTNHi4ndkdEQP2
	27dLTzSlqtua5kdzkS8MR//+kdcteJ+aA8Y8TCOG5eOK1V850ZPX
X-Google-Smtp-Source: AGHT+IEtzxtSoyL4zD0Jt8OZkZVEeLRJGCIq291CR/YkwkGPSz+ePtZ9DA9Nnme/DYNmlXmz/b00oQ==
X-Received: by 2002:a50:f688:0:b0:55f:ecdb:bcd5 with SMTP id d8-20020a50f688000000b0055fecdbbcd5mr277034edn.2.1707328203906;
        Wed, 07 Feb 2024 09:50:03 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXqyUnvdgxWOzQY/RwNTPGsjWaINK5My8em0zcGkd0Kqvnzv546crHfgdz0M+9z7P7MYE9pgGqMhf/0ky1S5mP8UXI5q5F6zqNq+TOT0cZNtkkrq21YiTJ3vImEHKGz7ZV+/CUhZQVw5OKnuvu5sLMXOwSXimkeep0rcROwrwg5Jb5xdGQSLCWiWc+cMSY+994ZrJK33/773HNVlOkkkt1WAPIcQHxUR0cifxzpHGlMTWykWyRuKZ/ZAuud07P49uOl8c5+TyKz0O4OYSJ1fPDtd4ZA/15g6rjBfsJQ7owj3R3RNl9mNI1RMm6nJUJetA==
Received: from toolbox.int.toradex.com (31-10-206-125.static.upc.ch. [31.10.206.125])
        by smtp.gmail.com with ESMTPSA id c18-20020aa7df12000000b00560f3954ffdsm180992edy.24.2024.02.07.09.50.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Feb 2024 09:50:03 -0800 (PST)
From: max.oss.09@gmail.com
To: stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	patches@lists.linux.dev,
	s.hauer@pengutronix.de,
	han.xu@nxp.com,
	tomasz.mon@camlingroup.com,
	richard@nod.at,
	tharvey@gateworks.com,
	linux-mtd@lists.infradead.org,
	Max Krummenacher <max.krummenacher@toradex.com>
Subject: [regression 5.4.y][RFC][PATCH 0/1]  mtd: rawnand: gpmi: busy_timeout_cycles
Date: Wed,  7 Feb 2024 18:49:10 +0100
Message-ID: <20240207174911.870822-1-max.oss.09@gmail.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Max Krummenacher <max.krummenacher@toradex.com>

Hello

With the backported commit e09ff743e30b ("mtd: rawnand: gpmi: Set
WAIT_FOR_READY timeout based on program/erase times") in kernel 5.4.y
I see corruption of the NAND content during kernel boot.
Reverting said commit on top of current 5.4.y fixes the issue.

It seems that the commit relies on commit 71c76f56b97c ("mtd:
rawnand: gpmi: Fix setting busy timeout setting"), but its
backport got reverted.
One should either backport both commits or none, having only one
results in potential bugs.

I've seen it in 5.4.y, however in 5.10.y and 5.15.y there one of
the two backports is also reverted and likely the same regression
exists.

Any comments?

Max

Max Krummenacher (1):
  Revert "Revert "mtd: rawnand: gpmi: Fix setting busy timeout setting""

 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.42.0

