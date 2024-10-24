Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDC61FF7CA
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793399; cv=none; b=LjMSQe1AOgOfX8uedR4vODkuerXpNFd4hmj1X63r4VPs9IkZrA4m0RRE3mvvjljJK1abDDfpPZC+6+rHRYiYE+ZRRawwtKRxtrxs4fLFzc96H9Rstv5XJTG3J+1szB1FVvzCpLW3TwMVg+m3+ISNy08w9oMF02AGO8LoJlo0dJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793399; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V8k8rDV5C+vT4ioOK7jZgQwcEDl0agnUnIEn/RERmDR6g17D4WVxmG6+0dJDq6npTsIMQZtbWLmHcIkFXsmM5NsosL+VNr4c9mVtRl40W5zZZBrDMWGrhM3qOkx6nRwZu18FNUgWDPRj/mXVy9q/D6KkqWDsOx+fUe68y9Ly4aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AAgbL7L4; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AAgbL7L4"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2fb5111747cso12769781fa.2
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793396; x=1730398196; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=AAgbL7L4Pc/ZBLE910FcjXwngHV09S9W1itMDVSRvUE7sXxFv5pSb7FiDfwB9/K6Cn
         vP93EsvZPztA1wRafTcK2aBptjPbyHzbTRYE6xNOUouoCM3WuAfMtwHO7v2xQ7DWPV+7
         emIHYkz9S+P2YOE9FoW+ssi0iUbipMjdb85SQKQieyx5oKeaO2cYpsIMd9xqlXguyE7f
         +4KvuCOxixQxkf+b1edDo0zJKJsKFtvxTPQfEKFVOHPrIXeWcdZnCxkxEa73rgbyEB6y
         cnraqSYN4NZpWHtzsXSmJy3BvAI+60f3LYD3YupgVX3HH/qdLz0aKDiIxiYxSN3hCDpQ
         fUAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793396; x=1730398196;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=l2RD+pjc3LvH2YiuwZzeSvRpoLDcYVN7OgYUWpifS1h5WPP4F/Jog5zZiYKumC6rlF
         Hqm72F6Q8PCpnStljfR5F4CPIioIykah3LVV+MbzCKGJTlnrD4agzShIgy42ZR7eYng1
         GZeW53or6JnhkMqlNCFmQyEPFvzMzRLSIIY8mumhKnedDywv9pKrO4eroU7WYISZmRx6
         +RYqSdV1rYGLjLHLSOAbO2tB0/jiDZHuZ748Kkg0UotKZ/uDcL2cSkmqRDRtSn0JQYdQ
         P8WFjLpkgqQt4jw2J7d2B+pbc0s1kYaH/QuarAYLUkxKO7l3iptufWXUIA1EDslQCnzV
         pEiA==
X-Gm-Message-State: AOJu0YzF+Jos9jPXFtvJ2zwSc4Ec5AIlTIhNCtPP5ZauuTqsGb10jwsV
	EH7qcZTNPrVXdqfs/y8e69cZdFoOLIpBtU3bNJZK27MgVrdKud3NDqMQdg==
X-Google-Smtp-Source: AGHT+IH4MuhnlAQS1Y8oXzk8X40BdnATQo+7LNv58tWXaJFpcvpEsowIMKDRjP0Wc5IpQC/ZDxqJ1g==
X-Received: by 2002:a05:651c:2106:b0:2fb:5688:55c0 with SMTP id 38308e7fff4ca-2fc9d5e3c81mr40780291fa.38.1729793395775;
        Thu, 24 Oct 2024 11:09:55 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2fb9adf887dsm14632231fa.78.2024.10.24.11.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:55 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:48 +0300
Message-ID: <20241024180948.4961-1-vladimirputin693389@gmail.com>
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
