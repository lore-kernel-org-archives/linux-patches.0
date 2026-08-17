Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3822236FD;
	Mon, 17 Aug 2026 15:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980087; cv=none; b=fjn6UaZNx1R8JobJeyBf/ZoKJtHVEUI1nkdgJX1yl6RxnkUwsmfcyGOlPxqhJkRUJdpSMgqG/IpgiK35b8A9U9GuPJWKze/mAb9EmCPjsjOZC1kh3/x/krjgViaHQPSB1eDl0qAAs8hjt8AKlZW+e0EY0pM3AT1ewP5OSVWkSak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980087; c=relaxed/simple;
	bh=9o7W2PwAECRHFM1AIPN2dEOR05CM2AUe6CO2qpcuxhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U3LbrGFVuSQoAYXYzuadBTii/ZyLneWAmDFBnGbvAv4/Xa9ee6lmJxzlvu1YULCOIdMRf+M6kCdrSFllhgEm7/V/3h0qWgCUvCyF77Bi/mSoNbiK3i5leu504W7GuF9uG9ZVSmXlPl7Ecam1GdWvWZvzBm7vcZqOZaipaki4ZJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hjTddj7I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hjTddj7I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D424F1F000E9;
	Mon, 17 Aug 2026 15:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980085;
	bh=8i6LA6bPEb0PAVCoZStSFSKapdLfT0fFK26xoSwq0Kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hjTddj7IKrF5hyNm6LlXjhnk6+ZzfY3fyTgz9bq6K+fmQu2fUAq0m/iFQK2s2p/CR
	 ozCfhk8Yw58NyvRnjIaOBztSsCA/vwX7iMptCpyX60Cji2wfnQpbhPWFYFD6H3NH/C
	 Ra0Vrtw5vcHI4LPk0kJUVnsVLOaRvuRvdujSF1ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Zhou <eilaimemedsnaimel@gmail.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.1 452/609] can: j1939: transport: j1939_session_fresh_new(): initialize receive buffer
Date: Mon, 17 Aug 2026 15:32:28 +0200
Message-ID: <20260817132559.173380911@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


