Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063039;
	b=HFMKzY86eoJntHK00VBdIwJRRP3AqcNggPBLDtoDkeLCHrXOObnmpdBn4CE5klIvl9Kc
	 yhSPJq1clsmUdjaMYDQP7Nlu4sSbPbx1Y98n1BLPllhEjnkLat2N15ZqDUzfWXfUp1QP0
	 Nvx8Rvq4V5Iik28jD9jNtDcJqFgUVrrCj7/U+4SzHwhP51rsaLyHfHEtqXYQRzEc05784
	 PaSyd75gFYCWNpdgxphAtWZt4zdZRMhzzpT9Wyz0h9NV71Ne0KQq7DeQrz44rEZ5D3dYG
	 hvAKbbKImn+4GaXB31ikshesXtnwYaIZCfaRssD1ewf7yUZuVkqrsgH8w8ZyDawqHrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063039;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uLfJjJ0fV9mO9teO3gutdBL91tUXLRllLUXHhv1c+gA=;
	b=j/9Fb8bBJ7pg5hc75v3uX3EmHei2rDqStWUfprv5f6FvnFGjObsUlN661VFoLBQnb3kR
	 4u5wZ5VCRUM8Mau0D1rdy/mogQrSs46ziXD+/ed0OEDKPomtZWLlwkrGdzTv/y/IpC5Eg
	 B847+u2wRZJB38u87FV9xoK8eRSa08PK+qGMjusfwRdkb2vTdULJinAoT5vzp6+be22+v
	 NShWdWeTUTiRSKyr6BtXNGIvzypnatyiaQS7gkg77ZVCB2nGPCMf7GG+DmAR71B85Vk1N
	 0OT960g+3Pt3FjGtmrCl0PseOQWy1MdMZAT4X51C0dO19BTPD7v97dzKRIDzhcf2JyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bn4lg9oX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEBA4606EEBB;
	Sat,  7 Nov 2026 14:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bn4lg9oX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A16D1F008A1;
	Sat,  7 Nov 2026 14:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063038;
	bh=uLfJjJ0fV9mO9teO3gutdBL91tUXLRllLUXHhv1c+gA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bn4lg9oXqeiLqutJsTajg0Gr03F3vyw+sTGndsGQiwDgC83bUIJp18XEpnRT+OD68
	 VCpH20c6c1gA3MNv2+bm6G+pNILMTu83F1aQmdZhhjKyK50BgdH40GYQ4aR/YjR7vY
	 X4dZL9LkXyJsm7C0hr0f42aE4zmZgULrTKQJJzWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vishnu Reddy <busanna.reddy@oss.qualcomm.com>,
	Vikash Garodia <vikash.garodia@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 287/869] media: iris: Fix bus_info prefix in VIDIOC_QUERYCAP
Date: Sat,  7 Nov 2026 08:49:29 -0500
Message-ID: <20261107134901.520278524@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Vishnu Reddy <busanna.reddy@oss.qualcomm.com>

[ Upstream commit 1facae9bc3c1cfcabc77184754d64c349831cbc5 ]

The bus_info field returned by VIDIOC_QUERYCAP used the abbreviated
prefix "plat:" instead of the standard "platform:" prefix expected
for platform devices. v4l2-compliance validates that bus_info for
platform devices starts with "platform:", and fails otherwise:

fail: ../utils/v4l2-compliance/v4l2-compliance.cpp(671):
missing bus_info prefix ('plat:aa00000.video-codec:dec')

Update the format string in iris_querycap() to use "platform:" so
that v4l2-compliance bus_info check passes.

Fixes: 94ef75095d5e ("media: iris: Enumerate cap->bus_info to differentiate between encoder and decoder")
Cc: stable@vger.kernel.org
Signed-off-by: Vishnu Reddy <busanna.reddy@oss.qualcomm.com>
Reviewed-by: Vikash Garodia <vikash.garodia@oss.qualcomm.com>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/iris/iris_vidc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/iris/iris_vidc.c b/drivers/media/platform/qcom/iris/iris_vidc.c
index 83b2b0e59f035..d6db5ae85990b 100644
--- a/drivers/media/platform/qcom/iris/iris_vidc.c
+++ b/drivers/media/platform/qcom/iris/iris_vidc.c
@@ -462,7 +462,7 @@ static int iris_querycap(struct file *filp, void *fh, struct v4l2_capability *ca
 		info = "enc";
 	}
 	snprintf(cap->bus_info, sizeof(cap->bus_info),
-		 "plat:%s:%s", dev_name(core->dev), info);
+		 "platform:%s:%s", dev_name(core->dev), info);
 
 	return 0;
 }
-- 
2.53.0



