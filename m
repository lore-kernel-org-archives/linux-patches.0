Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953D5200105
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793408; cv=none; b=VAH27H9du7TD8DEGBj/FOOHMn+Xe1Tl0L3yORewNIorynOxCStbbEz5lRZK+J4/jGsfDlKH3GYkIMf7aU/KptmFZZqmm0dVV/55Sh8ed1BzE3BE+NM55EkMS7ck6kVrsVR8iM1UqK+BgN8CSX2/CaGv23kX0vH9mB8xYKQ3gv9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793408; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JRISI+LsXPbVJ4Rd2L3OfgAQWpHvB4tyuofSE/ZArUL9RK5OWpb1Yr9hUwQozPLt/+MRUjAKWXHW5voicPsE2HNwVeFwlhKoAk06CMkWdjMc1c1BzG5sJX6VcTozZAjDwZMhiA0f5YADW6L7J/dFDGcODCp92186/iGEV49qPwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cHU+J+ZX; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cHU+J+ZX"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-539983beb19so1638595e87.3
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793405; x=1730398205; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=cHU+J+ZXr2i0Znhc02oj9lXxXE2qYpAPLLuH9xlKl6Y9qQz3diZU0ETJJgk0QK4uQP
         mrF6EOBxKY1gV4usLSasoiHWylRGzVRiZGYn+XKu/NrHiJPd4dKQ5V3UpVBCXI/n3dT5
         R9P5bCZv/Lv8+j2wna2SPtsDtxUIriM8BX2Pzzrp+ylNNQiXSfvmnndBK/EBATmGnJOB
         grNvXEjirhINX/7hWs9yi6V0oNCxz5VZLTVeucyTvYlVZ2l3V6XEB4KqD1bpskNRa0oP
         B5HENA0+yP0lSRMYZB+w+R4suQIf+HWLXglAxW+ewRsFXDPjHM0Mk7a7UGIf90b2jJZX
         NK0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793405; x=1730398205;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=Pq9uXLIaqZCV/GKR5TkyKyD5p134pONNZEz8rLiYkQw+RJcSu8WWzAPExNv8VeM7HD
         t47Rb7AdRPvhWm4WS9ObpGOl8558F+xba4GIDPIxEJjP4TizB3PENn6svBXdMa/+x6Qa
         33wDwdOtuSshL+/Jj78u2F6ZTML2jX9+CbSMvnFzMECPMf9SUkfwmIRelU4vVSSw4djk
         4RNtLQ3++UpbRtKjEx/+lJnh5kQWwgRdXq0Jz5yrJpXAzZGrD0/C1tfEnSuXd+RJVeHk
         B17roUeA3pFahDym9iRQ6wqWgtISaeuUxqh27nhYzarLF+5B6i97JbOV1CYkLXe5uuBy
         2xHQ==
X-Gm-Message-State: AOJu0YwBpJSSFLHSaGig5ewdSZbfN0EPY4jeMv+2+Dv4rjTcw+W6BmGp
	AeiCE/lZ7CE9a/05uewtmnBmjWPQBgK5Esl/G4HejuCCOvYm8P1y
X-Google-Smtp-Source: AGHT+IGrN6ms3pQqhya4KcF/zs3OCnMQ0qMgkDPjETwrTR/EVNxm/gLrAmk/tFrZ/zH+3i71OCfnVA==
X-Received: by 2002:a05:6512:124f:b0:539:de9c:c8a4 with SMTP id 2adb3069b0e04-53b1a3199damr4423660e87.24.1729793404656;
        Thu, 24 Oct 2024 11:10:04 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a223f01b5sm1424668e87.107.2024.10.24.11.09.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:04 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:54 +0300
Message-ID: <20241024180954.5968-1-vladimirputin693389@gmail.com>
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
