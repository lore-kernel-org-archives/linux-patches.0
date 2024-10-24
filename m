Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 013102003CE
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793391; cv=none; b=Va1Ge+DYsaGndI2dZ6US5wHtN/67K1AwFLYSvceYJbL4qk5kqlm7zEb5ZF34Cj9CbBRQm4edI3uyQVRXuAMZ0+rFkdM1tj7LNav2idh/qB16ly2EXMdLq9cKV5pxNyMNr8KC6HvY9rLhbg8i7ZAAPO2MTZ9s5ahC012mkYXjTWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793391; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XxdQiW2mEgFBufC3KF6WrKaP/5HtV6eDbGga+dDrE7j79REzeC+Xdg4l0xLuTWOLl3hcHM6ViFko2U4WjHaTUgugQkTfJiY7mAoEzmb0rOkuBM7yKrfO0anlUmiRNz+UbUMgopr6Dcrtz3kAdAmOyZERm01A1HpLAVUIlu2UexY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Kf5PfS9z; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kf5PfS9z"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2fb498a92f6so12530781fa.1
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793387; x=1730398187; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=Kf5PfS9zBKXth5uPTLaNnfO17ItmNkacQYkSLWKGWzfpRPcma3jm+bq5yet9VAgOQN
         aH9+j19IFANc3vOhsdDrLW1imvjGItkRrL1cerhX3hvZcDDIVY2UsfZc/up68RxV00V/
         EyfYFL5ZxuSW+PXGopdaALscI4kxuoXCiPTLcW/MR/AO8uqhClr0HFI74tPXRl6bK4/l
         hbbYUSh4/h9Jm3k+OfQHloC6s47wdnUmWZD8YtgEIMHGkZccHd0qzxrmUJiTFc6dyI83
         TC22kGazjsg5JT1nqveeBcRQwr07JhfqK6cZYmuq/X/Bj3SJFr2aBvV7J0Uzr2ufSzOo
         EpNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793387; x=1730398187;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=d6uz6GC1AqCxvLBkEpgoA1jO88FjBi29IOLD0mRFPp6Dhjl346FXPD/bo0jxEKj1wj
         yCxT5qfPnosn6CABZSJfHxP0Lrd+334eggQpKLH7UzKxVszf3k8KusMxqBmpSI5Lu4k6
         wQqMDggz+RgeYVGSiKDNf7YPtiCyEND0qL6BewyiQqF+3KBzgERSW6r1mnomb03BL9kO
         uWVDkO7umUPcoTbCJro1uSTGQXIbYCUd2m1tnjcdzyKQNWTvZacCxX7DuRIU0yQfG0x9
         cfkUF48722DCiwjH2Ha3uZcW9CNBMpY7VcRBViy4K02XHsR3y6v1qoLU/LxDp2OHK/BZ
         2k3w==
X-Gm-Message-State: AOJu0Yzd5L/N0Qt6TDQWwFJzzr474Of2prYIFsJVyJJ1DNZFBI4Fzsju
	URsYYMepTlJFk6X3/j7kSY76QGUJJsKt+PYox5NbkC9WOBm+cI6e
X-Google-Smtp-Source: AGHT+IGmxokXp35bJLLklxk/Se+cAtGIHIR220uHAPa6ZS+AfbClJAxh1tP8P6TKFLizRd6mEwsDhg==
X-Received: by 2002:a2e:be87:0:b0:2fb:3bc0:9c7c with SMTP id 38308e7fff4ca-2fca822ffefmr17934551fa.25.1729793386644;
        Thu, 24 Oct 2024 11:09:46 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2fb9adf845esm14198581fa.85.2024.10.24.11.09.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:43 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:40 +0300
Message-ID: <20241024180940.3282-1-vladimirputin693389@gmail.com>
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
