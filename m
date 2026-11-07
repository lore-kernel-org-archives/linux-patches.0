Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061783;
	b=FlyTjUfV5Qgosb69nIAIqUhg4gv+qwaj84iTNZHP7Fgqut1Msj5MZsijbjsDln7jv0zk
	 WIPtV3KTjQd+/eKDEfteXlUKG9ENQexMasov0vQgn3uU+3+SMEAnkHARfbax3FsxQglfe
	 FAAFMAFel+SV3494ouXNb3cPZNEY2RxtEcHmEuTUF/14EEDzcj24KyllQMzhMw833Be2w
	 ug1vs/auh1J+6JDhjz+ZuGSr1gBUH+OaHuj3iLYw0GqIFeanzFMLU+q7Q7MPoQxUaFeAv
	 P/6qnVZNRu49gwootNQbpfT62HDVx/gbg1zDk0fg5yyJ7+al1y/lnYvZf9V+oo/vkow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061783;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nL4T06vwdb5beWR+xvR0G1Lo6xbdbgK5fG+wqFLXWy8=;
	b=Ai4DeajCrKtLhWPdC9248UaB0cvM4Nb3NnvZ+TBqDPKTQxi13A4qVwJGQrOObajVfuuJ
	 9m5aivuWk8svNblfLbpxE5m0vKOv71q2mbPJot4sKgp6DQlAUWTYXHddujd26mqFFJUiv
	 FZugyw2hD5ZTMLGmex1gt7oQdO1ySVAU2ata2kx5UH8My+w97ppsWNPfN73OE2BzFHlh9
	 K09yfEBYiEAva7/3Xdoz8Kz7tssVE/6rXC7bHQlKXwIfmoOFecoTzYNA5B6Gw6cxEU/Bl
	 e+rO7jVig++HAyb/fHaUjSbozcLHv8POpU1Asvjf1MphctIAqRZAwM/ZdxdpgDPuJew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RlG84fGg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD108606A326;
	Sat,  7 Nov 2026 14:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RlG84fGg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79B1F1F0089F;
	Sat,  7 Nov 2026 14:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061782;
	bh=nL4T06vwdb5beWR+xvR0G1Lo6xbdbgK5fG+wqFLXWy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RlG84fGg3Wp3vaNENgdXu4txkZIJHL6jnS7uhzcG3MyeXI67KvogQfIlHy8c0MeyO
	 pGl4ml1mW6poTtb7pHbZnl8bXdojv7VXS/djxYrNYJQx8iKzZzWwMPsOALRZRHTIal
	 z/Q9A1wRocrmmXG+KE/geP0tkXE3MDwKZThBQVbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.12 0813/1536] HID: logitech-dj: validate unnumbered keyboard reports
Date: Sat,  7 Nov 2026 08:47:09 -0500
Message-ID: <20261107135020.379003733@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

commit c2deafcb4c8227771f768d77ed3c0a489250e9b2 upstream.

The HID core invokes raw_event callbacks before validating the report
length.  For an unnumbered keyboard report, logi_dj_raw_event() uses the
second byte as temporary storage while prepending a report ID.  A one-byte
report therefore makes both the initial write and the later restoration
access data beyond the received report.

Reject unnumbered keyboard reports that do not provide the temporary byte.

Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw_event length validation to hid-asus.

Fixes: 74808f9115ce ("HID: logitech-dj: add support for non unifying receivers")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-logitech-dj.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -1682,6 +1682,9 @@ static int logi_dj_raw_event(struct hid_
 	if (!hdev->report_enum[HID_INPUT_REPORT].numbered) {
 
 		if (djrcv_dev->unnumbered_application == HID_GD_KEYBOARD) {
+			if (size < 2)
+				return false;
+
 			/*
 			 * For the keyboard, we can reuse the same report by
 			 * using the second byte which is constant in the USB


