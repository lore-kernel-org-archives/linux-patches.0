Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996D3279908
	for <patches@lists.linux.dev>; Sat,  7 Feb 2026 16:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770480578; cv=none; b=n8n946R1i1NjIVXk7LyhEGbec5BcU9Rv1/3a0nfR0vyzBskuDLC86hfYZDAQBooonWbjhCJzG6uxzI9cak5v3f0/PjY+DsBpZi+/r6zyq/wMMPTcIiODVr+83030vv3gJvH2w84XPKND9cevQuEyZu3ZJ1QCYc+EsXtNzhWHzSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770480578; c=relaxed/simple;
	bh=Go6o+fPW2vfcvS7DHrVPUB1C51P0F8I280rZ9fGZJFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ee0CwMNIim3VQxxIj+9GhHKoHeFY32ukwl4uNdIbxhgBUNgbJwX7fATawJaKA5nHICTU7NkCpXemXVUlY4JxdZHgZ4GmY1mh7pvizty77Tz42b17I2cL+zeKbH2L712wgIDdJRbymYvnqtmYKT5atDO+iTCbN/Qbf2d4ZA9jJwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e8YgIeNC; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e8YgIeNC"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-47f5c2283b6so28852165e9.1
        for <patches@lists.linux.dev>; Sat, 07 Feb 2026 08:09:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770480576; x=1771085376; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zh0gpgjFwNimG3qav3V/O/Bh53M5i2Ji+XR/lDx+9ZI=;
        b=e8YgIeNC7MgT+GlAjTzom1Kb1iMHyr1poPX6u3Wp34+0QboRpTt6XdsYP5rdv02s7G
         QkZzDT5OIlJIvVkpYTs62sZk3J1A3mEcki2G6fDd3zg0RXtsGlMvfzoUxFhmJxh5l5f/
         MqYYeT3jsvgA1jVE867ygRX2/qP2rBUW7caD/bMKOTer0wcaIHB7F71xtiydcADHI8Yf
         Kcb2F4jjsIWTE/YWTyl3O+e+gHtIteEwZ15m8Wry5bEzdo894Ub8g3u8xiFYsFGckplU
         U3EuROx/3X/FyaHUXQpUA72FfpSfmrci159b+SOlDeBOFFHxOOU1vgVNWuHasUHgid7F
         fFGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770480576; x=1771085376;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zh0gpgjFwNimG3qav3V/O/Bh53M5i2Ji+XR/lDx+9ZI=;
        b=n/nZ4Efzj4rxZnmyeaqGNzTvfCN6jh/H9r7Vc/Sx+jRTsPxszRIUiehPw3fnjxTlTS
         eAePs6l84riSGZ5ma/4Adqy0XxYG/ExWmHk7k7TSLvmLFkyrXfKZXl4iI0H+K6q4wvHL
         iN/doXiWOfa13dxjjlRBVqnDl0a7C0eRclKNiXCWF5utDuLI+diqoVyn8C1vPolSZGZ6
         GhmZz+z6rW896winul44Db5eqnfvjAo9XbjWK3P4+X3W4EqYFkVYF6GJBnMtNVeJabTq
         sMHrHb9sA0WLaU0jxPo4Zg36Rh6ITFF33o6Yp18tcKRzkgFKBUCNVSqHjU1JGHhbEDhY
         XSsg==
X-Forwarded-Encrypted: i=1; AJvYcCW2NbpGbrZ45VK17591iMkKv+BCAx+pOFX8z5VDOesxpoPMwBlTmo77QEmgVLqr5O0afxUdR36I@lists.linux.dev
X-Gm-Message-State: AOJu0YwcP8xqq3ctN/uHlb4hYOAIMGlkqBm2HJKT06y/ig8rLpVlUBly
	n2ys/yGVtM8RL9EkFBISgsLvnF/hhepSLSnpcYymnfXGf3Buulqf2IXl
X-Gm-Gg: AZuq6aIHE6GuqLqTQ+GIiwfEGO/bi1wOXf/8EWR33EGPmw74psvto/uyTAtT+27V61n
	VTsm5tLOMakesedS71WfyiI+Ek2GXuOOnufGvGZt+pVG8KeAup9qA3sXWlMgofDV8w3SU4jHpC5
	In4wIHyea08c+MvsNrMrwAIzy1xmmCI5QVpntkIauzm/2Wv5w7jKciJNW5I+TcTWRirFqk03r6N
	U3pa/VvZREwlguDsAo/wor9mmUKx9nLkUIPaYUH5840vTqDWGNSF0AgftRW8hJDG6170/CL32K6
	urHiKr4XI2ztWHg7Fao0+HTFIo/3axzudIx3ceDSNz/ji4z8Yq4d9DiodtdR5TiPkyEg4FpWg2I
	CHK/1r2RjjU/YGACFguTdu17aCDX8Ye8wlOV5ai90pTzsikqMlCYRBEGu+Ws9wFkENhxVUXX4Xh
	t7BaONWIQ=
X-Received: by 2002:a05:600c:3b20:b0:47a:9560:ec28 with SMTP id 5b1f17b1804b1-4832020df6amr83848325e9.13.1770480575641;
        Sat, 07 Feb 2026 08:09:35 -0800 (PST)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-48323c12d74sm77930395e9.2.2026.02.07.08.09.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Feb 2026 08:09:34 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: linux-alpha@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linmag7@gmail.com,
	linux-kernel@vger.kernel.org,
	macro@orcam.me.uk,
	mattst88@gmail.com,
	patches@lists.linux.dev,
	richard.henderson@linaro.org
Subject: Re: [PATCH v2 0/1] alpha: trivial: remove ^L chars
Date: Sat,  7 Feb 2026 19:09:16 +0300
Message-ID: <20260207160929.705315-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260111112217.2126872-1-safinaskar@gmail.com>
References: <20260111112217.2126872-1-safinaskar@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Askar Safin <safinaskar@gmail.com>:
> Remove ^L (a. k. a. \f a. k. a. form feed a. k. a. \x0c) from arch/alpha.

So? You missed this patch?

-- 
Askar Safin
