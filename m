Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029929;
	b=kgaLUHxESClZPvNbhe8ZYqMrJf6lIX4v+1+iZ6FtrFYM1ceaqm75CxGckNr4OVQLXrW4
	 mP+jGIpGaUO262I7vZtZQYgwqjrDZAVeMsV89KPM1sRAJ57P535j6JLJWLIhhLz7kGFQb
	 raK/XKMBjXlJtrBcBF/1urH9ykqAmp+qbP9xQgf2GukvYHajvY1s66eRyStSDGJYRbC9f
	 3o2OYXer0t28oGqtFDZ+VNL5d3JXjzoFUE2Y80qBIKXkQzmzFzJkbHSQUpMSH8zCOy6MC
	 ucRPLbnl/Vcjl6uXZcFFBv1DrK1eMcrf3QEPNXw0MrFcaLhcqpVvZrRJLsMH3aLm22w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029929;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LHOYoh8+HLphS8NQ8alWWqk4r/XdMN+shg3kUB0xtQ4=;
	b=P0nGGP9EIfJERFLrzVJUYauKQXeP41UWYZpZh/fGT7nZeKU/Se1sR40xxhzLcxwrEWYQ
	 seMwf79OA8sF+IjAdCXgSoRBm9H6sinF9jR9EhOvSEZ+wlMw3mlwo3F0oAcOdEsD6UUsa
	 OQKJZ8TcRpKfUdgusouNztdgOQwa3KJS5pw//HppHgsmzSptRqsFAU/qDsjid+S9NIeEb
	 NJTqotcJDjtXx3mUhwmkRmH5tOPxebvKwybZTmNh/PRkrgOf0G9ipA6YSA56S37GBl9vX
	 C6Yj/e0KRN1uiHoYzghQxW0wWu+65M52HsbmGVne2p+EYNT/sCZtiGqHqAp6CMaQcGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aRYE9d+g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0682460A2630;
	Wed, 18 Nov 2026 19:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aRYE9d+g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CB6E1F000C4;
	Wed, 18 Nov 2026 19:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029928;
	bh=LHOYoh8+HLphS8NQ8alWWqk4r/XdMN+shg3kUB0xtQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aRYE9d+gREiaxRdcdTHwKl/09qauTgiNiFlAS4xSpjQdvwvfP/MPha7yoHjzkEq1o
	 3MVAMHpiTEMvi5psTbmoMk4G5ZqZ3iSt16t97zG33mS93Nv8gAN198J76XcmH79Vin
	 k4JNtykAq5lUq0CGEpSYzyOuQEwkut5JRspGmgYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0525/1756] swim: Dont start motor until medium is present
Date: Wed, 18 Nov 2026 15:44:12 +0100
Message-ID: <20261118150030.037141216@linuxfoundation.org>
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

[ Upstream commit dbbaaae83cb277d76e70426c0f0ce289e867ed77 ]

The spindle motor should not be running when a disk is to be inserted.
Don't start the motor while the drive is empty.

Reviewed-by: Laurent Vivier <laurent@vivier.eu>
Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/7ea60e0bf6135b9bcd4be0991a257d4c5de22bb3.1788513997.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index 645db47c827c6..7178a2bdd0777 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -630,8 +630,7 @@ static int floppy_open(struct gendisk *disk, blk_mode_t mode)
 		fs->ref_count++;
 
 	swim_drive(base, fs->location);
-	swim_motor(base, ON);
-	swim_action(base, SETMFM);
+
 	if (fs->ejected)
 		setup_medium(fs);
 	if (!fs->disk_in) {
@@ -639,6 +638,9 @@ static int floppy_open(struct gendisk *disk, blk_mode_t mode)
 		goto out;
 	}
 
+	swim_motor(base, ON);
+	swim_action(base, SETMFM);
+
 	set_capacity(fs->disk, fs->total_secs);
 
 	if (mode & BLK_OPEN_NDELAY)
-- 
2.53.0



