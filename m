Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD141C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:17:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E8E7C433D2;
	Mon, 20 Mar 2023 15:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325468;
	bh=nyD/biSwnmE61lrtW18J5H7Y6qPC96aP9J9xqE3FVJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m1sn6OVneF/HGvpHNqRJwk6zGLJ+3A7W5Ob9z2aNH5ic2b/1Vt9uoqFIklhMd54O9
	 3e8AeLEXko8DeyGQC23aGcb0MC2nn7QpwtsynNoi0j/fE64/Y5bPt0ZIMJD6AkYX+6
	 cMAuPS2JEaBHXAl9l0I78Up8RDsRKAO5AIzI90Sw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniil Tatianin <d-tatianin@yandex-team.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 088/198] qed/qed_mng_tlv: correctly zero out ->min instead of ->hour
Date: Mon, 20 Mar 2023 15:53:46 +0100
Message-Id: <20230320145511.222271620@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniil Tatianin <d-tatianin@yandex-team.ru>

[ Upstream commit 470efd68a4653d9819d391489886432cd31bcd0b ]

This fixes an issue where ->hour would erroneously get zeroed out
instead of ->min because of a bad copy paste.

Found by Linux Verification Center (linuxtesting.org) with the SVACE
static analysis tool.

Fixes: f240b6882211 ("qed: Add support for processing fcoe tlv request.")
Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
Link: https://lore.kernel.org/r/20230315194618.579286-1-d-tatianin@yandex-team.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c b/drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c
index 6190adf965bca..f55eed092f25d 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c
@@ -422,7 +422,7 @@ qed_mfw_get_tlv_time_value(struct qed_mfw_tlv_time *p_time,
 	if (p_time->hour > 23)
 		p_time->hour = 0;
 	if (p_time->min > 59)
-		p_time->hour = 0;
+		p_time->min = 0;
 	if (p_time->msec > 999)
 		p_time->msec = 0;
 	if (p_time->usec > 999)
-- 
2.39.2



