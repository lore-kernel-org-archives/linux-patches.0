Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28054A24
	for <patches@lists.linux.dev>; Wed, 16 Apr 2025 00:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744761738; cv=none; b=R9bOZwa1hGivaGmE2uCjNGO5bykpaalgoJ70cdYS1fX7LFP/GdHQcXNdVCGbj8sUXeM/R6lHRmz81N+hrhqZCazYeOZAvbGMeyD8w6xteJ19mfCwJZIL/tYVSyxjlAIEfmfToQNA00TucmuI1aNlG51j3TVIdGB5LBM9lTQSDBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744761738; c=relaxed/simple;
	bh=X73kg4tdW06GAOX2zu95FNoOmd3sHwKiCictodfiuao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gCLZ4fbFITS6nuDEttrWJYVQDxQhTAIXMZ3ItloGjmuO5g46TgjXWG2cpzoUDK6gm8YufdQWdAgj3z6L7t4P3Zbn2sH1NVIPVhO3T6pZIy/ex8YXHwu4t9BHndqfq9RRggbC+b+HylRfoUvpHi4Ze7MFF7X3WJkK/6K001Z+plk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=A2yoB7fN; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="A2yoB7fN"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-736b34a71a1so7162206b3a.0
        for <patches@lists.linux.dev>; Tue, 15 Apr 2025 17:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1744761735; x=1745366535; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ztpfrrq65RboKoVCNPKCaSBonp9V4OT02BBtVtoD/uU=;
        b=A2yoB7fNZ6vr106sCoS0BC1bhuUqQ1o9IZsyWw4omSUEgsJESB1XdkfRGVmYk2BgWD
         xQLXqT2K3TAzVuVBHUiLEioHpuvp8l7jxebQKF7ax5cagILI48OyTqkbDvfD9QRjlXyj
         LdisZ6l2FQmDpFpgM7h/TNuGWA0hYkZ/OZs40=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744761735; x=1745366535;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ztpfrrq65RboKoVCNPKCaSBonp9V4OT02BBtVtoD/uU=;
        b=Vp+VQTrEflxPcIR1w09cryoPr7TNfAM6Xaj1EBeBvCC9MED4LoooyxXzWywRJCrwTG
         nQPf2Mm2tRS7fI77p8lWoHGHh7s5M3bgpz7QsKBvCylIBhqrcWSwAWPI8A9NkLGzIHG4
         FMlHHhDplXXSzMIbc1vZsfmSpM9Qpfw/wtBfDZ9LUZF4+QhCr2sQlorSIqTKcvhLSFlu
         4F2C96UsttFduH2VEKQvCJnzNLD4eZ/6qG3oAFuWnmu3SknAZJxvf73zPcbPjx7AugXI
         1HNwLbKUnnw1iXQKb1ElgxR07xUYIV7mHoMGA9s1T+iEdAnOGJywrXKHOa5gMFyARKc5
         uE/A==
X-Forwarded-Encrypted: i=1; AJvYcCUt6wtAZ2JK4NmqMD9OGOmZxO0xr4rRZaJV6Qhk427khYc8EMiRPdwPgiAFktq2olLYBOv5inqV@lists.linux.dev
X-Gm-Message-State: AOJu0YxdOY3/wvODAH6xBKVvqe8+wCfgzk9dbf2mte93dTELQVpm7etO
	C7DMqJgXLXWVueqN9icOMSERfomnjq8nSHKVml6e2FewgyF7Vte/Hq+2nd6Hnw==
X-Gm-Gg: ASbGncsQNKx7Jb9MT1KdExBo0j2/Y2dnCSFqKIEhJLmBu/W2wAM/qFM03AhrTJNNchz
	tUQPUJym2sucd0Lcd3+xlt3LveciWaJa5PLw66CYlP1tEKjaxgnhq9cSBMa47YHcbqav959ivaW
	sDYXBUXaaVmmbZVL/s0mlSlwc/b9PbAilTmyv7qUNvvFwreEVialFsOhnSzG594NQWFqLXi97Kj
	PpZaslhgFOYbvYpNFxACC6eHdFKRWvOMr5hW2BApUbA3tbS3LzuMFLUV7EFQTY+zWjSH1oE4m/l
	1Y0d9umhQ2QNmfc3M5+9FXIscHavohNY84zryV7Le+00UnJ2CZZdRGdnRRKljlRVOk1XVlxn1Gt
	0xQ==
X-Google-Smtp-Source: AGHT+IHkUQNhj55ArcxMsqdZ9goNzK1iX/oCF1gdLXwsnONXGZV+o45RA+2MeBctZXHEWSSuaXlJnA==
X-Received: by 2002:a05:6a00:2e29:b0:736:48d1:57f7 with SMTP id d2e1a72fcca58-73c1f90d688mr1947843b3a.7.1744761735002;
        Tue, 15 Apr 2025 17:02:15 -0700 (PDT)
Received: from localhost (199.24.125.34.bc.googleusercontent.com. [34.125.24.199])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-73bd21c3216sm9157830b3a.49.2025.04.15.17.02.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Apr 2025 17:02:14 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	devicetree@vger.kernel.org,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rob Herring <robh@kernel.org>,
	linux-arm-msm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Conor Dooley <conor+dt@kernel.org>,
	Benson Leung <bleung@chromium.org>,
	chrome-platform@lists.linux.dev,
	Pin-yen Lin <treapking@chromium.org>,
	Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
	=?UTF-8?q?=C5=81ukasz=20Bartosik?= <ukaszb@chromium.org>,
	Jameson Thies <jthies@google.com>,
	Andrei Kuchynski <akuchynski@chromium.org>
Subject: [PATCH 2/7] platform/chrome: cros_ec_typec: Allow DP configure to work
Date: Tue, 15 Apr 2025 17:02:02 -0700
Message-ID: <20250416000208.3568635-3-swboyd@chromium.org>
X-Mailer: git-send-email 2.49.0.604.gff1f9ca942-goog
In-Reply-To: <20250416000208.3568635-1-swboyd@chromium.org>
References: <20250416000208.3568635-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The DP altmode driver fails the configure stage because the status VDO
that is spoofed in cros_typec_enable_dp() is missing a couple flags. Add
them so that the configure succeeds. This has the nice side effect of
properly reflecting the pin assignment and configuration of the DP
altmode in sysfs.

Cc: Benson Leung <bleung@chromium.org>
Cc: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: <chrome-platform@lists.linux.dev>
Cc: Pin-yen Lin <treapking@chromium.org>
Cc: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Cc: Łukasz Bartosik <ukaszb@chromium.org>
Cc: Jameson Thies <jthies@google.com>
Cc: Andrei Kuchynski <akuchynski@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/platform/chrome/cros_ec_typec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/chrome/cros_ec_typec.c b/drivers/platform/chrome/cros_ec_typec.c
index 6ee182101bc9..2cbe29f08064 100644
--- a/drivers/platform/chrome/cros_ec_typec.c
+++ b/drivers/platform/chrome/cros_ec_typec.c
@@ -531,7 +531,7 @@ static int cros_typec_enable_dp(struct cros_typec_data *typec,
 	}
 
 	/* Status VDO. */
-	dp_data.status = DP_STATUS_ENABLED;
+	dp_data.status = DP_STATUS_ENABLED | DP_STATUS_CON_UFP_D | DP_STATUS_PREFER_MULTI_FUNC;
 	if (port->mux_flags & USB_PD_MUX_HPD_IRQ)
 		dp_data.status |= DP_STATUS_IRQ_HPD;
 	if (port->mux_flags & USB_PD_MUX_HPD_LVL)
-- 
https://chromeos.dev

