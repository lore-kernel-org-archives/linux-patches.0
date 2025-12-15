Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B963233FA
	for <patches@lists.linux.dev>; Mon, 15 Dec 2025 17:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765821584; cv=none; b=PssAhT6NV5gSAbrJYukhloQSdlNpLjBVtB8G/KykClRnM0A/EKQEQV3CCOm5b88tDfdLkAv69gMaPF6eE8jqvfBS/1g7DtgOd+1SOsFhJerAVcKq6mcxJqXOR86u+mIgxwP5gVd1Xi02X8c2+Sl5zytWyaLgv5ZF0AF8KmbiBVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765821584; c=relaxed/simple;
	bh=rKVKnsmZY5Zk5WseCbLhC70tZU73oYSI0ZX68nvqOpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OgNhlcnxX4w4PKrkTVsnYceKQ+eF4/FTUHGXa8VgEXtjjYWOjMItBIqVO9PKMlCmVTbGcxGPn4/6uUA3fZkIYH+4BCrSmFiN8JmIntPoaM/wSmcdyzSFHt86DxXlRpO8A+AINXOzdhme462ISn4ZyAdO+QkwwrDaZUhVlWFdkAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LA71qtmi; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LA71qtmi"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-597c83bb5c2so3248217e87.3
        for <patches@lists.linux.dev>; Mon, 15 Dec 2025 09:59:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765821580; x=1766426380; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zIbn2oDFRSGWfD5W22SaWrURpraJkYSQ1nm0bbeV7eo=;
        b=LA71qtmiImXImDiBANGytZUbaoXhn8NbjZQUnqgL4t46+3KlbmRYA8UqmT5+5CHipx
         Hhoc9GvlbNyUcZRPSvOAA/GJbm323EmwCgJwP0WyXdgRhVmLauWurtQLVUbOQBe7nIXS
         znHSeIQY7JB0TcfagK5AWA203KhSOMaK73KbHc4BC/Smg71RBCyupgAPL8AYpKqx5JNv
         Dbc14/NRwWwO8VjZZJLDR5jOGVdo7WWd9nSSNeWYEB53P6EzcD2SaUagkqw9EtlBpbT3
         5rdcoLHgbqjKq+fWv8CmGeU1/WN3Qd9AxutjSI6B5nBZKc1fb4tRuE4HJXFfcboUqFNy
         Apkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765821580; x=1766426380;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zIbn2oDFRSGWfD5W22SaWrURpraJkYSQ1nm0bbeV7eo=;
        b=Cr/0n+W95cWbsfjevwteuXJCT0QtyoOOcwgmUTHwNWgq5wM2/JcYpWuQHHz1zZWN/g
         6QoSEmZPcwwkBvoVuHgzn03TdnafPIAvcCRQwspI0qHnkHE1dbwEUerdViyrLa9G4RY3
         XnDZQmpmqyMD/cYxblNLOhCFoGMYsHKaQM5FAb7rrmFcvDY6rAI07OMKoTWP8Xt+2iYh
         FHBXD68HoO8QefxEQ//7y7Lyixwr7oigc/MqSNwan3I8/HBv8vTDq+gJ8PqpmkA9zmis
         ZWwAUnuiNSbL496GN+Q32VOWYdIfzcsa+4hgaxKdS+nMArbtP2Aqr51KODKWcRD4qJH4
         f0wg==
X-Forwarded-Encrypted: i=1; AJvYcCVppa1P3pKTRO7UTPRA3wlp+P5cE1BzGdkLZYj6bMtkdYNkOTXq+CjnINw9oBmEYiIEfEZvscic@lists.linux.dev
X-Gm-Message-State: AOJu0YwOGVrIEWsWNhwymmMJLDtKLwGYG+wc4Fa/K+k0o8xvyXPRsAd0
	flI0xj6cd6NdRsvwShcD119jwamRIGtwlUWLOqwhpIa1NTV+HrbhzJZQ
X-Gm-Gg: AY/fxX7itlYc6A/eKUBhrahJTqi+FM3djXOXfe18pG+UidX1LvQx5Kxc0B1eMvuTnEq
	Wrdj/XOczrxBRvuAsLoxV7G9UsL9rJpL/OjvxOLZK4jMhDg27tLY/zpnLqO7qjwaBlBWg8SLVlL
	n1Rw34Rgd8OR4o74iyotEfPxjExjA58535iILjarUn7Sa/IqKd0wKjR8O9BgXvWmNCCAqwBJF7g
	y/Uf3QP9cJgZ2BCN3MkMI6d8YtgLBDkRsxkshF6d+h38WEz+sHU0NsMHc+oHVLDT6tkifCna6wq
	xhQuWHwiBMQE+Uyc5b26Y7V90SRrmzwzAZYPJYkcwI2LPKSEQkKjjJ5t6BnVm3nqWOZYFeNPoNr
	rNXuXOPTnmubEKeL9BmFhVRxuJoucKIvYsGdHKswo7MrWxMnKp/RHg3kplqkIsV/lmXvYnFNHOW
	I5dxBNZ2GP
X-Google-Smtp-Source: AGHT+IFsDUVoZATaLzj9N1/hjfRE03GZ2gIP+Qj4HQeX9tt2ONoJL779FMDFpau9DQULSPR5u/L2Cg==
X-Received: by 2002:a05:6512:1154:b0:597:d59a:69ca with SMTP id 2adb3069b0e04-598faa4d5b5mr3889154e87.28.1765821580147;
        Mon, 15 Dec 2025 09:59:40 -0800 (PST)
Received: from localhost ([194.190.17.114])
        by smtp.gmail.com with UTF8SMTPSA id 2adb3069b0e04-5990da11dbfsm5648e87.13.2025.12.15.09.59.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Dec 2025 09:59:39 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: rdunlap@infradead.org
Cc: initramfs@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v4 1/3] init: remove deprecated "load_ramdisk" and "prompt_ramdisk" command line parameters
Date: Mon, 15 Dec 2025 20:59:27 +0300
Message-ID: <20251215175927.300936-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <5c3c4233-3572-4842-850e-0a88ce16eee3@infradead.org>
References: <5c3c4233-3572-4842-850e-0a88ce16eee3@infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Randy Dunlap <rdunlap@infradead.org>:
> Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
> 
> Thanks.

Thank you!

P. S. For unknown reasons I don't see your email in my Gmail. Not even in
spam folder.


-- 
Askar Safin
