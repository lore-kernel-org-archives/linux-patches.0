Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016264;
	b=xszdyy7ONEo07XTBqE7hCQrbSiFcUBMt7lryPwuXlLNg5HWlr7w9ORM75pRq3XtPIm1B
	 C7PEfQWriYrvpH53KggxVjD1ndp3MpfwHCZbPkdBqokpjLqp+1s/UpX380kvmGz7z149H
	 2juR7uzx7EkQy9mQjtL8EXNyF1U/vNGfFmziFrRmflYr8idahJS6Vn/eZxISJNV2Llk4e
	 iFLaXL0527s6U0oaNEjrC90Vzf/JHZMTgkL5TBgasGCHU8Nu//0atP36dENU623YBR5UR
	 h0tTP6/o7vOaOVJf6sdc3BygwcSaOutGP9YCLG4UZGBvAWOmXWEu6dx10vRUe4uHUug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016264;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Bnsle7qjqIj68En06V80YVi05smNAEQUHB9No/CKWuQ=;
	b=Wq8bNwF6wrmNjRyfZXhMelafFGvGHJQ4AeUnQA/H/xraO12N+LHgwTgsdPWEFeGBBPQ4
	 BcsGPCALpyLSsHyN1TfYId1CJwvpQ/Wl0ZuPAI1D8jKXJzu6Qt4WD93zClDyR3uG0QOg4
	 3Yztp4mPNI+hNAJghNVRktA+SgWpHJXiQm14A8NfiWEnM8u0/8xP+vhUu7f3LPmFzIgoN
	 G2w9wz9zQ5VXjfwE+46hWOw3+AU2p2XzMfRePbyUQU5U/1CIjoiQNwvDtJrJjFGrPSZ9V
	 lSFYr9vcUo6+nUbAZmlSHi9kpNPhfZumdDJIhy7VVif1UhjIWsF5E/my149+EOvJrTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=riFZBbOC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80E4606A338;
	Wed, 18 Nov 2026 15:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=riFZBbOC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BAB61F000C5;
	Wed, 18 Nov 2026 15:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016264;
	bh=Bnsle7qjqIj68En06V80YVi05smNAEQUHB9No/CKWuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=riFZBbOC9bmFE6jRIQMMAhJxgL5t0rrUxVrpI8Rmxe7GOglR01d4g3TcWcbbyXhBF
	 KfmqaiAXcXBrH1pugNtanNasHslzK9Zgx6g1QTMP1Aj3DcAJylWEBrCUb+F+7vOrTs
	 yBaox6vUt1PcTXEHPjAaxTcjGiekNwl+cWnolfW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0465/2651] f2fs: fix to record both APPEND and UPDATE ino entries
Date: Wed, 18 Nov 2026 15:28:25 +0100
Message-ID: <20261118150304.537142314@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiguo Niu <zhiguo.niu@unisoc.com>

[ Upstream commit 06768d77ed956b4bf0b588fcff2fae8cfcb67269 ]

In f2fs_post_evict_inode(), record_bits is assigned with BIT(APPEND_INO)
and BIT(UPDATE_INO) respectively, so the second assignment overwrites
the first one: when both FI_APPEND_WRITE and FI_UPDATE_WRITE are set,
only the UPDATE_INO entry is recorded.

The two flags are not mutually exclusive.Once the APPEND_INO entry is
lost after the inode eviction, the shortcut in f2fs_do_sync_file() can
take the flush_out path in the next fsync(), skipping f2fs_fsync_node_pages().
As a result, the dnodes holding the newly allocated blocks are not
fsync-marked, and after a sudden power loss, the data appended before the
eviction is silently lost.

This restores the previous behavior where the two ino entries were
added independently.

Fixes: 314c9e476ffc ("f2fs: call __add_ino_entry out of the eviction path")
Signed-off-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 96cc0e777567e..4a6382b4c6a5b 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -1055,9 +1055,9 @@ static void f2fs_post_evict_inode(struct inode *inode)
 		goto skip_record;
 
 	if (is_inode_flag_set(inode, FI_APPEND_WRITE))
-		record_bits = BIT(APPEND_INO);
+		record_bits |= BIT(APPEND_INO);
 	if (is_inode_flag_set(inode, FI_UPDATE_WRITE))
-		record_bits = BIT(UPDATE_INO);
+		record_bits |= BIT(UPDATE_INO);
 
 	if (!record_bits)
 		goto skip_record;
-- 
2.53.0



