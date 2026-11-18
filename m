Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019152;
	b=mlWdMrW6SZ/XgeK5kcf53JNcm+BQyHTLgBQBho3QAzHiHXbTg1S3HqIS0NTTQlxHHys3
	 921YQ9DZdOK5c3Db7KYDiwVnkS1sn35X5rrAtTdZ+unbFijTunPxVitG09nhiVaby0lSX
	 W5lWrpJ3w7bV16FWdSv+kXNOfALNYsDpVDqyChpbX+C3pAoRx9JuEDamp1HxscZuH9mEM
	 6hCJNDs54HVTjAFvA2DQnytDdulnZrXvfAxkkNXqZmjRno8xy+G8BZmjo7OS+DEgoiQzS
	 n3GpyqOV2eizksmzz2heWDty/MxYbn+1U4VxkqqZ6ZxkBNZfxlpMtgUfVQIYmRj19kQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019152;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZOBymX/kr32GmNYAhjd3zh70jepLEayjeGTwXV5z/XM=;
	b=C6UvtnB58iC6CeeZr4vtNNx/fSVsKEgGG7Dh90fVDUfXSdqBN8WE28KCYu/A7pVWCRIU
	 HhdgoYL5Y5jItA2PDbHMXb0f6PDCOAf3eCkd3UTHhxFzAujaDFyR0Dz7zK6wjWDO5x1Gg
	 BtOSY79MZ0BwZa/hWxuBikSoyOfShfb2N7khtYoRIAEYUR5OFDsjPxvvX0wz3augVMdSB
	 M/TOim0vVuSwkkLsb9b4ioyKunxkoNH5mj47LGDUuuuOO0GO0Ps4IDZl3gge5LREDmyoE
	 px60o+lV/QmqtSK76OU478mN0JY+k/HafFkaOTKqEk4NI1k+nr8Y6DBXAUvxhqYEOpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2Z6L2Knn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7FB6606A31C;
	Wed, 18 Nov 2026 16:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2Z6L2Knn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B21FC1F000C4;
	Wed, 18 Nov 2026 16:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019152;
	bh=ZOBymX/kr32GmNYAhjd3zh70jepLEayjeGTwXV5z/XM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Z6L2Knn95A82BOPlw2+KM2WQ1OQDZ7eT9Av5UaqPI+ZvUxKdksT0ABHiWSkBrLLB
	 ZjmmCPObi8O+qzlpYOBD8SdBOM/Km4xMliI4bhkUSNmasG49Ngw73TOOfY8xVv0zP/
	 KxUMTIlrOE7QKVb3QA9TtimPuSxbN7N74inMFGlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ting-Han Hou <ue081723@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1495/2651] checkkconfigsymbols.py: Parse Git status output line by line
Date: Wed, 18 Nov 2026 15:45:35 +0100
Message-ID: <20261118150341.844671247@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ting-Han Hou <ue081723@gmail.com>

[ Upstream commit 72a61a7fef954152abd9df9def4f94816eb344ca ]

tree_is_dirty() iterates over the string returned by execute() one
character at a time. Its status check therefore examines filenames as
well as the two status columns.

An otherwise clean tree containing an untracked README is reported as
dirty because its name contains letters matched by [URMADC]. This
prevents --commit and --diff from running, whereas an untracked
notes.txt does not trigger the check.

Split the output into lines before examining the two status columns so
that filenames do not affect the dirty-tree check.

Fixes: b1a3f243485f ("checkkconfigsymbols.py: make it Git aware")
Assisted-by: LLM
Signed-off-by: Ting-Han Hou <ue081723@gmail.com>
Link: https://patch.msgid.link/CA+NtrhQqXgjT+4eg6W4P94Hc=DqdV3gQXz3EKKCxWvdWzfND6A@mail.gmail.com
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/checkkconfigsymbols.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/checkkconfigsymbols.py b/scripts/checkkconfigsymbols.py
index 36c920e713137..9f7aed98d91c0 100755
--- a/scripts/checkkconfigsymbols.py
+++ b/scripts/checkkconfigsymbols.py
@@ -245,7 +245,7 @@ def tree_is_dirty():
     """Return true if the current working tree is dirty (i.e., if any file has
     been added, deleted, modified, renamed or copied but not committed)."""
     stdout = execute(["git", "status", "--porcelain"])
-    for line in stdout:
+    for line in stdout.splitlines():
         if re.findall(r"[URMADC]{1}", line[:2]):
             return True
     return False
-- 
2.53.0



