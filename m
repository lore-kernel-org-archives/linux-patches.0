Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209151;
	b=r9s18vcXiZKNLYKbUHpwUKcYnClRBa+ZwI6uzlLlZ7NDG6/FttWbog251w3voJRPK4zg
	 2yMVT3PuctYl9sD0Svp4QDOLHj6kqJiRgcADwDq/A6cxr2q4WoA+zszqpZmPOsnNuAk/n
	 MLpFTufPYRlVGoEfi1fCg/b/7Hp14qf5fKUyqga4mKg6I1/n3Jw70GO1t8PiFYI8oR/gw
	 +P6yycwJNAl+WQeODM6qJU8B3+82xgA99LGJhUhMgXw0CmYhhxAGjE68p2mPcs/zqP1oQ
	 GcaYDcqeVsWXDOrMTfArQUjJMX7Bbh2Av1B5X1iCV+YE2Po48r89eRe1OJXlRnUjS6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209151;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9U8Yk69qWeLWRWxR0crmtdk7YtqMfCU3bNjaxYW743s=;
	b=yTSw4MaB8cRVoJHb6Xdht4Gm1Ce2IxL1RpyzZXaz6ETOX81gVg4VSiDR9Oc/WUo/M4SV
	 uAwr8lv7UbUdzxqoDygWtj44KNP16cmQKLIADQZivXMp1ut62WfAJSHSkSj03/m/3f0Gn
	 AwjHVYZEFSwez66jHhQRdWF+vOWcyhzoF/E8qjAMhNpdM2G6zTWZnUXixvu7XHxu/6A4C
	 b9YxBseQ5cJXwP43UtnNCHAR4FxbZmLelGQsRdJE7o10iPWRtFIW9Ib1iGJen0nqBYyfN
	 +EC/rRfLAS5l6O0MJgbYMGD0+ToYzc2r9phlDbciO5F07TKVlhSYzBVRGoz+gMQ7V7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qMrjA15d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE89606A31A;
	Wed, 28 Oct 2026 17:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qMrjA15d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395111F01825;
	Wed, 28 Oct 2026 17:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209150;
	bh=9U8Yk69qWeLWRWxR0crmtdk7YtqMfCU3bNjaxYW743s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qMrjA15di+1Ouf7u0XoZHw2/yfY80mYCkseh3+BTQJ7k5SL4077PbBshdxKSyMsDA
	 /anctVCnS3GyoSmMcNCeC0awkGljcwK45x4zZxoxhQZIA61SEo8JYNN+fPy5067UqY
	 KMJm2FBWW1MxbZfnEdSQyM4R1xhi5YL9pExgT3p8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Jiri Kosina <jkosina@suse.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 368/516] HID: steam: Rearrange teardown sequence
Date: Wed, 28 Oct 2026 17:58:40 +0100
Message-ID: <20261028170012.203812603@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vicki Pfau <vi@endrift.com>

[ Upstream commit ddce9641ce924ed91ec8304577e463823a29ffaf ]

This fixes a narrow window during the teardown sequence where callbacks
could still be scheduled during cleanup that would then have a dangling
pointer to the now-freed steam struct.

This also puts work canceling for rumble and mode switch in
steam_unregister, as that shouldn't persist while the client hdev is open.

Signed-off-by: Vicki Pfau <vi@endrift.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
[Lee: Omit rumble_work, coalesce_rumble_work and mode_switch
      cancellation as e133dc99fc07 and 1d4549fd1115 are not present]
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-steam.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-steam.c b/drivers/hid/hid-steam.c
index a856276b6c2cf..628e4ef72b81b 100644
--- a/drivers/hid/hid-steam.c
+++ b/drivers/hid/hid-steam.c
@@ -829,15 +829,16 @@ static void steam_remove(struct hid_device *hdev)
 		return;
 	}
 
+	hid_hw_close(hdev);
 	hid_destroy_device(steam->client_hdev);
+	steam->client_hdev = NULL;
 	steam->client_opened = 0;
 	cancel_work_sync(&steam->work_connect);
 	if (steam->quirks & STEAM_QUIRK_WIRELESS) {
 		hid_info(hdev, "Steam wireless receiver disconnected");
 	}
-	hid_hw_close(hdev);
-	hid_hw_stop(hdev);
 	steam_unregister(steam);
+	hid_hw_stop(hdev);
 }
 
 static void steam_do_connect_event(struct steam_device *steam, bool connected)
-- 
2.53.0



