Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7431F7580;
	Mon, 23 Jun 2025 22:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716578; cv=none; b=AcwIlRETXQOhwqzqn9eSgLmaY5VGKXRnGK/oQOfmmVQDL7m+NZ0xFm1erXovzgUpHaurmq0xubdv3OYO2WmapUrdS15daxHoTnrjv9AdvPQuENH5CMziqj9bV6rKYvpE0+5Qb2w4l7w0clZVr5RiGJhWBqNS0zy4K/FYRxHRm74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716578; c=relaxed/simple;
	bh=zbFxCV3Qsk+w9JYjmpVXGgHb2pnRI1h49xrE6Wj7bZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KPC44gELY01gu1rvYVjkvJ+rykAIqXzhnwtsn3M1/6hGzDwEEoT6kx/7b8Xdz3Uxz0ODrAOL5BNXxAsl9E2CBliE19Pfesz4auJv3YmvzduDCCOAj2ih2+SG3m1h6QrhqBEHhmSNgiEs7jhnZtK88wwOLdUDBys9V7mduUAQDPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bh1uRob9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bh1uRob9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5366BC4CEEA;
	Mon, 23 Jun 2025 22:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716578;
	bh=zbFxCV3Qsk+w9JYjmpVXGgHb2pnRI1h49xrE6Wj7bZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bh1uRob9a03Rgs+g/xk8xDKDs8NtivQO8GzY/dZmD7HJ4HLPKgpbjVKvq4gJJN1y2
	 m0dyxPaeXmJMhn/gf6EAEa+uXpbmU3jhQtBLEmZiqzEEwqIODECB9LV5DrFxOy8sWg
	 mXwGZVNCj/rBi6wANlmH92rqNIstucoDNuSgKPI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stuart Hayes <stuart.w.hayes@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 342/411] platform/x86: dell_rbu: Fix list usage
Date: Mon, 23 Jun 2025 15:08:06 +0200
Message-ID: <20250623130642.258843396@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e9f4b30dcafab..25a01c728c072 100644
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



