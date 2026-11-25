Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623445;
	b=bksqKf2XqYWnC8eAczxckXKutqjCXXZ4k8k9AhnIlezQyAeTblxfQIYDQcreN5tftuES
	 fjkRC2HaKY70CAZsa+cVI4rSyKTNSLQ4OIiHAT4owFKfJfiA0+7Bz+MufYMxIF8sJm7CV
	 sGWXQH0tub0EaNZkfTrUuGO+OL7r2yBlprBS7Y4+KZYOiCHCmwuMkV4crHq9ipLPQV2J4
	 U3grUzE5GTOZy7QPShscsR2uOYvAi6VN4p0cvu5ZmzHxm0stcRtgjzu/MjxPwqNxIKjae
	 JMVP0tl08YgJkimIeEC5mYuLQEiuvDYynwKaekc5nLEvzqdNJidN86U6HyuKtARcPXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623445;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9uOKg5Yrw22NMV+z6XCcqSEqXzzffs3K5iTJK98B0z0=;
	b=K/v2u946Y5cw9HBQHSZ2XnSr2irD2ZlKMnokH3cO6Biar2GGC1G90F0Lpbp4dCZzSrbf
	 SN2bNIIDQQCSq2oCT2Igdj6g3f1wfSdqZ6AmqYN87BUnLBEr3dDh4b6OkuUUwOYARJdN4
	 f2xsNUjh9tjRJQyK8e736MHHkPg1onmFqR4hl/Kn2qrziG+1R4sSG3uiZXtTsctfcz1Wz
	 pfY7wKUt+EzCkGt26uoW0XiRFdcv4g1iKJWp/bYoBqM6+wcgSro/5UpF/H/8HtVIHGTzV
	 A+VZpcieESZDDR3BK4bFPiI602f3f8yCBft7nVsyvB5QWRp8dAIzsi+gd3r4FN5hHjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eVnIzeAD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3117D606A323;
	Wed, 25 Nov 2026 16:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eVnIzeAD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E061F000CF;
	Wed, 25 Nov 2026 16:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623444;
	bh=9uOKg5Yrw22NMV+z6XCcqSEqXzzffs3K5iTJK98B0z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eVnIzeADgEAUkdBot86fQ0MSUnzXVHjKSJ9mr7g2Z4hfpxDg/kCM3yT3Q8xzA8amM
	 oImoMjykqDTo1603gzNI4lj5oFARr/5rRhHZzh0PofjQBcU4zLSebUpbYl6g7EaVXv
	 1MzQK91+LFsm6iC03OYcoK9f5KycfOHeBL+v3HoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyu Jin <hongyu.jin@unisoc.com>,
	"weijiang.zhou" <weijiang.zhou@unisoc.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 861/990] dm-verity: dont restart or panic on errors during system shutdown
Date: Wed, 25 Nov 2026 15:37:08 +0100
Message-ID: <20261125143842.194757862@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weijiang Zhou <weijiang.zhou@unisoc.com>

commit 47930d1236d2988cdc580c10d3af21b6b02d7ece upstream.

Commit 252bd1256396 ("dm verity: skip verity work if I/O error when system
is shutting down") stopped I/O errors during shutdown from triggering a
restart, since devices may legitimately be gone by then. Errors that reach
verity_handle_err(), e.g. through a failed hash block read followed by a
failed FEC attempt, are not covered and still call kernel_restart() or
panic().

During a reboot that is both wrong (nothing is corrupt) and harmful: it
races with the reboot already in progress and replaces its reason with
"dm-verity device corrupted", which bootloaders such as Android's treat as
a verity failure and switch the device to EIO mode.

Apply the same shutdown check in verity_handle_err(). Corruption is still
logged, recorded in hash_failed and reported via uevent, and the I/O still
fails.

Signed-off-by: Hongyu Jin <hongyu.jin@unisoc.com>
Signed-off-by: weijiang.zhou <weijiang.zhou@unisoc.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: 252bd1256396 ("dm verity: skip verity work if I/O error when system is shutting down")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-verity-target.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -156,6 +156,15 @@ static void verity_hash_at_level(struct
 }
 
 /*
+ * Skip verity work in response to I/O error when system is shutting down.
+ */
+static inline bool verity_is_system_shutting_down(void)
+{
+	return system_state == SYSTEM_HALT || system_state == SYSTEM_POWER_OFF
+		|| system_state == SYSTEM_RESTART;
+}
+
+/*
  * Handle verification errors.
  */
 static int verity_handle_err(struct dm_verity *v, enum verity_block_type type,
@@ -204,6 +213,15 @@ out:
 	if (v->mode == DM_VERITY_MODE_LOGGING)
 		return 0;
 
+	/*
+	 * Devices may already be quiesced (e.g. UFS set offline by its
+	 * shutdown hook), so a failure here does not imply corruption.  Fail
+	 * the I/O but do not restart or panic, which would also override the
+	 * reboot reason of the shutdown already in progress.
+	 */
+	if (verity_is_system_shutting_down())
+		return 1;
+
 	if (v->mode == DM_VERITY_MODE_RESTART)
 		kernel_restart("dm-verity device corrupted");
 
@@ -523,15 +541,6 @@ static int verity_verify_io(struct dm_ve
 	return 0;
 }
 
-/*
- * Skip verity work in response to I/O error when system is shutting down.
- */
-static inline bool verity_is_system_shutting_down(void)
-{
-	return system_state == SYSTEM_HALT || system_state == SYSTEM_POWER_OFF
-		|| system_state == SYSTEM_RESTART;
-}
-
 static void restart_io_error(struct work_struct *w)
 {
 	kernel_restart("dm-verity device has I/O error");


