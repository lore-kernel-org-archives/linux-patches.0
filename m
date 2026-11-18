Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018896;
	b=qPQjBHb2fFjjRYF7xr5vofKY+cqPrKiaCSLcjDlO7wYlLYExJEDvvH8PsnzFSYGEzYJG
	 i9tRgtUe10bAQBzM9WhSnSIC/khfQOetstQdl+tkw49nI1c8tdd3ELZF+gMOBoMOz+rM/
	 oY3RkwTys7vBULSVOLVCmIbpzEhFfGOItoOflcyMVOskPoiSlpf78VCjdDtUxbSUy8GK/
	 Kz8ycSd4Zz8Gt8+7f6TAmlDOnrvvFSbwstOlpPLnU4dipg1X3+mbAfbDATLbNPRiZLIWY
	 RCXNTDv2LEHPfWo6tRqWHF2sqjc6G7osmdtmkR2NYGSqcjDQ38BRwsMc0R5CdEF6wXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018896;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RPrdKqNKsXkgFHmPRFalErLe8/D7l3KaevoeSHv5qSQ=;
	b=gH3jQHOJ/zBFOglwvtGztco183yIeHYJfYTDH4xbYO66vFXPRvsjIkwiuhIViwYDHMOO
	 hKEx3pGLI4QTDghELeEu7uqJGLDzjlHQXitwngY9SFnCqR7dUSZ4n2smbhJjnUXPAUzhP
	 c7QwO3Gx9VdWmDNCRNkKoDo65T/6WGRsREi63fzFAStA0It2l0gBw+JpW8x/53P6ZYFHV
	 y97XXMQ4B+ZdQN9lBiKdgr+WSVfabZTXlrJe/vp9QcMAqZ6AwWWFfHJQ5ka3Wayil4AjH
	 7mazJeb8n4/v1ABwtf5vnSEvHgpL66gBHLkV22o3eKzf1AO7RlMf/lqjoONmq7BBndg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1fUfjpFF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E2E606A31C;
	Wed, 18 Nov 2026 16:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1fUfjpFF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 617951F000C4;
	Wed, 18 Nov 2026 16:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018895;
	bh=RPrdKqNKsXkgFHmPRFalErLe8/D7l3KaevoeSHv5qSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1fUfjpFFNXDwzH7A2wyGggDo4AAALDAfcUNB+OBthoX5HB40b/CkuWQ97uw2HgN9A
	 OOlZCiASjPWoDQQgLauH2HrsLyh3gZ/kI0lghkWGCBW1ryI9D+rPPm/LmNblFNTaku
	 5e2Wn8slNSdWWejlPupO2lT2UuuP7QCWP2Y28OXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1404/2651] wifi: mm81x: check bytes_remaining before reading delimiter
Date: Wed, 18 Nov 2026 15:44:04 +0100
Message-ID: <20261118150338.559007167@linuxfoundation.org>
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

From: Muhammad Bilal <meatuni001@gmail.com>

[ Upstream commit 54a54c06868d0c2beb9ec3e2ffda0f6cb33d5c8e ]

mm81x_yaps_hw_read_pkts() reads a full 4-byte delimiter and then
subtracts sizeof(delim) from bytes_remaining on every loop iteration,
guarded only by "bytes_remaining > 0". If 1-3 bytes are left in the
window, this reads past the end of the valid data and then subtracts
4 from a value smaller than 4, driving bytes_remaining negative.

A negative bytes_remaining then reaches the total_len > bytes_remaining
branch, where "bytes_remaining" is passed to memcpy() as the copy
length. Implicitly converted to size_t, a negative int becomes a
huge value, turning that memcpy() into a massive out-of-bounds copy.

Bail out of the split loop once fewer than sizeof(delim) bytes remain,
the same way the existing "end of stream" check bails on a zero
delimiter.

Fixes: b1906cea00b0 ("wifi: mm81x: add mm81x Wi-Fi HaLow driver")
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://patch.msgid.link/20260919192231.272078-1-meatuni001@gmail.com
Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/morsemicro/mm81x/yaps_hw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/morsemicro/mm81x/yaps_hw.c b/drivers/net/wireless/morsemicro/mm81x/yaps_hw.c
index 3d641d23c35ba..e1102b8fb8020 100644
--- a/drivers/net/wireless/morsemicro/mm81x/yaps_hw.c
+++ b/drivers/net/wireless/morsemicro/mm81x/yaps_hw.c
@@ -486,6 +486,9 @@ static int mm81x_yaps_hw_read_pkts(struct mm81x_yaps *yaps,
 		int total_len;
 		int pkt_size;
 
+		if (bytes_remaining < (int)sizeof(delim))
+			break;
+
 		delim = le32_to_cpu(*((__le32 *)read_ptr));
 		read_ptr += sizeof(delim);
 		bytes_remaining -= sizeof(delim);
-- 
2.53.0



