Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063083;
	b=GBf8Y024869Sw/xD58dOVFL8MGPH+RibqwkJo9vZo/C8xx20VIWTFH+lNU8KTpvGGsR6
	 7JciSayBa2KzHxLdxCmtC/Mb/mIupuyn1N+pu5DvUwEn/UBmK+omOxseK8yQk/HFgBSGG
	 cMAlC3qN65RKbI89N/TTkrJ0FwlCx4lc69hwVhhCRd6OpWStgnCmWw5Ld+93TD1aESu27
	 DlxYKMrutUtHarAWCG6OXKEtrqxQ5pWWZ1hDAHgTemLRSOmNfd6XMmhYMrA+OAetHl3wp
	 X+6qdht5lm/WaERbkAsbAJ4qYJZreDpHFr51GY4WTuTT4FS2dPEskh5pDp2tLhrIBwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063083;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aNw+a1LjzLrYG1/Qm3HmlhnYplOaKxQUHKhklXUbfjQ=;
	b=Q2ANvaB+fTIuLIgxioxhLFkBBnVbUB814vF9hborV8NcNOwf0ljbZfVu/GPJXSfJB/XM
	 CUM1kH/PBg74khXXDer1KQGvgbYHvBkV7cMCNZbFmcLnW841nXU0rq/NIg8pKEUgKduDI
	 TUHD8djpXh/2qwVSkaZn3OLeYQc6HzlY/jAuE7g8E60/k6xPAQyk++mcRw0h9iLzfz4tT
	 AHD1dV2U/+RojerHgi5oEoUsJg12ikSI9hPaWRsPPLM2gC1QNP8OCgyrmP10rSmWyAyQl
	 eAE0qtX6M2GM66/tactu05ALkVrzPX1IfZedK5zZPQ0goVv7jGv4PwB2h5dlJE/JgJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oQxMlwp6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1450A606D802;
	Sat,  7 Nov 2026 14:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oQxMlwp6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B692D1F0089F;
	Sat,  7 Nov 2026 14:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063082;
	bh=aNw+a1LjzLrYG1/Qm3HmlhnYplOaKxQUHKhklXUbfjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oQxMlwp61Sbdx51MfIn3Uup6pbk/cmQunotd6vHsZTa8xDl81C107SLAZhjjhzOR8
	 0NFvDXt3YAjg8RW5vNRJrV0yx5SwVZyECtuJpePcDulOZKJ1dm/ely7+mNlrtQq2zU
	 TEBn3/I3B9taTz+iiV29gl3VdM1V+iqEBTluI4jU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodolfo Giometti <giometti@enneenne.com>,
	Danish Khateeb <danishkhateeb03@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 322/869] pps: generators: stop the generator on unregister
Date: Sat,  7 Nov 2026 08:50:04 -0500
Message-ID: <20261107134903.388820341@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Danish Khateeb <danishkhateeb03@gmail.com>

[ Upstream commit 3e75af9f41c7509884d0955245dec2b791287e8c ]

Both generator drivers stop their timer and then call
pps_gen_unregister_source(): pps_gen_tio_remove() cancels its hrtimer
and disables the TIO, and pps_gen_dummy_exit() deletes its timer. But
/dev/pps-genN and the sysfs "enable" attribute are still there until
the unregister, and a PPS_GEN_SETENABLE or a write to "enable" in
between starts the timer again. Nothing stops it after that: TIO's
hrtimer keeps running in the devm memory freed by the unbind, and the
dummy's timer is left in the unloaded module.

The drivers can't avoid this by unregistering first, as TIO's timer
callback uses pps_gen, which the unregister may free.

Stop the generator in pps_gen_unregister_cdev() instead, under
info_lock after the device and its sysfs files are gone, when nothing
can enable it again. pps_gen_unregister_source() then also does what
its kernel-doc says: "it disables the generator so no pulses are
generated anymore".

Fixes: 86b525bed275 ("drivers pps: add PPS generators support")
Cc: stable@vger.kernel.org
Suggested-by: Rodolfo Giometti <giometti@enneenne.com>
Assisted-by: LLM
Signed-off-by: Danish Khateeb <danishkhateeb03@gmail.com>
Acked-by: Rodolfo Giometti <giometti@enneenne.com>
Link: https://patch.msgid.link/20260929124937.51114-4-danishkhateeb03@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pps/generators/pps_gen.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/pps/generators/pps_gen.c b/drivers/pps/generators/pps_gen.c
index 630a8804d63e7..eda7fd933bec7 100644
--- a/drivers/pps/generators/pps_gen.c
+++ b/drivers/pps/generators/pps_gen.c
@@ -228,9 +228,18 @@ static void pps_gen_unregister_cdev(struct pps_gen_device *pps_gen)
 	 * An open file keeps pps_gen around, but the driver may free info as
 	 * soon as we return. The sysfs files are gone now, so wait for the
 	 * ioctls using info and make later ones fail.
+	 *
+	 * The driver may have stopped the generator before calling us, but
+	 * userspace could have enabled it again since. Nothing can enable it
+	 * after this point, so stop it here for good.
 	 */
-	scoped_guard(mutex, &pps_gen->info_lock)
+	scoped_guard(mutex, &pps_gen->info_lock) {
+		if (pps_gen->enabled) {
+			pps_gen->info->enable(pps_gen, false);
+			pps_gen->enabled = false;
+		}
 		pps_gen->info = NULL;
+	}
 
 	put_device(&pps_gen->dev);
 }
-- 
2.53.0



