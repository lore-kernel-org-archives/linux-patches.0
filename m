Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC10F2566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:31:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53940C433D2;
	Tue, 18 Apr 2023 12:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821116;
	bh=xxPPVyH6s9wCTCL3GZDsVhvVc90miaXiyq9H9Iu7jeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iO3lcqF+CxFK5eqh/bvK7qyqkG7ZoxQd7q/H5bUP8hSYnQG8QaZoZPr+7Xa0iuGDH
	 p6jnCivCtUa1KW4+1yBKvekwMoOhVAWSce/cL50jSHXdQighb6pjwf262m57VwGi/2
	 9ITLazuZ4jJu5esEsSj64OEa4As0C4nPFlwh2lGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Weinberger <richard@nod.at>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	linux-mtd@lists.infradead.org,
	Lee Jones <lee.jones@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 71/92] mtd: ubi: wl: Fix a couple of kernel-doc issues
Date: Tue, 18 Apr 2023 14:21:46 +0200
Message-Id: <20230418120307.289191497@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
References: <20230418120304.658273364@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lee Jones <lee.jones@linaro.org>

[ Upstream commit ab4e4de9fd8b469823a645f05f2c142e9270b012 ]

Fixes the following W=1 kernel build warning(s):

 drivers/mtd/ubi/wl.c:584: warning: Function parameter or member 'nested' not described in 'schedule_erase'
 drivers/mtd/ubi/wl.c:1075: warning: Excess function parameter 'shutdown' description in '__erase_worker'

Cc: Richard Weinberger <richard@nod.at>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Vignesh Raghavendra <vigneshr@ti.com>
Cc: linux-mtd@lists.infradead.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20201109182206.3037326-13-lee.jones@linaro.org
Stable-dep-of: f773f0a331d6 ("ubi: Fix deadlock caused by recursively holding work_sem")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/wl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 4f88433d4adc7..28110cd4400b5 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -576,6 +576,7 @@ static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
  * @vol_id: the volume ID that last used this PEB
  * @lnum: the last used logical eraseblock number for the PEB
  * @torture: if the physical eraseblock has to be tortured
+ * @nested: denotes whether the work_sem is already held in read mode
  *
  * This function returns zero in case of success and a %-ENOMEM in case of
  * failure.
@@ -1060,8 +1061,6 @@ static int ensure_wear_leveling(struct ubi_device *ubi, int nested)
  * __erase_worker - physical eraseblock erase worker function.
  * @ubi: UBI device description object
  * @wl_wrk: the work object
- * @shutdown: non-zero if the worker has to free memory and exit
- * because the WL sub-system is shutting down
  *
  * This function erases a physical eraseblock and perform torture testing if
  * needed. It also takes care about marking the physical eraseblock bad if
-- 
2.39.2



