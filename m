Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA4F27466A;
	Fri,  7 Aug 2026 15:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116273; cv=none; b=udMYXxo4tXnoXWLf1udoGniGr/xfyTKuAU6fNTiRISs6QLnF1xjmRCmqB226L3BfLxxjEdME+Yv41J9yLiMaoyYfpg/Wsqzw01D3+UxPOJCVCq46fneQl7ldpsV7i0HqoU7jPgSvWByiIIrWq66cWjTgPaulJhRNnvpeqFvWTB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116273; c=relaxed/simple;
	bh=f82hZG3SjitlXMrczT2oF+N+83tHIqxKHgqzJf56PjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DRFeBse6arouHKhnCNFgJVLx7UK8VHjBjXLbpSLfdbxHKpXfM5m+ERPuo5yq7ADDOAmXriq4suucuKaP8Sm2C8r5Mr9dMKDn9L0jrJqavMjjpFa1WwlUVLbR9TjKwxTo9zCG5JM9+mtVLmWElnAutkUOFLqZj3bVQEGx4topPjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZwBjRCIw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZwBjRCIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46DCC1F000E9;
	Fri,  7 Aug 2026 15:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116271;
	bh=15fYK46KoDJempF5E+3DXXXd4X/Q2pi6O6K0fKMSO6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZwBjRCIwW1+X5sr044Pd5cgDYKaG44Tz9m7ymrZQvK8zi7fy1YWWtix6c+715hg/N
	 1AJMSQttY49kd2ZkxnA+roWZS/GRyDtcBoyKFdH4PxQ3em60cAWlC4DNmqjYNJlHD4
	 hHQ43kGmicL3EIIviVoQgfD2+AFKkEeM4Suep1bY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Zhou <eilaimemedsnaimel@gmail.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.6 174/261] can: j1939: transport: j1939_session_fresh_new(): initialize receive buffer
Date: Fri,  7 Aug 2026 16:38:51 +0200
Message-ID: <20260807143419.120022754@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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


