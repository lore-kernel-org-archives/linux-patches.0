Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064630;
	b=1odtvbdUDxbavOXWvnJU6Jbz9SAJFR2nvuhMLLXiHPx3D6N9ai6JParHEGv/dEfvxRQw
	 8k89kZ4hfGZ5GMiZbU7na9ANXDbK8nRaHhqhefmbvdIgrgNKiG9l9tYQ+GUSn/J/mRM1j
	 wCcxHj/dBKcescNOHMGFVos2hATvyznxAGID1cm7chcbsXT2OMSemltFJWKeYUIyGSSJ7
	 Nlbh5+8n9I8QI+RmJ51LBoaNwMSCkuZg/ZgeR3MUFCKoanOO84IGVcJTeykZTsuhUlObs
	 PJOyj6OKn7BTBGQTFrsAsJC3qCsishW3oVwaTSnlf5gekguH5E4r1eOe0F2D0zG7wSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064630;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IYLhU1XHdfRgXwYHVrYzlolmbZJwrma0z5uD2zw8KxQ=;
	b=ftatsHO8O9dSNat2ZA2oSFkBB4IN3ZMxrPvc0neuF3BRgNvv6O7obgY/WjL0bkB1c4jY
	 Wdu6deFpkT/1o9469wwihqQTWIUnvQCNXimqdb3EgeVCIVGuEBkRQ1pju5/XFv83tTcP8
	 JplMFfPI8dvryel7+1OjE44ijyG39+M+A8qhyQuA0eKxE7ODcagtyCpoUT5OUKaZczojJ
	 kKsi5f420uEUd+nDox7wIzXz2T8ZkY9Ph0cPXH45FjumAEdGKfqLaFQgpcvEJQtMN0Wrb
	 VF3qaWCve/G6Q9mqwiX6Co1f+fztF3HAHeZOInJVfdLu8DFIBww1BKXzl1Fmse8RqLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nu01ukxE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAFF6606A9E8;
	Sat,  7 Nov 2026 15:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nu01ukxE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89DC81F0089F;
	Sat,  7 Nov 2026 15:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064629;
	bh=IYLhU1XHdfRgXwYHVrYzlolmbZJwrma0z5uD2zw8KxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nu01ukxEuVMneOf4yGL1iMZDrVhjtEHOldNLBMHjeokR52tl5xqfVo/BZTme6sfi3
	 JQt9TOO/KKC6vrCHa1y3VZhENAYqgJUbkCeRhOAKkzYHUE16ikBt4X4OWNaYbGbNR3
	 G/1RNtSn3eqnvi/FtTwaG+iPZi3G88kZENKSHwBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjoern Doebel <doebel@amazon.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0638/1257] selftests/filesystems: Fix idmapped_tmpfile layer dir ownership
Date: Sat,  7 Nov 2026 08:48:54 -0500
Message-ID: <20261107134956.902287298@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjoern Doebel <doebel@amazon.de>

[ Upstream commit 9ba6627ef6b12debd1c54443939718db63234274 ]

The recent idmapped_tmpfile selftest creates a new directory in tmpfs
owned by user ID 0. It then idmaps the mount as caller [0,10000) to disk
[10000,20000). The original uid 0 owner does not exist in the mapped
range. As a result, mapped_caller_creates_and_links fails at the
O_TMPFILE open because inode_permission() rejects MAY_WRITE access:

  idmapped_tmpfile.c:145:mapped_caller_creates_and_links:
  Expected fd (-1) >= 0 (0)

Chown the directory into the mapped range to satisfy the UID
requirement.

Fixes: d943e68edc5cb ("selftests/filesystems: test O_TMPFILE creation on idmapped mounts")
Cc: stable@vger.kernel.org # 7.2+
Signed-off-by: Bjoern Doebel <doebel@amazon.de>
Link: https://patch.msgid.link/20261001082411.1493072-1-doebel@amazon.de
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/filesystems/idmapped_tmpfile.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/selftests/filesystems/idmapped_tmpfile.c b/tools/testing/selftests/filesystems/idmapped_tmpfile.c
index bc411ab8281ea..77b96d0943578 100644
--- a/tools/testing/selftests/filesystems/idmapped_tmpfile.c
+++ b/tools/testing/selftests/filesystems/idmapped_tmpfile.c
@@ -91,6 +91,13 @@ FIXTURE_SETUP(idmapped_tmpfile)
 	ASSERT_EQ(mkdir(self->dir, 0777), 0);
 	/* World-writable so an unmapped caller still passes permission(). */
 	ASSERT_EQ(chmod(self->dir, 0777), 0);
+	/*
+	 * The directory itself must be inside the range the mount maps.
+	 * Left owned by 0 it has no mapping in the mount, and
+	 * inode_permission() then fails MAY_WRITE via HAS_UNMAPPED_ID()
+	 * before any of the tmpfile logic is reached, regardless of mode.
+	 */
+	ASSERT_EQ(chown(self->dir, MAP_HOST, MAP_HOST), 0);
 }
 
 FIXTURE_TEARDOWN(idmapped_tmpfile)
-- 
2.53.0



