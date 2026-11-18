Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057349;
	b=oFi8qSpSlxkLMRjnoqEjixDeBadsuqlZewgSODpm6pgEHAs0ZIvxNQCBtXxg53E05j3z
	 3dt/79aatXGh1Tyb4RWOYWwdqYiWIuuYoMwKEDtgUmJOAto+Qq9Lb4MTGaP672yu5H4Be
	 dICy+lg1p0ytSemvyYL0OigIF5Oc9D3hyxItCmW7J8//z8hSBtW7F8tpqVl4hcunICMpR
	 d3UsrX+Fuq4KzH0y/i362CmLMSuf5Gt0r5bQt+WB0PvipV4nIo3QauCMpY9ot3D9UZ1/i
	 xVEzypwJ0yqFyQidSpIJaewC/3Nxy9BISouCctpCRUyAvfbRQYOBAO7owFlRaVygQCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057349;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Kln0AsK0RxzQx2hUnXrenYQgZk3WhM05swT1AZtys4M=;
	b=s1oGzwF/LgccCkAi2HRuU/qB3+mMdafoU8oErAh4crFnYbW7XJnuWTV+GFC5XByuVIyG
	 +3sZpLs1yASkvmz64qlcaQcBRvaDDwZIegH+ivLEwwrVWzDuBcNzhqUYPrWw6iSQmts3b
	 jLTgf43cUDWtrGtlUO2AqTfYNfZ2xc6d2Qa1y0RsrsqMjt5W1SQZfgET/MBrpM7SI8lUR
	 zuL38IDfCQV73PKZhiuIfr6FAACWKUI6BdymMmsYi9KlDXXGVDbhtyitL9cgRkeUzadMX
	 hLDBa8ZgWpUET3GkMQSYvcxVW3OXO0gvkRQGoR46DatYt2EFUjcF8IFQG6aXgGhy9TA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ef0E+S1m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABD1606A325;
	Thu, 19 Nov 2026 03:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ef0E+S1m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC3051F000C4;
	Thu, 19 Nov 2026 03:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057349;
	bh=Kln0AsK0RxzQx2hUnXrenYQgZk3WhM05swT1AZtys4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ef0E+S1m/kOew4aU9fM+SLagdWVmrnWG5u+TvS+wC2NWMq1i+7+dyuVfLvq/erUfu
	 iFK/zNGqmypuOG9Ad69yRmN3K6vbeW1OAmTraudD41qt9k+5gI21PHaNv3pAOA4EpA
	 n6oLW4VXdVO/2IvurHVU/W8Yt+TWTs4iGLEBg0i4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0058/1848] mmc: block: reject invalid perdev_minors before division
Date: Wed, 18 Nov 2026 15:34:56 +0100
Message-ID: <20261118145913.539837974@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e5506c793b6bd..d013aefb664c1 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -3106,6 +3106,11 @@ static int __init mmc_blk_init(void)
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



