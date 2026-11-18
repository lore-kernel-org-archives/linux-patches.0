Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060986;
	b=Q7VDzCbRkApHHlIAIJwv1yoPLJ+OFZg1b1fA5XD7pWPCPpT6tX01TGUCXeeQP2+nCgNk
	 7wXcaarV4m/uVHvbtIbCIJkCV8VzIEHSK9qfB4WNhB09o+cDUh+W0UkkatUNnL0vxcO/L
	 qGSWnWN9JhfQ8L82ZGsOzgY3lBMKliP7F3HVtw/msXxlL4hW1COQU4x0BTvez0sVha5wA
	 Mjd3APKmhOXKVolTWRZbIltKjFxYJwEoENQbx4qRrFBY8zdzL0iSzBzDptuUohPB8bcpr
	 aBqXwAIsXY9duprK97HtG6uGk6G+Zh5SNuGoVAaWmndhrZmZ4wOndLYvOWgvkrbzthw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060986;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xtr22UaZupd4Pstmc64vHsQSssHYXv4cPDsJpprSs4A=;
	b=roGrHmVkH4Xo7KVaST+y2k9Y0mE901joEdgwHOBJ80ph3TbujxXEW7TFTpjyRPwfWESp
	 CuEHurB2SfZIEsj76tdv2p8mYfET1J40k3ZYUSbHYTe+oz603KEziaDPH660NkjLnzPS4
	 HN+Uu9me8Y/8259mEqB2ViztycE5+ImQ6SH83pnx+LRhaikazndUBEWDFsDHxk8DUMqZR
	 rlosRGbw7SxsAvj3SlFrI+g9/s9JTqGDXWaZ+XlrjqXQ1t1hBBwrAAlN2oVmXD5YNG8Mz
	 vyZYdTfok4EapBn1C9+dkQthbSy4/1pmDVOKXgZ3yCsKBnp1+NUrEfUDyxO8XI8kgTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sSPBJRXD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A709606A333;
	Thu, 19 Nov 2026 04:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sSPBJRXD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54BFC1F000C4;
	Thu, 19 Nov 2026 04:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060985;
	bh=xtr22UaZupd4Pstmc64vHsQSssHYXv4cPDsJpprSs4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sSPBJRXDtDPZljd56LDUTdEimAUO4XWySCNH3LpkXfKyOiY3POfdVkKOPHxpxXVp9
	 Q7bkf1McqQKi4kq26VUX7222y48Nbf/EUVd6k7RiI/IIEZYO5FqNMKYWB1q8+W5GDC
	 PcbRxCIQMVS4An/wb4KdBk0OrtMzpeDna/c1qZIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stan Johnson <userm57@yahoo.com>,
	Finn Thain <fthain@linux-m68k.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1395/1848] swim: Fix FDEJECT ioctl for exclusive open
Date: Wed, 18 Nov 2026 15:57:13 +0100
Message-ID: <20261118150017.917299604@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit c76b93df9ae61d8ddebf6aa3bc218252f85e80c6 ]

The eject command from the util-linux package does not work with the swim
driver: the drive doesn't eject anything and the command fails.
Apparently, ioctl(fd, FDEJECT) returns -EBUSY when fd is opened O_EXCL.
Fix this by checking ref_count for either 1 or -1. Either value means that
the caller is the sole user of the disk.

Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Link: https://patch.msgid.link/ae3ee8e86833a2739d7857460cbe2addf4146088.1790641175.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index fbda85a2cfaff..0bac8ca0fff73 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -711,10 +711,11 @@ static int floppy_ioctl(struct block_device *bdev, fmode_t mode,
 
 	switch (cmd) {
 	case FDEJECT:
-		if (fs->ref_count != 1)
-			return -EBUSY;
 		mutex_lock(&swim_mutex);
-		err = floppy_eject(fs);
+		if (fs->ref_count == -1 || fs->ref_count == 1)
+			err = floppy_eject(fs);
+		else
+			err = -EBUSY;
 		mutex_unlock(&swim_mutex);
 		return err;
 
-- 
2.53.0



