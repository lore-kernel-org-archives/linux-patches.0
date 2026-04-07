Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906B837EFF8
	for <patches@lists.linux.dev>; Tue,  7 Apr 2026 06:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775544232; cv=none; b=pANdVGqnwNvxww0xeCY2Wh5fgMQxOd+2tUT1Nqhq44eA3SDwVALIbKVcea/E43lGZ6nW9N8cxkH9J01glTLrvaCw0FpFtEdXbFvRtqTcsZQtNHpriTy7yGLWhuaNCTcjJVhkJ7a5QdnPo6KalWij0+CpDyZl0rEs6Okz/x9w154=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775544232; c=relaxed/simple;
	bh=aFb1INi/NUNadwFavlaxDB5+UNJh/ScJxVg4b+I3juQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H7AN+V6MFkoicFl7Ob71CZMHqDOIPontMdOv/0cv73nML0RRjIV/fXTBPQY1pa/vKd+dEFmqDlHcpcZm/f+wytUfr2MB7FVh1O4C0UNCML2dK+BErGaDBGLJ7xWXA4tIyr2C41u/+lBgbfbBqAblqnunufwAFGKT7qUeQ6sNlkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BZhsHIyP; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BZhsHIyP"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-488a9033b2cso22958725e9.2
        for <patches@lists.linux.dev>; Mon, 06 Apr 2026 23:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775544230; x=1776149030; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7ZGa67ZFGELe5bUP+eZlyvbCuIknlSmdEyMWxXen444=;
        b=BZhsHIyPxDJBYCzmBilN8beh37xF6fIY0zrSa0vwiyktDrfPXsJNYUy3telPNIm16x
         UHKJCPvNgfur6TNTdyIsPokzRbEs/rOrDh3Ol7y8K54xFXZulkroH/M9g2Vm60mjIynl
         89/E7uoyMi+hG56sBhmmXryGDNMJcVBXjfuGgc7FaRUd9etGx5B394St0p90aQqjJ9eY
         +IBcj2rQK8IMkO7H0OZdpAopkFgLNKZ0V/GrNnd3eL4dBiWg9Ve5ct5eHLcjwdctOJDR
         haP6z1/XY0oDg9TYNK/CBq5xU44r7s9vNlUZUmmmC1eTDw/ZJqeQNh6KAdsDMuxCIldC
         Bsqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775544230; x=1776149030;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7ZGa67ZFGELe5bUP+eZlyvbCuIknlSmdEyMWxXen444=;
        b=WTHxtP8mwEs/YOxJtnIe8HlX3o2+P1RjSQkorZ2PVp3zpUFkUucdpdmRN6AVBx28rN
         fgWgj/NCu0lq8rgFHeIvG/pu/DRxBMMiVjvJMHsW1mBlwzSVs2rLnno+j2vVlhERnx36
         /4CLlU//TSJTR//CxVFEwkxiESmgiEUMZvsAio2H//sAbRX9m18azA7bLMREMcgqmRvY
         uc3jah6GpDlSsRl28V1l6hgkssj7eEVJIKNCY+qmMmS/5o8JSvKlDS51s7FOd59OAG3z
         ks7gMxfNXfo3Q85domkyR7Ps2JkJHvYRzPgni0nDsFFuR0bXPPJ5OsIl9Rn9dk+RjtQM
         O4zQ==
X-Forwarded-Encrypted: i=1; AJvYcCWJfwh3+jwNE8Ne4is5YTFPqgILwVxKEVSStH3PyMKdgm9osxtqBJRW0pCwnHlppTk8F6ziLiDS@lists.linux.dev
X-Gm-Message-State: AOJu0YzOLg6EwUdxKi61JWANp0yVnFuZMMGfuQ+hYS0c0Vqfpz7Fh/KI
	L27J/UxJ0CqAxlPJVUgaUjpYdIQtciDcXy/79OXpS+NsuHp4kw3Bqvxw
X-Gm-Gg: AeBDiesJDDWOmHISw9mpNcvtGk3GrUJcURbs3ljGa1X+FXDrG77NPZ9NqyKO+fHrKIQ
	tHXygUjLuJbX8RyMhzbi9k/+eK1HLFYIfmD2JLvtqNB7mL/mvtmetVPJRqwTUN0ZG/GgQ70ON89
	xGkGVP3eTfVtvY6DwrhtWamQLsTWucDafIzS+NGWV/2Mp39bILSagVDJLh0w8mrC3Tuyoiuz3Sd
	DgTIFGI9A8ykVV6UKBDN7mJZ5WEIQQtQ3Ehj06QpGcZATywKHbEe7/RXklaYPHvBQiEGlpu3KlL
	BIXBPZRjbKmWSIOOpXTtRI2YFlA1NbZTnA+EzAIDzBPN58ci8yrvsRnCQ5dqblNnPBHtcJlFVsE
	uquIRTctkLLemUmIn9hkeHrZEp293wlZ61oc92iP54Oci/2auXSdThhDfKGItzsJGr+VauO9Yqn
	n+hD40a3YhjbovL7dOpDY=
X-Received: by 2002:a05:600c:4512:b0:488:9324:3ab8 with SMTP id 5b1f17b1804b1-4889977604emr216797945e9.18.1775544229793;
        Mon, 06 Apr 2026 23:43:49 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-488be58c982sm10502235e9.31.2026.04.06.23.43.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Apr 2026 23:43:49 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: brauner@kernel.org,
	ddiss@suse.de,
	initramfs@vger.kernel.org,
	jack@suse.cz,
	kernel-janitors@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	rdunlap@infradead.org,
	safinaskar@gmail.com
Subject: Re: [PATCH] vfs: init/main.c: change comment: opening /dev/console may fail
Date: Tue,  7 Apr 2026 09:43:09 +0300
Message-ID: <20260407064309.3223598-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260406095452.GY3836593@ZenIV>
References: <20260406095452.GY3836593@ZenIV>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Al Viro <viro@zeniv.linux.org.uk>:
> ITYM "so if you supply your own internal initramfs, make sure /dev/console is there"

I want to write browser extension for expanding your acronyms like "ITYM".

Okay, I will fix in the next version.

-- 
Askar Safin
