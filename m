Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE272F0673;
	Sat, 12 Sep 2026 19:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240132; cv=none; b=SoE7VmjJ4E54RFYD48ux2ks5sk/6zwDjpYB2WPd3NHl2NCQbs2AdoXykqNQ9qhPSmzyAj9f8EJaaKFRMuDDx/kabAc4opL/NNACF7poEWmsD64TAo9JVtvWQ+tpm8BQry06siDCisoP2y+d1+yf1lpEZDzRCazs+LnkNzfAaXLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240132; c=relaxed/simple;
	bh=esRlj6N76ZIYJ8QaMc4YCECaVOV3U4pR5kn3vk46+OY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=de0VnKqitWGZK5ExxJhbH/Hn9ZVZvhDvmgV2uNtkC1DdpbfPZxg9glkhIvQH1YZvjDXZjnd3c7Cx0mUN0uOrHed3IFrAgRwVWK1pecOKbtJhwSznHYwQBE8GEu9XlSTw+t0lLxGT5ElYoODMegcJbsXZZHXPPgrZPJHkKm1MLT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YgdXAoYt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YgdXAoYt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA3A1F000FF;
	Sat, 12 Sep 2026 19:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240131;
	bh=119m7D+TvW0Tn8f5EA2nhqWFOvOC8PxO/2/YmcolQvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YgdXAoYtVctyFohZqPJJ4JvvT+u/8nrkmTCsJ3Z5t0DbwFSWi1mmR31VydmT5rSgx
	 FNi3pJmkB12INDbbOxUzVdxbaw1xoAQC/g3qu+fGPYg6qMyIlo0fUU8IiMSsvLm0jP
	 b2EN5I4ngnsajRfmab/uX9hbjxX32h+4IdIVkpv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	KP Singh <kpsingh@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 804/935] bpf/docs: Update list of architectures supported.
Date: Sat, 12 Sep 2026 09:03:54 +0200
Message-ID: <20260912065545.278488728@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: KP Singh <kpsingh@kernel.org>

[ Upstream commit e878ae2d1df5de4ea36e6d96c7d3ebe789aab9a5 ]

vmtest.sh also supports s390x now.

Signed-off-by: KP Singh <kpsingh@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20220307133048.1287644-2-kpsingh@kernel.org
Stable-dep-of: 3a59f11e0f98 ("selftests/bpf: vmtest.sh: Preserve command quoting when running in the VM")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/README.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/README.rst b/tools/testing/selftests/bpf/README.rst
index 9b17f2867488a..3ae7e282789b4 100644
--- a/tools/testing/selftests/bpf/README.rst
+++ b/tools/testing/selftests/bpf/README.rst
@@ -36,7 +36,7 @@ For more information on about using the script, run:
           If you want to change pahole and llvm, you can change `PATH` environment
           variable in the beginning of script.
 
-.. note:: The script currently only supports x86_64.
+.. note:: The script currently only supports x86_64 and s390x architectures.
 
 Additional information about selftest failures are
 documented here.
-- 
2.53.0



