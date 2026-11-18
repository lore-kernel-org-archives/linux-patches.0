Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055244;
	b=ZN9DvAGtqDTKYRNtnnn4PU+nYPZExSl5fxR0+84Bvg1GXEVChw1LEUF2CQwWXNhg/Lho
	 nNJGAh8CtdSGeJ2jjNKdV94XDOCQryzg+fBtCrEmNHIczjcDruIUjEogvuieGC8tKbHGq
	 EmibAyl2aGffA0H/IwndPkMyq/9osGHURnZLZzVWawjhHP1P5lldcTG7omjZCjsGde1IQ
	 ZW9Ehb56ahjt1Szs30MxS/dAkF4M1tcLNzgp75rJhyDdNtT1gET4fUEp6lDDv3z3A1FS6
	 oJMFTQfXW1u4iRkIPkGL3Ry+iqQl/YlM6SjGLd7GhgMOEJi549Vemi+DIIlNAWw+/3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055244;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qpKhRyz7R91KJIlodGStheAKAkUUf4KPeunN2Q4xntc=;
	b=bcDU3ac6UuJnghgpCbRoTHSpytqVxxCD6hZzT7qxjLDrnzk5D/+ngVkoYDcSE77QNRPJ
	 8EputKt4voOT1Q+h8y5TGvlBL+P3Nt+CLyCpyP/wA+vr70Agw9RdGktXBJcsXl9fj3NyC
	 N6ZEWw3rY//bjmoPH8RbI2vrv+se57emDzc2OwZE8m8cAaZktgu7jWIrappF680fi9u02
	 i+X1j9+Qw1xbtKggtBpKCf6YrSRKB7fSZotz7WN4Fs0XXpWbVvk+CXIHR330N5IPJX2gQ
	 NZo1IudgwTNUDA0ADrF2PZPr0wwO2XC42v9vvkWDgqEwsBUvio2h+k2bXkfnIuJUUWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L63wkCuk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2D3606A333;
	Thu, 19 Nov 2026 02:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L63wkCuk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B7B1F000C5;
	Thu, 19 Nov 2026 02:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055243;
	bh=qpKhRyz7R91KJIlodGStheAKAkUUf4KPeunN2Q4xntc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L63wkCukOEIRmDQP6U/lB7upCKhsX0TZkBY/e+4hMCFPyR2X1LQQjVUafw3NPU63U
	 QqyIMt8ZJFTu4YL+CRJ3yucSDK0IEBwGuKliiC/UIgPx4NWCDWEdv4Lg5QbdzbKB6a
	 GsjgnWJojlKCoP8fLvUV2WJ2PgV4H8UYasjYca48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1563/2214] swim: Select appropriate drive once only
Date: Wed, 18 Nov 2026 15:53:59 +0100
Message-ID: <20261118150114.593219303@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit a2d22b3f25c388f9fbce7bf36a45a8900dce4aa3 ]

Before turning off the spindle motor, call swim_drive() to select the
appropriate drive. Remove the swim_drive() call from swim_add_floppy()
because it was already called by swim_floppy_init().

Reviewed-by: Laurent Vivier <laurent@vivier.eu>
Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/370f73fcceb53ce4860904ce6cf4f06ade0e43d5.1788513996.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index c4fca0ed99345..77fe8e81dbb17 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -680,8 +680,10 @@ static void floppy_release(struct gendisk *disk, fmode_t mode)
 	else if (fs->ref_count > 0)
 		--fs->ref_count;
 
-	if (fs->ref_count == 0)
+	if (fs->ref_count == 0) {
+		swim_drive(base, fs->location);
 		swim_motor(base, OFF);
+	}
 	mutex_unlock(&swim_mutex);
 }
 
@@ -753,8 +755,6 @@ static int swim_add_floppy(struct swim_priv *swd, enum drive_location location)
 
 	fs->location = location;
 
-	swim_drive(base, location);
-
 	swim_motor(base, OFF);
 
 	fs->type = HD_MEDIA;
-- 
2.53.0



