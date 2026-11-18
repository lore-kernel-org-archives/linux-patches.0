Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045141;
	b=bDGYZr0m/JZFJ63tw1BN458/bEuD1QA4tNK059pp7xenj+bTihG4SoKkI8AnpRkjvN+q
	 pDsWpTnRN75F4U5AVsnHpQwUMOl45jK7gfvDHAzN/pMPSs16soMDSLj16rYqkhD8la//s
	 yCsCaRtGvk74A62n632m/gnbYc2JhCjAhZ6si6yMq8sGzQXS09dULANW91Vq2eUcCFSht
	 FjPx4gMx2NmIc34SljiAl4476n4e6qrxlyUY64y5+cRoQvBIOYGGyOkzsWJkgbYxg6U7G
	 fqI0R08jjzYM39H6N3aH0ZkhY81rW4ISxMj1fJ47jt2GKyExhvpGEmw7bS4ztcSiF8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045141;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KoNwidj3vJpQaWQNE3i1sz09vxJXQgOPmgIsNdFNZy0=;
	b=lnsKZNaM/oWaS3FqJxHxcMASQhNpNk0/5CVkitHpc4/4EvNtmwx4+/qBBtL/JGMm8KPl
	 YiUom5b0HL3p8HR6sNX/1gVW+KpD262ao9k7kbRGN+O3dsrlz8SzSJ24yTDAPMRSEoTU/
	 KOps3cnljl8TFvBLoQFoxeGXfmQmB11a+wM5pfnpO7nTpWrcyTHYxxNcUWkjyB+W21ULg
	 bIE6iArw39pxk92i3P/SQP5GIk7yshnvmBhMSYnwGw8cZAkv/8BAl5b2caBoO1ZBLKiXb
	 WYeEEa7+mTjj1Uc2vamrTtWvLVebKlKW4iteY5YRsUqaBHo1RCdFN5mdsvn+ildvzTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jArj8UnH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B51606A320;
	Wed, 18 Nov 2026 23:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jArj8UnH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 183131F000C4;
	Wed, 18 Nov 2026 23:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045141;
	bh=KoNwidj3vJpQaWQNE3i1sz09vxJXQgOPmgIsNdFNZy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jArj8UnHpMR5DEaz8kC+2KPhlz12Ym2DVQX0CJ1hMyZzwsODBnVM3AeLAg3gDNQuW
	 nOfTTJPAXzSREl4OdkH+ZCpymbkyRRcbeFXGav5XMIHH56BwRtdFg7Grzu1fLToZm0
	 ZIabQvoacJuyilr1F5Gtm1b1LpHcaF6YelGO3YVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jiacheng Xu <stitch@zju.edu.cn>,
	"Vishal Moola (Fractile)" <vishal.moola@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0817/2857] kobject: fix out-of-bounds access in kobject_action_type()
Date: Wed, 18 Nov 2026 15:30:51 +0100
Message-ID: <20261118150230.992499433@linuxfoundation.org>
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

From: Jiacheng Xu <stitch@zju.edu.cn>

[ Upstream commit d516455c940555566642b975d1835c67f08136b3 ]

kobject_action_type() compares the input against each known action
using strncmp() and then indexes the action string using count_first
to check for an exact-length match.

An embedded NUL can make strncmp() return zero even when count_first
exceeds the length of the action string. For example, the five-byte
input "add\0X" makes the parser access kobject_actions[KOBJ_ADD][5],
which is beyond the end of the "add" string.

Check the action string length with strlen() instead of indexing it
with the input-derived offset. This rejects malformed action strings
containing embedded NUL bytes with -EINVAL instead of invoking
undefined behavior.

Cc: stable@kernel.org
Fixes: 60a96a59569b ("Driver core: accept all valid action-strings in uevent-trigger")
Signed-off-by: Jiacheng Xu <stitch@zju.edu.cn>
Reviewed-by: Vishal Moola (Fractile) <vishal.moola@gmail.com>
Link: https://patch.msgid.link/20260920053726.22626-1-stitch@zju.edu.cn
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kobject_uevent.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index cd6db04f30c33..cb64874288bfe 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -84,7 +84,7 @@ static int kobject_action_type(const char *buf, size_t count,
 	for (action = 0; action < ARRAY_SIZE(kobject_actions); action++) {
 		if (strncmp(kobject_actions[action], buf, count_first) != 0)
 			continue;
-		if (kobject_actions[action][count_first] != '\0')
+		if (strlen(kobject_actions[action]) != count_first)
 			continue;
 		if (args)
 			*args = args_start;
-- 
2.53.0



