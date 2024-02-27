Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31CE13B2B4;
	Tue, 27 Feb 2024 14:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042892; cv=none; b=hiQ8kL/tZ/sbpBV/AUOx8uMYLpHPBTquT0yFZXnBkAYf+uHCnsJnz4Zh0uVOsOKUJRM/9hD0nL5plYd/IBcpTZzG2jHpEKlP4JhX9QJE9emh+4IVl3+A3jFenfBOY0kM6+GgkBM3knNQVU+KlDJoV8T9QIeZa4PSRSq2TCTCAcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042892; c=relaxed/simple;
	bh=kpq1Lbvo/+aVzqE2n/SjCimvTOxXGIpm2Rv9sohNL00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2JSdRrl1B8QanD2feXRU+17oP4tIRrBCHBhUZfrq2ulUato+/hErowCwuGO+9FwMZVsDXjNJhw7J3gdj0UMXohMNtAnz5Yna7hTc8uxU30T/FlfbBeZkcgIl3yLJ93pLz7niVxEke/3ibu/eBqFtJH4biRK9cw+SIGJFvKzE/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TF14na1j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TF14na1j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D9FC433F1;
	Tue, 27 Feb 2024 14:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042892;
	bh=kpq1Lbvo/+aVzqE2n/SjCimvTOxXGIpm2Rv9sohNL00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TF14na1ji4r3pVWRYslqBoHPsZi41MT0AvTuczSiTDFYSYFMpWdqrA0/r5xlq/Uzq
	 FBslp/dimd95MbvF29tXoQsMwizKA/L1JZuHhDYk7D2XjHmb6BeejDPpkFTn7k+qR7
	 IMNeRIMFk/OLj5EdCBF6d/ek65HGH60dDRCMwfxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Lynch <nathanl@linux.ibm.com>,
	Laurent Dufour <laurent.dufour@fr.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 151/245] powerpc/rtas: make all exports GPL
Date: Tue, 27 Feb 2024 14:25:39 +0100
Message-ID: <20240227131620.120414000@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit 9bce6243848dfd0ff7c2be6e8d82ab9b1e6c7858 ]

The first symbol exports of RTAS functions and data came with the (now
removed) scanlog driver in 2003:

https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git/commit/?id=f92e361842d5251e50562b09664082dcbd0548bb

At the time this was applied, EXPORT_SYMBOL_GPL() was very new, and
the exports of rtas_call() etc have remained non-GPL. As new APIs have
been added to the RTAS subsystem, their symbol exports have followed
the convention set by existing code.

However, the historical evidence is that RTAS function exports have been
added over time only to satisfy the needs of in-kernel users, and these
clients must have fairly intimate knowledge of how the APIs work to use
them safely. No out of tree users are known, and future ones seem
unlikely.

Arguably the default for RTAS symbols should have become
EXPORT_SYMBOL_GPL once it was available. Let's make it so now, and
exceptions can be evaluated as needed.

Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Reviewed-by: Laurent Dufour <laurent.dufour@fr.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20230124140448.45938-3-nathanl@linux.ibm.com
Stable-dep-of: 836b5b9fcc8e ("powerpc/rtas: ensure 4KB alignment for rtas_data_buf")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/rtas.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index a4cd2484dbca2..4da9baa0fbe8c 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -68,10 +68,10 @@ struct rtas_t rtas = {
 EXPORT_SYMBOL(rtas);
 
 DEFINE_SPINLOCK(rtas_data_buf_lock);
-EXPORT_SYMBOL(rtas_data_buf_lock);
+EXPORT_SYMBOL_GPL(rtas_data_buf_lock);
 
 char rtas_data_buf[RTAS_DATA_BUF_SIZE] __cacheline_aligned;
-EXPORT_SYMBOL(rtas_data_buf);
+EXPORT_SYMBOL_GPL(rtas_data_buf);
 
 unsigned long rtas_rmo_buf;
 
@@ -80,7 +80,7 @@ unsigned long rtas_rmo_buf;
  * This is done like this so rtas_flash can be a module.
  */
 void (*rtas_flash_term_hook)(int);
-EXPORT_SYMBOL(rtas_flash_term_hook);
+EXPORT_SYMBOL_GPL(rtas_flash_term_hook);
 
 /* RTAS use home made raw locking instead of spin_lock_irqsave
  * because those can be called from within really nasty contexts
@@ -328,7 +328,7 @@ void rtas_progress(char *s, unsigned short hex)
  
 	spin_unlock(&progress_lock);
 }
-EXPORT_SYMBOL(rtas_progress);		/* needed by rtas_flash module */
+EXPORT_SYMBOL_GPL(rtas_progress);		/* needed by rtas_flash module */
 
 int rtas_token(const char *service)
 {
@@ -338,7 +338,7 @@ int rtas_token(const char *service)
 	tokp = of_get_property(rtas.dev, service, NULL);
 	return tokp ? be32_to_cpu(*tokp) : RTAS_UNKNOWN_SERVICE;
 }
-EXPORT_SYMBOL(rtas_token);
+EXPORT_SYMBOL_GPL(rtas_token);
 
 int rtas_service_present(const char *service)
 {
@@ -498,7 +498,7 @@ int rtas_call(int token, int nargs, int nret, int *outputs, ...)
 	}
 	return ret;
 }
-EXPORT_SYMBOL(rtas_call);
+EXPORT_SYMBOL_GPL(rtas_call);
 
 /* For RTAS_BUSY (-2), delay for 1 millisecond.  For an extended busy status
  * code of 990n, perform the hinted delay of 10^n (last digit) milliseconds.
@@ -533,7 +533,7 @@ unsigned int rtas_busy_delay(int status)
 
 	return ms;
 }
-EXPORT_SYMBOL(rtas_busy_delay);
+EXPORT_SYMBOL_GPL(rtas_busy_delay);
 
 static int rtas_error_rc(int rtas_rc)
 {
@@ -579,7 +579,7 @@ int rtas_get_power_level(int powerdomain, int *level)
 		return rtas_error_rc(rc);
 	return rc;
 }
-EXPORT_SYMBOL(rtas_get_power_level);
+EXPORT_SYMBOL_GPL(rtas_get_power_level);
 
 int rtas_set_power_level(int powerdomain, int level, int *setlevel)
 {
@@ -597,7 +597,7 @@ int rtas_set_power_level(int powerdomain, int level, int *setlevel)
 		return rtas_error_rc(rc);
 	return rc;
 }
-EXPORT_SYMBOL(rtas_set_power_level);
+EXPORT_SYMBOL_GPL(rtas_set_power_level);
 
 int rtas_get_sensor(int sensor, int index, int *state)
 {
@@ -615,7 +615,7 @@ int rtas_get_sensor(int sensor, int index, int *state)
 		return rtas_error_rc(rc);
 	return rc;
 }
-EXPORT_SYMBOL(rtas_get_sensor);
+EXPORT_SYMBOL_GPL(rtas_get_sensor);
 
 int rtas_get_sensor_fast(int sensor, int index, int *state)
 {
@@ -676,7 +676,7 @@ int rtas_set_indicator(int indicator, int index, int new_value)
 		return rtas_error_rc(rc);
 	return rc;
 }
-EXPORT_SYMBOL(rtas_set_indicator);
+EXPORT_SYMBOL_GPL(rtas_set_indicator);
 
 /*
  * Ignoring RTAS extended delay
-- 
2.43.0



