Received: from n169-113.mail.139.com (n169-113.mail.139.com [120.232.169.113])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50BF431AA80
	for <patches@lists.linux.dev>; Thu, 22 Jan 2026 10:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769077048; cv=none; b=kXO2TesPEePUBbPQb1auHWaGB/vpXuxeAaZaDW57P7OkEES7QaArKnLUmSio7aS21BKoXC+7RubOAO9yoFdGiKVx2uCnUUrfSipFkJvsKfp+fmwLG9pU+CpnDFuWkf6zvXRcCAEwj6QYBMl7o/mx/pP6jnt/+ugpep3yKBwViFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769077048; c=relaxed/simple;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VI+FHcSRM13MQ744vkxArikxDwo6aO4XqwHYVuIk6iCmiq0ZXyt5L1yjSvB6JyRKuAO33rkGogjtXOFZzsuJ1XThZWPZf1852i19l9ynAgM93T+RItI0cGmvQU+LF6RrjQl/qcGlxU2urRdhd+46Hv1ueGgH47WLSRGpcjVylP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=dbf1LR05; arc=none smtp.client-ip=120.232.169.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="dbf1LR05"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=dbf1LR05VDeckFm944mWm8h3+bGVQfCtUnevESTmJFQP7CWyuRcsJhfKmzlkiwkU/mOEVji08h7NC
	 WXUR/SE0nzdaKck1lkOyc5Q1QiY1tBxCDnndKXlRa37sg+AhPjLTl8auPWK+OTuo//wrDtygoMz/0f
	 kj45Va361AqXCdSI=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from NTT-kernel-dev (unknown[60.247.85.88])
	by rmsmtp-lg-appmail-28-12033 (RichMail) with SMTP id 2f016971f862aba-01ada;
	Thu, 22 Jan 2026 18:13:56 +0800 (CST)
X-RM-TRANSID:2f016971f862aba-01ada
From: Rajani Kantha <681739313@139.com>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.6.y] iomap: Fix possible overflow condition in iomap_write_delalloc_scan
Date: Thu, 22 Jan 2026 18:14:05 +0800
Message-Id: <20260122101405.3376947-1-681739313@139.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260122033826.3110454-1-681739313@139.com>
References: <20260122033826.3110454-1-681739313@139.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit


