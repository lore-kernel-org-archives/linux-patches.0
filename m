Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A08C2003D9
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793391; cv=none; b=PEs/Vp8tHkELIG5J4xG90plBKeL1+gW5PqwhwsPTDZIVb5xeUQhoZtdbhPNrXaw79njXlKTxyW94nsz5bQkuSsWZ9TrvU018gCkRNnZezlfTLdjqQy4DO854hzC0ezx8fRRWGVU5h3lFX5FaaYxwGFhDyBZGNMqeZ45UX0CWBb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793391; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kqYX7VJ9/Eu6f2jYG1fRKSQ6KGF0vWsiun4lmqco5b+IUOWEz8IxPdjjl/FSzRMy9mFR4fGeIwfLlY7Carill+KQR3UzbQIpnlwdBWQw4vIaNn592mwBQBCpwTo9jLVkQcrZjubux65Gbn3pxAr4eLn3BLVIykUia9OTrydCAgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RaLuGBCG; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RaLuGBCG"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2fabb837ddbso19648481fa.1
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793387; x=1730398187; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=RaLuGBCG0r0ocicJ56FJpZ5PFt2n8M0pBGrkmdBkYLNPkCxn6AefcW39NTJXU5Lczp
         I96LGNI/5JJoYqLkpKrA1LQ8SCqM2DDFMiNdTaIBPA3PncpuSKKoxFRNcSTkgOfA1bOM
         ASFrRPF4lw4Q4biFRRGHyx0o58dXw3ELF7NNNrE4plg5q85Ehh6xatF0o241TLUI3zmZ
         7cWPWQ0DfhYIfxIyxzD87cnYqyC/zmR6/zFM1JRVKLxrJneuINljQOhKRAZJh4dB8NAT
         FnPLW5tmyVw6T/LBzWHBkAlzzAoC1zYS5WbH6B5Ba49zxLJ4RCeXPf5LQqYsbzmGB7Jw
         D/Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793387; x=1730398187;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=uvprlP6y6y8mE3D2GxpZT46XgcCle1+oaAT70lENXAfuFTHmae6kj/xhRMp64cFr4F
         sYXUbtdNgfyyA3Gcovjl5tHpp7RDrBw0HxOhMyVP2Xyc8Z1Ww9RngEJJoNi1W2Qus2ON
         2/pgmn6M64pOBa+83ACtmVvCUKtOOWkW4Yk49KkFjMF+XPbZuWxabeZI4gfx6o5R1F/U
         SZeJT/yICzXKZG9jQX9/8LfTfxd1p/dA8x0Aw1nUMIG0xvblndD88dr/myBnWp612H1v
         gWbDgq6ROkIiPL59Xi06VxRGQ+9kHPnMueGICjE/eCXALMme8LtWJJV+xt+P1lYrYqqJ
         d5tg==
X-Gm-Message-State: AOJu0YzYJ1nY49MwJT31YcK4CfZLVmFkbXDwsCqW/kGIIO6PTN9A6dnT
	hRZ+j6UWFjMLHl+quxgJEPwnNldfRtGejIMWxauNYPAiBbhlRmfjN8WAlUmI
X-Google-Smtp-Source: AGHT+IHuCfjJTjv8m/ScagPt28XVlDicH4JPtPwaSLt52lycNCOApYpHXJLTicQRVwLp2v7j8o6WeQ==
X-Received: by 2002:a05:6512:b22:b0:52c:e17c:cd7b with SMTP id 2adb3069b0e04-53b1a33d0b8mr7217595e87.22.1729793387354;
        Thu, 24 Oct 2024 11:09:47 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a2242013esm1405770e87.164.2024.10.24.11.09.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:46 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:41 +0300
Message-ID: <20241024180941.3319-1-vladimirputin693389@gmail.com>
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
