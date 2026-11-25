Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623108;
	b=zxbmKv97ZXUlBHHu5LE5lXxhXLhwJoEgn4vqx918CSr/NM+gFxbnP7HHC+KoXgga6++E
	 ejbM4wVLRQkOVqPWObnAuCKTCwkksODfiEV9jQe6/tsGOZ3IWSbynL3c8qmyOWhnkztTm
	 RAMWFc7R2Hh3n9V84fFI0FhZrYs5SiD3EdLVbg1EONw7cp+/RGj/OQndjU1RlZQ5DMRWx
	 EbL6SDfuuTS77B5lylTRAyb7OojKCIOFLRelGlSzTw5C9pkGl1jX2ZKqTBmT+ZpYEd0FS
	 Lr6BRjfDMEENSvpB8s9LT7leuNAa5Bo1GdQ14Nsm9IsxIti0ZxTKAn8uYxhPfk/UkgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623108;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hxM5jeCwvAkObKl/KBLPzUixqAjduQ7IjQq2yexihAI=;
	b=kWY58VgWzb3mvQuI/+hcRaG55n/mqtfS3ulBrjKpUNka7PKODy4sZKew2sgdHQPFJ0M6
	 mEhQ/YTw1E4GNDOw9cFnwkZpgp3CXcsxPAUD/s8c2Eb4dQw6SzaPr+jg+qwgInw/bc67x
	 iVvwjUy6wEnTA+DC5QBD25m1wAQT55YIEfzSuV4MC6MlAwaVyY46PZb8i62qfYVWLN4Xo
	 55CeSaeD0pJwbcuqcibmyVX01QkG22xAcj1k4JygGroZY2OLRZl6A1ZvT5iMeGnQ6zSny
	 +ch0+FHtBvPyTCZ6Ny3d0R2UjW2ML5ubs2FYf/VJv7StnnFw3wmz7NFxKBfHDIVl2rA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="2M9KZ/Nh";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3E1606A31E;
	Wed, 25 Nov 2026 16:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2M9KZ/Nh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E99E1F000C0;
	Wed, 25 Nov 2026 16:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623107;
	bh=hxM5jeCwvAkObKl/KBLPzUixqAjduQ7IjQq2yexihAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2M9KZ/NhZ/yYpbqjCxVNA54AbeYv0JA6KewhFirLyITq9Ifd1nU6MN14c4hjgtiMN
	 WhqzIoqG3hfNOi60WAszYF214ms+uHTGMxrs59ZJ2gYPxQZBUGpQTcoPSmZMxXWIdm
	 z9wu0CN3Y7nMKnd8/vanT2/4hHNYwi5n8SIJJ7UU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.18 754/990] cpufreq: acpi-cpufreq: fix P-state index mismatch in extract_io()
Date: Wed, 25 Nov 2026 15:35:21 +0100
Message-ID: <20261125143839.719741590@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

commit 6bc092a0fc4d331a4adbbb664078af149c580834 upstream.

When policy->freq_table is built in acpi_cpufreq_cpu_init(), entries
that are not lower in frequency than the previous one are skipped.
For each remaining entry, freq_table[].driver_data stores the
original ACPI P-state index, so the index space of freq_table no
longer matches perf->states[].

extract_io() currently walks perf->states[] with index i and uses the
same i to index policy->freq_table[i]. When duplicate frequencies
exist, this can associate a P-state status with the frequency of a
different P-state. It can also access an invalid or sentinel entry in
freq_table when the number of entries in perf->states[] is greater than
the number of entries remaining in the frequency table.

extract_io() is used on ACPI_ADR_SPACE_SYSTEM_IO platforms by the
frequency verification path, which is enabled by the
acpi_pstate_strict module parameter. With the mismatched lookup,
check_freqs() can fail to match the frequency of the P-state that
drv_write() has already programmed. It then sleeps through all 100
iterations - at least ~1 ms of usleep_range() plus 100 cross-CPU
calls and I/O port reads, all with policy->rwsem held, and
.target_index() returns -EAGAIN, leaving perf->state at its previous
value while the hardware is running at the newly requested P-state.

The cpufreq core consequently keeps policy->cur at the old frequency.
Since __cpufreq_driver_target() returns early when the requested
frequency equals policy->cur, the driver is not called again for that
frequency and the control register is not rewritten. The hardware can
therefore remain at a frequency that differs from the frequency known
to the cpufreq core.

Fix this by iterating over policy->freq_table and using
pos->driver_data as the original ACPI P-state index when accessing
perf->states[], as extract_msr() already does.

Fixes: fe27cb358835 ("[CPUFREQ][2/8] acpi: reorganize code to make MSR support addition easier")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Cc: All applicable <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260910111329.2220-2-lirongqing@baidu.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/acpi-cpufreq.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -197,14 +197,13 @@ static unsigned extract_io(struct cpufre
 {
 	struct acpi_cpufreq_data *data = policy->driver_data;
 	struct acpi_processor_performance *perf;
-	int i;
+	struct cpufreq_frequency_table *pos;
 
 	perf = to_perf_data(data);
 
-	for (i = 0; i < perf->state_count; i++) {
-		if (value == perf->states[i].status)
-			return policy->freq_table[i].frequency;
-	}
+	cpufreq_for_each_entry(pos, policy->freq_table)
+		if (value == perf->states[pos->driver_data].status)
+			return pos->frequency;
 	return 0;
 }
 


