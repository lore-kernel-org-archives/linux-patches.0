Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030036;
	b=y8vx+KPjXwCdozufVTvCa+2W5zQE53QPMKp2mUodulJvTxKNPm7/BK2lN0seFSqA0WRW
	 dOiAkRjooogJlWu2KOvnxRpVmi1hnrx3hDG9H/mYpbL4VYIQjC+WFzRKwIQokORyuZvLV
	 nsBzPIFdvvTAeOoNWJr83nQq6xRSxC8yIut//ZqElLfxurXR/Sbi1GjewQ2+YrNu7Rbd1
	 4AHavdNfb7WMIN0b2xrlnLmELBhtj8qrXKKoDHK+pJ1htTyCMDcb90BS027RZsv1F3Chz
	 ox3vE9D57v1h+tSHTakGbRiDYguHXxJNYzCavWBiQCXIEIXUhnQaC5OEkn6RapuRW0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030036;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r2+37VU5KqAR882AwFej2zF0V3oYisCtUBHItxmyiHA=;
	b=umZ5J9rsFvgUuO4ZR0PTUSWyv3sz8CFLxj1JQidWtvUz1sE0pNE0KG3IPkCLIr0cb1K0
	 7ugZNXgxWjMNNyOuy+qLNjuhRnrb6RYAgKyQZI8OKvot5au54THDaHKRZwuWDFZ/nn9ya
	 No6ZaLaxbPYmg1H6Y5H1dCq6X/cdTNPDtW5W6vZNHenVxEJIIjhjldmTu8L3eFEdm4as0
	 XxDQivpJnk6Iq/7wzgpB6nm+MlrbGdlFLeW/1PN06NZsbUMJGXK6pjtTcXalidzAbPsyn
	 IC2pmDSJV/3VImjCFCgCqH4eXWF3s9koNVnsYhTxU+yjDZlnap8mKQyn7twJE+JDb0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H7tP4gqC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8B4606A31C;
	Wed, 18 Nov 2026 19:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H7tP4gqC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C941F000C4;
	Wed, 18 Nov 2026 19:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030036;
	bh=r2+37VU5KqAR882AwFej2zF0V3oYisCtUBHItxmyiHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H7tP4gqCvLLeDrx9ILw1ZMJrPlrj/r9wrMOMkssVzpX8DTgIdu+33Kd08xUDSH5cl
	 Bw+U/8/GarqV6O48rsqCUQwH69JZmZWFppt2/muDAy9dpE5fWlVNVFOvttuERFqCsO
	 lwz7kwD00f4zq9r4Is2qpYm2OsqrUCwVn2XfAbqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0520/1756] swim: Dont disable drive after every sector
Date: Wed, 18 Nov 2026 15:44:07 +0100
Message-ID: <20261118150029.863411008@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit 05a7c4b197279cfb3ec3df26146ce085a2438aec ]

This fixes multi-sector reads on a Sony drive. The Mitsubishi drive
doesn't seem to care either way.

Reviewed-by: Laurent Vivier <laurent@vivier.eu>
Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/fc511e72753ae18b6f021701aa00d480335b0caf.1788513996.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index d69dfd6a824a5..6f40b057032a8 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -473,8 +473,6 @@ static inline int swim_read_sector(struct floppy_state *fs,
 	short i;
 
 	swim_track(fs, track);
-
-	swim_write(base, mode1, MOTON);
 	swim_head(base, side);
 	swim_write(base, mode0, side);
 
@@ -490,8 +488,6 @@ static inline int swim_read_sector(struct floppy_state *fs,
 	}
 	local_irq_restore(flags);
 
-	swim_write(base, mode0, MOTON);
-
 	if ((header.side != side)  || (header.track != track) ||
 	     (header.sector != sector))
 		return 0;
-- 
2.53.0



