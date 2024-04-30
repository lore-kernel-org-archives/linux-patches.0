Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D741E50A;
	Tue, 30 Apr 2024 11:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475235; cv=none; b=YgFOYUastCkgSrlaumEvZLZB11ILwh+mohDq6tvJgucR6dJyXz+nkdGzkeOEGlkNj2/iLNUsenwGCFKLjeJh4foDg6jSdr2lHs+FZi4Im075r1kdl9yLEWKKWPL+RIhNyKddCjVCturB52a+zTPSIay1B/V/jvxzYby+4thW6PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475235; c=relaxed/simple;
	bh=uhL6mkCZvzQw/+VYIlEInyIG5J3OD/BGJlL/f73SdOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q5vTpXNQCMHuAAiyj/UxIKGzllH8SJ3+ONqZ75AeLiFGAL8XCtsx8khEjTVhI/LiM6IpPutI/4oPTacWxtAtCuGDveW2CfsxlswJiX0raL54v8t5ufPAafWiUSpoNuSGAezwdZoTL6mvH5PRiGqra+usTTbMGbtjpGx0NXdghTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QKBDnOqC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QKBDnOqC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61323C2BBFC;
	Tue, 30 Apr 2024 11:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475235;
	bh=uhL6mkCZvzQw/+VYIlEInyIG5J3OD/BGJlL/f73SdOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QKBDnOqCgkQEJlG0z69rMsW99lGxrR8hMLTJj6xlzkmcEzMMxNyt6R6N6DO5Ee3rh
	 X3vhlGetyEDfOPKwLgSHKQDd+MY+mqWgpbEkv8/4f/16bGrUEfW+N5eiCRFjF/fsCp
	 dCQOqyhTTbs7c5j8nvC7952YvMAXFOcrMW5EQlLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yaraslau Furman <yaro330@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 005/186] HID: logitech-dj: allow mice to use all types of reports
Date: Tue, 30 Apr 2024 12:37:37 +0200
Message-ID: <20240430103058.174616497@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

From: Yaraslau Furman <yaro330@gmail.com>

[ Upstream commit 21f28a7eb78dea6c59be6b0a5e0b47bf3d25fcbb ]

You can bind whatever action you want to the mouse's reprogrammable
buttons using Windows application. Allow Linux to receive multimedia keycodes.

Fixes: 3ed224e273ac ("HID: logitech-dj: Fix 064d:c52f receiver support")
Signed-off-by: Yaraslau Furman <yaro330@gmail.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-dj.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index e6a8b6d8eab70..3c3c497b6b911 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -965,9 +965,7 @@ static void logi_hidpp_dev_conn_notif_equad(struct hid_device *hdev,
 		}
 		break;
 	case REPORT_TYPE_MOUSE:
-		workitem->reports_supported |= STD_MOUSE | HIDPP;
-		if (djrcv_dev->type == recvr_type_mouse_only)
-			workitem->reports_supported |= MULTIMEDIA;
+		workitem->reports_supported |= STD_MOUSE | HIDPP | MULTIMEDIA;
 		break;
 	}
 }
-- 
2.43.0



