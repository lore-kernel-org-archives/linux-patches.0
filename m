Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A49446E007;
	Tue, 21 Jul 2026 18:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658280; cv=none; b=ZmWLGu+kfdmvj0+BimP8VdH6Tiv3Lmfp8kA++sa/Cw68I/uWyBCmBmkNhv3pLibur6g2RKxIpBYM8xQ2JD9T3ZszpChFQ1gJ8hgPWjgFQfw3N9IC/IHZfXlVC66eR57Rvzsg5/Nj5mgL+T5eRZz/7qjDb9X0Foto5pp1ybZHieA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658280; c=relaxed/simple;
	bh=yK/NPNfC6yU5e8O6j6w7tSdPtIzwbB+HBYhlbuIGWJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C8X1p7y3cw5ZaZAKsBHX2u376wYpAhAqpNCeNvbFQYGI/B0aP8PlRk2LI1skLrMfAlfCK85N0kcyuvx/9fifYVt6NhrjNBKGlz3EAX6uzLj9uB4NFSLCOKwc6hmk7xD1ZtO3551IM1Vq5FPxbMJZ+hb/JzfYavLFIoUkvmVSfl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fbgAXw+V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fbgAXw+V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2921F000E9;
	Tue, 21 Jul 2026 18:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658277;
	bh=0U/fv+eyIYMRjX//ctxrbKTW7BpMDe1CAL6lBfO0TCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fbgAXw+Vy1xfJZndrVDBNU5vAM6jx+xpCGwlQL2OG+adu2TURcCWVpIJnDSvDMgEz
	 akU+bH27Xlctpy/3e+Lz6h+aayM+BV5ggnjSfsPthByzbmkp04i/URdXypV5Fay/bB
	 HEGXIFfdsy6CctK7ZjVcDrzlstc2gTXyJpVI0s8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rongguang Wei <weirongguang@kylinos.cn>,
	Holger Dengler <dengler@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1084/1611] s390/zcrypt: Remove the empty file
Date: Tue, 21 Jul 2026 17:20:00 +0200
Message-ID: <20260721152539.793438392@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



