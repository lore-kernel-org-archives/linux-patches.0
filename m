Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB77E2F25F9
	for <patches@lists.linux.dev>; Mon, 23 Feb 2026 17:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771868090; cv=none; b=eGZh1drMH0iJOuaYVIJFlG+g+xF1nMnhhUIWQ0RkFLM9g5dwEC5pZ97UDQIJPOmkbphV+EZHJ2f5slZU+/2cZFNt3pnuC4E1FQTnnTL72FMc6O4fsQG32Gks7QN5UB23tdfU0q5+cWD1hJL/u5uY+46th1pCjRPwgLxHFBKia9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771868090; c=relaxed/simple;
	bh=pPVYjjX+g8lwuvjjX9cEbFdLG+Rgns4g94OuadbV+lI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kost/b5tnWNvb15T1hed2/HwNhjB5oLrqZG/EP5eNxpgMoIQhIROch6DDf/DonR2z1KooPkqH0Jo4jV1gVXo+Wfpk2GaYQnJpQ7oTc/cFBWCLKjlDNO6v+e4K6omwLNsGEWp2xNFNB17ie0194foPbtJVatVCktp0BPUM+XQ1+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HYIy0Nvf; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HYIy0Nvf"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-483487335c2so42574945e9.2
        for <patches@lists.linux.dev>; Mon, 23 Feb 2026 09:34:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771868088; x=1772472888; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HUEz6YAu4nuheVqgpSXCLvSWu/dJuHAVRYNHbZZUc14=;
        b=HYIy0NvfDVYb515Outmlgzg54RkSbbGObdT+taZ4xEoX9r9sVt8gCywHhSbkU+nOWB
         2Su9y2sz/4WymDNDmCpLmaIbHdHbZgC82E2nCd12URJ6mq04rRjq/mulNDQxWlM+wTKA
         goVVmG5EW7FEzSA4k1BPc/a6+W6S7KkveeXZvMUQLxeY/N1qdg5BkrUOiQN3dtXZcReh
         sUAjxrwuMlqRsi2G8kNE/JMbHGi0TE/7821soSN4E2sWdJXi5Vw9EMBCtiTK2gr8aDHS
         VNyhCf8I+vLohyzi23Dif5LlJcNUuM+4nHm4+IsuF1Bo8O5IuocCC3iYDlBDjxYwIttY
         AGFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771868088; x=1772472888;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HUEz6YAu4nuheVqgpSXCLvSWu/dJuHAVRYNHbZZUc14=;
        b=QKGZhZRtVy2u4D0CmyMXkbRgnOHxp6wu++SIKkoahhxoZoQGrwRewaYMkldA3Nuw+S
         domUJ48iDUs1OjID7YuHN6OWQRRa8a7F2thfqaBg9dnxuUe3IX+zkVr+SpeQVs1n6MhN
         ed6uzpRTDzMvxhksTmXnsJlcr8ljoId/urqLxVe3Eu3az+1jJIoRuiGWOz5QVfUakSBJ
         TIBak1A+UrWMcxTkEQ311wJ5M2bpBoJXP7RCSkK3lnCqfbhiMNPqH+bLH32lzFKaNBqZ
         9HcBckjRSBqOWpd+3Wh/qYAoQmovdGqqndP1EzdTU2zL0QpEJ4jiW2LMgOs6AERkOm9N
         tltw==
X-Forwarded-Encrypted: i=1; AJvYcCV4hEFgNK1mW6trsZz2wDGBELDx/tJQRD4auFWJXe5nGvRQ24LI8+DWV9cs55O6g/jyhgZkbkB9@lists.linux.dev
X-Gm-Message-State: AOJu0YwU040alIfN2Q+Vjg0FJkz3frwo2YmtHZ8BG8xQhoUJEqFW8fVr
	Qk3Hcd7ydhpfIW3PfRnsORhEWPxu9rvhxBd3SVlpKMSaWcYBuKcAYNnL
X-Gm-Gg: AZuq6aJbfQ30wwd2Ln+KRT/oNj3SxJApG+V+ktrCjT+4mExz04QyQBPofV2THQrT40+
	rdT/UAqK3JhI1mgaSZEvXH2V+0UOfwCjk8WkaO8LfyrfcCLuYHYkm/bEcVwD96dAxKcebMhnT1q
	78wFa9JNdOpPoJfKK/RPGDae+rDxxpx1XkBU+n08Hu4Oe/M5N6jgO04hCraq5by9BXny6pEu3ZJ
	ljp+DbldNcXHrG/s+VeDcE6yBJFrnPgDic9LVbZ2q2vqtu+TzFX9dz8iHKXco0gV8uuZ8NaBDlI
	1PgyKcEUpzU9J7GT29igJAw7YrGQ253SOWZribhHrur+CkFe1cDgkoybM2ArLH94SjXE2gu3SOD
	EwCCUg5FjadPAo/pR+t+ehWAg6v2RxllrcuTpo8s3TNGov+V0jeZpQ/4THVoHuqsjT2ShvqEv/D
	IrV90nzSDnPe3sDWLNFjc=
X-Received: by 2002:a05:600c:45ce:b0:483:a895:9d85 with SMTP id 5b1f17b1804b1-483a95b3e18mr165817715e9.2.1771868087959;
        Mon, 23 Feb 2026 09:34:47 -0800 (PST)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-483a9b668f3sm213824665e9.3.2026.02.23.09.34.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Feb 2026 09:34:47 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: rob@landley.net
Cc: brauner@kernel.org,
	ddiss@suse.de,
	initramfs@vger.kernel.org,
	jack@suse.cz,
	linux-fsdevel@vger.kernel.org,
	linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nathan@kernel.org,
	nsc@kernel.org,
	patches@lists.linux.dev,
	rdunlap@infradead.org,
	safinaskar@gmail.com,
	viro@zeniv.linux.org.uk
Subject: Re: [PATCH 1/2] init: ensure that /dev/console is (nearly) always available in initramfs
Date: Mon, 23 Feb 2026 20:34:42 +0300
Message-ID: <20260223173443.327797-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <7e309fc3-7d55-4e95-8dea-f164a7a96b6c@landley.net>
References: <7e309fc3-7d55-4e95-8dea-f164a7a96b6c@landley.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rob Landley <rob@landley.net>:
> The real problem isn't cpio, it's that the kernel interface

So there is some bug here?

Then, please, describe properly this bug.

I. e. using usual formula "steps to reproduce - what I got - what I expected to see".

Also, does the kernel broke *documented* feature? If indeed some
*documented* feature doesn't work, then this is indeed very real bug.

I kindly ask you, please, please, describe this bug. I really want
to help you.

-- 
Askar Safin
