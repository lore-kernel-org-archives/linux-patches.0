Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CAC71F5EA
	for <patches@lists.linux.dev>; Tue,  7 Jan 2025 15:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736264919; cv=none; b=umtLnLoydkyOwgCtQS+GUDUWKv6NMqzGq3hyClZcV1iaiObUENGakvt7wDy8lWMB1VSM+K8F8tsY9ba/NsAAXn5xezeEDQYwc9Q9MZ4C5Mk3chafpSx212/D5XEp2V5Nz7REky/kZiJBojEJy3Jk92KoKJi2Y/1WQM4eToZw0W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736264919; c=relaxed/simple;
	bh=zHSxnQvEb8UZztbuDFW1UWtGRXNHr4k7c68bvF9k58Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=G5unTJ5vm1av7S2ECtji81aS9IHAwUdnCqP2gNDokNc5rwUMSvEZxuTAZ7zhLZKGNPx/Oc1Z8pu6jIGE2PiG0jpKKJTfYshFySJq03De1tcOu6rnf84SeRhCLzfw5U2SOZPxBMpO21cnIFG8u8b17X4OsOT9kulJjx2yVGnyA60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZLLk7QlV; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZLLk7QlV"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-436345cc17bso113831335e9.0
        for <patches@lists.linux.dev>; Tue, 07 Jan 2025 07:48:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736264914; x=1736869714; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZTv0piVgUC+YB8cY6nEGnXIfNYGA4ovWnbmblZRjSGs=;
        b=ZLLk7QlVCSLDt3Ao4cq0qFFh2d0PWTwiCCxkad7QCqj+RvgNnwd0/3PLdK1Bq5ZBli
         7ranmo1n7goBxtQjv55dipWQwYPpAD852fu5tVc4qDjxVWB8ELNUeer37x3uJYQUsNnX
         GrGwdeTHaM18XCYnTcRobeeBN9wi5XKJnw4XttR1JWf0oprUivW2VgQDRJJUirDI6OcZ
         LqNr0QeXzqj5lDpzvLVx0TXCVZprXdlxFm92ixRHxwxWiZO8HJxyWxb6DxrajItbpk3x
         2mto2wuwY6SeJMBiAKjm3FWjTXiLzMrHRbqrcot+Un5VfbiIbEHDI3vkFIZTTzuxuiMo
         T6jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736264914; x=1736869714;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZTv0piVgUC+YB8cY6nEGnXIfNYGA4ovWnbmblZRjSGs=;
        b=BsN/UiIMYGhx0sj8WOXJPCfMhxcjiWNGd5K8bXv3cmu3g0HUcdBwvurFGh1p8ReMMq
         Utco6TGkfEGlOwbSc5IT/VL1gyBlo7Ia1uoQJ/tbRAwKXqMnV4DbG1hVL+NoTcjsQSqO
         H8eluUfyyqr0CIaHr7FPGHv8wGo+2CqynJYdB79nJt3hKQeUfvxY8dRnubBxJ3sqHJ1x
         uTGtLhwGOjHDY0O2Jjw5ohj+cNs4BgCYUeczcXL4MNtvbsXw/PCpybux68wZ0HbbI9h0
         N+wuu0XDfVBu/CHMBhjDSVHVgrRl36/pkJaP3AcoRgv1Ub4LPaKLvIqdnuz2uNnK7+hN
         3O0Q==
X-Gm-Message-State: AOJu0YzOY7Y4J4c6SMY2TLco6SP4ABt2Cofu9uXf6WEs36LcrPfhy6p4
	DqJhjNOtLPvXskk8pUeHNG1ZWCv6Jz64/ZsLiNOQdRcVIBxtbqqr
X-Gm-Gg: ASbGnctvAWgGd2oMNUzPK75GXLoY/T+LbsuPvUjA6qA/DAzeQa30zW3iJKSAuiEl0Cy
	33rmLABWADIc587WZSVGpR5nv1ExBJY7PLQxxbYPD5jabm7J9LeCv8sI1OPTHB3azS9kgvtQJoc
	2cZgXceopYpDTKyouOpNm9tig8WfFJTk6Pjas5GIK0S7kJOR73lb2cZ+PDdnB5IzGhaum4WhaAh
	3AmI4Yza7zRSbcCE2XlTUVLQ0mE7DtS8+xPxVPyquDg+8mRNNq8y6Ul+AihUwiZAvL57QXT+lqa
	mWoBlN0LieAmECuDmkMPGzNJ
X-Google-Smtp-Source: AGHT+IFStaQ60Gj72ivc1xpL3DMDwxxZNPlR4BqR07cDPPFkt2xmzdnCYiM8rZqRpvi5D2KBWVLcHQ==
X-Received: by 2002:a5d:5f51:0:b0:385:fa2e:a33e with SMTP id ffacd0b85a97d-38a223fd369mr49518115f8f.43.1736264914273;
        Tue, 07 Jan 2025 07:48:34 -0800 (PST)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c8287adsm50005522f8f.16.2025.01.07.07.48.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 07:48:33 -0800 (PST)
From: Ilya Dryomov <idryomov@gmail.com>
To: stable@vger.kernel.org
Cc: patches@lists.linux.dev,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Xiubo Li <xiubli@redhat.com>,
	Patrick Donnelly <pdonnell@redhat.com>,
	Milind Changire <mchangir@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10-6.1] ceph: give up on paths longer than PATH_MAX
Date: Tue,  7 Jan 2025 16:48:16 +0100
Message-ID: <20250107154818.2658618-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.46.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Max Kellermann <max.kellermann@ionos.com>

commit 550f7ca98ee028a606aa75705a7e77b1bd11720f upstream.

If the full path to be built by ceph_mdsc_build_path() happens to be
longer than PATH_MAX, then this function will enter an endless (retry)
loop, effectively blocking the whole task.  Most of the machine
becomes unusable, making this a very simple and effective DoS
vulnerability.

I cannot imagine why this retry was ever implemented, but it seems
rather useless and harmful to me.  Let's remove it and fail with
ENAMETOOLONG instead.

Cc: stable@vger.kernel.org
Reported-by: Dario Weißer <dario@cure53.de>
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
[idryomov@gmail.com: backport to 6.1: pr_warn() is still in use]
---
 fs/ceph/mds_client.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index da9fcf48ab6c..741ca7d10032 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2447,12 +2447,11 @@ char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase,
 
 	if (pos < 0) {
 		/*
-		 * A rename didn't occur, but somehow we didn't end up where
-		 * we thought we would. Throw a warning and try again.
+		 * The path is longer than PATH_MAX and this function
+		 * cannot ever succeed.  Creating paths that long is
+		 * possible with Ceph, but Linux cannot use them.
 		 */
-		pr_warn("build_path did not end path lookup where "
-			"expected, pos is %d\n", pos);
-		goto retry;
+		return ERR_PTR(-ENAMETOOLONG);
 	}
 
 	*pbase = base;
-- 
2.46.1

