Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4703B9922
	for <patches@lists.linux.dev>; Thu, 17 Sep 2026 04:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789617618; cv=none; b=fOb2opPqgLJilJx23l3HMH5WCeOP5uhl+UX/HFKt5afbhmdR6BhW1UjelYbKXIhVV0vQ9dGTNDAREP1LgtcQeNxZjFUTuG10sHW97TlAtdBgVMO81uIWZ84ILr3KGZOBmUshvyZYCbS5T0lLpa+UqsA+TWJP7yt1lecp2stgSYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789617618; c=relaxed/simple;
	bh=t6kqad3R5WgeKWtDof9fjSN4rKNL6g8fBl1fgnljyQY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XlkZc9tVZ356ADHBxXTdOfVdBAOJfD/Uz/pijfJA0IbC2t92MAE2WwwvkyhXPQpmPk9E+knBMTv+sLYZ2KNHf2O++TWY4CDUBX8hoF2G1jGqY27DyxpjY1VRoOXGu9gZC0T9AoWjQMqm/AwEYmc1SAZIoehM1xJeVsWJ9KpxmqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DChuO1oL; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DChuO1oL"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49b912d3920so2776895e9.1
        for <patches@lists.linux.dev>; Wed, 16 Sep 2026 21:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789617615; x=1790222415; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pBijyL0HZR3/5g7v7DmejWL3K0668IdfViWW12KzHHg=;
        b=DChuO1oL6yLT0d4Tgsi+H0JUDO1ZKt6uDF9RNE1swgUvI4FHS05p32M8haxAgHsjTH
         mgfsktdMxIaHRzgfqoWZDLZVPUBsw1xdQqO3bEtlFv89WnK/khTk6enBuHgMHF4R67vo
         BgCSSvC6CRGkjmn7tOwE/lJnioC+nK3sUXxM/OyJO3ubU9oJuk5dEuZfQwVg7Z3AH/Ov
         Kn4ixDlZ2SMhcNf5oMH9+442BJLkKReAaikG4M9ecB9ct8E9GL5QluYTsEGMlPiJ+Fw8
         C7dDp3BQbvv1zy+iX2YpfG3idGzfvGAOp2+EyszVasZxfphLhyrtCp1ykWARbel9zAeo
         IBmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789617615; x=1790222415;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pBijyL0HZR3/5g7v7DmejWL3K0668IdfViWW12KzHHg=;
        b=E2aRiF999bRkXl9VXGPEz1bFTbyQiYVjPzXu0vEY1V1n9X/bgrvj5Qu58TvMdAHqXF
         O2LkUoiC2Jvz8LlqRC5pIp06UeXzl+JrNmB2zbDgzBIdxlUKjXKTlORDaIP2WjBQd/JM
         5tRFinaSFSazOFHbm45GWDZYgBRQjvPXyjhp5UJ9xcC6qonMojVj2ERwcjdq5onbgJ7m
         T5EPiJZ1QDTgCxAjAVYi4e1ECMBOI2wbVoUE/uGbtsLozGn5wq6aoP0zbc4Xl8LW/ira
         YI8AbklT3Bp9BbKNfIrgMmNGokXiDrMs9qzDVPVAdU8LCaWugbx6iTnUMjkQqF7DptVD
         0Sgg==
X-Forwarded-Encrypted: i=1; AKwUvBz8FvClgQUkmfPLz0b/+W70D3yWt2ia4qkLTluLipctdy4u9LtQR0f85vnyGuuy8VeGTl/+Hdjg@lists.linux.dev
X-Gm-Message-State: AFuF++nrnD5mo5hBAS0oPL5CSZnxm+KuHeFYoc7VaCUwgOcWljwsXNHt
	QXiNRunuqabhR3uEeM3NolGzvXzEras3qsqQLJVwTwaD9AaHqaa1CKBQ
X-Gm-Gg: AYBFou2rHy9EyYRjWgCpKUePKg3wBm46SluGKWf45mhwTHdjuUgWanyD5d9VGUsQZA5
	wx3jbuqbgfDbfc8T0HhARAiWvhQ1aPF0Sjq9Bv1HaPgU+v/d+UN6JQgy1ALpA9vek6KHeN+ItUo
	9Cl9HZLnWgNSNrfkcjtOCPXRzXt40RfK0Sle+u0AjOxXBwj6XKCKrxYzJnfVe5Xb+On+e1Yr1nO
	3/lYMAFRzwhFJVSeQtbeQ7sTPaPJv9wYISspGbZJ6OESpFrPyttRy7ucEXYAl7cn+doQaqWv8AP
	5T0k7NCnydborGRBcGMfp7vkib2xywp9SlzzqpcqjofuD3C5lLw9fZYq/xrw0RWDlsm/s4Nkw6J
	jjHpGcZOnDcvNmxH1JKKrTTgt3rdrACaXake4DDePq8r4W+b+9gfXz2ChCYQ4aXNm3QKZ11zGuZ
	79qi0qJER9aH87M8ERz+HV1weshe2bmE+j2k1CRV2ZD+KiMhha8PA/PHXwr9o982R1Dhc1kPypW
	n0HGghA8tjsSQHa+uFOKhpbf8wuYa8QYZIWpjxSPjHapRLj+DP6O4EctDLbl2UqQCWiXHdNrKDD
	A25kgbQwFIf73FquO+i/9etmAs3kaGocQjUZWGeW1SZ9ME14Ix99KIkTgjZD3xUhoztuqc42jLX
	o
