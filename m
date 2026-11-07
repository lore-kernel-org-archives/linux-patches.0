Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060910;
	b=CvD6SJxnshnZb7ASZDUyDz+h+okWYAGCE6v6+cIq2I0PsTpoMt2MjDwMo3ApLmGxwid5
	 TI+aT8r4KF1M4c7cnOONm3OCDGJlGSajARLlAuoA+sRkLfW2pg/lT7MklsSbyZqJ6DQbJ
	 17ELkpzY/Tsb3iTcTB7YSvtXK0mDT29uKpLcd5YowfyTZbEs9j7OFXHr+gnqsDkxDC7Gm
	 SzlgsmQ1TaBGMmHj9HoigWc0CuN8UZPafSTq6jGTXQV5fl+yF/hfsoDJ9BKsa7Kf1WDNm
	 Lv/MCyp7z+zga/uG9EPDaCdFZDco3fwFL4WxyFk8bJ5mS9/54PdcHOtp3xyNPIbxPLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060910;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ivq6WTlW2W5PswmQhbs3Rze7tl03Ce7ZO9MTfw5d8nM=;
	b=HmKVbA5Ksz5iXlSJGbCik4szo7x4GmxC1QgXrHu/Z/4+gB39iUVQAvVe+2zmwvNKxiyy
	 ILaVEJlApofjv5uxT1OasQrqxEviO5zG5r5T1WYsesFak8xjLArmH7BWKichi/7tc2PdO
	 1lVAv6DhF1RJCHaCNkmEDebSh1kVfbm6KCF3L14eg6RlpKgrM+TsFRz5vRQ214CcUiQeh
	 +MtxVFJBXGt1aeYekUbIqfCI78eyxFManGG7mJyiswTqftzgez5PIF2zEDLrlq8ZZXa1J
	 PQBnbP/FvQQelnbv4vsB4ZO9BvP3nPOAzJ+B8XfiTCyRPAX5A/GOtvhfjkawczeRmgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=keF8OCmM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F22606D809;
	Sat,  7 Nov 2026 14:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=keF8OCmM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5A51F0089F;
	Sat,  7 Nov 2026 14:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060909;
	bh=Ivq6WTlW2W5PswmQhbs3Rze7tl03Ce7ZO9MTfw5d8nM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=keF8OCmMvIkm+Y0NJQiutmGqTwz0VHCCDHjZsVWfcutEFyfAim/ZRcYc8m+VsjXPO
	 oUSxVQdBVwYKqLzWCsI7p4fPXo1wxfqROlLOTDFpZwCjvk7kZRVc3zcjpJVxBHprOo
	 +MHOj0z16NU1F3EJiuOBvtnGLcMhn1ePSowsbVZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0279/1536] HID: rmi: check report length before trimming sentinel bytes
Date: Sat,  7 Nov 2026 08:38:15 -0500
Message-ID: <20261107135005.503491206@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 28a3e326fad2451bdb66b747dd1f7ccbb900eed6 ]

rmi_check_sanity() trims trailing 0xff sentinel bytes, but its loop
reads data[valid_size - 1] before checking that valid_size is non-zero.

Reverse the condition so the length is proved before the last byte is
inspected.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-rmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-rmi.c b/drivers/hid/hid-rmi.c
index d55a0388895fb..ecc19387f6b05 100644
--- a/drivers/hid/hid-rmi.c
+++ b/drivers/hid/hid-rmi.c
@@ -386,7 +386,7 @@ static int rmi_check_sanity(struct hid_device *hdev, u8 *data, int size)
 	 * such reports here.
 	 */
 
-	while ((data[valid_size - 1] == 0xff) && valid_size > 0)
+	while (valid_size > 0 && data[valid_size - 1] == 0xff)
 		valid_size--;
 
 	return valid_size;
-- 
2.53.0



