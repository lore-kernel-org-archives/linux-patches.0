Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024805;
	b=4EGd1VSIR2Y1m+ojui0Etk651O/5QoKXJSNTkoLVeXIc9kIc192txZJihN3+PRCNilDa
	 NytrC9RtrYe5hVwks7jet5r4XVC5c72DuOAEXPA2JDinB7JsDOxiONAAUghYAc766VdqU
	 j+dLgs1hopbP63DgU7qEXIVwIGT18ggTWBZbe56o0AO7+gXVa9VS8fnuh2hZLXeptkb6n
	 9+QeYl68TuniNqwYIp5xJU0AJW4HMQHVxNilkDSUvu0RtkOhvEPUL+RY1dgTsVg512WfJ
	 Rh/VVlJQSZtFJWVe1eMh/GsXVxAZ3X9A23euD+l/sUmQdZJ03jJ9Pzvvoo/fFaa5HuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024805;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2t4EZhbvJeXAp38hdlkUJKNK76vr9PARICdZ37BFfaY=;
	b=pa73bbGObUlbBdrq2EFcwBJYeTu29l9Wgim1Lv0sygiCuGvdwLaez3rZy8e/IzsQG1uy
	 E1vFcKr6su23RBTXiS2i5id7YBioXIRUjYhspdjVMosaWgR29Yb7SMOOY5QcIvskvSehC
	 +42Bva8iSR+mAndqT4F9zXGmlQphLu9K/CW9jQMRCiDqK55oUBKvYT3l4ynzy9xFAb/Jh
	 WK/HBH3jrlORYsp9x9/PZKf0YZazD6BO7CnxEGvUIx2ckp9gWeegjsCI2IFpxSuu8Xeqf
	 0IMGY1g+k/nUS1PPDLytEj1Rq0zGzYvVceZUNsqFYAZXgaSTplAq5kp7JzCsU/SPG6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T7hKYhfh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0016606A32F;
	Wed, 18 Nov 2026 18:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T7hKYhfh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32AD31F000C4;
	Wed, 18 Nov 2026 18:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024805;
	bh=2t4EZhbvJeXAp38hdlkUJKNK76vr9PARICdZ37BFfaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T7hKYhfhufJph0DgSjKWAaYElwCz7vpm1jTWpVPcO0jn/gsYDIRgp79tDy5GLvx7N
	 YuF7QtGrNk+H7VHqh7RrEgXizeilqg4lbYbZAUZIKUuNapnDiMg6sGM2BRGbk4qral
	 OeSWXJtmgqzM2TUhDSnsptW3fxinVx/jcit+ArzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stan Johnson <userm57@yahoo.com>,
	Finn Thain <fthain@linux-m68k.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0854/2151] swim: Return -EROFS when opened with BLK_OPEN_WRITE flag
Date: Wed, 18 Nov 2026 15:43:09 +0100
Message-ID: <20261118150153.357555071@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 2fdf36868155e..9057dca830c5f 100644
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



