Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0CD9181D1F
	for <patches@lists.linux.dev>; Tue, 14 May 2024 22:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715726924; cv=none; b=EMk1iVyJJolL9u8eZuiCDyzEfZy3hSvyM7WjNvBUApIWJ7iOkZ46smuzPKUw60+Vfr78bGG9AUD7t8Ts3M0XNC/A4SjLL8iTtUTgDiRUVYcsMOYleV89fcAzfxGmimOVHKJrd83Mk2404LARGEf+/gOtjvxbQkBXSXTHIndcJxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715726924; c=relaxed/simple;
	bh=J7vPh0ZbPIZnc4W98FXR0VGHZuZYhbZC2ygC3LT6oBs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KYUKys9hb+RxOuLYddc6AiYMWXuNtZ2OAOquI0GxK8af3Ic/beO++QTnQ0EdGcjMeM2X6hnR+cDsUb3WuaXrBzGpKW9Wo/TBJ6cqVoJv0So2mjXdBrPjxddX4YtscA5K8doSxDnQm1YrRi52rDtXvN+cgbDF/KBxvwYfer07x1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=gB5HZTli; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="gB5HZTli"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2b9b88112bbso445377a91.1
        for <patches@lists.linux.dev>; Tue, 14 May 2024 15:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1715726922; x=1716331722; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7dEnatMats0sY9eR6iWDX8uys8lNwT71usJDglUkjFU=;
        b=gB5HZTliKC3Hrov7GYEpCSiGUVVr1+qjDedAdwg03eSIirfqTpVRhN8kJXolSOXm5K
         PwmnD5M0tU9LKu59q+1/SAD7W23PlRmIlcGSEzpKAi8MA1b9WX85QNbUA9HF0S0Ik9jH
         LG5kYyULQ5BXWR7uEnuD3z+OFYpPcF6HER4f0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715726922; x=1716331722;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7dEnatMats0sY9eR6iWDX8uys8lNwT71usJDglUkjFU=;
        b=RGU6ZVmg3Ju4Pn8HlSrmeoPTdN0YEOG9QS9IXVvLjE3utId9fAvWLJM6JC7plqR6zm
         z/REF5zOiX3thtGLXdmaxPWtcZLbiPCqyHpAKK7pdy/GujCstx/vaJ8u3riOndQCYZt3
         OLKGqZP0GSgHyycB83wfu8EXLSYhmhWLaLVkkDtpK+gkrNvpwnC0k6D9Fu+oDV+LyVY+
         eV90hNGETx0VH6pNWdWfUss8o5XOe7bATdHwK6deJyCzwUlOLA9Njk+Vu0TRa53uiGBM
         ky7wvBVCOiduTCAuBySA7382+i5PqmSRCZokO6Z2idgZ/lP2AFPzVMaC0oHmc56BOAZ8
         Euig==
X-Forwarded-Encrypted: i=1; AJvYcCXPLCPo7Z2jVazx6hWo1DkoXYBWBJnvTF1dpG3JZ2fPVaLUu/6oJWn3SpNwaXyz9c0dvYRQXUck/FSXIEgrcAesU2V3Dq6WpQ==
X-Gm-Message-State: AOJu0YyBSV9kPsGrriL5FhHToJcf6MlE+/TMk6fKg1+ECXwdmRWmktlR
	+0jBuVKU/PTuUYn21+FPXHhegUUzbkfM6Pxjxg10pzBD0iGXZ+J6QGnxewT3vA==
X-Google-Smtp-Source: AGHT+IFNYthq6sGRj5beJQGDuOSDHf6eMfI+iPOay6PKYPk2IVvOV/nkNwPHeh6QcabowUJdNEzJDA==
X-Received: by 2002:a17:90a:aa12:b0:2b1:6686:dd7b with SMTP id 98e67ed59e1d1-2b6ccb7e416mr12324060a91.33.1715726922083;
        Tue, 14 May 2024 15:48:42 -0700 (PDT)
Received: from localhost (4.198.125.34.bc.googleusercontent.com. [34.125.198.4])
        by smtp.gmail.com with UTF8SMTPSA id 98e67ed59e1d1-2b671782d89sm10230359a91.55.2024.05.14.15.48.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 May 2024 15:48:41 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Kees Cook <keescook@chromium.org>,
	Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E . Hallyn" <serge@hallyn.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-security-module@vger.kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Douglas Anderson <dianders@chromium.org>
Subject: [PATCH] loadpin: Prevent SECURITY_LOADPIN_ENFORCE=y without module decompression
Date: Tue, 14 May 2024 15:48:38 -0700
Message-ID: <20240514224839.2526112-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If modules are built compressed, and LoadPin is enforcing by default, we
must have in-kernel module decompression enabled (MODULE_DECOMPRESS).
Modules will fail to load without decompression built into the kernel
because they'll be blocked by LoadPin. Add a depends on clause to
prevent this combination.

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 security/loadpin/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/security/loadpin/Kconfig b/security/loadpin/Kconfig
index 6724eaba3d36..8c22171088a7 100644
--- a/security/loadpin/Kconfig
+++ b/security/loadpin/Kconfig
@@ -14,6 +14,9 @@ config SECURITY_LOADPIN
 config SECURITY_LOADPIN_ENFORCE
 	bool "Enforce LoadPin at boot"
 	depends on SECURITY_LOADPIN
+	# Module compression breaks LoadPin unless modules are decompressed in
+	# the kernel.
+	depends on MODULE_COMPRESS_NONE || MODULE_DECOMPRESS
 	help
 	  If selected, LoadPin will enforce pinning at boot. If not
 	  selected, it can be enabled at boot with the kernel parameter

base-commit: 4cece764965020c22cff7665b18a012006359095
-- 
https://chromeos.dev

