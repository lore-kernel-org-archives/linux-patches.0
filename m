Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E7E848E
	for <patches@lists.linux.dev>; Wed, 20 Mar 2024 14:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710945111; cv=none; b=qR/eEnL6Vr9JICIeWf9HNEIp+vgICwv07IHSKHzg5MQ5VmZ+zLPnXC8SfVlHbP/RAFKeFuurjizlTy0SOTCUU9smtWNqboX2uKKsOPSps6KzXIRI56dwhFvkqx19T+WDE6at+HYVefeRL8HFduYbONFtHgz2VOQbX9tDrCJ28YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710945111; c=relaxed/simple;
	bh=qodn0HWT2NxPcmvoeYPkM26Q8diisbuBZbvrENJf1/Y=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TyUebGSwKO4PtM082VsVK2mo5gxc+hkLu6grcXZKfFhTyuWLkqwVWglcQ3SNnTlKssx4RGvddnHyXYorf0vm2u5HlOCWCWfN0bENPiY95t01/ceiaTKxNyerJyMvwfGHkb71i80xSsdJhWTXtgLI90WY5VSnxtsoFBLaqoEjJ9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zvvfthDX; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zvvfthDX"
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-3c396fec63aso748002b6e.0
        for <patches@lists.linux.dev>; Wed, 20 Mar 2024 07:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1710945108; x=1711549908; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/bYOBDcymvYGp78k9DLmQb5D/9HOUP25d/CXpNGP+TY=;
        b=zvvfthDX+Qh4kL7HPuvYmWooH158OjObRWkJ28eVriEOQPN57Xa2P0NLw6YFqaVMKH
         xeH7XTvlu00s9mATizpH5lMZNeo1BC6h7DKyn13+pUiKOTYdIVYFjszfttaKguEJN8uX
         SzyPSb1HwwjkCMG7jStmOyPmENiqcul0vwPcPX2BLNvWt660abpmguRHd0RMmttTlwBC
         c5dchiUadYw/x1C9tA3Rmt3KqhztRXfDO4VUGBJIV634Vu+X5sAl0pc2AcMqIKS0Rl/4
         VW12ZP4AeDt6S/eIVy+NdUWGPhwzCOrwwxvIEvmDLZgarisjor5K+F1M6C7/0WSz/qGb
         4fGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710945108; x=1711549908;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/bYOBDcymvYGp78k9DLmQb5D/9HOUP25d/CXpNGP+TY=;
        b=ABaUd2sXkgpeu2Ej9B+Hvmvl5WM5LyeCioC4Gfj2iY2RrD24RdtjbBLM6j7F8gu1rw
         DkQd0J5SzAd8mzSmtwrSvZtIB5IXEI7QG5g0anXJV6UCcQacXT5SG+kxX8FEPzY+wfBt
         DnAXMQe5N9IBCin9rYmTQJCQKpL0svE7z5vkBJHR8G6XLy8ZcIBdg+6j3MHj2g/oLhWp
         bqHlOM0G9gOw6ElxCeG4gK+lH2VE2Ed/E4dhakgvzAtPW88hC27ETdo9LAmE8llYOS8u
         0h+AbMXRzG9Ek6Rl/FHsWm10tVn5wAaQvFUfz2CQBdHlzT1w4LnGzN6eE0ymnFMlv5lo
         sKTQ==
X-Forwarded-Encrypted: i=1; AJvYcCUqeJiwq437/LzFtmfsM6hG2M2PteyLHlIsR+vA1zfNcbtbKghuLzrk9pB56cPX8UiNd7EvPF5S7ZaTRc7DtD922WW2SyiK8A==
X-Gm-Message-State: AOJu0YyQdMtgJlArwTRu6P1Czf48b/FSNgwCR7DDcfIWFsYK1rQ/oU3C
	0mKH+smjFI/ZokD5P5Y4yaVVwpnYmjiBU2TYGG+M1fu5DscjgYCWmeCuoDgjn4U=
X-Google-Smtp-Source: AGHT+IG4f+F2qucJVV9FVBes2/YroVqIfuUP0CwK01ziUO7zee4tZhWwEr3MnA5b3XjZeI/FRbG/sg==
X-Received: by 2002:a05:6808:1523:b0:3c3:87c0:7369 with SMTP id u35-20020a056808152300b003c387c07369mr10478864oiw.7.1710945108603;
        Wed, 20 Mar 2024 07:31:48 -0700 (PDT)
Received: from maple.home (bras-base-otwaon1102w-grc-09-184-147-116-200.dsl.bell.ca. [184.147.116.200])
        by smtp.gmail.com with ESMTPSA id ff16-20020a05622a4d9000b00430cacfe532sm4331700qtb.79.2024.03.20.07.31.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 07:31:48 -0700 (PDT)
From: Ralph Siemsen <ralph.siemsen@linaro.org>
To: gregkh@linuxfoundation.org
Cc: herbert@gondor.apana.org.au,
	patches@lists.linux.dev,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: v4.19 backport request for crypto af_alg
Date: Wed, 20 Mar 2024 10:31:43 -0400
Message-Id: <20240320143143.1643630-1-ralph.siemsen@linaro.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I have found a regression in userspace behaviour after commit 67b164a871a
got backported into 4.19.306 as commit 19af0310c8767. The regression
can be fixed by backporting two additional commits, detailed below.

The regression can be reproduced with the following sequence:

echo some text > plain.txt
openssl enc -k mysecret -aes-256-cbc -in plain.txt -out cipher.txt -engine afalg

It fails intermittently with the message "error writing to file", but 
this error is a bit misleading, the actual problem is that the kernel 
returns -16 (EBUSY) on the encoding operation.

The EBUSY comes from the newly added in-flight check. This check is correct,
however it fails on 4.19 kernel, because it is missing two earlier commits:

f3c802a1f3001 crypto: algif_aead - Only wake up when ctx->more is zero
21dfbcd1f5cbf crypto: algif_aead - fix uninitialized ctx->init

I was able to cherry-pick those into 4.19.y, with just a minor conflict 
in one case. With those applied, the openssl command no longer fails.

Similar fixes are likely needed in 5.4.y, however I did not test this.

No change is needed in 5.10 or newer, as the two commits are present.

Please add the two commits to 4.19.y (and probably also 5.4.y).

Thanks,
-Ralph
