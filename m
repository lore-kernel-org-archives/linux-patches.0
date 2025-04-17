Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86367254878;
	Thu, 17 Apr 2025 18:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915567; cv=none; b=hWF3l8wFx1NFpv//uTTCJvLi1zXe8NHyOmnplHQg/ac/BQPgnQkCXzmnjLREREj76E6uBr8m2l4sd4IxXbLWHEu/C6VA99uxYMpl3eOIhYjuGUybpF6CJTjYqS1JOPqeGqyjy8Dy0OerSR8LNMdMyQfhLsLG4UUkqZpl/ymR08c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915567; c=relaxed/simple;
	bh=4MLq3Ne56vigkSU7akCpaZcZ1UjAUTKj4Vg0S6f4H+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qq2Myxyj0be9+MSQIXtkeXfVkxrtdHjePEvYDoKjCVsjrfx0rYo2yFrfZ/Cpc8zf44bmU9HKi5LF5NrZKhdazDhqP/wE7zIj2XjoM3B8OKdPVDfrnMVXRlWgH/pCdeCoybD/C1MWNg2AcuISnh89ZjyiOZB3f+WcDuAkrZGYVhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IjE2e9HQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IjE2e9HQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13415C4CEE4;
	Thu, 17 Apr 2025 18:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915567;
	bh=4MLq3Ne56vigkSU7akCpaZcZ1UjAUTKj4Vg0S6f4H+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IjE2e9HQI7xPlK8BWHpx+FAb0OaMJpQmQmgaxUNXZ6O1RXCY9HnFZhViLKKOWeOSC
	 h+itWuilky7wo8+zg/LlCXCMttM3KOOVc/1yP4LyCA5C+U86rjM3LuF0Id4cDPE3OW
	 S0K7ZJAR46YVedlnZVpa6zNUiqEWLAlWSmXcW2wU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tomasz=20Paku=C5=82a?= <tomasz.pakula.oficjalny@gmail.com>,
	=?UTF-8?q?Micha=C5=82=20Kope=C4=87?= <michal@nozomi.space>,
	Paul Dino Jones <paul@spacefreak18.xyz>,
	=?UTF-8?q?Crist=C3=B3ferson=20Bueno?= <cbueno81@gmail.com>,
	Pablo Cisneros <patchkez@protonmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 169/393] HID: pidff: Simplify pidff_upload_effect function
Date: Thu, 17 Apr 2025 19:49:38 +0200
Message-ID: <20250417175114.389876696@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

From: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>

[ Upstream commit e4bdc80ef14272ef56c38d8ca2f365fdf59cd0ba ]

Merge a bit of code that reqeusts conditional effects upload.
Makes it clear, that effect handling should be identical for
SPRING, DAMPER, INERTIA and FRICTION.

Signed-off-by: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
Reviewed-by: Michał Kopeć <michal@nozomi.space>
Reviewed-by: Paul Dino Jones <paul@spacefreak18.xyz>
Tested-by: Paul Dino Jones <paul@spacefreak18.xyz>
Tested-by: Cristóferson Bueno <cbueno81@gmail.com>
Tested-by: Pablo Cisneros <patchkez@protonmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/usbhid/hid-pidff.c | 54 ++++++++++------------------------
 1 file changed, 16 insertions(+), 38 deletions(-)

diff --git a/drivers/hid/usbhid/hid-pidff.c b/drivers/hid/usbhid/hid-pidff.c
index 99b5d3deb40d0..42c951a1d65bf 100644
--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -770,48 +770,26 @@ static int pidff_upload_effect(struct input_dev *dev, struct ff_effect *effect,
 		break;
 
 	case FF_SPRING:
-		if (!old) {
-			error = pidff_request_effect_upload(pidff,
-					pidff->type_id[PID_SPRING]);
-			if (error)
-				return error;
-		}
-		if (!old || pidff_needs_set_effect(effect, old))
-			pidff_set_effect_report(pidff, effect);
-		if (!old || pidff_needs_set_condition(effect, old))
-			pidff_set_condition_report(pidff, effect);
-		break;
-
-	case FF_FRICTION:
-		if (!old) {
-			error = pidff_request_effect_upload(pidff,
-					pidff->type_id[PID_FRICTION]);
-			if (error)
-				return error;
-		}
-		if (!old || pidff_needs_set_effect(effect, old))
-			pidff_set_effect_report(pidff, effect);
-		if (!old || pidff_needs_set_condition(effect, old))
-			pidff_set_condition_report(pidff, effect);
-		break;
-
 	case FF_DAMPER:
-		if (!old) {
-			error = pidff_request_effect_upload(pidff,
-					pidff->type_id[PID_DAMPER]);
-			if (error)
-				return error;
-		}
-		if (!old || pidff_needs_set_effect(effect, old))
-			pidff_set_effect_report(pidff, effect);
-		if (!old || pidff_needs_set_condition(effect, old))
-			pidff_set_condition_report(pidff, effect);
-		break;
-
 	case FF_INERTIA:
+	case FF_FRICTION:
 		if (!old) {
+			switch(effect->type) {
+			case FF_SPRING:
+				type_id = PID_SPRING;
+				break;
+			case FF_DAMPER:
+				type_id = PID_DAMPER;
+				break;
+			case FF_INERTIA:
+				type_id = PID_INERTIA;
+				break;
+			case FF_FRICTION:
+				type_id = PID_FRICTION;
+				break;
+			}
 			error = pidff_request_effect_upload(pidff,
-					pidff->type_id[PID_INERTIA]);
+					pidff->type_id[type_id]);
 			if (error)
 				return error;
 		}
-- 
2.39.5



