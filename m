Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69054155308
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793396; cv=none; b=GcXsMV043Cidl1tP6pPnPD41UWS7EnbwMMPpm79rQblyrrhFC2KepxcIFLliuD2zL7Xw7LiYlfPAaIZIJJtILKmwm2ahqfIJpCLAbeA0GLuzJ1n1iLOzEunj1uaPqfeZ/aCqsXYt86dmsIeFKs6XCnw57X9x0T9tVjj7uY9WvpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793396; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eXUb8y5MlfqjsWLa5i5NT/qs9yE+dG5MztWHz/MlpUhUEntEz4VKadQ2YcHm/oHivnmWvc54e3SyGYyDR1e/z1OjZu7iifXpbJ2YaqplC5EiF4KsQ1/sK1IOqobw6AS7I9agYmCB8CPLt7H2WmTu4zzGFiFZ/OIvSjmT/lSrkrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g3xQBTMu; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g3xQBTMu"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-539fe76e802so1594743e87.1
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793392; x=1730398192; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=g3xQBTMu9bbXl717HA0VjyE65uu8X2IEjvCXEIckrNxpCFSb2Odq8X5td/zTwncT75
         BX6GdehZIDSOyTMBIa0VsER7bVQmXD7qKYBHeoBjxiIPH2EmMvgMI+lnA/T1jArod0iI
         ZRVpLUPxD5NE9XEIQxjKGuX+EGRR4VvxF1qaQVdQZRthWHRDQbnJSM/7bZ55dHnutwdN
         ppG6iC7cRVM2+LTzMFigXEubbjkzGYpp2ndG2zpDw0Q0QkQlfFnI6WbD3BbWknudBtd7
         b6uGUaBZ9uYGDdzW5/OxIKwT1UCM+Qi0CWh5Ur9ZUHGfH8UfUHidpA/c6n3/ZXTqz8sH
         ZotA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793392; x=1730398192;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=p86RMoGbBdG/4x/lk70b2o3ZzJdk3rcz3IEXwd9bgcnRIaFJBngiLYYRd3eNBEk3UD
         zkWXs0nboLw9lMtqAE0w2cWo/XUySOHwlIjpnvtd1KrrlIrJE8XPw6c9xQFBb+BbaCys
         U/h9sPXOXfTLhbWXI5eDiSeWNP+KC5UrP5kAt8wBeUB5bravwpKkra7bnIUYPlKZ1yX2
         ZjVUO/Cy0ElD8cUHQW7zXpu731zYkmx/r73ZP3/zhF99lgVwkuWjahPZQW+4RG0Y9pmg
         tjNjGsthRlvbNPziq0AbVEwrfIpeqGWLsW1iZaIu3x7/q3h7Q2cuxpClCyAVHrr4SH3y
         WghQ==
X-Gm-Message-State: AOJu0YwdYyD8FQFDDGcm8Eev3WvXUX3KgpTNWM5FQvUPDyA9/jAN2pRI
	1v3pVzMYuiJCIYy+iGjzPM5GmIrRSgaIxVSOHu9CGi07zS39k1uS
X-Google-Smtp-Source: AGHT+IEtCG/tbM1l0LZRVCXur5tCUfwd5YOhGnskrlsflyhzmSvljtoPZeXDKdptkJ+XxDliQP4LDQ==
X-Received: by 2002:a05:6512:6c6:b0:539:8bc6:694a with SMTP id 2adb3069b0e04-53b1a36b85bmr4596164e87.43.1729793392398;
        Thu, 24 Oct 2024 11:09:52 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53b13cb326fsm881293e87.54.2024.10.24.11.09.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:52 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:46 +0300
Message-ID: <20241024180946.4399-1-vladimirputin693389@gmail.com>
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
