Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135E02003D0
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793391; cv=none; b=fljgNrhusGnycKTtJvsrcCa+eeXsOCQ4i7q2xHYGd4E9sERAfyGERubDQRRreIrniuRzm2AS7guvOzPdVitOfCOqpkXbpawn4EFPfVnLqzdlfD6v7WNJOFXDK1+j1VVv7PKCq+WW+fed8Rkyq1SAUavJZJPvJlKEyVTYPC4Iuek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793391; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GnqGsH2GcHWSzijoBStKGE+vjxPVXHVpK+qXm6NhjWCChCuZ19GkAdhKX2FTRns2qWMWcdHQ63T7PS0Rt+Dzo6g4vvdJH1c90xYRNh9hU9leirGBn4+C6UGBDGOVUz+6K5uzdKtCNC0fxBz6tYQbzLLclyrYKT6jOY2+Yv/rTE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MWbQ69Ps; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MWbQ69Ps"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2fb5740a03bso13770591fa.1
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793387; x=1730398187; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=MWbQ69PsEhE7uUk80+P6Lz/MV6UyKqs2F8g7tMZY5e1r8jBbauq4zqSccO3QtYXVnX
         Ch9nen5usm+eYPZAfzqQiAfOHbjqDqLYFcPF+0R3N7WppJMwICQo9ETgw2LHZVYZwzBi
         oQMoUIjgzi/uG57vJ1RQkMPWMBMXxrIRs7oVbXVeulu1gcna+RL6sGRYxoH0DE63r8ry
         8pnBFYaRkdtF9tcAj8BEGmu/SED8G/Euo75YQ4eSqeyQBJslyZtAs4bxOwBeiGqZtSWB
         jZ2fhjOc+oQGHlK9UmmPZdh2WULdaVxG/QM5igQrvyghYkQ0XKaun7FUARF4IJ/zgOO2
         o/pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793387; x=1730398187;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=wvPfS3xKoFozbCKuVlz0pdBCiGgThGUMZZsDUYWFmRBE8HroK+uLR/XlYOJBRDjgLV
         ZPubIV9fqfz3hGnO7woMO4IFgKBfYGBKp7dtjxdQ+7R0CsjJoBnf3gcN103dyBRaGApy
         M3x66xb+FKhBYeVXYAHJy559sTfaW/ZndL/Th6QCiDeOT4GhjlHgFfiDfsWkWEK6xG1K
         GQ8r0EK9FlMrlA7d/7HD6lT7Z5Sv5O9MNYPJXKuxtKaALKDBp4gnI6s5qbc8CVY6EUJt
         +sQ9sC6TeF0vrRsdnjqNC3zmNaYBxnzjy1J+5D6oJi4gkAtW3u2LsT35AF4xNtuZIOWa
         HAHA==
X-Gm-Message-State: AOJu0YwWMeURkWgiPi/cEsCU6ezBMBs9zOFNADaffhLvJr9pu+gJ/0yo
	OXuwvY/hh0pLjXZ58nsvG/r5hyqwhGVf0QOsdieYg4PdwspF7s8Z
X-Google-Smtp-Source: AGHT+IHupNTqVuJFvrmuqgiTPs8tsuUiAgzEYNUXSDbMIrQwfbrsvfQD+Us6PqVkByb/NUlgVamtzg==
X-Received: by 2002:a05:651c:211a:b0:2fb:5786:251f with SMTP id 38308e7fff4ca-2fc9d608159mr39245311fa.37.1729793387037;
        Thu, 24 Oct 2024 11:09:47 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2fb9adf84b3sm14573761fa.84.2024.10.24.11.09.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:46 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:41 +0300
Message-ID: <20241024180941.3312-1-vladimirputin693389@gmail.com>
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
