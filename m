Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBEB1FE0E7
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793415; cv=none; b=jZmlhhaCU8puetXKLiypyAKQYrdWR52YKM4faz1CbO0pvW0eHMO5PIX0vAxjun1hEipecADfJzBjg76IgJt6g1Kcp6e/Tztpjfx5YyTzOXWH69pH9p8vX6V6jqdZgGLzFNQwRNcGLPG90X8uhplEqTcrzWNFaomZemQW6BofnQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793415; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZJeosMkCK2HzzG+uFRtjhLx7VHMfSGChE8n0P2wMYYNu62Dge/JzA+00uXq1jt7aDCkAbLBcUf4ZXiJCO3FUE5a1+KLx14e9O01cjl1XaeP15OYWA7qtFkVJbVzK8RlIDVFBWsyPYcoGmx5o3tlmealAd1v7NOfq1PmKU6+znaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EpkC37BG; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EpkC37BG"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2fb599aac99so13095651fa.1
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793412; x=1730398212; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=EpkC37BGner9f0vHtI0y33j0sxiArfnH5lC8cjRUh5Rh0yEPZCTeq5WmqX5SatKceP
         RLdJ7GggAasuBi0vqe+jdh2+Qhi3G8rtxLBXWv1PK1iATBTHh98HKJOgqkXlROb8EmLD
         oDE+dYsoP9GkUwgV635MU+UNvi5s3yynpSdu/a5UUP7I0/sJTtqNsNpwO6yjRwC1Su/T
         BEvC9mT+9KRwG85oQKHj8RJF+a9UTkTc5vgD94I0R2C2egReX10ClmJwQw4pbPswkrwf
         QlFlOJcIRl3+XNxXl1ZTrfOFo0j97oax6JR29Zx45j/Qjqrrrz5wa6TN8RbrNaQ1bxVi
         TI7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793412; x=1730398212;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=FgcibrQ8Z65UcOe/f3hESurENhAoxDVV0wG5psOP5+NpPb9dy6U6wsq0cRTSmMJdrZ
         WDGlZumEy7PfER5ERJO7jx/y7GdHn9rg/RuHgN7DQigyEgXgNiNvdoC15VQxkHhQ4SZ/
         7Cv/wFvQhtHGzxu2fYOw+yvLXOFeYwFYIAnmJ5mDrAXH1ucQbIsRsWDspnrIr+rxCjXR
         sv1I5Vb5u2aZwxK0ErUg4ZAWZNHLVau+JJLQUoVrNJHJniPM1rhOEC5x9WBg85vNa1Kr
         HA5QEaWkJI4GOXXF3CVrwhY+t2ZBcXNVWMxU6rj/AV54/aK+cg7wTS+9/FjRLXswgLiC
         vn6Q==
X-Gm-Message-State: AOJu0Yx/aiekrasGl1AKguR1S1Vk1gVJbXX7RS1GQqubUtmQIBd39+oZ
	Re/PvBscoRtExyPCVjGDygNlCpl9kSNVCSYyQFS2fEDP1XeQpF/4m6VqVw==
X-Google-Smtp-Source: AGHT+IG46wQy/Y2GEGmVTTdeI7zSFu3hESSf8BUoX016cS5n49+XeUtjWN609wHzA+lSOPBMWaEEXg==
X-Received: by 2002:a2e:4a12:0:b0:2fb:7f9f:7f50 with SMTP id 38308e7fff4ca-2fc9d330671mr31038121fa.13.1729793412369;
        Thu, 24 Oct 2024 11:10:12 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2fb9adfa19csm14772691fa.89.2024.10.24.11.10.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:11 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:10:02 +0300
Message-ID: <20241024181002.7239-1-vladimirputin693389@gmail.com>
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
