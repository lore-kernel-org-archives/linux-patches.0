Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829199;
	b=rS19hdPyTd2ZNpFzXI2YaET46VeY0wLDzIR3UeB2pXoTzxC/Qsu0t7R8DoTGncMZsVGj
	 0lh8c91T73enRzXfElw2q2xgsQlLLXCLgzsUNgTnB0zsPUxBaZPx8qjtVEGxXOaRzJECT
	 6LJj2AXQ5xym44NOxABRkgzk3yOvbzaTb11UqIN2haUkpZ0HVE5G0rvipMAO36Rfan7e1
	 XQQ0wULcePlyhcR9Rj4BdQMJA/GSbK7+hSDaG17ItIv8c0nIgW0NcQLmRmZaaRELTFYgE
	 xUSnTorg1xjPs00BfVRrGyanUVc4Rs8zDHhnSayCGjmlOB5OeMTEvt3+pEiFbRO8ldA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829199;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Lh1xFQZQ+LAaT7fRVMb3Dk5Q2NAZLO3ITm0jyqMAalM=;
	b=MCH2KklzcDFWfJYLOLhZFw3CA3aXNG+8D6I22WOzpn62t3Xe/YYhrIkF3S2bDMjhofF+
	 AAliuN6q35iw0X+ichtUvZogee7cYE1W5F5N8Q5uOXl+ucZTjckL+u6f5vQf37wx4KuZs
	 1MR6265niKqMoghjjf0xEf7SQMFyj316IWZ4IHoHvjcWQsl89HG647kYlLt+RMWOgcS8U
	 65SW6B+IRKrBq8Bk+RsCwtqLfF1kiaY9nJmPrvZiZHbaoe01/1xEQ5fKQNUZS//9z+kcx
	 DYLJEO1JlFE6grTMh6+hMW7zqwZ1NZheVCC+1BFrH0QX320LNqnIv8KxQfGC5Kcjpkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QPIcGQnV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9C560A2602;
	Wed,  4 Nov 2026 21:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QPIcGQnV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CD191F0093A;
	Wed,  4 Nov 2026 21:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829198;
	bh=Lh1xFQZQ+LAaT7fRVMb3Dk5Q2NAZLO3ITm0jyqMAalM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QPIcGQnVnPCz+hSApymZLHYkYTnHHjHSRy2NxWPwoycEqODYoFwEwhpism5k2WKRA
	 53VfI0Cs4tbDyFhwAmXCSbseeL2OLQZU+3bXHgZLIFnXvfuU+e99uRZmV5aH5sm4vx
	 O1WHmp2E1SiTnOZy5E04XbDlSUM467N9AxDBxT9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Derek J. Clark" <derekjohn.clark@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.3 508/547] HID: hid-lenovo-go-s: Return ret instead of 0 in mcu_property_out()
Date: Wed,  4 Nov 2026 16:11:32 -0500
Message-ID: <20261104211052.821709186@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Derek J. Clark <derekjohn.clark@gmail.com>

commit 8ac42b2885322dc7fb03d88c5411e9dbd24f80d9 upstream.

Currently mcu_property_out() blanket returns 0, discarding the ret
value and any errors with it. Wait completion returns a positive value
when it is not timed out, which would error on all successes, so if it
is positive return the ret value from the raw event handler. Only if
it is 0 set it to -EBUSY, otherwise pass the actual error.

Fixes: a23f3497bf208c59ad ("HID: hid-lenovo-go-s: Add Lenovo Legion Go S Series HID Driver")
Cc: stable@vger.kernel.org
Signed-off-by: Derek J. Clark <derekjohn.clark@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-lenovo-go-s.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-lenovo-go-s.c b/drivers/hid/hid-lenovo-go-s.c
index a72f7f748cb5..68301d4c762a 100644
--- a/drivers/hid/hid-lenovo-go-s.c
+++ b/drivers/hid/hid-lenovo-go-s.c
@@ -38,6 +38,7 @@ static struct hid_gos_cfg {
 	struct led_classdev *led_cdev;
 	struct hid_device *hdev;
 	struct mutex cfg_mutex; /*ensure single synchronous output report*/
+	int cmd_status;
 	u8 gp_auto_sleep_time;
 	u8 gp_dpad_mode;
 	u8 gp_mode;
@@ -435,7 +436,9 @@ static int hid_gos_raw_event(struct hid_device *hdev, struct hid_report *report,
 	dev_dbg(&hdev->dev, "Rx data as raw input report: [%*ph]\n",
 		GO_S_PACKET_SIZE, data);
 
+	drvdata.cmd_status = ret;
 	complete(&drvdata.send_cmd_complete);
+
 	return ret;
 }
 
@@ -474,12 +477,10 @@ static int mcu_property_out(struct hid_device *hdev, u8 command, u8 index,
 	timeout = (command == GET_PL_TEST) ? 200 : 5;
 	ret = wait_for_completion_interruptible_timeout(&drvdata.send_cmd_complete,
 							msecs_to_jiffies(timeout));
-
-	if (ret == 0) /* timeout occurred */
-		ret = -EBUSY;
+	ret = ret > 0 ? drvdata.cmd_status : ret ?: -EBUSY;
 
 	reinit_completion(&drvdata.send_cmd_complete);
-	return 0;
+	return ret;
 }
 
 static ssize_t gamepad_property_store(struct device *dev,
-- 
2.56.0



