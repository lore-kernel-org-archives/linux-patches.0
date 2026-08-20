Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C043746D57D;
	Thu, 20 Aug 2026 17:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247771; cv=none; b=OZYlP0qFiruDskmaN00PSnwF6IN2I/hd6O/Kfpgk/klTcjpM5pTJ68IPErWBP7F1ROk213RUwO1/eomHoWRqkV/q23rgRu5yOdkpE8xYlbsylvNQk/RXIrgj5DAsQKC6ucmaJOUErB6eTZ+zhirHEL37JUD5cTTeOpdUXAlNfuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247771; c=relaxed/simple;
	bh=gFUB2Lrikj6KEOCnTjceKuF/SNUjRVG/Ua9T0OJli2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kvB3PVUZRhIZmLWKOQx1MriKLLdxasKp5AOQgreB47PNi06fRfr6p1Ih1n9a3W/mlwNyr5g4xyzns9rje24nkvg3bR48QEhuRQplAl53hNXKL4h0UnpMOGEwo8bBhkxk7CR7cq9Hc27s1+1BlMXGoV0DYKo3Z6ZOH7uNNIJhVU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TKguk5uS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TKguk5uS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F34701F000E9;
	Thu, 20 Aug 2026 17:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247770;
	bh=qTRYY9MGGaNKZpYMkd2wxRFLY/yNAVAQw7KYs0LDknA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TKguk5uSC5Kj0qHiOnrm/4+NtXVIXoixw++aUcqfNOS1KPgLnuhjWBorl+ywCShpr
	 kYiFCPfaYsnx15YNyz2JxvTHcb68AYRptneSL57au5vEjG6pvOl64cgj7Nzyh8llQf
	 S49CH3y8les5zmx9Ahfd4u6MeR4GL5mlWgyEQdRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 124/166] i2c: bcm-iproc: remove printout on handled timeouts
Date: Thu, 20 Aug 2026 16:56:23 +0200
Message-ID: <20260820145214.894414612@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 796e2c260187e32530cf343546ba1cdf2e2f5491 ]

I2C and SMBus timeouts are not something the user needs to be informed
about on controller level. The client driver may know if that really is
a problem and give more detailed information to the user. The controller
should just pass this information upwards. Remove the printout.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Stable-dep-of: 98f2e9e6d6f9 ("i2c: iproc: reset bus after timeout if START_BUSY is stuck")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-bcm-iproc.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/i2c/busses/i2c-bcm-iproc.c
+++ b/drivers/i2c/busses/i2c-bcm-iproc.c
@@ -811,8 +811,6 @@ static int bcm_iproc_i2c_xfer_wait(struc
 	}
 
 	if (!time_left && !iproc_i2c->xfer_is_done) {
-		dev_err(iproc_i2c->device, "transaction timed out\n");
-
 		/* flush both TX/RX FIFOs */
 		val = BIT(M_FIFO_RX_FLUSH_SHIFT) | BIT(M_FIFO_TX_FLUSH_SHIFT);
 		iproc_i2c_wr_reg(iproc_i2c, M_FIFO_CTRL_OFFSET, val);


