Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6FA3E3D8E
	for <patches@lists.linux.dev>; Wed, 23 Sep 2026 20:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790196130; cv=none; b=Ms6Z4ybXFqS+K79ulvHZXLTRgrXYOOOJtAh/ZxVwLFH3L3hIGHAroND0zrmyMX3yRr5iJWFo6s9IC0ZC3/0oLwo8gb5NCBlYW58qhIUk+8uBnrvl2h/SaNPCvJunlgNHsMw2QSTn+F6kdHbfpYD3CjyTNtFZvs9SY08+z7WtfRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790196130; c=relaxed/simple;
	bh=X7R9IrSos6cqCrnKYU8/u9DylC5NgZsXQ/kcQyXen2w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iV6ytMHB020wLrrQrYw63NZsrkcc9u8DF+hNWNByuR8LNFQyBjFmdXb+z8DDdkA/ct6A03Cl5gTl7RUNOzcXct+0Pkok6IozgDXDRaduJMn8QcmRgOz5yKG9c4bT9QZAryB7axCq+4fZ4Oy4qRxcpqT5CPHa+tUokD+fbfiJlqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pqi4gvKV; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pqi4gvKV"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e721b5503so12137315e9.0
        for <patches@lists.linux.dev>; Wed, 23 Sep 2026 13:42:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790196127; x=1790800927; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=X7R9IrSos6cqCrnKYU8/u9DylC5NgZsXQ/kcQyXen2w=;
        b=Pqi4gvKVhBkSnvlQEfQhqgXJ5oBQ0deHmhog+PmVMDYY+NpVWdNO7ljVVIzlRbIEHk
         PBn9hLYbxEvZ0P1xCztHCrQqEqku+Al+xrgkwj/0UDcwlvnceM7ifMm0WDzu17UbFOPd
         QGzbq0c7gcXnXRL5thQzxIVkkIu3kDV/8islO24FbT9zVKUe0Awd06sTanOUocCkBo4p
         tb31qp5jMUl+QyAA4rg+Y1hOkqiHtn0fNYAifYx+P0Gs7uL1MULHlcdL8Qd1Bgj57xzz
         DLd15ij+bVpvt2csedSmdlPeoNMG7kp73oaT3WgRyb7TGY/iVXUzIKW6YNYwt97k6oI2
         5vzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790196127; x=1790800927;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=X7R9IrSos6cqCrnKYU8/u9DylC5NgZsXQ/kcQyXen2w=;
        b=gQj128wVdzC4U/bwEk6m524nNB6vJoFxlXohGY/whrpFRZjN3nor7+laxeOHuxH40l
         3rocQA/7hbgCWISXScYVIUo+V0U1NdYl32T+cmXfRFpDYA26+RGGXPMDAM9sXgVG9Z7D
         /7i5zcV9/b2EkMgD1fXktazM/4hc0HkzzjDRK6ja6/KPJTNF2HTDWRFyZaxF2yEW9W5f
         fRL2kr78cIFeWijYh/F1HoGkBBt+XkrcSu81Cqiln9eFEfMziKJC+91I66AUBpxr2ULo
         516yA4sF0qBCxZ+I+YzuxGdRm8k6Fywj9g819QlPZkz3h0HjoeSxR1l+NGJzi1KRHOg3
         V6lQ==
X-Forwarded-Encrypted: i=1; AKwUvByl9rKl/euliE5m0hOWfobC7RkCXyG+OGESJXJKJ4q2dhfQNOm21azga/uH4zQMTppLg3zzF3WM@lists.linux.dev
X-Gm-Message-State: AFuF++kc9d1IvhNDpbiplEzd8X/KiG/fSKEouepwrLml+498PSG+qNmk
	fWYyH8lV8qzaY43F8HyPU0n8u2kfewo3SppwkaLGW9rFHe5aZTJOqRRS
X-Gm-Gg: AYBFou3Dp4CkZuv/tOmy8KhdlG4CbOGZqNdpMbKpWXz1u47k8mnmMJvoe32lWZkcuL6
	So7h4N42wIChnj+SjmMGXWD4JtXAH6Cglt9TZCwrLiQm2s5K9zg8dWpfVEevVd/adK44czaI0ij
	O/vTwRHT+vGfMxtc3nYiVAqDshaJFdWE2F9AMlXjl0oQA/J76Kt+rY5IhRxu5M5uHwamg+o4ddZ
	15eK67hTh59fULoziO7kv7fOV7QNt1WuOxXKrIZyFArOuFay1YRxWVbn1vaaqJk6cPHmGU/EkX6
	j9FSmkaBRxpaZj+LBOeRrmWm0nPgJnrjCgEWTSqCPD5YCeO5d6456F162woICJ1lf6z28Aqqrhn
	NlZs3m9f1FvSMjdTTdBnIFc+i0QS3eGmptQueNjo04RKCHoW2hXVeprEbkwIWGEIe4EGRdcQXDC
	sRa0dEfpAa2V/fYBAzMIiZB/X4PBi/BaX7LceD+sOrPpRyJ9+HcBJZzztol7OcE2m8q5fYha5FB
	zBv7p6bDkD0rmzgKLFTaQOwlBWp7RomOyomdUjjR8OyI5PHBGkWWdbokVtqgy5nMD/Wdg3bqn37
	yHFh5B3bZ8Ypa48wGWKE82uaq4FR9ZvgEgUbGkvrAcU7PAQbISNtT8AIFIt3UNtznWyD+7E+cRu
	m5tgaYCVoxCMq
X-Received: by 2002:a05:600c:6207:b0:49c:fc6c:be13 with SMTP id 5b1f17b1804b1-49fe66ff146mr5620535e9.25.1790196126952;
        Wed, 23 Sep 2026 13:42:06 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a4a2-9601-c082-2dcb-3f3b-92b8.310.pool.telefonica.de. [2a02:3100:a4a2:9601:c082:2dcb:3f3b:92b8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fe0c4b51bsm67169645e9.4.2026.09.23.13.42.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 23 Sep 2026 13:42:06 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Jianfeng Liu <liujianfeng1994@gmail.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>
Subject: Re: [PATCH 7.2 104/438] dma-buf: Make DMABUF_DEBUG default to y on DEBUG_KERNEL kernels
Date: Wed, 23 Sep 2026 22:41:46 +0200
Message-Id: <20260923204146.6699-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260923140647.476063815@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org> <20260923140647.476063815@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I object to including this patch in 7.2.8. I authored the upstream
patch, but did not tag it for stable. It corrects a Kconfig default
and thereby enables the DMA-BUF importer checks in configurations
that take the DEBUG_KERNEL default.

Jianfeng has now reported a drm/msm hardware video decode regression
from the upstream change:

https://lore.kernel.org/r/20260923074256.9357-1-liujianfeng1994@gmail.com/

The impact of enabling this by default for stable needs further
discussion.

Thanks,
Karl
