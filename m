Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620283;
	b=MNwn3+iRvz9Dxi6odTd/yN7VvikbWBmhC59js5KTvlFMsTyIn85gc2n8/f+vFfXY4l4A
	 oJpunwVtYhUnFuIbsIGrG7XIAff3DUvIHcWnDPI4G6AYbuue6Eqfmf/2o/HmeBSs/s27b
	 pmFN9rbsb+MEsjsPET15JJUwiGmOAazB5As4QyuuiB208TM7VIuKAs/+sWWoeSVPl/Gom
	 CfcFAa6jFlrx8aaQPgSYuud+NLYVispK4MU9wwGnyUAmjh8ubi4APL15op09awW3DSmXZ
	 YoW/fHgxy1uAW3FlzHHOytRE2MoMQDCAbBVXazR+nPDEK09soS9ebUa6YppCtkS3vuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620283;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gjw3UqY4fzNNJOeng2Fpe2fbrDMZNNi8+s91LtWJils=;
	b=cZEnxbxOiKuVidYOh93kiUtpyrW3C2KlO12Q0UQ1V4e8qjXEr5d1bBajNPS5IJ4oYR1H
	 SBpcz7Rvp27oKHElFwLTvCh4IidCP7QmRADhjJZeMNLa/+OxSswi3cA2XlcdGiOYFUZ+u
	 MTn5D/CQPyV4gppbMWAyYUMLPKCjBB8UcXt90hpgvMESCKUHhj4/Y6lXj1nmP4jsdJqYq
	 xURjO4HLNiarW6r9vHTYs711m5uh1YSY/8VkECcEK3qllXXlbFV4oxCMKeGFOG9AXwN0/
	 oLFkKO0i9iJgUvs9+oT2stx+DMnVJ509FKzo83zOtm2Lu0tHOY4H6dd3lHDG7Bq95YQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="eS/DNfun";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4D7606A32E;
	Wed, 25 Nov 2026 15:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eS/DNfun
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45CCE1F00A3C;
	Wed, 25 Nov 2026 15:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620282;
	bh=gjw3UqY4fzNNJOeng2Fpe2fbrDMZNNi8+s91LtWJils=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eS/DNfun9kovNwisTTOCqPCbARKCiBbVJ/ypYL+dijuQNlvfZPQKes/v46k2lsDzB
	 ddwHSTkVSLBQcj+FTz9rnrmQxu/uPnXZ3LS4n5EQYlC21VCD5V+WS24qoOcG/xoy7+
	 MUOLkg0PP2xsNeByfKyDQbVaTfltcmQ1sEjPC3n0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyu Jin <hongyu.jin@unisoc.com>,
	"weijiang.zhou" <weijiang.zhou@unisoc.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.3 0866/1005] dm-verity: dont restart or panic on errors during system shutdown
Date: Wed, 25 Nov 2026 15:36:44 +0100
Message-ID: <20261125143841.994665939@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
@@ -171,6 +171,15 @@ static void verity_hash_at_level(struct
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
@@ -219,6 +228,15 @@ out:
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
 
@@ -593,15 +611,6 @@ error:
 	return r;
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


