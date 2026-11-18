Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029207;
	b=n3FbW+CTADaDCALQthxdGEkv4T+Ynwp6IQIZ62mjSBqdzsGdlqpuog78QfTgORfQqlhl
	 QDav9AcCTOMOuhzx+I/eRhONJeKk7XG1e04hueWKvpgGBW44QrRn3Ws/ujBsFKxAHdzJ1
	 XK2pj3BZbAEwJzjSf+2O37Z6chmikGl1U9V/VRaHvuG79hz6lGKttR70wtgdoRLYMqiqp
	 DACiXXrS0EfwLSdXby9ULm1vjIeigB1kmpx71HnC3fo4zzE4CqQy9l6kXjm5JLt2yBAte
	 C4usluVap0owB9JDKsa7E2Dydrj/3iRTCOx2S10LV7dmiM0E2SgiDsMX8JRmRoSEjfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029207;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ey6PqHSeXiSry0r8Kj2S/4VE5MHmIUkp8iXcofq4YIQ=;
	b=y5Wo9yvdtoklZTcMfe6JO7uFEvdeqpS00mCfbuR6IHy0YDPFtiGlDIi7di/NkhoZstRK
	 48SnYVjly8XWYSIx7PDxZ/El2KAH1zHO1S9Fn13R/0skIUSgkdnlkdkfIIp+5r1TBa1x4
	 B6wiuwRM5Kg9oFdvon7uPd56dcqGqmHSuQ7O7MAhUx/jSczDtJ+1R2pzrT9kmj7TDjnuJ
	 tyLoJi7Ib24dEMBAM5KofVfXVCMUkw44XrICfdQC0iFNmV/3y4NdkeA3JP3w3YNSOVG/h
	 4VSi69+uKQW0OQks/o+jbRcVyAvcHISBiqp3tA74NYCpb+1yK6qFGMgF/u3AaCTlSig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wNcw05Tq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B85606A31C;
	Wed, 18 Nov 2026 19:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wNcw05Tq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AE151F000C4;
	Wed, 18 Nov 2026 19:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029206;
	bh=ey6PqHSeXiSry0r8Kj2S/4VE5MHmIUkp8iXcofq4YIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wNcw05TqnRGobhhBsYT1Aaq30pCWG+ez1dQ4Wy3J7/5JdJeFDf4nTIl/XmUDcC+F2
	 lrmGZk7zWW29huYi3nAWtO+XxrsviNviiI9cRHPo4vLTszMVNdkg3VrFcM/rOs0CiI
	 aVjaISztwk7NjsNmQKU1YPBrYbt37d+7lePpQvIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianyi Chen <hi@tychen.cc>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0265/1756] selftests/sched_ext: Handle CPU hotplug write failures
Date: Wed, 18 Nov 2026 15:39:52 +0100
Message-ID: <20261118150018.903175649@linuxfoundation.org>
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

From: Tianyi Chen <hi@tychen.cc>

[ Upstream commit 49c64ffb2fd996af4c82007196c61e17d74cb1ab ]

toggle_online_status() logs failed CPU state changes but discards the
write result. The hotplug tests can consequently wait indefinitely for
a scheduler exit that the failed operation never triggered.

Return the write result and stop both hotplug tests when a required
CPU state change fails. Release the acquired scheduler resources on
these paths and let the existing cleanup callback retry restoring
CPU1. Also fail the test when its normal CPU restoration fails.

Tested in a two-vCPU VM running a kernel built from the same source
as the selftests. Injecting EIO with strace into each of the ten CPU
state writes makes the fixed test return 1, with CPU1 online and
sched_ext disabled after cleanup. The original test does not finish
within three seconds when either of the first two writes fails.
Normal hotplug tests pass before and after the change. Making the
online file read-only also produces a failure without hanging.

Fixes: a5db7817af78 ("sched_ext: Add selftests")
Assisted-by: LLM
Signed-off-by: Tianyi Chen <hi@tychen.cc>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/sched_ext/hotplug.c | 34 ++++++++++++++-------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/sched_ext/hotplug.c b/tools/testing/selftests/sched_ext/hotplug.c
index 87bf220b1bcee..461604e8cf5ea 100644
--- a/tools/testing/selftests/sched_ext/hotplug.c
+++ b/tools/testing/selftests/sched_ext/hotplug.c
@@ -22,15 +22,17 @@ static bool is_cpu_online(void)
 	return file_read_long(online_path) > 0;
 }
 
