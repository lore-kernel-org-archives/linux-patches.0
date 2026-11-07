Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065389;
	b=l8E+W89raWQu5JnqvJG7o5W5pfgw3epU1CMhmj754j4YIIYsXgJVQGad1g+KIXHkRTXO
	 S2FgHuGznWZE6W1mjJM/BIm9FNp6PpeMkN3u8TjvfpKgY0Kq5RVSbM6m7Tf1eMzETRCtr
	 ju6DYxMo7wKJ5wgqHKTMNRlttlUoHcEUny/wEIgoxO58criidL69a+NDoF1wIVVfxsL3Z
	 ixDvykA9TNqyA8xawCrFPfhI3/0nfvGLnispS9hqNnfcV+CGfsU/p1nzpLsPsRy7o5MAd
	 YUPuAyXUY32BRF7zeFWy+no0Xn3CPplfH+pKHRvQiobVvbhghXrIr5X+KPsm9yezFxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065389;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lfAhEuHJ1IMjd+UzucCqJR4VKSgjL1J54SDpeKm75VA=;
	b=UnA0HCCvbWIlJEdN8vfdmmkQwno4rVYI7l37JyCNGYCQh3+fg0Gz1TUb1W+uKtWOzJZq
	 oTu33nr4ZEPnW6GV5dnzD4OJKVkPv1kkOHvR2lWUR7amUEZgYAtFGZveygf6y2ms/VNfd
	 /iioIrFATpV2vQA+lffIJ5M8jA1bG6g+TOBNMVLet02PcPJAZB9jaJdEkh7AWaY0MeFhw
	 cWorzKlXCoaFnl61bi/5inMH2ltcJCi8qE2j8l1BVAmb0xmSvPhdgYRVXurgOHm4R1pX+
	 KERWS04CIPYQSa1cNuH5tt3GOZoLaVKZhL6i+zzHVmgdwA+uPN4Z5iJ/mfaOZU7zEfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YbCnWlGS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC23A606A32C;
	Sat,  7 Nov 2026 15:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YbCnWlGS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D0B1F0089F;
	Sat,  7 Nov 2026 15:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065388;
	bh=lfAhEuHJ1IMjd+UzucCqJR4VKSgjL1J54SDpeKm75VA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YbCnWlGSo6OD7kSvpRsR5ZgDfSXTqk1UCPOax4o9VlRy/6CNEzrvkcyGaWbzaFWeA
	 ub79F0kGcV2/3V64gf7B7VTJL2YxF/whHCZokeOTVOmAEBPyL6PnotyqIkqK6xX3a9
	 9kSBWaqEvP8qYiTZ6SST5iDazshxHGNdWw2GImmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1112/1257] tracing/remotes: Fix TRACE_REMOTE build when TRACING=n
Date: Sat,  7 Nov 2026 08:56:48 -0500
Message-ID: <20261107135009.957817354@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Vincent Donnefort <vdonnefort@google.com>

[ Upstream commit 3bb853ad84244f0b86ab12f029bc4a0c9c7100e8 ]

TRACE_REMOTE relies on tracefs, eventfs and ring-buffer which are only
built and declared when TRACING is enabled. It is however possible for a
config to have FTRACE=y TRACING=n and TRACE_REMOTE=y.

To fix this configuration, have TRACE_REMOTE select TRACING directly,
just like other FTRACE options do and drop the TRACING dependency from
NVHE_EL2_TRACING to avoid a circular Kconfig dependency.

Cc: stable@vger.kernel.org
Fixes: ea908a2b79c8 ("tracing: Add a trace remote module for testing")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202610142301.GBepPVmS-lkp@intel.com/
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Link: https://patch.msgid.link/20261015112814.332084-1-vdonnefort@google.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/Kconfig | 2 +-
 kernel/trace/Kconfig   | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 449154f9a4852..e179b8ad79e81 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -74,7 +74,7 @@ if NVHE_EL2_DEBUG
 
 config NVHE_EL2_TRACING
 	bool
-	depends on TRACING && FTRACE
+	depends on FTRACE
 	select TRACE_REMOTE
 	default y
 
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 0ab5916575a97..6587450cfcd14 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -1329,6 +1329,7 @@ source "kernel/trace/rv/Kconfig"
 
 config TRACE_REMOTE
 	bool
+	select TRACING
 
 config SIMPLE_RING_BUFFER
 	bool
-- 
2.53.0



