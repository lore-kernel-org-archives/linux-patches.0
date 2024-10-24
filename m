Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42FC91FC7F6
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793395; cv=none; b=gUIwd3ZahbFyGEBYOQUy62Ojd42i31UvCSJg0ZOqIK4w4y9oRxbW8bCI0HJXky3KuCslC4S3+/nEVTO0S2JMXli8JYtkkBtKTiP1k9TBWjGFav3sw3dkDRmt9JT2rC1D606nEC/7e3HYvEc+ZNKYIwRRFz/X2LxUnGP57NxzUHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793395; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ioov+Ia+maccFNsB/SON+2x+FWnWbyUhSGS/+0lgTGjXp1h2HRzv3+52MTkRkRNloAaziDSRGnL7g+6n0UkHgjJtgfO34Bj9RMD/lyevsKIAnMrjPZvTY3qs9HY2iZ3iIxCICrR0t36+pXSCJPp6HPIRkOKKlDe9jc1f5CJ7SIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=df2rkHSl; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="df2rkHSl"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2fb3da341c9so14067301fa.2
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793391; x=1730398191; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=df2rkHSl6xcLu23TyeIOYi/gtQ17eJDrMxDnReg0s+WIpKPiaQCv68OxzO0BWtzPZH
         gs/soh4HcbRdM0hIxIEkViBiqreZVziDJ8pI7YwMkXtoTla/FFw1MNvtN+nQ//SyvWhP
         DzfUg/+wWn0zJUN7qpZ9lZdQ4SYzXTDN07cyXIl4RBvElvpT3wZ9hDkwo3K9n5N3JK+9
         dDlhmkO8opoGlFTaZrcwpTrFHnHmfFiIrbY5A8mgtJxBAn1CBoTu1wuSb1ftJdwLgcR0
         430SN/ymMKhqL2DcuSuK52vQQAxl9d7CpHZxWS8dK6mCKnpQxJrC9Hy4/mFzFaftup5g
         ZDEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793391; x=1730398191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=HTui4gduXnfHhLHzJfGdIlZvB2tj43Ce+uAdJltNinM9Tdv7MjHtagMQVf+wOd6RqB
         igji8M87nFruLHnVuoUGMzuqk8UwT7hN9jpG7gN7SPkrNuPzBTJNy9UPsTUWaq1Yx4bg
         4ph16rcbd4xIJpddmIRgmLg6+rzQOULpBhF4ntP0hBYxtPQUyKpndvO0fOmkg8nYHotF
         FIgKPnCwv9e0q9m+neBqEE3a6JWXai46Bs6u24m41jgAqR+HYcLr/iYUpq21qvTN9EKY
         7sy55o+EqAePC3Xbp2ifJM7AwQwM8lCdwQ/DMcXWTJpXBICw4zp4mVKIVWlspyIOUcXZ
         k3cg==
X-Gm-Message-State: AOJu0YyJsExpZHHoKScbh927+bj9uq5ZPRTQJaHOU4x09xW1xo21Ck7y
	sxUGaeSdqhzIeyjDi/KVBUdyMxmXcaZm0ZQBHYHdJp+62b5ti5lsxZql1A==
X-Google-Smtp-Source: AGHT+IFt0xotZcxFMlAjXBVp2HNBHdzLIbGS58T2djPKIpVaOCkmFdCLni6OwIHIes1d0YXyVfj6bw==
X-Received: by 2002:a2e:be1d:0:b0:2f7:4cf1:d6b1 with SMTP id 38308e7fff4ca-2fc9d2e5292mr44685191fa.1.1729793391121;
        Thu, 24 Oct 2024 11:09:51 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2fb9ae12072sm14766761fa.110.2024.10.24.11.09.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:50 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:42 +0300
Message-ID: <20241024180942.3618-1-vladimirputin693389@gmail.com>
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
