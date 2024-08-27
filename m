Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4F51D45E1
	for <patches@lists.linux.dev>; Tue, 27 Aug 2024 23:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724800364; cv=none; b=AUKxP1ug4usc7b4/XsTI3lcOPk/2Nt6x3zc8BOM8Zy6z7nNiiqpXP7sJdu3W+tFlseazK6NrBSMP2O24MwYdcgYA/jCBTMQ6JRKoyj9OYd8Td2QO8B+y6ZhxfX9D+feo9/Mkdp/oK2Zw/TPvqfpPgBiUI375Tpc8ywLv6gwxz5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724800364; c=relaxed/simple;
	bh=GD0A4TPEYjATzBkKcTtoqywA1zBBEQMw9GL0OoeNNZE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GgJUu0eqpIjKaC15QNP05YVfyBfjW0JWHqnPBaMWbOO+Z4QrCBSFqyiBI0A1RoSHyvOSsFjPPXozCLScA417qNAiZVGHoYX3BBfsFk4uawJYn6fgSPbSeWzlp5hYdb7IVKo1rVCUcf+hg5V+CZ28vAo+t3kvslJ5lTPJlDmyMHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=PcHOFGol; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="PcHOFGol"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-71431524f33so5122608b3a.1
        for <patches@lists.linux.dev>; Tue, 27 Aug 2024 16:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1724800361; x=1725405161; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Pv/ufdYKY+CmjhMEr75QBezIaND5j1qCC0DSQMSozsk=;
        b=PcHOFGoldvd8SuLFlGsnMllDIlUyvbM3XRYS3LPIBmFppc3zlQfF7CfmNj2/oGtsPZ
         J0sBJMsZ/9A34Nk5vsXbsEL8Q/8xbPlbgf9curm9mptMDKRAc7c+hHn7UXS79fsCtlg3
         QBbeTo+3QV/PlvRvkh6vM+DnwyLN9Qf67j6o4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724800361; x=1725405161;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Pv/ufdYKY+CmjhMEr75QBezIaND5j1qCC0DSQMSozsk=;
        b=BRUyTi6Kh8RdwlzKKpbUpOOuNQjXB77rstSK73aOaZcdroHA4ad4wLFdTr69x+4O0k
         HIDTZ9yszG0SiCBWyLGczFtB0BXw2Wa1SNO6nRSeH5zeNzkux8q0VaMcouv2zkpITitG
         c92moa5k23/mdictVEifB8sCTlYaoIhvG2ft155nMxm4ahAVNXtgA/Xmy2nkBJoFEGGw
         6h0wD0l52QI07QGSfaQW4n2qaqo5wpmFdiQtuJOZJrEiWckCD8IGGdk2eP1cwFRC86cg
         RIWEDVBEp9k5hDX/YBAFCSpPCQiKh8UNG1JZeGyPUpiVmxSRnYJOTwBHtCqTvZfm4hmC
         Ym2Q==
X-Forwarded-Encrypted: i=1; AJvYcCUEbYsXP/6jXHkeUexLXpTxxMMwM51/VpBwBiW1daZa279olij/RZNb4pcJa840+2ZLt8KzMeKq@lists.linux.dev
X-Gm-Message-State: AOJu0YytbI/C8YgjpbkdKoxmaQWPLdB60m4Ucj7xP94ZRmlvQVIaPkjf
	HqG3PvDklMHFMvch6kRvP2xfk+6i3T+YaGfHwmrFnGO0FVptn6Cdo5lvZCEhIQ==
X-Google-Smtp-Source: AGHT+IH+n08Sk8Vd2lCCcbwAL0bOTX/nA5NdiPgGvH28H6kVXqenmkkshHPtYDCVpMQVH6rWErsfbg==
X-Received: by 2002:a05:6a20:6f01:b0:1c4:231e:8ee5 with SMTP id adf61e73a8af0-1ccd2899c54mr110535637.29.1724800360717;
        Tue, 27 Aug 2024 16:12:40 -0700 (PDT)
Received: from localhost (210.73.125.34.bc.googleusercontent.com. [34.125.73.210])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-7143424a525sm9016824b3a.49.2024.08.27.16.12.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Aug 2024 16:12:40 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Konrad Dybcio <konradybcio@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	patches@lists.linux.dev,
	linux-clk@vger.kernel.org,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Amit Pundir <amit.pundir@linaro.org>
Subject: [PATCH v2 0/2] clk: qcom: gcc-sm8550: Fix shared clk parking breakage
Date: Tue, 27 Aug 2024 16:12:33 -0700
Message-ID: <20240827231237.1014813-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
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
shared RCGs for all clks except for the ones that were causing trouble,
i.e. the display RCGs on sc7180.

The first patch is all that's required, while the second patch can be
applied anytime to simplify the QUP clks that don't need to be parked.

Changes from v1: https://lore.kernel.org/r/20240819233628.2074654-1-swboyd@chromium.org
 * Revert most of the bad patch, except for the sc7180 display clks that still
   want to park at init
 * Re-order series

[1] https://lore.kernel.org/CAMi1Hd1KQBE4kKUdAn8E5FV+BiKzuv+8FoyWQrrTHPDoYTuhgA@mail.gmail.com/

Stephen Boyd (2):
  clk: qcom: dispcc-sc7180: Only park display clks at init
  clk: qcom: gcc-sm8550: Don't use shared clk_ops for QUPs

 drivers/clk/qcom/clk-rcg.h       |  1 +
 drivers/clk/qcom/clk-rcg2.c      | 36 ++++++++++++++++++++--
 drivers/clk/qcom/dispcc-sc7180.c |  8 ++---
 drivers/clk/qcom/gcc-sm8550.c    | 52 ++++++++++++++++----------------
 4 files changed, 64 insertions(+), 33 deletions(-)


base-commit: 8400291e289ee6b2bf9779ff1c83a291501f017b
-- 
https://chromeos.dev

