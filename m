Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029117;
	b=HLi1PwJ7p0dWawYZgMv7NsyW7zUElYoa4xqIfOQmakzouX9yYTm7ZlR87sx+F7qQduSN
	 j8J0P6yO2DCmNsvAHlGU5+/MHoJVQB81lP36omTSQq59pvaEtMl2qT6t+01A2RVYdY7Gn
	 GWon8KCx34IFBf+ktTCgkaV6a6xgsZt5GdP6IB2kTxIY/XYkrPzVlCum5apikKS1EZiMA
	 c+x0wXkVOwaxh7bfJ0hBMRlomtnMUSYMDZYm6VA0ijX2BiyC7csKdX9D3j78yWogftkCy
	 Npc9sXx0/xUArZGP5Y13772lX9mFPiIl1K2+VYdl/Cmhxe8v3pVArU7P/FGaTmXJ3kQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029117;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ONeDDHoczyICk2H2G+ntG6ZTLZ0GdMQhWp/EbL5vvYM=;
	b=oZkPKwimoKd3cIHCnREMaPVWLtu78ga8ivEdvq2qixndlPNM+KDDGoucfrUn8oV1vpTg
	 TF7/WDoazKW9FGSmjyS4NVwcutbLEYm3QWsF7eJxMLLH6ed9TlrDQeN32QXben3W92JxD
	 PisC7HotcvI+yN4f3jaG2LYvNcFcEELlz5t4lzuGsJGbC8UHOvSP0AtsRsE2PR5HctB5l
	 HcQBnRF5acyEMn5MGCnnQxMwNKvT0nGvJXGIPBtJG8DMSU1Zm5C1onSXgh6m348Sq89os
	 LNhbcAGbVn+5COfxdg9xqmH4e6/D/fvcsqFL5rP4YJ9mQBM24/y/rgRtf9sSwnJAfpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="a/DjS4tP";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C40606A31C;
	Wed, 18 Nov 2026 19:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a/DjS4tP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1685F1F000C4;
	Wed, 18 Nov 2026 19:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029117;
	bh=ONeDDHoczyICk2H2G+ntG6ZTLZ0GdMQhWp/EbL5vvYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a/DjS4tPW4q3o1q4tR4v1BLHFRNA/H7QOQYXDM/B0YOe9Ru1pS7saZhnYc1zuqp45
	 MI8gMvfzEAbjFwgDyz/+uJXdD2KYEnBwPGY8KFKOopA06MxYCd9zJdoLTIkfGpdG9q
	 9bZ6aW57F/1GgjwUq+UKddEYdMwWOrYzGNZoa+3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykyta Yatsenko <mykyta.yatsenko5@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0236/1756] selftests/bpf: More precise cpu_mitigations state detection
Date: Wed, 18 Nov 2026 15:39:23 +0100
Message-ID: <20261118150017.655806072@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit fc2915bb8bfcfdc6e5ea2cfc8d13fbaefe77c2c8 ]

test_progs and test_verifier binaries execute unpriv tests under the
following conditions:
- unpriv BPF is enabled;
- CPU mitigations are enabled (see [1] for details).

The detection of the "mitigations enabled" state is performed by
unpriv_helpers.c:get_mitigations_off() via inspecting kernel boot
command line, looking for a parameter "mitigations=off".

Such detection scheme won't work for certain configurations,
e.g. when CONFIG_CPU_MITIGATIONS is disabled and boot parameter is
not supplied.

Miss-detection leads to test_progs executing tests meant to be run
only with mitigations enabled, e.g.
verifier_and.c:known_subreg_with_unknown_reg(), and reporting false
failures.

Internally, verifier sets bpf_verifier_env->bypass_spec_{v1,v4}
basing on the value returned by kernel/cpu.c:cpu_mitigations_off().
This function is backed by a variable kernel/cpu.c:cpu_mitigations.

This state is not fully introspect-able via sysfs. The closest proxy
is /sys/devices/system/cpu/vulnerabilities/spectre_v1, but it reports
"vulnerable" state only if mitigations are disabled *and* current cpu
is vulnerable, while verifier does not check cpu state.

There are only two ways the kernel/cpu.c:cpu_mitigations can be set:
- via boot parameter;
- via CONFIG_CPU_MITIGATIONS option.

This commit updates unpriv_helpers.c:get_mitigations_off() to scan
/boot/config-$(uname -r) and /proc/config.gz for
CONFIG_CPU_MITIGATIONS value in addition to boot command line check.

Tested using the following configurations:
- mitigations enabled (unpriv tests are enabled)
- mitigations disabled via boot cmdline (unpriv tests skipped)
- mitigations disabled via CONFIG_CPU_MITIGATIONS
  (unpriv tests skipped)

