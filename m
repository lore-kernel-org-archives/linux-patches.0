Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2788632721D
	for <patches@lists.linux.dev>; Thu, 19 Feb 2026 21:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771535087; cv=none; b=EMxZvCaI/jCNNFhNSQvkN5ekQFH2Uj9FcoEQnwtm52XVh51FvoPHiGXgbKewiT/R8+o9hc0y/gVqNOuDlKJaOnhz2Equb4wDz5NVK6d7ggQvCP3Is/Hhloh6/qD0yk+srSAW224Yx14OU69D/N+ZrPy9jhUI3knK2BfMpyl9Y2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771535087; c=relaxed/simple;
	bh=FRv7eowAcNyO65MPdC6mYQ+EkktIEpwQbRI5qwDk7Qk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bpBujGBwkldmhDh6zPLyIslpTqRIa5S2knVLgAfiDuWkQUAQIZ/jCYkoOsaxFfTJ+rGSPKQhbqSB6K/P+S2Ec8T5pLCw/om3cmGIOhiVpElkb2TjRScl5JBh2PsEmhDOIolcZSoqaIWyREkARLShZbA2uON+8v0wlLldmx9oNAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dNQf5kfZ; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dNQf5kfZ"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-483770e0b25so14648295e9.0
        for <patches@lists.linux.dev>; Thu, 19 Feb 2026 13:04:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771535081; x=1772139881; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f0GUcmDt7bO2Sn9J+9uf0HNcJyXZ2g0c2Cg3p3pl5n4=;
        b=dNQf5kfZHIqRPw5cys+H7Ql78E0Xf2ih3fRxzm68YkivVgz5xm9biHouvDIDg5kunN
         pLbKWAu06pntPzvVp3G9ePiqiUuLqYZzaM/+Vz8/O+RmyNLHK2/AmrA4qiZZsTibUkJ9
         JoKgxNbAD+2UtnNJV8dLL2SLpbGu/Ml5MaJWN1hl3QM59T7y6FkbGhvQlt/561Li79EA
         a5soCsXNhxnVH4U4of4AH0dZFXnddVejMp9uCxvdekdSe/HzPa5UpodgyFZ6jzaAfeKY
         wBBvsJpirrZehkpxpOqnKjuT1zddfSoHJs/jCVL/4t3viq9VZztGFhFUIAsJyvi2PZWB
         9DXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771535081; x=1772139881;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=f0GUcmDt7bO2Sn9J+9uf0HNcJyXZ2g0c2Cg3p3pl5n4=;
        b=mMkngBBc5ugw2O97ESny/TYZ4FtK/P//JygDp+S6XGBDZsj/k/hGJ+viL1JhxXeBTx
         Zt2Umzo7i2CvPcqVnuIHEmu03oIa1l+h7e/iQxW2aDbd82yHSuEuX4d0Bt618Vjzw1J+
         uXEaC4l4+y+ZAh+mmf4kOboR0dAIda99rGtwENGtIcD+NSf4LjrGqSg5jMy1KmRjg0ck
         3KbpENG8ojG+z2DL+XbqEODwI3uucxVpPsBYfxVmoyKvy+ZJ8RtZV6raPJp8mYW7oj01
         XzTHXnr6FeP5QdTmR8ST1AbVZNiBXUFAoeamlQXR8B7w7rO2uQQ+SgOQ2kCL+D2u7a1s
         00EA==
X-Forwarded-Encrypted: i=1; AJvYcCWSdVyE0mZOlerigB54gKJPwHRbIH7PvqvZUJozrv/odjADbTyF0kYYdUO4AQR9XxuFyWbZWbLB@lists.linux.dev
X-Gm-Message-State: AOJu0Yw2ab5daIFuGIFPZ97zZN2qTJXWs2oF96yqPdcGNIZ3caCxs0Hk
	4kAFjzyOeQpfjjE9xAJapBJuy4m6VTFiZIiR46nMOvaQPKm5BHJ1WgvE
X-Gm-Gg: AZuq6aJp8gaFlc8ApkIsTt3yso5OUcLZ9H3wjqfOleZ2XuGUHaXfnMqH7zS2vVBVxsj
	MjBv1yhYCioBAsEtANYcRFf96Vjg8XrlO1B6bsS8T4ZFnBwDS24fvQ7nvqb3pyjt6KCc/ofqgLZ
	3RAvuU+4z0ihtMhu7JO/SqMveH4QuVV9I44vai35L/f0Ydqbe1fhryI59YuJ+XSwmbgEN0q4H3x
	x6yEb4hF5Uz/AyDd5sVl8SyKF/GK25xyLu7tTfh5wAUhSaBjyUGCMD95vAv3fxhd6nlxkL7MR3n
	HEQdpkn3WKCN4XPY0I/+fD0BkqavpyA/I4fkGsfzqVwRhA8fkPeEP15t1RXv6wG/DM5fLIERL9x
	kiwcS1T+V1SZd5/oHqGNV6zks8P7wWCPAqkxA+FmWUjwkjko3Ma3XfS5f+tN2R4aQA6tOHTopUe
	xbrW1G5xO8etHQgZODYabBTRiJiIJkgw==
X-Received: by 2002:a05:6000:420a:b0:437:6758:ce75 with SMTP id ffacd0b85a97d-43796ac216amr43835401f8f.23.1771535081365;
        Thu, 19 Feb 2026 13:04:41 -0800 (PST)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-43796a5b4cdsm55044994f8f.8.2026.02.19.13.04.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Feb 2026 13:04:41 -0800 (PST)
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
Subject: [PATCH 2/2] init: ensure that /dev/null is (nearly) always available in initramfs
Date: Thu, 19 Feb 2026 21:03:12 +0000
Message-ID: <20260219210312.3468980-3-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260219210312.3468980-1-safinaskar@gmail.com>
References: <20260219210312.3468980-1-safinaskar@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Binaries linked with bionic libc require /dev/null to be present,
otherwise they will crash before entering "main", as explained
in https://landley.net/toybox/faq.html#cross3 .

So we should put /dev/null to initramfs, but this is impossible
if we create initramfs using "cpio" and we are running as normal
user.

This problem can be solved by using gen_init_cpio.

But let's make sure instead that /dev/null is always available as
a quality-of-implementation feature. This will reduce number
of failure modes and will make it easier for developers to
get early boot right. (Early boot issues are very hard to debug.)

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 init/do_mounts.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index f911280a348e..3e71049b3dcf 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -525,5 +525,8 @@ void __init create_basic_rootfs(void)
 	WARN_ON_ONCE(init_mkdir("/dev", 0755) != 0);
 	WARN_ON_ONCE(init_mknod("/dev/console", S_IFCHR | 0600,
 			new_encode_dev(MKDEV(5, 1))) != 0);
+	WARN_ON_ONCE(init_mknod("/dev/null", S_IFCHR,
+			new_encode_dev(MKDEV(1, 3))) != 0);
+	WARN_ON_ONCE(init_chmod("/dev/null", 0666) != 0);
 	WARN_ON_ONCE(init_mkdir("/root", 0700) != 0);
 }
-- 
2.47.3

