Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C5C1E3DC8;
	Thu, 30 Jan 2025 14:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246856; cv=none; b=HtNtqPkKLylEXw1cd+dGxjBerZsgCpg0Y16IsoEW1NQG8xQgw8WevEE0pzNcZ+5JA77pGZ2G4W7NhrcHwzu0rLNH4Bp5Fh66uYomhSnNtvgAnlRPUfKAmjZH1mVEYECkvP/NvBaIonF9eMLN5c5w8aH2wvgbTWkXEniKyhy1v80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246856; c=relaxed/simple;
	bh=X2fLsDDlOnntThAQ/+aqWGPseSdfo7RwDLcPkSxVVqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XZ5BAD5iQYP+mSpOIlSslVjjave0q430fFQxj771m+fGeGEBJ1wqei5T2jYfavIhhxVV8cgdfwECnC3Wl/TBCksAkkLmuGhouvpGdvidMq87q4IqEMaPvTx6EWVTaZXPyjId/tzx6HgHe9U89vmniF8JlOirZeEsHmr6DntJhgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ku23Soes; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ku23Soes"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D060DC4CED2;
	Thu, 30 Jan 2025 14:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246856;
	bh=X2fLsDDlOnntThAQ/+aqWGPseSdfo7RwDLcPkSxVVqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ku23SoespHO61trxoABwAnE6geQVPa6Zwv+lV6T3Ng5e+/ZmXy7gbSUQa7Wn+Vsig
	 y4onfBfXgpRiLCTyyNsvZL1963GNqu1r6CAlSpeYTvn21G4/fjrvgqMDxNm00pzI4P
	 f05eddYFIgBKEJ9pefIdsZwEOiavixQopW5jZRbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Greiner <jack@emoss.org>,
	Pavel Rojtberg <rojtberg@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.4 91/91] Input: xpad - add support for wooting two he (arm)
Date: Thu, 30 Jan 2025 15:01:50 +0100
Message-ID: <20250130140137.342074222@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jack Greiner <jack@emoss.org>

commit 222f3390c15c4452a9f7e26f5b7d9138e75d00d5 upstream.

Add Wooting Two HE (ARM) to the list of supported devices.

Signed-off-by: Jack Greiner <jack@emoss.org>
Signed-off-by: Pavel Rojtberg <rojtberg@gmail.com>
Link: https://lore.kernel.org/r/20250107192830.414709-3-rojtberg@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -345,6 +345,7 @@ static const struct xpad_device {
 	{ 0x31e3, 0x1200, "Wooting Two", 0, XTYPE_XBOX360 },
 	{ 0x31e3, 0x1210, "Wooting Lekker", 0, XTYPE_XBOX360 },
 	{ 0x31e3, 0x1220, "Wooting Two HE", 0, XTYPE_XBOX360 },
+	{ 0x31e3, 0x1230, "Wooting Two HE (ARM)", 0, XTYPE_XBOX360 },
 	{ 0x31e3, 0x1300, "Wooting 60HE (AVR)", 0, XTYPE_XBOX360 },
 	{ 0x31e3, 0x1310, "Wooting 60HE (ARM)", 0, XTYPE_XBOX360 },
 	{ 0x3285, 0x0607, "Nacon GC-100", 0, XTYPE_XBOX360 },


