Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB5E13C8E8
	for <patches@lists.linux.dev>; Wed, 28 Aug 2024 17:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724865448; cv=none; b=WzgDI57dGJnALP1C/Bbo8Uuu2FXvvmu052KNMWAPVuJmjavM62hj0A1Z+Dnbi2RHMXEalyZZJUJqYdbIla58zODwaFk0NLdEa7hWQtEZw+vHtplKOAUyB1tu7r3vSEpRrcZzh9mhFOQNC1P6+Eg7G3aCn2IBO0hY8RT+VM6URAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724865448; c=relaxed/simple;
	bh=p1GvsN04RrnLY0X7JsqpE8JtBOcwD2Nm4oXAW17AAKY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=swIAr8Zt2PsKD81W9VQoXgLdnN3CvSCdl/tDNega2TmR0Yvaw5JQcPcpYasJDPGbQzaqAKYTJ6dA3jiXpnV9jFQJQ6V718V0vf47EufRTE2o9xNjVUN0ZseD7BWPewsh+1wYj3SMQ5L6RJSKkDdZHtWwvwGFPo4a27w2O7hOdrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=hKM/mzVn; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="hKM/mzVn"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-201e52ca0caso49917975ad.3
        for <patches@lists.linux.dev>; Wed, 28 Aug 2024 10:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1724865446; x=1725470246; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4kJ5hpnL3/FBGpLHASzo1BcvnUs7S3nSY7lVkr92lVk=;
        b=hKM/mzVnwHGAGup9RrXU683AFsj7i5wa04Pp+3Eke9azCoMJ65+BgV0KgcIFhtCBAe
         QUM3OCTzMXiCZXzlcs/+m8Krfj0APYMbwA8PQUlDbTGGC9zq0aTahBGKDq17fcHZHHLt
         d+kRjXEASvoajte6XUGQi1okx4EaGFPX65XQU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724865446; x=1725470246;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4kJ5hpnL3/FBGpLHASzo1BcvnUs7S3nSY7lVkr92lVk=;
        b=wTnDskPPfcrxBEv40w29an/WE05XJ1YlSViConNU2Ss1EFQWoWDVMlWJQIlpSWecYi
         Em6K3aWbtzkFRLwO+aJuuKEf3tI7KAgHH/rSEF6pKmWP8DIWF6r2g1KH+Wyfwr0coYGB
         FCTsQWHPzfb8oUeDy0QzxARRdfmET+rYtG5sur2OIimU3bJ9XQ6M3bed9EqGEzpydzb5
         KEg/AteoQGL6zFb+9LCs81hOw1UBx4Ewl3nhaxpNFQv55d7BYhGSjBo1wJpXgvDwIduA
         HYPqtKz3mEQx8TIesTLgd+CTFcEZcgJGf1QFlAGcjKZkDlfEagMF9eHDh9j9DH6ytOwb
         Na5w==
X-Forwarded-Encrypted: i=1; AJvYcCXJa611EBqnifjrcxtFRTOyN4Bf/yv5pBFcsGfocJpnXhDw81h2YWmei50oElj+wrkJYviZJvgw@lists.linux.dev
X-Gm-Message-State: AOJu0Yyl1XE+O3bA04/SjkRKpi6OaBhg9tWiJv/iJRJ+u3WJlMnnz7pL
	K2ZlIlbrofw8lf8MOPQXLW+OUcDl1PjQtbT1RqX4mOtdUcaDuZTSxQOhDMFb0w==
X-Google-Smtp-Source: AGHT+IFS7ZURBYUCOol3v8lGedBydTXmTI3cDaFTKt6acXzQU+49QjTiAkXmr7wLO/8x1OSBOaOUWQ==
X-Received: by 2002:a17:902:c40e:b0:202:54b8:72d5 with SMTP id d9443c01a7336-2050c49692dmr1849355ad.59.1724865445848;
        Wed, 28 Aug 2024 10:17:25 -0700 (PDT)
Received: from localhost (210.73.125.34.bc.googleusercontent.com. [34.125.73.210])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-203855dbcf2sm101566235ad.146.2024.08.28.10.17.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Aug 2024 10:17:25 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Konrad Dybcio <konradybcio@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	patches@lists.linux.dev,
	linux-clk@vger.kernel.org,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Amit Pundir <amit.pundir@linaro.org>,
	Taniya Das <quic_tdas@quicinc.com>
Subject: [PATCH v3 0/2] clk: qcom: gcc-sm8550: Fix shared clk parking breakage
Date: Wed, 28 Aug 2024 10:17:06 -0700
Message-ID: <20240828171722.1251587-1-swboyd@chromium.org>
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

Changes from v2: https://lore.kernel.org/r/20240827231237.1014813-1-swboyd@chromium.org
 * Reword first patch commit text to clarify further

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

