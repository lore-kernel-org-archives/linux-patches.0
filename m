Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7481448EF;
	Thu, 11 Apr 2024 10:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830296; cv=none; b=TrBErOdXcuv/fez8IOOW35TmuYbAMshbWwa9mU+VaUAd5gUIpGeR6IZyKyom84mZssfoBuQR9kSLE2VUho7wZ2/WBSTKR5H4odKo4HJkXyRuTCUX3VycB4ljBa8nwMP1uYHE0MVD6FZGwoy7gqn0UGX4gZWie2WAmxdBSDLuuf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830296; c=relaxed/simple;
	bh=cMgfeyN0FBBSlPoCLCUyW0tCOYdO67oj9VjcI2Ib0hE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mhG2uk8aAayguYWhL/8CiWpHR+Tr53GK4K7Q/ye7EzJO7iB8Zhp/USYBHVgr3xvak23zI6ubkJImfM2jY225iwzKimeLTkYklKaJPmbOhtRWW/54NQCwiaAmQ2A8eWL7P934MJuDlhqMxu0/dP+preMaOqQIcH8k8mvaW/ZdVMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=whgMZtAl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="whgMZtAl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5BACC433F1;
	Thu, 11 Apr 2024 10:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830296;
	bh=cMgfeyN0FBBSlPoCLCUyW0tCOYdO67oj9VjcI2Ib0hE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=whgMZtAlgHyUE3sKBt+9Nsfb1ad9zpZ7Sb1g+/bHgAayHNJRyVpRTKL4UEFqR0QFW
	 kH3c1+2iVyL1I9WYfXX5hp1QUQEBidILagLUGfBWneyCLvcDNPGOQvSoEQRhB0cdzX
	 sNgOiZ77TDrNAVksO5/ckvV+Rof9JbhbcQyV2r/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markuss Broks <markuss.broks@gmail.com>,
	Karel Balej <balejk@matfyz.cz>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 094/143] input/touchscreen: imagis: Correct the maximum touch area value
Date: Thu, 11 Apr 2024 11:56:02 +0200
Message-ID: <20240411095423.738397558@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



