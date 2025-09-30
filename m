Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7A4846F;
	Tue, 30 Sep 2025 15:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244743; cv=none; b=YfM0/Lqy/+LZTU1358P/IhWFrumlZYq99jmKOFEBaXRbnwh20ztwKrUWTLlO8ovE+BRichC6L0mC8obmI0p48JWgC84y+NHXJvhBhIchxB4+NVM21NkuZyZV/v38l2lxDTiP6LYhaIiIOsoxLxcTkPG66dyDTc1BSbS8KRiDQzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244743; c=relaxed/simple;
	bh=v46G2i8mW3ubDqeqNe7estlChvr33r5eJr11oqMDNfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lb64VWiDq23ViYo/BrwMrjLdJzAqke4qLbPa11Vmy8IV/toS+7rCShqcin8DTPChDwOCEIyeqfkZFoqKyfcQKeGtXh44btUK5LIkpkf3E7W0z1Z6OImIt7XaDjOU6LnUom2C/dfk/TGXI5/hKFiclJ4+0SmKDeUdNCNxDO6hZSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=swcO5vW9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="swcO5vW9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16934C4CEF0;
	Tue, 30 Sep 2025 15:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244743;
	bh=v46G2i8mW3ubDqeqNe7estlChvr33r5eJr11oqMDNfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=swcO5vW9aOFmUGCAEwhc71jZ5vmaa7omozufawSrM+MAKnNm8ecx5L646HFGGdMe3
	 g2JnjMlY/U97ZOLRryma6b5gnS/nOEBp6/1trU+pi7aMLARWFAb9IvSOXtdsLvkSly
	 t21tizeg6eVC8UxMxrS4svAwFNUIluU5zhrJ5fjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Chaudhari <amitchaudhari@mac.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.16 101/143] HID: asus: add support for missing PX series fn keys
Date: Tue, 30 Sep 2025 16:47:05 +0200
Message-ID: <20250930143835.253353014@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -974,7 +974,10 @@ static int asus_input_mapping(struct hid
 		case 0xc4: asus_map_key_clear(KEY_KBDILLUMUP);		break;
 		case 0xc5: asus_map_key_clear(KEY_KBDILLUMDOWN);		break;
 		case 0xc7: asus_map_key_clear(KEY_KBDILLUMTOGGLE);	break;
+		case 0x4e: asus_map_key_clear(KEY_FN_ESC);		break;
+		case 0x7e: asus_map_key_clear(KEY_EMOJI_PICKER);	break;
 
+		case 0x8b: asus_map_key_clear(KEY_PROG1);	break; /* ProArt Creator Hub key */
 		case 0x6b: asus_map_key_clear(KEY_F21);		break; /* ASUS touchpad toggle */
 		case 0x38: asus_map_key_clear(KEY_PROG1);	break; /* ROG key */
 		case 0xba: asus_map_key_clear(KEY_PROG2);	break; /* Fn+C ASUS Splendid */


