Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCDA205E26;
	Tue, 15 Oct 2024 13:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998488; cv=none; b=mpzwXrhG9LGs/TDUXKE4OEfMqmbzHfBSaO4JYI+6wW8djr1iNI1ckV3ZVbxJBX4Nk6cO0+S6/s7e6lIbLbGaHbCMkgNpGiIn5raxqY21I5rK5kuSAh6wNYp57zD+MLa8SJX6psyuh73cfnEThhD3lbJ8MLzO23lG3wpbubgP3C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998488; c=relaxed/simple;
	bh=CIwCEQvFmPqXxJjg3BubZEqg2FxqLzxLDPh3oiSPUJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M1DGepwfzpHCBr+Ph0VVs5JiVc2PCV4oNiyv6Ue1cRqYsG9YxCvbsX4I1eXUX++cgoE4m4f4Ko4fH/7TJKKufrXgaggKHYacYcKkU6R7G8xoit9OPG+w5ozYTa2YcntUml5kxe+ZOTp/qYS26NeJ3I9tEfvIY2xhePNL/kW0BLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NubsRI/u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NubsRI/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4806EC4CECE;
	Tue, 15 Oct 2024 13:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998488;
	bh=CIwCEQvFmPqXxJjg3BubZEqg2FxqLzxLDPh3oiSPUJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NubsRI/uBgAR/6lrBYavD7P5J9rKu+SAtRbwuTYrYehQC6vB/tXJ5t6f1Igl3+ELA
	 u0OL7UmE0zS/OPfsOh6zN3SHKHTJiw9Vk4JALMRjYmxLoEJNK9LEhr7T0viyy/v7Si
	 L2HiTnCeOWflUQXdR30r+jAC3aCLu2DwNrzbg3Ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 491/518] net: ibm: emac: mal: fix wrong goto
Date: Tue, 15 Oct 2024 14:46:35 +0200
Message-ID: <20241015123935.947625754@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 075c07303f165..b095d5057b5eb 100644
--- a/drivers/net/ethernet/ibm/emac/mal.c
+++ b/drivers/net/ethernet/ibm/emac/mal.c
@@ -576,7 +576,7 @@ static int mal_probe(struct platform_device *ofdev)
 		printk(KERN_ERR "%pOF: Support for 405EZ not enabled!\n",
 				ofdev->dev.of_node);
 		err = -ENODEV;
-		goto fail;
+		goto fail_unmap;
 #endif
 	}
 
-- 
2.43.0



