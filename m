Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BEFD30DD3B
	for <patches@lists.linux.dev>; Thu, 19 Feb 2026 21:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771535039; cv=none; b=FVvzfBVxjLqjI5CEQMfwFHpnUcOqgJOY5mZvoKEJ9LMmanz0oAx5f4Ovw4E397xm0f3XVnG3Zuxs/BX9NacNYEzKKBc8EhaAspCX5AtaNzb98+CBG/tP29ffcTWLA6VosnbGNVk438cwPzcnwnyYLD29KcDnQeP7HzAuhf91wqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771535039; c=relaxed/simple;
	bh=pNvvwCxaWteDSrjz3ya2LND8dS5HAFVN2gK9oksO2ms=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=F52V3T5Vlj8rMVt/DrVPbTpjm5wUAou7JTsMBlKgGT6w5u6l3dZhzD+21nTwlpl1GIbGRGmsSQM8AqYoAS10Novi/emj0XxGnV5Fo8vcTt12vRStyyrtd908kT/NRHRcFhULuv2guy+l7DdrVdkZdaUjg6s5liKiVbDETWMlfIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QE1hYFW7; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QE1hYFW7"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-48336a6e932so9344425e9.3
        for <patches@lists.linux.dev>; Thu, 19 Feb 2026 13:03:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771535036; x=1772139836; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lAxExF3Bh85aqNqMomIsLZH79MhB2KBo6F6PX7ObPew=;
        b=QE1hYFW7GPFr92Lr+ac7EMbL0ivs8DP/25CS0fYJHFdMWPTbFShC1hnBErhJ0fbveK
         wZ2Tdwj/CqZ7vxfIrSwtrTuFhpnDwZNQtBLXC6OaxmtYh3OOEjFfjuVa1Mf94RqrBeY9
         tWsBwNFPDo4sFqxBl2jfuZvpvUzImcaP3QEoKZ5/rVg+v/P1P4QS1TnoGsMw6TLpyn5o
         D7i8OncL9G473aMbKxOcHayq7o9lvS2RJK+mXiQhzCKR3K9j2G3anQ5bdgfr69rOszMv
         t73tiJtLhOAhjpKp76xu5FSCzqChgotiKALxzDszO3HBofBxgMkxNCOQbOuBh/ET+2x8
         iZag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771535036; x=1772139836;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lAxExF3Bh85aqNqMomIsLZH79MhB2KBo6F6PX7ObPew=;
        b=cgWYBULtCRck/EYQpoCQAHGGx2cWPQpU0PMB8GB+r5yFPKgZTzrKkMEXgxb/llkOGT
         +tS2U2cQXgzjtBq8N/7l7R9fDjHS5jmwdH6ZjYecj46s0PjfuuyaybuOn0O40gkqoU4M
         U85y5zu3WgW22P0c5eev0TBH0nxrbQ7/AWXZP1EGLwJ5zZ9rA0Cgqs8TKWUfPVH9vepr
         10m9FPo8N5P3enk9umthlganOG8A62ofQp9SgCmi1NorZsDSjbBiuLS8hxy9NX73qRob
         tIMsJN8CwJ2j1zTOTm8eec31td/6PNUcndJnL6XVXQ8kd4lqvjrT+c/K5RQf7SOLvfZw
         NRAQ==
X-Forwarded-Encrypted: i=1; AJvYcCXywfRQqfOsR0ojx19FZonNCXmqpL+G/UW95SkCEoQ4+sm5zqfeei4Sr3+e0Cy1UuArlzQFwjk7@lists.linux.dev
X-Gm-Message-State: AOJu0YyFi63bDpZCMmno1tjeDHcuccB9Yqm5F0Qaa8E2Bwcoi7LI5yyM
	eVfvYpVIHKMNlDVwER74wqXdqT8gKRLvJrOjKYRqQCk3GYRmmuiRXBlR
X-Gm-Gg: AZuq6aIWt9IBY1WO2aya2DG+RM37gtIM/m7NOCM8CTPdNfS21phSuAl1QescTIiOEr3
	C/55SMHmqcJJJ5fu5RkCkqwoYwg4cYdaJmTaG38s3Tx/rYK7KZGFDcBnZQagbggvlJBouvn9WPq
	jMisKR4O3TtwullaU/xeijQbhbFZkiAEvNdr1B5WTqHc/pW3v6TmWYsR4wgJ6YfaZuHAcYVMUrp
	dx05cryVYcq2kl8L8Dx0GY6gald4RFwwmZ8s8+Tn6/0S/pCH3gy/oeyLmwIwzkcyiA9wew1oc2A
	jSy19iBd4ntKoVN6JyXmauU7s9tSWBXF/B6r+gvvJ0GaD55+A0i+ss8M3Q/7jcP7ycuIclgqVyJ
	mFg3VNA1a1JIqbswZs/NAEzbCUbaUmwxxT7Swwxc7SsdZgpNZyKcyjsNGLxWhgflSW7qzzbcWwW
	5c/gELrgjF7ByJT8KAOKM=
X-Received: by 2002:a05:600c:848a:b0:483:aa2:6bce with SMTP id 5b1f17b1804b1-48379c00bf9mr264391715e9.30.1771535035717;
        Thu, 19 Feb 2026 13:03:55 -0800 (PST)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-483a316eb08sm30113295e9.0.2026.02.19.13.03.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Feb 2026 13:03:55 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>
Cc: Randy Dunlap <rdunlap@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org,
	initramfs@vger.kernel.org,
	Rob Landley <rob@landley.net>,
	David Disseldorp <ddiss@suse.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	patches@lists.linux.dev
Subject: [PATCH 0/2] init: ensure that /dev/console and /dev/null are (nearly) always available in initramfs
Date: Thu, 19 Feb 2026 21:03:10 +0000
Message-ID: <20260219210312.3468980-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset is for VFS.

See commit messages for motivation and details.

Askar Safin (2):
  init: ensure that /dev/console is (nearly) always available in
    initramfs
  init: ensure that /dev/null is (nearly) always available in initramfs

 .../filesystems/ramfs-rootfs-initramfs.rst    |  4 +--
 init/do_mounts.c                              | 11 ++++++++
 init/do_mounts.h                              |  2 ++
 init/initramfs.c                              |  2 ++
 init/main.c                                   |  6 +++-
 init/noinitramfs.c                            | 28 +++----------------
 usr/Makefile                                  |  2 +-
 usr/default_cpio_list                         |  6 +---
 8 files changed, 28 insertions(+), 33 deletions(-)


base-commit: 2961f841b025fb234860bac26dfb7fa7cb0fb122 (mainline)
-- 
2.47.3

