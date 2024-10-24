Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE461F5831
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793414; cv=none; b=ubVelkHqqDNrfB+ke6MBs+C1TUJ1Bs23WwK9LMCqpTxf4Wjv8ebsauQHs6sEif+pme3yG+MAoj51Pah1dspy5UtMPLeJ21m5ue7PrLIfKACYTJ5uO5d9EGAUn51NQY4VcJEqXoBBuJ3uYl1NWcoJg1dGyRuX1KJny91i02GLKaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793414; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=riy27unnypsuFibfsolk0CL4+eeqpqLiqFLW+feDpMGfJIEeBq7vRUjoHAH1zGoJzD7rcvr2NZ7TwyXIOpzDs/K6GDxAgBysGebc7TYCNmAqk2u5HOV27v6F/KP1A9qyk6X69E/JTBSzyAlL81zY80zOE3+5yaeH0muqSSuoyN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EdgwaXe5; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EdgwaXe5"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2fb5111747cso12772451fa.2
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793410; x=1730398210; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=EdgwaXe5wbYRaoAE9hdDbQ+FH9KVL7mlaZfdCrxaS8s9flttNwTh9KUb18podbnGyj
         vYExFo6FGGdmy1Zq6GxupHT5gEXahBIwB3AwFVHv6aYfcEriQfj7HKKRHl59+n4Qn7Vx
         y9tvb1vMp2q62Hlj1xkspuMe6wZMRpKqiUQm6U/DE1xSzs5CgBO8ffmMYgvgj0KdvQ66
         DXJ8s6QYhN826bdWPkXg/t9BhKGK7OszePUe9+HVkYdvqPFcbgIN6DDxKyN5S4MWtNbQ
         +uAzRlV03tYQOhUSGkQ6jM3GXDHqeKHcXdeT6aNo6wBH8FRAZAtuydL3whLGHILJuAKt
         1mQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793410; x=1730398210;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=O3vi5W9Hq5V/acGN4mAkA8CjimA9pyLfI0CFe2vQNSj1pVBHWVXEDkp5LMyvzqkvg/
         B2mKfYazrRLucXSjFkilowb4Bo0u7df2+C3fK396BdVFmh/mHvDu8wQiTEYfPqkex5l0
         O/nVAp1rmAgX2//rBcyCa2HopeaPDc/JEgEUj0jBMT+Yez77Pn42LrY/YLpSuewMjy4U
         SxOVcngqd1AuWW05iItVuZNkO6ZC40wrmFGPVr2xYCw4WrdTmUNshRzwW9s1dxVXnCoH
         dyEeb6xkpY8vicWQ4n7XqWaVUT7pi8T3RGtVI7J4/74uTUfrbmqoRXortEiq2nkPeurC
         biUA==
X-Gm-Message-State: AOJu0YzWzxsDAdQm+qejLVBoana+euWdnEWk3dPAVqknvgu7f/Ffd8X9
	Wu7Ex7Dz+vJMct2c5zj7c+Y46686ZlEHJd1aFbVrvJ3Cmkvn9jZJ
X-Google-Smtp-Source: AGHT+IGiQEx6Es2ZsgKd/BCB+dJallo3wSZVeEbjLp6ICwCd9IWspQ0qlb8j8/8to6U4lWLPZ0Dj3w==
X-Received: by 2002:a2e:a9a6:0:b0:2fb:57b7:5cd with SMTP id 38308e7fff4ca-2fc9d32e466mr44489821fa.7.1729793410089;
        Thu, 24 Oct 2024 11:10:10 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2fb9ad7624csm14306431fa.53.2024.10.24.11.10.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:09 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:10:00 +0300
Message-ID: <20241024181000.6953-1-vladimirputin693389@gmail.com>
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
