Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD1F1FC7D8;
	Thu, 24 Oct 2024 17:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729791540; cv=none; b=M7OHD/f9U91WuTTx61LuwwgIsfR3W28iTwuAIvFlSeiW1YqkQWb0iryGaPWkKF9iSTJx4V+0RI5eyPuLo/nPgVRlwfYLLpNuPX1D5WVGO+X47ekQ7AnAjGKhvLzZiREvZeJkboS5IHSLi15JV/GK8SubhOvjs3w+hRocP5S7Bzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729791540; c=relaxed/simple;
	bh=8WJnbrt2+eyPMiVYG09me24q/mcBtJcn+Lsz0IxKsZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n+xQA5VwtxQ16haexufUJxFmQldaea3HHsZFoxV1hAOvJzhW0ejIKw2ZWzh6jdavG0V5ud/JzhbCBR0iC/7APQYzffZ9Q+PhnibebJxMo/TbPYcjW2s9wCGu2hHwSCD9MPxLxlCT1QVATTPoP8gPyWJZOV4QFHq3wCly5Cis8ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eGJW06Fj; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eGJW06Fj"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-539fe76e802so1554601e87.1;
        Thu, 24 Oct 2024 10:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729791536; x=1730396336; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8WJnbrt2+eyPMiVYG09me24q/mcBtJcn+Lsz0IxKsZc=;
        b=eGJW06FjJT9N7NNV5xEzc3o6ZevPbyApq8plU0X6hdhCU8ZvLRiPrOvr82n4OfFWG+
         xFZwPr7kl7S0n+Z7jAgoxY3oH7G/UJ9GSqmA7WFV3VMSSu08aXM6/jqIDfT4OTKaA/t0
         X04BGR5YEQUwvwlk+p+3/Uwgwmf2IKCfxwM35KJSv+pXHgbMvC36eywr0mbX0+hQNam/
         L4p5GsCL6Wd5Z6swh13EIDT6zLtW/nCdchdi50UoxHcqYqBM1OYrI7VGIzefVzDJQ026
         O1dLc8SeAMwZesF0CBjGFyuPhnZSgeljlv2jqV2dNW9EEd7yl+JGrhRZiB4/hA57QTmz
         /sSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729791536; x=1730396336;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8WJnbrt2+eyPMiVYG09me24q/mcBtJcn+Lsz0IxKsZc=;
        b=KLld7f9vb/5BWSeE0/vOQOb5BazEprEVNpPEd91qQJ9nwNyNka3qY7hs/cyJ4sProp
         /+9zsgR7tKB3C8yu+PjC7OCR5VMGaKJBSqPaRwn7DwVr7ltGaS6wTEgWUZb3cEmj0EC/
         54VJBBgNwfPQUaWypaedmOQEFixBBT8OyWm65bl1GppQIIWQrH66PoxQgq/nj7+NNF5m
         vXOPZHJFGjHIwYI1h8U5oxCyBbZNTcKNCgn8gfz5hK6/jlnxIhqya/Gb0OuCw07B6lt4
         /o8q4QTO8Fam7qXyaHdseDIE3+sBS6/WT1IshWgPe5JYJmU0cLGXrAc8H1PpnJFiBOLd
         ejZg==
X-Forwarded-Encrypted: i=1; AJvYcCU4n9L9CB/nDwqNbj8Iyz9zMqMdgoeWjHJXpY7db9hD8KSi/4BW3fkpBE3Y9rpmbfskDPGnnwHpqQ==@lists.linux.dev, AJvYcCXKyCFffojOxab2bz0FWQk1cWt87Jhm3ppclC7w1JNJLuFUA4W8Kvrrk/u6iUouI8yXlio=@lists.linux.dev
X-Gm-Message-State: AOJu0YxBqrlnuZUt74t0kBQ1YcjsCD+c4R8QxEORxU5fUpMi2av9C2ng
	8d8rwuthcphYIVDkctyEgN+aC8DQH/XFmnlUDNBFuan9CZYIkvfb
X-Google-Smtp-Source: AGHT+IHBgp08+X7VDah7A1PXK+oh2J53hxr+ZwxrWtWH2iwrLcyRGNg7D7RBAUjcie/LivvlgLDo6g==
X-Received: by 2002:a05:6512:3a96:b0:539:e436:f1cd with SMTP id 2adb3069b0e04-53b1a306993mr4517544e87.16.1729791536088;
        Thu, 24 Oct 2024 10:38:56 -0700 (PDT)
Received: from seven-swords.. ([2a03:d000:2:9006:4eed:fbff:fe72:e806])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a2242024csm1417428e87.121.2024.10.24.10.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 10:38:55 -0700 (PDT)
From: Ivan Epifanov <isage.dna@gmail.com>
To: linux@roeck-us.net
Cc: andriy.shevchenko@intel.com,
	aospan@netup.ru,
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
Date: Thu, 24 Oct 2024 20:38:51 +0300
Message-ID: <20241024173851.245260-1-isage.dna@gmail.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <68e35542-d360-4a37-9ff1-16fe76594b6f@roeck-us.net>
References: <68e35542-d360-4a37-9ff1-16fe76594b6f@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Yes, everyone should do that, and I did.

If you did, you'd knew that their defence ended in 1940 with peace treaty.

Surely, Great Britain, Canada, Australia, New-Zealand and Union of South Africa delcared war on Finland in 1941, because Finland was "defending", right?
