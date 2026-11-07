Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060645;
	b=VXBsy5nNIGg5f9UZK5RLANFEhOOg+Ausp+btxhdhHRCVp4vz+SskF9C9N3/APohk4/yS
	 ROw6ip5R13iUgjz1/OKw/SXL+/bUaN/LkpT11En86s8eCi5idINXDdRbc5u4PwmI4JtxY
	 RxA2toCC26KCtp5KY+iYqbbpQvASV6guwpiPBleQAOer4mI3p3ywWpHS1qWALNmh503yO
	 Lye2X9clZ+/Y0Bjsyk+11S/4f+mHJEgarvrTXzaicZxzgeRae6LiDRy2nH2ajtAiY9BOH
	 rRR6VT5Xet8f/W1wFE165TwViG7v6bff6HvwM1cG0vMfI/OmRyvp6p3T/W4ZPYB5OuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060645;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=joBdeBLGIvvv+j/+ELzcB9Rk8l35PilY5WFLSlgkS2A=;
	b=XMnazKxg20s4g4CWwpSDLd9J+PJzBylshxDlDymSwwDtNG6zG/MyafUk7TF4oSPMg0yg
	 wQm51+yIo9hHZlOn0tXN+a9VqNlgxEhB0NKInQocF4zteMCp1UGWjEtasSTaQ3ct5LoW3
	 H7+nC8oWSm5/nzV2DJkBO6VCZU2F/czVbCo2dNzOc+o1apGk3bEiJp6FBVK6+RybVIlzK
	 m9Aljq7hDffIJMysz7MjbK6EZbGVUHTb2csyt5u5Y+ltIpT8G44shFRmJCiXg2AKS3bS8
	 p0e0g3OQceIiepWpqzH1nYrKj830Iaw7mWJRudg0JxKF0jlPCSMaCMq6HDj7cEJVBJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=woX1deD+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8B3606A32D;
	Sat,  7 Nov 2026 14:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=woX1deD+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 969511F008A1;
	Sat,  7 Nov 2026 14:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060644;
	bh=joBdeBLGIvvv+j/+ELzcB9Rk8l35PilY5WFLSlgkS2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=woX1deD+M/hGcuEdVLkAp1A7ZFscXzM9CSCz47enX6XaXEMBMqXYpfCu7im92+Tjy
	 vNdHS4x36leEn4KVurV0IVjlNXdxOR4i7m005ylnGvLIXz+YfZcJE9H6IISgDRuTPZ
	 kP4zJ0QlAioMz1ODiV5Z94it3tPyLpc9JbGzqowE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+72fe3ea5814121fbc76e@syzkaller.appspotmail.com,
	Yun Zhou <yun.zhou@windriver.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0079/1536] block: reject block device inodes with i_rdev == 0 in lookup_bdev()
Date: Sat,  7 Nov 2026 08:34:55 -0500
Message-ID: <20261107134959.893873813@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yun Zhou <yun.zhou@windriver.com>

[ Upstream commit 83887ad02f30c1814bed5da3ca999f7b0f3f337c ]

lookup_bdev() blindly returns inode->i_rdev without validating it.
When a FUSE filesystem exposes a root inode with S_IFBLK mode but
i_rdev == 0 (via rootmode=060000), any subsequent mount attempt using
that path as a block device source propagates dev_t 0 into the
superblock machinery.  After commit 9ee5f161a4db ("fs: maintain a
global device-to-superblock table") this triggers a WARNING in
super_dev_register().

Reject i_rdev == 0 early with -ENODEV since no real block device
driver registers major 0.

Reported-by: syzbot+72fe3ea5814121fbc76e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=72fe3ea5814121fbc76e
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Link: https://patch.msgid.link/20260703065548.1135125-1-yun.zhou@windriver.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bdev.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/block/bdev.c b/block/bdev.c
index e96ff382a1ce9..a1399a1bf9ac5 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -1185,6 +1185,18 @@ int lookup_bdev(const char *pathname, dev_t *dev)
 	if (!may_open_dev(&path))
 		goto out_path_put;
 
+	/*
+	 * Reject a block device inode with i_rdev == 0.  A dev_t of 0 is
+	 * never valid for a block device: no real block device driver
+	 * registers major 0.  Fake block device inodes (e.g. fuse with
+	 * rootmode=S_IFBLK) can expose i_rdev == 0, and letting that
+	 * propagate would confuse superblock lookup and trigger warnings
+	 * in the device-to-superblock table (super_dev_register).
+	 */
+	error = -ENODEV;
+	if (!inode->i_rdev)
+		goto out_path_put;
+
 	*dev = inode->i_rdev;
 	error = 0;
 out_path_put:
-- 
2.53.0



