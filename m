Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061380;
	b=Zod6jNUKuAv8hEbkkGQRBFXrIP+Te5RQ0sv5a9+qeQRprrHLQcwWy2+EPd3i8b+1Gzoe
	 se7oAdbCPjeDWljnN7xsPqyxm1ip9vpYihP1SjUQhIgVRfM9ivMjRB8Ud+Om3KnBVGcyA
	 FcmbaM3pxDtxt5a7I+92K+bTwPSv2gKN2ZGze4/f221puTcXc9e87wVB5Mk+nR+MC6kuu
	 n/PsIolctRf9FwOGxKMV/SLMqIlJDMJGZzf8p/C9Pw1n+YKO4RYcrVqdongrwGLwwJXd5
	 rUKF6k+L9/4jJsbP50mhFInCbTJKSbZqGkkGFtVXrqzWs8cv8MtbK6D7z4ge8ir3vQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061380;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vObRGUjAWHom4ZEoAApH8zYMcIPTdhKzxShMouGnfpo=;
	b=GYsfywC+J+klBkpEvvYgTXs143RT8lyOFBdCLWS4ecpReTVJJ5a6j6mbl9RS5W4PFAh+
	 xgk82Vg7gCdYUz9xohUFAOQq21h6PDnIO2zhOYVEWlz5C+G95M7F7y4aDYcRXvkK9egxd
	 QtuKkcEmGqaZfUx1B/Ql04ZI9EqUeJtO2L8dpg/VxpxgOuWQxNfjdUR4hb5AYIsS2km/j
	 8XTbLcElSpfxriOuiwWrx9mdORTkpG5kn9Rbu/x/SNn+ZqnkV51Jv4/BWA3yfg1hJcvEI
	 2M78qjs0Tpfpvgr8TvyT9KbGSD6Bg1l+cYoMh3rI0DFd7FLcSHQpYGM4MbcvaoxO+0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qXaCFRrn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD11606A320;
	Thu, 19 Nov 2026 04:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qXaCFRrn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D097A1F000C4;
	Thu, 19 Nov 2026 04:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061380;
	bh=vObRGUjAWHom4ZEoAApH8zYMcIPTdhKzxShMouGnfpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qXaCFRrnvAxtKtz9o8vdQdAq5Nq6pxmSBWcofDAJU0PUSb2dPTu51h4tfYay4QlX4
	 qqFewkPzI/zyMm032gHl4ClZy1lIIMnbQQQmc4rm5uezJM6kntJ7ShCTXvvAv+srbJ
	 Hd1HVwdrhIZBVYWfdx13y7xmsN9x+OMbaq47WRgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ting-Han Hou <ue081723@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1532/1848] checkkconfigsymbols.py: Parse Git status output line by line
Date: Wed, 18 Nov 2026 15:59:30 +0100
Message-ID: <20261118150023.519047061@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 697972432bbe7..b85113117a740 100755
--- a/scripts/checkkconfigsymbols.py
+++ b/scripts/checkkconfigsymbols.py
@@ -243,7 +243,7 @@ def tree_is_dirty():
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



