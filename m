Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435A81FF7D1
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793414; cv=none; b=S6uvj5YYI3jFIqZEqxMijI+QXAF7uUzO5USNXt4F8EQmPCP9rj64jlqkVbKsmq2glJ+8bEk2/id0J9xSoRAxmEuXcNY13yRL2XQeJhH+cHbQpZRLK+neJhWZVcSr9sFYGyuBsCG+Pq31i6G2ywPMlE2mgwvsmv3v5QAYpby2uhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793414; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iK2jc8HvVisbZe8b3U1wAZHQKq0SAkVY9TC5v2NY0bYaI0QeE12o2Gbt4h7M1m7AC1OtS6LLFtEF4gBDw3TTR73/krvU2JhnTqYJ2Tprhs30Ft/W/bccKAs++RRicBZ38PSDKAyMv44B5htqxvdZ64pKaNbiEASqmcoYQTUhV9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i+J6Tft+; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i+J6Tft+"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-539fbe22ac0so1525543e87.2
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793410; x=1730398210; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=i+J6Tft+wKlyDxaOAH63yKLMUCVxOwbyC+gf0x7lAAfHJ3FDQT5xLH6ZJt6stufP1o
         h4tPI9Ymru+sXjBCBojn43XSD636KZL4QEMs6L92ikcbERCPrBntA1OuiipWxJ0CbZ2Z
         nq/dEiAVTD9IVuD4XEjlPvE+x93yd1WDkaEDkWJJIhxjjeGVqpIBLtq0ZNeSK3BuD0n9
         QAntwyNLb3zT34VKuy+pc5rgzuENNfB1Nm1L7HLPQ2trKgwKTcDS1bNZUATg/laPCLyD
         SYlWR3zYm7WhWae9V9b4ijvTzQviDWT5+mOsLHkdQMz68kkXlOOfPpKgSXig3oOtza2t
         BKpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793410; x=1730398210;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=XPutEOE55lFKTj/XRQk/sMaoAAvcujSrVRnG5YVyndz+iC4V4BHE5sbIwQetaxAbS9
         UaM1iaX0erhJRWdqXy4z4MDKvUbGJ+ATRdr0PdGv2WbMi5nqbX2Ujbd70LnQVX+juYsn
         NXu5EDfF04S/+Jk26B7Gj4RY8DNex8kA6t53mz2IT9RMrxGYOiCmMm4DTJ4OokwgIQPX
         sYOmEiw0sZ15qkHmBln9BFsh5DnEN3ZuAbVsbTnZ9Joz1ajwx0XwddjOY+b1sI911US1
         sM0LbIbcd+goj0+GIPGTY/TNbwpMFQ9k/osoLTxoCX92NRUK6KClwncZ++fN2qgQJTk5
         Q+fw==
X-Gm-Message-State: AOJu0YzWk8Vpx7Dkxck3uWaSa5cEQzHuAOA4LXtxg4MNElAGvZp69q2O
	7nOvE1CLu+8pJgm6yLdQ3KCNGYQPdroRWnP+6OfOAbmax/TBQwk9
X-Google-Smtp-Source: AGHT+IEdsLkHLdSmlm4c3ueovspZOuEM9Ji4N5V9zwzWbfXDu8AKdNES1y/TqKkwAqteimmhyV9cZg==
X-Received: by 2002:a05:6512:3c8e:b0:533:3fc8:43ee with SMTP id 2adb3069b0e04-53b23de791cmr2111791e87.13.1729793410167;
        Thu, 24 Oct 2024 11:10:10 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a223e563esm1422942e87.25.2024.10.24.11.10.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:10 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:10:02 +0300
Message-ID: <20241024181002.7168-1-vladimirputin693389@gmail.com>
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
