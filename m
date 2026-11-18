Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031770;
	b=QJUhFyuzzr/C1jiVHEhusg/OIZgrbXyxC4a0F7TMZCI69GgjwaiA1J6BI+zJ6wAIoJ/a
	 Srzh82AsGyqP0PCF8vCiJZcb9DQHj6EzEU4KgLfuXuOgoriz/vrW5u8xrrO3lKfeD8Xcq
	 ciayfcZIaspA1a7+CwwIblB4kXRk1ucA4MltMUOp1qscYwR/sRcObKggkDa5E8Jcquo92
	 m01PNWT/UIK+Ywh2Kg39XnL16L7Rp31eYlLg6FD/2AlcbVTehZGhJGsrCRej9NuUclqE3
	 ZPUPdozWJvRKPew2KbZNmiAxFqDmLPF9Gn0ehBb/AzIT+VebJQXlh906rVDxLr9DjHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031770;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1Y3OEMz73vaayWohgQ75owsvc+hl8lyJZ3V92GsmuoY=;
	b=pgDl/oP/9QeewVfDKkzDQM/5GcDCdvU1hauYqumXwYrJQ65aEYpqs1ej5G4qWjVnTezc
	 BzX9s3txIo2yEZbP09HV4pdpuSDpt4AwWsWEDbRsdoNwY0/AhKLdK6Gspxi/ezTGzu0Mf
	 HO6LlwfeN/NNQ3SAg9pup57q4Yq4zzF6vYbnFLcCzAKxojoYWQN7Z5fME/ydqCz/A9bii
	 87Kjp5c0Frdz16m9yQ8PadHGBxRd5BjJUZdym54mNBTzriPX+T4634FwRH0QLuvGUIfDp
	 k6+YnG4OFAG26UgeOtcGHSwGpzWga4kGHIMAvleZbVeJgkZeJyWoi1UY3wHGWvtkwIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w4XFHFez;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5CD606A336;
	Wed, 18 Nov 2026 19:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w4XFHFez
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C601F000C9;
	Wed, 18 Nov 2026 19:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031769;
	bh=1Y3OEMz73vaayWohgQ75owsvc+hl8lyJZ3V92GsmuoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w4XFHFez5Jt2ceYM3imfsv34Ld/AVHIK/mYChtyvP0uPlExvHV+FcWhDL+e27UqT4
	 X3lh+q5YqgAAUEp35aC9J/q45YSJwHmdiY48OA9gPz4FGKhLZ5N1xSBCvdIvTm0kst
	 f9zGkPs08qqAk5L30uVhUh62Za9A57aLJDpyJfds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Yao Sang <sangyao@kylinos.cn>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1148/1756] nvme: pass partition flags to passthrough checks
Date: Wed, 18 Nov 2026 15:54:35 +0100
Message-ID: <20261118150055.744325177@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yao Sang <sangyao@kylinos.cn>

[ Upstream commit 6908a702955929b0876baac9fdc57070780a76f0 ]

nvme_user_cmd() handles NVME_IOCTL_IO_CMD on namespace block devices,
including partitions. It receives flags identifying a partition, but
passes 0 to nvme_cmd_allowed(), bypassing the partition guard and
allowing unprivileged passthrough commands to access sectors outside
the partition.

Pass flags to the permission check, rejecting unprivileged commands on
partitions.

Fixes: 313c08c72ee7 ("nvme: don't allow unprivileged passthrough on partitions")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Yao Sang <sangyao@kylinos.cn>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 22a98e75d8962..e0aa394c0482d 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -361,7 +361,7 @@ static int nvme_user_cmd(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	c.common.cdw14 = cpu_to_le32(cmd.cdw14);
 	c.common.cdw15 = cpu_to_le32(cmd.cdw15);
 
-	if (!nvme_cmd_allowed(ctrl, ns, &c, 0, open_for_write))
+	if (!nvme_cmd_allowed(ctrl, ns, &c, flags, open_for_write))
 		return -EACCES;
 
 	if (cmd.timeout_ms)
-- 
2.53.0



