Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7CB24A043;
	Tue, 11 Nov 2025 00:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822789; cv=none; b=PCCMxwRfoCi7t9fiv+MvaYuILnfocyvpS/a9ixUOhZqZbbjY+lQK5bOx25L5HVhK0Slj6b7kp/uKZIQWkujDm+j7CteXaNEnJxfWVLfkAdCae11WX3Snkr+gjDdTE09/Ku4vPkBcec3OKcCbZoMstVPU5ynHx8VD9Dt31Ad4seg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822789; c=relaxed/simple;
	bh=uYhPfNCnLB7IkyAxYJLaX7sVe8+6Cj03aPy89zlZ9P0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m2m+0IM1+gqBAfJHjQwR6LwnFgYPIQSZH0eXN8baRqF08HxHIcBzKaZzcHOd+bunAbaPXKBIpWezu7jhxzCdtgv9Y/4h8TmhH875qThIrCJ1up+gs7sfP3Zc0IsV7H+bFFHNTXpZ3rzZ6rZTnl4+CkR0Z01tHZycCcoZsCgYRlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aq22SdKG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aq22SdKG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B944C16AAE;
	Tue, 11 Nov 2025 00:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822788;
	bh=uYhPfNCnLB7IkyAxYJLaX7sVe8+6Cj03aPy89zlZ9P0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aq22SdKG0zoldTeEbCJrHYGYrAVoHUtd8JiYuyNzPbwCme/wYTaCpKWiQ9ffAYKVe
	 r9E7mArx9SieQUK9QvHnm9rIVNAiuOc3K/RsQJu6WMT1qocHrVQgUjXIHSXfZTJjZG
	 6gW6LRTVcF0AkUNmUZTv8pmyh/abnlQn3g0RitEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?Ricardo=20B . =20Marli=C3=A8re?=" <rbm@suse.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 109/565] selftests/bpf: Upon failures, exit with code 1 in test_xsk.sh
Date: Tue, 11 Nov 2025 09:39:25 +0900
Message-ID: <20251111004529.409039450@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 65aafe0003db0..62db060298a4a 100755
--- a/tools/testing/selftests/bpf/test_xsk.sh
+++ b/tools/testing/selftests/bpf/test_xsk.sh
@@ -241,4 +241,6 @@ done
 
 if [ $failures -eq 0 ]; then
         echo "All tests successful!"
+else
+	exit 1
 fi
-- 
2.51.0



