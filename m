Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E401F5831
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793417; cv=none; b=phei7wgjAEFiFh7bgU7e0v5D7FINcf7LS6S0MLRSzmFeFcnbhzGRm37fTn8xXP4t3/b2W3ZreKv9j9Ox5xKMlHKGIMzdJJ/+7WOHfLqEO6ugaaw23LqXICAlXgGCncRvl2z4mRXjiyNPsP477RRKZgvVU3ocoClPbQaU+nqRS88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793417; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ltXdZm0GsX4F7Tq078dZBqSIYaQQaN5S0K3qglj5EdWJmHxm9BELXm1a10qT4Szhz/Xd+MUiIFJJVbvFWCK5C5hLBARJIvbGa4c2PMs0BW4XvWMMkp9Py7H818xycbv54ZzkV+aFDI77ZCdOQM7PRqGqtF3+f3mjg2GyPS85C6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X1Ju0Dxo; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X1Ju0Dxo"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2fb3c3d5513so12667941fa.1
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793413; x=1730398213; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=X1Ju0DxogbtV6R7IEVm5rK2BO3DrSsZcGqRyQUNnEYZ8SIeRU2jXypgEMFZxel/gAx
         qZa8n5oSuV9oU5nbGzC0oeXjNqB59U0r03hzQfKKxwm5UcVocFm6mazDllMJ2SpJsGo9
         0nXsVFTTsNaxetbZrGARQ14HZ79LFLROEG6kSDqFlnqYk8Q7+ITrauYW4vFM4haOTSHm
         UFmaCgCLLp8Xo7ttaGZqatWFTAq/nwctzXmH6fXE/On7rZiHluUy+0D4Q6HjoTlEnc3+
         d0sc740lUqZPhNVHAue4H1HTEhm/VTesIa3v2FOQZXjsk9OHedexlaKHja4beSglVElj
         jfjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793413; x=1730398213;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=krPVAC9BaGBFm2ga7X1/Xn7Cut4prYA2fLkT3JloGfU/rNSKUq/J3BAU2wbLxIepRG
         cAiSVXS9gJ9DUeBS0Qw751QNwouLth5yrRK5tqBeAfv0r3gTu4xy08zJNo1J47LnOwWr
         AZaBbNPhBOCkrayqz+XGVFpWqErTjXUSwKb8fm4AhvRyTZSCE0XbNu+fGtZ+CYiR5dJX
         3BbgjKh4hUxrIlFHH2kSZlLidPl1KnGLKlHJ1s5AArJ595sn1TZLeLLCtUx27B/tyimM
         KDFFRdKGKsaQJq6cz0PJMFu1gR99w+WFOSrDJUvy4pWHkn9IHpCDUQZEefb5u5PxCIeV
         XKkA==
X-Gm-Message-State: AOJu0YzPS8vKRWUPbIuUq8c3p+ZQpwkIbLmij+ZRgAwV4mbytm9SlW+k
	K0EoLVU6nuNEm5t2lMVZMlUNc0yy56BgIMw45VspHNogZvvr32+EtKli0dnc
X-Google-Smtp-Source: AGHT+IF4Kk7VPSEqgFRDycxPRcwHs7pTNJLgWaBjKY5RL1PRHIDIZWWzxqlsbpgrmpC8v9Z8SXh1IA==
X-Received: by 2002:a2e:819:0:b0:2fa:dc24:a374 with SMTP id 38308e7fff4ca-2fc9d581de3mr31236961fa.37.1729793413384;
        Thu, 24 Oct 2024 11:10:13 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2fb9ae25a9asm14303231fa.135.2024.10.24.11.10.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:09 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:10:00 +0300
Message-ID: <20241024181000.7066-1-vladimirputin693389@gmail.com>
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
