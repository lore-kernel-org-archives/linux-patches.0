Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1231182C82
	for <patches@lists.linux.dev>; Tue, 14 May 2024 22:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715727140; cv=none; b=JaBKG92QVp8EBrr/tZlflIOo1THllVxcuAIIVJeDxxErLO7LKhA/v5AJOGjsL9CCVq+YVvicHvHHcoNBoaHfAARfuEDjpho1hIGIvZkyjWw93Bx4wvUo04BYi4IZMceO0gSYuFo1wHUSVVVZMf5NNl+bQ7A43aFvKkk2PXEjOd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715727140; c=relaxed/simple;
	bh=0qQ/sc8ONfKMIFEbDmEeKbk7hGENEC1CjPvuVVbodHY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ftu/cLOp38wzRaGSURpssoSMdmMLFRDgKQ3B9Y+EarKbG6NLbfkS92B8OPdj7rA5P9J9QOLJGOBBe5+fB8qRP6WxU9duYaG3ENfGuVmblRC3ygtJj+RYAPuAg2sThgfWn9AkNULesl89GglJNtnFFZI4Xtpd+gcAzWHxL8pEwjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=ifKkAq4n; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ifKkAq4n"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1f05b669b6cso34172985ad.3
        for <patches@lists.linux.dev>; Tue, 14 May 2024 15:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1715727137; x=1716331937; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=doHLoOzkV1dAkjUvPPZHC9iFmwa5zDfo9zpyMOeSinc=;
        b=ifKkAq4nezh5Wl6isLspN6/96mMi3nccYO1KUmeHCB43qAqJfYQBOCrD+QLZgWmEQ9
         Bx3uh7+8Xj7rYPvvBTBFymG6kfE4jwBEQeMGZALdDgby6jV+e+2ao3pgICFGIeJn2fIO
         1dE1gJ+jyCZDLL2GISln+I8rWrZdN8jpZ2thk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715727137; x=1716331937;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=doHLoOzkV1dAkjUvPPZHC9iFmwa5zDfo9zpyMOeSinc=;
        b=HRwM//QH3wUH4luZDl6vYgxM9q6dc//aUNhj84n/QdPiYSfUQmEqiWfJWZ2RWOJXbA
         5EsS2jds089qq+s5O/Nm4kaK6AeZE11SKcoVGpMm9X8LNmdTja5Fe4cLyIaafYT5mXbb
         O0hd5/5/3qevscSJCg0+5XN0UA9CcHH8wp10A6P48YgrwYOZPSv8QSvcfOE1pcs0tYKS
         likdDVDlk8ZDEdw1TVJqIFtIAKCZj+/1BFsBqd2cqoAnHyxqtib0a/4goxs1UXYM5miM
         2bTk+MWGXoFY52HE6zQ0C664FI0j7xGfXnWNlIWTF380ZpQxkb5Gg7Qs8XTLeox+SyKd
         59Qw==
X-Forwarded-Encrypted: i=1; AJvYcCVoWM67EG6Y66+muwN3RxJTxMmncsYv9szvE8EjTvKXazJOn+iGsZuIi+NiluNXeRkTHzzX/yVz5XaJWSM46/Von7XyjgIS0w==
X-Gm-Message-State: AOJu0Yxm8LBrGf6yT7UcWzx50zjHh/HtCapzzxLmIZbnrJ/q6TAiD0JZ
	O9D1p+8OSp9VwMPCpNR0ngZaMszVZf/1mRNRfc2phMd6iaCrf27yWTZlt1XgMQ==
X-Google-Smtp-Source: AGHT+IHWpFc8GRFfiX7fNqiCpm4+31CydC2UjP1SeqwBmoKCvpRAbRtb3mlF4Yocsg9frEgmjAbqMA==
X-Received: by 2002:a17:902:8f94:b0:1e3:c610:597d with SMTP id d9443c01a7336-1ef44057ca0mr125104875ad.60.1715727136930;
        Tue, 14 May 2024 15:52:16 -0700 (PDT)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ef0bad886csm103974935ad.70.2024.05.14.15.52.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 May 2024 15:52:16 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E . Hallyn" <serge@hallyn.com>,
	Stephen Boyd <swboyd@chromium.org>
Cc: Kees Cook <keescook@chromium.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-security-module@vger.kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH] loadpin: Prevent SECURITY_LOADPIN_ENFORCE=y without module decompression
Date: Tue, 14 May 2024 15:52:13 -0700
Message-Id: <171572713190.2793228.3146950773342970247.b4-ty@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240514224839.2526112-1-swboyd@chromium.org>
References: <20240514224839.2526112-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 14 May 2024 15:48:38 -0700, Stephen Boyd wrote:
> If modules are built compressed, and LoadPin is enforcing by default, we
> must have in-kernel module decompression enabled (MODULE_DECOMPRESS).
> Modules will fail to load without decompression built into the kernel
> because they'll be blocked by LoadPin. Add a depends on clause to
> prevent this combination.
> 
> 
> [...]

Applied to for-next/hardening, thanks!

[1/1] loadpin: Prevent SECURITY_LOADPIN_ENFORCE=y without module decompression
      https://git.kernel.org/kees/c/bc9316c14441

Take care,

-- 
Kees Cook

