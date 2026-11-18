Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051034;
	b=h0EmNuq9Cq4W5PxcE7sp2PEee/55oCqo67mbRBWdo24vdt/dSUlhngGBHKK+iCq41Gc5
	 dt5XmYb9pXq4wRZ1KszfCr5VYy/R4F6jJOl9Uli7EGAPKmGHQ2zdFwhGGnQM9Gn54vRxb
	 lDeoLU8MMiMiTBtvTdjtAQgtVzUCp/ONy0WLBdR801p3GCXa9xszeq/53EYsyF8SYkhb2
	 Px5ivjIkxIPXfSORnInSWeqZxL+JHslNGlJvoesxpXwhMRfd3wxBgFsQzXo9VdYJW5JcB
	 sQFTAb8nOjq3wMU9zI+0RGqVpRpRwUtEEpvKb1KwohUO/PCIFBH+NWn5+6PZxea9MkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051034;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s1cyOBIs4iX7sW3OBpei7an9qXNScbrlhML8TgOybUk=;
	b=xi7vcYFXEsFKoAA23Dk8yhOQdGHU84Fuf76yJJr6GQzFKTAQi6XxqrKAlltreYDd8Zqr
	 E5kCxnHaes1cQNHZ/qCECwP02iSrGsrTZs7KcBpYB5OSffiy3dlrsOZgfIOexElES9mIb
	 G+4atAUs6jt1G9FH25Rf5QQ5mbKl3P5CX6kQqGQyumSyGayiBcu1XBQhzDBvHRGUPsxen
	 4nav/ic2vtOXXN7Rfv8fsvRbFnq7iiGC0kR18vw77+BzSBC5roNzgRvARScYv+vEuylqR
	 ul6TWss4hkdHeSwFr/gVNW5C2t5YGZFfjD9m3o5gCY28I2l4EsoRBwU156uB4ddhyjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FOdsfJIQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0EA5606A31C;
	Thu, 19 Nov 2026 01:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FOdsfJIQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E141F000C5;
	Thu, 19 Nov 2026 01:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051033;
	bh=s1cyOBIs4iX7sW3OBpei7an9qXNScbrlhML8TgOybUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FOdsfJIQ0wnFUPShcpgdxGKaScuemf3qYjRyDHQeusKnwPMb06jX58YIZAORhJqJ9
	 d5uM91G0uyZNK80GgeoWUdoDeXKZYcUnAnzaqKYZa9KSbbwZC/GixThAs7AEePxVlC
	 eJPjHc/Q+cFabAs5b7HM45bFInHaetPUsFwpZH+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0065/2214] mmc: block: reject invalid perdev_minors before division
Date: Wed, 18 Nov 2026 15:29:01 +0100
Message-ID: <20261118150012.611931237@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e0421d857030f..47d2415c0349c 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -3130,6 +3130,11 @@ static int __init mmc_blk_init(void)
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



