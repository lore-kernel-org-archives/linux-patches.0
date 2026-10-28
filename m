Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217389;
	b=ncCiY235HBEVkuKnO6KGjZ7YDik+7blYQFlHqzCVkCj6U8GvOaFFUlIHOJxSQSZjndAC
	 x8iV8wu5f6jJL7ztBZOREsqQdHoXx6f3Ji1bGa47W6dl/99r1MmIF6KnqEUaW0l3VzAb0
	 38wN59AJPfJ7gOUKuOdBTTN6pdEv5I61WylGbfFCwWabIj2NC4ZHmUnQlsNOYb1gvR+Vg
	 YzVBYOUvgQDAKCSmZJwcLlznSeyJUWq91wkvQFDCHhij5gV19wo51dT7w+44gYe88GXLa
	 9Oc2u3YkP1Gq3Uip22MJauU3iAKWtOuS/ICO73NsUysV3UI3OxvKj0zWdgHBYR1dFDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217389;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vBxnJ4e1G2U9ZZnCo1Do88hEsXC/CVqKx2Cnq+Vlxlc=;
	b=H/M8aethHn6EJ+bRhBwrY27x0WLt1mB728ODwlWW0hVG5fnwUDsvy3q4CzompGC2PMlL
	 GEVig0d1rSDjSwNGcpDx2okNLp4EKNRJqbB+ym8ZnuFy551X4yNcYPYb7jsmS7rpSwTwp
	 rshtkgL2pTgYCUm5CxDH4HzbQ+Ip8auyIUR0Xj8AEeTTQPDyTiBA6u+d3nYvWLuiJxRrF
	 30bdzR8X7CHVYGDdiPoEjBAMGyXlOEoug/dO6YvoU4qFgA8e+Vd+YafUUvs2foo2x5OZ/
	 XanPjKEMOO/OGzu4ivgP8XCvhnqTnqdW+vKDcTHduagLKaY6eOO0h/3dT1dd9zClUzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IAlHtPOR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C036606A31C;
	Wed, 28 Oct 2026 19:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IAlHtPOR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 782C21F01825;
	Wed, 28 Oct 2026 19:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217389;
	bh=vBxnJ4e1G2U9ZZnCo1Do88hEsXC/CVqKx2Cnq+Vlxlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IAlHtPOR3jXYcyvPLZTFIUOJr0+3t8CknCS2XBq8Jad8cM0+cO6N+sLLVB3RuioRO
	 NH3PonWsn4I3NCW7sqLWrtpM58tpDSJIf8goBZvNvwbN1rzkhCN7c1zOU4IU4e46jz
	 W47TnQVLyR1eiF26yrW3hWbUjJ1ZI4NQkEb78YwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Niklas Cassel <niklas.cassel@wdc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1880/1887] scsi: block: Introduce ioprio hints
Date: Wed, 28 Oct 2026 18:06:16 +0100
Message-ID: <20261028170542.240023536@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit 6c913257226a25879bfd6226e0ee265e98904ce6 ]

I/O priorities currently only use 6-bits of the 16-bits ioprio value: the
3-upper bits are used to define up to 8 priority classes (4 of which are
valid) and the 3 lower bits of the value are used to define a priority
level for the real-time and best-effort class.

The remaining 10-bits between the I/O priority class and level are unused,
and in fact, cannot be used by the user as doing so would either result in
the value being completely ignored, or in an error returned by
ioprio_check_cap().

Use these 10-bits of an ioprio value to allow a user to specify I/O
hints. An I/O hint is defined as a 10-bitsvalue, allowing up to 1023
different hints to be specified, with the value 0 being reserved as the "no
hint" case. An I/O hint can apply to any I/O that specifies a valid
priority class other than NONE, regardless of the I/O priority level
specified.

To do so, the macros IOPRIO_PRIO_HINT() and IOPRIO_PRIO_VALUE_HINT() are
introduced in include/uapi/linux/ioprio.h to respectively allow a user to
get and set a hint in an ioprio value.

