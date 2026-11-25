Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620230;
	b=BQZBiXy0cLzKSHKJ+7C6970SNPXNaz5AAsUbUflaJk7uI4ysAQMVI9Ooh+8n4fRwO7gH
	 WHxfLesZlRhB5+O12Vlbn5wpAtO6qHBL9mvs8is0FTZZKNLixWhcbHdPvLYa/0Hq1O9zP
	 HYJSWMju8dd+EAkqyOwuBU60fK8LG7WzMsB2svhrSFHfq7+ZzpZ5LIqn9uA1/5pO4fLI8
	 PfpL5YWE8cg4kaJ70lk14L9woiGHocve8gHP7RTQTYXXAsJ465UhP4MKVuWNis2e7w/41
	 MOZypwyUiypxbEWkWKg56nzuyamHkDp6o7Pw7TkRfjD5oU356ZQWDhpNotevdxsru+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620230;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PiRKmBcFEJRcr/qshA2Frb2m6V/Ie3UFRerKC2sUgh8=;
	b=CpHWCv2Ft1x6zyaSYrjyrd1IwjUfGcZ7Hjmz97aM2OT3AB6fUfVWMjP9DFQO6JYyY+4e
	 BK4YFTu+pWhIs4TIM/FQcK06HQFufMid7JN35+46ojMaEcvYoM5uVY6VFhewuW2HsS0zt
	 QeRrn9/tOjeRHjqo1NavChND/qqe+O+wLVW3V4rzJj3tNstezskQTLJgBm07EDLcakue5
	 sfq+X7OXrettQeh/3Y2D4GIKDr3MSaSXhKN/PBEnUUMCGjowzbAnt/Ptj219wD2/OzsRv
	 SSAyLCL+Q3cmGDfYCMvZrccRN0JKoSsWZXaWsnC8DuH1Uy3tB5G89rQyQKxMl1Lah/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2s8iyDVy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A78606A334;
	Wed, 25 Nov 2026 15:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2s8iyDVy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A92041F00ADF;
	Wed, 25 Nov 2026 15:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620230;
	bh=PiRKmBcFEJRcr/qshA2Frb2m6V/Ie3UFRerKC2sUgh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2s8iyDVyC683UqzvByWdwJe+F9aJqxgRtuqYRQgN15C/VIfxvkLqFknAQb1ebJ+sE
	 JcUeZnhoDKZGdnqxieiCYTgD90GRgoeOtTR3yxrbI/Ij9HEWzgechzQ1QL3FhslTs3
	 xUNUA59JZ/WF+oA7ft702V3JE1JW9qLZnP0JEjMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shao Mingyin <shao.mingyin@zte.com.cn>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.3 0852/1005] dm log userspace: drop the device reference on error
Date: Wed, 25 Nov 2026 15:36:30 +0100
Message-ID: <20261125143841.668749873@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: shao.mingyin@zte.com.cn <shao.mingyin@zte.com.cn>

commit 0550d3b14e008b033b02cfce668008ec6addffe4 upstream.

userspace_ctr() takes a reference on the log device with
dm_get_device().  When the integrated-flush workqueue allocation fails it
jumps to the shared error path, which frees the log context without
dropping that reference, so the device stays busy and cannot be removed.

userspace_dtr() drops the reference correctly; do the same here.

Fixes: 5066a4df1f42 ("dm log userspace: allow mark requests to piggyback on flush requests")
Cc: stable@vger.kernel.org
Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-log-userspace-base.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-log-userspace-base.c
+++ b/drivers/md/dm-log-userspace-base.c
@@ -294,9 +294,11 @@ static int userspace_ctr(struct dm_dirty
 		}
 		r = dm_get_device(ti, devices_rdata,
 				  dm_table_get_mode(ti->table), &lc->log_dev);
-		if (r)
+		if (r) {
 			DMERR("Failed to register %s with device-mapper",
 			      devices_rdata);
+			goto out;
+		}
 	}
 
 	if (lc->integrated_flush) {
@@ -315,6 +317,8 @@ static int userspace_ctr(struct dm_dirty
 out:
 	kfree(devices_rdata);
 	if (r) {
+		if (lc->log_dev)
+			dm_put_device(lc->ti, lc->log_dev);
 		mempool_exit(&lc->flush_entry_pool);
 		kfree(lc);
 		kfree(ctr_str);


