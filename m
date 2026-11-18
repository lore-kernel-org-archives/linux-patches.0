Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034649;
	b=4a4jFkVCt6T8md8DL2P24x/cfKaE1SFwWgW17ZSy2eYMW8gXl3buprzUL+gsr3EP7egJ
	 0Htv0DkDBq58yKy0+WyoxUB7cjTPxm/zMQVKjNW2ITMLpeDglsIVMkm/3ib4WRdFWl3Ib
	 Z8N1qh21ZGFqlW2DHN1xfsNHdapSiUCPCMGfhm7PEFdWSXnYdHFE94GClQHDL22FuTUOv
	 Gqw8O8x9W3NMIht6hfMOLB6QN0KAdbLKQydaWfmLNw9oJtJJsINsad/qx2SzXzjiK7EGP
	 tN/GrlqBtAjSUP6hw5qSp2QiUTaSxb7aSnw1KDDeqYco/VJK+AY1nCJUA3C86Yz1Mog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034649;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ODo42aGtZQDvK06zZDrZS00h9N6qhIon7R752oRutfE=;
	b=TKm/pC7iSQ+q210JZw29UA8eZcfTLN3SJdegCNymZ89rHxpoCr1msHUD/gmABISjCFKO
	 cnD71W6B7tuQviqp7KtcLrTfC41MSM8F4xdRFcTd7x3PuVBE8FqTU749ZXSdRiZ5CEHZA
	 PhcPfIxMsia+6Uz2MNqwQKO+eAxXzRGSkBRIctNjgbqySWZ57AAEiyHLLEbcF479j+hGa
	 KyOzvOWwHijZxr9+lijm2NaMqk9CWktnaV0M/4AX+WZ0wAhcyMD9+n433+8CrR8KEgPTW
	 WJ86yeknJff2lb5aplse2Xa0ivbNnOq2RUsc4RsRYSjR62OYgeqsDhhiWez7p6DRKWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="c/chuW9j";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1587F606A31C;
	Wed, 18 Nov 2026 20:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c/chuW9j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31A321F000C4;
	Wed, 18 Nov 2026 20:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034648;
	bh=ODo42aGtZQDvK06zZDrZS00h9N6qhIon7R752oRutfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c/chuW9jvJRyTlurkFQfwaBBaK98he38fs5+9mQhPh2I5LQLzRcUsO0jS7wrFmGO8
	 eDISS8PmxdyaprFx/m58jCQYt915hhlkHw6PpGMs5gXqUIC4eGIHnc8vQlFLhXQgnf
	 bkO8/7mdiXfA9d8YrQuUzNyVF+mY0SZJU2XxoB2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0445/3318] dm-integrity: fix NULL pointer dereference when the R flag is used
Date: Wed, 18 Nov 2026 15:17:47 +0100
Message-ID: <20261118150330.079901415@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 7d4d4f3b668d708d94f62ecdd33ac330a6fd8a84 ]

If the dm-integrity device has the SB_FLAG_DIRTY_BITMAP flag set and the
user activates the device in the 'R' mode, a crash in dm_integrity_resume
happens because the function attempts to read the journal containing the
bitmap.

This patch makes dm-integrity skip any writes to the device in
dm_integrity_resume if the device is activated in the 'R' mode.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: 468dfca38b1a ("dm integrity: add a bitmap mode")
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-integrity.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index a10143b51c984..1259bdf7b2c3b 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3265,6 +3265,10 @@ static void dm_integrity_resume(struct dm_target *ti)
 	r = sync_rw_sb(ic, REQ_OP_READ);
 	if (r)
 		dm_integrity_io_error(ic, "reading superblock", r);
+
+	if (ic->mode == 'R')
+		goto skip_writes;
+
 	if ((ic->sb->flags & flags) != flags) {
 		ic->sb->flags |= flags;
 		r = sync_rw_sb(ic, REQ_OP_WRITE | REQ_FUA);
@@ -3374,6 +3378,7 @@ static void dm_integrity_resume(struct dm_target *ti)
 		}
 	}
 
+skip_writes:
 	ic->reboot_notifier.notifier_call = dm_integrity_reboot;
 	ic->reboot_notifier.next = NULL;
 	ic->reboot_notifier.priority = INT_MAX - 1;	/* be notified after md and before hardware drivers */
-- 
2.53.0



