Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03800200111
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793409; cv=none; b=U/A1HZ+mjajbGOly72xs+NwRjc6Tpw5ajrAjf5AG2Hi/K1FsRQsbR1u36lC7oc7HoRpS5TKchN8Sa/ipvdBdKVEd+nL/7jeQSNFq88iHHQpboV7QOndJylRkBnwavuc3mUi4DsaXnN+vjxt7ii/wmT5gsAvDaUKWIzGZmsfUElE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793409; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e7A/E8jnR7crFwg80uR3dfMOJdp+YWKU6foBi1TwhcfhBlev3AhQZL/SAmE1/v7a+hZZ8BqsI61uXceX1z/Zwk4g9mw3cC8QATE5m26rSooPq/kf7CS6WCkUHF6gY3XnxfDH3Uc2sg5SNR4pXdb534PGpx766u0mrzTAiMcBhnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P6utq1vR; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P6utq1vR"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2fabb837ddbso19652421fa.1
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793405; x=1730398205; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=P6utq1vRNvfycjn57Kz7+2eTHZWICM18Q4MudQtqt2ShriqoCjqLn9zz2+/gGimmdt
         /txyujRi5hI3ZQVJdK5aAKXo0VISnLFcrBEpEvqlIOqxy67FgGnLf5EBCBdly9Q8jbP8
         FR+bPMg1gyARemwSaEPB0dT4uPyNhu6KfzVvB/+EEYcMB8FunQkhWjodlSr2Bq15YZhq
         iNxK31gLtbqmwGU9CXpbp87vrxT9s4rIIIeTXdEWUlfS5HaH0J/dOo1y0Ramsg7EuqoQ
         7A17BwbPgj85/dmfM8FhGJDv/vS10ORq9srWA0TPjY5BsDPa/8Jb+L5wtrMlOffGgi0m
         14Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793405; x=1730398205;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=Jg3+Hp8axS6YhxVJVw3UjQ2AaabqqBSHmfRjvjeReUtzAwzz9SiJzg3Asn0ztv1npT
         KHtWMGYM1f8fHoiLmR7SDzIRCujapezUL4biiqRLHr/hLnfQ5Qu8HfAojvadclBhkWcF
         r+c6OqDMWZGYCliGp9CJwDu5IqA8WCYzoHZdssVJgX5zRnLWFlP68F7J2JO/1FHwSk1k
         R4as6MfLx6zBu/Vy69TuYGa2nziGHncGdu36BEKRD5W/xSIZlfXR7twAbicl8wphizGN
         08iHSgLzOaqpvXem4IAsgUASSbA8UEyCurC1mhM8dQc8cIEYdXU06P5sEZBPoN724DdA
         GnSw==
X-Gm-Message-State: AOJu0YykbePGjj57KFm0IoXQjrD6HZft4W5gIKxtGK0xOQ/R0iWR2Z/7
	YtJsMazYDsnJDfTlTED/Zb17LlqrRdJW0pPmimLT9CQ8kbJ8X6eYLO+CGQ==
X-Google-Smtp-Source: AGHT+IFx0PFVYyV+UUEXVymZOHZeppzHoxLYC2Sf1psswUKbpXrgW2p1KC2FlhqDVJA2p5I62IcxRg==
X-Received: by 2002:a2e:511a:0:b0:2fb:60d8:7422 with SMTP id 38308e7fff4ca-2fc9d5857femr47435501fa.42.1729793404765;
        Thu, 24 Oct 2024 11:10:04 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2fb9ad907a2sm14354651fa.71.2024.10.24.11.10.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:04 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:58 +0300
Message-ID: <20241024180958.6562-1-vladimirputin693389@gmail.com>
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
