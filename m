Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCFAD313E1E;
	Wed,  3 Dec 2025 15:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776176; cv=none; b=UVNjdKeeWG+eDuMZ1ScTT7ZIJ+GyzmXjqPfXab8oB1dUS+wtuPZyavb6tNskvKPLVKDQHjHwzUILefH+Y6aHRf3FcdjrAkQn/dXHnjOedPmqDIb9TNP5lw0/Z93l9ttog8wxiOfk5Sgmxvea3k1Z87OK9TFaPkfwnrn1tnunces=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776176; c=relaxed/simple;
	bh=Pc2HE2sTKb8JuLHtMAZ2OnnBlz/dNYKQlunuUd9bqUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uNJ6O9Wshnzf2opznTaJD02xjx0uIULYDaWsBE9ABejquTe7kFqBElovdx9JiFLGVbYlWlYAHWZveyZpnKCBgvVwV2afhg86jrBLnpNfdykY0t/ORnjReHG8km8f1p4Bd02D2zLs1INSOtMcEGWN1VEPTrBd2h10F17x3WKwagI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oROt8LTI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oROt8LTI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 325A1C4CEF5;
	Wed,  3 Dec 2025 15:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776176;
	bh=Pc2HE2sTKb8JuLHtMAZ2OnnBlz/dNYKQlunuUd9bqUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oROt8LTIl1mNauMlmQRKzHi9FShhppTZ/AmHM/EEQRyxXq3Q7wyGljwXBJxfpEVFe
	 3CKXrs2zUgWOhXTiMUUrKr7XGClnp+8QtT2ftZ1NeBqsWC89GVZCFnC42g85q6UrP4
	 icT7QWzpAGMCKoUxGtE8xBjeFEo8S2yRqtoMxrjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 061/300] tools/power x86_energy_perf_policy: Fix incorrect fopen mode usage
Date: Wed,  3 Dec 2025 16:24:25 +0100
Message-ID: <20251203152402.880928179@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1c80aa498d543..60917e32ec853 100644
--- a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
+++ b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
@@ -627,7 +627,7 @@ void cmdline(int argc, char **argv)
  */
 FILE *fopen_or_die(const char *path, const char *mode)
 {
-	FILE *filep = fopen(path, "r");
+	FILE *filep = fopen(path, mode);
 
 	if (!filep)
 		err(1, "%s: open failed", path);
@@ -641,7 +641,7 @@ void err_on_hypervisor(void)
 	char *buffer;
 
 	/* On VMs /proc/cpuinfo contains a "flags" entry for hypervisor */
-	cpuinfo = fopen_or_die("/proc/cpuinfo", "ro");
+	cpuinfo = fopen_or_die("/proc/cpuinfo", "r");
 
 	buffer = malloc(4096);
 	if (!buffer) {
-- 
2.51.0



