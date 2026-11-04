Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826901;
	b=xepUbUU6PR0OecVyYPdWruZtasaLX93bRaNfUReW1rJVqA915hWqgt1EPVjrF3s/P1x0
	 sAMPqxOF70S5FMXHy2L0rCxgzc6ENpRCP2gATUGaj5G8Yn6/73Tca/FbcSwHbPmzXeg7V
	 ErOWXrjE15Db7YQojScJ0revquuzIx7e4iEaXM/TMC+6fhG0aEOKjKsTbBFAR+wXB3S9M
	 WbFxS8VcOYXaRzWzqTnVjmhYCABUcv6w/rX/QXHAenNXl8gDxLYocLTBAm9hhIiW3NuuD
	 Hsl41qp77WgKAfj/NtqoUdX6MfTGeZTYnaQcyh7UT0NkPktScBHCG3+W9PQyjDufp3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826901;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6KPFz5PdcbiOPBBiwmF17IqgtqPt4PHzDZE0bhHnSac=;
	b=c3sVgsrE3mFfEKOOqrZLFVYq3v6hxu1v8igK2z79AQIglqoOdr8ZLWTcQlKPtsa9GihW
	 y3XfZdz8DOoACgayM0O4aMRU7+FhQxbbpcnJeDqccypHcmyV8jhrOe3e5eH5Fei+g3J7p
	 6OknP7fgiQaCB4y633ouk0Bd3o7Nwj/Vias9X0PXklvB3I2FTeHtOzCM6TXGYlg114csE
	 Sdee2+F1o7pP6KSXaTPrcnLkdeuzGRS7i+ZIqXgaafLJl4r7a1VH9IjSHVO7QZYMJ6BK5
	 epi+s0dcZ9zVTlJ2//rOj5xtmzvtrXTAuN3BlbjOVwy3yixEMKs2WG+o7GwO/7HQC+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xXB5EAHd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3636084B41;
	Wed,  4 Nov 2026 21:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xXB5EAHd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9571F000C1;
	Wed,  4 Nov 2026 21:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826901;
	bh=6KPFz5PdcbiOPBBiwmF17IqgtqPt4PHzDZE0bhHnSac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xXB5EAHdoC5kBsx8EEp11ndC+iep29H6rtDc0NXfUajdESIeTS3rzw6M0Gc8axK7K
	 VMo7u7GvJuU0C4f9IDbg00ebKuBpzgj/kGedYEYq3lgJFLXFuKKJAe4HmC7bDjl36j
	 Ks1RrPw6X1QukkXF12Pa16TlEJOXUfOjsuULLH9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fang Xieyan <fangxy@xiaopeng.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Marco Elver <elver@google.com>,
	Victor Chibotaru <tchibo@google.com>
Subject: [PATCH 7.3 074/547] kcov: ignore an out-of-range comparison count in write_comp_data()
Date: Wed,  4 Nov 2026 16:04:18 -0500
Message-ID: <20261104211040.359081950@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Fang Xieyan <fangxy@xiaopeng.com>

commit f5263bee9eb84d2388fd7555a18d518e17226894 upstream.

write_comp_data() reads the comparison record count from area[0] and uses
it to index the coverage buffer:

	area = (u64 *)t->kcov_area;
	max_pos = t->kcov_size * sizeof(unsigned long);

	count = READ_ONCE(area[0]);

	/* Every record is KCOV_WORDS_PER_CMP 64-bit words. */
	start_index = 1 + count * KCOV_WORDS_PER_CMP;
	end_pos = (start_index + KCOV_WORDS_PER_CMP) * sizeof(u64);
	if (likely(end_pos <= max_pos)) {

The buffer is mmap'd writable into the collecting process, so count is
under its control and end_pos <= max_pos is its only bound.  A count that
wraps the u64 multiply leaves end_pos below max_pos, so the check passes
while the record store lands 24 bytes before the buffer, in the unmapped
vmalloc guard page, and faults:

  BUG: unable to handle page fault for address: ffa0000000b60fe8
  #PF: supervisor write access in kernel mode
  #PF: error_code(0x0002) - not-present page
  Oops: 0002 [#1] SMP KASAN NOPTI
  RIP: 0010:write_comp_data+0x7e/0xa0
  ...
  Kernel panic - not syncing: Fatal exception

Bound count first: only max_pos / (sizeof(u64) * KCOV_WORDS_PER_CMP)
records fit, so a larger count is not a valid index and is dropped.
kcov_move_area() bounds the same untrusted count this way, and no count
the end_pos <= max_pos check accepts reaches that limit, so no valid
record is lost.

kcov is a root-only debugfs file (debugfs_create_file_unsafe("kcov", 0600,
...)) and write_comp_data() exists only under
CONFIG_KCOV_ENABLE_COMPARISONS, so this is a local, debug-kernel
robustness fix: the process corrupts its own buffer and the kernel oopses.
It crosses no privilege boundary.  Additional details at [1]

Link: https://lore.kernel.org/20260917104306.22145-1-fangxy@xiaopeng.com [1]
Fixes: ded97d2c2b2c ("kcov: support comparison operands collection")
Signed-off-by: Fang Xieyan <fangxy@xiaopeng.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Alexander Potapenko <glider@google.com>
Assisted-by: Hawkeye:GLM-5.3-flash
Assisted-by: Qoder:Qwen3.8-Max
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Victor Chibotaru <tchibo@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kcov.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/kernel/kcov.c
+++ b/kernel/kcov.c
@@ -253,6 +253,14 @@ static void notrace write_comp_data(u64
 
 	count = READ_ONCE(area[0]);
 
+	/*
+	 * area[0] is writable by the collecting process, so count cannot be
+	 * trusted. Bound it to the records that fit, as kcov_move_area()
+	 * does, so the end_pos multiply below cannot wrap past its check.
+	 */
+	if (count >= max_pos / (sizeof(u64) * KCOV_WORDS_PER_CMP))
+		return;
+
 	/* Every record is KCOV_WORDS_PER_CMP 64-bit words. */
 	start_index = 1 + count * KCOV_WORDS_PER_CMP;
 	end_pos = (start_index + KCOV_WORDS_PER_CMP) * sizeof(u64);


