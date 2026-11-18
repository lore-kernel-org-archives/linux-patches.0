Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043058;
	b=g5ravKGfwBpF0P65Je8lx8kAdZzXD9C0qJVn2X71Lrj8WNmtKz1Tfynoqt7tXWnpphWS
	 +fVuGP9DaLAKqB7Zrpm7PebgqqtMirB4J0VbsXCYUNLG56junNCRIxn8dFOvU75JxsMFo
	 /CetBz4JnQ+wEgABmtbipWkC7IbMJ6OwknasuXFoLW8p4WC8M+Q7Lm9aISz+43QcPpG+W
	 HqotBBF+jp/NgkpcKyByxZAz8jFlZZmmOKP9PV7aPEoXhhv4O+GlYvF/4ti3MgQbfvcRv
	 5GIk1JmcETWY658eL8Yui86dMzjiSVpqEeMx8pnd3UunpRpIePEAw+TBl3rWfSp4y1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043058;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yDQcunVGmZu8Prsj3UJY3LnmmjMrfCA+TyplZqyIsrk=;
	b=Uqap5Srfp+/xNNXP6KfO4OP1OqAKafzyyO4J2M/kheROfY7GEA6cLp3Nu8p96+7XyGU3
	 7/rloy4hzUhaaiAjVow1KocOHNwVp9TKHaDwO58TaybTVPvaMhBvWmyOwAM6HNJN3e6/G
	 lazWpXSsONB+7l712WLA6vZCdYzmSrzS+VUhWsdInhEJcJrkdKe97qFYvrsMSsdM34yGV
	 VirQ2/6/eXDlEdhh01vpVjaHnMURhBDBf80ERztQ6BfV/QbGE8++smt2WrR6gfq+CzbEr
	 2hIYfjyC8HDD/TABwHTCnLWFt91YbpBm3zfS0OocC0VD8DGhWZBv9NLo0RvHfz90UUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JVE9214Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66DF9606A31C;
	Wed, 18 Nov 2026 23:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JVE9214Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B95241F000C4;
	Wed, 18 Nov 2026 23:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043058;
	bh=yDQcunVGmZu8Prsj3UJY3LnmmjMrfCA+TyplZqyIsrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JVE9214Q2zZgLl8egG4aBbUSQnF31AOlDJ6G2iyW05a8k+Ow3TKUt6k6/hPm9sOi+
	 qBvN26l2Aym3vZ2lTrqyFhz80Ea37dTyXqpIqSyDqyZ5D0T4lAWl3NNg3TWrXNoUyY
	 oiNN1zPMWQvTHJtfk0fwkz0DKnEfWpxSWcXY0qNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight.linux@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0076/2857] usb_string_copy: Use kzalloc() to avoid leaking old data
Date: Wed, 18 Nov 2026 15:18:30 +0100
Message-ID: <20261118150204.046404704@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Laight <david.laight.linux@gmail.com>

[ Upstream commit 057df423bf4747091cf942af57307627e941e1fb ]

If the string is read while being updated (which is why the copy is done
in place) and the new string is longer than the old one, then the reader
can read memory that isnt part of either string.

Use memcpy() to copy the known length string instead of strcpy.

Signed-off-by: David Laight <david.laight.linux@gmail.com>
Link: https://patch.msgid.link/20260608095523.2606-37-david.laight.linux@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/configfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/configfs.c b/drivers/usb/gadget/configfs.c
index 723454292b734..b9e4ae4060593 100644
--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -115,11 +115,11 @@ static int usb_string_copy(const char *s, char **s_copy)
 	if (copy) {
 		str = copy;
 	} else {
-		str = kmalloc(USB_MAX_STRING_WITH_NULL_LEN, GFP_KERNEL);
+		str = kzalloc(USB_MAX_STRING_WITH_NULL_LEN, GFP_KERNEL);
 		if (!str)
 			return -ENOMEM;
 	}
-	strcpy(str, s);
+	memcpy(str, s, ret + 1);
 	if (str[ret - 1] == '\n')
 		str[ret - 1] = '\0';
 	*s_copy = str;
-- 
2.53.0



