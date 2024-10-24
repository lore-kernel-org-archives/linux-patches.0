Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AFF31D3195
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793398; cv=none; b=VOujfTZ8zOf9hNmyZSGi2PTpuHrGSm+9Rcitqy1QV9Uq+AzWqgRayH7I4vNcir37xEhIujZdDrbEeOcnG6uBlkDSUuH8A49BnIf5Z1QxIrhdcQncAWlciqLcDllHa9m3TZRvOuv7PwEGiz96Qf4iqtTb/ePWyJxM0jukRrWJqhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793398; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dc9oXhn3MmXiohePX4aNdfUgpXKYRQcHfrtvEmh0ZPROTDRir+JUGF+6HH2A7XWlViEPr4G7oEhb8zV12aR+JFsxUmzYYHApNOT0kjfxqYG/I7F1uXtQk2CsoIdEJawB3qnHn/RPcQtm8q2mEXXyaduHb7K/L/MiytKU1dZqKg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hciCjrrW; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hciCjrrW"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-539f1292a9bso1603960e87.2
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793395; x=1730398195; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=hciCjrrW3oboTa2+l4Vs1QKBj52uVdvya/Kizkzuid9r3EyS863BnN1b4s7Nz/0Jwz
         eMG7n3yhl3W+1lhQgzwRwUEN6ZZECwHBhxwo/vKBX2MGEXxFJVYm3qYhkg8eUVW5Sv9H
         g7MoshULQfTL0P/mcMNWCiP3kJul4jJpMLoTOavUPRsURY4iytY5iwfiowf+fF8D0Qbj
         aVB0znQVUrrEH9/2kIlssoaDOagZ5FjIsTj49SLlRS9tpTiAFOQxWfSSLiP9P9ajKodk
         +PPC/5IO/GxVispGAMEVa+IReJuqgou6xHmqB9FxItg6KIPuqbKcZ4fEFvmIpkc3KVFX
         AUcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793395; x=1730398195;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=ZDLvblJXDm/KeEIA8WqCMv7uGR7pWb//EiiMYNamCS09Y/IuMoUlTPLnHQV16DiFn0
         LGgXSaQA5jy8YewwcTit+/kLd6zYFltxKUl8dVM3TDsDvac9MaP9+6wI6p3KWxAPazk1
         gBt2sMgofnL5jWJ5DPe9xrixG5Dszg5XL3OMRjihZv8ckfKAcUA4BVCnn3auJWoLPFhl
         Ri654eKLIUFO3QnflAxjua9Jvm9HOVvsWvAerCWhFpGuMTsSfkT+mb+iLe0MhZ+nb69P
         5sEPGZ4MNu8Om1SWTgA0jE4EhTluMTNjGl1tuvEnLibPkRcPr0+SpwCSBISWM8EZXeJP
         ojNA==
X-Gm-Message-State: AOJu0Yz0ejluQEVoYkn/bEd+cY72gd95GrIdJMUs/hkZAtq0DOb7JfCY
	mR2UH17g7q66PHD43L8nZsWVeMxhTb+CnD3Fy2jzPv2cG7rAiOjfg83r1g==
X-Google-Smtp-Source: AGHT+IEBjLYGyPzrR+JVI8ijSkQeDfe24XmzCnMrvjmPsRZKU3fbOD+t6XJpgHfbU4WSWbFz50G2JA==
X-Received: by 2002:a05:6512:2392:b0:539:f699:bb29 with SMTP id 2adb3069b0e04-53b23df629dmr1766200e87.15.1729793394531;
        Thu, 24 Oct 2024 11:09:54 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a223f0007sm1431222e87.91.2024.10.24.11.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:54 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:47 +0300
Message-ID: <20241024180947.4702-1-vladimirputin693389@gmail.com>
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
