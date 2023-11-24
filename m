Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D046333CFD;
	Fri, 24 Nov 2023 18:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mCYAtJRI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED3BC433CA;
	Fri, 24 Nov 2023 18:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850696;
	bh=pzXruHM4kwKPoNLxiTdkZx6rEx+xKGPe+LvtzgcjumE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mCYAtJRIySdh0vWolCqzTyxDV7M1k6BuhD5kaBZj3HjujPOm8XTSpzKFtBVxKlVii
	 ZEscGB0A/ry5NomYlaJ/CSOn7mnDALp76rLhHxqU8xJdKBNxbZkPO3eRw99eOk/JQ0
	 CN4U4qKA4SFdZZMJd/pxFt8lG0uY1uKiWKkTNQXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinghao Jia <jinghao@linux.ibm.com>,
	Ruowen Qin <ruowenq2@illinois.edu>,
	Jinghao Jia <jinghao7@illinois.edu>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 153/491] samples/bpf: syscall_tp_user: Rename num_progs into nr_tests
Date: Fri, 24 Nov 2023 17:46:29 +0000
Message-ID: <20231124172029.072637435@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinghao Jia <jinghao@linux.ibm.com>

[ Upstream commit 0ee352fe0d28015cab161b04d202fa3231c0ba3b ]

The variable name num_progs causes confusion because that variable
really controls the number of rounds the test should be executed.

Rename num_progs into nr_tests for the sake of clarity.

Signed-off-by: Jinghao Jia <jinghao@linux.ibm.com>
Signed-off-by: Ruowen Qin <ruowenq2@illinois.edu>
Signed-off-by: Jinghao Jia <jinghao7@illinois.edu>
Link: https://lore.kernel.org/r/20230917214220.637721-3-jinghao7@illinois.edu
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 9220c3ef6fef ("samples/bpf: syscall_tp_user: Fix array out-of-bound access")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/syscall_tp_user.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/samples/bpf/syscall_tp_user.c b/samples/bpf/syscall_tp_user.c
index 7a788bb837fc1..18c94c7e8a40e 100644
--- a/samples/bpf/syscall_tp_user.c
+++ b/samples/bpf/syscall_tp_user.c
@@ -17,9 +17,9 @@
 
 static void usage(const char *cmd)
 {
-	printf("USAGE: %s [-i num_progs] [-h]\n", cmd);
-	printf("       -i num_progs      # number of progs of the test\n");
-	printf("       -h                # help\n");
+	printf("USAGE: %s [-i nr_tests] [-h]\n", cmd);
+	printf("       -i nr_tests      # rounds of test to run\n");
+	printf("       -h               # help\n");
 }
 
 static void verify_map(int map_id)
@@ -45,14 +45,14 @@ static void verify_map(int map_id)
 	}
 }
 
-static int test(char *filename, int num_progs)
+static int test(char *filename, int nr_tests)
 {
-	int map0_fds[num_progs], map1_fds[num_progs], fd, i, j = 0;
-	struct bpf_link *links[num_progs * 4];
-	struct bpf_object *objs[num_progs];
+	int map0_fds[nr_tests], map1_fds[nr_tests], fd, i, j = 0;
+	struct bpf_link *links[nr_tests * 4];
+	struct bpf_object *objs[nr_tests];
 	struct bpf_program *prog;
 
-	for (i = 0; i < num_progs; i++) {
+	for (i = 0; i < nr_tests; i++) {
 		objs[i] = bpf_object__open_file(filename, NULL);
 		if (libbpf_get_error(objs[i])) {
 			fprintf(stderr, "opening BPF object file failed\n");
@@ -101,7 +101,7 @@ static int test(char *filename, int num_progs)
 	close(fd);
 
 	/* verify the map */
-	for (i = 0; i < num_progs; i++) {
+	for (i = 0; i < nr_tests; i++) {
 		verify_map(map0_fds[i]);
 		verify_map(map1_fds[i]);
 	}
@@ -117,13 +117,13 @@ static int test(char *filename, int num_progs)
 
 int main(int argc, char **argv)
 {
-	int opt, num_progs = 1;
+	int opt, nr_tests = 1;
 	char filename[256];
 
 	while ((opt = getopt(argc, argv, "i:h")) != -1) {
 		switch (opt) {
 		case 'i':
-			num_progs = atoi(optarg);
+			nr_tests = atoi(optarg);
 			break;
 		case 'h':
 		default:
@@ -134,5 +134,5 @@ int main(int argc, char **argv)
 
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
 
-	return test(filename, num_progs);
+	return test(filename, nr_tests);
 }
-- 
2.42.0



