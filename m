Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060846;
	b=uImGaTfTPwZfMcBzAKUDlZrGga+G1dJFBAR4IvJHRHW2gmQhYQi9MtInpVwjH0vaj1Wg
	 LUoJl2SJbCqtVHzq1oJQExVZFyXr0gynfdm+Lacuk/wGV2ljnNZDwG3SRRgHBSLXmvWCQ
	 mKbjhrNI3cY0ZdBgvIgeBSttl3uEhNf/PSuq/qZisfOKn29QHKCli+saTsbAZ85kp4oUA
	 au0CK4LNlmhf3UpE4c8mTseQef7/ZR7AMmQ05EfLP8dmhTgkLorAg+Xi8gV5q08fvFtwo
	 fzXRSqPc4qwRGdqJEBTfKl0MaiDnS/ZjPj0PrxUVmRrwB1AapKsTXA9NMkKBnO15eFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060846;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hBOUuQ/arzCDXnql907aePnn9QWnLXc3M5YZjIpqFl0=;
	b=uM+wbphjtOFB+pKxY3q3auggMJHQLnhSHlBNQ13eckDStRlN+aT4Wu1RRgfoFXVHS60j
	 TYjhLBoVgnE3p1kc2medOSAC/Mirgp/PNrNcKCEPutOyGgvHdsysyMEPyyo+OH/s6Fzvd
	 HwI2aI04IifzBMXQJmMKRztuPBr2xcpO8uk5URVLui9H4twFlar4gz15bQV+oB7UX5Kda
	 pbbMvCdUfUAhUEU9lCTVfMaWi2qfJEtKJSCwkHBEdjF2Ff8tNATfkbuAIj70ZP98MG7mu
	 +p4baeIN7HyIdnfedXVy1w56XsApFnMBR7vIJ/dmqbX69wGkNFMo8Yb1JB5/uLO2nog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q+RqJr6Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49C6606A330;
	Sat,  7 Nov 2026 14:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q+RqJr6Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E3EA1F0089F;
	Sat,  7 Nov 2026 14:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060845;
	bh=hBOUuQ/arzCDXnql907aePnn9QWnLXc3M5YZjIpqFl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q+RqJr6QKEGLa/KELRP1b5tq8ERQIhnCUDKXf3VvgIfAFOo9RHhCMzhqa+GrZ+Ey9
	 3PUkjU85HRJFGGdopU6sZjdIaMABdO6YKeXTMpXGw/bOYtGWn6sy77jUPlh4R/aIwZ
	 jP42+EWA3zP/Zbqm0VwJ/E+5996S/8m2rLzoI5VA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0234/1536] mfd: ipaq-micro: Fix out-of-bounds stack read in ipaq_micro_str
Date: Sat,  7 Nov 2026 08:37:30 -0500
Message-ID: <20261107135004.246099685@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



