Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECA814388C;
	Tue, 23 Apr 2024 21:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908464; cv=none; b=ayxg4lwMAAqYxznmlqInRjZKvxU3nro4q/2M1wno25LCOtIM8Lr8P8aMx7O9fiTVN+0vhCUVLHO7d5aeKdJlyxF6G9XMeQLzlAoZRWIX+GRPjCLm/nllYCNupVHft9/M/K5JVYX/La1fp3+ZyympxsCDubmWwRG+WtyG4DNXQ1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908464; c=relaxed/simple;
	bh=m+HdP0/vLrRT4vJvsRr7OO7F+XvdqS68S4tvrMEo2WQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PEwI6fisIT2sJ70xwLxXH2HbF6FxIyG5Tgc1alI30TkdBtn2ezlYjbFMd7AvDNrl8wMN7h2zZ8/L/dVmQOqpJFBCFobVg131GE0nwHKWgBVhpmSh+f5zqy4xGiYV4/O74bNiwdSyEho9CJxxa57pin7T5QDT1xXnLKlPgZA92vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H8rPiVIO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H8rPiVIO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F2C5C116B1;
	Tue, 23 Apr 2024 21:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908464;
	bh=m+HdP0/vLrRT4vJvsRr7OO7F+XvdqS68S4tvrMEo2WQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H8rPiVIOeGVF1T5uR4H8Z0UkjMVh5/lR5Hq3KT9RMrWENnEbJHLAvZmqKgaCMd/5/
	 R8AEQ4mb0zECZGtEEYCET/cCWA0W//Qf5h+uvZTa7nN/Zy7L1WB6jA5J4L/zfm+kX3
	 4F/EeocLcOwdCYClV6sg4KLTylv1lMqfFeqAk4uY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 6.8 003/158] Revert "vmgenid: emit uevent when VMGENID updates"
Date: Tue, 23 Apr 2024 14:37:05 -0700
Message-ID: <20240423213855.942877739@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit 3aadf100f93d80815685493d60cd8cab206403df upstream.

This reverts commit ad6bcdad2b6724e113f191a12f859a9e8456b26d. I had
nak'd it, and Greg said on the thread that it links that he wasn't going
to take it either, especially since it's not his code or his tree, but
then, seemingly accidentally, it got pushed up some months later, in
what looks like a mistake, with no further discussion in the linked
thread. So revert it, since it's clearly not intended.

Fixes: ad6bcdad2b67 ("vmgenid: emit uevent when VMGENID updates")
Cc: stable@vger.kernel.org
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/r/20230531095119.11202-2-bchalios@amazon.es
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/virt/vmgenid.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/virt/vmgenid.c b/drivers/virt/vmgenid.c
index b67a28da4702..a1c467a0e9f7 100644
--- a/drivers/virt/vmgenid.c
+++ b/drivers/virt/vmgenid.c
@@ -68,7 +68,6 @@ static int vmgenid_add(struct acpi_device *device)
 static void vmgenid_notify(struct acpi_device *device, u32 event)
 {
 	struct vmgenid_state *state = acpi_driver_data(device);
-	char *envp[] = { "NEW_VMGENID=1", NULL };
 	u8 old_id[VMGENID_SIZE];
 
 	memcpy(old_id, state->this_id, sizeof(old_id));
@@ -76,7 +75,6 @@ static void vmgenid_notify(struct acpi_device *device, u32 event)
 	if (!memcmp(old_id, state->this_id, sizeof(old_id)))
 		return;
 	add_vmfork_randomness(state->this_id, sizeof(state->this_id));
-	kobject_uevent_env(&device->dev.kobj, KOBJ_CHANGE, envp);
 }
 
 static const struct acpi_device_id vmgenid_ids[] = {
-- 
2.44.0



