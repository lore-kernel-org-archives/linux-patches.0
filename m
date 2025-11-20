Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773EB30100C
	for <patches@lists.linux.dev>; Thu, 20 Nov 2025 19:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763668336; cv=none; b=duJk6szfnWVvISdJTj8zve72lLAeVNA5V4VspMu2kN1lZcBifSVS6QBfCKl7oS2bn/4DguTJMs9IeVw6PxxWfAMET9EsE2obLvSdPtvZmX10z4QZle5y8ZqEatMyExSn9u1pkZy5DrGNHKt57Z/ogUxoob4G3P8HFzfld4+jCR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763668336; c=relaxed/simple;
	bh=u2+T1r+sWsvkftBxAcy6kHz++p4wMgmzB+K5Zky2h7w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PcgLpEkz4Onw0fJAJZysZdhv4eN2yBw6buV1mGAnU9wU8/ZMmMcq1hJpVvp6M6vQhivZKiHVehv+OPWq/wRcJM6sTcJGZq4dcEiLDQijdMcksVGZBEpnccqJu69xIeN/x2Hk+8BLn1qxYRBACEdnApXY1zAqfGlYuDemVK2Z+ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BqB/VdSx; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BqB/VdSx"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-37a48fc491aso11279221fa.1
        for <patches@lists.linux.dev>; Thu, 20 Nov 2025 11:52:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763668333; x=1764273133; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Er2FJbbUBh6YnvwnjR3JbLaZQz/HmWBPLBBSx8YXc30=;
        b=BqB/VdSxkYcEtiNBM8QlxEGg+eYs56XM+/SbMtqTfn5dw945sHNKqQUKzjzuH7eC4G
         gJTkcsAZBmE68wiVt2DsoJOSxR84LI7JSlcw6a5GvXxI3u0WzyaY6AVgtQmKBWJ4T+w8
         Mmncjy7zV0gku1D+ZKBgOZYWjDwS2D6+S1IXhyi0biHJuqYRnrZInQu8tpOyciLrmcr0
         Dc0tWQ0x8x6krYxB5J5oTTr0gnjt4O3chWYqGoY+8io7gp9Wfz+jNVQQEp9aLkqZunbN
         hM4oqJvb5QjeoEKW7PaT58X4HBwTwLdi60b8Kq/o8e2Lsma5YKgAlQDn2MErju6+E0gp
         UZpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763668333; x=1764273133;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Er2FJbbUBh6YnvwnjR3JbLaZQz/HmWBPLBBSx8YXc30=;
        b=dxNqBD/7zoJMvErlyTb8sx3KUJOTWyoJLJfpwV0oXYOd0oSM/XbMelTlPWA8g5q/UO
         YUa3Y4blOyq/bgBky/x972SgSMxHEi9taweIcdo3bf2eBhIC/hKkzAJ6Sa/fpx9B1exo
         5DIQwYH7HcpX33S2y8Im0V+YIrrKImGi2CKle0CzAReVZldJLgkVpovhxgJXIoNO2SNS
         3vfdLpz9CngM1+IPldC6nPIi5xtRp4pUZ63b/Abmw0gHkMFFRmRL9ZwR0WPXZ6mtiwWi
         bZefen8u4pZMy97pCw7xWqXaH86syAzUdFDLIft9U8Xe3iYURTa/wYQ8j8j3KkwMzQ0g
         uZNg==
X-Gm-Message-State: AOJu0Yy1ce5vvMUFXs1e1C5iNVgxmItQRgbiyUA7c7kP3+TXt5+CjX+w
	oQIZA/ag9kGIC7iNAlgptRnsUTrWyGVmPYDndD552lrZ5BazB1myCD0g
X-Gm-Gg: ASbGncsv3rBqHjmGjFuLoULtZXOyo/8XeOyWdLT2VjJKwrx0Lm/eoZO4M9XRMOXvWBj
	wc/2JoLwsBi2MrxojCSCCfmL1xM4hJnTt4NuyybSHXHTNVI7QkAk+5Q3zccvm0/iNrqc59ZgbSc
	sjc3wiVpjgcB7JD6/fkp2Oqotdy/ceTlT+pJpMVYmTVpbcm7x8lkXxgQ0vzBlsReKD8ypaW1Tf8
	Lz/TR0Ut1sycLNFZve/CB6/e8Xt6wtcTL8a0Bi511N21z4BGUVByXqTeffEuu0syoRngxOrRbsK
	oGbw42kdEE0rSRdZs3DPW7mx6twQGsAw4/ESnYqF+5F0m8ke/HSaHYEemJ+qwyIOnqIBG4V1uYr
	0Op33fbM7hKMFH+6XiC9obSYbWKVxNVrBj02QnBWbWk/6/xN11Ib+3FWk19Xe4mqJMM7ifE9f1p
	BSVj4K/az1
X-Google-Smtp-Source: AGHT+IGO95a2DriC/sUFBPYgQuutgp8Cgi9UCTrUgdhkhO22s+KUmGoBKxdV94i/DlK6/m1jFIzlDQ==
X-Received: by 2002:a2e:7205:0:b0:37a:4714:ff39 with SMTP id 38308e7fff4ca-37ccecd68aemr7615261fa.23.1763668332347;
        Thu, 20 Nov 2025 11:52:12 -0800 (PST)
Received: from localhost ([109.167.240.218])
        by smtp.gmail.com with UTF8SMTPSA id 38308e7fff4ca-37cc6b4b47fsm6967301fa.2.2025.11.20.11.52.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Nov 2025 11:52:11 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: patches@lists.linux.dev,
	kernel-janitors@vger.kernel.org
Subject: [PATCH] include/linux/fs.h: trivial fix: regualr -> regular
Date: Thu, 20 Nov 2025 19:51:40 +0000
Message-ID: <20251120195140.571608-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Trivial fix.

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 include/linux/fs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index dd3b57cfa..247e37090 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3103,7 +3103,7 @@ static inline bool inode_wrong_type(const struct inode *inode, umode_t mode)
  * file_start_write - get write access to a superblock for regular file io
  * @file: the file we want to write to
  *
- * This is a variant of sb_start_write() which is a noop on non-regualr file.
+ * This is a variant of sb_start_write() which is a noop on non-regular file.
  * Should be matched with a call to file_end_write().
  */
 static inline void file_start_write(struct file *file)

base-commit: fd95357fd8c6778ac7dea6c57a19b8b182b6e91f
-- 
2.47.3

