Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043710;
	b=CVnL8zTlq29eFKCAXvEL5e0/6LXcbY6Byey2Pho8ARgjwT+pR8EavaSSNS+kTReJ4hMw
	 WUKkWV7MHaf/PF1dWRF39NZd+/kQLPHnHk1kyJ6G36yOicloJXUbGDfW0dsDpAKXHZYqK
	 9MYd92/v3ymUU/3hdFveD65ofvKk7ZLf7pKDgiaukPPNgZ+Cm3SnPntVov9eDxG0pXv4Z
	 SayiJ7J20NMtPy0vlTXX+RLbexjwxFDVaJyNgVFaBhy/9EdMTFR2FXUueHGf35xoEq3r5
	 rM/SY3JSw0pLHn+WtiVs/eQz1bt6DZLc7uiwYlf668BW0ikoB67l8APe1OgEqcSyUhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043710;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GbkaC18l9L4alDN8v84HIYqSkTLCO3VikRwaf7Kg69g=;
	b=GzUDsMLfh0Bg+7AJdf1HnFAjC6dfkvwAN3JnfhUfBz3Mt4nuWIEA28MY6MREi2gXJd30
	 YNCN7Yyu++o5gIlu9Kb4V70ifkL0GoxolnUVh917UUqYcQeC6QjLY7C/G7C3+ersjGa9q
	 srwKMr/KuKWzlVnta6BolbOIJq90C4yG5/AfVah00c1FH7tBhaGKnWNlau2yPdjg8P9zx
	 NSCd881Afop50xE6foZXABn/IYUNPCbg00hPdKp3bWi0oeBe8ZwHvESfp5WOwYF0FGdyj
	 s9Sg5j4gtdxZTY+8kMQohwpL9cXRqUmWMujkWOuwViWkBqz04XdDNrK+TR0lupdYAwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MsBGnIdA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D067606A333;
	Wed, 18 Nov 2026 23:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MsBGnIdA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21EC1F000C4;
	Wed, 18 Nov 2026 23:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043710;
	bh=GbkaC18l9L4alDN8v84HIYqSkTLCO3VikRwaf7Kg69g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MsBGnIdATQhmVLVs8J3raC06UHom9ZGQqxVDMpJfHQ+XzKNdybUtwiF5sv/2dxtyi
	 BRTgsButZhCPSVzwZsTb2H+bqb65n+nclg9A+oRGBZFAR8AdbM6wHo4kA37Vc64MHw
	 w5SkRcdzrBnnPgSP80+VoRyO8PmevVOYdnUusx4Q=
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
Subject: [PATCH 6.1 0306/2857] kcov: ignore an out-of-range comparison count in write_comp_data()
Date: Wed, 18 Nov 2026 15:22:20 +0100
Message-ID: <20261118150212.434786494@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
@@ -252,6 +252,14 @@ static void notrace write_comp_data(u64
 
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


