Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54EBE245010;
	Tue, 30 Sep 2025 15:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245863; cv=none; b=eGa4eSnrJG2a2Xw2702/cItuiEi5Tq8F4yDI253enZA2h0aPYgcUfdWJdV33tf5Wbhylp57O/T+F85L0EHdUzK3+SnXzeKxk4+EOtBe1+g1TK+6Zokxs2P2OtmTkMAAjtCvGiU732vheiVlBT1Bqn1poXHCT6AZKc20wdHJuJ7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245863; c=relaxed/simple;
	bh=CTNba1cMHOPHqRkpbHhzNeZe99qaELLth401rfQ6q+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qdNH7RNuwiHxsl3bkKtLZ0W8ZT/P40F4EbsRDJGh/lzn6JRmh/4sRp5BxqpHl0YnfcMBjpNQt9iEJeG6mnbhmYgPeJdR8KiKVRdAq/sNoxGczL9gh0MQHRGId8PwAeamHnCfyTWKAl7fzFMMLFoNPastqtUIUlMFKsFvNODyboI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i2S3q2CR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i2S3q2CR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE1B0C4CEF0;
	Tue, 30 Sep 2025 15:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245863;
	bh=CTNba1cMHOPHqRkpbHhzNeZe99qaELLth401rfQ6q+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i2S3q2CRhPWlw6S6FMrxUo0zTr0rlI95F4CYtBFMHvP/RXnZJCWEBUiEy9S81T7PS
	 okd+Z71G0lrOrmIwSns9ZHyMHBPcWoIc1nHbkoXsdezLBQuNTfRQn7NsCE5ZDFlAvr
	 ojPXB3nxNHAoFurkDQcF7Mycat2kvKm8mYNv4xCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Chaudhari <amitchaudhari@mac.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.6 55/91] HID: asus: add support for missing PX series fn keys
Date: Tue, 30 Sep 2025 16:47:54 +0200
Message-ID: <20250930143823.474484089@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
References: <20250930143821.118938523@linuxfoundation.org>
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

From: Amit Chaudhari <amitchaudhari@mac.com>

commit 831f70a5b93bd2d9e858ced2c12fab5766ede5e7 upstream.

Add support for missing hotkey keycodes affecting Asus PX13 and PX16 families
so userspace can use them.

Signed-off-by: Amit Chaudhari <amitchaudhari@mac.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-asus.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -869,7 +869,10 @@ static int asus_input_mapping(struct hid
 		case 0xc4: asus_map_key_clear(KEY_KBDILLUMUP);		break;
 		case 0xc5: asus_map_key_clear(KEY_KBDILLUMDOWN);		break;
 		case 0xc7: asus_map_key_clear(KEY_KBDILLUMTOGGLE);	break;
+		case 0x4e: asus_map_key_clear(KEY_FN_ESC);		break;
+		case 0x7e: asus_map_key_clear(KEY_EMOJI_PICKER);	break;
 
+		case 0x8b: asus_map_key_clear(KEY_PROG1);	break; /* ProArt Creator Hub key */
 		case 0x6b: asus_map_key_clear(KEY_F21);		break; /* ASUS touchpad toggle */
 		case 0x38: asus_map_key_clear(KEY_PROG1);	break; /* ROG key */
 		case 0xba: asus_map_key_clear(KEY_PROG2);	break; /* Fn+C ASUS Splendid */


