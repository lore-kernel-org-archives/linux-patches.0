Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522981FF7B9
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793412; cv=none; b=pfor59S9HX3kYfdjBwHUpn0DFjXVp01O//tpFxVerxbKT88FFY21gfwqOjhl6o/KwWfOtv/5rAfzVMX+a4oCxmXQQZkaLvz/qn/LqA36rv2AbfkhKQ1tBR8yQSByGwDwQbLiopP2jFLS9prXlbJUqWOtsSaQjjBC0Tgwwg0XnNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793412; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jk/a7wk5HohGYcNM2EgpTrBy5uVKiDYKpQxwdjv/pM1GWMoDe4mFuknRSatqseJYzplaT2iXkMqW3CMFziO8FbBiSa1BL2ZL4Hnc6IdbKGADWHW/Ev11niUX2q8oiiVxDuz2DfSDntuO1qfgsKljPvErR3TFHxC0sPXxB+4StpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IgSZkeDs; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IgSZkeDs"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-539f72c913aso1634413e87.1
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793408; x=1730398208; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=IgSZkeDstBhK81lPk6oyQf5d149Ey5aDanAifsQxklnXXz+bsnEvdElD9HJeHSwsqz
         4LMD0lEKfrQrdtt/QKlFnRc7vOyk1zE5MAkA5jPl3y7saXxwSnwrA9oMZcKwcPyEKbCF
         nEVlPcmzrvREj2OJ2QQIpDKGCHbJxhhPW77/t01j/fxtlq1alGeSFpQLFc16NCvCX78l
         mvB2vQXSvOo0jxQ/dHU1ub+OsaCpgm0u3HLFe52Tn+kgokLanPe4q2r3mn+ZPa5K1VQP
         F451PIhIPjaLqci/+bCHoiazER7ISCBzp8BH814AA7mhLV3jqcywOJXP1NUOSWlhkDNX
         0W7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793408; x=1730398208;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=bHWE42wVtDjZxQwf18vwhiP1XktGziwlhSstgnA2igGSJY05QPW4C8eocgFE6C8QUH
         hHkcYPdpUxhV3uLjZd/g0lCORoM3YvEs55V5RXbbV3wKsbllvaw2cl4nzqoCKZrcsAbj
         K2AlCw9M0dUL3tYEcZP1Fxythu7gGtr4UnprWNW4zgqSf49SHEnVCGvRK2jRAAtpI4hU
         ez+50F58JcNhXBFSpvZikUoyTh38NtIG0FIGNvMp5E2l8fsz5hXmns2iQFiHenhvHcrj
         2vZywn2bScKM9FMFvJhxigJPhNh+ma5beABEL5jr9XjV69wwHgMyaQgKVQl3yRjEkZAX
         fipQ==
X-Gm-Message-State: AOJu0YxcNHiKiSZLSSgScnCX9ZUFYXO2A4L81t7UCENjKuED+bmHKplp
	4egaIY3M6YHX0HACxyIT8tlIBwLgpvpcNENc2WNdXISFWHL8GhCh56cfZw0G
X-Google-Smtp-Source: AGHT+IF/ZUb9uZLdDIotprYkg5LpEdRMdkjnBUjZm7lahUyxUima/rRhmuF9ixLp3VHFtTwE01QqYw==
X-Received: by 2002:a05:6512:2384:b0:539:f4a6:ef40 with SMTP id 2adb3069b0e04-53b23ea0022mr2053400e87.54.1729793408031;
        Thu, 24 Oct 2024 11:10:08 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a223e5988sm1419761e87.2.2024.10.24.11.10.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:04 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:57 +0300
Message-ID: <20241024180957.6492-1-vladimirputin693389@gmail.com>
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
