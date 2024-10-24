Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235931FF7B9
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793410; cv=none; b=ezKk9qPJ/L+NlUuSLh4o9MYD2ho6F4ze3rGt3pffosLjcldQjk1UOAR3apad5qBXCTSJNFdEKPmwYdpMKPlUBpBUyuEToO/RQWoVGW45G/3Th7Ayy9xm03CmMd4GYMXduC/xnLO7H7bH4gM2p9Xk33O50mNd6ayp8Ba1LBGJvLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793410; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GcCIWgaE1cukZWIj4E1rNpo6Zjgz1K+sMuo1JuTQKW3p5+bLJN8bnT13ry5O4I+reoiNBDXdKe/m9Tf8JEZov/PG1VO4bFglikGl7niiNLlrUZtPRO6BTLmkb/S2IwdXySe6/sxamjEl4XCDNfelTRrxbkceNNIaSXsqZSnzSEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hYuXAzAQ; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hYuXAzAQ"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-539e690479cso1320001e87.3
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793406; x=1730398206; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=hYuXAzAQd0M/CUv09EakK8jHAVaNqHHoxF27uLrJco9rSdG/DSBwp/AoG2ral2e+u5
         7kf+Fz+e9wVVNHmavsLFhy7nPUGqjS6CHB9aP39t5pILVPnD4suxmzfNa5Bloz9LheB4
         K5C95udTOQusnhFQR0erKKnUD7SllKMaaHkk/LMpzJomt/G2TWCNOakiFE33755VgOgO
         UitHlYDargRa9ngIBYD6FrzFLmKX0ekN73iY7+RhPcrLGi18tqsx4lXABThYn7G21PKC
         T4oh6mHw47olUvFAKya2yF130Hn5kJz1t365ito5tuBE67Vv+poHZ4xhAtWbIBgu0BAb
         FxcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793406; x=1730398206;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=tqLilMNDG/sJXr+4mJcZFVnjPePNoJmGXrNipIhm8zgDNWwIOIulcuvbSM+WmCaDti
         fsYXVSdQeBXkdDVni225fwlM0IZxLcgo8vK0PcwObjwyOGHuZHnM4ueXOp/hoLUxuBjc
         WYRxuGd6JDeJQ6zvX7CrCQEHDL7zf+IpVksvVRgMNhREfP2h1x6DucDdEL/lTq8aAR/H
         /jXA9rC31BQ9ruf5ostCU+slBVLfGkORFA8p6b4WlMSfgeH1bn4rvVDFa5p7LyMriia0
         2ZzWe5I+z5SLUMt0JWANutHnJSPLGuYoVPL2/TWABUcy8j3rjalcFABEJjclR/qDCX0y
         SIMA==
X-Gm-Message-State: AOJu0Ywa0JyVIPhiFRzS5+MtVOMeoPw0OG3mLWl+RhCGoXOCt/Ys5dmK
	0cNcZv4tnBJO9JaW0Phd47W31v+Ljj2rt7fhpOOPKaQ9qubx8sKAqPc7C0GP
X-Google-Smtp-Source: AGHT+IFALbTpmyr/g4UvLKqBCbeKz8bCYdUi+NscxWZDK55+PkZ+r6j+bimRXUMVIh6gkAM7eYMVug==
X-Received: by 2002:a05:6512:23a9:b0:52e:9b2f:c313 with SMTP id 2adb3069b0e04-53b1a313464mr4413339e87.22.1729793406070;
        Thu, 24 Oct 2024 11:10:06 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a223ef957sm1433380e87.63.2024.10.24.11.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:04 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:58 +0300
Message-ID: <20241024180958.6602-1-vladimirputin693389@gmail.com>
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
