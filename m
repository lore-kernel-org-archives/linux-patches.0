Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229D33859CE;
	Tue, 10 Mar 2026 11:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141663; cv=none; b=ohU/58qVAHk8sorYMBfWKDzyTu9F3wvNyUpaC9V4Ykgs1AnqylW3vhZqNPdY8ESX+M10dHS5zWW2BWQRhfDVL6VujnPRYBTd3xGaXkDllLzCCldIoRkNusUeqyMzxYSuUZPoAdwK/QuxRaXU5B+r/uFdwJyJeN4OeBIZfcFGnkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141663; c=relaxed/simple;
	bh=Lq34gKS0CEe5kroUw8u6Jnz0iOVKaelNfEAOG7QtBS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XG0v1s3cesZr9oSPGhFF1aW3683fowwcE3KKw6EVS2TjtQr4N4f+gt51QSAVCUwrkMrXeKq9EPnrsJ+B7Ro5Iqk2uIy8+taSmPnhJmFpkmD2XvgZicuOtysHxJYjVopM6/g4E+iRLs8unL2a+8TgS8Gla2kDRvUPEH91c+vB9c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rrPsSu9f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rrPsSu9f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66CBBC19423;
	Tue, 10 Mar 2026 11:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141663;
	bh=Lq34gKS0CEe5kroUw8u6Jnz0iOVKaelNfEAOG7QtBS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rrPsSu9fNByg2OboxO3D6bw2jHpgKffyt50U8qNgSyUqF2XcNix4GBpSBDJkgYoQH
	 DG2koqghF4TtIs4T4XViwNOD7doptqq0VidOWpCjruYq9y7d5fc8yHtBqf7fcGpv7k
	 RZJAyQh+m+eTi1Tjz+r2rLmn3+FOgE6nP6MdPz2lmDRIy/3fWkX05C8A4yXiGC0QbD
	 krqe7/Ioys2G0p71W+hMbYbPVZv+C0Cunj4RYTPPm6+EGVmOYuxcByzWrSzaKLghqY
	 kYtROmWaQqcbW+yw8CDMSZXgPjpa1VymDpZyYKaMrF1C7sm1wXQx+8AIhixU6DdYKs
	 aBiGPQXOravzQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lizhi Hou <lizhi.hou@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 030/314] accel/amdxdna: Validate command buffer payload count
Date: Tue, 10 Mar 2026 07:14:49 -0400
Message-ID: <133df64fe3ea424277aa9a179bb25a00bf6e2b58.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit 901ec3470994006bc8dd02399e16b675566c3416 ]

The count field in the command header is used to determine the valid
payload size. Verify that the valid payload does not exceed the remaining
buffer space.

Fixes: aac243092b70 ("accel/amdxdna: Add command execution")
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260219211946.1920485-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_ctx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/accel/amdxdna/amdxdna_ctx.c b/drivers/accel/amdxdna/amdxdna_ctx.c
index 856fb25086f12..cfee89681ff3c 100644
--- a/drivers/accel/amdxdna/amdxdna_ctx.c
+++ b/drivers/accel/amdxdna/amdxdna_ctx.c
@@ -104,7 +104,10 @@ void *amdxdna_cmd_get_payload(struct amdxdna_gem_obj *abo, u32 *size)
 
 	if (size) {
 		count = FIELD_GET(AMDXDNA_CMD_COUNT, cmd->header);
-		if (unlikely(count <= num_masks)) {
+		if (unlikely(count <= num_masks ||
+			     count * sizeof(u32) +
+			     offsetof(struct amdxdna_cmd, data[0]) >
+			     abo->mem.size)) {
 			*size = 0;
 			return NULL;
 		}
-- 
2.51.0

