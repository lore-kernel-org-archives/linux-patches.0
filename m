Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016921;
	b=UHN9BRUekxdeWf2xkxEeaQMG+WRbgFJgmukl8A09v3hGfH95NyGuNP/dbdn2bJz00XpF
	 WV4NnPZ7J4x0WipLNVQhx1D739IPV8nJcVtT9dxLiebiVieyWOxR2Wjs3Cz7mModWINOc
	 zgPzfikZnTh58BD2AfhRc2q2L7RBkaMMIOQGo4LYUm9wn+cS7nEb4sueqiEOEYqJp9lRn
	 gAmD0gRJ9Bd9m45MvDa9trPiUqp2VS1NyAmyZux7Ps6EK6vf0HUpTIQGPMO3BC1azOTMo
	 tgY2UBsX8wQw2wp+tYgie85NZtimJ4/5GOMdIquFLP/nLlt9oQPqSXL1I+Bbihp1Z5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016921;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cjiesgq3p6IOEvt+QZy9B+tbV625J2c45hVd27Fivyo=;
	b=g5xgHVwzfPVEKpob8M9BdUI+mgId6stXZuQ7iajZKAKTuz/QkDlqiitkDZvnizHjvKxR
	 YoyeVuTHcJa2q4iOLitQ7X5/SeDafh5LjkOH242WHTemr5EIG379xfyNS1BMslfzlN8kq
	 Bo+afzCg91PyZrK8jyleKHeOWmPTbBwtLxQfl1dfq8yGp47MQibna1QbSzKjaZ5s9Qvcm
	 4uKPPGNHCx90a7iSFX26CvyT3EUJdM/rrH7nqRUHXGAs4uhz9lHPj6TSx6nEq1kAcOA5N
	 R42KhnD2Mh6mi0qMppahpz2wKWVu8YFpQP3tvWkzhl2JlE6vW8RwYdZh8qo6HlNbehA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mBO1r9bv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6FA606A31C;
	Wed, 18 Nov 2026 15:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mBO1r9bv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6288B1F000CB;
	Wed, 18 Nov 2026 15:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016920;
	bh=cjiesgq3p6IOEvt+QZy9B+tbV625J2c45hVd27Fivyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mBO1r9bvko18y0A2Zc2y3QpMEifK+QCRvUSGSnG1tuZCEfXNuF9W0BDFI/zbjAEAz
	 czGcyXbujpMRJxYPIC0lFUQNWHKpfjTMjCTNLe3sLMEZ7gxcVq14pQffYMTmgiVyRc
	 a+uqH2yJUpNiACduRxJWotip/DcRweIvT0hIu0tI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0701/2651] swim: Select appropriate drive once only
Date: Wed, 18 Nov 2026 15:32:21 +0100
Message-ID: <20261118150313.071651905@linuxfoundation.org>
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
index 5d89e7813049c..4721e073a8740 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -679,8 +679,10 @@ static void floppy_release(struct gendisk *disk)
 	else if (fs->ref_count > 0)
 		--fs->ref_count;
 
-	if (fs->ref_count == 0)
+	if (fs->ref_count == 0) {
+		swim_drive(base, fs->location);
 		swim_motor(base, OFF);
+	}
 	mutex_unlock(&swim_mutex);
 }
 
@@ -752,8 +754,6 @@ static int swim_add_floppy(struct swim_priv *swd, enum drive_location location)
 
 	fs->location = location;
 
-	swim_drive(base, location);
-
 	swim_motor(base, OFF);
 
 	fs->type = HD_MEDIA;
-- 
2.53.0



