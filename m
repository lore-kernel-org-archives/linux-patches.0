Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62001FF7CA
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793408; cv=none; b=tQLCYpSvQlDrOKF44B0csH7iEjIo2OxsGzd1vrZgG9ydpL3KzKdfSsQYY/bsdOFv3OwuHHWgYLAWceevRJFoVQdi7wP9hvQS8DFkD/MiUW538E9ypUoYFEIzWbKJsMkbWDhp8HovRPGcHkch0T1AYI9xPLZ0HqlCvoJD7r1tGg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793408; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TNaRSOPyaUx/e15Mln4eMIZHcZ1B46C2H9Fk2fXPgf60J0Ee71UnIVqeFkVK3GeZiwPJ/ibaEGA/7p7EbvnPTXrPyraVoO40ZzoKI6NyRCHN7qSAIgYOvSphMU2eOAU7rKHX1paOKDnzkgd3K+xcvaEVDkhcVg6VjPmFMrnMXj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mk7gh/sO; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mk7gh/sO"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-539e4b7409fso1346350e87.0
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793405; x=1730398205; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=mk7gh/sOkTDu2j4dYulUhZ16W71Jv8vkM5oD0lXYnAgveSXp3qFoqaZzD8XMlSh2or
         g4A+2eHjoZEkiEVgn7/9mx3e1TuBtD3Yqy4E4pb6WgPjJR/7E6HzY37S1x1Z0uGED+if
         WeFGXVPVBO+74IA/UiKD+C6VNatvKRFVveQkjstGb5CkE6ATfJX+xKfFFYPlWFJEzMNO
         bmCWQOEKBW1IMYQtQUt9iDj+bJvd6Ze4koU1f3Gq9UZeeO85uEDdEdtnpBWOZjiBkD/+
         oWNnIxP8UV3VQkN+00p7K+QaUM+Josua37R0LLLj7x5jZFK0jRWO2SA0Wib60XnSfBw5
         1VpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793405; x=1730398205;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=DUYTzV0O+G1UOy6U/hI/OfzBng/tA2y4pOs7CBKsp13tnoj6C4WHRs0jVcW/lC2RHQ
         15aQkd+aLbUrMpuQx/G6x8Rp1FRwcvItCNVGsO0auUwU21ehW909M0cp/DOutQrYYTfw
         Z8eSMoqhNFfPbikuQIVJzEDFKxZ84+sOVLWpdrYa7b5NKsi4p9cKhAdwGfHcT5e0JZhz
         eGv0Ctz5XM2CiCpA2fd0GpDG9gSSP9MtTcz1xPA5dp8YLVtzHb0KB0LdHJ2Ott2hoObt
         a8PtHny4neUcLMTMV2v9a/Jp8JzXtFAyWrDxo1hodeB7JYQfZlvzjwmnXAEV1X79YYiR
         tMzA==
X-Gm-Message-State: AOJu0Yx59WAXy+UyWXARJR5lULVmfpRlQ3St3KNYBzpwvzrPPEVJX8j7
	gEYMWEnYBJXKdUa+WICwm/WINNCGyhuBdfz9osbSksmGXoC9aQTU
X-Google-Smtp-Source: AGHT+IGMkW6tV4Wk7KPWWfFtI6jN2yt3VdRr9ZeK7gwsgVTgl7Ai8WvBfWqv1ADMXWZ/KZJ6rWOpBA==
X-Received: by 2002:a05:6512:3d0e:b0:536:7a79:b4df with SMTP id 2adb3069b0e04-53b2371753fmr1075275e87.14.1729793404670;
        Thu, 24 Oct 2024 11:10:04 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a22432c5fsm1442192e87.240.2024.10.24.11.10.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:04 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:58 +0300
Message-ID: <20241024180958.6536-1-vladimirputin693389@gmail.com>
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
