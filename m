Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033641;
	b=ge0xIoKc+ZD+wNORNpIIQJNR5qPPl/GPYp5MIyMGuenoztR/Psp7lcyw/oP94OsMtI6x
	 DA7fVaW8nsr0c/VF6n8lRMY302+/u2wql5A3zXrqiw9q4mGfxxaJFNDlJ7o4Jvux9BPMU
	 xVimsopRKF8lb94dlk8BjMADFhD7nXDZld9CngX8RVvCKhU4aC/g4dhuWHF2f3VXL28IF
	 wt38Q3Di7aumH6wTm9fDqsRmRhBdAAyHwLfoMZ48rO2edrcOcgtYpRNpoaAvtucM2t92E
	 Qz+RjognedWE4cCLtWYLR2vUKtliXUqJaSMWO1rDYUVcw7oDlx7Dmozt3ztXUDucYhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033641;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3OSZ/UmbKd8/zbW9qR7b7+pWtlZT9K/SiEoS3ALxzmY=;
	b=Tt67t9YbXOYDWW+OWK/XPZGtJixsZZW3gYCPXsuDeRDG90J8W/tdC6ZoTeGIlIHJds4N
	 S/CphNug1RnqL3HdpURcFeV11KO7vyGs3MZ9VAQ/p8EW8R068AGpMW4IrE7DnbdAuHUg8
	 GNemrQ6yK1kLRToCIto376tCr78VpGUUKcLmFpuq/uOsQQvERDVvLLdmWx6Ho1RrlNljg
	 Bh2yJyVR0Zk/IeVHnmyyJKKYbs2LniAm9UjxUa2G5UnghvwgSjesbxgZl16/nMuDCBJqu
	 3F0JCTztBbx2WZ9dgBQ4iGT5UgBb/DwNOTGQjGgfiFI3zFFVzHvxuBa9JpdJ6yjgUWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IbwqMbBD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF49606A31C;
	Wed, 18 Nov 2026 20:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IbwqMbBD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029991F000C4;
	Wed, 18 Nov 2026 20:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033641;
	bh=3OSZ/UmbKd8/zbW9qR7b7+pWtlZT9K/SiEoS3ALxzmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IbwqMbBDU9TzLqYoKOgeS7F4a5hV3ltM8ufYJdvgX1J5W7M1BsPGoERC5HFSCs0ky
	 ffXWQFSK/T0ofAUigQHQsTsmJX5a5Ng2PxASmVG+qh6J70zjGfiA5go6Ywe7ZL9cvh
	 ob0UkN6YcmzALsLfrDjOQxMEzco8oTQhVNXdpPjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0088/3318] mmc: block: reject invalid perdev_minors before division
Date: Wed, 18 Nov 2026 15:11:50 +0100
Message-ID: <20261118150316.771574706@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Rao <raoxu@uniontech.com>

[ Upstream commit 5253aee00a4383cb0482d5e99bde48b8054ae2c0 ]

The mmcblk.perdev_minors module parameter is parsed as a signed int and
is used during mmc_blk_init() to compute the number of supported block
devices.

Passing perdev_minors=0 makes the init path divide by zero when it
computes max_devices. Negative values are invalid as well and would make
max_devices negative before it is later used as an IDA limit.

Reject non-positive perdev_minors values before registering any mmcblk
resources.

Signed-off-by: Xu Rao <raoxu@uniontech.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/block.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index f53f0bf4ae60c..3b1309b04aa69 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -3149,6 +3149,11 @@ static int __init mmc_blk_init(void)
 {
 	int res;
 
+	if (perdev_minors <= 0) {
+		pr_err("mmcblk: invalid minors per device: %d\n", perdev_minors);
+		return -EINVAL;
+	}
+
 	res  = bus_register(&mmc_rpmb_bus_type);
 	if (res < 0) {
 		pr_err("mmcblk: could not register RPMB bus type\n");
-- 
2.53.0



