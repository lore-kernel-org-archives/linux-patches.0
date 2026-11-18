Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042657;
	b=LCxMjyibxd2JHzSV1NxHYZ+Kw+58Gwhv8RvT3pD2MzzeVklniA1+ZiMLi85Lbhr3JanX
	 KaAHjkDXVCuaW/rWznsldXTe6d4OlwTokG8eoyaYeCEjjLHvdK2VYlfdtdj8OU2+RGul6
	 Cv9mKepG1DpStW6m4c7JMeLA//OUZ30z3iClQ0gL58WSDYbfF1AHABO6B8eKUeQxgiHi7
	 LhNUMmsNsCeqQLguLnDJLdKBtA7L/xRw7JspARKuv13u8WV+OhhPk/+I78I0laZI5sXbq
	 p0Zuq+IH8/Ce1l+bO+dM/8z6MXcLdzbKmO7w8fuu6KAFB4qgCGQDWp7nwynD9EyyquA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042657;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cd2e6VJEyqLMU0RUn1Ws41IZXwnf5kvLqdPptqLlIVQ=;
	b=J0Bi2Xv3FLHlCjVcDgVj0ptsBs1LAHTdU0Ravm/+eQcY5OPDSHyH3F3EZP8nFPIn2Mj6
	 1Pqj77AHNLn1N4J5T337Ru1yC9VklqoGeqh5TtZny3nhxyZUrqsD5FiO8Xapcs96AguRb
	 0HuBCBsjf65rn1WL8KGYITyWzerL0Y4tNk+hsMUJ4oajUSG+ZhrK5dnxxyU2Zln0JpxjC
	 yed9KKWfbvqs+k8RprjJ8ck8X/5dsE0ntKH/x/fdCo6KQUNKm0kdMfbziznvoVbjtppZT
	 2dzpI+5PO0yxeZJKrFkG3eLSnnNXU61ZjhRz8qvNsKaHxdmp8KHYrckKPkw5qDlDUJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RuoPWRg9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CD6606A31C;
	Wed, 18 Nov 2026 22:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RuoPWRg9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2694F1F000C4;
	Wed, 18 Nov 2026 22:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042657;
	bh=Cd2e6VJEyqLMU0RUn1Ws41IZXwnf5kvLqdPptqLlIVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RuoPWRg9Lu6E+oonB0VJyHg3jyog2XbsARTfwdWPqe3XgM+l7Rwkm1y7tdxvUu9Tf
	 WDndD9uDiwtXo4c7LBqPTydNtwMTLpm4KUpiiBaixtidRqV/pdlgNEJ4l49FH4312W
	 UJQsz1RDpz8GGebcRSYFkPhnR44lTvwhBLaDkmIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3198/3318] x86_energy_perf_policy: Cleanup: Check fseek() in VM path
Date: Wed, 18 Nov 2026 16:03:40 +0100
Message-ID: <20261118150455.708607200@linuxfoundation.org>
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
index 2545f64d5f43b..f26c6dd0d6c14 100644
--- a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
+++ b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
@@ -661,7 +661,11 @@ void err_on_hypervisor(void)
 
 	flags = strstr(buffer, "flags");
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



