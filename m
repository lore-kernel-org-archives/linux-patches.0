Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3781143C76;
	Thu, 11 Apr 2024 10:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831293; cv=none; b=WSGF0AEDD3GNmuuA3y+5jap53Mjw+9Axp1OMkAtmdM+7DMRtWQiNubeE5Yv8amxri72JQ7ZOSK266aCaih1p7cboo2sZ4C9ei1WCFY3IduTzx5hKBq7ACFAnvLXnJ/eR1zNZQo6qg1eLV+cvppAXQlRkgf2rSQkyyk1AE3IKAyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831293; c=relaxed/simple;
	bh=lDxTdPgjOguyna2Kf8KntOVxZo6EEy1Leq6s0xav4Ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sdt+BGmzJp/JLLSVnB6mVh5TQ1EkYgcpQBwLx0MgrUjE56xpLjuSf7H2GPlkP3cHE8gCmBiD7sHHYHQIJvyBp1E2ndRmrnDgw91ZAmqGmGUD77Ki4dap3WKqxTtY79gHMeZwyTpnRwHUU7YDnyYG8Ba+ZMDDBfRXDFpc3SW3k4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v4iPeZRm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v4iPeZRm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ADDFC433C7;
	Thu, 11 Apr 2024 10:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831292;
	bh=lDxTdPgjOguyna2Kf8KntOVxZo6EEy1Leq6s0xav4Ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v4iPeZRmCH+f33IeIBCnBs3UAf1IX7bm4yUVeDDkCtu7KGzGWUP8mNOPofR3K1CbJ
	 LrTLu1MYtAndmkNYOP4XR1DU2MJXY+AyHCjZYqP7wxvWpyOkRnX5N819KTiXyNVHu8
	 Ayar+aFb8XF0AJnzUE/2Ulw1qLOTOXr5qtDQlVsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markuss Broks <markuss.broks@gmail.com>,
	Karel Balej <balejk@matfyz.cz>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 074/114] input/touchscreen: imagis: Correct the maximum touch area value
Date: Thu, 11 Apr 2024 11:56:41 +0200
Message-ID: <20240411095419.121329552@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markuss Broks <markuss.broks@gmail.com>

[ Upstream commit 54a62ed17a705ef1ac80ebca2b62136b19243e19 ]

As specified in downstream IST3038B driver and proved by testing,
the correct maximum reported value of touch area is 16.

Signed-off-by: Markuss Broks <markuss.broks@gmail.com>
Signed-off-by: Karel Balej <balejk@matfyz.cz>
Link: https://lore.kernel.org/r/20240301164659.13240-2-karelb@gimli.ms.mff.cuni.cz
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/imagis.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/imagis.c b/drivers/input/touchscreen/imagis.c
index 07111ca244556..e67fd30110278 100644
--- a/drivers/input/touchscreen/imagis.c
+++ b/drivers/input/touchscreen/imagis.c
@@ -210,7 +210,7 @@ static int imagis_init_input_dev(struct imagis_ts *ts)
 
 	input_set_capability(input_dev, EV_ABS, ABS_MT_POSITION_X);
 	input_set_capability(input_dev, EV_ABS, ABS_MT_POSITION_Y);
-	input_set_abs_params(input_dev, ABS_MT_TOUCH_MAJOR, 0, 255, 0, 0);
+	input_set_abs_params(input_dev, ABS_MT_TOUCH_MAJOR, 0, 16, 0, 0);
 
 	touchscreen_parse_properties(input_dev, true, &ts->prop);
 	if (!ts->prop.max_x || !ts->prop.max_y) {
-- 
2.43.0



