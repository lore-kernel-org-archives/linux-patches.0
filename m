Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082991FBF50
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793413; cv=none; b=YpNBqtB7R4uldx35QrMkZJ9O7q+gy+h3H3hyAULrm+OVYF4JIMz8TAf481SYMi8pLHunvKdwSmWkFHJ1eqsnBPM5v5XYZrGdAHfdZAsbvYqBo1/p66QHKEie3vHjUGUbDx00GpATutbOBkQrBCyY97Bv34mGIK3YL2frVvuvhr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793413; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q5Q1eyHeYRdJy9WBGS5y/AaNodPLMVCkvKdIEoubb6v8g0a580+Fzsloyz/g1fuDvGX0Zr+2heGCCvwL2eT4uR9T2vRRuCyP1EiPifmUNusR7OAYTqPaDTNVZ+etjuTzOOcallTisk/jOkwYzgsr4YL8iig8I5lrxv3KCqxVjPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZFud2Q9W; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZFud2Q9W"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-539e3f35268so1550643e87.3
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793410; x=1730398210; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=ZFud2Q9WOzN5MKlf5umqwnntVeepJnDjsc9ppCacXjVYvGcNyi81CnBqtfrn0Zazx5
         kDqEciINU09Y41Kxrva0pGzFr8N93tN6CyPhrIEPigFEV6hSGAlxqRu+FhKusTD5P/Ry
         sQqtuIRkaJ9/d01gvK4nUzJQOMVxxO7TeUkL8gT/DdEDhr56P0kVdiN5RnSrq54wnIkG
         koqjdddXS13EiORJ8j8SM0scuw7Igm63o1m8uEccoO5IbRaLs4uYXCwRQbiemy6q5n5R
         OprVe1AVQAg3VRTXfoqnO4kxEDrYgYRZCdfPpoJYvg9jV2DHgzoHrHLHCH6AoOI4krLN
         +Wqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793410; x=1730398210;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=rFf6gTrTbIqYruebe0c8coQAF8iUzHvbfHFjk7tUAWhdFC2OR4vkG25890rGg/giKn
         VPMeqheyDtkAN9DT+d0LuxebfQY2nupMZkTr+G1+tunugjJdWYaov9KlUC7O5QjNN6Lh
         q+ZGGl1ZlvOvEP++w57Lomz6KGpkUh20KT75cTsWRRq//8dTCunovEZ4+A+06UPwy2DI
         P6lfMitV5q4+QUpDVrBBvVu3DpaV4fa4iDMhcKBIo0W0AxbYK153ihMsNd3lnmogz5An
         iE7TKFmO/UdL6LnP9GkeSQUis9+Xo76Z8sQ/3JwtR/fcx2CvgfLz8gXusj6aCK1vnmZs
         VY+g==
X-Gm-Message-State: AOJu0YxOsYy4pDr+2sTEebeu41rknvr2zD5APXDoX4W9CN99qADheviK
	LeeTe0kaOqavtbqyhEO/o1mK+UR3TtGH+Sn6pGtE40GbxwMW7tjT
X-Google-Smtp-Source: AGHT+IFcSHlWc2zYVCRq19aC4qqeGSBEH2jpn9OytCczE/IQp3XOSBKyH9HQMm1UMBr5MCo8cZwIAw==
X-Received: by 2002:a05:6512:1384:b0:539:94e2:a0ce with SMTP id 2adb3069b0e04-53b1a39ad5bmr4550819e87.59.1729793410001;
        Thu, 24 Oct 2024 11:10:10 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a2242013esm1405833e87.164.2024.10.24.11.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:08 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:58 +0300
Message-ID: <20241024180958.6691-1-vladimirputin693389@gmail.com>
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
