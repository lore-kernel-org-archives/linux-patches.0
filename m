Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA28BA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:07:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8F95C4339B;
	Tue,  7 Mar 2023 18:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212455;
	bh=YPgh0AhVMBwuvC1FB1jKznntH8Jwwl3qVXSAGKpY0Ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sHCVpyavwin8PLF2jpi5yZt2QSJGgy/SYCBGv4VerAy+OpJfo7C/uWdBzzSZ5b+PH
	 53zBGBvTCW39R2Hoh59e9MFID77KqP+EO0C9e0kZJEbkEJP7Zon1wqFFXzkc11EW8h
	 e9d13GuHjtNBAvX6Z/ywxnQfsiQ6UXG0J0TIKz/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 190/885] selftests/bpf: Initialize tc in xdp_synproxy
Date: Tue,  7 Mar 2023 17:52:04 +0100
Message-Id: <20230307170010.265890018@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit 354bb4a0e0b6be8f55bacbe7f08c94b4741f5658 ]

xdp_synproxy/xdp fails in CI with:

    Error: bpf_tc_hook_create: File exists

The XDP version of the test should not be calling bpf_tc_hook_create();
the reason it's happening anyway is that if we don't specify --tc on the
command line, tc variable remains uninitialized.

Fixes: 784d5dc0efc2 ("selftests/bpf: Add selftests for raw syncookie helpers in TC mode")
Reported-by: Alexei Starovoitov <ast@kernel.org>
Reported-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Link: https://lore.kernel.org/r/20230202235335.3403781-1-iii@linux.ibm.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/xdp_synproxy.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/xdp_synproxy.c b/tools/testing/selftests/bpf/xdp_synproxy.c
index 410a1385a01dd..6dbe0b7451985 100644
--- a/tools/testing/selftests/bpf/xdp_synproxy.c
+++ b/tools/testing/selftests/bpf/xdp_synproxy.c
@@ -116,6 +116,7 @@ static void parse_options(int argc, char *argv[], unsigned int *ifindex, __u32 *
 	*tcpipopts = 0;
 	*ports = NULL;
 	*single = false;
+	*tc = false;
 
 	while (true) {
 		int opt;
-- 
2.39.2



