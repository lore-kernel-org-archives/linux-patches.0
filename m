Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057477;
	b=pnoPHngD+pwf/p5LCEWn9AWadRD3B7qChMW/4bWuNHXUxJqhu53HU5Duc1nFvUD44vgP
	 zwDowrL6OH+c7sdsxS8Xl3mh5sUFQT5mVN2244/HlCwiRIDMFw0WbJuzkQmzXwVCs/VPw
	 lUatmY9zqXnqW4JgrLC7AYSw034cdrwboesnm1GJnoEBS21XaPMhnsIFoHyD2awVRcoWV
	 S8R2ONbGn3REPylpOjkF7KX/RyC7E9k6SCTK8Pfrpbu7qPLoqa0hVSwMd2emhpCMnEE9f
	 QXmUl5joh1my4f4jEkc7jwvhkzqRfA4JKM5MxPRO9vm0zxS4QZCVhDUeXLbSnHvaO5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057477;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WFsbJCAYg4lYpbq5h7HTSTlV8dSFfPeN5AUMO7vA5RM=;
	b=2xU5G7dnt/SBA8Bh4+oTn9ZLekOzq1+bx2BrG3MEXp+ds/x4gZ9T3wPYiPiJVjGwr4/u
	 2CEjs/D5wBpLdy83XeJjH59e3RnxejarfDp/TwfXgXF4aMuGg+IpMaXEpRPFVdmUJWIKw
	 a6xupRAlYmzbKUF/sik9o8ZCchd2tadHY8bh/XtfoHxU1w4DfaXQCVZXA2c2qbj4ulpBd
	 xH4z5BhJRkeJol79CZkzuzgkzVnieVhrwNHOhtoieMsgmUZZ9UKm3qcxcgrDCqyYlWOvr
	 b1yxoj3TIJDAwheQ7VIZuSsXKWVfzzlqJWgA3fTdobeLm8DNN1lC0p/ciriRPYG67Ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HSftfRCM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8850660A2612;
	Thu, 19 Nov 2026 03:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HSftfRCM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE5251F000C6;
	Thu, 19 Nov 2026 03:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057477;
	bh=WFsbJCAYg4lYpbq5h7HTSTlV8dSFfPeN5AUMO7vA5RM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HSftfRCM+/ARW7qaaQ/0FqKM78lbEMw1Ti5UIVIlNSWrEsI/n2AaWvwcqFfTGNF+U
	 8jiTqZjlEEKm0yqgNCs8Bcrx35alpxdTAcazmDSSiIvv2qFPJsNxsG40OoscSnI8EK
	 afHyNKWHPxOUdGA53DZboZ6WdYATD9E09qptilGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0093/1848] misc: hpilo: validate device queue entries before use
Date: Wed, 18 Nov 2026 15:35:31 +0100
Message-ID: <20261118145915.022588912@linuxfoundation.org>
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

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

[ Upstream commit 7bf6940d7cf41f1f0330a9bae4b7a886e18fd8e3 ]

ilo_pkt_dequeue() trusts descriptor IDs and lengths read from the shared
FIFO entry. A bad entry can select a descriptor outside the allocated
queue memory or report a packet length larger than one descriptor.

Reject entries whose descriptor index or packet length exceeds the queue
layout before deriving the packet pointer returned to read and write
paths.

Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Link: https://patch.msgid.link/20260624190919.3432-1-alhouseenyousef@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/hpilo.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/hpilo.c b/drivers/misc/hpilo.c
index fea3ae9d86862..75ff914a3de35 100644
--- a/drivers/misc/hpilo.c
+++ b/drivers/misc/hpilo.c
@@ -158,11 +158,16 @@ static int ilo_pkt_dequeue(struct ilo_hwinfo *hw, struct ccb *ccb,
 
 	ret = fifo_dequeue(hw, fifobar, &entry);
 	if (ret) {
+		int pkt_len;
+
 		pkt_id = get_entry_id(entry);
+		pkt_len = get_entry_len(entry);
+		if (pkt_id >= NR_QENTRY || pkt_len > desc_mem_sz(1))
+			return 0;
 		if (id)
 			*id = pkt_id;
 		if (len)
-			*len = get_entry_len(entry);
+			*len = pkt_len;
 		if (pkt)
 			*pkt = (void *)(desc + desc_mem_sz(pkt_id));
 	}
-- 
2.53.0



