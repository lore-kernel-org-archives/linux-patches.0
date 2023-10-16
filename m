Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2260C266B7
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lk7bn28J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B3EC433C7;
	Mon, 16 Oct 2023 14:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697468185;
	bh=8pDQA6Z7QmUFH6ZYqyPPzxeP3wiJRl3uhP6QdKqVInA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lk7bn28JWJKAbN0lkofVsg4ysGo+cwM9HqGafNQEPDj6OMSd4dBvrfaua743Vxptr
	 XFAHLGgq+PoNjmZuIiiUfXV2GJlSUaD702qlNtTwHzxwcsfscz2MqbLY2PfdiJ9bky
	 6p2eXq7L02t4DSYoVcUMMLu7519VzTu0SA2dbTa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Binderman <dcb314@hotmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.5 142/191] thunderbolt: Correct TMU mode initialization from hardware
Date: Mon, 16 Oct 2023 10:42:07 +0200
Message-ID: <20231016084018.699562068@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit e19f714ea63f861d95d3d92d45d5fd5ca2e05c8c upstream.

David reported that cppcheck found following possible copy & paste
error from tmu_mode_init():

  tmu.c:385:50: style: Expression is always false because 'else if' condition matches previous condition at line 383. [multiCondition]

And indeed this is a bug. Fix it to use correct index
(TB_SWITCH_TMU_MODE_HIFI_UNI).

Reported-by: David Binderman <dcb314@hotmail.com>
Fixes: d49b4f043d63 ("thunderbolt: Add support for enhanced uni-directional TMU mode")
Cc: stable@vger.kernel.org
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/tmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thunderbolt/tmu.c b/drivers/thunderbolt/tmu.c
index 747f88703d5c..11f2aec2a5d3 100644
--- a/drivers/thunderbolt/tmu.c
+++ b/drivers/thunderbolt/tmu.c
@@ -382,7 +382,7 @@ static int tmu_mode_init(struct tb_switch *sw)
 		} else if (ucap && tb_port_tmu_is_unidirectional(up)) {
 			if (tmu_rates[TB_SWITCH_TMU_MODE_LOWRES] == rate)
 				sw->tmu.mode = TB_SWITCH_TMU_MODE_LOWRES;
-			else if (tmu_rates[TB_SWITCH_TMU_MODE_LOWRES] == rate)
+			else if (tmu_rates[TB_SWITCH_TMU_MODE_HIFI_UNI] == rate)
 				sw->tmu.mode = TB_SWITCH_TMU_MODE_HIFI_UNI;
 		} else if (rate) {
 			sw->tmu.mode = TB_SWITCH_TMU_MODE_HIFI_BI;
-- 
2.42.0



