Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1DB1F5F6;
	Tue, 11 Nov 2025 01:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823019; cv=none; b=myC+i0hx3kJ+2eCyftVSZo9kxkwtppAGKVTNQGaeAa2JroSW+UaSOEm3QhJy50IiEgi38OmhsD2rJyfrdvF5WVy17VIJF3nPfy68vT4NKUbR1ziln6929vqlC64KY+QTrZtZWIiKm3NfwmFY2KnefbJz4hu2oMJ85sGL6SKHtoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823019; c=relaxed/simple;
	bh=nY2nb1pi/dkBklhB/8noKOnYd2TvBFmE5W4wLrVx4hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l7jZU6ZCzXDs0GvT3X5p2FUx3DPLtJtYJNPcyq+/s8Og3jbihOWTge2uvIADcDpa6J7KcQGawDZk7ubMUULlKJnID7AjRQ5raHFFd8n1cl99FpKsqU/i8mzzRndb4s/+JhZldYwEoGVElfwGfn+59yC1QuP0uogAijgQrWUWZfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ebUIahlX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ebUIahlX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E9C3C4CEFB;
	Tue, 11 Nov 2025 01:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823018;
	bh=nY2nb1pi/dkBklhB/8noKOnYd2TvBFmE5W4wLrVx4hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ebUIahlXmDiZ7pGVEGGK9hondiVh6Mn9Ngfi7HlGex5e6sTOSaEh419kr/l9a/kQw
	 9K4nqkxDQ0zkQr1azPmYPc8iig0IJcjCmhtGtJPPRZSNVrP2YdDVsu+IaIenWE4CfC
	 4je2RgI0tDprL+/jOY53LiGYoeQORW67fT95yCQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 215/849] tools/power x86_energy_perf_policy: Fix incorrect fopen mode usage
Date: Tue, 11 Nov 2025 09:36:25 +0900
Message-ID: <20251111004541.638475147@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>

[ Upstream commit 62127655b7ab7b8c2997041aca48a81bf5c6da0c ]

The fopen_or_die() function was previously hardcoded
to open files in read-only mode ("r"), ignoring the
mode parameter passed to it. This patch corrects
fopen_or_die() to use the provided mode argument,
allowing for flexible file access as intended.

Additionally, the call to fopen_or_die() in
err_on_hypervisor() incorrectly used the mode
"ro", which is not a valid fopen mode. This is
fixed to use the correct "r" mode.

Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
index ebda9c366b2ba..c883f211dbcc9 100644
--- a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
+++ b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
@@ -630,7 +630,7 @@ void cmdline(int argc, char **argv)
  */
 FILE *fopen_or_die(const char *path, const char *mode)
 {
-	FILE *filep = fopen(path, "r");
+	FILE *filep = fopen(path, mode);
 
 	if (!filep)
 		err(1, "%s: open failed", path);
@@ -644,7 +644,7 @@ void err_on_hypervisor(void)
 	char *buffer;
 
 	/* On VMs /proc/cpuinfo contains a "flags" entry for hypervisor */
-	cpuinfo = fopen_or_die("/proc/cpuinfo", "ro");
+	cpuinfo = fopen_or_die("/proc/cpuinfo", "r");
 
 	buffer = malloc(4096);
 	if (!buffer) {
-- 
2.51.0



