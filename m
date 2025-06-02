Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C792C327B;
	Mon,  2 Jun 2025 14:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873077; cv=none; b=kRtm72GNqzjzsnygaQQgXJArzDGuoj3U5zklh6M7U6AXNfN8mcPkCSt6zuLJ2wZR72hQ3C0uJYeWJYGSt6rCa4OfjzbsNITs5NLnL8heTQoAh/Oe8WJqLCUGzHxBIXRDiHwOyExWDDkjDZIX5L3hAcjcJQqPJmLM9TUMLpvgGU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873077; c=relaxed/simple;
	bh=LEqTaVnVm40C85FECZlcehZTuR66v9iB8qu8TATCBWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FvOquIDjolv0YsXoHoaTJKG/5MbzAbquRseoJvLcUelmne6OFoXavIEmRnVUKFK1RgpadnEUvSLQDV1P/L7frFBq0+gcUCxoEj5S8dQYAvfonISFq6kKHPkEQI5nLXHi2+Pzqm3yNv8XJTsjjBiWh0wKBP91Z3lsJtknEf9LIs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1nNGfuWy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1nNGfuWy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF1F0C4CEEB;
	Mon,  2 Jun 2025 14:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873077;
	bh=LEqTaVnVm40C85FECZlcehZTuR66v9iB8qu8TATCBWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1nNGfuWyTi2dW5ig757gwCGke4/mXTyb1KpeobsEEHM7QfYw38NxyLxuGx8F0QZfJ
	 eC6GTmUUQWsfF6+ZotEOHFZTgfNFampb/9Szy5VLQvLx4zhHJsd7xEjDuPJ3a9KYW2
	 hYDVVn6Uw6VoXQj6UOT9Jcl061ZT8K9+R7QLNkRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/444] selftests/bpf: Mitigate sockmap_ktls disconnect_after_delete failure
Date: Mon,  2 Jun 2025 15:41:34 +0200
Message-ID: <20250602134342.141478843@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



