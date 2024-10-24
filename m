Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8441FF7B7
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793404; cv=none; b=QXcLAdnRKpzYB2GaFVnndx/IUNHVoWvE5ekgVLuskCm7fTCuLinaELpw9SCVX6FsDi8+la6BntnlVTuOHDi4tnvqD9n55rIRh7cQrmrQTxrLTo0H8+bf/97qQnWrRn+SPswjKa7u//PIa5V7JvbFhNImH1kOrDZw8u2GmuiJ6Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793404; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZWzoHNnGuQUE552NxxlHX/wIHXAyeKoVXfTHDP4WZDDPV1naU5URIX9jYiGmAftdwxz6ax6wnppl+4bYat3FqUEi1EvBuqT1tKtX0VUBCGWEy2tHAgjKv+06qwmHKeR1wvycUExv2OJpfbuuBD8/Ef/K5i5RDg4Hjp4KAcIk3uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YWKr2yVL; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YWKr2yVL"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2fb470a8b27so21098271fa.1
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793400; x=1730398200; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=YWKr2yVL4chypPQc/gRY5EWbItO7W8EB6yb3sL6GYaEDL3kgJfPG68nLkc8pvO6p8+
         4hXDMffxMFGJTVAKjzVHYiuV+3ZVn750uV6zwyOntDWL/G9FWATLXoSaxnCnCwby4iSG
         xICW5pFL79CwMcqNDy6B+oZg8UO0FGfogFmpTXbh3CpvQgaICfPNUzQMTs/OP6I5MgJR
         XTOxQkwLlb86b1bKDF2uPEtNKYly2GCEV+K6Jg5JVN6TeXMEmxeZpza1yfac6g0xTfCC
         seBOHug+9ad5uwptXMH/d1ZGkECzLkjxokQksClsO+mBIm+z92ytdgLnuN/ssSooZ1k2
         96kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793400; x=1730398200;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=sU6p50Psu9uZXWPzcUSzlAHUkkXziSuTmZyCZfCxb9+rMB/P34I+xywWnIUHWc7QVh
         mqB8H38X/ooMUe3QrgGEr/orMrCEI4Pud7Gwt/a5ISXapio5E8RddX3zOQq3FLqMcTwB
         sXUbeuyHRVnx41jR7mqkbfLSwlrvI2rHuge+dtIUxQZaufsQUfQql5VdBuiLAjBxVzSm
         vQXUhdlVMXknU5MrOMadnesQmJWvi/L0qAjs8Me6Ib53zExPNJykd1IBERdlcZnVvau1
         gNKTG10OYRcG3C3uTOJ1w4gjQtAlJaMoh/EyOBrkMd8NmXd3UANIOiGTnBzdDKzAZZx0
         LU9w==
X-Gm-Message-State: AOJu0YwLFTkalU5HIgVb4wKdq1S+GfljLL41L5V8kjYOTxuzRYNf7NHO
	VdX92YrEs1FPxysVbJ6XFFMGGIWKFzJrCQbKNA+dODYXtc7G1LcD3ip9ig==
X-Google-Smtp-Source: AGHT+IFymPea+yPSdT9iT8dxciFPgNGSw7HTQJ3+DyLwD8eum7fGUCgmp6oCkp4n6B5MHHylYwQqhQ==
X-Received: by 2002:a2e:a552:0:b0:2fb:4a15:6112 with SMTP id 38308e7fff4ca-2fca83006a0mr11394421fa.4.1729793400130;
        Thu, 24 Oct 2024 11:10:00 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2fb9ae25a9asm14302701fa.135.2024.10.24.11.09.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:59 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:52 +0300
Message-ID: <20241024180952.5521-1-vladimirputin693389@gmail.com>
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
