Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015735;
	b=zwSWGO02IYt6zv24t3cbBCsGUKF4E7g7R//Y7KWeNsX+uv7v6WgCidvOPae32h6JTlfe
	 fY6VFmHoHewaGmE3gP6RN+rW7UNal0L4YZHC1bA3x/wIbPaIwPeSYZJsTjdvv+dLmwu8A
	 THP/i9IEN/+zdk+WpNfDRhuEdLMcVE5kF5CkQn6sfFQbBDlSO7MBT1qD537GOvAkvhfrb
	 Mm4jAWmXdejzeVM/jFrGDox/jOiKQOZQmenyacvCYL0CdcxAQYIgFAZv+ftU+9ZcqE4NY
	 TVcatBy51Cc+LIrPC2XpupalbmIN24dz2ahZ9nMj46costEL991V/uFmGp402+cCcNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015735;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gGxv3NsFX/YjN/hAKvAu2ojeLXU7IJAnAk/MCru51CE=;
	b=xTyvbvHOOMmSg110uyVZYAt/+2YvfIfZ93N6/LJBWU+3IC34ur0A0yqcL2xdPc4AYWL+
	 x8wRkv5gjpiLRqxRbDdGJXvvkqsXD/b7BHp7SxcIRC/n26c31q+Nef3Z2DahmBeTOs5vw
	 U7gvX6ogMDz6X1qXjvTGCGA2CbzDJhflS44k+PRHVqt7UQmiR7uFu4NwiPCxBsBxjb2qN
	 asFbZn3A9cnhy88B/eC73I0MFjmPNF9vpexGjE09fY8ATzcrEHOrEipB2TMQpcotaxdfB
	 r02JPcoubcsmcg3gKVNWZBfxXX2BJzexuF8FNVJ0LI3O8dYIojBpFTl7IoKUEiWAa+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=flu+IoUV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4884D606A33F;
	Wed, 18 Nov 2026 15:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=flu+IoUV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 998D91F000C4;
	Wed, 18 Nov 2026 15:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015735;
	bh=gGxv3NsFX/YjN/hAKvAu2ojeLXU7IJAnAk/MCru51CE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=flu+IoUVG6sq3G5XD88QUNyBqGnHpkcOqCNHI5d/Imc0QZanE5s6FnzC7BK+NxG5T
	 dydFNYHxVPjvM8t9wwR/mpPxNXPj06wKUcJyGPl7pDDcqIK6MkABYImu+FBCOwEx12
	 StbhiyzDNcRNOhCK0rvZM/nojUHGPp1ayx5AUKlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianyi Chen <hi@tychen.cc>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0278/2651] selftests/sched_ext: Handle CPU hotplug write failures
Date: Wed, 18 Nov 2026 15:25:18 +0100
Message-ID: <20261118150257.923842876@linuxfoundation.org>
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
index 0cfbb111a2d09..10b8d42bd89be 100644
--- a/tools/testing/selftests/sched_ext/hotplug.c
+++ b/tools/testing/selftests/sched_ext/hotplug.c
@@ -21,15 +21,17 @@ static bool is_cpu_online(void)
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
@@ -44,6 +46,7 @@ static enum scx_test_status test_hotplug(bool onlining, bool cbs_defined)
 {
 	struct hotplug *skel;
 	struct bpf_link *link;
+	enum scx_test_status status = SCX_TEST_FAIL;
 	long kind, code;
 
 	SCX_ASSERT(is_cpu_online());
@@ -54,8 +57,8 @@ static enum scx_test_status test_hotplug(bool onlining, bool cbs_defined)
 	SCX_FAIL_IF(hotplug__load(skel), "Failed to load skel");
 
 	/* Testing the offline -> online path, so go offline before starting */
-	if (onlining)
-		toggle_online_status(0);
+	if (onlining && toggle_online_status(0))
+		goto out_destroy_skel;
 
 	if (cbs_defined) {
 		kind = SCX_KIND_VAL(SCX_EXIT_UNREG_BPF);
@@ -79,7 +82,8 @@ static enum scx_test_status test_hotplug(bool onlining, bool cbs_defined)
 		return SCX_TEST_FAIL;
 	}
 
-	toggle_online_status(onlining ? 1 : 0);
+	if (toggle_online_status(onlining ? 1 : 0))
+		goto out_destroy_link;
 
 	while (!UEI_EXITED(skel, uei))
 		sched_yield();
@@ -87,20 +91,23 @@ static enum scx_test_status test_hotplug(bool onlining, bool cbs_defined)
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
@@ -115,10 +122,12 @@ static enum scx_test_status test_hotplug_attach(void)
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
@@ -130,7 +139,10 @@ static enum scx_test_status test_hotplug_attach(void)
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



