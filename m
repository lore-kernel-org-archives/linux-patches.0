Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040675;
	b=BlZH73gV4TgFEWiz7ew37j9HoIo6oa5/230V9CsFeNVIwk/5XKRAPxcuY2obOorIwezZ
	 oyX5vpWA80NkJTEDjAFcYC+W0jhp6qAh4ysvqkQzwreqqB6FZxX4+rU+MkvrVvuddGAc+
	 59QqOrqo5jncXDXZ+F2X0IuWrBHzqECoD4dmfLNZfE91rkGjRDxnroT21O8bkBQhA5Uqi
	 psNfUA1QrTgCEIR1+AdnOnkQGejMhpqa2nUEJqKYJn+yr1A/M8vTidu01Azsdw1moK+pT
	 AP+oF1KZoIZelisePaHuKo3Sac4T/9869gqMfJ0KvR7yp+ZrEEXGccPYU7PdlNtWdqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040675;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7V5W0cW7cpMPwvcaBJpB9VLyYfVGNtzGpksOgEwHjxI=;
	b=FadyumicUaJgmEG01T7FsIBRPNSP6AePGL56P0Ri/nqO0L7k2tFX2we6XeJgjJcfkSpv
	 LocyeYEfVlpWrywaEgGMEhzU5QonDRovDPvzZyaQ8uqkRv1cVeEYp4boW6vb0tA+6MYv3
	 beiCuZ+9d8o1I2VsKRXu6GO22m2VN9Lnz3B6ZVLvptHLf6cWKpI6YTSCgawk0R9RG5oZR
	 hcinN+KadFLeYvH/6v6aiQlV8clkzCWBHY8bccHt/Ei0dxCQZV19OzhkFJBh04EQHjTsr
	 oXWFE3jtafuvZk17HswrCyrMBTuF8TF7Y53O1LS4UzJU8P90bBbYWW/p5V647NpD+LQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mDWW0LkR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13572606A32C;
	Wed, 18 Nov 2026 22:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mDWW0LkR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E011F000C4;
	Wed, 18 Nov 2026 22:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040674;
	bh=7V5W0cW7cpMPwvcaBJpB9VLyYfVGNtzGpksOgEwHjxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mDWW0LkRmcB/SPRG1b8ZI4npVO79WOgv0/8Nplibzz/V+s2zPZWt5RN/iY8OODwo2
	 0hhbV8h+X3n8vJLNIisB8qASgQnwqkPvZhF/SsckMeezumiQpJ2zdEHtFeOyYhj8bi
	 RDMbP3w16nvdjTFGLd9ZQi/qgdUg8lgYEXQzytEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Perry Yuan <Perry.Yuan@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2502/3318] cpufreq/amd-pstate: Export symbols for changing modes
Date: Wed, 18 Nov 2026 15:52:04 +0100
Message-ID: <20261118150436.442143331@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 8d916815b0afad2a12a9f1b945c79fffc144dba8 ]

In order to effectively test all mode switch combinations export
everything necessarily for amd-pstate-ut to trigger a mode switch.

Reviewed-by: Perry Yuan <Perry.Yuan@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Stable-dep-of: f6d3cbc63935 ("cpufreq: amd-pstate: Restore previous mode when changing driver mode fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 23 ++++++++++-------------
 drivers/cpufreq/amd-pstate.h | 14 ++++++++++++++
 2 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 803079b7e8193..475bb8575657d 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -59,18 +59,6 @@
 #define AMD_CPPC_EPP_BALANCE_POWERSAVE		0xBF
 #define AMD_CPPC_EPP_POWERSAVE			0xFF
 
-/*
- * enum amd_pstate_mode - driver working mode of amd pstate
- */
-enum amd_pstate_mode {
-	AMD_PSTATE_UNDEFINED = 0,
-	AMD_PSTATE_DISABLE,
-	AMD_PSTATE_PASSIVE,
-	AMD_PSTATE_ACTIVE,
-	AMD_PSTATE_GUIDED,
-	AMD_PSTATE_MAX,
-};
-
 static const char * const amd_pstate_mode_string[] = {
 	[AMD_PSTATE_UNDEFINED]   = "undefined",
 	[AMD_PSTATE_DISABLE]     = "disable",
@@ -80,6 +68,14 @@ static const char * const amd_pstate_mode_string[] = {
 	NULL,
 };
 
+const char *amd_pstate_get_mode_string(enum amd_pstate_mode mode)
+{
+	if (mode < 0 || mode >= AMD_PSTATE_MAX)
+		return NULL;
+	return amd_pstate_mode_string[mode];
+}
+EXPORT_SYMBOL_GPL(amd_pstate_get_mode_string);
+
 struct quirk_entry {
 	u32 nominal_freq;
 	u32 lowest_freq;
@@ -1272,7 +1268,7 @@ static ssize_t amd_pstate_show_status(char *buf)
 	return sysfs_emit(buf, "%s\n", amd_pstate_mode_string[cppc_state]);
 }
 
-static int amd_pstate_update_status(const char *buf, size_t size)
+int amd_pstate_update_status(const char *buf, size_t size)
 {
 	int cpu, mode_idx, ret = 0;
 
@@ -1304,6 +1300,7 @@ static int amd_pstate_update_status(const char *buf, size_t size)
 
 	return mode_state_machine[cppc_state][mode_idx](mode_idx);
 }
+EXPORT_SYMBOL_GPL(amd_pstate_update_status);
 
 static ssize_t status_show(struct device *dev,
 			   struct device_attribute *attr, char *buf)
diff --git a/drivers/cpufreq/amd-pstate.h b/drivers/cpufreq/amd-pstate.h
index bc341f35908d7..4911fccec4689 100644
--- a/drivers/cpufreq/amd-pstate.h
+++ b/drivers/cpufreq/amd-pstate.h
@@ -97,4 +97,18 @@ struct amd_cpudata {
 	bool	suspended;
 };
 
+/*
+ * enum amd_pstate_mode - driver working mode of amd pstate
+ */
+enum amd_pstate_mode {
+	AMD_PSTATE_UNDEFINED = 0,
+	AMD_PSTATE_DISABLE,
+	AMD_PSTATE_PASSIVE,
+	AMD_PSTATE_ACTIVE,
+	AMD_PSTATE_GUIDED,
+	AMD_PSTATE_MAX,
+};
+const char *amd_pstate_get_mode_string(enum amd_pstate_mode mode);
+int amd_pstate_update_status(const char *buf, size_t size);
+
 #endif /* _LINUX_AMD_PSTATE_H */
-- 
2.53.0



