Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017892;
	b=HjAS3lSLnF++WRv/dijkNb+6rPJKm688cZooUeaW7Jq1Uxsm5LtGdB8Be2AyOmeYFHtb
	 aknvOZMjAgteh2PQcoKfd/Xvjn2rCtoQnK5k7SGDC/Ftqoy97efZDFKzqylrrp88VkdCX
	 24ciYkUk2xgjxZlaBNHewBFzKVZ7ZjFNYuJ+yC2OB7uljIG4ATN+aFsyqEIKV4X0RTaPH
	 rDdRNHGOtRhfabDU3LNCInJK+FBgYVx4VmNkntcQmOWBQI+t9IQ1gI0tlmCTpzx3xZZnB
	 GKycrSYZMgs1fG7isxz9m7UQg8MtnaqO43Neb9910bViWgi7w5cOIuhE5hHxI7IbzKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017892;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jVvQO3Sp4xUwfg72VnvYVD01bOzpw5xMIY6SbFn+hu8=;
	b=hf+zYRblmzomM3nNtBRjOSHVX9nZ3htcS8tbhry8vEnQBamin9LaodLuEl/7WOVOAI72
	 R13NBUBkvu0TWlHf3imKwlaVPSF/ggnI613eLCMLlMPCAoCWrxr4e6MqSqNs/pOAKSsm4
	 XlA90VfnLOcHmWIyx2Ak5F9EXOBoZv1+4FZhz4DgAiRSzgTTdTv68pfJrH533e3jGmFpt
	 xrJ7eOiNJZnVOPTGPcIrW6UJ2RwmEf/+zSckRKCD8S4Q6Ps8Crg450eHg8wkqZRmZk73O
	 pW2qfA5LDO0/IBQ3ft/9y3CFD/+MdJ4z0svZy/D6/EFEpPCXsR1UrIsxcgI6ppmihgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nv6Q+nTB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D1D606A31C;
	Wed, 18 Nov 2026 16:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nv6Q+nTB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2E01F000C4;
	Wed, 18 Nov 2026 16:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017892;
	bh=jVvQO3Sp4xUwfg72VnvYVD01bOzpw5xMIY6SbFn+hu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nv6Q+nTB0KW3AtlGlNHtuaGpCpmqcZGbSZiTJ6dECuvicNnsbXttm604PSPBIAqPd
	 9ewb88G7OWMQ5ChoEsNT/Mo6f3qWmn5jX0chxJE18V3vnUzD79LD5g3c8rVCEs3725
	 1Wq5odAwpuigx2+RDtr+mtc9RU3YIBQIOjs+Pef0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stan Johnson <userm57@yahoo.com>,
	Finn Thain <fthain@linux-m68k.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1005/2651] swim: Return -EROFS when opened with BLK_OPEN_WRITE flag
Date: Wed, 18 Nov 2026 15:37:25 +0100
Message-ID: <20261118150324.098838301@linuxfoundation.org>
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

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit d8fe777978a12a96cb5d10d6d888720fcba2da2b ]

Write requests are not supported by the driver and produce IO errors as
shown below. Avoid this by returning -EROFS when opened for writing.

[ 4111.690000] I/O error, dev fd0, sector 2 op 0x1:(WRITE) flags 0x800800 phys_seg 1 prio class 2
[ 4111.700000] Buffer I/O error on dev fd0, logical block 2, lost async page write

Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Link: https://patch.msgid.link/327be6ca3c92c3411b5dfaeede014ed65a2d0f0f.1790641175.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index a67ccd4504b75..d45b789661a0e 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -630,7 +630,8 @@ static int floppy_open(struct gendisk *disk, blk_mode_t mode)
 	if (mode & (BLK_OPEN_READ | BLK_OPEN_WRITE)) {
 		if (disk_check_media_change(disk) && fs->disk_in)
 			fs->ejected = 0;
-		if ((mode & BLK_OPEN_WRITE) && fs->write_protected) {
+		if (mode & BLK_OPEN_WRITE) {
+			/* Write support isn't implemented. */
 			err = -EROFS;
 			goto out;
 		}
-- 
2.53.0



