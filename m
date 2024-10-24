Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6E11FF02F
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793399; cv=none; b=iSCJDBskPLVsKPoupaFNXLtDPKWASPCwgzZTDLy3G5sWeJlkYmw4zbveUOvkohHQSiVaWzL21xQGPZtDuZWxsSWnnz+2Ip+YL+4PjldwdPWvudoymAuYS9ijdn3ZjzznB05HtatD9rDl8bwCW8djBdRy7saYcha4NPHXo15+ydI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793399; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BaoTVHYzuMPC+Q0hQhtJ1Fl6+mVPF8kH8oOIQRCd7BLzB0PPA5wkETwCNX/SerNPTQBI73I+d0Sd/vwnL5H0T1VQt+3P0kVJPNwhbrvWX6qJqlpJtREL6GypWcwvVfyZ763Haz3RGvtHmW/y08OINmO1vWvwpDdWKtFwIgtn7oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gve+joxQ; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gve+joxQ"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-539eb97f26aso1277197e87.2
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793396; x=1730398196; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=gve+joxQuCfD5JEEVrUoINCOz7BhlSdUutQxZQ64wZ5bYeTdLf2fMygRQKXNIWYR3I
         8ERYWBI7MVtGsozFwOdGmpuUgG/7NPoDj1KmoTyJBzZCqQSapvcyU83eKEXMANqFoDq7
         kU8E4otGcd25BqAOybCCmHH7XKOUWgKA9l3eaTP3lQQb9Nz6rWBilE8NB0YeJJ9dWXT7
         yroWqIut3viK0DiCbvLAmHpztWe2/bDfYc/ozItJE4BYdFSaHoypQHKxBSJKfubDLZ3x
         O9uXs/ZfrR8h4HWDgjk29LgxXLrImaPASXQUzxAZNcfKbUvfLG9M4a4jjpybEXLNnsO5
         wJIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793396; x=1730398196;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=YmeL37Bb4bg2bpAPZeTjTvuY/Jt0hniRUK0P/ov2lq6yeulMapF8nD04QQnTtcwevK
         CWDf2dARJJRUgSmTEL9dPKa5MjqbKHpIo8uEZirlsBUZZVGtEeGadf1JxwXHs/sXfaHT
         s02D7CcBUroiAlBNRJGUmHcTC2Hw/jo/SzpI7RsSqqX62W+8+5YWQMOlBtmdARvBsQ0e
         AyB8Vvi54JExh/NjLL2GBenY/QU5yMlrszQ21QgVF4pSBszho71hc17Z6ahZ6ZLFX8xF
         YMKF6vubDidExUV9nO2dhLpAbJhBdSnPMQ1RZVSIvYVCrXkntYnZyQap3upI32pEmWDE
         iNDg==
X-Gm-Message-State: AOJu0YxG+P3ZBkx0P+CHuWK3vs162YGY0pzvviEaI3RAEKEfUcIOFevB
	LEqpUVmtigXHn52/8870VKosiNq7sAekLiNDpyr726uxbQyP8XXj
X-Google-Smtp-Source: AGHT+IH78s/qsIDQnFCxnVhiIpieOnolF/C0WReuwTAjb1adI6DowjM7dJ2BL7klXl2hEDvY/cubXg==
X-Received: by 2002:a05:6512:ad3:b0:539:f5b3:f87c with SMTP id 2adb3069b0e04-53b1a375bfemr4334729e87.46.1729793395406;
        Thu, 24 Oct 2024 11:09:55 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a22431569sm1433143e87.222.2024.10.24.11.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:52 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:47 +0300
Message-ID: <20241024180947.4641-1-vladimirputin693389@gmail.com>
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
