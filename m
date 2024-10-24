Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15382003DC
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793392; cv=none; b=EWY7Ate044E3wt/2Ca9R34ojGlGo+NyOJPFe80qWli+x0joN/sXziGOH1tYi/u11Qp7q5bTvjBtA5ifZdYbCrA1QKgX2GvEDS3d2M4NHJM5BSuf+cUgj2745/OlcTnDiei8oW+tpLr2CyfR42p0O8e10IqTzc7fF5hNKOdTvCBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793392; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U1htihN43iVoJopDiZy4pHLN9jQ+6EMzu+kEfCM2sSGyTOjevPmWisspVPR6ARpz6u47u2mbhUAUpdfCBdb9dmn9hzz/YZMiTeUiDdAyUqlJuHHSUPEyuhOBPVarwEYT0WnpiU3SnCbj3/S0rL1r9TNJ3Pu54Lf468xHViC2c+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MUe/y4px; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MUe/y4px"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-539e63c8678so1373443e87.0
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793388; x=1730398188; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=MUe/y4pxaWYdhPjYA43C0K3lbYg6nMkJT+3MjhDKDjIgJUTGdno0fCpwi199CEUwy7
         cH9YWjMiFmIYyNl9Ov9/nLBaLXK4jJ1O1HN8fUv+fQ3cfIsrcNegPPUevQGM78mwXejq
         Ng49wyNCEVMu0nR9IM/laHCFXFfbTXMON3dHBIvJ9SSnfc13zScknGjzJ+vxEA/zeVrz
         IUobIM7AbfsmwYbwgpAOkNGkNcfJg76xcIsrqYCCOdd4ZJDbQmous7/ZVWWJfP5V18p7
         nZ8diQuGbrdh0G/j1+fqVPvlNP9bv8PGCV+/eeX4G1ZyT4TKN3e8/mPfnVdJOeR2dsIt
         aQfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793388; x=1730398188;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=r6qN1zpX7w7zfhhrhqXACBxGLxmPo2t/YLH/QH2RvUfqoOKdXxWNjaoKfuRbmDLRc+
         9kTDKs+lAjIQjM8ZgppQnsG+idsBTmUHRB9423pDXN6zBIvMUWjzh8P2yWrpc+iL536Q
         li159UH3HJK8S59rTMnh+9yUb3ZzGX3+1gnWw6gEd2ibJjzOQPfQw+jWYwv2fEksnz5m
         d64yNUPKz74LZrcjHiAUD2OMfFe3O9fLiIWw/+6mX6cQbZPsMEHRU9uLB2dRu84nVO8B
         hEuj1ieIoM0yjaIjOJ0HCpbvUviIa/7B9BAiMi7qwjj9at+Us00npp7vRF9DTZHy+Ias
         ONXA==
X-Gm-Message-State: AOJu0YwwsToVY/RNSOOLgHNJ+nELU4lSgsJz3rnJUU6XFynxCFUMeCdf
	cMeQYYka/A2mAKKlYZqXf+7iJKhIGu4uhD40VtCbHVItaePeD8C5
X-Google-Smtp-Source: AGHT+IGbVHzdpoj8MIIzfP8+f8i+4moB92ZhDmH17HIuH4fVPvuTpVg8umbA0JLA6qetbqsiY+TPRA==
X-Received: by 2002:a05:6512:3185:b0:536:a533:c03a with SMTP id 2adb3069b0e04-53b1a3069bfmr3934310e87.17.1729793387694;
        Thu, 24 Oct 2024 11:09:47 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a223e558csm1419280e87.7.2024.10.24.11.09.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:47 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:42 +0300
Message-ID: <20241024180942.3657-1-vladimirputin693389@gmail.com>
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
