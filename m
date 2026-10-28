Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207687;
	b=SNMQGtaP9j8crvunD/vrGDgk/McPCY3ju/By8l21Ii66pj2WLqqvRaYZI+GVuaKyl0p5
	 XjZa1wpNNgroCoZxzPX0rELSrARqGxwhts6szyLND7GOCDrfWhLKP93+KXFnNTpY70+Yr
	 Ae9V2GMWXf4BFGU0smy1KuNW5vz3gYurwjt5jTRGtadtvAndlz1qGVsXm8ErIKLSKLGTW
	 LVEG7L7S/xvz5YWAmv2BizBHM4AKnUimX9ARyeHlvL8CRNxvlfJRgjSEPriE+RtkJKbsY
	 p1BFhr/RDPoggNk9Odt9l3AgIng/97ui5aXQjhriELMCE6jo4lg7YmQhYWoMaYgd74g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207687;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GaABEl7OKkVDV/QQsqA1AaZGlIlg9IqQCf1pkSHLhDI=;
	b=h/svdqY+vdGIyTUeObnRHMTBAxTZu1RQVWzpbdlOrZ6o0q14hfuT2lNb1JF36E1bHoGi
	 503t16aehS9mbDv2ycY5IWyuAm32jNSE2NJF20m53G0Y4+qnNOjjK2HApQZP1gsZ0yotk
	 9RPD3DQNozbS5246CiTi9XfULaGJRuWDXHJ4KO4p5u7nJAx9FRQ7PojeXRTKQq1F20Xyu
	 oj8l2ZYHkoZS5mhy2ZQuOJqFfoGjSoNKClaYn6MNl68KKDrnirP9BMrU3VH/2PBBeG02s
	 GuNmsRqRh0SG4jccb7fmhkhD6VfPrA5QPoaqd8MOHKIjytLreCEIw+Ozp+MyK8+TUuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AqGNSjT+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9950F606A332;
	Wed, 28 Oct 2026 17:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AqGNSjT+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB1991F031E7;
	Wed, 28 Oct 2026 17:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207687;
	bh=GaABEl7OKkVDV/QQsqA1AaZGlIlg9IqQCf1pkSHLhDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AqGNSjT+0nNKtTSYwy2CqPrPPMEM+HljAHuN44rZc2QS25uxp8XgiMpcS+SuoSN6H
	 5MnTlzsfyWZvchM/q5r99Z0Q/VPL96Mn53HKM0h7QIi6YFIis5KJps/Kw1Yp2B4TOQ
	 GfXjAXoPFtsx4+HYoeEsWg3jZeP0Ht6kw/XC126E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sun Yangkai <sunyangkai@fygo.io>,
	Chen Cheng <chencheng@fnnas.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 104/247] dm-integrity: require stable writes for internal hash modes
Date: Wed, 28 Oct 2026 17:58:27 +0100
Message-ID: <20261028165949.860116497@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

From: Chen Cheng <chencheng@fnnas.com>

commit b2fd92f016e9d692fd3c8c08d0ee014e9212279d upstream.

dm-integrity direct, bitmap and inline internal-hash modes compute
integrity tags from the pages carried by the write bio.  The lower data
write also uses those pages, so the tag and the data write depend on the
same memory contents staying unchanged while writeback is in flight.

Without stable writes, a buffered writer can modify a writeback folio
after dm-integrity has submitted the data bio and before the lower device
has consumed the data.  After a crash, this can leave data from the later
contents with a tag calculated from the earlier contents, causing
permanent checksum failures on read.

Set BLK_FEAT_STABLE_WRITES for internal-hash D, B and I modes so
filesystems wait for writeback folios to become stable before modifying
them again.  Journal mode is left unchanged because it copies data into
the journal before computing and persisting the tag.

Tested using dm-delay over a virtio-blk test disk, dm-integrity
internal_hash:crc32c and no-journal ext4.  The D and B reproducers both
failed with checksum errors before this change and completed with
READ_RC=0 and zero mismatches after it.

Fixes: 7eada909bfd7 ("dm: add integrity target")
Cc: stable@vger.kernel.org
Reported-by: Sun Yangkai <sunyangkai@fygo.io>
Link: https://github.com/chencheng-fnnas/reproducer/blob/main/dm-integrity-writeback-race.py
Signed-off-by: Chen Cheng <chencheng@fnnas.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3979,6 +3979,10 @@ static void dm_integrity_io_hints(struct
 		limits->discard_granularity = ic->sectors_per_block << SECTOR_SHIFT;
 	}
 
+	if (ic->internal_hash &&
+	    (ic->mode == 'D' || ic->mode == 'B' || ic->mode == 'I'))
+		limits->features |= BLK_FEAT_STABLE_WRITES;
+
 	if (!ic->internal_hash) {
 		struct blk_integrity *bi = &limits->integrity;
 


