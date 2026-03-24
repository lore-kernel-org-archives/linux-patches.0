Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80B93A3E67
	for <patches@lists.linux.dev>; Tue, 24 Mar 2026 05:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774331296; cv=none; b=XqDIqfjFVLWELGOlfk0xyyxLVYG9yV2b2919qq7gPHqtYfeBcZ1CJn+0LrUVLmb3zLenZo2ha31vE49cgxkIr0DDinHoAZdnoc5ny72pxHAHJuyXqliUTONsmITViCdQkRciNDLFSw3hoy/J092I4A7GbhVMV4wIN2rkk6lEk0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774331296; c=relaxed/simple;
	bh=SndHFF1+to8KzMdmPz5N+el01Ad0vJk3qbBVeWcxGns=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IhkoA70he/qJYrJYs+TuFqADWQZyaBaBao9YrLd4K4duCiFP0tn/zRAG0z5oemlBR+ryQ/hgBmEbWetC4OZjYj7humVkTdQtuLCprJnLf4JqiuuEm9me2i1Ow/vb0HuREp/WFW3bHDCdyf/ZabKFvJWrko1lKEYJGtYM15ia/JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JfikYLtu; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JfikYLtu"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-486fd27754bso6929375e9.3
        for <patches@lists.linux.dev>; Mon, 23 Mar 2026 22:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774331291; x=1774936091; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rolgU/W7afX3h7P7QCO1z6YnDyhgQdhfop9FHg+Z0U0=;
        b=JfikYLtuWcDnuahXkzQy4bIXkZkSGZ5DUe+bFcU8VAeoId2DRsj08tpXcpmHf0yxFe
         VjfcilBqC6GC7n2APLPM7I4W1LP4OpzeYAejtBQ3f5Uf/zJVa2ddentzBsr7oVUbS7LF
         GNum7HyJXlwyrGOE3uG0SwxtB7YbEEwvSkQAhaQhnyvfjjVcWdP23qk6xkaQTt4YvXKX
         XI7c9R3k85Sm/oNK+XKlpsKjlCLhT83moNNeHgPU5NtUqfe55cA0kuisgI9vmYrO1k6f
         vewXvmYgeWffk1UanSzEMy/3NJCRZzW6v/hw884sS7ugNoz1l/hifFYWOjJsswrbm9cL
         FK6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774331291; x=1774936091;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rolgU/W7afX3h7P7QCO1z6YnDyhgQdhfop9FHg+Z0U0=;
        b=GVpK3z9836d0Cnpz/eopBXDmKXirCxcwy+kgVws2mB8PGnt5TvCRsVhzYAUtcEPQPj
         Un8MPMj+/ZFijp+Q2GwV/dcwnCLx7qjmCMdembZTaVKpsO/GGbNHOx+luQaH/Tz5Odh5
         qOgHOGVyzk+uYH2J6s9739wx0M8wEIgHufUJEWK1aKKbLn57pkADDy4ufnGcTnSOHdLf
         qCakVICdnNbBYEUi1A8gOp12UaaLie63c58NHXrUJ1AC6caZtt8IkH9vmbtUN3pPsKpH
         l40f7muk1/0N53jPWF8lJ/OappMbJ3nRtGI2O0zTqFXPh/BPmOWUpqCW9lWkhfqronj0
         UzkQ==
X-Gm-Message-State: AOJu0YzkwP57v8KlGrC1wIGaaDy6JDEDAgdcGeQPK+Tek5yZ63/KaRN7
	ux02oykV9MZrr/TtlqHv+KEG1HC1EFad1hNmdxu8p0y+8v4rCmK4IXu/IgsEkw==
X-Gm-Gg: ATEYQzydxkNJt4RTRDtkI3AS9MEzSWBJVYz5/3M0R3N3+BVqo83727M1DIhVhyrqCPY
	CojCxaUhuf/ynG2GzFcSx9IMVLZE8yJKuU9e+Crmz6vMif7cxz73EUilLo5m+x0g43gKu8kTQve
	rP2auncfaUmRFQ80LvKrpp/oYEQB6YsPPPoP7IB3sgdA7MrkvhSfKalBQVo2KoBrkVKQQ6RXTxL
	868tl6fp0bRCSTwoGHuN8B06qtzVrZoDQIW0ePHBy0DFXaq7YQrww3jlLSJEysW2rNrbiZ5Wh1N
	7U1yj5tpMEdbFWEyIq3MDe4QSTqIl3o13QvD/HIWnGi1BoWD2ExBOlBPf5w1a3aF8bBI/bUEzPk
	3olK0X/HweDBtQUxwkaMFmy2+6yuTUVMCRLFiSk/n14q/RDcUIRytQl1VxmKgZC1ys512mR6/ig
	aWewZybmD4JsUmVviNsac=
X-Received: by 2002:a05:600c:8b31:b0:485:9a50:3369 with SMTP id 5b1f17b1804b1-486fee304c4mr208108905e9.29.1774331291127;
        Mon, 23 Mar 2026 22:48:11 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-487110115fbsm17566555e9.8.2026.03.23.22.48.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 22:48:10 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: linux-kernel@vger.kernel.org,
	Joe Perches <joe@perches.com>
Cc: patches@lists.linux.dev
Subject: [PATCH] .get_maintainer.ignore: add myself
Date: Tue, 24 Mar 2026 05:47:47 +0000
Message-ID: <20260324054747.3171493-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I don't want get_maintainer.pl to automatically print my email.

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---

Joe Perches, please, apply this.

---
 .get_maintainer.ignore | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/.get_maintainer.ignore b/.get_maintainer.ignore
index e8d2269ba..2d03b9dd9 100644
--- a/.get_maintainer.ignore
+++ b/.get_maintainer.ignore
@@ -1,6 +1,8 @@
 Alan Cox <alan@lxorguk.ukuu.org.uk>
 Alan Cox <root@hraefn.swansea.linux.org.uk>
 Alyssa Rosenzweig <alyssa@rosenzweig.io>
+Askar Safin <safinaskar@gmail.com>
+Askar Safin <safinaskar@zohomail.com>
 Christoph Hellwig <hch@lst.de>
 Jeff Kirsher <jeffrey.t.kirsher@intel.com>
 Marc Gonzalez <marc.w.gonzalez@free.fr>

base-commit: c369299895a591d96745d6492d4888259b004a9e (mainline)
-- 
2.47.3