[1] https://lore.kernel.org/bpf/20231025031144.5508-1-laoar.shao@gmail.com/

Reported-by: Mykyta Yatsenko <mykyta.yatsenko5@gmail.com>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250617005710.1066165-2-eddyz87@gmail.com
Stable-dep-of: 040ef1f8b02e ("selftests/bpf: make cmdline_contains stricter")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/unpriv_helpers.c | 93 +++++++++++++++++++-
 1 file changed, 90 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/unpriv_helpers.c b/tools/testing/selftests/bpf/unpriv_helpers.c
index 220f6a9638134..3aa9ee80a55e4 100644
--- a/tools/testing/selftests/bpf/unpriv_helpers.c
+++ b/tools/testing/selftests/bpf/unpriv_helpers.c
@@ -1,15 +1,75 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
+#include <errno.h>
 #include <stdbool.h>
 #include <stdlib.h>
 #include <stdio.h>
 #include <string.h>
+#include <sys/utsname.h>
 #include <unistd.h>
 #include <fcntl.h>
+#include <zlib.h>
 
 #include "unpriv_helpers.h"
 
-static bool get_mitigations_off(void)
+static gzFile open_config(void)
+{
+	struct utsname uts;
+	char buf[PATH_MAX];
+	gzFile config;
+
+	if (uname(&uts)) {
+		perror("uname");
+		goto config_gz;
+	}
+
+	snprintf(buf, sizeof(buf), "/boot/config-%s", uts.release);
+	config = gzopen(buf, "rb");
+	if (config)
+		return config;
+	fprintf(stderr, "gzopen %s: %s\n", buf, strerror(errno));
+
+config_gz:
+	config = gzopen("/proc/config.gz", "rb");
+	if (!config)
+		perror("gzopen /proc/config.gz");
+	return config;
+}
+
+static int config_contains(const char *pat)
+{
+	const char *msg;
+	char buf[1024];
+	gzFile config;
+	int n, err;
+
+	config = open_config();
+	if (!config)
+		return -1;
+
+	for (;;) {
+		if (!gzgets(config, buf, sizeof(buf))) {
+			msg = gzerror(config, &err);
+			if (err == Z_ERRNO)
+				perror("gzgets /proc/config.gz");
+			else if (err != Z_OK)
+				fprintf(stderr, "gzgets /proc/config.gz: %s", msg);
+			gzclose(config);
+			return -1;
+		}
+		n = strlen(buf);
+		if (buf[n - 1] == '\n')
+			buf[n - 1] = 0;
+		if (strcmp(buf, pat) == 0) {
+			gzclose(config);
+			return 1;
+		}
+	}
+	gzclose(config);
+	return 0;
+}
+
+static bool cmdline_contains(const char *pat)
 {
 	char cmdline[4096], *c;
 	int fd, ret = false;
@@ -27,7 +87,7 @@ static bool get_mitigations_off(void)
 
 	cmdline[sizeof(cmdline) - 1] = '\0';
 	for (c = strtok(cmdline, " \n"); c; c = strtok(NULL, " \n")) {
-		if (strncmp(c, "mitigations=off", strlen(c)))
+		if (strncmp(c, pat, strlen(c)))
 			continue;
 		ret = true;
 		break;
@@ -37,8 +97,21 @@ static bool get_mitigations_off(void)
 	return ret;
 }
 
+static int get_mitigations_off(void)
+{
+	int enabled_in_config;
+
+	if (cmdline_contains("mitigations=off"))
+		return 1;
+	enabled_in_config = config_contains("CONFIG_CPU_MITIGATIONS=y");
+	if (enabled_in_config < 0)
+		return -1;
+	return !enabled_in_config;
+}
+
 bool get_unpriv_disabled(void)
 {
+	int mitigations_off;
 	bool disabled;
 	char buf[2];
 	FILE *fd;
@@ -52,5 +125,19 @@ bool get_unpriv_disabled(void)
 		disabled = true;
 	}
 
-	return disabled ? true : get_mitigations_off();
+	if (disabled)
+		return true;
+
+	/*
+	 * Some unpriv tests rely on spectre mitigations being on.
+	 * If mitigations are off or status can't be determined
+	 * assume that unpriv tests are disabled.
+	 */
+	mitigations_off = get_mitigations_off();
+	if (mitigations_off < 0) {
+		fprintf(stderr,
+			"Can't determine if mitigations are enabled, disabling unpriv tests.");
+		return true;
+	}
+	return mitigations_off;
 }
-- 
2.53.0



