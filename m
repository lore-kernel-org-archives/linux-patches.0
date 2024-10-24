Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FAB61FE0E7
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793420; cv=none; b=p1a5lfUL5kVBHTe8Zec3uwvtzgCgq8b7G6gCvodZqcYKMsqa7Pb8oioERB+83ryd7voRgtrvFFpXFEecG34M7IXIEv8qEw+I/vUmmoAv79Kx8D2K0TheB5oVTxn0V5Zp2QbsT6k22h6N9VNKPAjfAovyOFp1nM8Sm3kK+R60OiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793420; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d0lRPOR83XjnRb/9oUDh2uogPh+4vnldG6XnnfI+ZDYq0avvWIZZ2mrhtiEo34T7sZxa76+U5RDuW19JgTrPKVoRpYi9/D11m0WRKxXedmH+EYYek6egIkcPK0QaIjlgegWzn5FGsc8H3f6O40aQGFpJnLSD+m1g86DKllfahqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N8tVp1zR; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N8tVp1zR"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-53a0c160b94so1543996e87.2
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793416; x=1730398216; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=N8tVp1zR24N2GmmQgTnptHIKWE9w9Hc9Mu2xr3ElfaLaVBEf62Kk0QAgYBUsx6QenM
         CtmafJT8dWp7pfwmHAwAOwolirlo5zydW8cbjxeocSxUlee//K0rru+WcrCp5LaoJbMe
         np0u/ODRCcvBVJ0uosUTcEgzP6rWNdkWd/+v8ZkiwwwtBrA6BN0aQi8YOhj6Tm2DUT1w
         0supaVXvF+eVHoG5P9F6m5qV9cyr9K8hwwD+u36owVQVOR05MZ+cvvEZ4WrYKSYBrmc8
         F/b10xl2K1KDBkQ7PXg4tcvP4PzCAjqDo12i3eNGpEZjEfR5fH+L/qZIt+Qq1RvjQjem
         lAPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793416; x=1730398216;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=cDzM8X8SicPeo0Lw7iqnctq7Tt7OMnYfHONNnhAZciSLOsKGCG4fohB3zyUdqTl9wY
         zGwB1XIiGR3KxF5WxbQ2EPZ91grFrR9zArcAW9wDDdBpOyUOH0CA75WKvYwGiCQOZOVV
         +LdY6OKmualwpFTvlF4oMBg6ZfIokuYZX5tEkdTT9mC405ZJ9Sb9SVVf6i5VSOV96Asx
         bzUSBSqAYXb3DY99gEGZW5JTyQgB8cZYWfBhF05X1Mpc5TWoGqrzkFFuwMGyeoiqGbNm
         LjOsTfLY48CK/DQdxkMuCVQzzVmBq5R1RyTi4kyiHuUKYZAqueAu91X2l3HTIGV3l8Qb
         msPQ==
X-Gm-Message-State: AOJu0Yzkmhr4LszWTOgX2Q2l4mveQw4cvgyjIJsti3VYcLhpE6vP6MgR
	X1qIbnu4/FhdTzERIbT2sP/PspdSueI6DyIprkIIKN/f1bwkI2A9JdPYTxT8
X-Google-Smtp-Source: AGHT+IFdrgsJEIotu+z+xgNr5hVBbw/ozxeey0cKanpXy+hKPV9Z5OGyTEM3DN78UWh4VjwrNHjvWQ==
X-Received: by 2002:a05:6512:ea8:b0:539:f74b:62a5 with SMTP id 2adb3069b0e04-53b1a30d646mr4084992e87.25.1729793416097;
        Thu, 24 Oct 2024 11:10:16 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a22440565sm1414100e87.294.2024.10.24.11.10.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:13 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:10:02 +0300
Message-ID: <20241024181002.7334-1-vladimirputin693389@gmail.com>
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
