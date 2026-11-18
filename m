Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057446;
	b=O0JvIobIaFECMCMHxw8zj2RjhjCo3IDTKkMlwNwQiFo+tylrSg8aM2XGpBQ3qIcBTCXA
	 WYTaZGELb/aWJSRFQvTtyckVaOiisLrmNDWNlLk7wJQKlvP4PvwYEJWlvWIgsiXBUIyPZ
	 xLv40I8KS/WYnhYCh9zsiihDT5oskCFpLGn8VCyHEATO8j0HpXJggyo3kZGr8EMMGeI1G
	 MtCY/v/Xu9Kb2dYAqjRJs09Vd0I7YwCMke3fcRra6kkE72WHdRlvZ3OOzLecYnXEyvABG
	 ctcRFmo1xbJ0PChNzmzZApQcqfDaN8/G5+6O5EF8m0lJRSgcNu84ZZilkEWOlrTMM0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057446;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FqkyiTdY/VsAvHf1kCxXLMQbXvM6FywBKqQI9su+ed4=;
	b=dH6YdwSZIs5kY8Cy0M3KBSg74cgiosLV/lUJuQoYzKWZUhxR6SBO1UsRiJTrSaInubmF
	 Qhm6kyzIgJQLuBPPtEvBHYkTsjGUWkW/5IEberkgY1oN8BrOBqVy8KX/vX7m5peb44Ciz
	 MUBb1HXiX8lW46ywuy2CrZACgcMilyTmhNTC4tVJ5VimsYE72v/yt4UYVHW0dEwNykLHB
	 ojjff1wIlVEazXSNqj31UZ9PfJr83n/9d//cdiCJvtW3AnSiRMn6W+Bnif6F8S7qAR2kM
	 31rM4FWiyrzc4+v5hyrzcVRVFlFcX0YLtIiEb1dlshn8CntXQlQUJUs+oQotq9avH5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C0k0cj6W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE0260A2606;
	Thu, 19 Nov 2026 03:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C0k0cj6W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E501F000C4;
	Thu, 19 Nov 2026 03:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057446;
	bh=FqkyiTdY/VsAvHf1kCxXLMQbXvM6FywBKqQI9su+ed4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C0k0cj6WQar5Rae0FuY+ZezQD8Ft0ftQTA00gVw3IQgvWFLEF30WuE/wcQt7wccFo
	 AyXd5odMHdbMtWk9V/SlGvk1PxafzjVkuxkE02wOo9OLFjkRpnjkvbEBEtYVAu4eof
	 XpIeFe+hYTfrea5+B0Yw3Qdga46QFKXfwsmF543U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0132/1848] mfd: ipaq-micro: Fix out-of-bounds stack read in ipaq_micro_str
Date: Wed, 18 Nov 2026 15:36:10 +0100
Message-ID: <20261118145916.685023699@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit da3a98c941753255418616d249e5b40db0927c26 ]

ipaq_micro_str() decodes a UTF-16LE string into an ASCII string.
It copies characters to a stack buffer retstr, but fails to
null-terminate it. When kstrdup() is called on retstr, it can read past
the buffer into uninitialized stack memory, potentially leaking stack
contents.

Fix this by initializing retstr to zero.

Reported-by: sashiko-bot@kernel.org
Assisted-by: Antigravity:gemini-3.5-flash
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Link: https://patch.msgid.link/aintJF4X5tWDW-Ej@google.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/ipaq-micro.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/ipaq-micro.c b/drivers/mfd/ipaq-micro.c
index 4cd5ecc722112..d1f3b2b7989f6 100644
--- a/drivers/mfd/ipaq-micro.c
+++ b/drivers/mfd/ipaq-micro.c
@@ -224,7 +224,7 @@ static void ipaq_micro_eeprom_read(struct ipaq_micro *micro,
 
 static char *ipaq_micro_str(u8 *wchar, u8 len)
 {
-	char retstr[256];
+	char retstr[256] = { 0 };
 	u8 i;
 
 	for (i = 0; i < len / 2; i++)
-- 
2.53.0



