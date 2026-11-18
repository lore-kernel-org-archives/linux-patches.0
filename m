Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033945;
	b=VxyfoZvxqUOFIENXmqlHGVfjEhfy6lEEaej5ezaAw111HbNYVd39YCDhfMMHPr3LvwSg
	 VO1LmZ5RnrFOcpVWmwJG6nOrrhKXRA4O3xnNRgLFanD1VWCzjiGuzECOjRAVDGJQTnnAn
	 KunQSj3cMPC2hJn0Fsa4Xp/41eJIvsAHNAoO0e3Rf+6BNTsfR3y4/+tIg8bE660aEhgKy
	 DyoLKIa84iTgRaHgLimn2SEhv+srvbS+pCRS6VM2glkGBySS2rTYP1CtBPyN+PR4+h/Gv
	 kNRNihKL9W29LpY/xjLpz8tN21TdpngOthpKwyUh4jSWfsEpdvlyts3843eJ+IjYGMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033945;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V8B0FolRwzBxf3s1xNYbVHc02s0bIyBjDv7IBi1XIm4=;
	b=MeW5s5qcPfnuvPA15+r6oEUUWSKXbGE8D0/NgINRdP3ibIJEYccXFsTPi2nEjdJhTMyi
	 fhS5bGP1CY7cMyxpbqGkyLtzxSFGdL6PXROzilo73MjivHnFvYfS0Oh4G3femgXypPriP
	 Ps/WlTM73QnIKLqZ7/wFbXSwUHjHfoclGees2QGcES6zPOLkM1kFEG0l1GzQhHCzymezN
	 WUDpX39pVBjYDs9n3/oQXWpGOnm4adYPseR9xPfeILvB22GR0kdKyrFN62k199IBjLrrd
	 LpyICTSncTL9pAkr1qe25kuKcM9pIi/CpYLF4R7o53CiUo22hU5GVr4yCIs4RFyiD6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KJw7XfVe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA80606A320;
	Wed, 18 Nov 2026 20:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KJw7XfVe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F35371F000C4;
	Wed, 18 Nov 2026 20:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033945;
	bh=V8B0FolRwzBxf3s1xNYbVHc02s0bIyBjDv7IBi1XIm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KJw7XfVeXMYH/SOV9SUTDDkqVkvCu9MTKuCHO5amEXgUKY6vGYJIW3ejW8E77Cmag
	 ZzneJytr5xYyZ3hfhnKdYccvvGTALx8JnrDlkwIe/Z8HgDdfh6UQ5nej4nHVdo4+Ft
	 kLwCGxncUD0mSW1Ct2YG7MfMt5ah0yabVA7vdGic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0194/3318] mfd: ipaq-micro: Fix out-of-bounds stack read in ipaq_micro_str
Date: Wed, 18 Nov 2026 15:13:36 +0100
Message-ID: <20261118150320.634461266@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c964ea6539aa6..9ac26a17b6202 100644
--- a/drivers/mfd/ipaq-micro.c
+++ b/drivers/mfd/ipaq-micro.c
@@ -219,7 +219,7 @@ static void ipaq_micro_eeprom_read(struct ipaq_micro *micro,
 
 static char *ipaq_micro_str(u8 *wchar, u8 len)
 {
-	char retstr[256];
+	char retstr[256] = { 0 };
 	u8 i;
 
 	for (i = 0; i < len / 2; i++)
-- 
2.53.0



