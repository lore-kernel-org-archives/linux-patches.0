Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46DE146C839;
	Fri,  7 Aug 2026 15:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114972; cv=none; b=pltPXe8qiALeIWGwj/QZ6Ebj5jV1FXlzFAeB4b8n7SpZTP0SDHkVJsNrJNnqxO3V9P9Q5ne8m5C2vBTqO6gZXfxChtGgv+i0V5xWK5knz06mSX6PdvKzUkpvKpeZLHQYka47LrvUDUINlFeGGfvuRbbAHIYh6ADMv+ebXOGy4sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114972; c=relaxed/simple;
	bh=sngmWIQ46kg8ye4m2tFKfRhqlyFxnwv5kIx+S8P6IZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QRMwyLgZE67wfiDPd2K9yRX1QiRMtW1jdWEAKGgn3alr0IUHQrRe1caGzEDYVhrhqYxM0+aiZgUdumVjy0Kxc9KLwHDrJ30I365qvqa0tj9OREupPUBhJfry6Fy+6s5vIabmTC9igcc7QBBSuy2sMywyNVpMbghUrku33pr8RFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mxby3jb+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mxby3jb+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F911F000E9;
	Fri,  7 Aug 2026 15:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114971;
	bh=h9wmR0zp+z+7xDR/Mx9pD8mTQ7WWENP+/3SGw4aJyeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mxby3jb+WZjY7dUQaxLwi1Ghfpr5W2mXWhJ/iKiV38qoMlFrMyD2WBdbDfuSeQW4m
	 MKDIjr2xVdAh0uW3l1Mgg0o6eizMc7sJVFe12+4Rwl+Ij5OFCMDWNOX14y41vUyRvo
	 Dd96yrBwJMfPaoqa5gZtBcAb3SpxCH+aKIc+qRb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 112/396] Bluetooth: ISO: fix timeout vs sync_timeout typo in check_bcast_qos
Date: Fri,  7 Aug 2026 16:34:32 +0200
Message-ID: <20260807143426.710878814@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit e9cb51813d79fc9aae4a2098aab3ab6ebd7fb6c8 ]

In iso.c check_bcast_qos(), missing bcast.timeout is not set to its
default value, and appears typoed as bcast.sync_timeout.

Fix the typo.

Fixes: b37cab587aa3 ("Bluetooth: ISO: Don't reject BT_ISO_QOS if parameters are unset")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index d667cbf8a1392..a0ef76ecb80b8 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1709,7 +1709,7 @@ static bool check_bcast_qos(struct bt_iso_qos *qos)
 		return false;
 
 	if (!qos->bcast.timeout)
-		qos->bcast.sync_timeout = BT_ISO_SYNC_TIMEOUT;
+		qos->bcast.timeout = BT_ISO_SYNC_TIMEOUT;
 
 	if (qos->bcast.timeout < 0x000a || qos->bcast.timeout > 0x4000)
 		return false;
-- 
2.53.0



