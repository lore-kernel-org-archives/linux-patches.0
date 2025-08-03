Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257D3214236;
	Sun,  3 Aug 2025 21:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754255895; cv=none; b=ePogmEeA7NvqGPtWs5YhLhAkfBfHCnHBhK1uGR3xQDtU62v3Pv+K7yoQq393EhJk94sOAyIde6rxpEvs5THgrs9H5kkHx6TSL1mh+5OrnQXdTyhX+lF+93gDPOhqt3IeNpO5xbeCAJwJqoqBAnkC/pJYsERmZ0LCbxKmElQlNV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754255895; c=relaxed/simple;
	bh=4S3cEXFaIuMEUqfJ6RDkW/hfb2OMxXB4p7yq7Wx0Wnc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qrSSs2vHcPAOx8iQBM2I83V7ki/V7vwMZQ2kTaGj73MvKFIXNmUyHvOPZpc8hW/TwUxLpxgd0YKnMmLRDnGAf8j1KHDLf/l5HX2E94Q6DYniYjgFbeUCf8pPyJ3LZ22uYgYVHS0uk1Mkz9kUgbuAoy2GSu3dFYRsYqfmIfLUXms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qiM2eooJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qiM2eooJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E194C4CEF8;
	Sun,  3 Aug 2025 21:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754255895;
	bh=4S3cEXFaIuMEUqfJ6RDkW/hfb2OMxXB4p7yq7Wx0Wnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qiM2eooJf7yCE7c82447FmrViuwlSG6eZ7f+bkoC+uESXG+uZAv06cKOdV2AdPIYG
	 pdd0rzI0Ebfc5zvnPUXFMON+unLevbu4JayYd1xhBn+DRBlMALroUoIhiooyJSwh0q
	 ZiXu0gka5JuavB4pum5wtaQR62F8g7EJ/itUvzIBBMQQuTNm7KPPnEl1oJ4hdASO41
	 sbpvV/bscFHY4Fbgeb0Ecvcy2Ie5u9XWfKODS1NFLeWkCDmYOosYzFhAnVQCgDgk/L
	 oZcdjtUKMy1EwiHktduQ13sa8xPn8L9afJPs4fRMOiERy7/0/WFAq799h+WV9cMJ+t
	 Ysznz295WP7SA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Maurizio Lombardi <mlombard@redhat.com>,
	Laurence Oberman <loberman@redhat.com>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>,
	kbusch@kernel.org,
	sagi@grimberg.me,
	linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 6.16 15/35] nvme-tcp: log TLS handshake failures at error level
Date: Sun,  3 Aug 2025 17:17:15 -0400
Message-Id: <20250803211736.3545028-15-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250803211736.3545028-1-sashal@kernel.org>
References: <20250803211736.3545028-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 5a58ac9bfc412a58c3cf26c6a7e54d4308e9d109 ]

Update the nvme_tcp_start_tls() function to use dev_err() instead of
dev_dbg() when a TLS error is detected. This ensures that handshake
failures are visible by default, aiding in debugging.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Fixes a Real Debugging Issue**: The commit addresses a genuine
   problem where TLS handshake failures were being logged at debug level
   (`dev_dbg()`), making them invisible in production environments
   unless debug logging is explicitly enabled. This change promotes
   error visibility by using `dev_err()` for actual error conditions.

2. **Small and Contained Change**: The patch is minimal - it only
   changes logging behavior by:
   - Adding a conditional check `if (queue->tls_err)`
   - Moving the error case from `dev_dbg()` to `dev_err()`
   - Keeping successful handshakes at debug level

   The diff shows only about 10 lines changed with no functional
modifications.

3. **No Architectural Changes**: This is purely a logging improvement
   that doesn't alter any control flow, data structures, or protocol
   behavior. It simply makes existing errors more visible.

4. **Important for Production Debugging**: TLS handshake failures in
   NVMe-TCP can be caused by various issues (certificate problems, key
   mismatches, network issues) that are critical to diagnose in
   production. Having these errors hidden at debug level severely
   hampers troubleshooting.

5. **Mature Feature Area**: NVMe-TCP TLS support was introduced in
   kernel 6.5 (around August 2023 based on commit be8e82caa685), making
   it a relatively mature feature that's likely deployed in production
   systems requiring proper error visibility.

6. **No Risk of Regression**: The change only affects logging output and
   cannot introduce functional regressions. The worst case is slightly
   more verbose kernel logs when TLS errors occur, which is the intended
   behavior.

7. **Follows Stable Rules**: This meets the stable kernel criteria as
   it's a small fix that improves debuggability of an existing feature
   without introducing new functionality or risks.

 drivers/nvme/host/tcp.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index d924008c3949..9233f088fac8 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1745,9 +1745,14 @@ static int nvme_tcp_start_tls(struct nvme_ctrl *nctrl,
 			qid, ret);
 		tls_handshake_cancel(queue->sock->sk);
 	} else {
-		dev_dbg(nctrl->device,
-			"queue %d: TLS handshake complete, error %d\n",
-			qid, queue->tls_err);
+		if (queue->tls_err) {
+			dev_err(nctrl->device,
+				"queue %d: TLS handshake complete, error %d\n",
+				qid, queue->tls_err);
+		} else {
+			dev_dbg(nctrl->device,
+				"queue %d: TLS handshake complete\n", qid);
+		}
 		ret = queue->tls_err;
 	}
 	return ret;
-- 
2.39.5

