Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051742;
	b=Kgq6kFy1Yxl60pmwK/y5NeFFKB/a3WvlnvNZOJ2QZ6cHGUoYP0TczWRNSwVx+4hUctH2
	 X03BCOPcpS/jiXkJ5UDXA6asDGtjHuqKblGWYw2gtDE4aIuQO+ygfHs10k4ijB9t5uQcb
	 F7CfDQD90n0LTZ73I90Yc1opkLOFFBrQaUPC8fp1/corA6wWtYYJLU16Y/RYLLLB2ywAp
	 2S+hw9sQYvUQ17v0/RTyXGjs0gRuYO0cx2/MGR+GV5D7yKXb4gvng/VIJI85bfgW52N2I
	 0vhGStbIqhaLMZge3sFKbb8nqRqJl2JgEX3v42acOb9WX16ljdhjZiOfWNHvAtON4FQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051742;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HZ894K/X/CY0a0ev55A1zTM7lgv05sDXotyZ7lXlwmI=;
	b=WFBw8uyzMviF/t3QIWclAEeuvlvKdjmev+CoOYrrUPQ/vAwrqxaIde+rulN5ZcDj4rCc
	 8Aik0gpuOauzNkgrjmREj9V9AI5Y1iPuG9eCwv4BQ06/ZNcnaZCGbG44AP3l+m3aSXOFE
	 KC1rB3Obi4mrru2+qiECoiV6yj2ZCm2602q3nIYB30qn0QmVTN+Ku068qQnaD6Ukegw3m
	 cb1btY4yC6syq/ROnO6mHrrgX2swpAsoRBOsR3kMtzCOfjMLXHBcjUF0w7XMnAyTac9Y4
	 QdMWVIFwpY4GLw3OEywYoPrYf6SZCUnb5zGr1HCnJwSQbsehkPOZJ4G04U1X+mAAHmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bCTJI7Wm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10433606A31C;
	Thu, 19 Nov 2026 01:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bCTJI7Wm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F24D1F000C4;
	Thu, 19 Nov 2026 01:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051741;
	bh=HZ894K/X/CY0a0ev55A1zTM7lgv05sDXotyZ7lXlwmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bCTJI7Wmp+sCc0yVxrx6rTAZ37ZpBpysztbsC2G+hPKYYagTqstnsc0QhzuGhNfi5
	 daL64BaafTH8g6zbRaKUCxBn6UuyELphtryqE8cO2UD6NQgWlERqEAJfijOJ5CKev1
	 2OUigXmUCfZaiXff365nq+wINsdwvQUbTDt1HuVc=
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
Subject: [PATCH 5.15 0257/2214] kcov: ignore an out-of-range comparison count in write_comp_data()
Date: Wed, 18 Nov 2026 15:32:13 +0100
Message-ID: <20261118150020.410569634@linuxfoundation.org>
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
@@ -237,6 +237,14 @@ static void notrace write_comp_data(u64
 
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


