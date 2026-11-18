Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027697;
	b=qKaN0eYuVMQmD52iTHVYNvMuTQd82yDqNU6bbh90CPZnKm+TeaXPg9pGI7gPg6Rril9X
	 EIAKpADuNWBlo6eKxVPjofvUWvJVRCNCYqM+SXXG1kT1NG6g26VtpZhYfxlWixKhOv7wy
	 M8rgM4bHpVlBdeedkgmcGCRq3C4IP4sgODkwBbV9kiiMTxGFmYQRhZfEHHKLjy4tYgpz6
	 HrDOoq0ZZWlnvcvuexguB5VxfdqgcJB5civGCMbxsfDaXdNos6Y+VCZ/SSm/7/Ev/Y+LA
	 Hef58QeClvehsx2fVF8fbxK/7MKAUW35IOK4cJ93Ms5T8fNpMe6aPFIR2mzEEJmXeeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027697;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9w2kSUbX2yvJTiuoaSUbe7ytLSig0W43B2nu00zPIBA=;
	b=R2xsqf8Pylz2ivxZcUWq8ZsC69hn/uB4wgf989eGeP6o0Kqe9x9v3DRZZoY7JcwSN0xY
	 87GIMpGt/jPPQRCU/fjEkE9M/0fr+CP4Hv5h4+oGIuNsaUW66t9q9HVe90TDMefi6HOQf
	 /4bQmoT69MRUXHLhQk/M9k/QUVcsFlQAwq65K260ZlcWuh08Mi5vhxtaI9viMwXuKbRnS
	 SZ8GtDuS2my2x8s4lwkLLqoCn+uPw7RGxhXFZ2vnD8Y1x8NC9B7rWCcEaM5nManXPqiPg
	 lZJT2Y8FDt+L7rXQdO7Ov5VTIJsRrK15G3eKxyJnMY/uMlI12aYRJ55ToGI6E4UmIUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SxEyBR2a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298BC606A33E;
	Wed, 18 Nov 2026 18:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SxEyBR2a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 820DB1F000C9;
	Wed, 18 Nov 2026 18:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027697;
	bh=9w2kSUbX2yvJTiuoaSUbe7ytLSig0W43B2nu00zPIBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SxEyBR2aA5n42p3UbQ/wcnoLSba1KmEVfX4Byoe8RAkWwicbz/E7tPRbEliu7bctH
	 6roA5AyOTB9iswUFHV7Yp8idB8bHjxT0uEt8z/3TxUHH6WXtvCbag1XrLgWIW7jsOS
	 Zk2bcK+EuCo3zD6vTpJuVNquiyKpVE9VWt2OcVfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Maurizio Lombardi <mlombard@redhat.com>,
	Daniel Wagner <wagi@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1882/2151] nvme-fabrics: limit each queue type to the number of online CPUs
Date: Wed, 18 Nov 2026 16:00:17 +0100
Message-ID: <20261118150230.354011196@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Wagner <wagi@kernel.org>

[ Upstream commit 99fd0cbae84988e0af34784aa18ddd51ae094ade ]

nvmf_nr_io_queues limits each queue type to the number of online CPUs
when asking for I/O queues, but nvmf_set_io_queues hands out the
granted queues without these limits, and only nr_io_queues is clamped
when parsing the options.

E.g. with 2 CPUs, nr_io_queues=2, nr_write_queues=10 and
nr_poll_queues=10, 2 + 2 + 2 = 6 queues are requested, but handed out
as 4 default, 2 read and 0 poll queues.  blk_mq_map_queues can't create
more CPU masks than there are CPUs, so default queues 2 and 3 take over
the CPUs of default queues 0 and 1, and connecting the I/O queue of
default queue 1 fails with -EXDEV.

Apply the same limits in nvmf_set_io_queues.  A queue type with more
queues than online CPUs always has a hardware context without an online
CPU, so no working setup changes.  The options are not modified, so the
limits follow CPU hotplug on reconnect.

Fixes: 6486199378a5 ("nvme-tcp: fix queue mapping when queue count is limited")
Fixes: a249d3066de6 ("nvme-fabrics: add queue setup helpers")
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Tested-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fabrics.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index 9c3e0c755ce54..03941bcd2dd97 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -1125,18 +1125,27 @@ static int nvmf_parse_options(struct nvmf_ctrl_options *opts,
 void nvmf_set_io_queues(struct nvmf_ctrl_options *opts, u32 nr_io_queues,
 			u32 io_queues[HCTX_MAX_TYPES])
 {
+	/*
+	 * Each queue type is mapped to the CPUs separately, so a type with
+	 * more queues than online CPUs has hardware contexts without an online
+	 * CPU.  Use the same limits as nvmf_nr_io_queues.
+	 */
+	u32 nr_io = min(opts->nr_io_queues, num_online_cpus());
+	u32 nr_write = min(opts->nr_write_queues, num_online_cpus());
+	u32 nr_poll = min(opts->nr_poll_queues, num_online_cpus());
+
 	memset(io_queues, 0, sizeof(*io_queues) * HCTX_MAX_TYPES);
 
-	if (opts->nr_write_queues && opts->nr_io_queues < nr_io_queues) {
+	if (nr_write && nr_io < nr_io_queues) {
 		/*
 		 * separate read/write queues
 		 * hand out dedicated default queues only after we have
 		 * sufficient read queues.
 		 */
-		io_queues[HCTX_TYPE_READ] = opts->nr_io_queues;
+		io_queues[HCTX_TYPE_READ] = nr_io;
 		nr_io_queues -= io_queues[HCTX_TYPE_READ];
 		io_queues[HCTX_TYPE_DEFAULT] =
-			min(opts->nr_write_queues, nr_io_queues);
+			min(nr_write, nr_io_queues);
 		nr_io_queues -= io_queues[HCTX_TYPE_DEFAULT];
 	} else {
 		/*
@@ -1145,14 +1154,14 @@ void nvmf_set_io_queues(struct nvmf_ctrl_options *opts, u32 nr_io_queues,
 		 * sufficient queue count to have dedicated default queues.
 		 */
 		io_queues[HCTX_TYPE_DEFAULT] =
-			min(opts->nr_io_queues, nr_io_queues);
+			min(nr_io, nr_io_queues);
 		nr_io_queues -= io_queues[HCTX_TYPE_DEFAULT];
 	}
 
-	if (opts->nr_poll_queues && nr_io_queues) {
+	if (nr_poll && nr_io_queues) {
 		/* map dedicated poll queues only if we have queues left */
 		io_queues[HCTX_TYPE_POLL] =
-			min(opts->nr_poll_queues, nr_io_queues);
+			min(nr_poll, nr_io_queues);
 	}
 }
 EXPORT_SYMBOL_GPL(nvmf_set_io_queues);
-- 
2.53.0



