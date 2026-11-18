Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052428;
	b=UsmOS/OIZ1b0IvTTIo3FwcBHQyzalGjGvSqRG9F2a2O4OEOAG/Sgu0Xv5X/dGC0mxgzO
	 YbnbIQ4kMYwMHbxdbywuggBxMnqmhKk1UVKTUzfb7WxEk3JTZNZF3TV0+WoOO19mBs2T5
	 MSBX4PfTNy9hmQsDRuk6Iaejh3T0SeUdZsYrNL/mMKu8PBamwQL3lbVdQjIUOo/ErGaD3
	 kdtZAz56IwRNbyysOpOrOIKjhNaElyM3YU5HKfQZ2XaFMkUPr7xFNqm6QT7VB/e15zKE3
	 YxGcsUSavYCq321kbpS5PWE5NhrswQmdUeS1W2fymH1vFjR1x4wVcuTZWGx1kPg4GHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052428;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PsO20nzX5RC66s2Ubi/Vy0+0pVPNJZxIrzdJh9ljYsg=;
	b=NdNdyDoLwAYZ3d7XW6NnQIWg90yn/+X5mDzJWFHpMIU0/jVt4zm7FGzUDCo4qj1tJhs1
	 mRrGBx88crIJ0RWvzMLnpioIpXHNpp4RIR+Skw1Fjkt62Xjk6cKK7VMYIn1V9CMIu8z76
	 1ozi3nvdv09sgxRg6WaaOqZOYB7SXmDgFDpxL+XQb2JiUMEmn+inaQTjhOs6eNn7FR+6r
	 PhbQU2cvI/W5OSsiEfiiqH/gLidCEgNEW4uCpLCsrX0Iut1J3z8C0q1ol8e71HHX72Ikm
	 079TM+fXZCUyh1lPqq4MdlSG4TGWlAdn/gfWcEzC5L/uQKam3Z5CpnVsGXmamEVRBjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qNCC2uNX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11555606A320;
	Thu, 19 Nov 2026 01:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qNCC2uNX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61BE11F000C4;
	Thu, 19 Nov 2026 01:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052427;
	bh=PsO20nzX5RC66s2Ubi/Vy0+0pVPNJZxIrzdJh9ljYsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qNCC2uNX9+ABH9hSQPGnsFfddhlPeb9+1GX4D8SWkffEBLKbHHPRhzP94c0lKnHw4
	 bKslr9t6yhZ6+IMSjQd5CAd25O03w6w6eWESK2UNLLIXDW9cVPPLT0GJPfzolyHfn/
	 CNcuxINGlJc2KPnAAqYOsVoBUZm9b/cN1ZF8PRI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0559/2214] dm-writecache: report I/O error if flush failed
Date: Wed, 18 Nov 2026 15:37:15 +0100
Message-ID: <20261118150033.373118102@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 78a6afc2999d26e5a30a56db77db34c22b88f5d5 ]

There was a bug that if writecache_flush fails due to I/O error, the
error is not reported in the FUA bio. This commit fixes it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: opencode:big-pickle
Cc: stable@vger.kernel.org
Fixes: 48debafe4f2f ("dm: add writecache target")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-writecache.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index dfb55fe09ce13..8d0aa6f90e94e 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -1481,10 +1481,13 @@ static enum wc_map_op writecache_map_write(struct dm_writecache *wc, struct bio
 		}
 	} while (bio->bi_iter.bi_size);
 
-	if (unlikely(bio->bi_opf & REQ_FUA || wc->uncommitted_blocks >= wc->autocommit_blocks))
+	if (unlikely(bio->bi_opf & REQ_FUA || wc->uncommitted_blocks >= wc->autocommit_blocks)) {
 		writecache_flush(wc);
-	else
+		if (writecache_has_error(wc))
+			bio->bi_status = BLK_STS_IOERR;
+	} else {
 		writecache_schedule_autocommit(wc);
+	}
 
 	return WC_MAP_SUBMIT;
 }
-- 
2.53.0



