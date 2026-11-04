Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829240;
	b=MVDGHWPEawx50wQ7u0hG4HBivs79ezzu4wjuyoCNJX6MUnDcHqqi/ur5yV0AmeTVBlcw
	 i5FD/YMAmY5WWBdbhGnl6uvFMEwYc4fNLhBURPHacCHCFn9FbBOM2P5CNAdxCfT4oExV9
	 D6azmzxYzk9HdPcyXDrqSi7s4KDIgH++GqG0fWBB9ZNiGbV7Erby9QPyZTSSNleKkBzJg
	 iyZW0S2a5mftwpUivKZvj7utMuPOapwAoVlM85Tb93MAOjMfIeP9p4JFzdo5YQrkHosTS
	 UvKeGIipwLADC+njLHg34UwzrRQLf/cK9XMDem28eNm0dlGY1RmctMyOvMwU/7vk/wA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829240;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b1zqBpIsPj11qbbJWiePyt6BnNF60z65jIZ2U59C5ug=;
	b=5UZluiVDQJkjdXXNw2x3Abd2Asr9qy3g3v+q9t7CoyvHkWEhKDYEat7YVr/qwSfF0hDD
	 QW4dNnpgPdckD/Tkf1YUJpCB/8P0AgUoIOEEWZftgYr5N1g9N5Vy6iwQ+yhRmslieZ5k9
	 r/smrt86X8VmpyXurwlo/DmjYcZ7K6S/jgaUWZmdZgIe7oLbVCb6YbeOZvClDnmrCgLt8
	 BdFUT4E2AVRbeXgWiq/9K6aA83YHJTGk0xaRV/Mvq/L8XuEHTC05PN69q8kxeUWBAGJky
	 L90bUg67yzJJySzwrKZytw6Tts1iL/mHkcdhBXF1Hf7ygRoGUiG0r/DxBsTgeuqWPOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NGDpx15E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CB66074588;
	Wed,  4 Nov 2026 21:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NGDpx15E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9403B1F00A02;
	Wed,  4 Nov 2026 21:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829239;
	bh=b1zqBpIsPj11qbbJWiePyt6BnNF60z65jIZ2U59C5ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NGDpx15ETDSy5boxSXxse5YGhG0P4fn/E+wZwA5AJKDNH3bpm9o1mgszCGvYlDOPN
	 eNOK6uWX5zpfgsHpz6OrAYtyEKm4nwXWrrkrsr7EuPQXVrfAfuemybVjEd9OKSDYSF
	 bEm5QsjA3B2VgEmJyYA+I7OqJ7DcoXRqJB5JKPtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Daijiamu <3058704216@qq.com>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 536/547] ksmbd: use clear_and_wake_up_bit() directly
Date: Wed,  4 Nov 2026 16:12:00 -0500
Message-ID: <20261104211053.626188856@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Daijiamu <3058704216@qq.com>

[ Upstream commit 8852052e32df965a76daecbd8cda0ecf950b54df ]

clear_and_wake_up_bit() was introduced by commit 8236b0ae31c8 ("bdi:
wake up concurrent wb_shutdown() callers.") to replace the open-coded
clear_bit_unlock() + smp_mb__after_atomic() + wake_up_bit() sequence.

Replace the sequence and drop the now-trivial wake_up_oplock_break()
wrapper, calling the helper directly at each call site.

Suggested-by: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Signed-off-by: Daijiamu <3058704216@qq.com>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Stable-dep-of: f728cfee6929 ("ksmbd: fix app-instance non-durable supersede session UAF")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/oplock.c |   20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -763,14 +763,6 @@ static bool wait_for_break_ack(struct op
 	return false;
 }
 
-static void wake_up_oplock_break(struct oplock_info *opinfo)
-{
-	clear_bit_unlock(0, &opinfo->pending_break);
-	/* memory barrier is needed for wake_up_bit() */
-	smp_mb__after_atomic();
-	wake_up_bit(&opinfo->pending_break, 0);
-}
-
 static bool oplock_break_set_ack_wait(struct oplock_info *opinfo)
 {
 	bool ret = false;
@@ -826,13 +818,13 @@ static int oplock_break_pending(struct o
 
 	if (opinfo->level <= req_op_level) {
 		if (opinfo->is_lease == false) {
-			wake_up_oplock_break(opinfo);
+			clear_and_wake_up_bit(0, &opinfo->pending_break);
 			return 1;
 		}
 		if (opinfo->o_lease->state !=
 		    (SMB2_LEASE_HANDLE_CACHING_LE |
 		     SMB2_LEASE_READ_CACHING_LE)) {
-			wake_up_oplock_break(opinfo);
+			clear_and_wake_up_bit(0, &opinfo->pending_break);
 			return 1;
 		}
 	}
@@ -1260,7 +1252,7 @@ again:
 				SMB2_LEASE_HANDLE_CACHING_LE)) {
 			if (!oplock_break_set_ack_wait(brk_opinfo)) {
 				atomic_dec_if_positive(&brk_opinfo->breaking_cnt);
-				wake_up_oplock_break(brk_opinfo);
+				clear_and_wake_up_bit(0, &brk_opinfo->pending_break);
 				return -ENOENT;
 			}
 		} else
@@ -1309,7 +1301,7 @@ again:
 		      lease->state != SMB2_LEASE_NONE_LE)))
 			goto again;
 
-		wake_up_oplock_break(brk_opinfo);
+		clear_and_wake_up_bit(0, &brk_opinfo->pending_break);
 		return err;
 	} else {
 		err = oplock_break_pending(brk_opinfo, req_op_level);
@@ -1319,7 +1311,7 @@ again:
 		if (brk_opinfo->level == SMB2_OPLOCK_LEVEL_BATCH ||
 		    brk_opinfo->level == SMB2_OPLOCK_LEVEL_EXCLUSIVE) {
 			if (!oplock_break_set_ack_wait(brk_opinfo)) {
-				wake_up_oplock_break(brk_opinfo);
+				clear_and_wake_up_bit(0, &brk_opinfo->pending_break);
 				return -ENOENT;
 			}
 		}
@@ -1342,7 +1334,7 @@ again:
 	ksmbd_debug(OPLOCK, "oplock granted = %d\n", brk_opinfo->level);
 	if (brk_opinfo->op_state == OPLOCK_CLOSING)
 		err = -EAGAIN;
-	wake_up_oplock_break(brk_opinfo);
+	clear_and_wake_up_bit(0, &brk_opinfo->pending_break);
 
 	return err;
 }


