Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A351FF7B9
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793397; cv=none; b=AwWTRmHGzonM/jVURFynPHCqBmLPBswIsfpFb9wJt62E4uhrm+H5VLk1o70rZi2I3lj+MfuqZUbcjpjP9s5ne0A+NaYO7h/ZaZATzNl/pP0nco84ohjCTVnwMVNHf5PaZl9bP0n2DO42XzGhz7tJYO4BjetgOD50gK87ZJsFfJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793397; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YWANLNGEfxy8T1jLV2mBJ5u6wW2DP8DF+ZSN6jLt6/2SDEvhhbPrvyui7A3+BQvHC7T3scHC67OHZglbVG+CivXGC108fS3avN1dDx9WWeevBO6XXImHwTZRVNlfCO/pSivJ6tg/s+OU1o27WA50Q5QbQ9Hmr/dK7yCbszhs28I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KTNTqaNU; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KTNTqaNU"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2fb3c3d5513so12664791fa.1
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793394; x=1730398194; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=KTNTqaNU+GMaynixICvEnkemViNEUtsAYYgNJwke8EEiIRLKwwdfLRdE0/a3Bp98Y0
         9lsqx4kGFAt7oeS37dYPsylwfA4NdVqvkcUhm7AlPQvuTiJxmr1NmDpiT/PT2ix0vuVf
         86M+T0nm6efDv3586UWpFSD/7V2o95JgpRWII+wA28wDw2+FBdJf7iBxU/dUDxbLaJyr
         WMwfv3dcCKt//AbSuDBTFhbaLE3heIlNsVIi1mErzw0nik/7uR8dA61S0ZJh2e78BZTB
         JwXLe0s4r2e9gc5lioCMuHpXVEISh6BoWewFuQ3lxuP5M3QWoVHQ0lwurBSsmtDQWliw
         JoKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793394; x=1730398194;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=IplvF/9VPvD9PYnhVty+xDv08khM1gpv9csWfEUlVesFsgOsPWOqrmxFGlEqxmMoeY
         KgNxV0zQnlLL8SCLQYXzekK7YEyqLuvZgODB/VfZ9G/ppXv84zvrZBanUNxyJjd/nIWz
         Bk1ikrNpZKGZiPCvE4MZ2Fm6JI6AxWSztTneZcfgA+jUIGFxvsBjiHedVaJDSySmFaKH
         +kZN8fuDyOqvYIC1ifCOtCEiAl1syf3MfWkdpdYieXFGz8hA/SqwZB8Koh5Qkfmg9xFB
         wc+NkY5wNa3UrFgK30Ys3B8QQUA4XsE2AIjJj0NulEtDAIydL9/RYwku6OEj8YPTuPUi
         eg7Q==
X-Gm-Message-State: AOJu0Yx2U9a+gmvypwZ+qnJqmOa9O64pK4AUHQrvJgDIJC5Do5ueIvSj
	tJC3T7+4acbDOBn0uFOGizzqzLZDuqfqoLqwWI6dfxX4jtyznLiJ
X-Google-Smtp-Source: AGHT+IF3I4ZVQ/mvfsiFsipP+G/I4aJZ45FsxDe5/J2pQ9Fc1sm1uVG7d7pz9hitC7WfFLksb+xT3A==
X-Received: by 2002:a05:651c:2109:b0:2fb:51a2:4f63 with SMTP id 38308e7fff4ca-2fc9d384beamr41885091fa.34.1729793393742;
        Thu, 24 Oct 2024 11:09:53 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2fb9ae242a1sm14714381fa.122.2024.10.24.11.09.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:50 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:43 +0300
Message-ID: <20241024180943.3736-1-vladimirputin693389@gmail.com>
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
