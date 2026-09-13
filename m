Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28AD3C060E
	for <patches@lists.linux.dev>; Sun, 13 Sep 2026 19:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789327577; cv=none; b=gQFqEjeDDfX6qkO2sq1kC+H3AmCZWE8ndDU76/SsCvg1iF+SgFUj63FObVjs+b67gD0qjX+c72rWSNqkTZl5zQcWsS1o4qy3mS0GV2oJtIN7qlW2T8yU8ExYjPv+JGianU0wZMP3sSekbzPor8p2zURRxTLsDMRvuORUmHVHv2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789327577; c=relaxed/simple;
	bh=jrspKrSHaAFQmRBzEI+lMfU9C6MRcN7DzFgzkR2aG3Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VfQf9UJZa2ghCn8f+tI1PkYkTYu1y3sjiK4sQy2TYEM195RUKwcwP8BJ0bPehcYl6G755H1Z4fSefUmeTH+ABYilwOca4V5VJbBFfbAzGadln/bLo/t6VXS91RI3PVKHqsGnc+jA2MPZTO3tyAGGXoswaKFg6oHbPt5G9jnN7AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WZLj8sLF; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WZLj8sLF"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ccfd61ecaso12788695e9.3
        for <patches@lists.linux.dev>; Sun, 13 Sep 2026 12:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789327574; x=1789932374; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jrspKrSHaAFQmRBzEI+lMfU9C6MRcN7DzFgzkR2aG3Q=;
        b=WZLj8sLFN3B9QoCMdWhTyF8L4SZzySVHUaZ7/sl5yTnGALdaGPNPogvS6tEVbPMl8E
         83A7wPTj0XVfDBN8H04OIFIXjqbDlha8yzRFjhbVpUMaxhOz78OXyD7pfa79gnz86795
         aZ0J6Wly+IMJ3iohzXjSFmjjx+rCGjrebFKEyuSciT/JOgh19y7Z0fWJ5eAEoDOM93JQ
         4nRWdBa7JmVL6JnQjcWJdUzB2I21hYEzgD540fC5aR7coFIwjH4yRsQep2igTtTmsNrn
         hkkXDSqBdi8yNtndMdpcGLIR5tmtLYHrHGC8emGLbQGGxMLfBEYbFGlIKKc/3IOk4p8u
         r0Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789327574; x=1789932374;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jrspKrSHaAFQmRBzEI+lMfU9C6MRcN7DzFgzkR2aG3Q=;
        b=mORFU2LuHoUDACMK4jK3Gn7SpxuuTaxenLxKsxi2ZeKYwFSwb4Kn+AU+YwPja5t6eo
         Qu1S/Ca7eYwxRZ6HRsFq2XpIc1ePonrQgDg8uV+nOriJlggF73ONFX+UzufUUocleJIZ
         S0WB0lAfkAJRAJeK3cu3WE+KOUGp4xGMaY21/9PrJDZmre3eg2wqZY+cFkwY9zpLkVCn
         C7TYy1epT/F1giCvby/3SsgOLwZb+iMYhBoUpgkRRa973V87kiKI8ODlfyPEdv+5FBDk
         wchZ7EXdreMO7RBxJTrEB6hBw0IlHUIa4POEoZkkpC9iWe8hjb7gwd6YDA922K7vAtZ6
         u+ww==
X-Forwarded-Encrypted: i=1; AKwUvBxUIHMwnAvr2vEQ1odMv3DN6lHfGo0oeOfZSBvE7DO++WFjpQvkgWd/nIET6YAGyofad//C1t7s@lists.linux.dev
X-Gm-Message-State: AFuF++me+pkCeGomlgLoRfzEZMcc/qnjjw+Xa01Svlutcs01yH/Ucu37
	JcWjO5MzPFmLut1GoamvcPrpy6j3smY2fMQB2Z3V4x9MtMwev2+FffpQ
X-Gm-Gg: AYBFou1GHVOGQ0qVu+j0wSjhawiQCD4jDRfc8StXt1qjcdj8n9xVKg8GddqWOFN9SpE
	BqacXt9iDf8UWeberGYOEnAiq9cqDH6fX2dyz0g5g4XIgAZCt1pT3T/1YEL/vbZDySdnSHJssyL
	n+60PL8Byp+cI8RIq7x8hfn5d1IhRI4yzPZCTBtD/qW0vDA7Gqa64KMQooLgBd7JO9Xn011AUHj
	PyKC7U4x0QZu/CxgEJ4Y4tVgNlIQnLL9kWGk/incfMM8JnY6f6C9+TXVA38zHJezhqCwQX5TIpd
	EWM63uVqG4VXHMJAsNcFUcASYdVGQ1MH8zFK7tuUkharoi4AUGJii/25rOxDbtFMle751NrsOdv
	yjIFmZgviIu4q9VUTgvskMwOo4ylW3XLNRi5yzGM65DYvn7a61dyd6XWuxoR+muN9psIPu9zFFs
	+SfVojhz482FDynOjuauOaYS+vjGF3Rb8AdxX8Y2WblrxN+wUfAyQstVLXeYi98JzXTYyxEappO
	zjI0jb6z9DLnvRhJ2BAk5KZ4PavopXbAu2PWVP7psKu5/st7YcO8ia62NKuBOA2muZnkzl0sqgO
	OQMnfRz9l04SWE6jGo3dRvZG6mWJXg+HNnQM6E+aU9nNYKdJcY2U4ZVGNYlHLkWSxhZERc9qp/y
	ZgA==
X-Received: by 2002:a05:600c:474c:b0:49c:fa21:e74a with SMTP id 5b1f17b1804b1-49e619e4e91mr144757715e9.32.1789327573903;
        Sun, 13 Sep 2026 12:26:13 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a0e6-2301-7846-2cfb-35f5-6359.310.pool.telefonica.de. [2a02:3100:a0e6:2301:7846:2cfb:35f5:6359])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb36e4a6sm22435162f8f.37.2026.09.13.12.26.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 13 Sep 2026 12:26:13 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 1360/1424] net_sched: act_skbmod: use RCU in tcf_skbmod_dump()
Date: Sun, 13 Sep 2026 21:26:09 +0200
Message-Id: <20260913192609.2581-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260912065637.721099003@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org> <20260912065637.721099003@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Please hold this patch unless a 6.6 backport of upstream commit
3016024d7514 ("net_sched: add back BH safety to tcf_lock") can also be
included.

This patch replaces spin_lock_bh() with spin_lock() in
tcf_skbmod_init(). A rate estimator can take the same lock from timer
softirq context, so the timer can interrupt action replacement while it
holds the lock and deadlock on it.

I reproduced this on 6.6.157-rc1 in QEMU with lockdep: after the estimator
timer ran, replacing an indexed skbmod action reported inconsistent softirq
locking on tcfa_lock between est_timer() and tcf_skbmod_init().

With only the skbmod hunk from 3016024d7514 applied, restoring
spin_lock_bh()/spin_unlock_bh(), the same test produced no lockdep
warning.

Thanks,
Karl
