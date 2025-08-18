Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10128335BB3;
	Mon, 18 Aug 2025 13:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524248; cv=none; b=JOTs0Hd25dHz8YdijvLd6kgzonDYAj+Pf/va11qSpXpXvCCpAfbm+d53tOe+GOTfItfYjP5ZxN7IoCMTLfJtGGx+Nko8cM1WBf97g7uYSGTgapsKsaRcw3LIGLfOsUhqve+esOi8Kl5zZ4zqeY01rvN23Q4GAPmBSAdY3DhkBVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524248; c=relaxed/simple;
	bh=KEa16O2Y/xHGMqcOiNdqKGsMa2OOdHHUet4JyIZ9Aw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FNLoLuf1/2cAeTv2T2lRhg2jQLylqI2u2kuMTp/47dM6v3A5F8oPEeAwsH8ano17fBdEdg2qB9ehCL6LbX2IUFFqely9apFIzKkbOMkJnaL0wX4agEls3EbWlpL+ALjgO6BxyO/ZJXkpfxXtFB9KzB5NNEOcoU5bXLvh0rNDfEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VkIrNMkI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VkIrNMkI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D40C113D0;
	Mon, 18 Aug 2025 13:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524247;
	bh=KEa16O2Y/xHGMqcOiNdqKGsMa2OOdHHUet4JyIZ9Aw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VkIrNMkIte5WIXD0EDpp9JlFgDvL7sUya5h1NyVHWqzGQb+QZ2KUwiHDw3NcaVjCq
	 db/hL7yAbzIofKrTd63884MaB2rNNaO4U9XO0DwMDTCS4jGAAqFtxV7KMgov9e9672
	 pmdQ4kejYahaW9AslED1Pi3Tqv9qN8xla2ZQC5og=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jorge Marques <jorge.marques@analog.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 396/515] i3c: master: Initialize ret in i3c_i2c_notifier_call()
Date: Mon, 18 Aug 2025 14:46:22 +0200
Message-ID: <20250818124513.656018704@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jorge Marques <jorge.marques@analog.com>

[ Upstream commit 290ce8b2d0745e45a3155268184523a8c75996f1 ]

Set ret to -EINVAL if i3c_i2c_notifier_call() receives an invalid
action, resolving uninitialized warning.

Signed-off-by: Jorge Marques <jorge.marques@analog.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20250622-i3c-master-ret-uninitialized-v1-1-aabb5625c932@analog.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index e53c69d24873..dfa0bad991cf 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -2467,6 +2467,8 @@ static int i3c_i2c_notifier_call(struct notifier_block *nb, unsigned long action
 	case BUS_NOTIFY_DEL_DEVICE:
 		ret = i3c_master_i2c_detach(adap, client);
 		break;
+	default:
+		ret = -EINVAL;
 	}
 	i3c_bus_maintenance_unlock(&master->bus);
 
-- 
2.39.5