-static void toggle_online_status(bool online)
+static int toggle_online_status(bool online)
 {
 	long val = online ? 1 : 0;
 	int ret;
 
 	ret = file_write_long(online_path, val);
 	if (ret != 0)
-		fprintf(stderr, "Failed to bring CPU %s (%s)",
+		fprintf(stderr, "Failed to bring CPU %s (%s)\n",
 			online ? "online" : "offline", strerror(errno));
+
+	return ret;
 }
 
 static enum scx_test_status setup(void **ctx)
@@ -45,6 +47,7 @@ static enum scx_test_status test_hotplug(bool onlining, bool cbs_defined)
 {
 	struct hotplug *skel;
 	struct bpf_link *link;
+	enum scx_test_status status = SCX_TEST_FAIL;
 	long kind, code;
 
 	SCX_ASSERT(is_cpu_online());
@@ -53,8 +56,8 @@ static enum scx_test_status test_hotplug(bool onlining, bool cbs_defined)
 	SCX_ASSERT(skel);
 
 	/* Testing the offline -> online path, so go offline before starting */
-	if (onlining)
-		toggle_online_status(0);
+	if (onlining && toggle_online_status(0))
+		goto out_destroy_skel;
 
 	if (cbs_defined) {
 		kind = SCX_KIND_VAL(SCX_EXIT_UNREG_BPF);
@@ -78,7 +81,8 @@ static enum scx_test_status test_hotplug(bool onlining, bool cbs_defined)
 		return SCX_TEST_FAIL;
 	}
 
-	toggle_online_status(onlining ? 1 : 0);
+	if (toggle_online_status(onlining ? 1 : 0))
+		goto out_destroy_link;
 
 	while (!UEI_EXITED(skel, uei))
 		sched_yield();
@@ -86,20 +90,23 @@ static enum scx_test_status test_hotplug(bool onlining, bool cbs_defined)
 	SCX_EQ(skel->data->uei.kind, kind);
 	SCX_EQ(UEI_REPORT(skel, uei), code);
 
-	if (!onlining)
-		toggle_online_status(1);
+	if (!onlining && toggle_online_status(1))
+		goto out_destroy_link;
 
+	status = SCX_TEST_PASS;
+out_destroy_link:
 	bpf_link__destroy(link);
+out_destroy_skel:
 	hotplug__destroy(skel);
 
-	return SCX_TEST_PASS;
+	return status;
 }
 
 static enum scx_test_status test_hotplug_attach(void)
 {
 	struct hotplug *skel;
 	struct bpf_link *link;
-	enum scx_test_status status = SCX_TEST_PASS;
+	enum scx_test_status status = SCX_TEST_FAIL;
 	long kind, code;
 
 	SCX_ASSERT(is_cpu_online());
@@ -114,10 +121,12 @@ static enum scx_test_status test_hotplug_attach(void)
 	 * Take the CPU offline to increment the global hotplug seq, which
 	 * should cause attach to fail due to us setting the hotplug seq above
 	 */
-	toggle_online_status(0);
+	if (toggle_online_status(0))
+		goto out_destroy_skel;
 	link = bpf_map__attach_struct_ops(skel->maps.hotplug_nocb_ops);
 
-	toggle_online_status(1);
+	if (toggle_online_status(1))
+		goto out_destroy_link;
 
 	SCX_ASSERT(link);
 	while (!UEI_EXITED(skel, uei))
@@ -129,7 +138,10 @@ static enum scx_test_status test_hotplug_attach(void)
 	SCX_EQ(skel->data->uei.kind, kind);
 	SCX_EQ(UEI_REPORT(skel, uei), code);
 
+	status = SCX_TEST_PASS;
+out_destroy_link:
 	bpf_link__destroy(link);
+out_destroy_skel:
 	hotplug__destroy(skel);
 
 	return status;
-- 
2.53.0



