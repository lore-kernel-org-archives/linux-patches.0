Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56E01FE0E7
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793410; cv=none; b=e9Vq43WhDSAkGKtUlKCqi4v8z3pN8s/HR7ol6eqve8g7I3kfx0gxLbaKn8GAxNo2WHRgwkqiqX8kgkaPf9p4WfjTbZLdQ10925YU125LJi1aLVDgwfqGTZ+FHYK4EQTBY1cmZr3uiUvAzeUc6ipK8lLZT7NXDiKm8q5WgwDK2RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793410; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VCYZ9bQ+xy8Q7omm8d7G+HcftpRrw8DH9L/xA8Iix9FUZjfs3UXjrJxq5trxnOfB+bAUoz7k13nAZ66db2JdHBk9pyf0+cHEpqK4KlWsk71nhuTRhx5h7tZAcAxSiTu89Z6XKDINLXR69qNobgDEuOkrIG7kJySJk12mrzwvs9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HKwHW6Vx; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HKwHW6Vx"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2fb50e84ec7so10981931fa.1
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793407; x=1730398207; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=HKwHW6VxqhFUimip339x7zQJ8ZRocln1BKVRdbTC9po0r7hle5rVi8zaL8VSJOA/bx
         FqYOVsDPtUDVsuTLRCrXJDEH9i3zl2niWnLjSlkfy1PhiuYQMY0qOcV4fZUNU7e+vLOA
         94eVjtUEkK0JQUlqJpMxgXHxIe6oid3TSRPL5Z0tIM+9d1+ncbl7oUbGvH8LyfScRqyX
         dGnqNoX+YSvNVuURK39diFelKe+eMhPMs97PArhKMPgilYq8qziQMb/btq/wXerYyXZw
         cgl7IxYbwhXZwGrmPcGRUOATq8dgtrWQaQ1O4vqtqis9A+melPQc7vd09y4vufBn9HnI
         neeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793407; x=1730398207;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=VdN5Y1m5MueEu9Gt3MVqnGZ7PUDg0zXvrlx2TCzV+JUGsPUiArHvAsNI90Gl4GCsyZ
         6Hn0V5riB89ilBXCR0vm9E2OhiAmYaTF+oB8EPv6/Rv+H8vEhyW2V2JtR+syOH2ZvZzt
         MjN36n96+Vcghwt9ba8SSRpwSuXx+Y/I35Q3iOdiVB0XChC62kO7QnLggyIbOhAiCt1r
         rgdH4bbhX7M0azGSQDOlgnvYEb/dGo/g0weMjWnC1hPoPrB2TodEAEm1CcRnuOCZhl6B
         0I6X/fvnRcAJQP6IC0t8aRbnoetH9/1ieT58NnGofMfvMN4ApgW9bhiUknJg8iFfIVmK
         HBvw==
X-Gm-Message-State: AOJu0Ywi3g2AkGev7Ziwsvbtj9AwC9O8VLfq3SwOwJDDH+ikyk2SPmDX
	wGEga+Bcd8vwEDxaq3uAf88Sj65tfWnHl8Fz2NmtIbIN7Xnf5sgI
X-Google-Smtp-Source: AGHT+IFpxUWvZl2ME3zUtywwRl6wljomhN5jPUDUnLU7eDVCP9PXRI3rarUW3OxhdzLUnfc/XdK6yw==
X-Received: by 2002:a2e:743:0:b0:2fb:57d6:f464 with SMTP id 38308e7fff4ca-2fca820b2a2mr14801461fa.20.1729793406495;
        Thu, 24 Oct 2024 11:10:06 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2fb9ae12273sm14636571fa.115.2024.10.24.11.10.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:04 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:57 +0300
Message-ID: <20241024180957.6421-1-vladimirputin693389@gmail.com>
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
