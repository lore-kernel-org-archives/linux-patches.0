Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE65221543;
	Mon, 23 Jun 2025 22:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717577; cv=none; b=Q6vTXWvbsvrvfCNov/qPMagRIqVYBLcIrg7+qNSdaU+YYgTy+aMuDXufMvLlI8uwwh3OSHMIIp0ff1GvL1JHuEAJf0FJay8zbjd74l3RS5M9i1l8q9vIvjYhWkzO22pN26rsA3/tmnCoaHjZ+n0BLu4Tm/+zn7PR3quh1rc1WtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717577; c=relaxed/simple;
	bh=Me7mAQ9qb81mDdMQQahWyAl30uh4k4p84pNtpZI2apY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GIi9Vh2aLG2CpRDheyN7H/HyVkMcOZSNnRVITLLQwoKhqWnD+CL398UYv8hrPHEbGr5Wt1sgpy75RW919mRX02FnPQEThIeNaU/ZIzTEV8yG/vI9JUyTpGW4Ioi8CrWGSn/Nho4JTAtEz17gilRzrRQxXojcJVDws6wcTYYEeKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jWovhyuI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jWovhyuI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56FD9C4CEEA;
	Mon, 23 Jun 2025 22:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717577;
	bh=Me7mAQ9qb81mDdMQQahWyAl30uh4k4p84pNtpZI2apY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jWovhyuIpS98BhLj3vieu0Af6gu6BZPEYvGPpZTXVGbDdu6uG7ubJcL7qNTC8J1CO
	 o4K0yXUsf4A8eHFjfyg1qgjRQM4VaXcLup4rgtaTqEGVV6bR7uMQEGBhkGZQnBTkmL
	 ic3Ekf4VdiGTSNTzS85rsQ7QjZALiKrpbKBPwMa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stuart Hayes <stuart.w.hayes@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 438/508] platform/x86: dell_rbu: Fix list usage
Date: Mon, 23 Jun 2025 15:08:03 +0200
Message-ID: <20250623130655.940360821@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stuart Hayes <stuart.w.hayes@gmail.com>

[ Upstream commit 61ce04601e0d8265ec6d2ffa6df5a7e1bce64854 ]

Pass the correct list head to list_for_each_entry*() when looping through
the packet list.

Without this patch, reading the packet data via sysfs will show the data
incorrectly (because it starts at the wrong packet), and clearing the
packet list will result in a NULL pointer dereference.

Fixes: d19f359fbdc6 ("platform/x86: dell_rbu: don't open code list_for_each_entry*()")
Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
Link: https://lore.kernel.org/r/20250609184659.7210-3-stuart.w.hayes@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell/dell_rbu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/dell/dell_rbu.c b/drivers/platform/x86/dell/dell_rbu.c
index 9f51e0fcab04e..4d2b5f6dd513f 100644
--- a/drivers/platform/x86/dell/dell_rbu.c
+++ b/drivers/platform/x86/dell/dell_rbu.c
@@ -292,7 +292,7 @@ static int packet_read_list(char *data, size_t * pread_length)
 	remaining_bytes = *pread_length;
 	bytes_read = rbu_data.packet_read_count;
 
-	list_for_each_entry(newpacket, (&packet_data_head.list)->next, list) {
+	list_for_each_entry(newpacket, &packet_data_head.list, list) {
 		bytes_copied = do_packet_read(pdest, newpacket,
 			remaining_bytes, bytes_read, &temp_count);
 		remaining_bytes -= bytes_copied;
@@ -315,7 +315,7 @@ static void packet_empty_list(void)
 {
 	struct packet_data *newpacket, *tmp;
 
-	list_for_each_entry_safe(newpacket, tmp, (&packet_data_head.list)->next, list) {
+	list_for_each_entry_safe(newpacket, tmp, &packet_data_head.list, list) {
 		list_del(&newpacket->list);
 
 		/*
-- 
2.39.5



