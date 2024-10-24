Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BACE1FE0E7
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793398; cv=none; b=qtbWLv8tyGrvHmIrwINpnjsZo06rbvF78vlUav6QK4VN3YL2bAxRtjanZGuIrUm+Fnn9rR8QU+muf9lwthMf+ZLKtBwi0niLVKnKnTM+CUn4NuI7u7GVXDcjn5LwHTNlDBtdKbHp+AG+ARs2GOcerVicXwU+SWtTNe653QcW/+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793398; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S5i+q/YtrKUfJNRi92ADRfpADzcUBt1l2MGxXiX4cLTjuzpzoYRvQFHXaEmeZba4lVq6rtOKRY5E8lVgUkdRU99+zvlhL1Q3jjrv5pZgPSWU0xW8tFits3eszNyH2/XAyqDDvTVuanbFBpp3rKBzCfMfoVYJfBVli5e8OMntQMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IIN/6nU6; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IIN/6nU6"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-539ebb5a20aso1265550e87.2
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793395; x=1730398195; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=IIN/6nU6RGsqiqP6ltp9q1snuHpMa8UsXfWvN07g5cbeLzlOrf0dP7cKT79Bhhxl0y
         nyQXVr/DYMBzZPDx9DzbRWQL6WhMxSpbUB1NqT6nc0FMeuoDTXOI7HWdUlODQh9VCd/i
         cEn0Jm3nXBXqF0XJb4/0tDXwIY82Cs2Ro0n6Bm9iEVsqYjaOcf1W89bD3c52tPpM+UaO
         HAF2/bjP3GGEnd45m/BZM57cDLmyLvh1mN32i8hf2NEOqqb11s9HyZyFeHGDVvGnqM0g
         K6RtQWvpmg7UISNNEMmA18B0EAuTDkb3DLQ7z6LcXU2pJTsUyWasW0p3+6CBcKUx3E++
         HAQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793395; x=1730398195;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=YJRfSPORrdCdb2lDpcoVemSfGnAOXJK0xbxJwgvbONViliEnx5GKBZcam4+osKYeZE
         7+zfYBz6IxbmpM75u9sx8jwpiaFoIvXQ3Yp4ZyaTzVpNpzEy2kUqFA5/shhVmbRb3iO/
         FIilmYU/oYTQ7cPIvLwJH/GxTY298Mk8Tps/Ibex8/rSqhn8nKa3SnZweeD3FF8ineso
         q5m1yjr0+gNfn+OVsG0t244xmAaLbwtA2L+o4HxdU1MCL4rvoygeAWzWV3WBNaGMT1Ek
         rGRr2/sb+P3cLN5XbmehYIj+akhRpUF/0DXKQle/DTPnVrGqGVBLx67i0uLwA0PK/jAh
         48Uw==
X-Gm-Message-State: AOJu0YwJbnzFswHWMnw2WFzTsw0l41xrAY4+MQiSXdqY1ELpfO1NA+lj
	ZCPmHnVAfaUn+xVerFTGD6IDah4IeeGr2Tu7fSBZFb1Hd7ZYCA19Y7U1Aql9
X-Google-Smtp-Source: AGHT+IEl1UJqrRwd6RfcUpJ1Kl7mcFNHTzHdU+eB5uoPOylmEs6/9XyGtbuu5t3fqSQUmEnouu4fzw==
X-Received: by 2002:a05:6512:3989:b0:536:54fd:275b with SMTP id 2adb3069b0e04-53b1a37554emr4218465e87.54.1729793395003;
        Thu, 24 Oct 2024 11:09:55 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a223e5919sm1432378e87.36.2024.10.24.11.09.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:52 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:46 +0300
Message-ID: <20241024180946.4525-1-vladimirputin693389@gmail.com>
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
