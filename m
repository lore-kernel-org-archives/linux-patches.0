Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF7631E858
	for <patches@lists.linux.dev>; Sun, 13 Sep 2026 17:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789320522; cv=none; b=MkCgXdUORNQ1Jy5mj/UOIlHZGq2szZf4SZmLvIEHh7jOBxZERgsgrrVAvYg3SZzjt0C42duu3esLQLjp6AJtHyZU2kO8GyQVMaanGtkJxl1338adaS1GDZ/j2Z9WhohGDoNpTDCn7w8wU48ngE1gwvkZaZTVi2pbU2cx+mIBm2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789320522; c=relaxed/simple;
	bh=On+rz/ZmuKojokNXfYqOBOt08u5f6BSrCmw1MqxDuAg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oCW2bBZ5lLW7kl2pC7+RasoPxyRoAP95dvwdAyunNr6gHRuJcHVRql5M4iHbj+utSWLqCyOJWRmnrZIdxFZEnH4YT1jgJmbrh/AcNOV6Xf5ZWMySUSkciqFhVTuGOISb95Gm72wpyYs4JklOiP+i0Qz4MUOIDe4XsKjC71MHb9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JQRG48v8; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JQRG48v8"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e7355e411so7475155e9.1
        for <patches@lists.linux.dev>; Sun, 13 Sep 2026 10:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789320519; x=1789925319; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=On+rz/ZmuKojokNXfYqOBOt08u5f6BSrCmw1MqxDuAg=;
        b=JQRG48v8JmGC738nAI/Yn4DGgGpFkTJgGP+FJde7fH3IySY+1aXRMRPcebRR5Y0uUV
         Mi7WHzaGTS8zSnbeqF4UOrJ5hNYXQZBVhp7bl2F5NBOsTlP12bq9aQkRJ9MLGGHpAf84
         M74QY2oaq/NqvBGPwgxzvSuO/K1/Ojylfq64o6Ph4Uf7aaLQlUctXxqhHdhXGMzAV5aT
         394DaFLxnpwzr7T1OQzdf4wnl9VJLrV16Sn5gYCyuQoZoFIEVCdzytPiSovqpghcgRKI
         i4kfw23wMZ9ZBWQz4DTeMODH2dpslZUP6RwVRVQw5uvzWWuWhLy6zChEYri7VtkfhDOY
         6bPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789320519; x=1789925319;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=On+rz/ZmuKojokNXfYqOBOt08u5f6BSrCmw1MqxDuAg=;
        b=Y6EC8cKGpz7Gq3KGHvfas85rdbaHMO1tGUtRvlraueL6l/Sy9pUrWgMHFUbI14fthn
         d2bsbc+vT3iHyuL/mh3m6ppfvKj2+1WIltWREwJ+nDwm1FkZWfTCtMDgrj9sNDuV8Th/
         naoNJ2mptpqhSq1BRSpU8mpTgXCOevCi5GjPlIlzdl1CDep3KXZGKWf4V8h07IMCjpEW
         3tMxSZtOCQbrueYgkAEFgT4UAX/6cUSOd2etB1iLwSwDxghXVtKPSoVXZPxI90ns9w5d
         irBzVA04UMglnaCtRExah9f+dF/58AS5mCcGgUqA5txx9rehM0CPoghNiYFAWDK6d33S
         cfTQ==
X-Forwarded-Encrypted: i=1; AKwUvBzsFyXHIedOIZBWOLc1/2nsJHxYQBchRaEedBT8Wv0ve/kpOiqOjHPnWMI+hyG69CIczVXb52uU@lists.linux.dev
X-Gm-Message-State: AFuF++mEwWBNGTz/nLGq7xu9RD8voTfLvUYvtWToNueHF/dTPA9/11z9
	nfJby16jFgwcsaEXB7+/mkC0K2bmihO70+sr20hiyhEi8A6yVh8LnLMR
X-Gm-Gg: AYBFou2wSrN2N7E9D8u0QIpQ1i9kvSLjMZ8hPAJKSZNbytBSju8ulBjZpOkCdnOZz7u
	o85N4arsV2l5N11UhOhGBmOnVYAfomWvcZi+yEUDeHOTcP3Ka0bD1FMLsu/8TG/lxcrnxsiYyUh
	52JFmssK9cAF4fEByReWb2z77/q4MEV+6gT7MjMQz4PyZ3FIrOMbwcP+hgAsq86TsU7K4b8JbmU
	St9UiVPdr6krxyBDtW3RLDFVQwsEkeXvxOQFJUBFcQLYC0c4QU/RhqZuzjHU9fjyPweVdAdlZYU
	NlDdjTP9mm0ruzl9/HS3rNP8M/01Cf7UEc2wjbmJIDjIO9ekfJWR0DdA8ILD2KlNYN4otSLrVzE
	7UTDmFwOMLmJ9lBvTu6skdt642tSA6QJ/iHtn9cnGZceCBaIITEEOed+sEkkNBI4Kru2d4liJWV
	gmky9PTO9T3EcfsObNoi/6SFDV8zVjOQWTSsBeOE9Eqq4FnSHjJYVfxfkEGu/F6lhmUY8LfWbS2
	wT/W1GwNBd40OyMMcTF4SuSsUfJ+6INgkF+rPOAVx3qop80nLQMhTnj/9Co4xcXyU1InRXnVQyJ
	j5InhDuFZmDPJFSym8DMooFUfbY5b3HMFsDw/d/aIRWIRBrHOaun/6qKn+GLX9bSbeeAF70lDJO
	6SoOfTtz0YKb9HqEuDAQ=
X-Received: by 2002:a05:600c:4693:b0:498:943:ccc0 with SMTP id 5b1f17b1804b1-49e619bec89mr306254245e9.6.1789320518714;
        Sun, 13 Sep 2026 10:28:38 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a0e6-2301-7846-2cfb-35f5-6359.310.pool.telefonica.de. [2a02:3100:a0e6:2301:7846:2cfb:35f5:6359])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d26d4e3f3sm366987695e9.15.2026.09.13.10.28.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 13 Sep 2026 10:28:38 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 888/935] net_sched: act_skbmod: use RCU in tcf_skbmod_dump()
Date: Sun, 13 Sep 2026 19:28:36 +0200
Message-Id: <20260913172836.1738-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260912065547.180810648@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org> <20260912065547.180810648@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Please hold this patch unless a 5.15 backport of upstream commit
3016024d7514 ("net_sched: add back BH safety to tcf_lock") can also be
included.

This patch replaces spin_lock_bh() with spin_lock() in
tcf_skbmod_init(). A rate estimator can take the same lock from timer
softirq context, so the timer can interrupt action replacement while it
holds the lock and deadlock on it.

I reproduced this on 5.15.221-rc1 in QEMU with lockdep: after the estimator
timer ran, replacing an indexed skbmod action reported inconsistent softirq
locking on tcfa_lock between est_timer() and tcf_skbmod_init().

With only the skbmod hunk from 3016024d7514 applied, restoring
spin_lock_bh()/spin_unlock_bh(), the same test produced no lockdep
warning.

Thanks,
Karl
