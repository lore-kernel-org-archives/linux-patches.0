Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021925;
	b=N8kCQHeVYDzxQlXkVT5ILw8VbtaqDSMogMCzDGrA4YCEbhdXjUy4DbcomcnBuZtNQx65
	 oc+cmBAFvD3FeRtNGTtzclZWevo6NEMximkBiml+I2m7LVbCw74/vTUjvoOpEOANuTDiJ
	 4zexJ64Z3bY2x52f8IlTzmccNqmlCQFFVO2xqojukxclhOXWyd5lu8XjJWeBPBNpauTau
	 Eh7HW8IHOxY0kRvbT0VV+pNqWzvPwHJCdIFxwd1eaqhU6gWhzJx9OiZNWYobg0kQ21ioG
	 x4/b5GUz9mVb0A0XKemR4W/7nTMcatOlDOPgr2aAk3fdgwFim0tBRFNF0TUQeWkwFeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021925;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kLcvFweSewxv+Wj3f7MQEoh9QMzbChXPp1uLfw6c6Ss=;
	b=RoZgezqW63nHz0ZVRaQV3UZhmaeggz1/wO2MZdwPDEzRyaJzFOqo978cA1+SbFUdvhg0
	 aG7btE+BI4KROPFs2yZ/WXl2HKFOi2AT62xP4zkGtftFoY65ucllTYQqpLqfwXkeN+yYX
	 Y96+fbKOVTyno3aEKke+aaGVnEjIr4j8NXd4x1qV/qEp0wvzqAF8TB4dUpkaBCgTwJosX
	 U4OCANwXT+XpixbUWTR6MsCLGDFFDctvDOQwXber1n5znfiYmJLChAm3sgoD/LYcBd5q9
	 ygNNDoCyETQEqkZrTGFzwfmuPOUNC54bbr/j1FJ/F+vETwiOQP3BG3+NP/pbF9FN1Dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x5YjJ8vH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3554B606A31C;
	Wed, 18 Nov 2026 17:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x5YjJ8vH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D151F000C4;
	Wed, 18 Nov 2026 17:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021925;
	bh=kLcvFweSewxv+Wj3f7MQEoh9QMzbChXPp1uLfw6c6Ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x5YjJ8vHDMZNit8kT9xeusyBtZwjTtlgVlLrQ1IOwYR4CtiqWwmrMSjyZGCng64XM
	 Zh02XyJ78uxGulC1y2dbFd+kqlxFdyiyjABUNfsyjppGhe3rqd9ulki9LFVVqPtU6f
	 t8fCVEAsgrcruMl0Xt8uR/FGMoTAWG29wlGgJDqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2479/2651] x86_energy_perf_policy: Cleanup: Check fseek() in VM path
Date: Wed, 18 Nov 2026 16:01:59 +0100
Message-ID: <20261118150414.180480164@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Len Brown <len.brown@intel.com>

[ Upstream commit 2778dc35d40e7e84c134ca4cab1376fa58208f80 ]

Add return value validation for fseek() and ensure consistent
resource cleanup on all error paths in err_on_hypervisor().

Fixes: 0936cdfbb527 ("tools/power x86_energy_perf_policy: Input/output error in a VM")
Assisted-by: GitHub-Copilot:Claude-Sonnet-4.6
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../x86/x86_energy_perf_policy/x86_energy_perf_policy.c     | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
index 1fbe6af508d0f..f45ca6e209fe4 100644
--- a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
+++ b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
@@ -783,7 +783,11 @@ void err_on_hypervisor(void)
 		err(1, "Failed to find 'flags' in /proc/cpuinfo");
 	}
 	rewind(cpuinfo);
-	fseek(cpuinfo, flags - buffer, SEEK_SET);
+	if (fseek(cpuinfo, flags - buffer, SEEK_SET) != 0) {
+		fclose(cpuinfo);
+		free(buffer);
+		err(1, "Failed to seek in /proc/cpuinfo");
+	}
 	if (!fgets(buffer, 4096, cpuinfo)) {
 		fclose(cpuinfo);
 		free(buffer);
-- 
2.53.0



