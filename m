Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040792;
	b=GS+1QPpNSfYb1WWGOS4LE37c3wPgBCn4d7pULSz3C7V9cpfImYbOobEzciS3yH2fUlHJ
	 v6v3ffQjo9wRvDyqKghG4IdW9PBpE4YyrcWQpqhMMHIMyFJsxuDefEFdadWShIzzLuqkK
	 8sW++ofb4SFn4AFrISaZtJXBj9MkKej1ex8opQtNrqwYCroO86ADuYc0zITophcIG+X+a
	 Ys7kYoAcdihYJPH6nvJO55klnB6HZNcn+l3hrFGOEOo3WN7gdEcM2G4CDIwWyNVs4Jj9e
	 71qimWr/uHFLWiOyqK1RzdjN0NUySldbspeZcCzWGA+sqFPv+AUJLiFZ0h4L+mn3fOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040792;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t6vDk5qfdnso8hFOOeaM7wfwiwgyGpdk2H5sWXtRL3E=;
	b=r0HVPMy/uA88DOgGDchhLj7eVHE04jopgwxK5PGla65DR1oGgaIXRfoAlkGnafh/8Jmp
	 3sD33O8no8f9lDvNAWaEG4k5chNBhAwaapjn1/9881+Wl12hmcdOJ1C5juXTCSdqnDO1/
	 NQgCK+Xcv50L8HpL4JA76zmKn8But0jLUq5L+nDiBlZggNhPIQqwzc0ue1nkIHhLWQ/6G
	 DxuGV+aTgUGrN2lh9bNgC2xrI0Fx8i6OrTOEPZ2n+DvbTS7RHpkorU5wyXZq1Q6+B4BiN
	 +ohbk4z5TuVzwxYtlQqXm50fPmZPDgXkp9HpihE40FE4q1BgiFjeWdEZnm4s9GgGJ6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hI9ha2KN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B61606A31C;
	Wed, 18 Nov 2026 22:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hI9ha2KN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2203E1F000C4;
	Wed, 18 Nov 2026 22:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040791;
	bh=t6vDk5qfdnso8hFOOeaM7wfwiwgyGpdk2H5sWXtRL3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hI9ha2KNkq5ZOdIiu7D4hbvyjWw3YzJlXEHYyzlHTlB+B6993HLKfXCZff5Tb/GoI
	 x8sndsY6rcRH52HdQvTE89kvYDD00/FlYf/RFEfzrU+sibf+vE4mcEbl0MKKwQcFU8
	 qPWHJrg/hkXw7jkUwJ/GCA/YVsvYDXxkuat3Zdec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Jie <quic_luoj@quicinc.com>,
	Yury Norov <yury.norov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2542/3318] bitfield: Add FIELD_MODIFY() helper
Date: Wed, 18 Nov 2026 15:52:44 +0100
Message-ID: <20261118150437.565871206@linuxfoundation.org>
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

From: Luo Jie <quic_luoj@quicinc.com>

[ Upstream commit a256ae22570ee4c3427fdc703a58a89afee6a332 ]

Add a helper for replacing the contents of bitfield in memory
with the specified value.

Even though a helper xxx_replace_bits() is available, it is not
well documented, and only reports errors at the run time, which
will not be helpful to catch possible overflow errors due to
incorrect parameter types used.

FIELD_MODIFY(REG_FIELD_C, &reg, c) is the wrapper to the code below.

	reg &= ~REG_FIELD_C;
	reg |= FIELD_PREP(REG_FIELD_C, c);

Yury: trim commit message, align backslashes.

Signed-off-by: Luo Jie <quic_luoj@quicinc.com>
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Stable-dep-of: 7406d6cf76b1 ("perf/cxl: Clear stale event fields before reprogramming a counter")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bitfield.h | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/include/linux/bitfield.h b/include/linux/bitfield.h
index 87eb3a210bc20..30a3c3b86745a 100644
--- a/include/linux/bitfield.h
+++ b/include/linux/bitfield.h
@@ -8,6 +8,7 @@
 #define _LINUX_BITFIELD_H
 
 #include <linux/build_bug.h>
+#include <linux/typecheck.h>
 #include <asm/byteorder.h>
 
 /*
@@ -38,8 +39,7 @@
  *	  FIELD_PREP(REG_FIELD_D, 0x40);
  *
  * Modify:
- *  reg &= ~REG_FIELD_C;
- *  reg |= FIELD_PREP(REG_FIELD_C, c);
+ *  FIELD_MODIFY(REG_FIELD_C, &reg, c);
  */
 
 #define __bf_shf __builtin_ctzll
@@ -155,6 +155,23 @@
 		(typeof(_mask))(((_reg) & (_mask)) >> __bf_shf(_mask));	\
 	})
 
+/**
+ * FIELD_MODIFY() - modify a bitfield element
+ * @_mask: shifted mask defining the field's length and position
+ * @_reg_p: pointer to the memory that should be updated
+ * @_val: value to store in the bitfield
+ *
+ * FIELD_MODIFY() modifies the set of bits in @_reg_p specified by @_mask,
+ * by replacing them with the bitfield value passed in as @_val.
+ */
+#define FIELD_MODIFY(_mask, _reg_p, _val)						\
+	({										\
+		typecheck_pointer(_reg_p);						\
+		__BF_FIELD_CHECK(_mask, *(_reg_p), _val, "FIELD_MODIFY: ");		\
+		*(_reg_p) &= ~(_mask);							\
+		*(_reg_p) |= (((typeof(_mask))(_val) << __bf_shf(_mask)) & (_mask));	\
+	})
+
 extern void __compiletime_error("value doesn't fit into mask")
 __field_overflow(void);
 extern void __compiletime_error("bad bitfield mask")
-- 
2.53.0



