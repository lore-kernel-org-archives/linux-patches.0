Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E9222323;
	Thu, 18 Jan 2024 10:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575372; cv=none; b=Fk7HetUyS/tc9CYSL+ySEspGE6rEYxWwpqoG+6x8p7e7ThbltogJrdl4JkBbeDRwO94Ex25Zq2EUjKZ/bzAgcjFWs4ihFW6o2en+7vK/1WItIPHoGaAB1SXOjL98Ua+CmQKCdX37lAzX3BgaFMfuYlFbX3rAYMUsFM8hNPTOdXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575372; c=relaxed/simple;
	bh=XonA3s1GNBPROxhMmRov3j2QVmi9PvI/xWp9hM69tXM=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=iEay80zvP/1dT7BaV4HaHsnZqA9fR/eGB21p85JWi94Y18Y0Zhq7YUC0PZmjovXOKcrkwkO1ghSwdBgesiu2/VaAUnGEoxUF3HHSv9AMMzj84O2TScPQB2lXBJNE7WDOJ07Zx5TfA7GcT1C8gIAgxubkvdwFF9n0fZzFpqNpSmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ASrSVaVw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ASrSVaVw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45BCAC433C7;
	Thu, 18 Jan 2024 10:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575371;
	bh=XonA3s1GNBPROxhMmRov3j2QVmi9PvI/xWp9hM69tXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ASrSVaVw2fjkbid1hUsSMSYg35+6O4orlSEQtnzDtQ7dM7SeAsNYmsr3N8KVLwU5m
	 mUyPYoqm4FrBtrw5Cos8Xps58sk76Xp4To/Op1SSMk/d0ETYv8Udqzr+zGsUeedQJc
	 mZL3l/+pqLuThiIHL+vDfX8q53Vwx0eq8JyIxV/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 109/150] dm audit: fix Kconfig so DM_AUDIT depends on BLK_DEV_DM
Date: Thu, 18 Jan 2024 11:48:51 +0100
Message-ID: <20240118104325.093417355@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

From: Mike Snitzer <snitzer@kernel.org>

[ Upstream commit 6849302fdff126997765d16df355b73231f130d4 ]

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 2a8b081bce7d..3ff87cb4dc49 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -660,6 +660,7 @@ config DM_ZONED
 
 config DM_AUDIT
 	bool "DM audit events"
+	depends on BLK_DEV_DM
 	depends on AUDIT
 	help
 	  Generate audit events for device-mapper.
-- 
2.43.0



