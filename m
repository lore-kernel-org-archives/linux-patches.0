Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1EC1FF7D9
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793412; cv=none; b=VEve/txA/h7WZwq54X9kiIqRGErCpsDc1PBdCB9MfqiK5qqRH3pWxuNvg8ex0lQyPwd/YO63zcsAAgURq8cmX7wHIWjMMYdlsuGaVrvlMN3QVNT0fEffoCkb4OlNofR+Gz4L3lMwvYrl8YDhy6Q2L3Rsg8y83tzH5ziFUUk+hjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793412; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TuAyjRPc8lWpoKRSy8Ky6tsfOpxOFrPkV+CdokjiVRL3ozXAd5q/o/tFavpzJPTDyi1jMt9nuQ9AUvasuhhDpcpx6pBTp/Hk3sozZ/8RZ2shRQLp0in8Xr1uLfquub/MM1z4txVZDoPdhniPanSUB75EWTuoh7IjOY4QIpgXShI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D8cthJy/; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D8cthJy/"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-53b1fbb8be5so1485791e87.1
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793409; x=1730398209; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=D8cthJy/z9pQNT6SnIxw7J6SI+T7KbaHu+xxffOTFUc1metfv8gh/PcWTBsUW8JAAe
         H1Anvdc7P0rHFAaP6SgXuUma0JCNag4ImWfWvBFXDJB3KckSHQwF2h3q27hKYgjYIS9D
         A5a7uUbIOxcAU0siY7DLWcbtungJ9dspSc3qEkt2Q6qhXNMB9AxY9fCtWxgNXz2wQYLc
         01zc3Pib0a2Hz3wB3NV0qRCoVzb84Lq4GExezLm2UJj0Bzgd+1LhKy2dpyLSQi2/bnyv
         DTC5J/WDtGOjCkONLRIT6RKZInXETPS+Wt06GyM4+5BolJP9pud7Udobi+lUZBc7bzuT
         oR7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793409; x=1730398209;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=aKGb0BY1WSkUi60AnFXHNJzMLZBJJWUvO6f/ex65Aye7jciWPBIR1Sld01PVTgJ4eB
         Qw1sdjd+3lADKgnuQFSbtVsOJJV+2QXfLySLvsk71ikKiv3CLxFce6Kbs7SDENRReCrF
         H/x1CrjjyMIO+fEApaw9Dd6oyfTjBCM7gs3AVkvb4pp8aYfGJGS45B5me09pK+oYAAJ4
         LQK0uSLnUNFR0RppBA81a47RF0dWFcOhnoECmYEul957sWjEAYynfxZzAWUVtNzgbt+f
         YQ1KZo3z6B1+8Y4mFUlhz4cSW5ZOnzPgl6Zs/F1P4Xnt9R8dCjX0Lu5pwsxzvuo11o9m
         7S6g==
X-Gm-Message-State: AOJu0YzhcGdhnTXPoQZ5H0DVqEnA6xWNZbYqDbN02X7w1SMBTLqKWJLX
	nZExyU62bU9PnqyeqX7BNhsHZJl4w/fXTNWfIUO6yzWoXQh+lD3Vg7M23WTZ
X-Google-Smtp-Source: AGHT+IFsOTm84zNK7Nez/xWjD/bjXB85TILuwYToAiTG98kQ8J+AP4R1r4ty59AjLd+4se1GfyRrHA==
X-Received: by 2002:a05:6512:3e05:b0:539:a2e0:4e94 with SMTP id 2adb3069b0e04-53b2375d086mr1106055e87.30.1729793408521;
        Thu, 24 Oct 2024 11:10:08 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53b137a83b0sm886105e87.163.2024.10.24.11.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:05 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:57 +0300
Message-ID: <20241024180957.6552-1-vladimirputin693389@gmail.com>
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
