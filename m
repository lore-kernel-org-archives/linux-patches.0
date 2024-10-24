Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B681FF7B7
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793414; cv=none; b=JUd2DK/Axk0pVhKMgWu/NhhVVuJukrd6bW6tn1nrzXj8mYhtK8c7XZJUxrL2wZjwCRiSq0D/x2s7JkOqWLCwjYYhGLvkSpswonTCydLEnN+f2gFXopEoAmFOpZWRBQdQHN3wOKsZmfxDnjsrlpN3/eufAb67bxnq7XU+v9ty8so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793414; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQqGaintYSmUc4H9/wj0h9CoYDLgW8Vq3AO2acpjW9tfuHKhbrpdxVdGKDieb+ennQ7fxV8TFKM/7z2ABix92uNxl86QiYIEcbhsQOV7C708jvjKi89Yjj5lRFEjM75Q1c7H9YQy8AeY4cEVx4Y/3nANPTk5JSAkQbkf2/m5cII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MWsPhsPv; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MWsPhsPv"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-539e4b7409fso1346420e87.0
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793410; x=1730398210; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=MWsPhsPvsO0w3WVXFWXdLZ4Ho3v3dgoS5EeVcOvyD84A+hHP3RJCy6EsBLlfG1RkQC
         Tm6SmiW3T2wI5QzGu7b7LcuRwk6JBg+DjK1uao58J3vn3TJxRjDAtnIUhO2toVGVs0zv
         mnDIiSWswQ/MWLHxvOORIsbitmIeLHzzbE6DZXPBOXOEXuL5dDkIAXmy1wj0SRLdFALs
         yZvBM/I+TA9obg7N+bvTOIPIcLIVPOR1Q5Y4Io3Qcu/gWty2EYdt0/eD1Th2PXIHadtG
         3xBLeViyrtyfr7n8M2PQ3R7M4goPTjvBSMge12bYJam9/UfCOaAav2TUK9kVc29EDXTk
         z30A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793410; x=1730398210;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=GB8HpVv7mZwo9ixX+bTPFFEUAC477s28v2/Q3hCHbLD3ACA11JWt6git1G6GB+kdYG
         OuFMtaeE9MsidS1ZgGPLX7X2Y66K6OThZXcyxjInvZzlw4NkbCVG6B1r8e8yBb35yLUQ
         A5Wv57vs7cu5UWpX+9AtTVJdtXGw1br8+djn/bEjOygobJ570+0dLWl4cIF7PQbQe60+
         CH9Y+14/mM6n+5vXXPjtejgnEARFWSd6nYv6tzCwYb59l3n8r7Oynu4ZYZCjduCLgffy
         kRIwo6d6jZxW0xt6JLJ1zpdbw/EjdmV16KASvn7WiDsGQMVFJdvlOYY3pU4Dx/TjSzhn
         YsUQ==
X-Gm-Message-State: AOJu0YzkjaUh8+HkkDy+em8P5IY24NBYRxO6bVXIWdUXTA11IaVmHlmI
	A9dZSAlIidibs+lW//RGr/edwKRSCV8gpWeJUyp2Dy/jgyVAFl51
X-Google-Smtp-Source: AGHT+IHyxxsykHoJ9pj7hdy+2JiYJrAkdwmNnrIjZnRWtmllIqnA3ZmloW6kGXJHxWmM1UQyMwd3qg==
X-Received: by 2002:a05:6512:4014:b0:539:e88f:2396 with SMTP id 2adb3069b0e04-53b23751e00mr1116486e87.24.1729793410093;
        Thu, 24 Oct 2024 11:10:10 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a223e54f3sm1419035e87.4.2024.10.24.11.10.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:09 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:10:00 +0300
Message-ID: <20241024181000.6940-1-vladimirputin693389@gmail.com>
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
