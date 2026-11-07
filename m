Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062205;
	b=wSDwA+EO4sRrzM9WM+JmULzsld9wpIZ6KWjiyrwD+ZTndgwG5fIjbSBd/6o3aD6/xkA4
	 Im6iMCynASpoPrvmQVK1U2NC1TlfZ2vyPAArenqf5WU4ZAwNStTtvQ5B+5RjdloDIuty5
	 9BoltLUfvqWr+KWU9hJzFKfxANbTNwTLUtyz+OOxWtDwaLUFlwkeCxHCfqcRQFkEuVh4M
	 nU2vvs2d7yB4cNytZjfBtaoGd8WwYvOC5iNBB5dKgqcPyGl/vJ6NQ7VQvhmR/c9fUjV3L
	 bPsRY90KC+d5kE3kKYFZqUgdJ2JN7YnSvBQ1AhSeJkqpNUS9NJDJVHt6414SHIpkbmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062205;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mwMTafpAgPns/b/5WGpPZuFH/MsLuRBSV1/C8rH7IzM=;
	b=G+WGuc2Gjz2eqVFNkIhIVe3ZRTH69uWuVTePvC00/wumW7cdhwkafeKdd+iDXl2DDk4y
	 rmUnOj2wXAS0ql8ElHS7AGjCYMXNaKGolBwYf13oVQnOu658K8Y+uoMsmWOuy8XR6UvDa
	 py+quTLEAHATlec0Zc75KFjaZPkuJhpX7xemzuWbeOr81Tqog3CzPNgVActE9P50frL25
	 NxjgDPIAXKtYC3+SI50ti9m+6bYwehdY1uyIr/T315MH+34nYAx5Lre9b1d0Ir/ZsTEK7
	 X8FD+0iaaFqyJsStt601CiJlN9y3pYwEVyJ3GohnWvFmpNIaTXsUi2K+BW7DO4s5B4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=igGtd9WW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37702606A326;
	Sat,  7 Nov 2026 14:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=igGtd9WW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2CAB1F008A5;
	Sat,  7 Nov 2026 14:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062205;
	bh=mwMTafpAgPns/b/5WGpPZuFH/MsLuRBSV1/C8rH7IzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=igGtd9WW9KwBRr+5phx0l5FeVcFK6m86YAB/RAmwPyHvqS77TNDdYdW4I12gNCjNV
	 DKgvvqTdNjoIk/Jjbf4IQEqdnI+Jp9hSTVHe+06MDnR1Eq5ui+e9Ve57BRxsUl3Mfs
	 bZC8+YGWL0PeTcOf6fOWcVXIQSu90cpybmdH2yEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tharit Tangkijwanichakul <tharitt97@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1153/1536] media: hantro: Harden MPEG-2 control access against NULL
Date: Sat,  7 Nov 2026 08:52:49 -0500
Message-ID: <20261107135030.110196054@linuxfoundation.org>
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

From: Tharit Tangkijwanichakul <tharitt97@gmail.com>

[ Upstream commit 2b685dba4226792933f45b1cbf8991e89ccd21ce ]

The MPEG-2 sequence and picture controls are validated
before a job is queued, so hantro_get_ctrl() is not expected to return
NULL in hantro_g1_mpeg2_dec_run(). The controls are nonetheless
dereferenced unconditionally.

Harden the invariant by checking the sequence and picture controls with
WARN_ON().

Found by code inspection.

Fixes: f329e21e9dad ("media: uapi: mpeg2: Split sequence and picture parameters")
Cc: stable@vger.kernel.org
Signed-off-by: Tharit Tangkijwanichakul <tharitt97@gmail.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/verisilicon/hantro_g1_mpeg2_dec.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/platform/verisilicon/hantro_g1_mpeg2_dec.c b/drivers/media/platform/verisilicon/hantro_g1_mpeg2_dec.c
index e0d6bd0a6e44f..6a942f4b8a2dd 100644
--- a/drivers/media/platform/verisilicon/hantro_g1_mpeg2_dec.c
+++ b/drivers/media/platform/verisilicon/hantro_g1_mpeg2_dec.c
@@ -161,8 +161,13 @@ int hantro_g1_mpeg2_dec_run(struct hantro_ctx *ctx)
 
 	seq = hantro_get_ctrl(ctx,
 			      V4L2_CID_STATELESS_MPEG2_SEQUENCE);
+	if (WARN_ON(!seq))
+		return -EINVAL;
+
 	pic = hantro_get_ctrl(ctx,
 			      V4L2_CID_STATELESS_MPEG2_PICTURE);
+	if (WARN_ON(!pic))
+		return -EINVAL;
 
 	reg = G1_REG_DEC_AXI_RD_ID(0) |
 	      G1_REG_DEC_TIMEOUT_E(1) |
-- 
2.53.0



