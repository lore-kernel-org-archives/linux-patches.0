Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88203346E46;
	Fri, 21 Nov 2025 13:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732289; cv=none; b=QxTPp2wSfSnYBiLS0jkWY0WDDIrNUBqZhX7kIlDFk8yLsuIEwLyVCqXraE3VTFP3vcwXeoUJ7B5rhOu12JlVQmB4PUlpp+dsS/hskN6jeeVJYm/DakejUmTejzhxZAQ47axMVjgmWrgbwEHrZEypMSJ5EtQ7sojZgJgX8H/8bew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732289; c=relaxed/simple;
	bh=Tdcci8Qa9uLZdnxJjcIIXQWGMznUKNbb1RfeM6qiXoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IKcooD2G98c0yZQg5STsUAnNCc2Sfl6uws4G6Z9MGtURlXC4UpgyZr/5fLvoLWnIsljH0JwWOiILw5lQ4DgdWJ9j2Hde/TbNSChWEd/mAqyuaDJKKqtzkFSN44CGuWGDbNRzeVN9NvDjaFCVOzuQN+R+/BfuvsR3oYU3gy5wARA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l3zVBzR/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l3zVBzR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3340C4CEF1;
	Fri, 21 Nov 2025 13:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732287;
	bh=Tdcci8Qa9uLZdnxJjcIIXQWGMznUKNbb1RfeM6qiXoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l3zVBzR/RlLejQExMKn1RiZRURZx3WPgGewC26MAr08eJVNS9QaNGTK6FRgEMTYAd
	 a8tXKQqJ2UuXLH66PL0NVw7xNgeDMgBRLsoZvCOoyOMsRkOWepOjiTrzTFqx7Mngi+
	 IxCABeKxveU4rhmUMul0dp+BnBQWoBZMk37hETiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?Ricardo=20B . =20Marli=C3=A8re?=" <rbm@suse.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 069/529] selftests/bpf: Upon failures, exit with code 1 in test_xsk.sh
Date: Fri, 21 Nov 2025 14:06:08 +0100
Message-ID: <20251121130233.481728126@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo B. Marlière <rbm@suse.com>

[ Upstream commit 2a912258c90e895363c0ffc0be8a47f112ab67b7 ]

Currently, even if some subtests fails, the end result will still yield
"ok 1 selftests: bpf: test_xsk.sh". Fix it by exiting with 1 if there are
any failures.

Signed-off-by: Ricardo B. Marlière <rbm@suse.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Link: https://lore.kernel.org/bpf/20250828-selftests-bpf-test_xsk_ret-v1-1-e6656c01f397@suse.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_xsk.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/selftests/bpf/test_xsk.sh
index 2aa5a3445056a..f4205823175a9 100755
--- a/tools/testing/selftests/bpf/test_xsk.sh
+++ b/tools/testing/selftests/bpf/test_xsk.sh
@@ -203,4 +203,6 @@ done
 
 if [ $failures -eq 0 ]; then
         echo "All tests successful!"
+else
+	exit 1
 fi
-- 
2.51.0



