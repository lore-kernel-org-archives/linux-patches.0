Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536C51DF666
	for <patches@lists.linux.dev>; Mon, 19 Aug 2024 23:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724110592; cv=none; b=q6D6ImfQIo39XfR/4EuhTA2bH8sUrL+eo8INCiflgyFu8pqknhEpb+SggEOKmlCAkyZ8U6ImEz9h17w/ycx4APfI6nmv+i6833sc0/nWLkdx9KbUXlfj15JKBBl8XipTwpubbR+IdQ5T/fMBm+3ztsfSHEKBjl7l83PCmVXHZFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724110592; c=relaxed/simple;
	bh=bnMnLpZp/vOPSEYX30lp0wp4cH4DtZ+pQAK/e1kQwZY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OkojSsTNdp/bj2yBOe460Os/O3fKVRqCPgmxFarrYMaexkmi5OkRn76KY7gQQINaD/IrJ+v2hzMHdU+Aw7bLKygfNKAk+xHI+zMxsSl6rrEnpbdlEmzkKCrgS7iYEU1ygUbXnVc7jdWjFshxF3eP5osgxOWKBIC6H+hmnQLIsdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=WWsTYQlz; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="WWsTYQlz"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-201e64607a5so34190855ad.2
        for <patches@lists.linux.dev>; Mon, 19 Aug 2024 16:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1724110590; x=1724715390; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BLDC5jns3s4C83X1DcMxdP9cS3cEbuLuxiBTxLxZvgc=;
        b=WWsTYQlzkAcoSfKv+lYe4ks3YI1yXJnVSp6tA3/xEXkvo6FVmi/vSthRAMdL4sNt0K
         SDlWFV5MTaMKSkvtgDiYZQbbTFJjWsT5aiB+zd7RHBQPBM2At9tl78j/89EPNJBORH/I
         BgkcP+QZZcHTyrYkbRCcYESNou/OQdyGmM2wE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724110590; x=1724715390;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BLDC5jns3s4C83X1DcMxdP9cS3cEbuLuxiBTxLxZvgc=;
        b=T80MjJ0jrlUMDSbjQlMcaFZTcXzxGBZGoGlPdcoQA4kalscPhXColAAzsBEWTD68HH
         IzgRR/FumMnH5E5yqqFGHwKOVN2rA9rs8/BvJ6r9Zo526kWbfw+UWJossxaVzO+pBMBf
         dNCrNNZkhQDam17R76H3Z0Ll8Q37PeK+RyKQyv+vIt35FISDSCLv0Hh9B/vQ6DW3akCs
         UNBxKy3+ejNec+HpUr0HfSNeDuWFJxb2NbXcF59ArKhGYFDZL9cLJ/ej/k0AIP0MAZk8
         MdCm26REB1ZfmZTXPN4OJLmPk/mz8PXnOfzLcZkUjvOvL5yObPnRkzTGiAn6i8ogFzzj
         VKMA==
X-Forwarded-Encrypted: i=1; AJvYcCUcTl7Y8Urupx+mzRfqohKKhMfmz7qJCmieNjcKxVoaajOCYTcAE1G3PVUqTkAZT7PKMhpTjkpAEJeB1hioHXYY5JnRnroG9A==
X-Gm-Message-State: AOJu0YwcMmJXZ7NLKwt++0wS1zY5M/Sv2pmtyC8ctycFVzi2W2eU4NNO
	DXiZFiGnq9IU9Sf+TwLGB3AYwKXgnnUBS37lfcFIWffOMMncEaL5xtLO0mvu7A==
X-Google-Smtp-Source: AGHT+IF+AD7Zm81meDhqLkHnYjIPgLHIQ0TzFtOkcrvdzaom6Dh2akLYWZlQIUgyro2on4aBmpYOMg==
X-Received: by 2002:a17:902:e883:b0:202:3dcf:8c47 with SMTP id d9443c01a7336-2023dcf8e43mr59296145ad.59.1724110590261;
        Mon, 19 Aug 2024 16:36:30 -0700 (PDT)
Received: from localhost (210.73.125.34.bc.googleusercontent.com. [34.125.73.210])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-201f0375acasm67703585ad.161.2024.08.19.16.36.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Aug 2024 16:36:29 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	patches@lists.linux.dev,
	linux-clk@vger.kernel.org,
	Amit Pundir <amit.pundir@linaro.org>,
	Taniya Das <quic_tdas@quicinc.com>
Subject: [PATCH 0/2] clk: qcom: gcc-sm8550: Fix shared clk parking breakage
Date: Mon, 19 Aug 2024 16:36:25 -0700
Message-ID: <20240819233628.2074654-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.46.0.184.g6999bdac58-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Amit Pundir reported[1] that a recent commit 01a0a6cc8cfd ("clk: qcom:
Park shared RCGs upon registration") broke USB and audio on sm8550-hdk.
These two patches fix the issue by skipping the parking bit of the
shared RCGs for devices that can't run so slow.

[1] https://lore.kernel.org/CAMi1Hd1KQBE4kKUdAn8E5FV+BiKzuv+8FoyWQrrTHPDoYTuhgA@mail.gmail.com/

Stephen Boyd (2):
  clk: qcom: gcc-sm8550: Don't use parking clk_ops for QUPs
  clk: qcom: gcc-sm8550: Don't park the USB RCG at registration time

 drivers/clk/qcom/clk-rcg.h    |  1 +
 drivers/clk/qcom/clk-rcg2.c   | 30 +++++++++++++++++++
 drivers/clk/qcom/gcc-sm8550.c | 54 +++++++++++++++++------------------
 3 files changed, 58 insertions(+), 27 deletions(-)


base-commit: 8400291e289ee6b2bf9779ff1c83a291501f017b
-- 
https://chromeos.dev

