Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062331;
	b=M2hX0E13hEWa7N17+3W5qB8FFtbTn10ZYMmswvOhBj+N3t3k4r/fqsYcWqkwqzyUXvCH
	 gCTe+qWIX7zggzY+AbYgKevumAGUjlE1cj+gy/iVpG7xpTH4N26nI53fec7XIqrBrI89D
	 jhqVEpSjMA1J4Z80RtqSCkMuVKxhZUs1wy0amdrg1IJwHC11Ew6rn78M1dN5VnZLhu7/G
	 QEAUH3tAPdMxVIGSnShGd6W89ba0hFVOUvxEqBQzdG2UOz2OPO1Gw71zS/ERBK4zvgnqF
	 kPGYo0DMZTL7GTpPv/jDW2Fix69/NlbVjbxYgRxXri8+MZPde/xBNWRAJ4JKP18qecg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062331;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4uKcsX/bOWMuIMIAea8frNCug0dY3x0/CvWtd6sIn4o=;
	b=zkD940RhoNUqxHN2WUe/PTcsl1MAPKpKrg0KiQjgUONxSyPfBTyVrIYoYExHHDhMcnxC
	 EbkC6JBJTqjPVl3/LmmVmIioTo3kHSWcObJHmZG96cKDMFwDfEaAPN1DdA/byMu+k9Q1p
	 ZXnlk5URwjsSXx6pmj0xxXh3TfzYAIFCvwQwHBil0nasmqhuG+U+Z0Tr6YFs5NMYrKmLS
	 bzhp/DXHV9idsCrKrQQXFMosSoW2BLOxrPYcBIYbBo7nBVi46Fk39pp787LHrCInBS4C6
	 mdqtcitlqTh1PVWojpJwAXFDg1UTY57LTQRUHXf3HlrV3JOjkvw2r8ZkXedtDOT+hng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nX7kVOBF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48735606A660;
	Sat,  7 Nov 2026 14:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nX7kVOBF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E93B41F0089F;
	Sat,  7 Nov 2026 14:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062331;
	bh=4uKcsX/bOWMuIMIAea8frNCug0dY3x0/CvWtd6sIn4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nX7kVOBFZBqDnSs18DojVGX2j/Vh9vOAuePB4klu8bBxTTZavukKthr7/z1hp5I+I
	 COu0mKlYTcZ7og1PitrP87b9Q9pGDYqbtrmVNGboC1iZ+sTr+yT9Me+n3tuz+JAYXb
	 T1v+zA2qm07i3u3XQ8nXDaMRS34eZJ3JBYEF1f3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+e5693071d903b832@bugs.sh,
	Samuel Thibault <samuel.thibault@ens-lyon.org>,
	stable@kernel.org,
	Weiming Shi <bestswngs@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1262/1536] speakup: Fix NULL pointer dereference on VT switch + selection
Date: Sat,  7 Nov 2026 08:54:38 -0500
Message-ID: <20261107135033.216531043@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Thibault <samuel.thibault@ens-lyon.org>

[ Upstream commit e1301ab8a8411fccc7effe0711fc09939a94953c ]

When selecting/pasting very quickly after VT switch, the tty is not set
yet, leading to a NULL dereference. We can just abort the operation.

Reported-by: co+e5693071d903b832@bugs.sh
Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: stable@kernel.org
Tested-by: Weiming Shi <bestswngs@gmail.com>
Link: https://patch.msgid.link/20260829164945.2691317-3-samuel.thibault@ens-lyon.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accessibility/speakup/selection.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/accessibility/speakup/selection.c b/drivers/accessibility/speakup/selection.c
index 7df7afad5ab42..463a7ef19315e 100644
--- a/drivers/accessibility/speakup/selection.c
+++ b/drivers/accessibility/speakup/selection.c
@@ -61,6 +61,9 @@ static struct speakup_selection_work speakup_sel_work = {
 
 int speakup_set_selection(struct tty_struct *tty)
 {
+	if (!tty)
+		return -ENODEV;
+
 	/* we get kref here first in order to avoid a subtle race when
 	 * cancelling selection work. getting kref first establishes the
 	 * invariant that if speakup_sel_work.tty is not NULL when
@@ -120,6 +123,9 @@ static struct speakup_selection_work speakup_paste_work = {
 
 int speakup_paste_selection(struct tty_struct *tty)
 {
+	if (!tty)
+		return -ENODEV;
+
 	tty_kref_get(tty);
 	if (cmpxchg(&speakup_paste_work.tty, NULL, tty)) {
 		tty_kref_put(tty);
-- 
2.53.0



