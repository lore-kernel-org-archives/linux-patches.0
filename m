Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D696728ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:21:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40AEEC433EF;
	Mon, 12 Dec 2022 13:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670851270;
	bh=aflPuhEq+wGJU4Y8zH6f3NYshneZO7s8jdqN3Qa68Nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1T3LHYwjP1rvIWYfqDrrWRo+pdh7GpW9maGGWPkViPyfKIXfAOxxN6PKkDlL0vqfC
	 fAAsLGITRxcNqctXkc7b9GgUsEyrAkP6RCigI4DPHFXrYDw75d23Dopsu6spOT3VtV
	 6kyIxoCc3cVINr49yvsWvob2FCv0JaHkKqo6rCxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 5.4 23/67] Revert "net: dsa: b53: Fix valid setting for MDB entries"
Date: Mon, 12 Dec 2022 14:16:58 +0100
Message-Id: <20221212130918.733424167@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130917.599345531@linuxfoundation.org>
References: <20221212130917.599345531@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rafał Miłecki <rafal@milecki.pl>

This reverts commit 1fae6eb0fc91d3ecb539e03f9e4dcd1c53ada553.

Upstream commit was a fix for an overlook of setting "ent.is_valid"
twice after 5d65b64a3d97 ("net: dsa: b53: Add support for MDB").

Since MDB support was not backported to stable kernels (it's not a bug
fix) there is nothing to fix there. Backporting this commit resulted in
"env.is_valid" not being set at all.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/b53/b53_common.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1551,6 +1551,7 @@ static int b53_arl_op(struct b53_device
 
 	memset(&ent, 0, sizeof(ent));
 	ent.port = port;
+	ent.is_valid = is_valid;
 	ent.vid = vid;
 	ent.is_static = true;
 	memcpy(ent.mac, addr, ETH_ALEN);


