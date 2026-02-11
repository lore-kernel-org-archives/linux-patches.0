Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A900F3128DA;
	Wed, 11 Feb 2026 12:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770813120; cv=none; b=gOgJB6zpNM8Vu52bTaxNMhubaXk1+iBdOE98AE0XbJWkbjcJtLUc32xLIKvk5Wefemnw4iZgK5834gi/Svytj9XmCM6xoDuJkxXRZ13pXPl6BuxwG4lFP0YyuBjtiEyaKbtWJlMnsFL28Y/8auXpLmaF6J/P6ksmPd0zRgxOSBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770813120; c=relaxed/simple;
	bh=d+JUQGbvTe0fG6MIJdLQbjmAgjtxNi6q9PB4HGdoLUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SskoEKqvxnA7ig0jbPIC+9ofINGspIy1wVlAVA+XaGpq4ATNPgPyBEfvtC3ZHsN/aI/XSS6QnoJtxCRmen8KX9AOjpTm5VaG5K4G2d6uMLWKvsOX3Vt+RZ/Sf+NqZnRrEn09Ldv4S7iycUDfnaPfDG85cZDe5w9d50gWT4PbX7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=irTlWRW9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="irTlWRW9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F9D5C19424;
	Wed, 11 Feb 2026 12:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770813120;
	bh=d+JUQGbvTe0fG6MIJdLQbjmAgjtxNi6q9PB4HGdoLUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=irTlWRW94pd8zqxFZPKHWYHMe9zCZAcWM7Ue8BZGVZbGiKT7kSRmRswFGhZfdkeNH
	 /A6YsKanLgUneXulkDIGYmWQE02H2kfDcQdT7ofs/7q8zqJmZ9uhNy2oLxYoc7C8Ij
	 NS64ncup59gZogJyJU3+L4nW0FszVmBranvmVR3Yh++Lcf8y/ZJrNAmk4komyl85UV
	 70X6S51xoy5CXRftXhFTILx0GCwG8oCodCK63hVn8ISduTlAcEmjTk8b1BvXfl8QB5
	 MQ5aQXrik5pZDcskZU2j6UwiyPjsQ6fY9lcxKzOuMZycm3YeXhdxPAInoT8DTB0wxO
	 zMlwnEjB2t7yw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Md Haris Iqbal <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Grzegorz Prajsner <grzegorz.prajsner@ionos.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] rnbd-srv: Zero the rsp buffer before using it
Date: Wed, 11 Feb 2026 07:30:34 -0500
Message-ID: <20260211123112.1330287-24-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260211123112.1330287-1-sashal@kernel.org>
References: <20260211123112.1330287-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Md Haris Iqbal <haris.iqbal@ionos.com>

[ Upstream commit 69d26698e4fd44935510553809007151b2fe4db5 ]

Before using the data buffer to send back the response message, zero it
completely. This prevents any stray bytes to be picked up by the client
side when there the message is exchanged between different protocol
versions.

Signed-off-by: Md Haris Iqbal <haris.iqbal@ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Grzegorz Prajsner <grzegorz.prajsner@ionos.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The entire data path is now clear. Here is my complete analysis:

---

## Complete Analysis

### 1. COMMIT MESSAGE ANALYSIS

The commit message states: "Before using the data buffer to send back
the response message, zero it completely. This prevents any stray bytes
to be picked up by the client side when there the message is exchanged
between different protocol versions."

While the commit message frames this as a protocol compatibility
concern, the underlying issue is actually an **information leak
vulnerability** — stale kernel memory data is sent over the network to a
remote client.

### 2. CODE CHANGE ANALYSIS

The fix adds two `memset(rsp, 0, sizeof(*rsp))` calls:

**First:** In `rnbd_srv_fill_msg_open_rsp()` before filling the
`rnbd_msg_open_rsp` structure (56 bytes total). Without the memset, 13
bytes are **never explicitly set**:
- `hdr.__padding` (2 bytes) — struct padding field
- `obsolete_rotational` (1 byte) — deprecated field, never written
- `reserved[10]` (10 bytes) — explicitly reserved for future use

**Second:** In `process_msg_sess_info()` before filling the
`rnbd_msg_sess_info_rsp` structure (36 bytes total). Without the memset,
33 bytes are **never explicitly set**:
- `hdr.__padding` (2 bytes) — struct padding field
- `reserved[31]` (31 bytes) — reserved bytes

### 3. THE BUG MECHANISM — CONFIRMED INFORMATION LEAK

Tracing the complete data path reveals this is a real information leak
over the network:

1. **Buffer allocation**: The RDMA chunk pages are allocated via
   `alloc_pages(GFP_KERNEL, ...)` in `get_or_create_srv()` (`rtrs-
   srv.c:1435`). `alloc_pages` does **not** zero memory (unlike
   `__GFP_ZERO` or `get_zeroed_page()`).

