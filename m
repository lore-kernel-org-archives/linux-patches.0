Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782971F3D56;
	Tue, 21 Jul 2026 17:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653886; cv=none; b=dvJQz6IgzxIk+gZkhMYorhUKtGIw7qffeYaq4hxVIYzuP6GlGo6FDidxpCtvCSG/VOcvMKNGqeReO238Rigp8DrVGKnpPHeQ0MAAN06zv4WL9d5PQ2FMDJSzOYsG/bQAQma3jJcl1POciR+r6emoQXMAk8+NhMhcqnMyQk09eWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653886; c=relaxed/simple;
	bh=kBvbT7RS15fjMbIjNq5SDGYhjDBMcMRhzIc+2CVjf8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TzCbQgJxslzJG843aGucOPyT+gRQDqZfof1/aUMWnwkPAvbHNH4dtS6qm/Z7uqYqOTvF1eCVJqgDa6kcPD9ou3mDC9L78kqe9OgXAutNwxF1O/AGSwBpa7ANBYT1lTMGyr8JXaQXKCbGxiHILZ+e24mOLUYtGHSBizXP7Y3yXtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tTkHFnm6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tTkHFnm6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCDCC1F000E9;
	Tue, 21 Jul 2026 17:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653885;
	bh=XMYnV2zb3RmVKjuinE8moSP/mA5sNOUIAePveygjyl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tTkHFnm6qO37Z4GMBrt3K/RYH5y1vUKM7NhiCD7+z2FTR7rzeKhkeudeq720Zy6As
	 BPOISPHpGTZuSlc98RT15AWZ94Fg8k+7NOnxz8VJsUu2O6dVLxMA9WE+oC/D9AMcUE
	 W4PW5D+beylHFEklHOv74bKZcaex9oe1nAEmh8YI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rongguang Wei <weirongguang@kylinos.cn>,
	Holger Dengler <dengler@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1496/2077] s390/zcrypt: Remove the empty file
Date: Tue, 21 Jul 2026 17:19:29 +0200
Message-ID: <20260721152628.075976627@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rongguang Wei <weirongguang@kylinos.cn>

[ Upstream commit 575f87b9d4882b0d621192fdd754d7e09dbd5789 ]

The files has no real user because CEX2 and CEX3 device drivers
are removed, also remove these empty files.

Fixes: 5ac8c72462cd ("s390/zcrypt: remove CEX2 and CEX3 device drivers")
Signed-off-by: Rongguang Wei <weirongguang@kylinos.cn>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/zcrypt_cex2a.c | 0
 drivers/s390/crypto/zcrypt_cex2a.h | 0
 drivers/s390/crypto/zcrypt_cex2c.c | 0
 drivers/s390/crypto/zcrypt_cex2c.h | 0
 4 files changed, 0 insertions(+), 0 deletions(-)
 delete mode 100644 drivers/s390/crypto/zcrypt_cex2a.c
 delete mode 100644 drivers/s390/crypto/zcrypt_cex2a.h
 delete mode 100644 drivers/s390/crypto/zcrypt_cex2c.c
 delete mode 100644 drivers/s390/crypto/zcrypt_cex2c.h

diff --git a/drivers/s390/crypto/zcrypt_cex2a.c b/drivers/s390/crypto/zcrypt_cex2a.c
deleted file mode 100644
index e69de29bb2d1d6..00000000000000
diff --git a/drivers/s390/crypto/zcrypt_cex2a.h b/drivers/s390/crypto/zcrypt_cex2a.h
deleted file mode 100644
index e69de29bb2d1d6..00000000000000
diff --git a/drivers/s390/crypto/zcrypt_cex2c.c b/drivers/s390/crypto/zcrypt_cex2c.c
deleted file mode 100644
index e69de29bb2d1d6..00000000000000
diff --git a/drivers/s390/crypto/zcrypt_cex2c.h b/drivers/s390/crypto/zcrypt_cex2c.h
deleted file mode 100644
index e69de29bb2d1d6..00000000000000
-- 
2.53.0



