Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050047;
	b=Jzod8XUI53mdDULHmAzdiYQqQghdMQ+GHDV4aXNWEA8qkmQ6QrJ5UbA2WtYfs17XnpgJ
	 QnzR1eiksiFBq0auteQH6J3XXCVEAPhSiyGaYxuo8HqFTv5pSYNtTrJdqZTKrpcziXTNY
	 ciwYA9Uhew/xK9M90d6CFy541ScqAUpJuWJqL5wKEh/G5bIKHR8hyyp3NxkSnN1/Z2v0g
	 jssX7BanXaW1ih4hOtHtr6uV8CsZOT/xuOPVD+/NtLs/dTt5HglArv1eCpK1/rgakEvRt
	 A5JPar3wOsqwPPZu6dTaeU4jcWUvMkk09ER6y/1qtDoSEYLPI72WDbqrdV1o/XxJkRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050047;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+u28Tw9QzxzF3TDEoX3McMLBkwng++eQuYPfDclYvrs=;
	b=V+5b0fy7d9PACfQp4bsmYUgzjhf+HQIVLB/kzEF+tQUV3kY96eoTPSFnnths1EyAcp9Q
	 J+CwfyVDCcivXfWKdLv14CskPb0qP9mg9LGrhpV0Sbg+y3t+YatXMKhPbA0KTZo7Ibrc5
	 EunQ53Vu8IS32QPmoM6xr1jDK1JXbp10hpeyNIjdPlEhZ2jtPtWdxquZndVK9fk1WcsdB
	 IDisWfqFFw1ePyqNjVEMVv3WoVagGXcFlBecop9mw2zreU9DWhOM9lDE7RVs9+R5uRlgI
	 7i+yfCmBo4DDn0Xo0RrUBiUAfHfkUqFSNJJPQcuWLEMm0TQcf/luZ/rCGqHjYEYqdTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cIP6T4tS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA5D606A32F;
	Thu, 19 Nov 2026 01:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cIP6T4tS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D66311F000C4;
	Thu, 19 Nov 2026 01:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050047;
	bh=+u28Tw9QzxzF3TDEoX3McMLBkwng++eQuYPfDclYvrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cIP6T4tS77kkGy/2nE5Qbd8rEAHneP7ux/2olOvav1GS4VgloBOynDfDSW9FDwhu4
	 aaWC5d2UGeYsFf4FHxEfwhiZ+IP7wM5pD9KLf46aoormKasmjTmRZRDVzaNOZFXmzL
	 MM1hWQTmd5nTm/acuzc6UzCkRQwixecIZDSUE/ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiliang Yuan <odys.yuan@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2568/2857] selftests/bpf: Keep the bpffs of cgroup_hierarchical_stats private
Date: Wed, 18 Nov 2026 16:00:02 +0100
Message-ID: <20261118150333.951787125@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiliang Yuan <odys.yuan@gmail.com>

[ Upstream commit 3c824dfd17e6e918e45a6a96bda0d020ddec8287 ]

setup_hierarchy() mounts a bpffs on /sys/fs/bpf with setup_bpffs(), and
then sets up the cgroups with setup_cgroups(), which moves the test into
a private mount namespace.

The bpffs thus lands in the mount namespace that test_progs shares with
the tests running in parallel, on top of the bpffs already there, and
hides what they pin. cleanup_bpffs() later runs in the private mount
namespace and can't unmount it, so it stays there for good.
bpftool_maps_access then fails to pin an iterator because
/sys/fs/bpf/test_bpftool_map doesn't exist anymore, and bpftool_metadata
can't find the program it pinned in /sys/fs/bpf/test_metadata.

Set up the cgroups first, so that the bpffs is mounted in the private
mount namespace.

Fixes: 88886309d2e8 ("selftests/bpf: add a selftest for cgroup hierarchical stats collection")
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261009-selftests-bpf-cgroup-stats-bpffs-v2-1-f93a111da992@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/prog_tests/cgroup_hierarchical_stats.c        | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c b/tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
index 3bd27d2ea668c..ad19d6d41918a 100644
--- a/tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
@@ -151,7 +151,7 @@ static void cleanup_cgroups(void)
 /* Sets up cgroup hiearchary, returns 0 on success. */
 static int setup_hierarchy(void)
 {
-	return setup_bpffs() || setup_cgroups();
+	return setup_cgroups() || setup_bpffs();
 }
 
 static void destroy_hierarchy(void)
-- 
2.53.0



