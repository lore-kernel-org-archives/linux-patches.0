Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020670;
	b=UWKm9F/YrOglCDA+AT44d+/efTmV+EaZ8J5cBjRrgkul9SUFqqZkaGfWag1rPGEbCnzX
	 GSXE7oWHPS61NRTIWhTFsca0mwFQhkbLzUYuoH3gmS+CYwGrzGG3nGjQa3QP/ZEr/E6dm
	 /dN349hKFkMlDDmKJvV+OfJwsxLkXyVaxd+2XjCsuH6fAqTzc9eRnH+JK5t5CmY2Cmk7t
	 dZqQ8STkUhlZvLo0rBaHNRzww9DD55uz8iZX0G2z7m72HujNEy7iZFIiGzFDuxKxMbHPz
	 KUyYTsQQcCHVFeHed+zDJZikFDOCsI1qrycLMlcIpTL5gEKMBOWjbNFF0ZZcTGAVGEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020670;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0MphNW0b++7S7/dSOwdbxW9bdGmsw3c4Du+ps2NuQ0M=;
	b=OHXXn/iS+EfefRg4mD138vg4Kz+wLHddN539es/MwQUMRp7+ZItVX6+MsyS+Xd5ti9u7
	 0s5/S9uRESWGz1ygjFRuXRfEQCMq0Jrk+/91tWWqgy2nqC0MnLJ0Uy7goidoabtNHiFmQ
	 as58ArqDAkIzgiCAmQl3eD9yuufQe8SCnIgsnmc3lV8CDer+yWwh3yiTbsYMkmIZoii90
	 21BHX/wo+BdvqJrkmNsoyGR32YyFepYQUm00VJIHFIBVQeOFe96RZMfRpxkRRH1qwsaDA
	 V43WI6FvJaee4ReLTCvggn5sV/R06F0c42s5WlV5sUr6sRrurbCWkYiTX3YYSTGpZFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CckXZScx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A46606A331;
	Wed, 18 Nov 2026 16:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CckXZScx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A8F71F000C6;
	Wed, 18 Nov 2026 16:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020669;
	bh=0MphNW0b++7S7/dSOwdbxW9bdGmsw3c4Du+ps2NuQ0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CckXZScxm2GJyPtGBzBwuMs074jmTl/76FKn/dOHYJhn5ma1+mzp82jppSOZYQxpJ
	 uhRoW6HhPydk5hc2Dd/HhIWraDDK4PKsfF6I8bWWpEfjf8q2wuhDhTkZFwg2z7rnVg
	 znb8k9YqAe/JM5QH+3Gs9gRmjKwI9yQS6Sps3F3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5ad4fc9c8360b68e353f@syzkaller.appspotmail.com,
	Nehuen Lian Bova <nehuenlian.kernel@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2034/2651] HID: magicmouse: fix null pointer dereference in magicmouse_event()
Date: Wed, 18 Nov 2026 15:54:34 +0100
Message-ID: <20261118150359.357001340@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Nehuen Lian Bova <nehuenlian.kernel@gmail.com>

[ Upstream commit 5b66b65cfd6f697b1addb6159cbece53d20db2fc ]

Add a guard clause to check if 'msc' and 'msc->input' is NULL
before attempting to access its fields, preventing a general
protection fault.

Fixes: b8d56ef91cc3 ("HID: magicmouse: Apple Magic Mouse 2 USB-C support")
Reported-by: syzbot+5ad4fc9c8360b68e353f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5ad4fc9c8360b68e353f
Signed-off-by: Nehuen Lian Bova <nehuenlian.kernel@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-magicmouse.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index d637c04773799..e6d4d49305268 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -553,6 +553,10 @@ static int magicmouse_event(struct hid_device *hdev, struct hid_field *field,
 		struct hid_usage *usage, __s32 value)
 {
 	struct magicmouse_sc *msc = hid_get_drvdata(hdev);
+
+	if (!msc || !msc->input)
+		return 0;
+
 	if ((msc->input->id.product == USB_DEVICE_ID_APPLE_MAGICMOUSE2 ||
 	     msc->input->id.product == USB_DEVICE_ID_APPLE_MAGICMOUSE2_USBC) &&
 	    field->report->id == MOUSE2_REPORT_ID) {
-- 
2.53.0



