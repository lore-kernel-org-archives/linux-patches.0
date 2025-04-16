Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39CE8C2C9
	for <patches@lists.linux.dev>; Wed, 16 Apr 2025 00:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744761735; cv=none; b=bAW/RhpvkSSl3ve9mhOOTzpGkuGH780dPk/IUKnUT4/YgztnrnYsi9HJO/kzb+jqI0TEfWvPyXi5JeHThv1ldQiwYS53v8FyRf+eP8hKaEai+aNWW4OMTfVffshSy9DK4mkrrz/CofuXiJw7spVwQn20AIDJzzYHZiEOKCyFpn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744761735; c=relaxed/simple;
	bh=9LdBVOezi3+S4+ZxOQ8+mmTVUoo6eXOCdNB3fmZA2G8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ArPsCF+cLuonJzTxMPFjKSdGRQZ+57xC2Oeah0tC0DRUVrO9MJr8rqdCjCxMuBes8mWhpT+hVyIJjwdCwp4X9y4ntgoT2cBt4gW7BOT5Cjs7/8w5ED8FA7Fg/R9hjsIHLNrkKYpplNQkfn08hFhxpv28DA+JJyi5SmeOX1mtgmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=dvkol6CG; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="dvkol6CG"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-224100e9a5cso70614485ad.2
        for <patches@lists.linux.dev>; Tue, 15 Apr 2025 17:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1744761733; x=1745366533; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ETD26CH6iD+0uFy4hgKYmRwgyWbV2LZsUcS2ttgEWQs=;
        b=dvkol6CG11OQh6F3fhZRYU05Ma0kbjJGO0UUW5MZCpNCjwzpMVrnKq5uF3nlopriA1
         EL7iSBGIBw6deuOYv/GUbY5snJ2jfFK/oAzxyqDtWEgkLj3QmDib6V2o2veGwFxSDGyI
         k/y4QWSl2XdVAXfLJpZdVrEWM8mhp/Do6sRFA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744761733; x=1745366533;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ETD26CH6iD+0uFy4hgKYmRwgyWbV2LZsUcS2ttgEWQs=;
        b=nOChipvznEw1F8mVqhOOzm2fyZeJpnjFw9U0dQwZkOYg/IHBnDmh42H+xVwLoSZ3Xb
         LddS0l/E/mUezmFXQzWeisPhlXS8WRIKRzoOHYLvKdLEdP2dLLbWJ1u+QmLss9suwtnB
         RZIaHtMwabSz+/1Ru6TFsO88zKBmxZzDnnUU0GwTq5G+0duEQ/gdCVSP6wkQ54XOJmY1
         R2wkLmEBb1zbh7otvRzl0t6uID1451klWU3/fIY0dBPM5MXG5xdax30ZqnQwzGorpXwJ
         LtSf3l1UBaBlKGP6IVSMavKtz4qatis10MpWX3OsPzSFxHKNfedqrSHjcUy2JoF+rk1l
         pHSA==
X-Forwarded-Encrypted: i=1; AJvYcCXwoPWxjnaOPuyuSNzkdyhM1fxtx5A3BT+W9m0CBN3nKRyWcwJJNOS4R67J4W1/Zcz3eEXTxtwn@lists.linux.dev
X-Gm-Message-State: AOJu0Yw97nXXO2ic/D9JRNt2NxsVI0DxFqM5i0NhGrItgphXRTwJUP/D
	x4Po2Fx6eVjqRsb58COhka0pji+Q4Bwbwq+i8gX7EnF1yRCAaoNzFNc8phbJ0w==
X-Gm-Gg: ASbGncsMN1u6FehYMAJO75upI8C1vSMt1pHWOBoOtqjgmIMDZZsh4cdY0piFTuqPwJe
	xogszp+pf0SQgF898deR6N23Tg5Mb9G+mjsXePG1AQkW39uy4uHs2HG9Y7Cw3zhC0Y3elZq9Xf7
	KQHopIqieRHYgzPUl/r+1orHA2UXV4ExCBHNB117+93bmAMwcCS0+yDBCD/Junywf9oi4Iv/Z5N
	5bIPxBB2kgoamlf/YtR0cHuyKPsvvxhNWo05xNNECJIsByI9XhaUj+BP8E1u82apPBaR5lJuZa5
	1r1SzKNYKcBMccAkA6s/7Ak4rbN4/55J/q1v0rzhne45mpj0VYmIlum5Y1ILsMbYC5Gq4HCs1r1
	Ajg==
X-Google-Smtp-Source: AGHT+IGTNhPFIcDKlL3bF0SzfSJ7SIXjnXhh0YeuCFsofT603F8bPtE9D2lDaA650EUHL4OU3b5nnQ==
X-Received: by 2002:a17:903:2a85:b0:220:e63c:5aff with SMTP id d9443c01a7336-22c31ae8e3emr14464865ad.47.1744761733360;
        Tue, 15 Apr 2025 17:02:13 -0700 (PDT)
Received: from localhost (199.24.125.34.bc.googleusercontent.com. [34.125.24.199])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-22c33fc47e0sm1235925ad.167.2025.04.15.17.02.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Apr 2025 17:02:13 -0700 (PDT)
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
Subject: [PATCH 1/7] platform/chrome: cros_ec_typec: No pending status means attention
Date: Tue, 15 Apr 2025 17:02:01 -0700
Message-ID: <20250416000208.3568635-2-swboyd@chromium.org>
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

If we aren't expecting a status update when
cros_typec_displayport_status_update() is called then we're handling an
attention message, like HPD high/low or IRQ. Call
typec_altmode_attention() in this case so that HPD signaling works in
the DP altmode driver.

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
 drivers/platform/chrome/cros_typec_altmode.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/chrome/cros_typec_altmode.c b/drivers/platform/chrome/cros_typec_altmode.c
index 557340b53af0..c2d9c548b5e8 100644
--- a/drivers/platform/chrome/cros_typec_altmode.c
+++ b/drivers/platform/chrome/cros_typec_altmode.c
@@ -280,11 +280,8 @@ int cros_typec_displayport_status_update(struct typec_altmode *altmode,
 		typec_altmode_get_drvdata(altmode);
 	struct cros_typec_altmode_data *adata = &dp_data->adata;
 
-	if (!dp_data->pending_status_update) {
-		dev_dbg(&altmode->dev,
-			"Got DPStatus without a pending request\n");
-		return 0;
-	}
+	if (!dp_data->pending_status_update)
+		return typec_altmode_attention(altmode, data->status);
 
 	if (dp_data->configured && dp_data->data.conf != data->conf)
 		dev_dbg(&altmode->dev,
-- 
https://chromeos.dev