X-Received: by 2002:a05:600c:3e0a:b0:49e:81db:4926 with SMTP id 5b1f17b1804b1-49eac4638femr61582055e9.5.1789617614946;
        Wed, 16 Sep 2026 21:00:14 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-9dc6-c001-54ee-4741-4927-0a28.310.pool.telefonica.de. [2a02:3100:9dc6:c001:54ee:4741:4927:a28])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fbfd935cfsm6880015e9.0.2026.09.16.21.00.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 16 Sep 2026 21:00:13 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: stable@vger.kernel.org
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	gregkh@linuxfoundation.org,
	sashal@kernel.org,
	luiz.dentz@gmail.com,
	luiz.von.dentz@intel.com,
	marcel@holtmann.org,
	johan.hedberg@gmail.com,
	eadavis@qq.com,
	davem@davemloft.net,
	kuba@kernel.org,
	linux-bluetooth@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	pav@iki.fi,
	syzbot+b7f6f8c9303466e16c8a@syzkaller.appspotmail.com
Subject: [PATCH 5.15.y 1/2] Bluetooth: L2CAP: Fix deadlock
Date: Thu, 17 Sep 2026 06:00:03 +0200
Message-Id: <20260917040004.21041-2-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260917040004.21041-1-kmehltretter@gmail.com>
References: <20260912065526.833703348@linuxfoundation.org> <20260912065546.976652519@linuxfoundation.org> <20260913202907.3100-1-kmehltretter@gmail.com>
 <20260917040004.21041-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit f1a8f402f13f94263cf349216c257b2985100927 ]

This fixes the following deadlock introduced by 39a92a55be13
("bluetooth/l2cap: sync sock recv cb and release")

============================================
WARNING: possible recursive locking detected
6.10.0-rc3-g4029dba6b6f1 #6823 Not tainted
--------------------------------------------
kworker/u5:0/35 is trying to acquire lock:
ffff888002ec2510 (&chan->lock#2/1){+.+.}-{3:3}, at:
l2cap_sock_recv_cb+0x44/0x1e0

but task is already holding lock:
ffff888002ec2510 (&chan->lock#2/1){+.+.}-{3:3}, at:
l2cap_get_chan_by_scid+0xaf/0xd0

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&chan->lock#2/1);
  lock(&chan->lock#2/1);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

3 locks held by kworker/u5:0/35:
 #0: ffff888002b8a940 ((wq_completion)hci0#2){+.+.}-{0:0}, at:
process_one_work+0x750/0x930
 #1: ffff888002c67dd0 ((work_completion)(&hdev->rx_work)){+.+.}-{0:0},
at: process_one_work+0x44e/0x930
 #2: ffff888002ec2510 (&chan->lock#2/1){+.+.}-{3:3}, at:
l2cap_get_chan_by_scid+0xaf/0xd0

To fix the original problem this introduces l2cap_chan_lock at
l2cap_conless_channel to ensure that l2cap_sock_recv_cb is called with
chan->lock held.

Fixes: 89e856e124f9 ("bluetooth/l2cap: sync sock recv cb and release")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
[ Karl Mehltretter: backport only the l2cap_core.c changes. The HCI
  changes are from an unrelated patch accidentally squashed into this
  commit. The l2cap_sock.c change removes locking added by 89e856e124f9,
  which is absent from 5.15.y, so the quoted deadlock cannot occur. The
  core changes are needed because c531e63871c0 was backported without
  the matching lock. ]
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 34f89f7f993b..f1d7a6cdd8aa 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -7992,6 +7992,8 @@ static void l2cap_conless_channel(struct l2cap_conn *conn, __le16 psm,
 
 	BT_DBG("chan %p, len %d", chan, skb->len);
 
+	l2cap_chan_lock(chan);
+
 	if (chan->state != BT_BOUND && chan->state != BT_CONNECTED)
 		goto drop;
 
@@ -8009,6 +8011,7 @@ static void l2cap_conless_channel(struct l2cap_conn *conn, __le16 psm,
 	}
 
 drop:
+	l2cap_chan_unlock(chan);
 	l2cap_chan_put(chan);
 free_skb:
 	kfree_skb(skb);
-- 
2.51.0
