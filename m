Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956051367
	for <patches@lists.linux.dev>; Tue,  7 Jan 2025 15:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736265032; cv=none; b=BghVHaCESQEk4SNCu3IgISKuVVzTUjadR7iq7k1uHL13iq3+GUfuXlVXmr+RS6oJnFY9Zoar4q0vdi88RuHLm9Hd7ILCaXBU3zF+2jx2sVhQkmib4IPIPHla3+COdEPPwSGYsiB50xuaGsZzDCW4z58irnhL4gYyr07TcuZmJZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736265032; c=relaxed/simple;
	bh=80YpzQVau2iHsJbM/3HxC55tVhLcSIdIG9IUCjqWvis=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bFWQlv+ImSfqaDpqCRtlHKW1XYzSxuOJIZdj0YEEj+w3/VUblfle7/x65iqVm4LB63kLzN0GVI4TJ/ud2ORlL44fF7i5tlunXshWUMzLxje9oumSEZo9SupWiBjlufkrZtEUim3eqsWxWZHtZax0VeIQRNDXBut+Zh0Zc8BQe5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L40Ob6sY; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L40Ob6sY"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-436326dcb1cso105087285e9.0
        for <patches@lists.linux.dev>; Tue, 07 Jan 2025 07:50:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736265028; x=1736869828; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lHe0KygA/Lbfz7umC4cWgOiunml0PiO3u5JU8TrYweU=;
        b=L40Ob6sYszsz8lZwAJJO+ibdWyAa+kpQM6rt5Hd9e7g82Cqv0RGBPFhh/u1xi7o0i8
         GkU8eUSO7PA6Ae6jro/8hCIToVj8XSMrheOHCEr+s/SyTJmf6H9c0pkjqCjREVxPTlrR
         VRyiYWk12Ue7Djnc5b9PGOQJ2jA8tBa/y+I4OlaBeRJa+P3x1g1BMYg7DBDiPd3psevS
         KBVbNitR62/nP4VL/Sfhvyv99V3ULsvGq+Oz1uCPadsYAcQZBa3FQhsFZw1G1NosF1WU
         Te06dBrAwb6OyCVwXIobZDJc2Vtgm6X09F0np0i9lYR3PMt7N9MV8SuxI1HdVyE0KCXP
         bCIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736265028; x=1736869828;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lHe0KygA/Lbfz7umC4cWgOiunml0PiO3u5JU8TrYweU=;
        b=srHqRY6oCQ2WREzp1zyxYCiAeu1hX0gJQKB31qkiBF+KFG9l2LjwP+P6nSojpPQXW3
         zmq9Dqjnep2FCOROw7n131gre03kNWc3sR+ooiOrj3C9m1oTSlM2ZWXlFqzFNQUO+4KT
         eB2WqflpTi9JYa/11YABtFr6EsVPmysl8ya4P1E9l6x8PNgzvUsNrlWnh9CsKRJNUjTN
         WGUZA8pAKjPD5wN4gtN2IZKA4/EeAVDRodYzs2XCXjSHwV3hdRzHy7WmwS5UeFoVncaz
         QTfIIiRvZB2YqnWlwQi76RJdCXdirlHmjYl4pVt+BVPMSpURzv3mtNSbZgJA2sfl40ZS
         sFjQ==
X-Gm-Message-State: AOJu0YyUo2qYZUEQ9zIA2U/I54iXBZ/Zd8rN/mragw8PNZaZDGTJNx6u
	MS6duwxwUxyJuzfkhdBgJBP55P5NAvHzUG8HBvwJilEyk87vdP1nYwdCeg==
X-Gm-Gg: ASbGncvJ8Ciccxho+GU1Hw1K0HOfUpyiQ01Oo9Ggxb2vMgNligVM7jJwaMwkCzlJmPA
	czVoyzZretVsHESnUI9Xuw9oyL4MVDwKLJZ5rx3w2mX5ng02+s0zSRDyfIaZtM2fTZMHwey/qyw
	1Hw3OY1itcVJtIOsgIsGzOQhKg1/+ENy4G+bG2UJmHDLPcwbSTcyeqEYeiVlt8O3aOtwX4UbWUZ
	3NySVhMjQYoafbaLlZHVScq4cD4fuoN4vMfqUAbSwWH7mSBH5zTV7AFDNoqvGOzz8AqDOnVsRu4
	2lHSOa9vx92x1sJg0AHAnD79
X-Google-Smtp-Source: AGHT+IHswZ5PunMRRmfg6wntLNnqMGbJQjQG8Ygalpb3cyfEetK8aX7XGb99yhCFW+NnRNXjziZKDQ==
X-Received: by 2002:a05:6000:1785:b0:386:930:fad4 with SMTP id ffacd0b85a97d-38a221fab43mr53564815f8f.19.1736265027739;
        Tue, 07 Jan 2025 07:50:27 -0800 (PST)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c832e8asm50015640f8f.37.2025.01.07.07.50.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 07:50:27 -0800 (PST)
From: Ilya Dryomov <idryomov@gmail.com>
To: stable@vger.kernel.org
Cc: patches@lists.linux.dev,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Xiubo Li <xiubli@redhat.com>,
	Patrick Donnelly <pdonnell@redhat.com>,
	Milind Changire <mchangir@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6] ceph: give up on paths longer than PATH_MAX
Date: Tue,  7 Jan 2025 16:50:08 +0100
Message-ID: <20250107155010.2658845-1-idryomov@gmail.com>
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
[idryomov@gmail.com: backport to 6.6: pr_warn() is still in use]
---
 fs/ceph/mds_client.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 11289ce8a8cc..dfa1b3c82b53 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2713,12 +2713,11 @@ char *ceph_mdsc_build_path(struct ceph_mds_client *mdsc, struct dentry *dentry,
 
 	if (pos < 0) {
 		/*
-		 * A rename didn't occur, but somehow we didn't end up where
-		 * we thought we would. Throw a warning and try again.
+		 * The path is longer than PATH_MAX and this function
+		 * cannot ever succeed.  Creating paths that long is
+		 * possible with Ceph, but Linux cannot use them.
 		 */
-		pr_warn("build_path did not end path lookup where expected (pos = %d)\n",
-			pos);
-		goto retry;
+		return ERR_PTR(-ENAMETOOLONG);
 	}
 
 	*pbase = base;
-- 
2.46.1

