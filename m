Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019691;
	b=tMBwk/bYlOrhu835rHypBf9iJ96Vo1tz5ebOOXf0QHrjMmUgofW/p5eFIthhnRXNC9Zc
	 ntpB9VX7tN9wjcndD1eyg80eJhAzQANJXLofPojUe77PdeSfbm/sm+ke5Ptwm1o6J1Ej+
	 sSQTcpz8nWpcIYv1rD2rXhBqe0lqwmlCFb/3kV+q9VP8s7mlzyaPfJeNewyH/f0eTX4P/
	 jOq61qV+Br/eFrvzLnYvubDHI4Adqi9kMJkBJ4Mumbsa2RL5tDk1hX0g4uV3cAi+HnaoJ
	 pzW0TMdpvfT/9YxRZSuC59GVMlZVWlI7X4c9z6ZAOXm/DAY9s3Me3bO251ik/Ts3IBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019691;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=5HvF7mEYcLoDwwt45nz49qTWsUbRyDCkBnuJ8ejZaSU=;
	b=oJsiXHgQJLwKBsUDDc3jdD5wyPmWDe27X83Ai+8HJRbaH49ljcMRHkZ5L1BLcHnxJ8ap
	 tNMjZiIye8889de5asA7Q3BN9ETsichLCFEsg74mmg3V5qEAKWqG96Y/yPs2zUbp/L2w0
	 m0rzND1uHfMfRYoGgCWXN9275Hmxrsa8KE1uLFlEZKIEeL8xgUQSFwe8ZrTonJcTgMuRj
	 kiAyKk9KJjPPlEI2GBHrnD8RJi8lIh0FML3mJ23qtrcOy10aADBaKLHKyPLMxbP4yN5Nt
	 GRSHLEmwSu898TeKMw74mSmofyB/1pNPtWOCXaKqA5zqYYt+oBC4tb3oSbF7KtYNgqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TWwnDv3J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A728F606A33D;
	Wed, 18 Nov 2026 16:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TWwnDv3J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A9B1F000C4;
	Wed, 18 Nov 2026 16:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019691;
	bh=5HvF7mEYcLoDwwt45nz49qTWsUbRyDCkBnuJ8ejZaSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TWwnDv3JVZ/mTw5d9yDvkaTfB+kJpTpI10dHaMn+t95bEziJhstsaWttxT7a5bLmq
	 eFqqpcIhVSA0uqvKHJfToxR/Mq8asiuUmQjnqW8S32HO4B9v4NF6vKpMi7HWg7YZIH
	 12Q4uxUwsoJeY/YnN3Z+ufQK10rahvlPhS9B4NYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dale Whinham <daleyo@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1686/2651] platform/surface: aggregator_registry: Fix tablet-mode detection on Surface Pro 11
Date: Wed, 18 Nov 2026 15:48:46 +0100
Message-ID: <20261118150348.378882017@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dale Whinham <daleyo@gmail.com>

[ Upstream commit ee2e7315dedcdd934139237f820582f9b6ce7842 ]

Replace ssam_node_kip_tablet_switch with ssam_node_pos_tablet_switch, as
Surface Pro 11 reports tablet-mode via the POS ('posture') subsystem and
not the KIP subsystem.

The KIP-based driver would remain stuck in a 'folded-back' state after
suspend/resume, whereas the POS-based device reports its state correctly
even after suspend/resume.

This fixes the type cover keyboard/mouse being ignored by desktop
environments after resume from sleep due to the erroneous 'folded-back'
state.

Fixes: c4a069095395 ("platform/surface: aggregator_registry: Add Surface Pro 11 (QCOM)")
Signed-off-by: Dale Whinham <daleyo@gmail.com>
Link: https://patch.msgid.link/20260918-surface-pro-11-aggregator-registry-fixes-v2-2-c4ed9335814a@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/surface/surface_aggregator_registry.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/surface/surface_aggregator_registry.c b/drivers/platform/surface/surface_aggregator_registry.c
index 82c2144e10ec7..2cb8278d98eac 100644
--- a/drivers/platform/surface/surface_aggregator_registry.c
+++ b/drivers/platform/surface/surface_aggregator_registry.c
@@ -415,7 +415,7 @@ static const struct software_node *ssam_node_group_sp11[] = {
 	&ssam_node_hid_kip_penstash,
 	&ssam_node_hid_kip_touchpad,
 	&ssam_node_hid_kip_fwupd,
-	&ssam_node_kip_tablet_switch,
+	&ssam_node_pos_tablet_switch,
 	NULL,
 };
 
-- 
2.53.0