To support the ATA and SCSI command duration limits feature, 7 hints are
defined: IOPRIO_HINT_DEV_DURATION_LIMIT_1 to
IOPRIO_HINT_DEV_DURATION_LIMIT_7, allowing a user to specify which command
duration limit descriptor should be applied to the commands serving an
I/O. Specifying these hints has for now no effect whatsoever if the target
block devices do not support the command duration limits feature. However,
in the future, block I/O schedulers can be modified to optimize I/O issuing
order based on these hints, even for devices that do not support the
command duration limits feature.

Given that the 7 duration limits hints defined have no effect on any block
layer component, the actual definition of the duration limits implied by
these hints remains at the device level.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Link: https://lore.kernel.org/r/20230511011356.227789-3-nks@flawful.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 01584c1e2337 ("scsi: block: Improve ioprio value validity checks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/ioprio.h | 49 +++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/include/uapi/linux/ioprio.h b/include/uapi/linux/ioprio.h
index 4444b4e4fdad9..4c4806e8230bc 100644
--- a/include/uapi/linux/ioprio.h
+++ b/include/uapi/linux/ioprio.h
@@ -58,4 +58,53 @@ enum {
 #define IOPRIO_NORM	4
 #define IOPRIO_BE_NORM	IOPRIO_NORM
 
+/*
+ * The 10 bits between the priority class and the priority level are used to
+ * optionally define I/O hints for any combination of I/O priority class and
+ * level. Depending on the kernel configuration, I/O scheduler being used and
+ * the target I/O device being used, hints can influence how I/Os are processed
+ * without affecting the I/O scheduling ordering defined by the I/O priority
+ * class and level.
+ */
+#define IOPRIO_HINT_SHIFT		IOPRIO_LEVEL_NR_BITS
+#define IOPRIO_HINT_NR_BITS		10
+#define IOPRIO_NR_HINTS			(1 << IOPRIO_HINT_NR_BITS)
+#define IOPRIO_HINT_MASK		(IOPRIO_NR_HINTS - 1)
+#define IOPRIO_PRIO_HINT(ioprio)	\
+	(((ioprio) >> IOPRIO_HINT_SHIFT) & IOPRIO_HINT_MASK)
+
+/*
+ * Alternate macro for IOPRIO_PRIO_VALUE() to define an I/O priority with
+ * a class, level and hint.
+ */
+#define IOPRIO_PRIO_VALUE_HINT(class, level, hint)		 \
+	((((class) & IOPRIO_CLASS_MASK) << IOPRIO_CLASS_SHIFT) | \
+	 (((hint) & IOPRIO_HINT_MASK) << IOPRIO_HINT_SHIFT) |	 \
+	 ((level) & IOPRIO_LEVEL_MASK))
+
+/*
+ * I/O hints.
+ */
+enum {
+	/* No hint */
+	IOPRIO_HINT_NONE = 0,
+
+	/*
+	 * Device command duration limits: indicate to the device a desired
+	 * duration limit for the commands that will be used to process an I/O.
+	 * These will currently only be effective for SCSI and ATA devices that
+	 * support the command duration limits feature. If this feature is
+	 * enabled, then the commands issued to the device to process an I/O with
+	 * one of these hints set will have the duration limit index (dld field)
+	 * set to the value of the hint.
+	 */
+	IOPRIO_HINT_DEV_DURATION_LIMIT_1 = 1,
+	IOPRIO_HINT_DEV_DURATION_LIMIT_2 = 2,
+	IOPRIO_HINT_DEV_DURATION_LIMIT_3 = 3,
+	IOPRIO_HINT_DEV_DURATION_LIMIT_4 = 4,
+	IOPRIO_HINT_DEV_DURATION_LIMIT_5 = 5,
+	IOPRIO_HINT_DEV_DURATION_LIMIT_6 = 6,
+	IOPRIO_HINT_DEV_DURATION_LIMIT_7 = 7,
+};
+
 #endif /* _UAPI_LINUX_IOPRIO_H */
-- 
2.53.0



