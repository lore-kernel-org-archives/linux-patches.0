Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813AF1FC7F6
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793401; cv=none; b=LAi3XpGbbDyigsPSW0BvPfkmD+5WmFoOOEp6NlNBexGDOrWyMcEtbt4bCHqw+JUf+JZQQGMMziZBQ8hOoSfKbQQlZXllRFquQRN7O4Hygoubw5C4JNg4nrAysbRlH+p2DehOXBRajcdyYD+ZYv8xYFzWFylye2E+6V5M5ahlH6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793401; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AG5IfTuOrwxW1Es3jvUfxu5AmwSaCt542cH2QgRVM0r+7jgsrq+o23/nHwY+RTmd5f37TKvFpwC8Msdou3UN8LILplZVLKOBwU4L5RqDOlsuM4lr0Duo2FRsZ3cLje4UQdFqxF04GfcAtz7RJO0QY4tA0taQE8ZzAfc0eJIVSfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fDMhhRnu; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fDMhhRnu"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-539fbbadf83so1736187e87.0
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793397; x=1730398197; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=fDMhhRnuLAz+6bkBfRgprY+djZd2KLe7C4ZuDAMG01ISF/876pJgKZz9GE4DMimH04
         AvrJj7aeXcvgxpNqwElChSBj+3ydTFyljb+4WEFdceDwEnmVObZWMpFbrbw2O/cBrFF2
         kYzGEm/pwC9pGT7qj4Le6O8tsLEUWhw6GyfDD/Nj1fJDLf+31m7BUbQ66eFAVm5n/S2g
         /xAm2f6BVCr0pv4reXQD0TWJC1Vi5zi9cyX9zfiAylyqYClfJC3HMvuB12/QwlL1RpoD
         EcPnpf2m3iPlLXJ4zO30u9aJL9e3U9BvoSS8MQTM3xdmmhpekl0K+DImfFlIHgv0V4fT
         IEJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793397; x=1730398197;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=leoFhSMYomfqgFDJi+t4Q63XZZlqqfYMp3WXXwfdwL9rO/JcyKtOAvbqkB6mQAdh0s
         oqofCgF/Wqw1/YiDnid2gjD3TkvFUe4c+rIFPManilaM2KjFQPlLHO9OWxdKMpCew43O
         PC7JortwjJJ3D6dFFahUWJmb7X2ghVkUzeZrGxAM2U/foZqqJ5JlG24x2lYLhsgbTudq
         66rJ6IqvN/Fy49GTbv6hmhUouQ5FG4kZK7GFIMhYZNpXVhrG2xsi70E9q6Q2Ro3EJh/k
         CO/xGIYj+RVfNsEWxK0rSG2Kqxskv6gnpBXO3RyxNtT4av4EJW4J5PJNvmZsYbwJlCWd
         BN1Q==
X-Gm-Message-State: AOJu0YypyWueFNyweWsIvDEL0pdxLFK1oGVhbtSs8ADKaDbIfIQxKBEN
	+qRU08Ei8DjJc+Gt5sBUDYosmh+txdpfmKiQqOlLcgHz02Gvs9d+
X-Google-Smtp-Source: AGHT+IFTPlHVbpIoJfwsEws0ScxFGK7hPD9j37MJ9y2wcojly1HlZ0DtRk4ZoBN+6ZjdG5bGPxfWJA==
X-Received: by 2002:a05:6512:1255:b0:52e:7ef1:7c6e with SMTP id 2adb3069b0e04-53b1a37d045mr4602577e87.51.1729793397390;
        Thu, 24 Oct 2024 11:09:57 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a22432e39sm1437423e87.241.2024.10.24.11.09.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:54 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:48 +0300
Message-ID: <20241024180948.4781-1-vladimirputin693389@gmail.com>
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
