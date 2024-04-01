Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B513D961;
	Mon,  1 Apr 2024 16:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988455; cv=none; b=pxwgGzlCT4h1eMz23+Lu+fSSLF0SLafGCHN8qsUGMfjZ/7lFq0Vv0RH4QAIOUMaW54B0i/nAI6LUUS3OIQ0sXAC24QWz4u6eTRFC1z9up5xz8bvDZeC/n53gtOmESPzxeBPx/U8u9jTRdc3B46kcfB8TEVkUraOwdAqYIYUMYTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988455; c=relaxed/simple;
	bh=2FrtjAPrx6mXuDqirk09Lv6KfLGs2kw3koIefDtxg4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IYIBqxVJC+KevhK8tRzwSGWiTeLEiVh/FxfdG7M29U48AZeftgwjyjFQyGq3os2aR67v2FztARonsDyLt73lN0a1HDHmNrvJn+/w9DXs/72awWBuxYECZJWlWbE8IkSZ8yeWDaqHyDgeIhiWGKisnKcAQXCzy5xtk7ZtA4FULIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yYiHHpWO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yYiHHpWO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB88BC433F1;
	Mon,  1 Apr 2024 16:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988455;
	bh=2FrtjAPrx6mXuDqirk09Lv6KfLGs2kw3koIefDtxg4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yYiHHpWOKUkZCB87e3/0alI+4qk7K3kQd/TLvIS+nxaZIDTzHhYZU41KSDeb1KVgH
	 5M8/aPPmAd+4SZvYtp7Omw+6d2iCxLZUd1JznlhXLxXeqHRw3Yc6MNbOKu8/Mha5TS
	 XawkqEgdPFOzyGpqHm+Uh9A4uiVHHOg/7RPZB7Hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 189/432] x86/CPU/AMD: Update the Zenbleed microcode revisions
Date: Mon,  1 Apr 2024 17:42:56 +0200
Message-ID: <20240401152558.777730397@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov (AMD) <bp@alien8.de>

[ Upstream commit 5c84b051bd4e777cf37aaff983277e58c99618d5 ]

Update them to the correct revision numbers.

Fixes: 522b1d69219d ("x86/cpu/amd: Add a Zenbleed fix")
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/amd.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 2055fb308f5b9..77a1ceb717d06 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1002,11 +1002,11 @@ static bool cpu_has_zenbleed_microcode(void)
 	u32 good_rev = 0;
 
 	switch (boot_cpu_data.x86_model) {
-	case 0x30 ... 0x3f: good_rev = 0x0830107a; break;
-	case 0x60 ... 0x67: good_rev = 0x0860010b; break;
-	case 0x68 ... 0x6f: good_rev = 0x08608105; break;
-	case 0x70 ... 0x7f: good_rev = 0x08701032; break;
-	case 0xa0 ... 0xaf: good_rev = 0x08a00008; break;
+	case 0x30 ... 0x3f: good_rev = 0x0830107b; break;
+	case 0x60 ... 0x67: good_rev = 0x0860010c; break;
+	case 0x68 ... 0x6f: good_rev = 0x08608107; break;
+	case 0x70 ... 0x7f: good_rev = 0x08701033; break;
+	case 0xa0 ... 0xaf: good_rev = 0x08a00009; break;
 
 	default:
 		return false;
-- 
2.43.0