2. **Buffer reuse**: The chunk pages (`srv->chunks[buf_id]`) are
   allocated once at server initialization and **reused** across all
   RDMA operations. Each chunk may contain leftover data from previous
   block I/O operations (data read from block devices being served to
   other clients).

3. **Response buffer**: The `data` pointer in `rnbd_srv_rdma_ev()` is
   `page_address(srv->chunks[buf_id])`, pointing directly into these
   non-zeroed, reused RDMA pages.

4. **Client request direction**: Both `send_msg_open()` and
   `send_msg_sess_info()` on the client side use the `READ` direction
   for RTRS. This means the server processes these via `process_read()`,
   setting `id->dir = READ`.

5. **Response sent via RDMA WRITE**: In `rtrs_srv_resp_rdma()`, because
   `id->dir == READ` and `sg_cnt != 0`, the `rdma_write_sg()` function
   is called. This performs an `IB_WR_RDMA_WRITE` operation, sending the
   contents of the server's chunk buffer directly to the client's memory
   via RDMA. The DMA mapping is `DMA_BIDIRECTIONAL`, and
   `ib_dma_sync_single_for_device()` syncs the full response before
   transmission.

6. **What leaks**: The 13 uninitialized bytes in `rnbd_msg_open_rsp` and
   33 uninitialized bytes in `rnbd_msg_sess_info_rsp` contain whatever
   was previously stored in the reused RDMA chunk page. This could
   include **block device data from previous I/O operations** —
   potentially data belonging to other clients or other block devices.

### 4. SECURITY IMPACT

This is a **cross-client kernel memory information leak over the
network**:
- The server leaks up to 46 bytes of stale data per control message
  exchange
- The stale data can include block device content from other clients'
  I/O operations
- The data is transmitted over RDMA (network), reaching a potentially
  different machine
- This has been present since RNBD was introduced in Linux 5.8 (commit
  `2de6c8de192b9`)

### 5. FIX QUALITY

- **Size**: 2 lines added (`memset` calls), no lines removed
- **Correctness**: Obviously correct — zeroing a buffer before partially
  filling it is a standard, well-understood pattern
- **Risk**: Zero regression risk. The memset zeroes the entire
  structure, then the code overwrites the relevant fields. This is
  strictly safer than the original code.
- **Self-contained**: No dependencies on other commits
- **Tested in mainline**: Authored and reviewed by RNBD maintainers
  (IONOS team), merged by Jens Axboe (block layer maintainer)

### 6. APPLICABILITY

RNBD has been present since kernel 5.8. This fix applies to all stable
trees that include RNBD (5.10.y, 5.15.y, 6.1.y, 6.6.y, 6.12.y, etc.).
The patch should apply cleanly since the affected functions haven't
changed structurally.

### 7. CONCLUSION

This is a small, surgical fix for a confirmed information leak
vulnerability where stale kernel memory (potentially containing other
clients' block device data) is sent over the network via RDMA to remote
clients. It meets all stable kernel criteria:
- Fixes a real security/data-integrity bug (information leak over
  network)
- Obviously correct (memset before partial initialization)
- Small and contained (2 lines, 1 file)
- No new features or APIs
- Zero regression risk
- Has been in mainline; authored by subsystem developers

**YES**

 drivers/block/rnbd/rnbd-srv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/block/rnbd/rnbd-srv.c b/drivers/block/rnbd/rnbd-srv.c
index 2df8941a6b146..6afac85c110f2 100644
--- a/drivers/block/rnbd/rnbd-srv.c
+++ b/drivers/block/rnbd/rnbd-srv.c
@@ -538,6 +538,8 @@ static void rnbd_srv_fill_msg_open_rsp(struct rnbd_msg_open_rsp *rsp,
 {
 	struct block_device *bdev = file_bdev(sess_dev->bdev_file);
 
+	memset(rsp, 0, sizeof(*rsp));
+
 	rsp->hdr.type = cpu_to_le16(RNBD_MSG_OPEN_RSP);
 	rsp->device_id = cpu_to_le32(sess_dev->device_id);
 	rsp->nsectors = cpu_to_le64(bdev_nr_sectors(bdev));
@@ -644,6 +646,7 @@ static void process_msg_sess_info(struct rnbd_srv_session *srv_sess,
 
 	trace_process_msg_sess_info(srv_sess, sess_info_msg);
 
+	memset(rsp, 0, sizeof(*rsp));
 	rsp->hdr.type = cpu_to_le16(RNBD_MSG_SESS_INFO_RSP);
 	rsp->ver = srv_sess->ver;
 }
-- 
2.51.0

