Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE068155308
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793403; cv=none; b=VTBh9mzKWu+PyfUNxN9sTu7Xy25LMnyO18S7hTmTPLKKyEsX+H5iGiATlzi7+8t0Q0e6/DzxKesq/fJWIZCLESspj/qbE3fV3bc90r/9SDB+VH3HbPGQNXuAU2+vGfOsI0XcbSUBq66uX8DLstQ23ada6Ay0HAXGDVF5w3fFNBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793403; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OqdD8w//kksqbFi7Ex465eyuZpYmNdOVN8rRxFF6Q17ekypjg2YM1QK9AfVBN04rcKWZXnc+HHakbr9e/quV2vdtdptg6yO2oTa/zqFLzywwPhBbckzYRk2Gl4gKz2MOhs6RorsucW2g66wQLRjQBaxL8C4tNQgolTcHLOS6Urc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cpnZEob1; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cpnZEob1"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2fb5a9c7420so12982981fa.3
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793399; x=1730398199; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=cpnZEob1M9Ni1AZ28yiueweCC/SMZ3qr2w5LY8+9WKjM3OMNyww4UPmzCAf0i0+GQB
         SJSz78Utq0U3UYEN1iE7R+u8ITW2zqxYelY7zPOEZQZIPL6hSyrBa5oKascuiG1b4/mm
         H+PUwP+fuIvYNoppjnmDemAfyfsRuPCKpwc+mmaW9HyRKdR/tOn6UCvdYpb69kJWRLbh
         JzTHxBLNVdA+i4SWbJaXKh/PCDMCBSF4huXc0Fhib6wSBp0duR9cVbpNtklgte91JjX3
         haJBbhhR7B1LGSxLKRKUv8LYnhv3/BVrZPkl3qkRdznrVfojMHkXGSGRWBB6v3DpiGvL
         supA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793399; x=1730398199;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=WR8/fD+PD8MB/SjhNzfiwBCgE6HDzG77nuRhlfFX5WeW15vD80gkFyzwHuNjFMU/OB
         mavNtIaa/ZhjCOyxrzxkClO+Zm4itWP5yeBK3UItPIJx7rAvtQ1bxXzq5c4Oxa+1/KGA
         t/1lzvzgLkt52oG6ZzYjK4GX3B2IZQjFEt61PTirWZf0zHAXH5602wRTVgZ2AWxxrPtE
         13sHo8X8SNLaMDj+i4uBPFqEKd3eBLaQ7I9ROUWYQz3sR4Eo2Loob5dQFX7sDaX3oJ+R
         C7ZI476GzCBmy22j5qzsQWgyrnEAWqtrS+Fy+vF+8Wanhk3akYnujtfStqQ6wuSm4Tln
         F69A==
X-Gm-Message-State: AOJu0YwsQvm/Vvpv5x+dMjvUNUQXhWW7v0GTr4fF7xJpNWW96ygsdluA
	kEZnD4sv/AHXuhG7Ox91JWSxyFaHMpkX2T6wVj9PqUVf9zMDFn+Z
X-Google-Smtp-Source: AGHT+IGe0SXtrmsbS7B2469v0Qt/ziAeZ1oOgvA/oqPjBr4kH4TutgELX92QyGNdbr8FX8mYL9iuJw==
X-Received: by 2002:a2e:be1f:0:b0:2fb:4f0c:e40c with SMTP id 38308e7fff4ca-2fc9d5955e3mr42804101fa.34.1729793399158;
        Thu, 24 Oct 2024 11:09:59 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2fb9ad8c904sm14160241fa.61.2024.10.24.11.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:56 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:49 +0300
Message-ID: <20241024180949.4991-1-vladimirputin693389@gmail.com>
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
