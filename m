Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17FD33B2FF2;
	Fri,  7 Aug 2026 15:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115506; cv=none; b=IabEas3O6QsYO7yiQh/xXzQ2qvI3f5nXoAVLkMrEkk/xW4vycox/XrNwOQ4Qn3IIi6DT3W1T1rL7qeQgejWLN7/CbKRsyqY8+7BMEZAV2Q707TPFL4VjAdsXJVMmxkV8jzHyzqAH8Q7x0QOXZiZM9MBaVxCzfl3Wt3nD5pird2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115506; c=relaxed/simple;
	bh=xqhQ2NFErcSxPWSELgJZWYLtYoR5rxqbH+7o/smlzwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=emeyoolSiiMbt1WDg/r9ulvPzV3Cn0KKPDn+9IWOYd4x288DGhLZHLeRBn8K92yoqvCf7x4OmL0DNCMnlDAURZTUUMxcbAn4OoP1ibOjZckXLeS6Qv63h21nud8MNuO1mdvWAjp40MBfLdFhQeSeCkeYWORh7uRzZP05dmBASQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l0RfjpX9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l0RfjpX9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7171E1F000E9;
	Fri,  7 Aug 2026 15:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115500;
	bh=lBv/rDZv53SG4rVgZA5Fo0z9Kl0OJJ2UVDQAYyIYJxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l0RfjpX9/HWJnNtIDNqRGc9mW1vTT6HHhSs1cCUBcM+GEv3lFPIagdDcRaw7fcFIG
	 Xq6raRDQjJVyOzRCd2QozzkItdGC9C496raAgx3WGrcqUOchB6xbX7BcTuRHp6gVAl
	 1ZxUm06hLoSdYQm6nWao1uPThMoSXbGOHY2zhZAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Zhou <eilaimemedsnaimel@gmail.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.18 299/396] can: j1939: transport: j1939_session_fresh_new(): initialize receive buffer
Date: Fri,  7 Aug 2026 16:37:39 +0200
Message-ID: <20260807143430.718879122@linuxfoundation.org>
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
@@ -1558,7 +1558,7 @@ j1939_session *j1939_session_fresh_new(s
 	}
 
 	/* alloc data area */
-	skb_put(skb, size);
+	skb_put_zero(skb, size);
 	/* skb is recounted in j1939_session_new() */
 	return session;
 }


