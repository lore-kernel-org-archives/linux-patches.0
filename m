Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82201F5831
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793405; cv=none; b=nPn58QLJc78ItaPIyTrWcC1ieStv+WZCB+8TvS02u1qoqbQ/SrS8plqo5xgbibtnfs5nI5NfJg3AenWAIFwCbiXFflZpemAZ4dMr1fPvZ0FYuOtb67Hm6jCZTmNvu53EGdqeYKFeeF+P1tCPkyoe1dBLzWDSiJo9Kga74DzVerk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793405; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yfau/uKFKpMqxRQ1MFRig6B031I5Mpjn0LrbY8gfM1X3OxBaJVVRzJFEXCycN5BpAItUH0+F6f/Dr0dOxq4e2o710Wf3Oj659iYkeDNr2ZdPhTYwgJdkN/rHS+o/Yt90GWhSDCELbfnvu+e2fVH0heIvBrRRudhGr6tQpee2GBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N68jlEIJ; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N68jlEIJ"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-53b13ea6b78so2069068e87.2
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793402; x=1730398202; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=N68jlEIJh3B9zUitx5lYob+JsRfUDpmIPHV+FBluGuHXxWIgFvgwrNol8/TEJD5pkq
         HkaC1+ZN9l96WWSiBFrA2sEviNSZ+MGLud0Ohi5rglQ0fitafx307bbT/ckbFuLoDyhv
         YHAVeazNjPv1xHpZ3pjefO3UtyZtSri8yQbVojRj0ohxC+13U4wCq/R/x2G8Eyeu5pg1
         anpTDdDHgodkahXw4utbH59iYxEnYnGIWvd0lT+YCzYvqMB6FQ4R9J4hZVp1fFtVJ1HG
         OPzUith45u7bFR6oQSmv1tNT5rZ5EhXqSMal62pgxRdU6qpG99eTLKJe183zP4SwN7gg
         wK1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793402; x=1730398202;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=WgLTLuoBL3BDleFwESqTXxTetBFt9qG7m5rcwZs3iN1NTmAUYKx+tU4UeApbvWAfSw
         pXj3H3hM96sy/Zgyh+Tqw/8dDSpQKK7iI4AlAw7/WmJZwXEdMp1LnCMNz9tTc8QmF0Lg
         6kO+LEghv2iXysdrFwpnsakCm8STETITwyLb1P6Df8azvl650fW5raYVakhK117SdCeo
         LWezU9XIMmP5UsDpkljREfjbBDMBC9s8Uw/t3OEtP628fCwUJReeSbCpfJbS46dyom6N
         onnqoR3FbkczWmOYopIGQsGvZyNJ/niXENrU0J+gXfQk8P7HYYHwUp/VFowr9xth68xh
         avKQ==
X-Gm-Message-State: AOJu0YyNMqRiyYRizZKJp6pVijuPxby6VJIo8wAJg4WdGxZK8lS7+U7m
	rWeFTuEkdrNzXqWIAMzK9iwQc5upxv10JaRxq8P4GOAJoc2A5WCd
X-Google-Smtp-Source: AGHT+IGHnd4RFXbgbB3OrosL7qB5tOgDzhfO28BiCMwLqh/qN4I2L1LVeirHk79ZmR9Ai0ZG4O5n7Q==
X-Received: by 2002:a05:6512:12cd:b0:533:483f:9562 with SMTP id 2adb3069b0e04-53b1a39b148mr7062701e87.42.1729793401678;
        Thu, 24 Oct 2024 11:10:01 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a223e5951sm1431682e87.58.2024.10.24.11.09.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:57 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:50 +0300
Message-ID: <20241024180950.5269-1-vladimirputin693389@gmail.com>
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
