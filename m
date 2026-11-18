Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017022;
	b=TluoTIDSVj+gi2zpxQzljTbDVyIKnQroX6xN1X9mUCk1hTHsSv/aMHy8+WP5Ak9oF9b2
	 Dd9GxbAPVXojVG+PsgPM5fCzTwtuJftzYC028c5xSOaH9+2Fq7Vc+mXYmr0R3yCtYsWcu
	 qhJHLzEr4zU3H631TMhrPeKh7NtE3dMXBsBZ/sEhBBKhx07VitK8OrVZLsnKg3iOQ230B
	 AX9dVfQT76Topzno3x9jXj8rQ+cg4Xm8VI/mseRKWLQVjtbCJyPN70YHzmK+Y4WfnL5XT
	 qdAALA9OWsHjUYpNprUaHzXx7w3P3XUWyypTH/NGedSHsUDx9+mN302lU8D5WPS+fxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017022;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gILbcr+tmhFkLmVzgNfCSVuwuToXgFStfMnZ7EvS8zw=;
	b=kven/2sI5ziQ5TroQo2H+SKfCK3Die93AzR4e8h6uPk8sXqtqHx/JWip2FqG31rc1b+S
	 OlRugrRjCyKX3WCb2Qt3UomyQCYWBbwn8QwkTfjUsEIh6vUEvxj16ETtEIU7C9wTEVz3P
	 BWDaHkV9+W/HClSBLWF2aQh+JxdxP2sR+0o/XBQtOrL46JvPbHTDVHCgiLXvou0ffMG21
	 kdFp9l96UR3axIotE1HopdAhxfl3s2rLRl0sJeVWFaZilYBzkaBmh4DuKhDj7gP98QAN8
	 ksPiumSp113qRF9fTRA7f6g9hMc5LVnVoxJsnjjDOhZfpLQNT1Yvwyvu2TAOYeiVWGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z1U93bmL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556E4606A320;
	Wed, 18 Nov 2026 15:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z1U93bmL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B00281F000C4;
	Wed, 18 Nov 2026 15:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017022;
	bh=gILbcr+tmhFkLmVzgNfCSVuwuToXgFStfMnZ7EvS8zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z1U93bmLsNsZbj/tie7Sp9xp3mpZ792gA35Y/X9jBfPz4IHMfxl9qqgDKa+O+xy5p
	 QRr1z8ecOuzZDH25acKKb2Zn6Cewc8N8M4UbfKw5q4UNF6oeosAmjC8snzcI3hyxzO
	 DfReSDeIN/CvOmeYYkm2JsLjHwQB3lWCBb5gtVp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Thomas Huth <thuth@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0696/2651] crypto: ccp - fix SFS ioctl race against device teardown
Date: Wed, 18 Nov 2026 15:32:16 +0100
Message-ID: <20261118150312.900781594@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Muhammad Bilal <meatuni001@gmail.com>

[ Upstream commit de4929b47683ed22d8c05f68d2d0f0cfd95b90a1 ]

sfs_ioctl() reads psp_master->sfs_data and caches it in sfs_dev before
taking sfs_ioctl_mutex, while sfs_dev_destroy() frees sfs_dev->page
and sfs_dev->command_buf with no locking at all and only clears
psp->sfs_data afterwards. A call to sfs_ioctl() that reads sfs_data
just before sfs_dev_destroy() runs will still acquire the mutex and
go on to use the now-freed command buffer in send_sfs_cmd().

Have both functions take sfs_ioctl_mutex before touching
psp->sfs_data, so a call that is already using sfs_dev completes
before teardown can free it, and a call arriving after teardown sees
sfs_data cleared and returns -ENODEV instead of racing it.

Fixes: 648dbccc03a0 ("crypto: ccp - Add AMD Seamless Firmware Servicing (SFS) driver")
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Reviewed-by: Ashish Kalra <ashish.kalra@amd.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sfs.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/sfs.c b/drivers/crypto/ccp/sfs.c
index a4777839790b4..530141f8bc743 100644
--- a/drivers/crypto/ccp/sfs.c
+++ b/drivers/crypto/ccp/sfs.c
@@ -111,13 +111,13 @@ static long sfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	struct sfs_device *sfs_dev;
 	int ret = 0;
 
+	guard(mutex)(&sfs_ioctl_mutex);
+
 	if (!psp_master || !psp_master->sfs_data)
 		return -ENODEV;
 
 	sfs_dev = psp_master->sfs_data;
 
-	guard(mutex)(&sfs_ioctl_mutex);
-
 	switch (cmd) {
 	case SFSIOCFWVERS:
 		dev_dbg(sfs_dev->dev, "in SFSIOCFWVERS\n");
@@ -191,8 +191,11 @@ static void sfs_exit(struct kref *ref)
 
 void sfs_dev_destroy(struct psp_device *psp)
 {
-	struct sfs_device *sfs_dev = psp->sfs_data;
+	struct sfs_device *sfs_dev;
+
+	guard(mutex)(&sfs_ioctl_mutex);
 
+	sfs_dev = psp->sfs_data;
 	if (!sfs_dev)
 		return;
 
-- 
2.53.0



