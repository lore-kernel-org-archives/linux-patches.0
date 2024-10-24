Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959781FE0E7
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793413; cv=none; b=WirS1qMMXxMj8mqzxI75CG+m4DP4zKjxB8AEgKvu4ddJYspSqYMptK2Kt99Myzu6tPt5aMg3wJPoWOdbQ9+GN2xk2l2qOQNV4L3M6cTtvIczSN4Skrgc4bhnw6NE0t3/RYGvAZV7DjLhaVQvVTWFON3aP0TC3iNRWxkIx+DTtEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793413; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E0QvucGos6jnUjPISumUa2dMcLCNByaLCA7ey2gh6PFwQoPNyfdfdkzRF4EtDIcpPAk5k1k1Wi/fiNWLNkzSdcgKqh0k+XG8anOxgOLg+RHl8+V4LUyDoDFvGcv9b8JAEcZAT8QH9B5uw9FeDO34wpX/dlWFqUMo3noPFIbKUys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cVp3uoPB; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cVp3uoPB"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-539f84907caso1412754e87.3
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793410; x=1730398210; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=cVp3uoPB8K+yZCfeqGEBBYI2ciXXMK0OgwrOYj5fyofKOrVr+5AvTU8h5xVBTL52Rl
         b/nPpEyESfwH3NgxZmJkN8CcWPAZa32MTl2HFQCkUGK49l/hnYcdEncuC52s49zP0TQI
         EfnntB6yx+np/RHP/XmJ9kNhguVb2b0zX+JsQruOhsYZ0+m3Gxu8m+tlAIaF8CsW3Jw/
         K6LyKePrtYFsKr1T/+GdqZJg8+YIny2E/oGh8/ODJPKPk6ruaupWg5XKRwS1j52+VcAb
         /c+YoFxHAVMzORzwDCMCPN5MoyTK9+OMb5k/E1usIX/gQqQzWqT/ferkg2RFdThn1zm3
         64OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793410; x=1730398210;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=V1gebMbyaruNr+Do5ssZEm0jAcbWyQQBWRZMTZBx5mQHFNA2l9GhZQ7VMpcJT0QJrH
         oi6OEqsrhoUEa5ggNzlOntrq+rsr9ETwVgiB1ykemUQPGoZpzr/XYVRKV7YSa5aryDIj
         kkoX+Ks6C5pJ9NZVD3XKe/l5wcCq1GaZsEBJP8F5WKnTIy/a+6K2nyeaIz1OGlDeRIht
         2W/Dw3V2UNFTdZTk2X0W6FlUkSAo7/ozzO+aTNN4Y73GbCd+5UToU2ENUKV+bye+EbFW
         MwNEJiVZgDVeLg3/hNRMHw5plyS3z5sb9dvOJEs9gzKJx7qs8SDV1sRc1H+ij/ccUNjy
         KeDg==
X-Gm-Message-State: AOJu0Yy7ja0UvRUAMylk9T5cAq+rCG3PzG2Q2n+M3BesLiugzRAKV9oY
	puvA/1kG/65KlT83+UiYh0smnkWlZP4jf/1/jjoZ9ags2pdlsvxjVpgAR0W3
X-Google-Smtp-Source: AGHT+IGqRiz7sbJeTXBqlmA3svgiWVPiCDgp3edmKa5PFqHX+WSWyYecpwBurGly+Y74lpkSv5l2mg==
X-Received: by 2002:a05:6512:ea1:b0:53a:1e5:572a with SMTP id 2adb3069b0e04-53b23df5444mr1683750e87.16.1729793409720;
        Thu, 24 Oct 2024 11:10:09 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a223efb24sm1422794e87.65.2024.10.24.11.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:05 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:58 +0300
Message-ID: <20241024180958.6650-1-vladimirputin693389@gmail.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <2024101835-tiptop-blip-09ed@gregkh>
References: <2024101835-tiptop-blip-09ed@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

You should kill yourself NOW!
