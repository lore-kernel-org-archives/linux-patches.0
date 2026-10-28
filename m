Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214777;
	b=A7YOL4jiFMM2AIGOkJq9GD900KhPQdXgp5on7NyVZEqQ1+Dj28RWg/jHbpgT+bmXk0h8
	 JgLKddgePJVqUPJI5qLV8y0fwOfKoPLAUZTQs3ZjFb9MH/kr2DhJpN8pnQE08nEl1pQ7N
	 PqQAYTOtrvTihXGgQs/PHKlS2dMHL2Sm2T5026n8/DgPdhcfwk/AJ/eoxcWr15+dHEDlZ
	 Iqkm4CxBM/HKgy/ERM8GGbQCY/HX+rO4BSzcwW77KglNtHL4Ji8IYcU5fGFJAgFwuCwJh
	 pIuahzOcGJQw1OrCU0JHpjMwO+mhLWWjzVwAW2J+F8D2DpI0wGIB2aDsqaz9ZkrvBKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214777;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b3qNDVu/HSMqMc9xRyQp1oDLje8pJAr40q/7SI2UWcA=;
	b=VtGmby0TGC1FcvjUUOslObe3BqZIZ91EKnUC9BaRx2606sEckrpwG9iyoXmZX23sg0bB
	 FTylcKMLkwEBN3DalKhWUxscErQTpNYJLbZzRPB7cwVeftL94GIq8IS5aGjKnSL5oru5U
	 3hZc3Pa88hGMUnlG4byLbeBbQtr92Mvt1MtYKs7jjW15MT9nMD3bI7D/LMQfVNaQU85g5
	 whyI13w+TOo0aolqGOaU+fLqYGGLSXwtalaNd+un01fBE/93nzFQzun4OXoUTMtYIuwA5
	 iFxBlslEbq3ifc8WM9LJkMil9+tX7xaL9l1fk3wGQ6f2eY+bhi3CU57CjLFG9QbeuQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TihbuEui;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66C2606B7CF;
	Wed, 28 Oct 2026 19:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TihbuEui
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2F161F031E0;
	Wed, 28 Oct 2026 19:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214776;
	bh=b3qNDVu/HSMqMc9xRyQp1oDLje8pJAr40q/7SI2UWcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TihbuEuiQZqP6eEdTEZJQkXizda3xse7hub6Edh81c36CdG9XES8uvbYOzJUNz4k5
	 +CKHjhe06QRjLdZVlthARZ6RslnR0RN7Cd0yyIo/7xUXt4jHScRUXiV8ClRc91Jwre
	 5j5Q+Y76+X0e2TEd+gzxFbgrCr5p7jPxiNRrAFQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Chen <chenl311@chinatelecom.cn>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0977/1887] HID: rate-limit hid_warn to prevent log flooding
Date: Wed, 28 Oct 2026 17:51:13 +0100
Message-ID: <20261028170521.643125948@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Chen <chenl311@chinatelecom.cn>

[ Upstream commit 4051ead99888f101be92c7ce90d2de09aac6fd1c ]

Syzkaller can create many uhid devices that trigger
repeated warnings like:

  "hid-generic xxxx: unknown main item tag 0x0"

These messages can flood the system log, especially if a crash occurs
(e.g., with a slow UART console, leading to soft lockups). To mitigate
this, convert `hid_warn()` to use `dev_warn_ratelimited()`.

This helps reduce log noise and improves system stability under fuzzing
or faulty device scenarios.

Signed-off-by: Li Chen <chenl311@chinatelecom.cn>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Stable-dep-of: 0a3fe972a7cb ("HID: core: Mitigate potential OOB by removing bogus memset()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-core.c | 4 ++--
 include/linux/hid.h    | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 9ad52318a86de..4b717cc838cf1 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -642,9 +642,9 @@ static int hid_parser_main(struct hid_parser *parser, struct hid_item *item)
 	default:
 		if (item->tag >= HID_MAIN_ITEM_TAG_RESERVED_MIN &&
 			item->tag <= HID_MAIN_ITEM_TAG_RESERVED_MAX)
-			hid_warn(parser->device, "reserved main item tag 0x%x\n", item->tag);
+			hid_warn_ratelimited(parser->device, "reserved main item tag 0x%x\n", item->tag);
 		else
-			hid_warn(parser->device, "unknown main item tag 0x%x\n", item->tag);
+			hid_warn_ratelimited(parser->device, "unknown main item tag 0x%x\n", item->tag);
 		ret = 0;
 	}
 
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 941a58f4b5bb6..09f6ba66f1db2 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -1248,6 +1248,8 @@ do {									\
 	dev_notice(&(hid)->dev, fmt, ##__VA_ARGS__)
 #define hid_warn(hid, fmt, ...)				\
 	dev_warn(&(hid)->dev, fmt, ##__VA_ARGS__)
+#define hid_warn_ratelimited(hid, fmt, ...)				\
+	dev_warn_ratelimited(&(hid)->dev, fmt, ##__VA_ARGS__)
 #define hid_info(hid, fmt, ...)				\
 	dev_info(&(hid)->dev, fmt, ##__VA_ARGS__)
 #define hid_dbg(hid, fmt, ...)				\
-- 
2.53.0



