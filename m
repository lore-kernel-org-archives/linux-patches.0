Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829438;
	b=zvgnSdVq799MepT08GoTTum+fu/OD3uJDgwajyspdJrYBMnNCEKqD1xmRalAqyAMUXzb
	 HSZOGE0RFopdFR5SzReF+a04Lg6rC8RJLsS925vyXf0v0EYo3IHFwTKUZs1QtDDC4/TAJ
	 wpiOI0nlkoNpsae/DdSwc6VBjNdIPiZXi0auiaeRUq4Jv4UvCIb6htOg8elr8I89Yq74U
	 14JPKBb64C8H/sHHzQGxbJJPO3QGgaQs6/aDFFasygXqayQGVxdbWiwPuQaLS3PW2NdPy
	 K7pOkW5tY3VnFPGlXVbJ20GCuBvLFtLX5MBGglgpyysd5IhdHJ3Ko3BJOIolYerMG2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829438;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AUlaGiXmcRBDmEmcIQBz9BZGyhVFV+B9QBTfleul9iI=;
	b=itFj03A58u9yzCPn6kcjjrEGMD3hriTu480OwJUH8BilGxBmtKOPqpHpFXcuLHdBtW0V
	 OLvVlbwLeOFEaR2xWLad+avYQvRpvKcZUitQAybX72FD7KzQ8bXO+V7aLOBaxHmCY1DXK
	 srWzzgUkpZIdzIy0zmHSasHBiBEmVX1WIAT+A3gwsd4yeyD1b3nYKLWksR1/rpGnDL+yB
	 +2u9LgeqtykKr0Jdq4SjKJjVja8dnazloQNmQl0BxZ16z4qe7QbpvZVqE9tsF+9V7UwZr
	 CQ3bxLLwrbizotdmqhctMxh8GbYDGKk3M2GueBXZSYroKlidAfMBoaCuo/AftffbS5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yQ3VBtnf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2003606A863;
	Wed,  4 Nov 2026 21:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yQ3VBtnf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7B91F00A1A;
	Wed,  4 Nov 2026 21:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829437;
	bh=AUlaGiXmcRBDmEmcIQBz9BZGyhVFV+B9QBTfleul9iI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yQ3VBtnfk82fkrDA1VlQM0zV0GR+mb+r0E8NZzCC1WGioAeX4yE/+A5bN+AZ1wOp3
	 3f0DCf4wfj4xJcQgj92A3Qx3XYtEin1TgK8Ge5VjLUAk8kaRhKnlmjItXEPi10+zEN
	 ISmwHubhS/SEb9NU1lbjDYnLw0Ytj5IQILz1lZys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0125/1005] mmc: block: reject invalid perdev_minors before division
Date: Wed,  4 Nov 2026 15:57:38 -0500
Message-ID: <20261104211047.180426587@linuxfoundation.org>
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
index e8e45b161a398..5077842b286fe 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -3407,6 +3407,11 @@ static int __init mmc_blk_init(void)
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



