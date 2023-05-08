Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7370168A7
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:39:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D3C9C433EF;
	Mon,  8 May 2023 10:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542398;
	bh=FuW/M5a7AsMve6csqm1BrtLWEIvsziSbEwbhp+BivZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nhAiqUSuSkjHpT2D6+IOTwHrGrv2d7FBDqXMUTCesrbRjEqi0iVrCv2H2/34RMU0V
	 JcsEe0JfzxKF3SP9Cq99z8qm6WyvU9sOMIkeqEMQNEQ31n3okNKd0giiI/LQ0NZ+jn
	 LGtBfUj71B5xefbIo6udv4e11DwofAS0HkOmfOTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 388/663] wifi: mt76: mt7915: unlock on error in mt7915_thermal_temp_store()
Date: Mon,  8 May 2023 11:43:34 +0200
Message-Id: <20230508094440.697603261@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit cdc215c2c8d74b3c8886650e979b47f16c1f7f92 ]

Drop the lock before returning -EINVAL.

Fixes: ecaccdae7a7e ("wifi: mt76: mt7915: rework mt7915_thermal_temp_store()")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index a80ae31e7abff..916d6c7c569d3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -90,6 +90,7 @@ static ssize_t mt7915_thermal_temp_store(struct device *dev,
 	     val < phy->throttle_temp[MT7915_CRIT_TEMP_IDX])) {
 		dev_err(phy->dev->mt76.dev,
 			"temp1_max shall be greater than temp1_crit.");
+		mutex_unlock(&phy->dev->mt76.mutex);
 		return -EINVAL;
 	}
 
-- 
2.39.2



