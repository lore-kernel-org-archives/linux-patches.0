Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B871863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:48:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00FF5C433D2;
	Wed, 28 Dec 2022 15:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242512;
	bh=6O+tJBAgNb1qG4Bb09pcxdwc2LV1uEwiAiUk4IjyR7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=azeyW5fC2hexoZV8UO0hPu56GKIilUHmi5Lsa1MTPsIkxCV7oTssaiGmjlBiI5haw
	 AEu1mu8BSAxJvU3x2GOQRqxrQQuUhuQ3+lmhbtH1XQWUK53xcJaNrZ0kVU9DntcpXQ
	 LrVi0I6WtfDCx0i0qrGd1vWRXDWqNhsaKjzq/laM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang ShaoBo <bobo.shaobowang@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0378/1146] regulator: core: use kfree_const() to free space conditionally
Date: Wed, 28 Dec 2022 15:31:57 +0100
Message-Id: <20221228144340.433896333@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wang ShaoBo <bobo.shaobowang@huawei.com>

[ Upstream commit dc8d006d15b623c1d80b90b45d6dcb6e890dad09 ]

Use kfree_const() to free supply_name conditionally in create_regulator()
as supply_name may be allocated from kmalloc() or directly from .rodata
section.

Fixes: 87fe29b61f95 ("regulator: push allocations in create_regulator() outside of lock")
Signed-off-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
Link: https://lore.kernel.org/r/20221123034616.3609537-1-bobo.shaobowang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index bc4bba899aea..78b6469e74d5 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1813,7 +1813,7 @@ static struct regulator *create_regulator(struct regulator_dev *rdev,
 
 	regulator = kzalloc(sizeof(*regulator), GFP_KERNEL);
 	if (regulator == NULL) {
-		kfree(supply_name);
+		kfree_const(supply_name);
 		return NULL;
 	}
 
-- 
2.35.1



