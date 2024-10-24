Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98431D3195
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793417; cv=none; b=WHTgbu9/u6x4bNAMv90xY93DYpCx/tiwQiumO4+vFdd6fF1NG0vEXjYWF+/PssRm1HtwgguTEhCXmJ1QFkmnhP+XLnyf6hfPykqIcbT/1W5fweyacq218Y9BcjgnArRkNChp6GgI6PMQxfBMtfV77d4rln/KpTY6Vi2Ar4ebknI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793417; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c2+hujMI5bdhfof/XpAHiP9+r8wcwY5xkTAAEAdj4rMwoHQTbx3JYXb7koVG4ZYoo/kxuQJN1qfxorBjIXpnU0kgmEWqCx9hSrXFQcCXz7i7Vg9hPntdOnC7k98RBfC11mAos+tuvDlxnzBFRN/5+N5UA8yfT3bPCNOV/I/AbTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fzfTZsfD; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fzfTZsfD"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-539f4d8ef84so1608298e87.0
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793414; x=1730398214; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=fzfTZsfDidvPt2rRUxL89TIoas+7/b5zLKvI05TeY+z+4rmftRWefCuGHfPfZG4BCx
         hplRkmUMk5e4qFJEd30d0qDg60HKqpCFv2bQuWKEBMt8dVi2uTeV0BUwY9R/JW6WqHu5
         o8lzti/G4+lYeOaw4ExmU7zLyaPmnicIROJzdoIlZ5/JXNYxzaE4vr2DK7lCHmvfhCka
         84T9c8n+4eYH6ZjFpSuIsZNyKTdG0zpTNQzdlfyUBRoXr2YavmA/9pu7L+EG6/8fpMcS
         iRefdXUOcHKUWFhP9HsSVgOSwiHvjGsEtQcGx/ybnMXRXA4xEyEMm5mNRShRDJMuAGOL
         0oBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793414; x=1730398214;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=mlFlR1Hud1mS0m24gtIgdGKzpPsaCSDrrqBukHYRu0wBEUlJ2WgqFyOZOh8x7Y45bO
         3Bg63Gc/Y/XuI/fsxJuOYFTF9p+wSeZ0yvSmLxjr6zGj9DR6+aksZw5cHQd3Y9WV6UXb
         oTRJO+aDi2att7SQZay5GxvsNJ45lu7ZUcy0dJeRa/DVWLQ08P4sMkhbZXnznWCn8iZZ
         tiq65vZpkZq15t6ic/9aPmRP/AWTPJhZqLn50tpNVB0XiSjJOYi8DfP6hYSqwJf29lBQ
         bDN9IXe4sfWbiRgabZ3l0LIdMzRCdfBmBMjXqPZCo/SKuONERL82rXGGYCu6zMZrJXHF
         0cUw==
X-Gm-Message-State: AOJu0Yz9fC2l+E5OoykULZP//PElz5vjodRxO0ufu0GPE8AUhwsG9p+v
	ztgCoMMKLsSgxOAFfh//AhU9XAMeORQULmKYg7+JKE8V+5Q/+/16WzW62c1b
X-Google-Smtp-Source: AGHT+IE9esyUTitZ1kjLbICcvndxrTaUvsmqCIzwit+AeVemmf087F/NCdeo/bgQIre8BQF+Y2H7BQ==
X-Received: by 2002:a05:6512:3e25:b0:539:f06c:6f1d with SMTP id 2adb3069b0e04-53b1a3a786amr4509056e87.55.1729793413840;
        Thu, 24 Oct 2024 11:10:13 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a2243eeffsm1430020e87.268.2024.10.24.11.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:09 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:59 +0300
Message-ID: <20241024180959.6809-1-vladimirputin693389@gmail.com>
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
