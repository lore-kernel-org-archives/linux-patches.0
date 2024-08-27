Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0671873466;
	Tue, 27 Aug 2024 14:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769925; cv=none; b=lJARvjMtWGtsPv7WkM/EFNGfgOjMedoOBnrV9ySTAfCW41N1AIEDJubBpGkeaBKuDukGo5FnLZfVKVaaQLanjFot7bRAchjz/IrYbO/r4F+3C0CIixQ8MzFqOhv9tx0WXZpvzQJM+B9ROcqUZl6rdEw/djmjLVXy3dbXpUC1ETI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769925; c=relaxed/simple;
	bh=qGubkfkkw0Y0+y0IdUNVfesvjT9w8whqp9O9+mTEh1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tvAgdK2tZo2haKV8+lkrh9q/p5OiFU5s03U5SAfW/l6ozhG9MFMuWvmptHPeLJlh1ArOasbw55CyJokR3w2MAv+FtqlS6Eq/p29wqdTVekfPjnZwFYiwta83yVUiL2L5lRRc/pDtpu7cjQaM9JcxWAfkXYPUF0uovB1TpHvJac8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0lRljw5j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0lRljw5j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 676B1C61063;
	Tue, 27 Aug 2024 14:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769924;
	bh=qGubkfkkw0Y0+y0IdUNVfesvjT9w8whqp9O9+mTEh1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0lRljw5jlfkoJSwQdV2pKwmTXKe0dmMZ2S2QdoT9gW3MA8uVQoDdBWpBkhH/Cbd8j
	 CjBQWPoOj5Me73IOHRya0H93uOjNRuiRm2F1moFGAfZRFm021/8CL2X8zhk/8296mz
	 NppJGiBB9u6P7AnjiugtftDUJuZCbF7msfvjnLLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 076/341] selftests: net: lib: ignore possible errors
Date: Tue, 27 Aug 2024 16:35:07 +0200
Message-ID: <20240827143846.302731918@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

[ Upstream commit 7e0620bc6a5ec6b340a0be40054f294ca26c010f ]

No need to disable errexit temporary, simply ignore the only possible
and not handled error.

Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20240607-upstream-net-next-20240607-selftests-mptcp-net-lib-v1-1-e36986faac94@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 7965a7f32a53 ("selftests: net: lib: kill PIDs before del netns")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/lib.sh | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/tools/testing/selftests/net/lib.sh b/tools/testing/selftests/net/lib.sh
index a186490edb4ab..323a7c305ccd4 100644
--- a/tools/testing/selftests/net/lib.sh
+++ b/tools/testing/selftests/net/lib.sh
@@ -38,25 +38,17 @@ busywait()
 cleanup_ns()
 {
 	local ns=""
-	local errexit=0
 	local ret=0
 
-	# disable errexit temporary
-	if [[ $- =~ "e" ]]; then
-		errexit=1
-		set +e
-	fi
-
 	for ns in "$@"; do
 		[ -z "${ns}" ] && continue
-		ip netns delete "${ns}" &> /dev/null
+		ip netns delete "${ns}" &> /dev/null || true
 		if ! busywait $BUSYWAIT_TIMEOUT ip netns list \| grep -vq "^$ns$" &> /dev/null; then
 			echo "Warn: Failed to remove namespace $ns"
 			ret=1
 		fi
 	done
 
-	[ $errexit -eq 1 ] && set -e
 	return $ret
 }
 
-- 
2.43.0



