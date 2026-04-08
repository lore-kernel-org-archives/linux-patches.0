Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5443A34AB06;
	Wed,  8 Apr 2026 18:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674144; cv=none; b=k0RTCmQAer/KKJVvbcLUKdqAVkHYL8udc+EHqcLLS1Q52fc5mYzNqmNQR+58UL9Bdl+l5BEWhm1Tjud3lCsCYDxQnMYvEGTYcABRV6G+aqjSEmTqzRKYPCS4q3AJbGfsPN9RohlUiH7rRAVgT+oNorl//3e25pphYocjJpt4q+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674144; c=relaxed/simple;
	bh=U6zQSUsJXDUhqy7Yg7D0wp0g3tWW9letEaEjaPgd3Tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g5+A5Rs3zdRmGTxGL8wR6x16O8rpAX7J3QyRKcD3udpjKqI+4KTEk8Nqupo16aE+7a9OlL2LDw+C00tnA9RJh0SzYhS90ccNOOhzXAvXhI1QXSKkbPkAd8ejAq8pdsXrs8mQGFEqZxR028274kAGKbOegW1b59Ci8T9ECojg4i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PlgpiaLf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PlgpiaLf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D91C2BCB0;
	Wed,  8 Apr 2026 18:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674144;
	bh=U6zQSUsJXDUhqy7Yg7D0wp0g3tWW9letEaEjaPgd3Tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PlgpiaLf11dQhyqOMV3TcDPbmc0MI/dYfP13EkHz2ui93ndyhq5+X7tcQXSunxJuI
	 cWUYr/ciJcUUqj6P99IAqp25SbjyxSbm2WTVUyatyN4lpf43xrppG+OihDCgKt6TkT
	 U5o7CjpNmLIoePVhURzXpblmQ41Y2qGqV06lOUnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Daniel Tobias <dan.g.tob@gmail.com>
Subject: [PATCH 6.12 226/242] x86/CPU/AMD: Add additional fixed RDSEED microcode revisions
Date: Wed,  8 Apr 2026 20:04:26 +0200
Message-ID: <20260408175935.553533121@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit e1a97a627cd01d73fac5dd054d8f3de601ef2781 ]

Microcode that resolves the RDSEED failure (SB-7055 [1]) has been released for
additional Zen5 models to linux-firmware [2]. Update the zen5_rdseed_microcode
array to cover these new models.

Fixes: e980de2ff109 ("x86/CPU/AMD: Add RDSEED fix for Zen5")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://www.amd.com/en/resources/product-security/bulletin/amd-sb-7055.html [1]
Link: https://gitlab.com/kernel-firmware/linux-firmware/-/commit/6167e5566900cf236f7a69704e8f4c441bc7212a [2]
Link: https://patch.msgid.link/20251113223608.1495655-1-mario.limonciello@amd.com
[ backport: 6.12.y uses a custom check_rdseed_microcode() function with
  a switch statement. Updated the switch cases to include the new
  models and revisions from the upstream patch. ]
Signed-off-by: Daniel Tobias <dan.g.tob@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/amd.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1034,7 +1034,14 @@ static bool check_rdseed_microcode(void)
 	if (cpu_has(c, X86_FEATURE_ZEN5)) {
 		switch (p.ucode_rev >> 8) {
 		case 0xb0021:	min_rev = 0xb00215a; break;
+		case 0xb0081:	min_rev = 0xb008121; break;
 		case 0xb1010:	min_rev = 0xb101054; break;
+		case 0xb2040:	min_rev = 0xb204037; break;
+		case 0xb4040:	min_rev = 0xb404035; break;
+		case 0xb4041:	min_rev = 0xb404108; break;
+		case 0xb6000:	min_rev = 0xb600037; break;
+		case 0xb6080:	min_rev = 0xb608038; break;
+		case 0xb7000:	min_rev = 0xb700037; break;
 		default:
 			pr_debug("%s: ucode_rev: 0x%x, current revision: 0x%x\n",
 				 __func__, p.ucode_rev, c->microcode);


