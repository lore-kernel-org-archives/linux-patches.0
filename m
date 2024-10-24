Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDFF31FF7B7
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793402; cv=none; b=RMV93Tp8VDHIz6iqnCWDdVYQxz/lxl3wGx3S5GamwCym/pZkAc1DSMcW1sb9f+wgItsHWRJwGeBdlfBhYzLuisEUaogKcFuam8tcxx5Cdgr5cIU0jr5ElnzIUTsZyFv+ZQRGFCkHcEmlFlNf0onaTiDFdLy9xR8Z6wfvSAcbbqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793402; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xec0DzKGeLzENkndps87Z1iAQezqforj8wAHKJJ6aUU1BM/3K1QHDnwF9swKrgQPhpGi6FF2NVbSoMmvOt2oOxgigWreW6Q5TCmSHXyovDNvkzcWQ/TtQnUG1yKI2UCj7UFZgngIxfZE746z7e7G3SnH0iYRFYvDRQW7PY2vw1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Oa2NUdya; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Oa2NUdya"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-539f58c68c5so2263447e87.3
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793398; x=1730398198; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=Oa2NUdyam+LPEkXKCoIA0vwW6fDcH3tsCTp/Dhm63N5V9B8r7e9uqiQG3q8E74kCUK
         Smdtu3kVr6On+/1BgKxpUkeFUgIbAJd149LzwuQdEEik8Ai+Y4034IgnRFEzs4Yjqxk8
         6iK6f3ao1uKePDUYXcFoGYoa/QJOv8+dhYKhBfYU9Dm/3nV8VkqrWa6x4KfIFfHXY9ih
         RbG9aDoqYL552/9LR3I5/yHcoZ2IIOeMPe28k/rvw3ARuxoFHhheo9SXmI5wP5y7bOZr
         Dq3PHopMbj7HAGW2rx5snWcCDQfIE6TU8cA6Xgy43DJwgGY0oQvXExKWe6Mn3mJLSwlT
         nz6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793398; x=1730398198;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=pkTZ7ObSnUGA4c5yeLajwUSSTqp5/OuY9QxT/jRkEpp49cbH7OWIamtGwMNTtgc4nl
         XZRIuB9jgJisF6r66O8BMxiG+husGilo+qiax/3hBCjkTSUOm9vl+UBpQA6iQfEypD1V
         67uYZXeTRcQ01tVwD50vndjH9NS++65Z6DhYOwoZETlOdPRkRAho6skdsce5+/w/xODN
         mh9BORDXviSNwUA0LZzigGQv8QuLjc8PhyouzWkQE+OkKnjmnWVfYf5A0rE+FVZVavSS
         2BSerpu4qr7uF0WAgEkM1fK3sspImqtqhrMwU4m1hTIv7mJdyr7C8v0AHrxfdY1mDkQ/
         29Og==
X-Gm-Message-State: AOJu0Yzjpwelepjjah8UurTID1ANt6IwFi9UyeBcNiNDaVvuBqZaEe2Y
	g9Q/O13b/JdAz1FBNmx7SnXDsI7KmxDpw4schfmF0I573mPi5Yty
X-Google-Smtp-Source: AGHT+IGQM9BDqT3wiHr9y5hIvph8olIvEk9ykp1+n1pSCVHnQf/C64CaMJCoHRr5Tv1bnBSPEiNRyQ==
X-Received: by 2002:a05:6512:23aa:b0:539:8cd1:848 with SMTP id 2adb3069b0e04-53b1a3bae89mr5821775e87.61.1729793397780;
        Thu, 24 Oct 2024 11:09:57 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a22422167sm1433836e87.129.2024.10.24.11.09.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:57 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:52 +0300
Message-ID: <20241024180952.5515-1-vladimirputin693389@gmail.com>
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
