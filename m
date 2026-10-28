Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214909;
	b=itTu6pqvOHgE+Uj37Ihvxt5ape+YWtLDhOXq5HaAmx4ba7s3pWDdJuW/9xiepV2W9kFa
	 7Nd8lMlB85xyVx++elkTn60gfW3GRdm1ApxJPbiYXrADDQvoQqKDG0skCk4U097+Luw6V
	 vtxUBG9ALo7Z8fp1w6hKT10lHgbEwNMKJvREyXUdKae6hvEh63IInmMZGSkr+ZiDhkBhY
	 JpJg92daum/JtuarcVEBSllnaS08TPqECAsjaze77XJmI2Ey/tUc2sE3yCq2x2dh4XDO4
	 FaHY4r4RmiMgzhG5Lur+DLoc0nrpfTuIPcF7SPxCF4n4rypYyhskUhfAx4R1AygwuBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214909;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pvRKTtQaEfSTy3jkKbxYhLBM6D19wNYXJlj6+NBHNFg=;
	b=3psfEqtAcgaookRHHEEIDVXk9NW5RR+i5OZ+s2iEh9xXJ0L5HfTkhp2sk7JcXUhXUv5C
	 BKoH1DZ5iTgUDfoudVXBuwdqujRMwCDYkhnBfw9keIYBn1dWN4DJIWfahPTpYm35C8Kke
	 azDfz7crhhKMOWV3YYOVIGEpG3dzrK2nWlVxuYHXdms9xoSuCEY9biudxPzdbbTPtmpLY
	 bQj67EybP07vRYmjm1CNsHJgpIgrwdf5x3YPQ/8qRM1OhMJmG0UQNVr1GhvYywI5xL3w7
	 p0D1uO/Z9b5juwZ31eCHbGBXR4yRpf9CLAyID7l25I6zBqZI0czrIPJksHIpFWSDpzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nA8Xjib0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B11606A33D;
	Wed, 28 Oct 2026 19:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nA8Xjib0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2FBB1F01825;
	Wed, 28 Oct 2026 19:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214909;
	bh=pvRKTtQaEfSTy3jkKbxYhLBM6D19wNYXJlj6+NBHNFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nA8Xjib0pJHVPYsNqPOFWOuMJs5fBRpMVm7bEcIj5+tamYC0orQY+Do+o2lWuAFip
	 rrmlW9grv/2T2P5D94w80h9Ve9Ss1CrHvQUv0R6a13gVxeRKlRmphy/afThOaqJZ0n
	 i2cyuhdsUs6vab1udXfolu3Paed7OO0AxUBbx9EA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Even Xu <even.xu@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1024/1887] HID: Intel-ish-hid: Ishtp: Fix sensor reads after ACPI S3 suspend
Date: Wed, 28 Oct 2026 17:52:00 +0100
Message-ID: <20261028170522.718537810@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Even Xu <even.xu@intel.com>

[ Upstream commit bdab6c94bb24758081625e619330b04cfd56570a ]

After legacy suspend/resume via ACPI S3, sensor read operation fails
with timeout. Also, it will cause delay in resume operation as there
will be retries on failure.

This is caused by commit f645a90e8ff7 ("HID: intel-ish-hid:
ishtp-hid-client: use helper functions for connection"), which used
helper functions to simplify connect, reset and disconnect process.
Also avoid freeing and allocating client buffers again during reconnect
process.

But there is a case, when ISH firmware resets after ACPI S3 suspend,
ishtp bus driver frees client buffers. Since there is no realloc again
during reconnect, there are no client buffers available to send connection
requests to the firmware. Without successful connection to the firmware,
subsequent sensor reads will timeout.

To address this issue, ishtp bus driver does not free client buffers on
warm reset after S3 resume. Simply add the buffers from the read list
to free list of buffers.

Fixes: f645a90e8ff7 ("HID: intel-ish-hid: ishtp-hid-client: use helper functions for connection")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218442
Signed-off-by: Even Xu <even.xu@intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Stable-dep-of: 56f7db581ee7 ("HID: intel-ish-hid: fix NULL-ptr-deref in ishtp_bus_remove_all_clients")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-ish-hid/ishtp/bus.c    | 2 ++
 drivers/hid/intel-ish-hid/ishtp/client.c | 4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/intel-ish-hid/ishtp/bus.c b/drivers/hid/intel-ish-hid/ishtp/bus.c
index 67e3215a332e6..a2a6b935bf5ee 100644
--- a/drivers/hid/intel-ish-hid/ishtp/bus.c
+++ b/drivers/hid/intel-ish-hid/ishtp/bus.c
@@ -730,6 +730,8 @@ void ishtp_bus_remove_all_clients(struct ishtp_device *ishtp_dev,
 	spin_lock_irqsave(&ishtp_dev->cl_list_lock, flags);
 	list_for_each_entry(cl, &ishtp_dev->cl_list, link) {
 		cl->state = ISHTP_CL_DISCONNECTED;
+		if (warm_reset && cl->device->reference_count)
+			continue;
 
 		/*
 		 * Wake any pending process. The waiter would check dev->state
diff --git a/drivers/hid/intel-ish-hid/ishtp/client.c b/drivers/hid/intel-ish-hid/ishtp/client.c
index df0a825694f52..d97c843cee0cb 100644
--- a/drivers/hid/intel-ish-hid/ishtp/client.c
+++ b/drivers/hid/intel-ish-hid/ishtp/client.c
@@ -49,7 +49,9 @@ static void ishtp_read_list_flush(struct ishtp_cl *cl)
 	list_for_each_entry_safe(rb, next, &cl->dev->read_list.list, list)
 		if (rb->cl && ishtp_cl_cmp_id(cl, rb->cl)) {
 			list_del(&rb->list);
-			ishtp_io_rb_free(rb);
+			spin_lock(&cl->free_list_spinlock);
+			list_add_tail(&rb->list, &cl->free_rb_list.list);
+			spin_unlock(&cl->free_list_spinlock);
 		}
 	spin_unlock_irqrestore(&cl->dev->read_list_spinlock, flags);
 }
-- 
2.53.0



