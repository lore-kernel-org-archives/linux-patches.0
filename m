Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901E61FAEE6;
	Thu, 24 Oct 2024 17:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729789672; cv=none; b=dQJv6KPkWTlfVvzdSylJl7XMsiWzZFEVW6A9WP2sDQxey8nmPieAvfiuqs3C63b+avLJCE26g16+R5mAAnqlNrFHzs9VohCllPQ2+gTBjTDB0ULE9OKaZovo/PFa4D794+tfR0BtxpLTb+I+aLm8xVGui3aG453jUadX0BkZu+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729789672; c=relaxed/simple;
	bh=wRR1+SsfuQg03dCSafmMEZ8+Tf+vTRsuGcUvfSNBJuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EMmyEH0vCnAsyM/g1BoRKO+bAkpOHGkvokSjD0j/JRs0TmZHxLxALZ8/8014SUoefP/M8HuggnMoRGPbiSprMNMw83SXFGVxUy9jCS6EP4xqaT+MSQc754phC22lhc6xYHyQRfDMHgpq1V1hzALd4OvmMmSzWMsmUDJSFos+POU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K9H9LEn5; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K9H9LEn5"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-539f72c913aso1543968e87.1;
        Thu, 24 Oct 2024 10:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729789668; x=1730394468; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N4zqWpgJymZz2GSVXCHfh3D8JgL8gK/HJOJAl8/d83M=;
        b=K9H9LEn56pU80t8fAtU1Zj2lAPyXJjYcuB2gV5GBchU3TGmMQttdP0A8ib8UDAvDUM
         NP26JufoBXpDJUQOYgF35DG3+x+oFzWyPnlGQYheJxqS0N3KHZxZj+k7gVEtFtJlz4AN
         pPL4h9ddipzGIc+6maf/Vj24HxWNMali+UVcEm3L2kn/kgBgLYR0/8fZH10rpMdqm6Rq
         oE+g6JwTQIlD+nkpY601MEUu/IB90bDlWDu5Af46SLiQMK0soHlFvX+yMXlhZ5coqTKj
         WRjzSGhqvfCGeVORXXS2uG2nc/519H4no5lRTWIzNQXHxwGpf+KKYfHQadiO/L7KA5U3
         1NBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729789668; x=1730394468;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N4zqWpgJymZz2GSVXCHfh3D8JgL8gK/HJOJAl8/d83M=;
        b=XvtVMOu+sRH0cDeoghZtk78rjMDN0RYi3cquPBY6xX3wxFeyQcrAPOFAwGrrKCN/VL
         wu3R/z1Yzlsb5usJoP4qw7/ZQ3Kn235fn+JGH4sHWAn/2i4QzFbJGSBk8zv2vV/xPWIw
         Vh6h/gQycLusZF5byg+TOyseI9mT8fyt4siXYqRRQ6phRqxqsTkiexG9f70/FO1hZlKY
         VSCPoUjP+Xhx6nr8xh+z+6xEURujxQEjbo720Sbv2jo/32TZykeVzh2pUA6IryapoS/g
         HAhtFHfEAwkLuyePFmreIk3obeIdi0/ey6ykgEQuJvExQ7Z81Y05ji0gWmukaf1/+wVE
         JkkA==
X-Forwarded-Encrypted: i=1; AJvYcCU0quzwTK6cUIZC5Uf4ELEfNWac7qzNqiQOGstgDjH8CYi5FrADWsnoummU8ZUKdBY+3YzhRHY+Qw==@lists.linux.dev, AJvYcCUv6fzhyjcUiyXeMLAMf65Tg5AGu0bA7iKNCEvL/+3WihB1ZghpmEJhyB/EnXSkMC26IwA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxG+KvOSCTWqOk1dhovfDzrVXIfCU611fwZu5R2bLEqI5IoEfY8
	uomS4OhkkUwfIlWWpMrcFK+tLS6POxwbpL991DKSxumtBJ3KzLAi
X-Google-Smtp-Source: AGHT+IFz4e5V/ZhUT+FzKXu68/7/HX9Chj/TG/YiHuqSFphTBJiVCK9htk4MUJh3OJ5HcvAjn4kgpw==
X-Received: by 2002:a05:6512:1054:b0:539:efdb:4324 with SMTP id 2adb3069b0e04-53b23debc01mr2073012e87.21.1729789668288;
        Thu, 24 Oct 2024 10:07:48 -0700 (PDT)
Received: from seven-swords.. ([2a03:d000:2:9006:4eed:fbff:fe72:e806])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53b1f30c189sm447396e87.51.2024.10.24.10.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 10:07:47 -0700 (PDT)
From: Ivan Epifanov <isage.dna@gmail.com>
To: andriy.shevchenko@intel.com
Cc: aospan@netup.ru,
	conor.dooley@microchip.com,
	ddrokosov@sberdevices.ru,
	dmaengine@vger.kernel.org,
	dushistov@mail.ru,
	fancer.lancer@gmail.com,
	geert@linux-m68k.org,
	gregkh@linuxfoundation.org,
	hoan@os.amperecomputing.com,
	ink@jurassic.park.msu.ru,
	isage.dna@gmail.com,
	jeffbai@aosc.io,
	kexybiscuit@aosc.io,
	linux-alpha@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-fpga@vger.kernel.org,
	linux-gpio@vger.kernel.org,
	linux-hwmon@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-iio@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org,
	linux-spi@vger.kernel.org,
	manivannan.sadhasivam@linaro.org,
	mattst88@gmail.com,
	netdev@vger.kernel.org,
	nikita@trvn.ru,
	ntb@lists.linux.dev,
	patches@lists.linux.dev,
	richard.henderson@linaro.org,
	s.shtylyov@omp.ru,
	serjk@netup.ru,
	shc_work@mail.ru,
	torvalds@linux-foundation.org,
	torvic9@mailbox.org,
	tsbogend@alpha.franken.de,
	v.georgiev@metrotek.ru,
	wangyuli@uniontech.com,
	wsa+renesas@sang-engineering.com,
	xeb@mail.ru
Subject: Re: [PATCH] Revert "MAINTAINERS: Remove some entries due to various compliance requirements."
Date: Thu, 24 Oct 2024 20:07:42 +0300
Message-ID: <20241024170743.241144-1-isage.dna@gmail.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <Zxpqnf1M8rPTB4DN@black.fi.intel.com>
References: <Zxpqnf1M8rPTB4DN@black.fi.intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Proved that you don't care about users of your product either? Sure

> $ git log --author="andriy.shevchenko@intel.com"
> $ 

Look who's talking
