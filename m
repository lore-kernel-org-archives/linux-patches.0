Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3EE82003C1
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793392; cv=none; b=EyWD9VY7+ierGWuuWnn1C7/u4UP2x2DUITdGgxbMZb+NzA7w4P/kmP6/DGeMb8Tb6yecK08sOaCll26OMFNl8q5Mr/bmRgDI6H2rAmeL0X9ne1lP9ade7pp2rImJmncKhYJUkWPDVqX6QfFoXEl1qvYtMB91XsnOcTKsb/9CCsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793392; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zg03Qq5ZWl90Nb6bFpAPFCi8xwn3QVpI5FrWDjlkFudkm2xJM0jvYTSlzTmn+klVlqonV9megErr4imf4TR8xtcfzBT30do3wX6OeMh9vm9veYfYmBKUBUE3hJicBGmDC3dmC1fHNzteXpluz+f+PXWD68ztLNYheKexnDDeJ7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c42cdyiL; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c42cdyiL"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2fb51e00c05so18897761fa.0
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793388; x=1730398188; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=c42cdyiLAHsDJVvvty/3NI8xe1q+u33BjPfq3l0WGSdxLMrmQpK5rMHJF+FmSRJQLO
         e7tvWWUBQzWJ0gqDaEcjE98zG8lkUxp/QhuPAZQn9FWQsAanpAaCZnTs78oSwF18pazD
         zmhCHAd3BklJEDnrqIrNYUH7FvPY6qpKEdoK1aTWrvzGA5ZSYoJt3lkVpQDCrLiALLA+
         xXUwwiqBxYhIpFWs5C/jawb3mI/V1muzki64X9GT45ryvHJrw4BdtxNzFcO248wxV0/T
         4w2DDmW0J2w/exg1aypL82zBYZ1cV0GG7hxXz6jfmNM14SX71wK0McaRLvdtVRtNoZGt
         VdCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793388; x=1730398188;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=bd5uRv/I96aOEFrrJlG0Ct6q03qVmKe0q7fCwINLSE8n+M6hLacyLRMDFCd/It18zm
         1fo+c8u1AqU13YyxizrnvqSNaXEe70sxPDznr2Sd6CtP6/Y96ObgtgaI17y9JyF3zXTl
         OKphbrOIGBnS3FhjbaaPsCmNSxIWOXaQoQnozMFsLY/QhZg/1o63x25gElTmor940Ta7
         /wQ4ZUyd8Z5wq4B62Iugho1ctfT7sfRED0d5Cw7MVvtyoDx+Bi0sPjrc52Xp3MmakaEP
         KspB1rVgEbuBjGorHibl72Uh3tMlUrq4jrzNoj96zBE7l2fw3nobmW/2NMzpUdawQ6Ct
         o0Xg==
X-Gm-Message-State: AOJu0YzOObgTDPPxRfFzYETZ2fu6SvOkZGNZrgE75cCuRMnFPlkTPmcG
	nUGHBgzKs2/Z+DpOFwicif7YovcNBcd41MJdHYJyxZWkvGKSfiNJH20hKFxV
X-Google-Smtp-Source: AGHT+IF8L/aCvZ7Mjzd4Cv7Qy4vP4U8k8aUcXhOOgiCVNpBgh52A0vBJH0vI78cmQnKw+xR/lpDD8Q==
X-Received: by 2002:a05:6512:39d1:b0:539:f10b:ff97 with SMTP id 2adb3069b0e04-53b1a3ac08fmr6978621e87.49.1729793387608;
        Thu, 24 Oct 2024 11:09:47 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a223f0022sm1419295e87.80.2024.10.24.11.09.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:46 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:40 +0300
Message-ID: <20241024180940.3275-1-vladimirputin693389@gmail.com>
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
