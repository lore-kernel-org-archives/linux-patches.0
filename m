Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060732;
	b=keUlUMCGP/NMU9xdJfmfb5jw9ztYKBxbIVHcP1DPdfabppDvsae5ylLRPfWPYVswta9B
	 BpkXi3O9QCeM3TPvnXVZktYwJjap0pujqmyRkHZadABTyLR/5FSPhQxECi9G6eUye1nwN
	 IFu4Sz0adJmpRiNwKXPvqly9mzqWM21olfz+R7MLIVoW0yZW1CSZMaIMDzoxt++mgcKWc
	 YvKuxG5a0W1XT4dQBvjV/k37f+twe4XpTYNFY6YglFtFeB6blDY10rEXvc2Had2TlZpmb
	 rEcMeD4u+YT5bm72U41ejkT/vd0VOkl9W2YiAOC2l4LJ9JT3NfbTPZeWyQ6iV9aRBow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060732;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s+oyBK85GbX10LM25c0bTyxx9IT+yRVwi1trjNfOH+k=;
	b=fS0vJjzrj6a/7UhNWEdjz2xN4g9yis2kK+8KwhRcz2l7rqrDx0lPcy040c/j5PyUyxGg
	 TRBiKnMgU7v7BJn74GbM3uEFoiYTdM9X1f4pQA1qn8Xi+Syg/Y7lulO47cgUwic+Fgu7e
	 VcV4ZZRjdBDYNXzwkqwa9QD79aSDeuBknqPJAR3xnhgtDUdcYVs+ESKaQk69WL+ibty2L
	 QQPLQLabap6/ZFY6+KUBgDVUk2IhtqYnHYGF3SNwsSS3lMAxK8kMRHQyw7xVT288zZ69U
	 1sMrHdDHTMKLIkfVrPzVP51HOSoblBYeMKXDj/OBJLpVD2MK9vmirvwg1ofa4GQm7FA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QvsY1PBT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED5C606A326;
	Sat,  7 Nov 2026 14:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QvsY1PBT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35BD21F0089F;
	Sat,  7 Nov 2026 14:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060732;
	bh=s+oyBK85GbX10LM25c0bTyxx9IT+yRVwi1trjNfOH+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QvsY1PBTmMHl/Xp2dDE3W2odtjch1c7oHcLFnTLrl9MRpwSu+Dv+CjnDRZ6rrKI95
	 sH9q5RnzyeLMejPPihyjrmQTmzsWJ8VN8JqqvvDJ9xH7fIpjtHLZG9vZcUDTFe+lTX
	 plBVIYXnKG+QJsCTvPVS8eXlhNgSOgRtGNK9eO/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Hari Mishal <harimishal1@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0124/1536] nvme: bound ns descriptor header and body to identify buffer
Date: Sat,  7 Nov 2026 08:35:40 -0500
Message-ID: <20261107135001.168904342@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Hari Mishal <harimishal1@gmail.com>

[ Upstream commit 3c568b35a0d309acb40746552bec2af24cd550ef ]

nvme_identify_ns_descs() allocates a buffer and gives it to the
controller, which populates it and then iterates the buffer with
variable byte increments that vary by type and body size.  But, there is
no bounds check inside the iteration itself except the loop bound
itself.  Fix this by checking and stopping iteration if the next header
or its declared body would go past the buffer itself.

Assisted-by: gkh_clanker_t1000
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hari Mishal <harimishal1@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index bb274fecbec48..cf79a6c45ccd3 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1540,8 +1540,12 @@ static int nvme_identify_ns_descs(struct nvme_ctrl *ctrl,
 	for (pos = 0; pos < NVME_IDENTIFY_DATA_SIZE; pos += len) {
 		struct nvme_ns_id_desc *cur = data + pos;
 
+		if (pos + sizeof(*cur) > NVME_IDENTIFY_DATA_SIZE)
+			break;
 		if (cur->nidl == 0)
 			break;
+		if (pos + sizeof(*cur) + cur->nidl > NVME_IDENTIFY_DATA_SIZE)
+			break;
 
 		len = nvme_process_ns_desc(ctrl, &info->ids, cur, &csi_seen);
 		if (len < 0)
-- 
2.53.0



