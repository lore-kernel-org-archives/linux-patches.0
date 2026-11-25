Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620263;
	b=y51xSDXi8mEsO9Ps/J6iJVVD8p1y2Ch6NEPOoglJ01Tj09Y7H3TC+TlY+6lcL7ECgXf8
	 GTFrJkOwxGgrNmpofmeZMWI0vD1XFShcE0eBr1Y4RV7PrwViLdSSZ7B5VZwbgTHVvgqRI
	 /X4S1HbpnRfMumdjzeNmwUDN5Y3gWh5LGASpy/5yYhqOmMkWrODTnjE0suR2Zhi1swHWt
	 YBCxDwPYvLzdpGn6Z+77VAVBB05D4vZ7mcsciMEhXpKCTU3he5o70DZBPEV88kBA7AgbJ
	 kpxyIlg3Dtg9vbAB7cWFGFAPAffOP6VtX85t1D7Un3j7eO6SBhdHIxVJuoAOgG92hbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620263;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w70VRETvNAT09ZkbUiBDeodqAAuEZshrq5AH9ajOaMw=;
	b=ekdngA4d3lHWdDauAYH4wszNdF59zoOZRCTEr45R4d0w+rmbUlBzs6e2O+REGqvLewAu
	 vM4R1roBr7jI1plvhM0U7uDlKeMRg2wEyE26OBnct+IbVbBTrOQtVw6lY4M1MnNpu0eL3
	 YXeEBbn7ixQAEfzMZlwNAkI5IDkKtswgaPJ34WeM9CbZNkh6R/nomuCbkQvfAyo1RSS82
	 Gi4bvELvBGY8azVT4Hnz1hDCg5+bMeBH8yJ0H0lmEIMuGO9SHswxVHmra4xhLxwJwGhii
	 VvIoVOSwh3DUgr8/va4o5FQfVvvobh35tqLFWcAccrMVTC849wYFAzK0/qO0hIYaBLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JzgfKJUq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF13606A32C;
	Wed, 25 Nov 2026 15:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JzgfKJUq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9661F000D8;
	Wed, 25 Nov 2026 15:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620263;
	bh=w70VRETvNAT09ZkbUiBDeodqAAuEZshrq5AH9ajOaMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JzgfKJUqd7hTO/EYDenrt/bWev/ce3kMcud4eM6nmV7rcosYvCVyLRYc6mTqgi3UX
	 WIGQlAHIz2YGDEU9vGY3iTw3lSOnJQkVia4NcawqrZnZ8DoTWkAeseCl7PwLQ0oAHV
	 IhIZGqat1aTAfpD9tGwT7PDIk6KnZYSIPrZqjmVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shao Mingyin <shao.mingyin@zte.com.cn>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.3 0861/1005] dm mpath: fix buffer overflow in parse_hw_handler()
Date: Wed, 25 Nov 2026 15:36:39 +0100
Message-ID: <20261125143841.879061986@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: shao.mingyin@zte.com.cn <shao.mingyin@zte.com.cn>

commit 8f611fe94a781c6fb658488cc7eab4e4923e6df6 upstream.

parse_hw_handler() builds the hw_handler parameter string in a buffer
sized with

	len = 4;

plus one byte per argument.  Those four bytes were meant for the decimal
form of the parameter count, three digits plus the terminating NUL.
dm_read_arg_group() accepts up to 1024 arguments and the count written is
'hw_argc - 1', so a count of 1000 or more needs four digits plus the NUL
and sprintf() writes one byte past the allocation.

Size the buffer from the actual string length instead.

Fixes: 2bfd2e1337f0 ("[SCSI] scsi_dh: Use scsi_dh_set_params() in multipath.")
Cc: stable@vger.kernel.org
Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-mpath.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1085,8 +1085,9 @@ static int parse_hw_handler(struct dm_ar
 
 	if (hw_argc > 1) {
 		char *p;
-		int i, j, len = 4;
+		int i, j, len;
 
+		len = snprintf(NULL, 0, "%d", hw_argc - 1) + 1;
 		for (i = 0; i <= hw_argc - 2; i++)
 			len += strlen(as->argv[i]) + 1;
 		p = m->hw_handler_params = kzalloc(len, GFP_KERNEL);


