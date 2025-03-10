Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D6D1C3F34;
	Mon, 10 Mar 2025 17:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628792; cv=none; b=InXbHWo4SoiU4F8GBShBUFR+JJnXgP7HFfOlHoMIOKBNpuUuVDHEBFomyByy4YLFhX3wBWmRe16Z/+D9pSU2YeCZI8DGIqL1suYepFzB35oJCng9m+/19+05b8NQkXvkLrurHrb9gNo4YPRoC3kwdeGBwjcEnVVxeh/fhIMXadY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628792; c=relaxed/simple;
	bh=V39WzSTZiOaEfz9obzu9gduwDHBx8xe7EuDiHOkUdDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T3JV0pH8BpWmaIRSFRpJSDDyJ8tqi4XSswP3dkcLFoAMSiYS+rD84xrKYY3xaQRpy9cVV3fU/wDLDhS9HpK1YaofZwC+BfHYrexdQsAigt0qIHDfryLNw0eca7USWvKgrcM8XxkJSxCcV/4svJKhkKM3QIhZ9P0jenzqsQDwRm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OIH39/+G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OIH39/+G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A35C4CEE5;
	Mon, 10 Mar 2025 17:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628792;
	bh=V39WzSTZiOaEfz9obzu9gduwDHBx8xe7EuDiHOkUdDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OIH39/+GUESOUYHi4vGcAuRXZLq2+KzWXG3qPv0arFn/JlgRpuKSgm39aJXV/Z6dk
	 T8UkJxb19X21VlJOyx7nippQLEyzBI8bEFTzghns26xKmh6sSiJOyZbAoWOwtMxmWx
	 /GLCiXIv5GGgz2g+5iCcIrinZDT7UToqo2HdirF4=
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
Subject: [PATCH 5.15 070/620] net/mlxfw: Drop hard coded max FW flash image size
Date: Mon, 10 Mar 2025 17:58:36 +0100
Message-ID: <20250310170548.342774665@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 46245e0b24623..43c84900369a3 100644
--- a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
+++ b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
@@ -14,7 +14,6 @@
 #define MLXFW_FSM_STATE_WAIT_TIMEOUT_MS 30000
 #define MLXFW_FSM_STATE_WAIT_ROUNDS \
 	(MLXFW_FSM_STATE_WAIT_TIMEOUT_MS / MLXFW_FSM_STATE_WAIT_CYCLE_MS)
-#define MLXFW_FSM_MAX_COMPONENT_SIZE (10 * (1 << 20))
 
 static const int mlxfw_fsm_state_errno[] = {
 	[MLXFW_FSM_STATE_ERR_ERROR] = -EIO,
@@ -229,7 +228,6 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlxfw_dev,
 		return err;
 	}
 
-	comp_max_size = min_t(u32, comp_max_size, MLXFW_FSM_MAX_COMPONENT_SIZE);
 	if (comp->data_size > comp_max_size) {
 		MLXFW_ERR_MSG(mlxfw_dev, extack,
 			      "Component size is bigger than limit", -EINVAL);
-- 
2.39.5



