Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C875E1FF7DA
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793405; cv=none; b=TIa1n3BxxSJ04i4RDrpf/2EKIs297e457jz5qDuTt7QzQuwZ9cVwduANHgzGsT+SThgarv6n1ugbceK8fqccXmYESRCmfoIKusIl7l7Oz4rlT9a/oicFLJZ81iVo0GQU9xs+we6I9bUJPPP5Bak6Z8Q/Cswb+Qdm4vcOZrl5Fbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793405; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JNooTQDu29uk3gSIajUlVhzxvThZJGf/kqop9xr3pzDeoLHsnUbsMpZ/M+F3r62QIGC7Q+GhgsEfIKW1aLhb91pe3RV81jWQ0/Z+il5x/x576H/LA3gF1UIAcNu+YRof59VboNTQBg4rxQ26c0qeTsSJNfxgOqmoTWmr5iwdwug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mQQtqKP8; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mQQtqKP8"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-539eb97f26aso1277319e87.2
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793402; x=1730398202; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=mQQtqKP8yS4u9gxIlf53oQezzSM2xHGQeePueh1hWQC2CB/oT0XQQ/zxvc556IvOxq
         vm1UrnU8idMHheYWLbBSio0FK2ZI0A7+k0Ojp2mFmzlYMUxpIsI1cClip964BEZss0Ir
         OWBOqImrVyxf863ACdy+BKDS3zNo+tUIPhAKlifLfk0xAhCl0om9s/YRylU0ys8h9Kv7
         yfPsZ8BHm3lps0quimzbq3pn7alA1crt3KZMLD2rgjtHf6qqP2RqYwUsxtD7Vl8d2kHk
         QfCyM01pHJ5rbAnKxipaDEv+1FdrrdmByiyexj9DAKpK3vXsw+3ZsO6s1r4uBIYsuBLO
         2yeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793402; x=1730398202;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=EXN7Mz2ofjaKi9md+4WZpOIRnaHMDDgqN+Ew46r+MM8hKXB6GTvuEkahvdCVu2tojl
         fmxpLf/SETMHlS2dPKK6boaMiQghMzmpl7Ul+S5bnS/OgQfajBbc3zcPDGtxSdgh4mZP
         ir0h6lB8+/TvuDenQluU+528vDl7So7wl0qosm2ie4f5qGqvQiEoR+8I5CiywmfNwFb0
         ZS6p4rKXcUzob0y12cuLBc6RJZJLKU//O7jDQO34hq99XRT4HEa4+p3NRCQ+6WheAhKD
         amNBWfYp6JpNDaVGZah9hADFvzf3gSEK4FZIz4tsbQxHmBOsANCyWJ0UqGMMTYGbhaeK
         Ivkw==
X-Gm-Message-State: AOJu0Yxcfaa2O1J59qLB33FbWi1pFseo39DtVBd/IKMRCGwe44g3OD8+
	lpiBU97PmM8usVRKoqbHhWQYU6uyKLd5O5gZHrOZI0QUj8ootqP/+IYI1zFK
X-Google-Smtp-Source: AGHT+IF9fRe4rnCefkg6yMPfpQSHHEeglTaHU5U5uUdOwyE+rRLzscp4TtFyeRZq8atinmfCLZ6gZw==
X-Received: by 2002:a05:6512:398a:b0:539:f2f6:c70f with SMTP id 2adb3069b0e04-53b1a2fed80mr3877550e87.8.1729793401875;
        Thu, 24 Oct 2024 11:10:01 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a2242030csm1429412e87.139.2024.10.24.11.09.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:57 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:49 +0300
Message-ID: <20241024180949.5189-1-vladimirputin693389@gmail.com>
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
