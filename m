Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C967518661A;
	Tue, 10 Sep 2024 09:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961740; cv=none; b=tP3uwxSv2J+mWQhdb/H5ToEDlA75hNAIvG9PoPgAVoppNS9a1G5JLSU/v+B2Rgbdnu7NnrO370T75i5/PYQ46OuvhMkKkvv7YbdO/+PLd+XSp0Y/bndwvWQKKSg1SV0Rkq6Hb4wDbgaj4RcQujacl2iv1wO6hGoEKXrbSLZj8EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961740; c=relaxed/simple;
	bh=ALPyyVK9hw5d1pBWgcNU7VExuVY5hFJlv+A6p9MH73c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CILc6+OZLR0YUViB573HxaMhyZEcUPGvAyedafs6fwDi/uxlCQCJaH+1x5gtyxqY4KLX2qwsMhY9dZSigUJDvTRhAO7MdqaZmBF0K2AJnp5sEKYcXSAqvna6bKtQxxgVPsafUfzaunUaUNUaAKJ8a/PxDvE1qx0Yw+Dz03KVTqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vXZ3PxaT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vXZ3PxaT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487A8C4CEC3;
	Tue, 10 Sep 2024 09:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961740;
	bh=ALPyyVK9hw5d1pBWgcNU7VExuVY5hFJlv+A6p9MH73c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vXZ3PxaTablk7Zp17bSQsQnwQGZNVqRSkE3vSAqaLMEsbDygZSjTb4oOLN7HslTUY
	 rMWpZjV10TUeyfQYwj2eITUrBXxfIhi9vYqLTnD8aU2oIMsu/0XXkQO9CtVqoM6ZC9
	 9CXfVnKQ/poZHvYl5AaBxskE1Ifa/xJ40DHW6ht0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawel Dembicki <paweldembicki@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 173/375] hwmon: ltc2991: fix register bits defines
Date: Tue, 10 Sep 2024 11:29:30 +0200
Message-ID: <20240910092628.293177927@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawel Dembicki <paweldembicki@gmail.com>

[ Upstream commit 6a422a96bc84cf9b9f0ff741f293a1f9059e0883 ]

In the LTC2991, V5 and V6 channels use the low nibble of the
"V5, V6, V7, and V8 Control Register" for configuration, but currently,
the high nibble is defined.

This patch changes the defines to use the low nibble.

Fixes: 2b9ea4262ae9 ("hwmon: Add driver for ltc2991")
Signed-off-by: Pawel Dembicki <paweldembicki@gmail.com>
Message-ID: <20240830111349.30531-1-paweldembicki@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ltc2991.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/ltc2991.c b/drivers/hwmon/ltc2991.c
index f74ce9c25bf7..d5e120dfd592 100644
--- a/drivers/hwmon/ltc2991.c
+++ b/drivers/hwmon/ltc2991.c
@@ -42,9 +42,9 @@
 #define LTC2991_V7_V8_FILT_EN		BIT(7)
 #define LTC2991_V7_V8_TEMP_EN		BIT(5)
 #define LTC2991_V7_V8_DIFF_EN		BIT(4)
-#define LTC2991_V5_V6_FILT_EN		BIT(7)
-#define LTC2991_V5_V6_TEMP_EN		BIT(5)
-#define LTC2991_V5_V6_DIFF_EN		BIT(4)
+#define LTC2991_V5_V6_FILT_EN		BIT(3)
+#define LTC2991_V5_V6_TEMP_EN		BIT(1)
+#define LTC2991_V5_V6_DIFF_EN		BIT(0)
 
 #define LTC2991_REPEAT_ACQ_EN		BIT(4)
 #define LTC2991_T_INT_FILT_EN		BIT(3)
-- 
2.43.0



