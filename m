Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05ACF2003CF
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793391; cv=none; b=V7n+IgabWfkQkV1RcZ01JVhsebTj59QYpywq++Krbk3j2ETeSTfMidMKSd5gFFq2rIzPhMFGo7pmYJu1qw5Hc1P0MQY5YQgwMANC6NryYNYGlT48YyliOuWVNc0dBY2h1qlGizP8tS7Hb3rs+AzeKB41ZptcBu5PZMRZ+P14AmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793391; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lwpJ07DpYncgHuBrMTFS4tTdn4lY/VXl50mncgnKoGHLhUidxFtkmx0XXrZ4oGqZkeTu9GBRw16qkyNRGYkgL02TD68VngCdlvcjpYP5ocxccKebLctz2BblhQaWno9CPgeG3vDw6IDOciW+iGrJpvSAub7M7mVF2MZXB0g56EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O4b6wRqY; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O4b6wRqY"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-539f84907caso1412321e87.3
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793387; x=1730398187; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=O4b6wRqYre/Fi1wVpC2tk+UYunaCORoa9TYVaMKjUxJ//m2dbkShEWEbS3+cStU/2D
         Omrfuj1Ou5ZH7/Tuyumq6NyolairFuTCJuqEXNiKESo6YKs0AcLSShUm7LFF2CJ8khAs
         A0IGpyzehQOD0wmJBcmM0tnJL3Jlb56+TOu/9EjNHVo7n063y6hnVzCZumDfXC6kXZBo
         fa+xvNGcDwyuIyafbGyssuOluYc91+GAONHDlnkPpjrhLwZ5HgR4Nq92+jOi8DQyFqi+
         k7OdiJG7S2QTV/2rUyBZOcGCATP+M7EZj3xxSz+5buSqiCcKfLtsEq/A2HEK1jCpzIZb
         akgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793387; x=1730398187;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=CxV79BxR+/0FlYXJWH4ckNtWBckbcdj+76zB3tlV9iHynyNtG1fTCuR7H2YLsk8m/q
         lAQgDnXSAxeOL/wrVQKffxa8mJ2TBoMWRE+qINIJSKQ7TwvSj6vDnwTG6uivRbrqt5tq
         S8ApY1cN0Gkp/8s0q3atmdQkzJBF4fyyHlV40/4qChHLIXjaYfcq3lnY5pZxAkjxaws+
         DKCxK2BDiLpyeKn0YtSwrDqS/Q+Ap5myZ4U5TjfltRO2e06HoChZn/yoQoZgby7agIv0
         IxR78Z4uS4+LEg5f5gCqc9RxqgS0k9WpqBX8SeRsuSjJLW8ywxKaRjjKmvzkKQCLAERy
         amFw==
X-Gm-Message-State: AOJu0YymiTetjfZW+qPUNy3K7MyUblcti46S7942g+ibGktkIUUX43Uc
	F4oQASVD5Sxaf5ZRjBxrXHRYepiKgQsWdt6mWEak0UORtAoKIsqv
X-Google-Smtp-Source: AGHT+IGbR1Q0kaCP1csp9vnu+KjU0gyFReO6HUJ00+8OiZgELRvlOgvxPTZocdN9gVLvOEPrSOZpuw==
X-Received: by 2002:a05:6512:a8f:b0:539:de9c:c890 with SMTP id 2adb3069b0e04-53b23e86082mr1731599e87.42.1729793386994;
        Thu, 24 Oct 2024 11:09:46 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a2243ee12sm1431904e87.285.2024.10.24.11.09.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:46 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:40 +0300
Message-ID: <20241024180940.3297-1-vladimirputin693389@gmail.com>
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
