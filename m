Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A67435EF2;
	Fri,  7 Aug 2026 15:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117576; cv=none; b=JrOY8LjFvAEwqMiwrrdKCqt7BXzOg7p4UZPMzWvHHfX98e7CGyDZiHY0aUnzI/swvQRjLVI1Y4YPuGGl06bzM1xFsYI8Szadx9FvJkuLSO7ZJqUSE1N3ouPU3z6FrtYeBEoivOtBifAAkMH5n638roEMKJCoiYYFl1dc/XEkggo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117576; c=relaxed/simple;
	bh=7cIyf1E100I3tJ8E+i7yBeTJ8Jt4o9wIwzRRG1ZnGyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mizQE50XWJAI771IYJhtrObKInJVKZPvrere1/m/y9NZVozkS4lDz6ipvZr7IZq1nL+9VurrmoqeuBFpfISqZIKlzu/uUVVDaY9JUhyCALj1TeBd0nnNL+ZBtsW2WVSUP+69+dqVLP5TFTf7VrWArVp/lMZxMnw49BRdJr1GDus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eNZNfBKl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eNZNfBKl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF2691F000E9;
	Fri,  7 Aug 2026 15:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117575;
	bh=E6LysXXwEQzLeXepP+WQendm7hvYrKdELxO1b/8jryg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eNZNfBKlvS4evdbz4i0qv+qcsYXIrOAPAH1qXSX+OtMwJ+mjU1skRCrX1ma+ybAcN
	 mnBp6IYYD0oXDtRxaenrxMls5w5xUbUGU+1JUwXGJ0PDcEsy8fGGwmEeLuiMWKvWvO
	 wtn6gPmk1SjVd+dJqvtdP0y4xutLBsa5u32zSS+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Zhou <eilaimemedsnaimel@gmail.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 7.1 368/438] can: j1939: transport: j1939_session_fresh_new(): initialize receive buffer
Date: Fri,  7 Aug 2026 16:39:24 +0200
Message-ID: <20260807143435.817503058@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1579,7 +1579,7 @@ j1939_session *j1939_session_fresh_new(s
 	}
 
 	/* alloc data area */
-	skb_put(skb, size);
+	skb_put_zero(skb, size);
 	/* skb is recounted in j1939_session_new() */
 	return session;
 }


