Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033340;
	b=kXRcNI0loz0UVnBmkeqJwgjGTq6Y0cu9EmeMofYLiBTEp1jzOs+Ss7E77vv4GIzxETOP
	 6DtpMDTFuKsXWa7fXPy/ZZFDSl8OcoBAVT8jhH82PgLNRHyHd/apnT4eAnZDqc+MwY8se
	 KPYpS0+eVdF3W27jR9DKtU039wsJ2PePZDyRB7jpek7HNbcJqXP+yywkhQUAhYquK1Keq
	 rViOO9dn0XDFFmEXRyL/iQz/vCt14+kNwkQcCm5UUoLmSkiL6q+quKFH1N3ziJM4jZE4X
	 uVhb1FlpgKXfQ/7rjEZhyhHeM4gQaICs9pTuo25O2tLg0TGfgUyxRvipvadWVIsxmFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033340;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uzduErHouXE1Z+Y018bbvwR3I+DVyPLz2mbpExuIEcE=;
	b=5X+9dfqikzjMa+cIketl8CEueNTb+sek+lBDwyu8XlCIFTB74ILXsmHcSWnoCdfzf9yd
	 sy/MXWFsaU6zW7E4AcjROuG7kmeGmh4mGOGNZw2LlnTMC3dASDS8QW2pM/axnK5UdurWL
	 CNwEZNMdlUi6FBbnEncNAOza+1P1si3Qqm5BECtuEBwjVJ6UkhEed6SZ4WC94/3cHx5nu
	 zQi56tVhU2YMpbyXiLjKhU02PeEKcgTmfdkLARNgd353m1c8Sbb1vWDV4tdgblM6Gb1Y9
	 8a/RNuXE6bKFImgv9n88CxcujK2qJnelyX9lSoWI16p2BaCI+IEyJkCiaj/2kYz/NLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hmo1EtDf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DAC5606A31C;
	Wed, 18 Nov 2026 20:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hmo1EtDf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 960411F000C4;
	Wed, 18 Nov 2026 20:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033340;
	bh=uzduErHouXE1Z+Y018bbvwR3I+DVyPLz2mbpExuIEcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hmo1EtDfuMAbJbWwihOQT+KUeIzbr29d4fZ+x+2nsS5ojpn+MhchCRIzoPPXmBjic
	 OSSo1eaJ/D1OzhvP4fMoneg42xEdb0EfeWUc2AL+LAMEEjv5i2onxIja4VPidAqpj7
	 UkCype/Fwc2a348hoSxkYUBJFX0B10pEw5tlyRXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hemanth Selam <hemanth.selam@gmail.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.12 1732/1756] selftests/cgroup: set the test plan after the setup checks
Date: Wed, 18 Nov 2026 16:04:19 +0100
Message-ID: <20261118150118.523057792@linuxfoundation.org>
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

From: Hemanth Selam <hemanth.selam@gmail.com>

commit 0c893d170ff8efe7b4067552932d26e7defba307 upstream.

The cgroup tests announce their plan before checking whether cgroup v2 is
available, so on a host without it they promise a number of results and
then skip out after the first one:

	TAP version 13
	1..3
	ok 1 # SKIP cgroup v2 isn't mounted
	# Planned tests != run tests (3 != 1)
	# Totals: pass:0 fail:0 xfail:0 xpass:0 skip:1 error:0

ksft_exit_skip() can only emit a well formed "1..0 # SKIP" line while no
plan has been printed, as the comment above it in kselftest.h points out.

Move ksft_set_plan() below the setup checks that can skip, so that a
skipped run reports:

	TAP version 13
	1..0 # SKIP cgroup v2 isn't mounted

Several of the tests skip more than once while setting up, for a missing
or unwritable controller as well, so the plan goes after the last of
them.  test_core joins its two setup paths at the post_v2_setup label and
sets the plan there.

Reporting each planned test as skipped instead would keep the plan where
it is, but the setup failures here mean the whole test cannot run rather
than its individual cases being skipped, which is what "1..0 # SKIP" is
for.

Fixes: 1dc830ee4c15 ("selftests/cgroup: conform test to KTAP format output")
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/cgroup/test_core.c       |    2 +-
 tools/testing/selftests/cgroup/test_cpu.c        |    2 +-
 tools/testing/selftests/cgroup/test_cpuset.c     |    2 +-
 tools/testing/selftests/cgroup/test_freezer.c    |    2 +-
 tools/testing/selftests/cgroup/test_kill.c       |    2 +-
 tools/testing/selftests/cgroup/test_kmem.c       |    2 +-
 tools/testing/selftests/cgroup/test_memcontrol.c |    2 +-
 tools/testing/selftests/cgroup/test_pids.c       |    2 +-
 tools/testing/selftests/cgroup/test_zswap.c      |    2 +-
 9 files changed, 9 insertions(+), 9 deletions(-)

--- a/tools/testing/selftests/cgroup/test_core.c
+++ b/tools/testing/selftests/cgroup/test_core.c
@@ -902,7 +902,6 @@ int main(int argc, char *argv[])
 	int i;
 
 	ksft_print_header();
