Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781621FBF50
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793418; cv=none; b=SRhrQNWsQmxOz8LO2Kl9MzCzBrUqqY61jpU5sgUYjpvYgzFkxFdXWMHw+mUMNDvb7MH+enkRzwN8eptKtJHQ7ZgjSU5ds5pBR09UNGu5jn83v2hk/ijcMROj/ANXXfOvdhcluOsqusATxrtk2UhN68lIP34drvEiqnnX1PbZo88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793418; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ec2+XpVp1Eft/ZQSHfjCpPPbRuHPX0MDSwa08sTpBqCM/KoLaqHtq2DuBnnsW14ybIp/PYHNegS0bGPduBUtHsEVP7MOKX4NwFF7VLuS9m+iF0NcMamaQZMqSwuBPaYly9gQ1RkpdjmEn5isRt7H25f7ny6gkJTNWxI+kuV1lMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VvU/VHPD; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VvU/VHPD"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2fb56cb61baso10116081fa.1
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793414; x=1730398214; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=VvU/VHPD3f4MOtod68T1ILaV049TC8gnu3FyNdxbCZHAXx++s/IeBi3Yi3/lrY76hQ
         uLWhug4WEPSc6f74xOq0ezvcMYoAttRb6OVv3fmCqtxX7zwufCVwCfrFHDNaU1C/3t4i
         ckVHODyaIKTiNsm6GQOHvPfUqq6VZrX613o+AYYluqZd/Xx7BYAxK+vtEnM+tiReSG9c
         VwTyMEB5QA9XsXIpqlJDkQPbBsyBDQrn7vwj/pa0jlNSDeV1f6m9Ctt2lE6jYAqxNVKU
         FPFq9YAkj8/R9nkzV1AgXG6t3MCj7597usn7knAzWVozRDL558FHyaOOh3vH+qVa1mJJ
         VDgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793414; x=1730398214;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=DZg3kQFPFj2THbtCDtLatXQlKrGDo6d2wFuMdo702vDOEFyQUI5JJVf27q6zjkYies
         YcAjXVTarRYbvEfN76w1DUlu9xJwwwg61RcZs61nVhIOFWx2PLsPoN9gNLWLJEIX9GQM
         igzAbTpIvWtZk7KQMQGPqMd7kKH5A2wJlD36vVCh2iJRWveNWAyWKkTVQ4hjMyLFfBQQ
         yDICCMXUrrDJ/ZiHf7mCriChxry+ataa0YqZ78EgEtmvF/visFDpbqO13saKNGB+KL4n
         C+DoRqdtdOz/+R7Oq3GYbrQIpU1TEnpEvZCLhqFaRF4M4ZLJNb7NO5BvVgpBFqBViwV/
         77Rw==
X-Gm-Message-State: AOJu0Yyy8vck89OapxT6Y5GspU8wr0dh8DDqXNH2usU2J4RjNBg7vrHu
	I5kpet83XsdaPOZUK2UtZTsCDMYN9u6LKkiwHy41aeDCJ9uBeuJ+
X-Google-Smtp-Source: AGHT+IFesip757Rkfnz9hSKaSgVUcp9Dgco7mQML6bExrU5D+cTd81CD6z1nUIMu7QC/gLZUQ4udIA==
X-Received: by 2002:a2e:f11:0:b0:2fb:6277:71d0 with SMTP id 38308e7fff4ca-2fc9d365e3dmr34734151fa.22.1729793414401;
        Thu, 24 Oct 2024 11:10:14 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2fb9ae12187sm14556001fa.114.2024.10.24.11.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:14 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:10:03 +0300
Message-ID: <20241024181003.7274-1-vladimirputin693389@gmail.com>
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
