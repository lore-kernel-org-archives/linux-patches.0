Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CF6429027;
	Mon, 17 Aug 2026 14:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977499; cv=none; b=ltI5OE+4xYquQd2+e7YVIzliVvxGnsn3XICjj8hlGRgVVCMZ5Xu6VI0CNp1CVPp9uF1H9h33x17YTj5/g0yPTsSuNX6umvd/2MoEolL2+8xgEWuSE/XB0y9R7UNRIdSTmNNmGUtpQJ7pa8O7iwXaSFt4p6BqFppTuOiC3DEmw0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977499; c=relaxed/simple;
	bh=97XoBLV50Lv2S5AIgofH+IYG+cxP86sKNj2yLSJu1uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IWvBR5DbkdUAISvujV+NVs+5i6bCzV6gjGPbdEwwkguBl2RPJkwdnH0gjPV27h5d7iG0DcC/dscebWmmF4Ew2p8k39YrlbPsvc4Fg/VVV36SzyszI4o+Ho62JcGAqzdyMlTMaZBkdWvXiY6LEtNy9oBfGrzc5KZc9vZ/u14SJb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bJtLOszX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bJtLOszX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D45A1F000E9;
	Mon, 17 Aug 2026 14:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977497;
	bh=yRpwSyRTvPIoFExBp19dqcXnr7nPFh2qWk9qtJY37xM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bJtLOszXbi3xSso90DMNGaUPmq+DjMxuXvUq+425++mFUA6FKvUmI90Iv5cwIS8At
	 GX7YZXc+Vxdx5xAEptvB94mIa+l5Mm2qRENO8u/UhBqf7lyfl+2JgHy5OWxb9zxW2r
	 C2Wujw1N/apcBiz/p6szv5fUuk7qTuL5PKv2YoOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Zhou <eilaimemedsnaimel@gmail.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.15 349/456] can: j1939: transport: j1939_session_fresh_new(): initialize receive buffer
Date: Mon, 17 Aug 2026 15:32:19 +0200
Message-ID: <20260817132553.202671956@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <o.rempel@pengutronix.de>

commit eb96c58907922546e415e545fe9a14ea63b02719 upstream.

Zero the allocated buffer in j1939_session_fresh_new() to ensure it
contains no residual data.

While there is a potential performance impact if users allocate maximum
sized ETP buffers, most real-world use cases are not noticeably affected
since the maximum known buffer size is typically around 65K.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Reported-by: Ji'an Zhou <eilaimemedsnaimel@gmail.com>
Message-ID: <CAPAUci5dykCLjoijqkUtFqJFesgncrD7+S6y_V=gjbFkY2Tifg@mail.gmail.com>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/20260728055835.1151785-3-o.rempel@pengutronix.de
Cc: stable@kernel.org
[mkl: add Message-ID]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/j1939/transport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1562,7 +1562,7 @@ j1939_session *j1939_session_fresh_new(s
 	}
 
 	/* alloc data area */
-	skb_put(skb, size);
+	skb_put_zero(skb, size);
 	/* skb is recounted in j1939_session_new() */
 	return session;
 }


