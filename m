Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0016B1C4A18;
	Thu, 24 Oct 2024 17:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729789991; cv=none; b=Tgh2VuMdge/+xBTdJYmRQaPftcQZUnbErZOSHilGrhKsZGgXzC1CkWBL0bEwHYyLaaDt24FjRrR9/pT55cx4N5j03yqiFitz6MJMrEDNYvMt2hRBpzUmYaCHbkEjqDn48xq32vcXP2PWzfZGu5JSYY8uGkp9hZq8F8h1XETKRbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729789991; c=relaxed/simple;
	bh=6hdAvb8NLWL704iTziqYqjEOhmMGQ3+UNyvCY/oBTLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JAMVWPbXeFNeKlPoaIJjgGj8GSYLYnZTglQtir4Flk+Tt+vXpk/iLtqL4LT01xS2yFnPtz8lWGpL5sDfmFGii5KvQGAyehRZcIP1XKECRe87LbHQownOFTJzVWcBO/MTopXwaBecsCpnlGw47Yg4geK2nczt7zr2YslLL4k4p9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RL4tDV8M; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RL4tDV8M"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-539d9fffea1so1089822e87.2;
        Thu, 24 Oct 2024 10:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729789987; x=1730394787; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6hdAvb8NLWL704iTziqYqjEOhmMGQ3+UNyvCY/oBTLo=;
        b=RL4tDV8MTqS1ANKDpBeXcQriNNjylQTDcZQklC5DB5S+V1lUbXHmauUD5OB3siRqYb
         CY0Tn5BHAMqTzgL3Mf4BQiKVjaxDs9Yc7IWEUx5y3WsmItBrNY4zeHfyWUBxLZKfudcN
         SuyVK2HW5x7WDh5GwfYutwyq8p8eHcQj71oERTw0YiWtN3zrnzqhrQ/MvqiDFd8eSrGE
         3QQTAlfA6skamN98Y371Vj3xJ6bfQB2kujfrRLx7rq2qyii4d5bjY/rAMgnkj4/6at1q
         1ghLMwDeXD4OLbKaZURQ+u3BjSwzNi5eluGmd8E0qLLzHFvURsbY8r0BuxxsEB7u9ICe
         bV2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729789987; x=1730394787;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6hdAvb8NLWL704iTziqYqjEOhmMGQ3+UNyvCY/oBTLo=;
        b=Nptbbj0VJu4t4dMqDzeb+oTHbi6peC88BM5dhJwH8fdpxUwMYpYyEip/7FqOJ5zWkn
         3ZjUSenEbGxaiBZfFwIYDYPwTXg4wMh466NUsozJtkBESE44OsaiBNWq+ohbkG3telhx
         Se1TlwU0WZ6fZwCNqV+d1fg+J0gYwhzbJZnFjWdHrEwTCLCMjyb/irLAW/dPHdJbir+v
         bF6G2nefdbMHGEiFNDIq+cxZ83PmMKP5ifEIPAG7BJvVWC985ZVKZBK6Q9uAdRO7i0JV
         zmJLi5EdNU5s/de0jgjTAicpHft/2/ZhRoG/VS9/oHCmv4QPwnMcsmSFYz1drLbeEWMP
         b7xA==
X-Forwarded-Encrypted: i=1; AJvYcCUfaOfax8UR7/3LX+WleOMrprNX9EpgU7Te3CvxMVdzMoxxFwik9YtWkpFWeXkyCOALrJKbUua8HQ==@lists.linux.dev, AJvYcCXAnxDdAGDBalX3yNurodsIaOU+HAkbJorKb1Ce0wxloxlD1wNixaYy0ati4y8fqdks6jU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwH20RxBnX/qqs01e5owCeGOX5IIdGujhYCFUG6j76fE3qpHQTf
	moWzU0C6luNlS1/qi6y1me9lIrAT4MkpSD/boss0ypjN4ybxYItG
X-Google-Smtp-Source: AGHT+IEJrnhn/5/VxTjI1TEQfMbkTLNVVw+upqvyz70ssz9oIGnbiAEnPfVYa3vxl29Vh+zfeQfo5A==
X-Received: by 2002:ac2:4c42:0:b0:539:8ad5:5093 with SMTP id 2adb3069b0e04-53b23e33be4mr1818516e87.35.1729789986594;
        Thu, 24 Oct 2024 10:13:06 -0700 (PDT)
Received: from seven-swords.. ([2a03:d000:2:9006:4eed:fbff:fe72:e806])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a224202a6sm1431843e87.125.2024.10.24.10.13.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 10:13:05 -0700 (PDT)
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
Date: Thu, 24 Oct 2024 20:13:01 +0300
Message-ID: <20241024171301.241949-1-isage.dna@gmail.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <61a622bd-7597-45e2-96d9-9cba02fba407@roeck-us.net>
References: <61a622bd-7597-45e2-96d9-9cba02fba407@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I really don't want to get involved, but this misinformation really goes too far.

Then don't.

> https://en.wikipedia.org/wiki/Finland_in_World_War_II

> provides context. And it does sound familiar. Turns out the Finnish defended
> themselves against invasion from the Soviet Union. Sounds familiar ? Guess it's
> the same as those alleged Nazis in Ukraine nowadays.

Especially if you can't read beyond few pararaphs.
