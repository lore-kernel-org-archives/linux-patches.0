Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035541;
	b=GxVglzVxC2t2UxD7Xx3etTXIGVT8fO9TYIvj1vDLr1RQADVsWm/bOpI17icFEsBWUSrt
	 Vx6MW+nI+qlgEPR+LmVtkaL9Z+YkafQKcZERSQESOhHKHXfJY2kaHAt300RyehH+oRQk7
	 XMbP58Ngh+fPygMreg70fqN/BLQior82S83E96zSflG4qNVN9IlzCIVr4eyKUtVUva3Rk
	 sO2xNeiTo8ogoQmddqZu/SpqXwfBwRIJUOvb0UwQijzPoEI26EKGnsnODKy5ML8ds1eM3
	 xkb0eIPbImpCICfI5alvEhTyWz9VbJ+GV0BZxnv/phVcTcxvmlWYXKqPG6KJEBfmIZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035541;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MKP/wdTqH9ZQEABjBkc1+eoGiPkD9caq4UuHqftBab8=;
	b=J+xE7cPS/xK7wE5DsbVmwQENfX90nHXrg32uxSOSpmXvoTpyzk0XMfu2joFhQiHnKVbp
	 QzjRRxr10B4nZkpyalF0DVrpaNRpWBLYREkcYvPKSCNIC/5L5jbmN22xUd03sdSOGnAkq
	 1Z8LIRn1DEOAk5FVdPiBC/gE/jdM61OUbmryiPoSLCqRJk1BFGB76ELkpSUJ4TcwV5AJi
	 JriYuYyzBn99iDjbB83lDiB92C4l85bhNhvdbPE/wleyDxWKcmNE4FrWDyzMLOeDZmoO5
	 59Qjko7Y8K9gekvZYPuPwsiQHaaM3ex4WzwfRpHfMjDjjRL/VuhaFphFPeVDPgqB6RQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZNsPDR8X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624A5606A31C;
	Wed, 18 Nov 2026 20:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZNsPDR8X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE9331F000C4;
	Wed, 18 Nov 2026 20:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035541;
	bh=MKP/wdTqH9ZQEABjBkc1+eoGiPkD9caq4UuHqftBab8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZNsPDR8XtzuBVSFMQoGv6WW4hCJ79C9fJQkUDiZMXV6G3d6GFkPTOhAKPGScPZn4r
	 Mc4DiKpFvK0UG2N/k3ZJgtI3fuZq2PArQNqCrSDlo1jh+0a61Kl6kmcPEKvHlt1Ew5
	 X3yYoEM5lrdCZI6whkv1Iz85sQOhQm2fqIbRBrug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.6 0739/3318] HID: roccat: pyra: reject short button reports
Date: Wed, 18 Nov 2026 15:22:41 +0100
Message-ID: <20261118150340.752023477@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

commit 493268f459bb6aeeecbc77f2204c11ad74d05213 upstream.

The raw event callback runs before HID core validates and zero-pads the
report.  It passes the buffer to helpers which inspect data[0] and read a
complete struct pyra_mouse_event_button for button reports.  A truncated
report can therefore cause an out-of-bounds read.

Require enough data for the button report before calling either helper.
Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw-event length validation to hid-asus.

Fixes: cb7cf3da0daa ("HID: roccat: add driver for Roccat Pyra mouse")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-roccat-pyra.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-roccat-pyra.c
+++ b/drivers/hid/hid-roccat-pyra.c
@@ -557,6 +557,9 @@ static int pyra_raw_event(struct hid_dev
 	if (pyra == NULL)
 		return 0;
 
+	if (size < sizeof(struct pyra_mouse_event_button))
+		return 0;
+
 	pyra_keep_values_up_to_date(pyra, data);
 
 	if (pyra->roccat_claimed)


