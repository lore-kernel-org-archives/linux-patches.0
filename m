Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0DC1F4C8E;
	Tue, 30 Sep 2025 15:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759246200; cv=none; b=H8SdFKtUr8d/elXmMlBKgf7EqNQjW+prKaRI/1BsPj1nC6Ple+e8dUtnTc8B09YDr8NIbEQvVtVgumBkbAsfJpBOBsMv6fsDM9eNm/OmP3XSn/rgV5fxbd1KCEgc/PiPp7DzF55PPxe5A9A5+QM6qiLEpx0Vq3CG3IqrYKgabzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759246200; c=relaxed/simple;
	bh=Rg/FOSYD9bqtsy6jSy3Yj4XI32apbqT/xoalnqZBERo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IuzWOEO0VUlItAKr19TL7d9mGt3s6CWgBTv6Az9dsenpSuO/FMnvuh0IxG4ycuHXT9LP3a4TUrxjv4xo7Vhl1U/ySRAYbU6AEnMWF+wJAuQrsokyvgNq3UlyT6lElqwFZoKT8tzlAE/g3DqhOBL7S7PJF8+3OSDIVYEs9QyQ9HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XsNcEb6W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XsNcEb6W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD28C4CEF0;
	Tue, 30 Sep 2025 15:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759246199;
	bh=Rg/FOSYD9bqtsy6jSy3Yj4XI32apbqT/xoalnqZBERo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XsNcEb6WEL3SjEJP5jsvhif52bn4iAicWZPJhelxzreGnZsHbwYKHQe0k2Ur2BpXx
	 Mv7GlqwbjT9M3/ZNlVlmJgNE5BM7QwxYMtuYPZgURjO3JQlMb9tra4Y6ihVxrt3wB8
	 0dWi5IvDMldD7E0FPZmCE6W92rg4letpQmpE0Ifo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Chaudhari <amitchaudhari@mac.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.12 66/89] HID: asus: add support for missing PX series fn keys
Date: Tue, 30 Sep 2025 16:48:20 +0200
Message-ID: <20250930143824.641223171@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
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
@@ -971,7 +971,10 @@ static int asus_input_mapping(struct hid
 		case 0xc4: asus_map_key_clear(KEY_KBDILLUMUP);		break;
 		case 0xc5: asus_map_key_clear(KEY_KBDILLUMDOWN);		break;
 		case 0xc7: asus_map_key_clear(KEY_KBDILLUMTOGGLE);	break;
+		case 0x4e: asus_map_key_clear(KEY_FN_ESC);		break;
+		case 0x7e: asus_map_key_clear(KEY_EMOJI_PICKER);	break;
 
+		case 0x8b: asus_map_key_clear(KEY_PROG1);	break; /* ProArt Creator Hub key */
 		case 0x6b: asus_map_key_clear(KEY_F21);		break; /* ASUS touchpad toggle */
 		case 0x38: asus_map_key_clear(KEY_PROG1);	break; /* ROG key */
 		case 0xba: asus_map_key_clear(KEY_PROG2);	break; /* Fn+C ASUS Splendid */


