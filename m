Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7B625DAEF;
	Tue, 11 Mar 2025 15:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705426; cv=none; b=jEBkaKJwimihXJ7I/UgiojY3EiJsA8+cHVzB+cJrY8yF1bpSVmIdcSRhjLPV9aWQX/vnMD4aQ2cK43mJ3cVDhnZpg9P2ABpkpx1xab+C4wfgX60yYmTwC49ujiKd6Bcby1qh1E+mkC0ueKUR+h/j9wuwcneR2S/Yt83Us9AN9SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705426; c=relaxed/simple;
	bh=yK0G7HkfxeKLNQcn9e7e2YRiIs/fcsP/wfNTwMZPPGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fYsaYaukh//z/J6MGY8TFngO+E+aggMSCUe3SuLWk5ROcqiLr7COmyh4erEJQaYAOlcs1VQlrK7Yi9jkbXVb9KKdHXuEom2xYvglwkYSlP1J2ZnLXZ3TJDxBmUfnule31YNjwax0uqBCc4TUlbQWEowEYpqo/iUwU8GSe6LphoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ODF2vAKA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ODF2vAKA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 388B0C4CEEC;
	Tue, 11 Mar 2025 15:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705425;
	bh=yK0G7HkfxeKLNQcn9e7e2YRiIs/fcsP/wfNTwMZPPGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ODF2vAKAEPYazOfHe2wVtwWLAUO9KnshjlN+5O1vs668OAq+55nIzM46vZn7wjaQ2
	 3w+q7JRi1ZTpqBvwgmz6XJCS0tiWlFawSpL18d9t0+7EBFBK7GjmcKeGeqeCN88bfC
	 FnM/T1BgjaLYlYmSJLMTXpR3EfPly7qUF7b4pCpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maher Sanalla <msanalla@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 031/328] net/mlxfw: Drop hard coded max FW flash image size
Date: Tue, 11 Mar 2025 15:56:41 +0100
Message-ID: <20250311145716.131381502@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maher Sanalla <msanalla@nvidia.com>

[ Upstream commit 70d81f25cc92cc4e914516c9935ae752f27d78ad ]

Currently, mlxfw kernel module limits FW flash image size to be
10MB at most, preventing the ability to burn recent BlueField-3
FW that exceeds the said size limit.

Thus, drop the hard coded limit. Instead, rely on FW's
max_component_size threshold that is reported in MCQI register
as the size limit for FW image.

Fixes: 410ed13cae39 ("Add the mlxfw module for Mellanox firmware flash process")
Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Link: https://patch.msgid.link/1737030796-1441634-1-git-send-email-moshe@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
index 29e95d0a6ad13..5fa1b7c33c54f 100644
--- a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
+++ b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
@@ -14,7 +14,6 @@
 #define MLXFW_FSM_STATE_WAIT_TIMEOUT_MS 30000
 #define MLXFW_FSM_STATE_WAIT_ROUNDS \
 	(MLXFW_FSM_STATE_WAIT_TIMEOUT_MS / MLXFW_FSM_STATE_WAIT_CYCLE_MS)
-#define MLXFW_FSM_MAX_COMPONENT_SIZE (10 * (1 << 20))
 
 static const char * const mlxfw_fsm_state_err_str[] = {
 	[MLXFW_FSM_STATE_ERR_ERROR] =
@@ -111,7 +110,6 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlxfw_dev,
 	if (err)
 		return err;
 
-	comp_max_size = min_t(u32, comp_max_size, MLXFW_FSM_MAX_COMPONENT_SIZE);
 	if (comp->data_size > comp_max_size) {
 		pr_err("Component %d is of size %d which is bigger than limit %d\n",
 		       comp->index, comp->data_size, comp_max_size);
-- 
2.39.5