-	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), &nsdelegate)) {
 		if (setup_named_v1_root(root, sizeof(root), CG_NAMED_NAME))
 			ksft_exit_skip("cgroup v2 isn't mounted and could not setup named v1 hierarchy\n");
@@ -915,6 +914,7 @@ int main(int argc, char *argv[])
 			ksft_exit_skip("Failed to set memory controller\n");
 
 post_v2_setup:
+	ksft_set_plan(ARRAY_SIZE(tests));
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		switch (tests[i].fn(root)) {
 		case KSFT_PASS:
--- a/tools/testing/selftests/cgroup/test_cpu.c
+++ b/tools/testing/selftests/cgroup/test_cpu.c
@@ -701,7 +701,6 @@ int main(int argc, char *argv[])
 	int i;
 
 	ksft_print_header();
-	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
@@ -709,6 +708,7 @@ int main(int argc, char *argv[])
 		if (cg_write(root, "cgroup.subtree_control", "+cpu"))
 			ksft_exit_skip("Failed to set cpu controller\n");
 
+	ksft_set_plan(ARRAY_SIZE(tests));
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		switch (tests[i].fn(root)) {
 		case KSFT_PASS:
--- a/tools/testing/selftests/cgroup/test_cpuset.c
+++ b/tools/testing/selftests/cgroup/test_cpuset.c
@@ -250,7 +250,6 @@ int main(int argc, char *argv[])
 	int i;
 
 	ksft_print_header();
-	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
@@ -258,6 +257,7 @@ int main(int argc, char *argv[])
 		if (cg_write(root, "cgroup.subtree_control", "+cpuset"))
 			ksft_exit_skip("Failed to set cpuset controller\n");
 
+	ksft_set_plan(ARRAY_SIZE(tests));
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		switch (tests[i].fn(root)) {
 		case KSFT_PASS:
--- a/tools/testing/selftests/cgroup/test_freezer.c
+++ b/tools/testing/selftests/cgroup/test_freezer.c
@@ -828,9 +828,9 @@ int main(int argc, char *argv[])
 	int i;
 
 	ksft_print_header();
-	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
+	ksft_set_plan(ARRAY_SIZE(tests));
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		switch (tests[i].fn(root)) {
 		case KSFT_PASS:
--- a/tools/testing/selftests/cgroup/test_kill.c
+++ b/tools/testing/selftests/cgroup/test_kill.c
@@ -277,9 +277,9 @@ int main(int argc, char *argv[])
 	int i;
 
 	ksft_print_header();
-	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
+	ksft_set_plan(ARRAY_SIZE(tests));
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		switch (tests[i].fn(root)) {
 		case KSFT_PASS:
--- a/tools/testing/selftests/cgroup/test_kmem.c
+++ b/tools/testing/selftests/cgroup/test_kmem.c
@@ -421,7 +421,6 @@ int main(int argc, char **argv)
 	int i;
 
 	ksft_print_header();
-	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
@@ -436,6 +435,7 @@ int main(int argc, char **argv)
 		if (cg_write(root, "cgroup.subtree_control", "+memory"))
 			ksft_exit_skip("Failed to set memory controller\n");
 
+	ksft_set_plan(ARRAY_SIZE(tests));
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		switch (tests[i].fn(root)) {
 		case KSFT_PASS:
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -1652,7 +1652,6 @@ int main(int argc, char **argv)
 	int i, proc_status;
 
 	ksft_print_header();
-	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
@@ -1677,6 +1676,7 @@ int main(int argc, char **argv)
 		ksft_exit_skip("Failed to query cgroup mount option\n");
 	has_localevents = proc_status;
 
+	ksft_set_plan(ARRAY_SIZE(tests));
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		switch (tests[i].fn(root)) {
 		case KSFT_PASS:
--- a/tools/testing/selftests/cgroup/test_pids.c
+++ b/tools/testing/selftests/cgroup/test_pids.c
@@ -145,7 +145,6 @@ int main(int argc, char **argv)
 	char root[PATH_MAX];
 
 	ksft_print_header();
-	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
@@ -160,6 +159,7 @@ int main(int argc, char **argv)
 		if (cg_write(root, "cgroup.subtree_control", "+pids"))
 			ksft_exit_skip("Failed to set pids controller\n");
 
+	ksft_set_plan(ARRAY_SIZE(tests));
 	for (int i = 0; i < ARRAY_SIZE(tests); i++) {
 		switch (tests[i].fn(root)) {
 		case KSFT_PASS:
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -770,7 +770,6 @@ int main(int argc, char **argv)
 		page_size = BUF_SIZE;
 
 	ksft_print_header();
-	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
@@ -787,6 +786,7 @@ int main(int argc, char **argv)
 		if (cg_write(root, "cgroup.subtree_control", "+memory"))
 			ksft_exit_skip("Failed to set memory controller\n");
 
+	ksft_set_plan(ARRAY_SIZE(tests));
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		switch (tests[i].fn(root)) {
 		case KSFT_PASS:


