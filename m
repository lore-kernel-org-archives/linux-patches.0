Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591392;
	b=cxWPaiPaVYbk22oH9kHSInlM/kqgfN+o/SR/eJtQCeIgIMaRcWZ3Kn3qXvUCT8bT0Aev
	 4uNtANIAgC1eBPU9iwz1AU6gJXoDOqlojtKJCfBepoMoCTTwYR5vK7UFbUbamUTbiTUyC
	 9mcUNyFkJjgJ8aOb9SWnQLdAaq0iCDoJXSo4wzM7wDHpz+ue3B1ZOOJFTN3qANIeQluQV
	 G+7yWUZm5RZZCFpgxMrYFxxQzlVBgtRkUvDGCXKX3TyPKeQBFEDNjq0iKSoy9Mj7kZj26
	 X5bw48fAMPnQ83Ewhgkpgi6OIsu9fW1I7f6VXXAClIke9O0/N2ytd9rNZ9fmc27/MAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591392;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cBg0ru7px8tVcc+gXf7hXjEI+vO0ZEG5AttLBnDnHBo=;
	b=to7cT5L/dsJbDxNhgkkPGwiYgVzkxLtf+1IiXPiO6ALYgndaX6CqZx8l6UevEqpHUlID
	 gWIP1PHKNN4AZlwCN7b2/Laq1XPXtzdzwQOcLSQ+Ipv/Z42ZmL9tdhH2GQRAqMq4FUBFF
	 sGm+9K4Cr7wAgAUoA7xtyAltGqf5rV78hXeGOT9N1LbLkFCxbIZ0P8gntycwADoYjhsoM
	 1RU8jb4xdYuAjEJ/rqhuuIs6L7LeWJu7hJbmOLvJwQMjZTpswWPBvvXpCcHVYQw29TJw1
	 B5Qkf8vaQ1wLJmMrV+5pF6atrK/o8qg5IAxQN8AiFvc8bGvegltXwJuepMADU22Bivg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ryYxzec7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4AB1607A5CD;
	Fri, 13 Nov 2026 17:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ryYxzec7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 905CB1F000C4;
	Fri, 13 Nov 2026 17:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591391;
	bh=cBg0ru7px8tVcc+gXf7hXjEI+vO0ZEG5AttLBnDnHBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ryYxzec7ysWwzxu5iTnfDY65RNCR1tBwV4KdMdpEFUtOrUueKZMCPVmxSQ7VWTL9R
	 mGVN3xaUNcuI9RaRh0X9rX6YckrXIN+BF0jtSmNcKCzYyUEE9MHeIhAp2pyxrECtKU
	 Dv2ATBjpQ+YLeozTUEK/dx30ak0BJPuxU2B3vIP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Jie <quic_luoj@quicinc.com>,
	Yury Norov <yury.norov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 491/670] bitfield: Add FIELD_MODIFY() helper
Date: Fri, 13 Nov 2026 10:50:55 -0500
Message-ID: <20261113153828.575010850@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
Stable-dep-of: ea9854a169e9 ("spi: cadence-xspi: reject SDMA transfers larger than the requested length")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bitfield.h | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/include/linux/bitfield.h b/include/linux/bitfield.h
index 20978c60b565d..c60554acc16dd 100644
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
@@ -156,6 +156,23 @@
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



