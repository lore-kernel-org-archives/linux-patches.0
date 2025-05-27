Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCCE813A244;
	Tue, 27 May 2025 16:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364387; cv=none; b=ViYAbpEB8L6JY2Ye29Y9qgKoeoNiw3gbhVHZyFe6TWYXMXF2XisPxpu/LwMK7zkoN8nB7flPj3f4idSQVLipzOcBFo1XFjYDwP5pHJaaZNynp5yBiC9tDcGvNmFB6nzIjvBsxS95NMCPdh3/F/GAhnCfClVShgsS9Vrck3oql+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364387; c=relaxed/simple;
	bh=JbY/UeRUfwG/UaT/N98qCHaf2MzRF/y/d0pA60V6i7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ql1VQxdQvPyDpMBpGPtPV5IIZV7FB/pxL9KhdEay0cMoPoS3e3VdKgOgdf6MiVJH+hzzkyb8kCebDqtp9NDht4obpzYj2fIaPjPacvgM7V/K1JGL1pbB6eHoxP99PTlVPPtHFTFbdStN00qfzUMi5BBX6W6pgYjb7Bj6S3VT72k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gPYTLSMP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gPYTLSMP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1557DC4CEE9;
	Tue, 27 May 2025 16:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364386;
	bh=JbY/UeRUfwG/UaT/N98qCHaf2MzRF/y/d0pA60V6i7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gPYTLSMPS0wq+jqjASUaMs+i0qY+dBlJwww+V1pH6sT6SumOu2IOHDyjbsnBhwXOp
	 B/dMbcY19kPSaWbqCNMusgooqLSIc7MeBlitBxgywUMVAzUZHIYSl4TkD4ELR1b75j
	 wxkkymPG8ePVE7rmez81ERa6c44b4sKNUznfqiTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 039/626] selftests/bpf: Mitigate sockmap_ktls disconnect_after_delete failure
Date: Tue, 27 May 2025 18:18:52 +0200
Message-ID: <20250527162446.652302364@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ihor Solodrai <ihor.solodrai@linux.dev>

[ Upstream commit f2858f308131a09e33afb766cd70119b5b900569 ]

"sockmap_ktls disconnect_after_delete" test has been failing on BPF CI
after recent merges from netdev:
* https://github.com/kernel-patches/bpf/actions/runs/14458537639
* https://github.com/kernel-patches/bpf/actions/runs/14457178732

It happens because disconnect has been disabled for TLS [1], and it
renders the test case invalid.

Removing all the test code creates a conflict between bpf and
bpf-next, so for now only remove the offending assert [2].

The test will be removed later on bpf-next.

[1] https://lore.kernel.org/netdev/20250404180334.3224206-1-kuba@kernel.org/
[2] https://lore.kernel.org/bpf/cfc371285323e1a3f3b006bfcf74e6cf7ad65258@linux.dev/

Signed-off-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://lore.kernel.org/bpf/20250416170246.2438524-1-ihor.solodrai@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/sockmap_ktls.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_ktls.c b/tools/testing/selftests/bpf/prog_tests/sockmap_ktls.c
index 2d0796314862a..0a99fd404f6dc 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_ktls.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_ktls.c
@@ -68,7 +68,6 @@ static void test_sockmap_ktls_disconnect_after_delete(int family, int map)
 		goto close_cli;
 
 	err = disconnect(cli);
-	ASSERT_OK(err, "disconnect");
 
 close_cli:
 	close(cli);
-- 
2.39.5



