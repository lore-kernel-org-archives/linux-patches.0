Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058390;
	b=NFqLYrChBJyAAnlQYFGZdqwj+vYUzP+yCf6Y3xxk2b9QLF5dPhKny9s+NR9HtjrhgBph
	 DWq6IrshPX/OjS9bDCS8faq0aMVj5oe+OxMu3Je7yWcJf06f9X/WVxc50iLCFY+zpipNn
	 IKDzwh/EQYMUWKU/zXTC7WuxW0ZAZFttAAhpKGocJkEhDABZl5jmgnyvcIoQMbYbgWR/J
	 7crmkUMxPiEUyhYudgK0C2Jh2v8m9J0aCjmUU3/ZedfN4RoGis28rtCOpSG4zc6HqrTzf
	 +uqQuzWvWM9fsMoXCEs/yGWG7bDtdSwrzxSlHvM87ITzf2A37WbpmXzHMP3uHkxICTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058390;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pzEJeKIFI33N/apK+gR2VbL/r3EtZtonKKyx9UK7Tdo=;
	b=QPytXNUD+eOE8edNbfYQxPX33lBRWrW6TAY0N02QXHuq9uZYe+KzEPxbFk97TToPN1VV
	 dERA9LAVSZhnDWisWvJTLlj9ihn3pPXB6Rr3OFS4QB4OQeGYiC4VXW+W002p3lcEpnoi3
	 yA0obJIZ23FAZYxxIOxNob0Fvqsesq5wqRpFSQgg5SOrUbYwQiNK9cdv0kzoU2GkvbNRM
	 RkfESFWFyHJzj6Cf5WGuuMXRv2jmIHVFDPYV/MOEL3c0vKolOED44/UxwpEEXSHpzDTIN
	 OjWz/3BOYP6inpx/wg9OVeC7pWYALXrTYuTzVcQZofQQQlHBqn3MhiExAIzgRScR3xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="tN09yOD/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476E9606A326;
	Thu, 19 Nov 2026 03:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tN09yOD/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 837391F000C6;
	Thu, 19 Nov 2026 03:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058390;
	bh=pzEJeKIFI33N/apK+gR2VbL/r3EtZtonKKyx9UK7Tdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tN09yOD/TEaliwUb0KjXjbprVLovw0v7L4EsxyNeW+p6iTVcorvFnHuY1FRQ+RXLU
	 v3KUK7RstctFIBcfbBzWjAZ1SEJ0hKpN8ZsCAEhbvObNI1ZRdpb9FHKOc9fLCGn6Hx
	 FqMrSeQpVOCqv3utouKdM7/hnuMuSHvnW+IdVl/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0468/1848] power: supply: ab8500_fg: Report sub-percent charge changes
Date: Wed, 18 Nov 2026 15:41:46 +0100
Message-ID: <20261118145933.950588269@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 4d40dba1815d46c6ef9019ed80e3b998b0fc443d ]

The fuel gauge updates bat_cap.mah from the coulomb counter but exposes
bat_cap.prev_mah through CHARGE_NOW and ENERGY_NOW. It only refreshes
prev_mah when the rounded integer capacity percentage changes, making the
momentary properties appear frozen between percentage steps.

Refresh prev_mah and notify userspace whenever the new charge remains
within the currently accepted percentage. If a discharge estimate tries
to cross upward into a higher percentage, the existing rejection still
leaves both the reported percentage and charge unchanged.

The AB8500 fuel-gauge implementations in the Samsung-GT-I8160-Codina,
Samsung-GT-I8160_HD-Codina, Samsung-GT-I8530-Gavini,
Samsung-GT-S7710-Skomer, Samsung-SGH-I407-Kyle and
Samsung-SGH-T599-Codina-TMO product trees retain the same percentage-gated
prev_mah update and contain no finer-grained reporting workaround.

Fixes: 13151631b5bd ("ab8500-fg: A8500 fuel gauge driver")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260916-ab8500-charging-v1-2-e986ed321cc6@kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_fg.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/power/supply/ab8500_fg.c b/drivers/power/supply/ab8500_fg.c
index a88590563647e..5218a0daf6c38 100644
--- a/drivers/power/supply/ab8500_fg.c
+++ b/drivers/power/supply/ab8500_fg.c
@@ -1372,6 +1372,13 @@ static void ab8500_fg_check_capacity_limits(struct ab8500_fg *di, bool init)
 		}
 	}
 
+	/* Keep the charge properties current between percentage changes. */
+	if (di->bat_cap.prev_percent == percent &&
+	    di->bat_cap.prev_mah != di->bat_cap.mah) {
+		di->bat_cap.prev_mah = di->bat_cap.mah;
+		changed = true;
+	}
+
 	if (changed) {
 		if (di->bm->capacity_scaling) {
 			di->bat_cap.cap_scale.scaled_cap =
-- 
2.53.0



