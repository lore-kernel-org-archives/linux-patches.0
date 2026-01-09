Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44072F12D4;
	Fri,  9 Jan 2026 11:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959387; cv=none; b=G3W7WBfl1IE21E1D2TXToynLIkarO4kLrQDTsrVRPVKXCvQBRswl2DGM1WufgUZ14Snk0QxeWf1mTalfrsfQCQRxTjB613GbgmPt/P1ZWMo+SxqC4ACocoNx8LW3yTfqeL+3R1/BUZGRAIgGwX9qnr8XNL1vvXX5LgW+qFgyKc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959387; c=relaxed/simple;
	bh=gf5ssUf374IwhH+HUU0mBFBdMb1S7kApw/UCFZaNmN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FwnqNi5RUvLPan22Hxn/pnjlcB7TOaR6SwhKmW4P57pcruxWQr+yfkuHYbIQ8BK9/HD49P0M8Vi3iQJs/9/bh7UxViZAhaRzbPDCyfykWoJM7sILRkGFG3C6ea6ffW4lrb/6mn7mpl4TGjyuMTy4wobsFDCjW50SNr1n4EASaHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AHcw5nKn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AHcw5nKn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12195C4CEF1;
	Fri,  9 Jan 2026 11:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959387;
	bh=gf5ssUf374IwhH+HUU0mBFBdMb1S7kApw/UCFZaNmN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AHcw5nKnSBs5N4OmRU2JDtmEsrugxcUep0yZCUYCY4lz3ZCSJqYiKtCz3OiyO4vuk
	 jL7KZCT/WdyCIYNKgnaNAOzNt8d/dShtZoqEGG7PnL5Qm031YTA6acQcnQhRe5te0H
	 4OOMel/eivfr46X7UXolaVjFuv+AkbSt11QGKvWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	April Grimoire <april@aprilg.moe>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 033/737] HID: apple: Add SONiX AK870 PRO to non_apple_keyboards quirk list
Date: Fri,  9 Jan 2026 12:32:52 +0100
Message-ID: <20260109112135.242919256@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: April Grimoire <april@aprilg.moe>

[ Upstream commit 743c81cdc98fd4fef62a89eb70efff994112c2d9 ]

SONiX AK870 PRO keyboard pretends to be an apple keyboard by VID:PID,
rendering function keys not treated properly. Despite being a
SONiX USB DEVICE, it uses a different name, so adding it to the list.

Signed-off-by: April Grimoire <april@aprilg.moe>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-apple.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index 7cf17c671da48..2b8021628d3c6 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -341,6 +341,7 @@ static const struct apple_key_translation swapped_fn_leftctrl_keys[] = {
 
 static const struct apple_non_apple_keyboard non_apple_keyboards[] = {
 	{ "SONiX USB DEVICE" },
+	{ "SONiX AK870 PRO" },
 	{ "Keychron" },
 	{ "AONE" },
 	{ "GANSS" },
-- 
2.51.0



