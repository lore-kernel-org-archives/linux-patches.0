Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050518;
	b=5F2oS2c3dO0Rk+gvAODL/Ia5tTZGTKCDNB7GCU+SZFAkyRXYlNzKygt1CHcTCicJkK0h
	 hRtIQhFOqohoEqjbne/ATCooGnW0bZQLBNF3cP79A2Zj0WmY5ej6IYJt2YroaSSDFmPzR
	 1k6XiQlaa7Kd1Eil8eNR2pHLcnz24HW2bZcR788ISEFwOXLTdN3F5VAQU4SJyc/EGVL38
	 orL/9alOCcIQg3pdn91MQyNQe5AVn/hwFNrM4S11kTm0TLcDUquEkj+EEZupHG0gWvDEq
	 9JCcnYgmASvc+8tcbG1mTqzXweZeKmS0pEQ+czElurWY5CzLaYz6kjT2RgKBMNzmOwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050518;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aXeJrTEhiNFRptBUy3x0SorQEVrUQTOxt24wq8BXgzs=;
	b=3t9BazM2IOY+DkAzK7ZzpQ2CZcfu3Pq0ge7cBmjIEgSsleKQ+69xqc8Fk93VL3AnZQk4
	 9gRCwPb6ZyYDBBCin69UfLlfaxIoP03XUvAw7cqel4kBULmiaOgWIbw9TFbb4QU7sYxbR
	 T6VYnqV+Cu1KF280Hua5hN8bZfVKFU06eDVxlLy7H4JxxVDJMXRNmDKRZZW4kDJ69vh7G
	 HYzYOOxX515+YFjhvnF4/TY9SG52UcytpwyGH8cN5U5gWThPnn4g2STRwBfAoG2+jYBw4
	 ILdNXuWkkS91dcZd29jY6kUUzutZlqmYEtHtR+atVYrVBZC4VsKGu5m7s2efRrjAH5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P6LHwstc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09BC606A320;
	Thu, 19 Nov 2026 01:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P6LHwstc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 430AA1F000C4;
	Thu, 19 Nov 2026 01:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050517;
	bh=aXeJrTEhiNFRptBUy3x0SorQEVrUQTOxt24wq8BXgzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P6LHwstcGPYeQEcBMF0LDW5el+pa+2bA4Y5iQRZIQeWOPoRcR1/nQDiAAPd5Y4HvY
	 UdnpJ0QnEcA/jACQqUzpWFYpcR1CmUxUxuVx/0nT4TgxvCzxLyPdyCeTPWhG5Am5K+
	 52Z0NINmY+1/SH9nMkuWegLSKtinA5XovSfdr8mQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dudu Lu <phx0fer@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2736/2857] net/sched: gred: keep the qdisc lock while updating the table
Date: Wed, 18 Nov 2026 16:02:50 +0100
Message-ID: <20261118150340.137761873@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Dudu Lu <phx0fer@gmail.com>

[ Upstream commit 306f788134a21a3d60c1eb872d0ec0ce7c7e09bc ]

gred_change_table_def() publishes table->DPs/def/red_flags under
sch_tree_lock(), drops the lock, and then keeps writing state the
datapath reads without it:

  - gred_enable_rio_mode()/gred_disable_rio_mode()/gred_disable_wred_mode()
    set/clear table->flags;
  - the red_flags_changed loop writes table->tab[i]->red_flags;
  - the shadowed-VQ loop frees table->tab[i] and clears the slot.

gred_enqueue() and gred_dequeue() read those same fields (test_bit on
table->flags, q->red_flags, t->tab[]/t->DPs) under the same root lock on
another CPU, so the post-unlock writes race with the enqueue path:

  BUG: KCSAN: data-race in gred_change_table_def [sch_gred] / gred_enqueue [sch_gred]
  read (marked) to 0xffff000007ad3b00 of 8 bytes by task 110 on cpu 0:
   gred_enqueue+0x88/0xc60 [sch_gred]
   dev_qdisc_enqueue+0x4c/0x19c
   __dev_queue_xmit+0x10a4/0x1ea4

The comment justifying the early unlock only covers the DP-vs-DPs check,
which the shadowed-VQ free loop relies on; it does not cover the scalar
mode bits and per-VQ red_flags written afterwards.  Move the unlock below
those updates so everything the datapath reads is published under the
lock that protects it.

Fixes: 6639607ed9de ("[PKT_SCHED]: GRED: Use a central table definition change procedure")
Signed-off-by: Dudu Lu <phx0fer@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20261021155434.66572-1-phx0fer@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_gred.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/sched/sch_gred.c b/net/sched/sch_gred.c
index 4f44a268286fa..63c23af51b4a3 100644
--- a/net/sched/sch_gred.c
+++ b/net/sched/sch_gred.c
@@ -442,13 +442,6 @@ static int gred_change_table_def(struct Qdisc *sch, struct nlattr *dps,
 	red_flags_changed = table->red_flags != sopt->flags;
 	table->red_flags = sopt->flags;
 
-	/*
-	 * Every entry point to GRED is synchronized with the above code
-	 * and the DP is checked against DPs, i.e. shadowed VQs can no
-	 * longer be found so we can unlock right here.
-	 */
-	sch_tree_unlock(sch);
-
 	if (sopt->grio) {
 		gred_enable_rio_mode(table);
 		gred_disable_wred_mode(table);
@@ -474,6 +467,15 @@ static int gred_change_table_def(struct Qdisc *sch, struct nlattr *dps,
 		}
 	}
 
+	/*
+	 * Keep the lock until every field the datapath reads (the
+	 * RIO/WRED mode bits, the per-VQ red_flags and the tab[] slots)
+	 * has been updated: gred_enqueue()/gred_dequeue() read them under
+	 * the same lock, so publishing them after the unlock races with
+	 * the enqueue path.
+	 */
+	sch_tree_unlock(sch);
+
 	gred_offload(sch, TC_GRED_REPLACE);
 	return 0;
 }
-- 
2.53.0



