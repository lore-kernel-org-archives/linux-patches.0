Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173084F68C1;
	Tue, 13 Oct 2026 12:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895011; cv=none; b=PRD74VtX77kzzE1AsWOAPb/ELIA1qIvtapw1vlaDqm8VRv/mYGH6mC+gqwnIyknyLo+mJH/peeHTzLfzWezVACEzZhu35aUI/Xe2cyu0T/zII2zcjBbmgshJ5XGFxpoZ6qhjHKnuVxmy1e8QYAE1AFLqbZRB/zCeqW+ANkunxUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895011; c=relaxed/simple;
	bh=K0nfGqiMuH8BX6x/flJ0TQcWXQljedjfSjIXhC6o2t4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ju7zD0uBQillae2mgn7ZBI3M/Ehm7L8+b55lbfamdNFU+CheEHPEyU6jdTdbaAemflyKo57wLTNUrSwjrkUCQfiBVhy9o6n7GYd6mNE7i7C/GdSWW/ysyg2K/8LhxcpvVJK2sak9sSV3OGTHO6AwUtYBZw9Xaza9XwHqTwYf/ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OyX1imA4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OyX1imA4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ADED1F000FF;
	Tue, 13 Oct 2026 12:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895010;
	bh=SZHHslymjq9neaapgzFXafQHAVNKOqoP3hHsuJPCVeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OyX1imA4pOahlRHptzlMCaqlINVnGVUvtg5vygi/za4v0XSoxspVMGBZQAvfRw+Ju
	 JeOq1fYON06NGwb8I82tOP3PFRAp9b4I5dB59OryywsAjsYDrIHPe1fyHearDxfmae
	 whYBppOTvsazbf3zrGUDRg599ABDQQisB70Mp9o8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Rosencutter <rosencutter@gmail.com>,
	Lovekesh Solanki <lovekeshsolanki00@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 129/497] Input: synaptics - add LEN205b entry to smbus_pnp_ids for ThinkPad T490
Date: Tue, 13 Oct 2026 13:34:56 +0200
Message-ID: <20261013112910.952481847@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lovekesh Solanki <lovekeshsolanki00@gmail.com>

commit a961417c5ae77bbb728a23d9577ecd8f4d8a4b5a upstream.

Lenovo ThinkPad T490 has a Synaptics Touchpad that supports SMBus/RMI4
mode, but is not listed in smbus_pnp_ids table.

Add LEN205b to smbus_pnp_ids[] passlist.

Reported-by: John Rosencutter <rosencutter@gmail.com>
Closes: https://lore.kernel.org/all/CAOGuaRh025eKcBf9P8UrvtXNp68vQ0HVF2EbNMp-kpdaC1HNpA@mail.gmail.com/
Signed-off-by: Lovekesh Solanki <lovekeshsolanki00@gmail.com>
Link: https://patch.msgid.link/20260920200730.1836756-1-lovekeshsolanki00@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/synaptics.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -190,6 +190,7 @@ static const char * const smbus_pnp_ids[
 	"LEN2054", /* E480 */
 	"LEN2055", /* E580 */
 	"LEN2058", /* E490 */
+	"LEN205b", /* T490 */
 	"LEN2068", /* T14 Gen 1 */
 	"SYN1221", /* TUXEDO InfinityBook Pro 14 v5 */
 	"SYN3003", /* HP EliteBook 850 G1 */


