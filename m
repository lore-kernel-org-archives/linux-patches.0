Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624351;
	b=PBuLb8rRLiaILy0FtBmpEmVcQIl1YFUDTPeKiS777Yeg+SoaZjLZejaQWTwrIKgM/TI4
	 gGbbGa8AmziP05hzCYGGPX8nzlgGHUYDRLrp1esmy4CYJ0yOGhaIUVqTTpy2gUmdpKSFO
	 DmORPjsQPtfn/lDB2Kqr93aj4779160z2O4KflQg0Fj0KUZp3Xl5G7R7fTMtum+DEERRY
	 CFYk4lYMeNwu+2R/EYswhNnhFPcez+JvQgj72mdpZ6IJva/pOL0coHIuGCriEX4hTYkRG
	 780mkrLAuXoO+l0joTCW9JAR7zirfZfF8A7Kg5B/rH9nJ5z98YJYntQbB0TTQXUqlAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624351;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2QROoqfxlHYbP5HkU8hz1MD/lJbgS2/I+g0DnSddMWI=;
	b=VkB+1mxBlilxkSesf2BobZfRNDCvw+fVjXA7CO5MAtgmHDrocx1MslAp/I/KRuAe/Bn5
	 hY6+QxLYqS8E2UFU/4lSTX085ZeQ6JUGmpUBPj3j8v3AyDIyrl4vxSFsipYnW1Hy1HtFH
	 /LOUHEz9YJP26qQhibZNf3bqHzLo4/H0XV5HVlvU9I+OFNwSk5Dbjb/5NsxTuH79HFuby
	 1+/PjKIkVux7WGbgfY77CX9qH3gyXH4iFgW6jJQTycin6NQUDaHvUb7gnAPZ2Yy3YHyrk
	 D6k2Qtc75owzK0eJfZ9vv4Dv5n0rx02SjUBXbIScKFcjeAtoaInSAQur9XnNteXf82Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cFlaCrkt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C430606A33B;
	Wed, 25 Nov 2026 16:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cFlaCrkt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE7471F000C0;
	Wed, 25 Nov 2026 16:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624351;
	bh=2QROoqfxlHYbP5HkU8hz1MD/lJbgS2/I+g0DnSddMWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cFlaCrkt09YreAGnk0vFdXEe8cKy0rW+CMe7oAhv0ahrjx+mV+SpvcN1gYILHjE10
	 Mh0ZohbHgnD+jNL7phTdq97BP091gE49mGUQaeveuCXt6aeges7QcFxhlBF7kJZQSv
	 i7A8GfZ85lFfk3hRzM51ZEM0pT/+9ZE/rm1Le2H0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Dewald <kevin@simpleble.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 164/816] Bluetooth: MGMT: Clear disabled connection parameters when loading none
Date: Wed, 25 Nov 2026 15:28:32 +0100
Message-ID: <20261125143852.991599639@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Kevin Dewald <kevin@simpleble.org>

[ Upstream commit d90f24dc389b9a7524aaac109021d1530fa180f0 ]

Load Connection Parameters only clears the disabled connection
parameters when it loads more than one entry, so that loading a single
entry can update the parameters of one device without dropping the
others. Loading no entries does not clear them either, though, which is
what bluetoothd does when it starts without stored connection
parameters.

Pair Device adds disabled connection parameters for the device it pairs
with, so these now survive bluetoothd restarts, and new connections to
the device keep using the parameters they were created with instead of
the defaults set since, e.g. the connection interval from main.conf.

Clear the disabled connection parameters unless a single entry is
loaded, as was done for any number of entries before.

Fixes: 0ece498c27d8 ("Bluetooth: MGMT: Make MGMT_OP_LOAD_CONN_PARAM update existing connection")
Assisted-by: Claude:claude-opus-5.5
Signed-off-by: Kevin Dewald <kevin@simpleble.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index ec54d383510f4..6405c41f8ceec 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -8243,7 +8243,11 @@ static int load_conn_param(struct sock *sk, struct hci_dev *hdev, void *data,
 
 	hci_dev_lock(hdev);
 
-	if (param_count > 1)
+	/* A single entry may be an update for one device, so keep the other
+	 * disabled parameters then, but clear them otherwise, including when
+	 * no entries are loaded.
+	 */
+	if (param_count != 1)
 		hci_conn_params_clear_disabled(hdev);
 
 	for (i = 0; i < param_count; i++) {
-- 
2.53.0



