Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBE926E166;
	Tue,  8 Apr 2025 12:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116836; cv=none; b=NZxKzL5ApahZgCO0T+gETU3iGqi+BeLy60/Bb0F0FnIF/5xPdEwtFUPi92K5nRpbIEAD05IQ4WwUvHBtCTqzsYnNsOvpFEMh7/Gv+Y2p7htEkMlYA1EXpBetLIhBS5id5rOcoGtrDDGTbl2JI2OBhID8NTYInMd7N6VkTgOOba8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116836; c=relaxed/simple;
	bh=+ko9+syxyl8KRqsIM37+malAcKs1V9jZH0ReqhG9/r8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VEzQ/kALtXNu1drtvW0y73tN6S/HYxRWphyp/fFK0MoAAW0lBqNlUA77b/G1dNjV+sesoW7Z/eKBqRtCowZQU09hrSGxX/Bm89gJAG+SJbolq/JZISFcudiQBCrRQRv7o3KuL/N/9+erE6OGYA6LC0/oLMkdFbZo5xBrpNJ0hPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RY8vhRw6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RY8vhRw6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40109C4CEE5;
	Tue,  8 Apr 2025 12:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116835;
	bh=+ko9+syxyl8KRqsIM37+malAcKs1V9jZH0ReqhG9/r8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RY8vhRw6tcCf84jfz0YuKkbCsnZ744ThxMbA98w/bI7YkE3VrsuKS4P06jKRu3d/i
	 s6j9fCD9M0W/Ucq8Q3jwjpTUe5MHweUg8JYnRHp+HPgtOLqUAaMLGQ5KLq1sczh4fv
	 UvIYyZgcDVVhYnWAbCmwIZseijj2Xnlw23sYAJAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Shuming Fan <shumingf@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 286/423] ASoC: rt1320: set wake_capable = 0 explicitly
Date: Tue,  8 Apr 2025 12:50:12 +0200
Message-ID: <20250408104852.441575930@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit 927e6bec5cf3624665b0a2e9f64a1d32f3d22cdd ]

"generic_new_peripheral_assigned: invalid dev_num 1, wake supported 1"
is reported by our internal CI test.

Rt1320's wake feature is not used in Linux and that's why it is not in
the wake_capable_list[] list in intel_auxdevice.c.
However, BIOS may set it as wake-capable. Overwrite wake_capable to 0
in the codec driver to align with wake_capable_list[].

Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Acked-by: Shuming Fan <shumingf@realtek.com>
Link: https://patch.msgid.link/20250305134113.201326-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt1320-sdw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/codecs/rt1320-sdw.c b/sound/soc/codecs/rt1320-sdw.c
index f4e1ea29c2651..f2d194e76a947 100644
--- a/sound/soc/codecs/rt1320-sdw.c
+++ b/sound/soc/codecs/rt1320-sdw.c
@@ -3705,6 +3705,9 @@ static int rt1320_read_prop(struct sdw_slave *slave)
 	/* set the timeout values */
 	prop->clk_stop_timeout = 64;
 
+	/* BIOS may set wake_capable. Make sure it is 0 as wake events are disabled. */
+	prop->wake_capable = 0;
+
 	return 0;
 }
 
-- 
2.39.5



