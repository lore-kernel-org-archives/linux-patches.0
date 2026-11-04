Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829468;
	b=kD4saXuci1RFo0K+pw3A+K3aSHh6rrZFVIDz5dS3EEWNagwco5B98CwUL6WzN11Di+LA
	 vFU7/3OzWDH2h3qsOw+WmokJsHMAJCxhiTHVxkGR6OphN1pts27erDJNq6Vgii23NVYTM
	 pij3M6VEcGI8XLTTo8cTinUmQZybehPEPBf8edCdOdfZ249OvFvuiLt7BHb6OC2eG8f9g
	 IgwpPtxM2kESCyTRBS2wZX9oJj3y1pqnEGrehad9A23wlpv6DP1E+l3IwX3RbeyKyQJUW
	 H0Mgq6V1qA04wAE2is2ta/DGynCDKzmDb3q31fpmOQepwXIgC3kgXjsqgUQkZjfLR2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829468;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OIRuitLMMU3p0W37kDFFWA8m+iYfUmhJx+QH+cATtTs=;
	b=3HipN2/K6kq78C1Tq01tjwa8SwkiAQ6VBNcnD7ooY+3VFoSfcDNQ7VmqC9xbQ9LI8umn
	 YYzF8I984P2VyYymP5FueuGuuvHtmmXCJlordr10ufOX7hwyrDrRvItR0O3qw83qATeZt
	 41C1c/kMXBaC77yiHOWepykO3s9/RA6zoy5ZINVs5zGESzzfvMntSCeBCkqY8VBO1Pwcj
	 ojpKWNXJe1mk7SjOnFEMjom/IZ9rT1wyRDI8MhHY1MPPvUIPNYhi/viW/T6i/4sEzD+Sx
	 wNgPXnPNZjeajBBIEL8DGkuFJTzvYaPdZj+O+0CwbTDhDbil0JVirJSwoCkb89G/iYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0GvdGTW2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C412606AB0B;
	Wed,  4 Nov 2026 21:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0GvdGTW2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DB721F000C1;
	Wed,  4 Nov 2026 21:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829468;
	bh=OIRuitLMMU3p0W37kDFFWA8m+iYfUmhJx+QH+cATtTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0GvdGTW2rEIhh1j01poSAgN2Zx+P+6Lh6+lXdANyWjVVBYwUzh5QmQptH1rGy8Nmh
	 085+MJKhfXtcGh9OYxNTwxBGqhiEU82FlzVKiBeWMgDDyyt66UAmiX2klZ3M369m6n
	 1x7VJtBaeE5vc05tz1h0urZj8QdmsegASYsBVo+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Hari Mishal <harimishal1@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0145/1005] nvme: bound ns descriptor header and body to identify buffer
Date: Wed,  4 Nov 2026 15:57:58 -0500
Message-ID: <20261104211047.766823144@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index d5fb6612fa229..5ed62e070f715 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1564,8 +1564,12 @@ static int nvme_identify_ns_descs(struct nvme_ctrl *ctrl,
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



