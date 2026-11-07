Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060670;
	b=zBrlPAlWO+vInH6tNHH4KpRPySyFsYHWf3amnE1AVelq7b5aEs+WTdwrJkO5J7Iuy1YV
	 FuSc47CQ1IGmlD1gHOKs1rx3dCEU8rC7nSu0GkcTu6HhS/XVbJK6N0G+SSAltswDNOTUE
	 nL9NRikh5oGkkLxxJzfIg1khlWn1KX4DusCiMgQpi4bKTPxrcRyGHJWnnQH1eSbz3o8dA
	 rXcwZmkGcyII6xnMhqvJJJddMmYBfJI7Fh0O7obhlXIGEzoxjmFVZ6dpD8JzRs+ognKJa
	 TmFeLP8K3akh00Gme29C8iEq8e5QGiPpR7our8y9HBN5WySZUbSBSlvo0rkpKNvm0Uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060670;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1NzCn0xwN+M9g6aEnvzfp34McsCU4bV+YxDN4LdSHyk=;
	b=HHSgp0ONpnQMW4UA2DilSHUlEpW3na7fR+dJ0rQVTN28SESqb1OHcokokC7qFkiknxza
	 3KzuTOqnNkDlR+lkRoDBmCs6opd3BQOYbEY73SAWli1Z7HW7mHzEQqe1nGzbgqv9PPEEn
	 mbiZ97OKCkVZYLvUV1ugEJZBUY/YTENgv5uJk8UFy/7/mdNLIyKZ+rAWBXpUQBq9asymR
	 BKq7gfIotDoxdH6wY02sMgBY2eoml5MFbgx+LHG3OrNn9uj4RZnHUvADjbdXc0VtTHrn1
	 z59jGsqvdW32VW+ivPgG+4CSYnQDxxaf6eQLwNxFy1w3Y7THdZvYKiGtcB0da1mUHog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=semvk0ze;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50EFD606A326;
	Sat,  7 Nov 2026 14:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=semvk0ze
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F36731F0089F;
	Sat,  7 Nov 2026 14:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060670;
	bh=1NzCn0xwN+M9g6aEnvzfp34McsCU4bV+YxDN4LdSHyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=semvk0zeGQjDI8iiE5/rNneURDoep1PUdwfE392jx9WplGx/lC/ihtPs9yufxPcjH
	 tptIO3OzPKTl2vf+cYCtncdctY+BJhsEQvJVBWggwEppb6ZWaMSOvmkt/5660d0yFi
	 BYLv8tm7l4mjM7pdvyo+AIBBdxc4nz+JPcFQ/hYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0106/1536] mmc: block: reject invalid perdev_minors before division
Date: Sat,  7 Nov 2026 08:35:22 -0500
Message-ID: <20261107135000.650883280@linuxfoundation.org>
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

From: Xu Rao <raoxu@uniontech.com>

[ Upstream commit 5253aee00a4383cb0482d5e99bde48b8054ae2c0 ]

The mmcblk.perdev_minors module parameter is parsed as a signed int and
is used during mmc_blk_init() to compute the number of supported block
devices.

Passing perdev_minors=0 makes the init path divide by zero when it
computes max_devices. Negative values are invalid as well and would make
max_devices negative before it is later used as an IDA limit.

Reject non-positive perdev_minors values before registering any mmcblk
resources.

Signed-off-by: Xu Rao <raoxu@uniontech.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/block.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index 3aefe2cbc0857..96209860bd1b5 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -3397,6 +3397,11 @@ static int __init mmc_blk_init(void)
 {
 	int res;
 
+	if (perdev_minors <= 0) {
+		pr_err("mmcblk: invalid minors per device: %d\n", perdev_minors);
+		return -EINVAL;
+	}
+
 	res  = bus_register(&mmc_rpmb_bus_type);
 	if (res < 0) {
 		pr_err("mmcblk: could not register RPMB bus type\n");
-- 
2.53.0



