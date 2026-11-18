Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043047;
	b=d/HKycxlpM7Ckujj1YBE8CgUz0ZhrXYQh6j3Vs0PcYxJT5N2V6mmHKKFPn6gM47DIrtL
	 hSzZJZZYa9c9Pu4fvk3718oaYev0tOdo7zOZUac9gdzK+M+j+GkdQp+oPqZAWzQNm5ldl
	 KAqay9GHEyu5lLbx4R75PKslyf8zUX1F1fnWQSlD21W4eQ0NiQpoRuwQUl6+OgsxZQ8ju
	 peWJ20CCFc4I46sAUJ8nj+JjvcALpIgJ6VXxngAbRbsGHQkzysexxy+ih53HXOoGbx7JV
	 r6MLZjMg7gElBG1VRKgyNr5slYBm5ALE0NLYl61E7Oj3PT8e70e8694Mtm4Tz6jBwvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043047;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=87xr5Qr2cWMwMskb8kJ/Py0RDoeBCC3kekhFZ1H7Mws=;
	b=uuH5E8O72Pr6mJbrTuFs6AV3lcmPrmq8Z/lf65fTS0pRg2v9/wfOv76BjxWA3uguCfex
	 Dl5V4uIZvqBV8GE0sy3jh10qaHIpp91dMK88+qdmcLjNpEbdrrY0TZthgN37DaPghytoR
	 IBsqmKj92ahQvtYfA9ObTgxn2B2AGcnWEepuZRKn20nXWlZ9Tt2d78aDME/ur8AuNhNzU
	 5rbCDLgjOSYAQpzfQi1w23Nai7yZ+Wr8j22aoWUJyyiC/z/c7lL0Ac3UMayw6X4nKSTKn
	 FQ6/iw3L0ODpYmVqwj2dEhX+O0D1VBLtlpt5ymaRPPoPJL0bjDzwChQQpStx8Wo928A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S3ucWrK9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71AF960A2608;
	Wed, 18 Nov 2026 23:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S3ucWrK9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B141F000C6;
	Wed, 18 Nov 2026 23:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043047;
	bh=87xr5Qr2cWMwMskb8kJ/Py0RDoeBCC3kekhFZ1H7Mws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S3ucWrK9mmPa37Gu6lnE/VopDj0DMI1Dz+nIszOXIwUaRYu6AwzplovB9R15CbgPm
	 p5UoyFkwIS8cBAZyS3HwUKvJGdmEan3LlM2vaqihznIpk2ZrImIuWlNOqLJW2PCrGo
	 yRxTWPP1bmz2qSDqcFoLltzk2E1XDkaITTuUks0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0072/2857] mmc: block: reject invalid perdev_minors before division
Date: Wed, 18 Nov 2026 15:18:26 +0100
Message-ID: <20261118150203.909418223@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 22ba3a1d693b8..94139fe07929c 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -3184,6 +3184,11 @@ static int __init mmc_blk_init(void)
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



