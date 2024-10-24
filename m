Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8D51FC7D7
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793412; cv=none; b=TILbveCSR4kS97gPjnHcaSJ2h5+MHPOiVu5TXab7haiw/qAYayNOhaSONoqDTNxU2fB42ZiwaA+4+LG/eR/hrEn0+L2SQ/jtCWRQU7Dyc6X9fICjze7aYauGjfGa5zkbvrW9pg83HD01L0IX6dQrWKP5HdmiRYgygv4IOMRCEGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793412; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o+MRv6uz1pEC2qf/q67/PwukW02EkrZR3Jfz13ZXGCswuYYeUDKZn98Kf8Tj7IUBegboEweoBWFxV4v5K23NNPWrhj/HlPpMDra0H1VbuCHJ0ACEllzIyYDdt0q3CZ6fK/vjcIG548SPjcpBRKG6GpBbsxjzUU0m3A4sILiOR/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TnFUAATA; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TnFUAATA"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2fb599aac99so13095061fa.1
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793409; x=1730398209; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=TnFUAATAUzKJ3YcbHR0Uly3+d6upOfJ9j+2kkn3H/pkY7OxtC9Mx6izsfLCm/t8JN9
         /sNhVHAqZj5bOLA6fCmMPQy3FT+6wjnqBWDV74yWIVQe9486FhSEkTf99uEJrAG+HgWn
         cS5klyFwmQ9wIjGIoIh3b25MO8RvzgfnO+HjKab7B6t6Xz71NtjSQsiQTHSTrRkc22pv
         K1vyYYtLx97z5b0yCOd6t0FWAxCCXE3f7T7GIjdLPzlWf2XHJvalpD9sF9rLuz6ZgEbA
         vYIQh7/tJ52K2gp3UIZqjvkNjLrFhGDTUce8J23xTqHtabmCl5slW7Kh8KJGxCph89uc
         XKow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793409; x=1730398209;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=Z6ZO7dTHlFLUi+ZqelFOgxOXPms2/mYlp2C3GeEJ4s7Qcw9BpF9HN/GOBFIHnG/cyd
         eCvqIlo3Pyq0sCLR26GQuo7N4+ND9LiccvoZraZZ17KdxfnDys5NhIiim3MPTiKPcnwr
         Qyv4vGEBNViRi8Iix/gLW/0kToJWdctObiOUTAVrOXr15oaFcFfnLo/RMA/fXBYbMy9n
         rZ9Eshwe8UHO4CsgwxQ097YUbt8skecgfPVLkqe33kcypvsKbptZEAPiNvNify8BxcR8
         NM+5oAc2X4BlZO+NsP4I9vUSGV1DYsEqtcmbcbRnJQpo2tfdAmScSfe8NEPUdyBDXG5h
         EmNw==
X-Gm-Message-State: AOJu0YxVSdq1KnjUtHHbFrvvYURlnJp7bvcXbDTvkY/bfNIxxiPJ4IY0
	ah9IG0mD7MLdyhwUGJn4GKZ+cb83qVjdYfMgq84mw/b7JpBdcOdW
X-Google-Smtp-Source: AGHT+IEqWLSHzFfOAEOhrtI6HX9Ncu2LWBCWNlQuCCKS5CJ0SUFhQUVYeorWa+vX3mofyHLOLgvUdg==
X-Received: by 2002:a05:6512:124f:b0:536:741a:6bad with SMTP id 2adb3069b0e04-53b1a2f2943mr4227163e87.12.1729793408863;
        Thu, 24 Oct 2024 11:10:08 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a22420110sm1434023e87.143.2024.10.24.11.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:08 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:54 +0300
Message-ID: <20241024180954.6070-1-vladimirputin693389@gmail.com>
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
