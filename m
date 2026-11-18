Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015947;
	b=kWkLKZH7wgPQEuWBvjm3+d7K1dRr5BwrobW2fzOlGXkHpi2vg9LbmQM2DVCW8PnHKL3v
	 0OZf6vBPM964S23EinODb1fIa4m0kG80sdIlBXC5UYBHc/3KqY9cfNzzBwii19myZkGIh
	 cSxlnIEiwCzpAn16nRcMnkXTzyEms4MJpEvGH0R26V0D0QE6UgVoQy4WATv9BBx7xodKB
	 klqn1ei2bkJWrWQmqUI/0d9/Y5zkOLeCBC7ibvGiT5vZw11veMAvt2prIP7cW8SK0BNlc
	 BTH6tlHlFJ5gOFZb+QUfK/EVR1TwrN3+5Amnm9KWkGABMdgTW7NLpJksoLlLOZt26rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015947;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U11Q247YRHJDkxrZmeVNs10Eny7TvfSqcdI4lUkCb6c=;
	b=P445gtLnCua61z1FBFELC+EbZovARuvnOxyssYF7EWYzk+ORm3TegRxN1rC7ydXjhWj5
	 gziZxL8nwqlyNOHKKI+XCrnHqNTgwUnQ0WW1VH8CzKF7vO7sgbHXUt6rRJbHV16B9+TfQ
	 LugabGyfDlv3IfHsP71r449y6UbayhB4lh9JjyuRel6guLJtrfszp0APjuEKQ/WXmEpTm
	 DdZK3q37jFDNaejXRe6lFOQtTtqkja2crcYRpgAp9BYZAhbWs9hYk9KkzvNsjNaPRa/e5
	 ABwkK0WwHq2OdYiWzYQCx7ntqB/mrGXm+90gpYO5UXowqiN4Dv9zvwUflLYHCnpeMKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yvaRMP0g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B88C60A2608;
	Wed, 18 Nov 2026 15:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yvaRMP0g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E47F1F000C4;
	Wed, 18 Nov 2026 15:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015946;
	bh=U11Q247YRHJDkxrZmeVNs10Eny7TvfSqcdI4lUkCb6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yvaRMP0g9ow8F6xeQmmC/qF2TRFaTxlXGA94YKztJoXMTeuTNMmSrFFBDVPyQlgf4
	 S1fzxrg0XmyK5wHvLgQ9dV9flOuJAaiiG7Wk7V+LfVopzRvu2r8YvTgBE087X3R6tK
	 jHVREUyUTxmzAL2RXGR1Kpbu3HfQu70Q5q7Wt8T0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>,
	Oliver Neukum <oneukum@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0355/2651] usb: image: microtek: stop SG processing after transfer errors
Date: Wed, 18 Nov 2026 15:26:35 +0100
Message-ID: <20261118150300.618933048@linuxfoundation.org>
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

From: Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>

[ Upstream commit d937ca39cc44a01ce64865dd25b1e205a05ae3a0 ]

When an SG URB completes with an error, mts_do_sg() calls
mts_transfer_cleanup(), which completes the SCSI command through
scsi_done(). However, the callback continues advancing the scatterlist
and may submit another URB for a command that has already been
completed.

Return immediately after the cleanup so that no further processing is
performed on the completed command.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>
Acked-by: Oliver Neukum <oneukum@suse.com>
Link: https://patch.msgid.link/20260723195654.152104-1-diegomancera.dev@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/image/microtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/image/microtek.c b/drivers/usb/image/microtek.c
index 1f0b3c44d3881..787cf5aba55de 100644
--- a/drivers/usb/image/microtek.c
+++ b/drivers/usb/image/microtek.c
@@ -475,6 +475,7 @@ static void mts_do_sg (struct urb* transfer)
 	if (unlikely(status)) {
                 set_host_byte(context->srb, (status == -ENOENT ? DID_ABORT : DID_ERROR));
 		mts_transfer_cleanup(transfer);
+		return;
         }
 
 	context->curr_sg = sg_next(context->curr_sg);
-- 
2.53.0



