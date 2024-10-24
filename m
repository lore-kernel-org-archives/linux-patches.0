Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642471FF7CA
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793412; cv=none; b=Js99GeThRO7s2Vn3mitKKObki2GueEnTgGx2PB3jYuDyhX4rSMSzPDTMZY/avLhQGapN3fQxZUYFBaKfrb/ZhYPA/P5GmGGwbxFP7J7NIi5N9n8mvGJjem92bDpsauUmmrZl2hiBflVUCeq/lZ0oj8QoFiFwN5I97/KsAt3gDJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793412; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oq2iTy/benAVrC2XLPv9gNAms2uEp1ITukavtqM0yb4WWTFolbwa5rwi/HlNJOyJMoHnZAlSBQqdtgAysPI0gEUjvRafuws/7o1wRQjuUdRlQ/JguTvpIoS9gjqAdt8qew9Q7ZTAUwwtu1N1BXyUCLr5p/4bL0xpYpjA6cS92dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FOzAUdYY; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FOzAUdYY"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-539fe02c386so2343478e87.0
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793408; x=1730398208; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=FOzAUdYYkxp997UY8gVworSyyEnbN/nFiTID3+2JC1b55wfimjFBlEFT6TFDmtDzJu
         /74VDg53FWxk+TkfJbsGQS7rScxZ9jJPBHNtSDP0bqLLAYexSHyJULUOsD3UUmxRT9Wm
         XWhumuNhhtPv9yDAimrTYM7UtNjSAz7lS8avLvcyEjiQBBdh14x7Swead6Kf3FQE09h/
         E8EJ0Uiv2cqqhZbmzOGeZM/bSNmZHHhcMGFrRVMufHQGjbZno+NhZwMOQ+q3mU8qLv25
         +rCl29BfbB1/rLMcfep9lgC/B8oe21f/NozpPbif+B+A0K11qytnub3C1KC2KVt26ILp
         9B8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793408; x=1730398208;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=FBu8y6qmg+SrNyK8DJPP2MTm2AsN33tKRbxOG/Ux/hQaIgZk2Salur3kGXFbJJ8x3D
         aWBY937gvQXQaMu2tO27cZDGo4eQiBhv6Y7HRyobL6Z0eKliu9kfm7/XBgEUTOhJq+0o
         8MfpSpnt9ktO/PfsPPAm7n9LLMUfS0+Ftm6k0ODOG2oFwcpXmD28MfEMd13Mm5i2rA1x
         hofO18ETF9NzMpKuqFuVIYTPPsL2YJlQ3vg11jifNmmFb3WdE2/v5DZwuUfJUvWtVCus
         tjNKH6HuYcW+T1OQLm/Tp5y0FV4jMuKZ4Lqzb41Of+v0UTZSj1BEQwARPVCkfDGhsaMM
         3EdA==
X-Gm-Message-State: AOJu0Ywsk4fLhTzujRZQiUf7ZIFqicGG+XwSpPvwnB/2T0uskvsmonKO
	prkaHixthFOLWXhlHN8KuZmRhUOHchQqHLZR9qlqnE/30Z7musSQj922zspP
X-Google-Smtp-Source: AGHT+IFGTaOTsYcmSZsOYZ2HdK6B6rhHX/BB4hUAGZg67a4w8Lz4h2fbobPLczlvx+9WMWasGSqg9A==
X-Received: by 2002:a05:6512:6ce:b0:539:fcf0:268e with SMTP id 2adb3069b0e04-53b237094admr1050915e87.14.1729793408239;
        Thu, 24 Oct 2024 11:10:08 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a223efe99sm1431006e87.104.2024.10.24.11.10.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:04 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:56 +0300
Message-ID: <20241024180956.6229-1-vladimirputin693389@gmail.com>
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
