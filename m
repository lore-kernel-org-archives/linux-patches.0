Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5813F8E09
	for <patches@lists.linux.dev>; Thu, 19 Mar 2026 23:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773962910; cv=none; b=WWwucUUQmAhj+FZZApJequOWGMgiTXGoW79So18/e8YVP6mga8zGE5cF0ffUZyOB0dBXBCcJ1FivrJc+jOGDzEoMUoM5OHQTWOqui08z9prmuXcNRJGDDmnG39jH8lfRqflJvAg4Ohn4b9EiP0/tdHDpFgXTu+fFYj4SW6o3pXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773962910; c=relaxed/simple;
	bh=RWPSrq0iveoOJKvr0MLwMT9ETGu0pPtPOzleo4aJxXY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EsWRgwvT7N3DwELT5DPLn5L9x0KKw4qzWmHvSDu77z7uVKxLj3UahW7KhIa3mfO1Sp86B65IkZAbqgLDwuwtgIhXpCLiXEJVHileCor7scZLqfp0J/PXa9MEWaWxNo5YMCC0g4bv8MYhkeP2HMEeDw1PiYdo8XhAFM9Y/L5Yeeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dEAbhAUm; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dEAbhAUm"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4838c15e3cbso11031275e9.3
        for <patches@lists.linux.dev>; Thu, 19 Mar 2026 16:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773962908; x=1774567708; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ukH6iurOqmVqpAUSNgmGXdSqfeMmyiANM/nmwq1iOMo=;
        b=dEAbhAUm89cBW/OM5in7OkRMnqb96Tn1AM9bEsFHmamH35/frrmJE6QYYKQotsyYyH
         7RfJLJQnRGokFNUk5YiW8kWc/eyJ03hXn1x4WzzxaMYEkCYRjK+0REHAekSaMOOKLPx+
         F9lGoKRp3t9nFaTiTj+tDUOKDxYxIfdw5MBEIGygLIFekMHPrfUXpNiOGBk0kg21gRws
         vloi/XnKRmSgPWQYxDq91mYYWOc1LyF8OHcUQp36ez8f3khQ2GIs9Md8rrqUL6tgjJ3T
         dE+cYaqMK7ebpg+yeg/XJWVP6B2/lFZPWvzdGXy1VVCkD7Rgp7p7aHeGiA6RNjo4JuYA
         WTrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773962908; x=1774567708;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ukH6iurOqmVqpAUSNgmGXdSqfeMmyiANM/nmwq1iOMo=;
        b=n2UbaIjU5TRTWfGAAidAYj/EMu/OeioM1jKx1+bGT6lYWsTICwkH8+OZMG/MKhwrIU
         vhaB6RNXSw+sVfZb798VI7JoV7u8UlgienId+i34ApfQGkNuf54jMF7/Iww7ORq0KORo
         TfxOEfwooMyQiWAuU53n6J0WvUD3g08E8tJVmLZYijR7K+a4mY7WvIpJRx7EixaqOQAN
         4zdyuaytBGMvrpvqeaepIGzS7S5pSfd9+oKuV/MkPEfiik93TtzAzsGnBk5xIIX8I6+V
         c+QH7JQi867crztnR9USSV/71GdXDzDiBkw+hG3NlTnmMYO7PvbbMzNxgpYAYsw51hnF
         aP6w==
X-Gm-Message-State: AOJu0YyvODAkaUMontcjFVI/I/RLNSNa7qKIbNwWxjEW+NZGZ7+4d6AP
	UaFqgbj/qsYZqmEnz81NJxxkbWD/2EPgz+GvZRNJoSykb2N/vtWWtEwo
X-Gm-Gg: ATEYQzylw70K9wLbHD5dB0QwWooPtRLxvhxcdvX91Ab5meeBRu+Q7s2N52i08Stp59t
	Njut7A6VfWgze//JrvJAvTwAHiPQHV6QAkaI+HswVkhbcOXbqPa63k+inuOsBEmoP1ToKL59LQn
	EozA13sx06KeBPNtcaEgbAfCU+NYzpZXAibYL4jDk67AxjVtoslTmlRwnAmylPwp1UGaPRIOFxp
	BAAyofihlI+zCf105SO1wGWsvJhW1sOU6Ad3uGlkGz9m8Iy2Sf67eEJf97u3elszaqAaluckYCs
	G1hl4WyEa3dRhZTg714IGEEi019gqtgivkQ53uZAjg8BF3iL3AmEmEFcHkb2jcbF7MOktvRVgEF
	8cWv6sEcV8cEdZV/1RrbWoT/9wCnpkeWUJ2J0IyEKmlzg5RAj1NY1u6VSzWKQd9Jz94uRxu3u6L
	tF4H4tHy4VoizYkSWPp7s=
X-Received: by 2002:a05:600c:524e:b0:485:3dfc:57a with SMTP id 5b1f17b1804b1-486ff020bc4mr14311315e9.32.1773962907672;
        Thu, 19 Mar 2026 16:28:27 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-486f8b1d03bsm83143705e9.4.2026.03.19.16.28.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Mar 2026 16:28:27 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: patches@lists.linux.dev,
	kernel-janitors@vger.kernel.org
Subject: [PATCH] init/initramfs.c: trivial fix: FSM -> Finite-state machine
Date: Thu, 19 Mar 2026 23:27:21 +0000
Message-ID: <20260319232721.452950-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

FSM means "finite-state machine", but I think this is not obvious to
everyone.

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 init/initramfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/initramfs.c b/init/initramfs.c
index 139baed06..d29fe0a5c 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -212,7 +212,7 @@ static void __init parse_header(char *s)
 	hdr_csum = parsed[12];
 }
 
-/* FSM */
+/* Finite-state machine */
 
 static __initdata enum state {
 	Start,

base-commit: a1d9d8e833781c44ab688708804ce35f20f3cbbd (mainline)
-- 
2.47.3

