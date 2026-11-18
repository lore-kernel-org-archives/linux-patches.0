Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051152;
	b=NuMYgjmJNt3V2s/H5j8ot6AwmAIJU+F94W17ok+ya/nXjyDD5L/OLjj7PDUNXbFsDEM+
	 KFx/iHK0xQ3hVkzE8RCLBf7ynODd/X68T3DtVhxSUmyeK8Dd2zi9sP33FHbM9RweGbzpY
	 uLeEVLgiUtFl6NOKz/w9wtz7zrHRaxCkREcvjA8Vi5nCFw1BGTnElx8IKxe3RGj7CPLIu
	 jFW24H5HRrgJCokKEJU2ODvfaXocHxJIGl9a8WnY78wmkJUefxnJ8bNkT+iJJunx2YZX4
	 zYMmTMXss8BWhqvAB+SvgyPb4gLUMAig8KWCP74gyY9J3lguvXjQUR2cF8+IHE78d6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051152;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gyoHe2gSoQCUkD/GJ1YX/N9XTz0solZgvgep73X56VU=;
	b=AeYxWuKvQSIoh0B+p5mGoZ9Y4X5Q7R1zUKPbobTiyq7N5V0PhMmYJt97ateoO7OaK861
	 iaHHbu60UAnT98JuCiGc1cxJt40e8DSZeiLzbpQ7CnEukT77ohzjyqObWohylzPGpxQyF
	 V4dz/wXpdbQiA79uE48V1muLW9xx6ysymW4Q8QLfiiJV9g2hHpo8hiyzP+AGDQqxbVtMb
	 3oGD1Vyj2fBFQk4TslsA+fNXCxRFvPQU6Vc72BdxraAryOx3Y4p8eGXt0DMOPd0uWrmfI
	 iAclp01p+XInPlqtu+/JqonLVXrlwLGPBrDhbrrW0ue/xZc28lGO4PQLOdcJRDVCY4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KjI1jeVc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8E6606A330;
	Thu, 19 Nov 2026 01:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KjI1jeVc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A711F000C5;
	Thu, 19 Nov 2026 01:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051151;
	bh=gyoHe2gSoQCUkD/GJ1YX/N9XTz0solZgvgep73X56VU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KjI1jeVcYlFpSyNRWYM0B5bEkJC4rIgidq6vEd1jzUXQgj28y8DYILoChAyJApFco
	 TPyvzl/C5KIF4d23VV2fQpJJiuV05ahSNHPNvRUYXRB4Txfdu1t2fd2ZByikizFagP
	 Ex8FUK5Er5m1K2fFUJ5q2canXDHHbjm3JG4fBzUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0107/2214] misc: hpilo: validate device queue entries before use
Date: Wed, 18 Nov 2026 15:29:43 +0100
Message-ID: <20261118150014.196261367@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8d00df9243c43..64795066e196f 100644
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



