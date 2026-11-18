Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059983;
	b=pFZNcYIvS5+gdTNuEW4gEFnYnvRmh10Avtys4piNKu7Tv6EpZgD8ZTkygMJXpksv0wC0
	 2gNOr4d+jJ4pDFmhO6WsrJ66HvN/VfrdOZQxMt3qpqqhdC5FbNYoyy4deEo1xZJGvnclf
	 Fp3MIrwMW7FfiXAefFq+FYw44AACTKMI5gJk7+Vi87Y2OdvrlzLTmGsdkHlNymEyCWYat
	 Z5Fk3rJRU81qe1I7SFj1vi3Z8MqLNC+OX36RLeDHtKzfFQaJx/soxU9zQ+6wkj5jYD7BO
	 L4AVKHEOiDXGXENDl9jYeRPRgJeHLPX6ggjF0c8p3kOz0TRCu1hr2KuPLhNLs3p2iGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059983;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U9hHBlwZf/F4xa9cZUUGBTl24sEDI+wLoDhE6XuJsgk=;
	b=oYQsvD/pnUtsDakdhVWsq4nEPwXdlh1tMQhrh2IB+TE+dj7RAcwIkZrEjvmfRvDmbRME
	 t9U/STvKuiQfMX3Xw4ZzJsPKE2A9j3Y+YlkjEFgmz9MLOPWJmfyulj5I6QcJAcGtxrxOI
	 J3VvZ09l7GzNgV4Wyhwmpz9n0rk4k7cte9BuwP0P7Wex3cK/gOEkkzlqst+h1VSdSMGzd
	 N+BEbs3R76/Tbx/MKSyB4MdbTM9m3t0P1hkImS55Efq2+6Var6HXtop04D9DenSQgER3u
	 7aivZ5XGkAiSZYLjqwepba2TieXtfR6HkDsfZvkkyHDxRqUeenrjLKu8oeZWYHH9Scg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=grwXKpgT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E200D606A320;
	Thu, 19 Nov 2026 03:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=grwXKpgT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 451B51F000C4;
	Thu, 19 Nov 2026 03:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059982;
	bh=U9hHBlwZf/F4xa9cZUUGBTl24sEDI+wLoDhE6XuJsgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=grwXKpgTB7mGhRSkhlhFmFQLg3T06jADzL3yPm/qZWI18Qv48zE+CPnLK7QIaDpvV
	 hqHxLzY3xXvvBzXe2/Fv67Z/0UWMGfsupiRzaiBPsfXULt8gy7T88gcZoImMxoLdN2
	 t4XUVP1z2cOYTPG4TK6u/BhQJ+w3aQMtKg/jau5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bhaskar Chowdhury <unixbhaskar@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1019/1848] kernel: debug: Ordinary typo fixes in the file gdbstub.c
Date: Wed, 18 Nov 2026 15:50:57 +0100
Message-ID: <20261118145959.665415653@linuxfoundation.org>
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

From: Bhaskar Chowdhury <unixbhaskar@gmail.com>

[ Upstream commit 2bbd9b0f2b4ec0afa80b52b1a68bd3bc80618275 ]

s/overwitten/overwritten/
s/procesing/processing/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Link: https://lore.kernel.org/r/20210317104658.4053473-1-unixbhaskar@gmail.com
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Stable-dep-of: 13962ef7021e ("kgdb: Fix buffer overflow in the 'M' and 'X' packet handlers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/debug/gdbstub.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/debug/gdbstub.c b/kernel/debug/gdbstub.c
index b57e5e338aab2..45f6e39d29db4 100644
--- a/kernel/debug/gdbstub.c
+++ b/kernel/debug/gdbstub.c
@@ -321,7 +321,7 @@ int kgdb_hex2long(char **ptr, unsigned long *long_val)
 /*
  * Copy the binary array pointed to by buf into mem.  Fix $, #, and
  * 0x7d escaped with 0x7d. Return -EFAULT on failure or 0 on success.
- * The input buf is overwitten with the result to write to mem.
+ * The input buf is overwritten with the result to write to mem.
  */
 static int kgdb_ebin2mem(char *buf, char *mem, int count)
 {
@@ -960,7 +960,7 @@ static int gdb_cmd_exception_pass(struct kgdb_state *ks)
 }
 
 /*
- * This function performs all gdbserial command procesing
+ * This function performs all gdbserial command processing
  */
 int gdb_serial_stub(struct kgdb_state *ks)
 {
-- 
2.53.0



