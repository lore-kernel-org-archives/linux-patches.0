Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B911BDC3;
	Mon, 14 Oct 2024 14:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917189; cv=none; b=dnuRJS19m9gTvi3bgxp5VU+dfH38EDgB3zFB6fwWgJtcKldNdUjy42XgkWh/MLwqQjOiwoSYcrrHy0nUkUfI08L6cPF64SIjhtwKJd7Jn5TRXVTpSxqtTS1Pf+Dm4Hraw85CEIltVAFZ1JBSZDgsTnlsJDQ0JnJu400zvInincU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917189; c=relaxed/simple;
	bh=oHVcW0PyG8Bj1BE8y+++JWbs8PSm8bBdAM+MuRqQuck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GhIOIFntY/EE5qP1r2MdiwJ7dlT2AQ64AtMLeao7gAkl/sLqeu8WYiMQ8e2c4Xhid3h20EjBlRpbBZUK+JRBY2v0XXGxzbGdAkWzilbhkVH09BkuEKVIb3gdYJg59uE3POL1mKkUCybUjzejSWEft/FX74z5/3r+73jZaPIV2l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HWVC0gry; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HWVC0gry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E08C4CEC3;
	Mon, 14 Oct 2024 14:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917189;
	bh=oHVcW0PyG8Bj1BE8y+++JWbs8PSm8bBdAM+MuRqQuck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HWVC0gryRgrt5oWbacM7bbrXtsu7xXL8bbjnqd46RIItxrnIoYRWn6HJFu/79KxaI
	 xczE320Nft+kj52cADv9El349/udIvugLq4oPYxfwoi54QU01AxZ06bhIESFZz4prm
	 O8KvL2cd4d8l4qGNa82A0s1I6ic9d5cPD3aKaYOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 146/213] net: ibm: emac: mal: fix wrong goto
Date: Mon, 14 Oct 2024 16:20:52 +0200
Message-ID: <20241014141048.666242930@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 08c8acc9d8f3f70d62dd928571368d5018206490 ]

dcr_map is called in the previous if and therefore needs to be unmapped.

Fixes: 1ff0fcfcb1a6 ("ibm_newemac: Fix new MAL feature handling")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Link: https://patch.msgid.link/20241007235711.5714-1-rosenp@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/emac/mal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/emac/mal.c b/drivers/net/ethernet/ibm/emac/mal.c
index c3236b59e7e93..3578b7d720c06 100644
--- a/drivers/net/ethernet/ibm/emac/mal.c
+++ b/drivers/net/ethernet/ibm/emac/mal.c
@@ -578,7 +578,7 @@ static int mal_probe(struct platform_device *ofdev)
 		printk(KERN_ERR "%pOF: Support for 405EZ not enabled!\n",
 				ofdev->dev.of_node);
 		err = -ENODEV;
-		goto fail;
+		goto fail_unmap;
 #endif
 	}
 
-- 
2.43.0



